using System;
using System.Web;
using System.Net;

public class HtmlEncode
{
    public static void Bad(HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Write("Hello, " + WebUtility.UrlEncode(user));
    }

    public static void Good(HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Write("Hello, " + WebUtility.HtmlEncode(user));
    }
}
