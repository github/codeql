using System;
using System.Web;

public class UnvalidatedUrlHandler : IHttpHandler
{
    private const String VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html";

    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: a request parameter is incorporated without validation into a URL redirect
        ctx.Response.Redirect(ctx.Request.QueryString["page"]);

        // GOOD: the request parameter is validated against a known fixed string
        if (VALID_REDIRECT == ctx.Request.QueryString["page"])
        {
            ctx.Response.Redirect(VALID_REDIRECT);
        }
    }
}
