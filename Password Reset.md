#Resetar Contraseña Usuarios Factory .Net Core

-Contraseña por defecto : <font color="cyan">**Vege12345.** </font>




```sql
BEGIN TRAN NAMETRANSACTION
DECLARE
@Usuario NVARCHAR(10) = 'ID_Usuario',
@salt NVARCHAR(max)='wFN/dzSy/PVHk0Vo1SzwcQ==',
@PassHash NVARCHAR(max)='Apmqj8LK3w/oFGPjslWzm9oeXa4i7Igju8eZnKqWdiY='
        
UPDATE Users SET PasswordHash=@PassHash, Salt=@salt WHERE Usuario=@Usuario



--commit tran NAMETRANSACTION
```