# Scripts locales

`install-recluta-pronto.ps1` prepara el almacenamiento en el disco D y valida el
Docker Compose del repositorio. No elimina datos ni genera credenciales. Por
defecto solo valida; para iniciar los servicios:

```powershell
.\scripts\install-recluta-pronto.ps1 -InstallRoot D:\ReclutaProntoOS-V2 -Start
```

Completa los valores de `.env` localmente antes de usar `-Start`. El script
conserva un `.env` ya existente y no publica secretos.
## Frappe, ERPNext y HRMS

`setup-frappe-apps.ps1` inicia MariaDB, Redis y el servicio Frappe con el
perfil `erpnext`, comprueba las aplicaciones del sitio y ejecuta la instalación
de HRMS y las migraciones mediante el `bench` oficial. Requiere un `.env` local
con contraseñas reales y un sitio previamente creado siguiendo la guía oficial
de `frappe_docker`; no crea datos de negocio ni secretos.
