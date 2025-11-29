-- ============================================
-- POLÍTICAS RLS PARA SENI
-- Ejecuta este script en Supabase SQL Editor
-- ============================================

-- USUARIOS: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver usuarios"
ON usuarios FOR SELECT
TO authenticated
USING (true);

-- CURSOS: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver cursos"
ON cursos FOR SELECT
TO authenticated
USING (true);

-- CURSOS: Permitir insertar a administradores
CREATE POLICY "Administradores pueden crear cursos"
ON cursos FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- CURSOS: Permitir actualizar a administradores
CREATE POLICY "Administradores pueden actualizar cursos"
ON cursos FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- CURSOS: Permitir eliminar a administradores
CREATE POLICY "Administradores pueden eliminar cursos"
ON cursos FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- ESTUDIANTES: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver estudiantes"
ON estudiantes FOR SELECT
TO authenticated
USING (true);

-- ESTUDIANTES: Permitir insertar a administradores
CREATE POLICY "Administradores pueden crear estudiantes"
ON estudiantes FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- ESTUDIANTES: Permitir actualizar a administradores
CREATE POLICY "Administradores pueden actualizar estudiantes"
ON estudiantes FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- ESTUDIANTES: Permitir eliminar a administradores
CREATE POLICY "Administradores pueden eliminar estudiantes"
ON estudiantes FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- INDICADORES: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver indicadores"
ON indicadores FOR SELECT
TO authenticated
USING (true);

-- INDICADORES: Permitir insertar a administradores
CREATE POLICY "Administradores pueden crear indicadores"
ON indicadores FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- INDICADORES: Permitir actualizar a administradores
CREATE POLICY "Administradores pueden actualizar indicadores"
ON indicadores FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- INDICADORES: Permitir eliminar a administradores
CREATE POLICY "Administradores pueden eliminar indicadores"
ON indicadores FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- CATEGORIAS INDICADORES: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver categorias"
ON categorias_indicadores FOR SELECT
TO authenticated
USING (true);

-- CATEGORIAS INDICADORES: Permitir insertar a administradores
CREATE POLICY "Administradores pueden crear categorias"
ON categorias_indicadores FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- ESTUDIANTES_CURSOS: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver estudiantes_cursos"
ON estudiantes_cursos FOR SELECT
TO authenticated
USING (true);

-- ESTUDIANTES_CURSOS: Permitir insertar a administradores
CREATE POLICY "Administradores pueden crear estudiantes_cursos"
ON estudiantes_cursos FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- ESTUDIANTES_CURSOS: Permitir eliminar a administradores
CREATE POLICY "Administradores pueden eliminar estudiantes_cursos"
ON estudiantes_cursos FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.rol = 'administrador'
    AND usuarios.is_active = true
  )
);

-- EVALUACIONES: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver evaluaciones"
ON evaluaciones FOR SELECT
TO authenticated
USING (true);

-- EVALUACIONES: Permitir insertar a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden crear evaluaciones"
ON evaluaciones FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.is_active = true
  )
);

-- EVALUACIONES: Permitir actualizar a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden actualizar evaluaciones"
ON evaluaciones FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.is_active = true
  )
);

-- OBSERVACIONES: Permitir lectura a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver observaciones"
ON observaciones FOR SELECT
TO authenticated
USING (true);

-- OBSERVACIONES: Permitir insertar a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden crear observaciones"
ON observaciones FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.is_active = true
  )
);

-- OBSERVACIONES: Permitir actualizar a usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden actualizar observaciones"
ON observaciones FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE usuarios.auth_user_id = auth.uid()
    AND usuarios.is_active = true
  )
);
