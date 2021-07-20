using System.Data.SqlClient;
using System.Web;

public class ResourceInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];
        string connectionString = "server=(local);user id=" + userName + ";password= pass;";
        // BAD: Direct use of user input in a connection string for the constructor
        SqlConnection sqlConnection = new SqlConnection(connectionString);
        // BAD: Direct use of user input assigned to a connection string property
        sqlConnection.ConnectionString = connectionString;
        // GOOD: Use SqlConnectionStringBuilder
        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
        builder["Data Source"] = "(local)";
        builder["integrated Security"] = true;
        builder["user id"] = userName;
        SqlConnection sqlConnectionGood = new SqlConnection(builder.ConnectionString);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
