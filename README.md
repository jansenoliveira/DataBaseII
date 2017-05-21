# databases-scripts
Repositório dedicado para armazenar estudos e exercícios da matéria de Programação e Administração de Banco de Dados.

## Links
- [https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-ubuntu](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-ubuntu)

- [https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools)

- [https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-connect-and-query-sqlcmd](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-connect-and-query-sqlcmd)

- [https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-migrate-restore-database](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-migrate-restore-database)

## Restaurando o Banco

### Adventure Works:

- 1> RESTORE DATABASE AdventureWorks
- 2> FROM DISK = '/var/opt/mssql/backup/AdventureWorks.bak'
- 3> MOVE 'AdventureWorks_Data' TO '/var/opt/mssql/data/AdventureWorks_Data.mdf',
- 4> MOVE 'AdventureWorks_Log' TO '/var/opt/mssql/data/AdventureWorks_Log.ldf'
- 5> GO


### Pubs

- 1> RESTORE DATABASE Pubs
- 2> FROM DISK = '/var/opt/mssql/backup/Pubs.bak'
- 3> WITH MOVE 'Pubs' TO '/var/opt/mssql/data/Pubs.mdf',
- 4> MOVE 'Pubs_Log' TO '/var/opt/mssql/data/Pubs_Log.ldf'
- 5> GO
