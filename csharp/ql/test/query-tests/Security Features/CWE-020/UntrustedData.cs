using System;
using System.Text;
using System.Web;

public class UntrustedData : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        var name = ctx.Request.QueryString["name"]; // $ Alert[cs/untrusted-data-to-external-api]=r1 $ Alert[cs/untrusted-data-to-external-api]=r1 $ Source[cs/untrusted-data-to-external-api]=r2
        var len = name.Length;

        var myEncodedString = HttpUtility.HtmlEncode(name);
        ctx.Response.Write(name); // $ Alert[cs/untrusted-data-to-external-api]=r2
    }

    public bool IsReusable => true;
}
