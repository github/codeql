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
            ctx.Response.Write(password); // $ Alert=r1 Alert=r1 // BAD
        }
        catch (System.Data.SqlClient.SqlException ex)
        {
            ctx.Response.Write(ex.ToString());    // $ Alert=r2 Alert=r2 // BAD
        }
        catch (DbException ex)
        {
            ctx.Response.Write(ex.Message);   // $ Alert=r3 Alert=r3 // BAD
            ctx.Response.Write(ex.ToString());    // $ Alert=r4 Alert=r4 // BAD
            ctx.Response.Write(ex.Data["password"]);  // $ Alert=r5 Alert=r5 // BAD
        }
    }

    void SendPasswordToEmail()
    {
        var p = GetField("password");   // $ Source=r6 Source=r7 Source=r8 Source=r9 // p is now tainted
        var message = new MailMessage("from", "to", p, p);  // $ Alert=r6 Alert=r7 Alert=r8 Alert=r9 // BAD
        message.Body = "This is your password: " + p;   // $ Alert=r6 Alert=r7 Alert=r8 Alert=r9 // BAD
        message.Subject = p;    // $ Alert=r6 Alert=r7 Alert=r8 Alert=r9 // BAD
    }

    string GetField(string field)
    {
        return "";
    }

    public bool IsReusable => true;
}
