using System;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages;
using System.Collections.Generic;

public class UrlRedirectHandler2 : IHttpHandler
{
    private const String VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html";

    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: a request parameter is incorporated without validation into a URL redirect
        ctx.Response.Redirect(ctx.Request.QueryString["page"]);

        List<string> VALID_REDIRECTS = new List<string>{ "http://cwe.mitre.org/data/definitions/601.html", "http://cwe.mitre.org/data/definitions/79.html" };
        
    }
}
