-- ============================================
-- SCRIPT DE DIAGNÓSTICO PARA ESTUDIANTES
-- Ejecuta este script en Supabase SQL Editor
-- ============================================

-- 1. Verificar cuántos estudiantes hay en total
SELECT 
    'Total Estudiantes' as descripcion,
    COUNT(*) as cantidad
FROM estudiantes;

-- 2. Verificar estudiantes activos
SELECT 
    'Estudiantes Activos' as descripcion,
    COUNT(*) as cantidad
FROM estudiantes
WHERE is_active = true;

-- 3. Ver algunos estudiantes de ejemplo
SELECT 
    id,
    nombre,
    apellido,
    id_curso_actual,
    is_active,
    created_at
FROM estudiantes
ORDER BY created_at DESC
LIMIT 10;

-- 4. Verificar si RLS está habilitado en la tabla estudiantes
SELECT 
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
AND tablename = 'estudiantes';

-- 5. Ver las políticas RLS activas para estudiantes
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'estudiantes';

-- 6. Verificar cursos asociados a estudiantes
SELECT 
    c.id,
    c.nombre_curso,
    c.seccion,
    COUNT(e.id) as num_estudiantes
FROM cursos c
LEFT JOIN estudiantes e ON e.id_curso_actual = c.id AND e.is_active = true
WHERE c.is_active = true
GROUP BY c.id, c.nombre_curso, c.seccion
ORDER BY c.nombre_curso, c.seccion;

-- 7. Verificar si hay usuarios autenticados
SELECT 
    'Total Usuarios Activos' as descripcion,
    COUNT(*) as cantidad
FROM usuarios
WHERE is_active = true;
