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

Invoke-Sqlcmd @QueryConn # GOOD

$QueryConn2 = @{
    Database = "MyDB"
    ServerInstance = "MyServer"
    Username = "MyUserName"
    Password = "MyPassword"
    ConnectionTimeout = 0
    Query = $userinput
}

Invoke-Sqlcmd @QueryConn2 # BAD

function TakesTypedParameters([int]$i, [long]$l, [float]$f, [double]$d, [decimal]$dec, [char]$c, [bool]$b, [datetime]$dt) {
    $query1 = "SELECT * FROM MyTable WHERE MyColumn = '$i'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query1 # GOOD

    $query2 = "SELECT * FROM MyTable WHERE MyColumn = '$l'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query2 # GOOD

    $query3 = "SELECT * FROM MyTable WHERE MyColumn = '$f'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query3 # GOOD

    $query4 = "SELECT * FROM MyTable WHERE MyColumn = '$d'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query4 # GOOD

    $query5 = "SELECT * FROM MyTable WHERE MyColumn = '$dec'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query5 # GOOD

    $query6 = "SELECT * FROM MyTable WHERE MyColumn = '$c'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query6 # GOOD

    $query7 = "SELECT * FROM MyTable WHERE MyColumn = '$b'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query7 # GOOD

    $query8 = "SELECT * FROM MyTable WHERE MyColumn = '$dt'"
    Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query8 # GOOD
}

TakesTypedParameters $userinput $userinput $userinput $userinput $userinput $userinput $userinput $userinput
