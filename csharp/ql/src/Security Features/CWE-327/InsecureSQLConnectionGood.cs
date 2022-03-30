using System.Data.SqlClient;

string connectString =
    "Server=1.2.3.4;Database=Anything;Integrated Security=true;;Encrypt=true;";
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectString);
var conn = new SqlConnection(builder.ConnectionString);