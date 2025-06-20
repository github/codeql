$userinput = Read-Host "Please enter a value"

# Example using Invoke-Sqlcmd with string interpolation
$query = "SELECT * FROM MyTable WHERE MyColumn = '$userinput'"
Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query # BAD

# Example using Invoke-Sqlcmd with string concatenation
$query = "SELECT * FROM MyTable WHERE " + $userinput
Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query # BAD

#Example using System.Data.SqlClient
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = "Server=MyServer;Database=MyDatabase;"
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT * FROM MyTable WHERE MyColumn = '$userinput'" # BAD
$reader = $command.ExecuteReader()
$reader.Close()
$connection.Close()

# Example using System.Data.OleDb
$connection = New-Object System.Data.OleDb.OleDbConnection
$connection.ConnectionString = "Provider=SQLOLEDB;Data Source=MyServer;Initial Catalog=MyDatabase;"
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT * FROM MyTable WHERE MyColumn = '$userinput'" # BAD
$reader = $command.ExecuteReader()
$reader.Close()
$connection.Close()

# Example using System.Data.SqlClient with parameters
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = "Server=MyServer;Database=MyDatabase;"
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT * FROM MyTable WHERE MyColumn = @userinput"
$parameter = $command.Parameters.Add("@userinput", [System.Data.SqlDbType]::NVarChar)
$parameter.Value = $userinput # GOOD
$reader = $command.ExecuteReader()
$reader.Close()
$connection.Close()

# Example using System.Data.OleDb with parameters
$connection = New-Object System.Data.OleDb.OleDbConnection
$connection.ConnectionString = "Provider=SQLOLEDB;Data Source=MyServer;Initial Catalog=MyDatabase;" 
$connection.Open()
$command = $connection.CreateCommand()
$command.CommandText = "SELECT * FROM MyTable WHERE MyColumn = ?"
$parameter = $command.Parameters.Add("?", [System.Data.OleDb.OleDbType]::VarChar)
$parameter.Value = $userinput # GOOD
$reader = $command.ExecuteReader()
$reader.Close()
$connection.Close()

$server = $Env:SERVER_INSTANCE
Invoke-Sqlcmd -ServerInstance $server -Database "MyDatabase" -InputFile "Foo/Bar/query.sql" # GOOD

$QueryConn = @{
    Database = "MyDB"
    ServerInstance = $server
    Username = "MyUserName"
    Password = "MyPassword"
    ConnectionTimeout = 0
    Query = ""
}

Invoke-Sqlcmd @QueryConn # GOOD [FALSE POSITIVE]