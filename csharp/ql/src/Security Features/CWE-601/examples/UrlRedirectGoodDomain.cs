using System;
using System.Web;

public class UnvalidatedUrlHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        var urlString = ctx.Request.QueryString["page"];
        var url = new Uri(urlString, UriKind.RelativeOrAbsolute);

        var url = new Uri(redirectUrl, UriKind.RelativeOrAbsolute);
        if (!url.IsAbsoluteUri) {
            // GOOD: The redirect is to a relative URL
            ctx.Response.Redirect(url.ToString());
        }

        if (url.Host == "example.org") {
            // GOOD: The redirect is to a known host
            ctx.Response.Redirect(url.ToString());
        }
    }
}