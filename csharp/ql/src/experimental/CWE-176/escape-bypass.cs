using System;
using System.IO;
using System.Web;
using System.Net;
using System.Security;

public class UNHandler : IHttpHandler
{
    public void BadEscape(HttpContext ctx)
    {
        String provided = ctx.Request.QueryString["input"];
        String escaped = SecurityElement.Escape(provided);
        String normalized = escaped.Normalize(NormalizationForm.FormKC); // FormC
    }
}
