// semmle-extractor-options: /r:${testdir}/../../../resources/assemblies/System.Web.dll /r:${testdir}/../../../resources/assemblies/System.Web.ApplicationServices.dll /r:${testdir}/../../../resources/assemblies/System.Data.dll /r:System.Text.RegularExpressions.dll /r:System.Collections.Specialized.dll /r:System.Data.Common.dll /r:System.Security.Cryptography.X509Certificates.dll /r:System.Runtime.InteropServices.dll

using System;
using System.Text;
using System.Web;

public class UntrustedData : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        var name = ctx.Request.QueryString["name"];
        var len = name.Length;

        var myEncodedString = HttpUtility.HtmlEncode(name);
        ctx.Response.Write(name);
    }

    public bool IsReusable => true;
}
