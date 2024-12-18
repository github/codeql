using System;
using System.Web;

public class UnvalidatedUrlHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: a request parameter is incorporated without validation into a URL redirect
        ctx.Response.Redirect(ctx.Request.QueryString["page"]);
    }
}
