using System;
using System.Web;
using Microsoft.Security.Application;

public class XSSHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string page = Encoder.HtmlEncode(ctx.Request.QueryString["page"]);
        ctx.Response.Write(
            "The page \"" + page + "\" was not found.");
    }
}
