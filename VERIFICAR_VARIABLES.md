# 🔧 Verificación de Variables de Entorno en Vercel

## ⚠️ Problema Actual: Error 504 GATEWAY_TIMEOUT

El API `/api/users/me` está dando timeout porque no puede conectarse a Supabase.

## ✅ Pasos para Verificar y Corregir

### 1. Verificar Variables de Entorno en Vercel

1. Ve a https://vercel.com/dashboard
2. Selecciona tu proyecto (seni)
3. Ve a **Settings** → **Environment Variables**
4. Verifica que tengas EXACTAMENTE estas 4 variables:

| Variable Name | Ejemplo de Valor | ¿Dónde encontrarlo? |
|--------------|------------------|---------------------|
| `VITE_SUPABASE_URL` | `https://abcdefgh.supabase.co` | Supabase → Settings → API → Project URL |
| `VITE_SUPABASE_ANON_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6...` | Supabase → Settings → API → Project API keys → anon public |
| `SUPABASE_URL` | `https://abcdefgh.supabase.co` | **MISMO** que VITE_SUPABASE_URL |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6...` | Supabase → Settings → API → Project API keys → service_role |

### 2. Puntos Importantes

✅ **Verifica que:**
- Los nombres de las variables estén escritos EXACTAMENTE como se muestra arriba (mayúsculas/minúsculas importan)
- No haya espacios al inicio o final de los valores
- Las 4 variables estén marcadas para **Production**, **Preview** y **Development**
- `SUPABASE_URL` y `VITE_SUPABASE_URL` tengan el MISMO valor
- Las keys sean las correctas (anon para VITE_SUPABASE_ANON_KEY, service_role para SUPABASE_SERVICE_ROLE_KEY)

⚠️ **Errores Comunes:**
- ❌ Usar `SUPABASE_ANON_KEY` en lugar de `VITE_SUPABASE_ANON_KEY`
- ❌ Confundir la `anon` key con la `service_role` key
- ❌ No marcar las variables para Production
- ❌ Tener espacios extra en los valores

### 3. Después de Configurar las Variables

**IMPORTANTE:** Debes re-desplegar para que los cambios surtan efecto:

1. Ve a **Deployments**
2. Click en los tres puntos (...) del deployment más reciente
3. Click en **Redeploy**
4. **DESMARCA** "Use existing Build Cache"
5. Click en **Redeploy**

### 4. Verificar que Funcionó

Espera 1-2 minutos a que termine el deployment, luego:

1. Ve a https://seni-nine.vercel.app/api/users/me
2. Deberías ver: `{"error":"Not authenticated"}` (esto es CORRECTO - significa que la API funciona)
3. Si ves error 504 o 500, revisa los logs

### 5. Ver los Logs de la Función

Si sigue sin funcionar:

1. Ve a Vercel Dashboard → **Deployments**
2. Click en el deployment más reciente
3. Click en **Functions** (en el menú lateral)
4. Click en `/api/users/me`
5. Verás los logs con mensajes como:
   - ✅ `"Verifying user token..."` - La función está funcionando
   - ❌ `"Missing environment variables"` - Las variables no están configuradas
   - ❌ `"Database error"` - Problema con Supabase

## 📸 Capturas de Pantalla de Referencia

### Cómo se ven las variables en Vercel:
```
VITE_SUPABASE_URL                 https://xxxxx.supabase.co          [Production] [Preview] [Development]
VITE_SUPABASE_ANON_KEY            eyJhbGciOiJIUzI1NiIsInR5cCI...    [Production] [Preview] [Development]
SUPABASE_URL                      https://xxxxx.supabase.co          [Production] [Preview] [Development]
SUPABASE_SERVICE_ROLE_KEY         eyJhbGciOiJIUzI1NiIsInR5cCI...    [Production] [Preview] [Development]
```

### Cómo encontrar las keys en Supabase:
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **Settings** (⚙️ en el menú lateral)
4. Click en **API**
5. Verás:
   - **Project URL** → Copia esto para VITE_SUPABASE_URL y SUPABASE_URL
   - **Project API keys:**
     - `anon` `public` → Copia esto para VITE_SUPABASE_ANON_KEY
     - `service_role` `secret` → Copia esto para SUPABASE_SERVICE_ROLE_KEY

## 🆘 Si Sigue Sin Funcionar

Comparte:
1. Captura de pantalla de las variables de entorno en Vercel (puedes ocultar parte de las keys)
2. Los logs de la función en Vercel
3. El mensaje de error que ves en la consola del navegador

## ✅ Checklist Final

- [ ] Las 4 variables están configuradas en Vercel
- [ ] Los nombres están escritos exactamente como se indica
- [ ] Las variables están marcadas para Production, Preview y Development
- [ ] Hice Redeploy después de configurar las variables
- [ ] Esperé 1-2 minutos a que termine el deployment
- [ ] Probé https://seni-nine.vercel.app/api/users/me y no da 504
