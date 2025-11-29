import { createClient } from '@supabase/supabase-js'
import type { VercelRequest, VercelResponse } from '@vercel/node'

export const config = {
  maxDuration: 10,
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const startTime = Date.now()

  try {
    console.log('[1] Handler started')

    // Check environment variables
    const hasUrl = !!process.env.SUPABASE_URL
    const hasKey = !!process.env.SUPABASE_SERVICE_ROLE_KEY

    console.log('[2] Environment check:', { hasUrl, hasKey })

    if (!hasUrl || !hasKey) {
      return res.status(500).json({
        error: 'Missing environment variables',
        hasUrl,
        hasKey
      })
    }

    if (req.method !== 'GET') {
      return res.status(405).json({ error: 'Method not allowed' })
    }

    console.log('[3] Creating Supabase client...')
    const supabase = createClient(
      process.env.SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY!,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )
    console.log('[4] Supabase client created')

    // Get token from Authorization header or cookie
    const authHeader = req.headers.authorization
    let token = authHeader?.replace('Bearer ', '')

    if (!token) {
      const cookies = req.headers.cookie || ''
      const tokenMatch = cookies.match(/sb-access-token=([^;]+)/)
      token = tokenMatch?.[1]
    }

    if (!token) {
      console.log('[5] No token provided')
      return res.status(401).json({ error: 'Not authenticated' })
    }

    console.log('[6] Verifying token...')
    const { data: { user }, error } = await supabase.auth.getUser(token)

    if (error || !user) {
      console.log('[7] Token verification failed:', error?.message)
      return res.status(401).json({ error: 'Invalid token' })
    }

    console.log('[8] Token verified for user:', user.email)
    console.log('[9] Fetching user profile from database...')

    const { data: usuario, error: dbError } = await supabase
      .from('usuarios')
      .select('*')
      .or(`auth_user_id.eq.${user.id},email.eq.${user.email}`)
      .eq('is_active', true)
      .maybeSingle()

    if (dbError) {
      console.log('[10] Database error:', dbError.message)
      return res.status(500).json({
        error: 'Database error',
        message: dbError.message
      })
    }

    if (!usuario) {
      console.log('[11] User not found in database for email:', user.email)
      return res.status(401).json({ error: 'User not found in database' })
    }

    // Update auth_user_id if not set
    if (!usuario.auth_user_id) {
      console.log('[12] Linking auth user to profile...')
      await supabase
        .from('usuarios')
        .update({ auth_user_id: user.id })
        .eq('id', usuario.id)
    }

    const duration = Date.now() - startTime
    console.log('[13] Success! User:', usuario.email, 'Duration:', duration, 'ms')

    return res.status(200).json(usuario)
  } catch (error: any) {
    const duration = Date.now() - startTime
    console.error('[ERROR] Handler failed after', duration, 'ms:', error.message)
    console.error('[ERROR] Stack:', error.stack)

    return res.status(500).json({
      error: error.message || 'Internal Server Error',
      duration: duration + 'ms'
    })
  }
}