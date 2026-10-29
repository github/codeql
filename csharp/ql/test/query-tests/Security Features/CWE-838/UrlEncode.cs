using System;
using System.Web;
using System.Net;

public class UrlEncode
{
    public static void Bad(string value, HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Redirect("?param=" + WebUtility.HtmlEncode(user)); // $ Alert=r12 $ Alert=r12
    }

    public static void Good(string value, HttpContext ctx)
    {
        var user = WebUtility.UrlDecode(ctx.Request.QueryString["user"]);
        ctx.Response.Redirect("?param=" + WebUtility.UrlEncode(user));
    }
}
