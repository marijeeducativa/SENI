# 🔧 SOLUCIÓN: Estudiantes No Se Visualizan en Vercel

## 🎯 Problema
Los estudiantes no se cargan en la versión desplegada en Vercel (https://seni-nine.vercel.app), pero funcionan correctamente en local.

## 🔍 Causa Más Probable
Las **variables de entorno de Supabase NO están configuradas en Vercel**, por lo que la aplicación no puede conectarse a la base de datos.

---

## ✅ SOLUCIÓN PASO A PASO

### Paso 1: Verificar Variables de Entorno en Vercel

1. Ve a: https://vercel.com/dashboard
2. Selecciona tu proyecto **seni-nine**
3. Ve a **Settings** → **Environment Variables**
4. Verifica que existan estas 4 variables:

| Variable | Descripción |
|----------|-------------|
| `VITE_SUPABASE_URL` | URL de tu proyecto Supabase |
| `VITE_SUPABASE_ANON_KEY` | Clave pública anon de Supabase |
| `SUPABASE_URL` | Misma URL (para el backend) |
| `SUPABASE_SERVICE_ROLE_KEY` | Clave service_role (SECRETA) |

### Paso 2: Obtener las Claves de Supabase

1. Ve a: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **Settings** → **API**
4. Copia:
   - **Project URL** → para `VITE_SUPABASE_URL` y `SUPABASE_URL`
   - **anon public** → para `VITE_SUPABASE_ANON_KEY`
   - **service_role** → para `SUPABASE_SERVICE_ROLE_KEY` ⚠️ (SECRETO)

### Paso 3: Agregar Variables en Vercel

Para cada variable:

1. Click en **Add New**
2. Nombre: `VITE_SUPABASE_URL`
3. Valor: `https://tu-proyecto.supabase.co`
4. **IMPORTANTE**: Marca las 3 opciones:
   - ✅ Production
   - ✅ Preview
   - ✅ Development
5. Click **Save**

Repite para las 4 variables.

### Paso 4: Re-desplegar la Aplicación

Después de agregar las variables:

**Opción A - Forzar Re-deploy:**
1. Ve a **Deployments**
2. Click en el último deployment
3. Click en **⋯** (tres puntos)
4. Click en **Redeploy**
5. **IMPORTANTE**: Desmarca "Use existing Build Cache"
6. Click **Redeploy**

**Opción B - Push a GitHub:**
```bash
git commit --allow-empty -m "Trigger Vercel redeploy"
git push
```

### Paso 5: Verificar el Deployment

1. Espera 1-2 minutos a que termine el deployment
2. Ve a https://seni-nine.vercel.app/login
3. Inicia sesión
4. Ve a la página de Estudiantes
5. ✅ Los estudiantes deberían aparecer ahora

---

## 🔍 DIAGNÓSTICO ADICIONAL

Si después de configurar las variables los estudiantes aún no aparecen:

### 1. Verificar Logs de Vercel

1. Ve a **Deployments** → [último deployment]
2. Click en **Functions**
3. Busca errores en los logs de las funciones API

### 2. Verificar en el Navegador

1. Abre DevTools (F12) en https://seni-nine.vercel.app
2. Ve a la pestaña **Console**
3. Ve a la pestaña **Network**
4. Intenta cargar la página de estudiantes
5. Busca la llamada a `/api/estudiantes` o similar
6. Verifica si hay errores 401, 403, o 500

### 3. Verificar Datos en Supabase

Ejecuta el script `supabase/debug-estudiantes.sql` en Supabase SQL Editor para verificar:
- ✅ Que hay estudiantes en la base de datos
- ✅ Que RLS está configurado correctamente
- ✅ Que las políticas permiten lectura a usuarios autenticados

### 4. Verificar Políticas RLS

Si las políticas RLS están bloqueando el acceso:

1. Ve a Supabase → **Authentication** → **Policies**
2. Verifica que la tabla `estudiantes` tenga la política:
   - **"Usuarios autenticados pueden ver estudiantes"**
   - Comando: `SELECT`
   - Usando: `true`

---

## 🚨 ERRORES COMUNES

### Error: "Failed to fetch" o "Network Error"
**Causa**: Variables de entorno no configuradas
**Solución**: Sigue los pasos 1-4 arriba

### Error: "401 Unauthorized"
**Causa**: La clave `SUPABASE_ANON_KEY` es incorrecta
**Solución**: Verifica que copiaste la clave correcta de Supabase

### Error: "403 Forbidden"
**Causa**: Políticas RLS bloqueando el acceso
**Solución**: Ejecuta `supabase/rls-policies.sql` en Supabase

### Los estudiantes aparecen vacíos
**Causa**: No hay estudiantes en la base de datos
**Solución**: Agrega estudiantes desde el panel de administración

---

## 📞 ¿Necesitas Más Ayuda?

Si después de seguir todos estos pasos el problema persiste:

1. Ejecuta `supabase/debug-estudiantes.sql` en Supabase
2. Comparte los resultados
3. Abre DevTools en Vercel y comparte los errores de la consola
4. Verifica los logs de Functions en Vercel

---

## ✅ Checklist Final

- [ ] Variables de entorno agregadas en Vercel (4 variables)
- [ ] Variables marcadas para Production, Preview, Development
- [ ] Re-deployment forzado (sin cache)
- [ ] Deployment completado exitosamente
- [ ] Login funciona en Vercel
- [ ] Estudiantes se visualizan correctamente

Una vez completado todo, ¡tu aplicación debería funcionar perfectamente en Vercel! 🎉
