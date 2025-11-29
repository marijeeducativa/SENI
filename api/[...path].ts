import type { VercelRequest, VercelResponse } from '@vercel/node'

export const config = {
    maxDuration: 30,
}

// Cloudflare Worker URL - Update this with your actual worker URL
const WORKER_URL = process.env.WORKER_URL || 'https://seni-api.marijeeducativa.workers.dev'

export default async function handler(req: VercelRequest, res: VercelResponse) {
    try {
        // Get the path after /api/
        const path = req.url?.replace('/api/', '') || ''
        const targetUrl = `${WORKER_URL}/api/${path}`

        console.log('[Proxy] Forwarding request to:', targetUrl)

        // Forward the request to Cloudflare Worker
        const response = await fetch(targetUrl, {
            method: req.method,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': req.headers.authorization || '',
                'Cookie': req.headers.cookie || '',
            },
            body: req.method !== 'GET' && req.method !== 'HEAD'
                ? JSON.stringify(req.body)
                : undefined,
        })

        const data = await response.json()

        console.log('[Proxy] Response status:', response.status)

        return res.status(response.status).json(data)
    } catch (error: any) {
        console.error('[Proxy] Error:', error.message)
        return res.status(500).json({
            error: 'Proxy error',
            message: error.message
        })
    }
}
