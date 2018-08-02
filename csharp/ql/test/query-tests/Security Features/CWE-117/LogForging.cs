//semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll /r:System.Runtime.Extensions.dll /r:System.Diagnostics.TraceSource.dll

using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Web;

class ILogger
{
    public void Warn(string message) { }
}

public class LogForgingHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String username = ctx.Request.QueryString["username"];
        ILogger logger = new ILogger();
        // BAD: Logged as-is
        logger.Warn(username + " logged in");
        // GOOD: New-lines removed
        logger.Warn(username.Replace(Environment.NewLine, "") + " logged in");
        // GOOD: Html encoded
        logger.Warn(WebUtility.HtmlEncode(username) + " logged in");
        // BAD: Logged as-is to TraceSource
        new TraceSource("Test").TraceInformation(username + " logged in");
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
