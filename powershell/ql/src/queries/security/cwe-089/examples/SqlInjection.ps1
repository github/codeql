param(
    [string]$userinput
)

# BAD: The user input is directly interpolated into the SQL query string
$query1 = "SELECT * FROM users WHERE name = '$userinput'"
Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query

# GOOD: Using parameters to prevent SQL injection
$query2 = "SELECT * FROM users WHERE name = @username"

$params = @{
  username = $userinput
}

Invoke-Sqlcmd -ServerInstance "MyServer" -Database "MyDatabase" -Query $query -QueryParameters $params