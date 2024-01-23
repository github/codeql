using System;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages;

public class UrlRedirectHandler : IHttpHandler
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

        // GOOD: We check whether this is a local URL before redirecting, using UrlHelper.
        // As recommended by https://docs.microsoft.com/en-us/aspnet/mvc/overview/security/preventing-open-redirection-attacks
        string url = ctx.Request.QueryString["page"];
        if (new UrlHelper(null).IsLocalUrl(url))
        {
            ctx.Response.Redirect(url);
        }

        // GOOD: We check whether this is a local URL before redirecting, using local method
        // As recommended by https://docs.microsoft.com/en-us/aspnet/mvc/overview/security/preventing-open-redirection-attacks
        string url2 = ctx.Request.QueryString["page"];
        if (IsLocalUrl(url2))
        {
            ctx.Response.Redirect(url2);
        }

        // BAD: Adding or appending a header
        ctx.Response.AddHeader("Location", ctx.Request.QueryString["page"]);
        ctx.Response.AppendHeader("Location", ctx.Request.QueryString["page"]);

        // GOOD: Redirecting to the RawUrl only reloads the current Url
        ctx.Response.Redirect(ctx.Request.RawUrl);

        // GOOD: The attacker can only control the parameters, not the location
        ctx.Response.Redirect("foo.asp?param=" + url);

        // BAD: Using Transfer with unvalidated user input
        ctx.Server.Transfer(url);

        // GOOD: request parameter is URL encoded
        ctx.Response.Redirect(HttpUtility.UrlEncode(ctx.Request.QueryString["page"]));

        // GOOD: whitelisted redirect
        var url3 = ctx.Request.QueryString["page"];
        if (new HttpRequestWrapper(ctx.Request).IsUrlLocalToHost(url3))
        {
            ctx.Response.Redirect(url3);
        }

        // GOOD: The attacker can only control the parameters, not the location
        ctx.Response.Redirect($"foo.asp?param={url}");

        // BAD: The attacker can control the location
        ctx.Response.Redirect($"{url}.asp?param=foo");

        // GOOD: The attacker can only control the parameters, not the location
        ctx.Response.Redirect(string.Format("foo.asp?param={0}", url));

        // BAD: The attacker can control the location
        ctx.Response.Redirect(string.Format("{0}.asp?param=foo", url));

        // GOOD: The attacker can only control the parameters, not the location
        ctx.Response.Redirect(string.Format("foo.asp?{1}param={0}", url, url));

        // BAD: The attacker can control the location
        ctx.Response.Redirect(string.Format("{1}.asp?{0}param=foo", url, url));
    }

    // Implementation as recommended by Microsoft.
    public bool IsLocalUrl(string url)
    {
        if (string.IsNullOrEmpty(url))
        {
            return false;
        }
        else
        {
            return ((url[0] == '/' && (url.Length == 1 ||
                (url[1] != '/' && url[1] != '\\'))) ||   // "/" or "/foo" but not "//" or "/\"
                (url.Length > 1 &&
                url[0] == '~' && url[1] == '/'));   // "~/" or "~/foo"
        }
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
