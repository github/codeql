using System;
using System.Web;
using System.Net;

public class XSSHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string page = WebUtility.HtmlEncode(ctx.Request.QueryString["page"]);
        ctx.Response.Write(
            "The page \"" + page + "\" was not found.");
    }
}
