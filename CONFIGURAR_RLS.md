# 🔐 Configurar Políticas RLS en Supabase

## ⚠️ Problema Actual

El error `Unexpected token '<', "<html lang"... is not valid JSON` significa que Supabase tiene **Row Level Security (RLS)** habilitado pero **no hay políticas configuradas** para permitir el acceso a las tablas.

## ✅ Solución: Ejecutar Script SQL

### Paso 1: Ir al SQL Editor de Supabase

1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto
3. En el menú lateral, click en **SQL Editor** (ícono de base de datos)

### Paso 2: Ejecutar el Script

1. Click en **New Query** (botón verde arriba a la derecha)
2. Abre el archivo `supabase/rls-policies.sql` de este proyecto
3. **Copia TODO el contenido** del archivo
4. **Pega** en el editor SQL de Supabase
5. Click en **Run** (o presiona Ctrl+Enter)

### Paso 3: Verificar

Deberías ver un mensaje de éxito. Si ves algún error que diga "policy already exists", está bien - significa que algunas políticas ya estaban creadas.

### Paso 4: Probar la Aplicación

1. Ve a https://seni-nine.vercel.app/
2. Haz login
3. Ve a **Cursos** - Deberías ver la lista de cursos ✅
4. Ve a **Estudiantes** - Deberías ver la lista de estudiantes ✅
5. Ve a **Indicadores** - Deberías ver la lista de indicadores ✅

## 📋 ¿Qué Hacen Estas Políticas?

Las políticas RLS configuran quién puede hacer qué con cada tabla:

- **Lectura (SELECT)**: Todos los usuarios autenticados pueden ver los datos
- **Crear (INSERT)**: Solo administradores pueden crear registros
- **Actualizar (UPDATE)**: Solo administradores pueden actualizar registros
- **Eliminar (DELETE)**: Solo administradores pueden eliminar registros

**Excepciones:**
- **Evaluaciones y Observaciones**: Todos los usuarios autenticados (maestros y administradores) pueden crear y actualizar

## 🆘 Si Hay Errores

Si al ejecutar el script ves errores, comparte el mensaje de error completo y te ayudaré a solucionarlo.

### Error Común: "policy already exists"

Si ves este error, significa que algunas políticas ya existen. Puedes:

**Opción A:** Ignorar el error - Las políticas que no existen se crearán

**Opción B:** Eliminar políticas existentes primero:

```sql
-- Ejecuta esto ANTES del script principal si quieres empezar de cero
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver usuarios" ON usuarios;
DROP POLICY IF EXISTS "Usuarios autenticados pueden ver cursos" ON cursos;
DROP POLICY IF EXISTS "Administradores pueden crear cursos" ON cursos;
-- ... etc para cada política
```

## 🎯 Resultado Esperado

Después de ejecutar el script, tu aplicación debería funcionar completamente:
- ✅ Ver listas de usuarios, cursos, estudiantes, indicadores
- ✅ Crear nuevos registros (solo administradores)
- ✅ Editar registros existentes (solo administradores)
- ✅ Eliminar registros (solo administradores)
- ✅ Maestros pueden crear evaluaciones y observaciones
