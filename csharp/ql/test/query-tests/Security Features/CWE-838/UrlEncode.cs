using System;
using System.Web;
using System.Net;

public class UrlEncode
{
    public static void Bad(string value, HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Redirect("?param=" + WebUtility.HtmlEncode(user));
    }

    public static void Good(string value, HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Redirect("?param=" + WebUtility.UrlEncode(user));
    }
}
