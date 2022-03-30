using System.Data.SqlClient;
using System.Web;

public class ResourceInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];

        // BAD: Direct use of user input in a connection string passed to SqlConnection
        string connectionString = "server=(local);user id=" + userName + ";password= pass;";
        SqlConnection sqlConnectionBad = new SqlConnection(connectionString);

        // GOOD: Use SqlConnectionStringBuilder to safely include user input in a connection string
        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
        builder["Data Source"] = "(local)";
        builder["integrated Security"] = true;
        builder["user id"] = userName;
        SqlConnection sqlConnectionGood = new SqlConnection(builder.ConnectionString);
    }
}
