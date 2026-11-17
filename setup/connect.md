# Connecting to SQL Server

All connections use **Windows authentication** (your Windows login). No passwords.

- Server: `localhost` (default instance `MSSQLSERVER`)
- Database: `AdventureWorks2025`

## Terminal (sqlcmd)

```powershell
# One-off query
sqlcmd -S localhost -E -C -d AdventureWorks2025 -Q "SELECT TOP 5 FirstName, LastName FROM Person.Person"

# Run a .sql file
sqlcmd -S localhost -E -C -d AdventureWorks2025 -i setup\smoke_test.sql

# Interactive session (type a query, then GO on its own line; QUIT to exit)
sqlcmd -S localhost -E -C -d AdventureWorks2025
```

Flags: `-S` server, `-E` Windows auth, `-C` trust the server's self-signed certificate,
`-d` database, `-Q` run a query and exit, `-i` run a file.

## SSMS 21 (main SQL editor)

Open it from the Start menu (**SQL Server Management Studio 21**), or from the terminal:

```powershell
& "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe" -S localhost -E -d AdventureWorks2025
```

In the **Connect to Server** dialog:

- Server type: **Database Engine**
- Server name: `localhost`
- Authentication: **Windows Authentication**
- Encryption: **Mandatory**, and tick **Trust server certificate**
- Click **Connect**

Then:

- Open an exercise: **File → Open → File…** (`Ctrl+O`) → `D:\sql-practice\AdventureWorks2025\ex01_select_columns.sql`
- Check the database dropdown on the toolbar says `AdventureWorks2025` (the `USE` line in each file sets it too)
- Run: **F5** (or `Ctrl+E`) runs the whole file, or just the selected text
- Show the estimated execution plan: `Ctrl+L`

## Power BI Desktop

Open it from the Start menu (**Power BI Desktop**). To pull in AdventureWorks data:

1. **Home → Get data → SQL Server**
2. Server: `localhost`, Database: `AdventureWorks2025`, Data connectivity mode: **Import** → **OK**
3. Credentials: **Windows** → **Use my current credentials** → **Connect**
4. If it says it can't connect with encryption, click **OK** to connect unencrypted
   (fine here: the server is on this machine)
5. In the Navigator, tick the tables you want (for example `Sales.SalesOrderHeader`) → **Load**

## VS Code + MSSQL extension (optional; mainly for Python)

1. Open the folder: `code D:\sql-practice`
2. Open any `.sql` file.
3. Press `Ctrl+Shift+P` → **MS SQL: Connect** (or click "Connect" in the bottom status bar).
4. Create a connection profile:
   - Server name: `localhost`
   - Authentication type: **Windows Authentication** (Integrated)
   - Database: `AdventureWorks2025`
   - Trust server certificate: **Yes**
   - Profile name: `local-adventureworks`
5. Run the current file or selection with `Ctrl+Shift+E`.

Connection string (for tools that ask for one):

```
Server=localhost;Database=AdventureWorks2025;Integrated Security=True;TrustServerCertificate=True;
```
