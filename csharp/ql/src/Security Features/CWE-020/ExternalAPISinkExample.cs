using System;
using System.Text;
using System.Web;

public class UntrustedData : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        var name = ctx.Request.QueryString["name"];
        ctx.Response.Write(name);
    }

    public bool IsReusable => true;
}
