using System;
using System.Web;
using System.Collections.Generic;

public class UnvalidatedUrlHandler : IHttpHandler
{
    private List<string> VALID_REDIRECTS = new List<string>{ "http://cwe.mitre.org/data/definitions/601.html", "http://cwe.mitre.org/data/definitions/79.html" };

    public void ProcessRequest(HttpContext ctx)
    {
        if (VALID_REDIRECTS.Contains(ctx.Request.QueryString["page"]))
        {
            // GOOD: the request parameter is validated against a known list of strings
            ctx.Response.Redirect(ctx.Request.QueryString["page"]);
        }
    }
}