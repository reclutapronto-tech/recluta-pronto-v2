# Integración operativa

Los tres workflows versionados en `workflows/` exponen los motores por webhooks n8n:

- `POST /webhook/recluta/vacantes`: envía el documento a Docling Serve para extracción.
- `POST /webhook/recluta/prospeccion`: recibe oportunidades provenientes de Muse.
- `POST /webhook/recluta/reclutamiento`: responde mensajes mediante Evolution API.

El instalador copia estas definiciones a `D:\ReclutaProntoOS-V2\n8n-workflows`. En n8n deben importarse desde la interfaz o API administrativa local y activarse después de configurar las credenciales reales. No se incluyen credenciales ni datos de negocio.

Para la prueba extremo a extremo de infraestructura ya iniciada:

```powershell
.\scripts\e2e-smoke.ps1
```

La prueba falla si algún servicio no está disponible; no sustituye la validación comercial con documentos, candidatos o sesiones reales.
