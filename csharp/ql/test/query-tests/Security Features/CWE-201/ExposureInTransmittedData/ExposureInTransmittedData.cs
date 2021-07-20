using System;
using System.Web;
using System.Data.Common;
using System.Net.Mail;

public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
            var password = "123456";
            ctx.Response.Write(password); // BAD
        }
        catch (System.Data.SqlClient.SqlException ex)
        {
            ctx.Response.Write(ex.ToString());    // BAD
        }
        catch (DbException ex)
        {
            ctx.Response.Write(ex.Message);   // BAD
            ctx.Response.Write(ex.ToString());    // BAD
            ctx.Response.Write(ex.Data["password"]);  // BAD
        }
    }

    void SendPasswordToEmail()
    {
        var p = GetField("password");   // p is now tainted
        var message = new MailMessage("from", "to", p, p);  // BAD
        message.Body = "This is your password: " + p;   // BAD
        message.Subject = p;    // BAD
    }

    string GetField(string field)
    {
        return "";
    }

    public bool IsReusable => true;
}
