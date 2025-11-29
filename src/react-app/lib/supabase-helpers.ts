import { supabase } from '../supabase'

// Helper to get current authenticated user from Supabase
export async function getCurrentUser() {
    const { data: { session } } = await supabase.auth.getSession()

    if (!session) {
        return null
    }

    const { data: usuario } = await supabase
        .from('usuarios')
        .select('*')
        .or(`auth_user_id.eq.${session.user.id},email.eq.${session.user.email}`)
        .eq('is_active', true)
        .maybeSingle()

    // Link auth user if not linked
    if (usuario && !usuario.auth_user_id) {
        await supabase
            .from('usuarios')
            .update({ auth_user_id: session.user.id })
            .eq('id', usuario.id)
    }

    return usuario
}

// Helper to check if user is admin
export async function isAdmin() {
    const user = await getCurrentUser()
    return user?.rol === 'administrador'
}

// Helper to get all usuarios (admin only)
export async function getUsuarios() {
    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .order('apellido', { ascending: true })
        .order('nombre', { ascending: true })

    if (error) throw error
    return data
}

// Helper to get all cursos
export async function getCursos() {
    const { data, error } = await supabase
        .from('cursos')
        .select('*, usuarios(nombre, apellido)')
        .eq('is_active', true)
        .order('nombre_curso')
        .order('seccion')

    if (error) throw error

    return data.map((curso: any) => ({
        ...curso,
        maestro_nombre: curso.usuarios ? `${curso.usuarios.nombre} ${curso.usuarios.apellido}` : null
    }))
}

// Helper to get all estudiantes
export async function getEstudiantes() {
    const { data: estudiantes, error } = await supabase
        .from('estudiantes')
        .select('*')
        .eq('is_active', true)
        .order('nombre')
        .order('apellido')

    if (error) throw error

    // Fetch courses
    const { data: cursos } = await supabase
        .from('cursos')
        .select('id, nombre_curso, seccion')

    const cursosMap = new Map(cursos?.map((c: any) => [c.id, c]) || [])

    return estudiantes.map((e: any) => {
        const curso: any = e.id_curso_actual ? cursosMap.get(e.id_curso_actual) : null
        return {
            ...e,
            curso_nombre: curso?.nombre_curso,
            curso_seccion: curso?.seccion
        }
    })
}

// Helper to get all indicadores
export async function getIndicadores(curso?: string, categoria?: string) {
    let query = supabase
        .from('indicadores')
        .select('*, categorias_indicadores(nombre_categoria)')
        .eq('is_active', true)

    if (curso) {
        query = query.ilike('niveles_aplicables', `%${curso}%`)
    }
    if (categoria) {
        query = query.eq('id_categoria', categoria)
    }

    query = query.order('orden').order('id')

    const { data, error } = await query

    if (error) throw error

    return data.map((i: any) => ({
        ...i,
        nombre_categoria: i.categorias_indicadores?.nombre_categoria
    }))
}

// Helper to get categorias
export async function getCategorias() {
    const { data, error } = await supabase
        .from('categorias_indicadores')
        .select('*')
        .order('created_at')

    if (error) throw error
    return data
}

// Helper to get stats
export async function getStats() {
    const [usuarios, estudiantes, cursos, evaluaciones] = await Promise.all([
        supabase.from('usuarios').select('*', { count: 'exact', head: true }).eq('is_active', true),
        supabase.from('estudiantes').select('*', { count: 'exact', head: true }).eq('is_active', true),
        supabase.from('cursos').select('*', { count: 'exact', head: true }).eq('is_active', true),
        supabase.from('evaluaciones').select('*', { count: 'exact', head: true })
    ])

    return {
        usuarios: usuarios.count || 0,
        estudiantes: estudiantes.count || 0,
        cursos: cursos.count || 0,
        evaluaciones: evaluaciones.count || 0
    }
}
