using System.Data.SqlClient;

// BAD, Encrypt not specified
string connectString =
    "Server=1.2.3.4;Database=Anything;Integrated Security=true;";
var builder = new SqlConnectionStringBuilder(connectString) { Encrypt = true }
var conn = new SqlConnection(builder.ConnectionString);