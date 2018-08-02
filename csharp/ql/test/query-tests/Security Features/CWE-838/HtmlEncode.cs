// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs ${testdir}/../../../resources/stubs/System.Windows.cs /r:System.Collections.Specialized.dll ${testdir}/../../../resources/stubs/System.Net.cs /r:System.ComponentModel.Primitives.dll /r:System.ComponentModel.TypeConverter.dll ${testdir}/../../../resources/stubs/System.Data.cs /r:System.Data.Common.dll

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
