using System.Data.SqlClient;

// BAD, Encrypt not specified
string connectString =
    "Server=1.2.3.4;Database=Anything;Integrated Security=true;";
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
var conn = new SqlConnection(builder.ConnectionString);