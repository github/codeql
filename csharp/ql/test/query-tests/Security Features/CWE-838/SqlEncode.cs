

using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Net;

public class SqlEncode
{
    public static DataSet Bad(HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        using (var connection = new SqlConnection(""))
        {
            var query = "select * from Users where Name='" + user.Replace("\"", "\"\"") + "'";
            var adapter = new SqlDataAdapter(query, connection);
            var result = new DataSet();
            adapter.Fill(result);
            return result;
        }
    }

    public static DataSet Good(HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        using (var connection = new SqlConnection(""))
        {
            var query = "select * from Users where Name=@name";
            var adapter = new SqlDataAdapter(query, connection);
            var parameter = new SqlParameter("name", user);
            adapter.SelectCommand.Parameters.Add(parameter);
            var result = new DataSet();
            adapter.Fill(result);
            return result;
        }
    }
}
