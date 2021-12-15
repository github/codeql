using System;
using System.Web;

public class XSSHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        ctx.Response.Write(
            "The page \"" + ctx.Request.QueryString["page"] + "\" was not found.");
    }
}
