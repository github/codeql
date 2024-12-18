using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Web;
using Microsoft.Extensions.Logging;

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
        // GOOD: New-lines removed
        logger.Warn(username.Replace(Environment.NewLine, "", StringComparison.InvariantCultureIgnoreCase) + " logged in");
        // GOOD: New-lines replaced
        logger.Warn(username.ReplaceLineEndings("") + " logged in");
        // GOOD: Html encoded
        logger.Warn(WebUtility.HtmlEncode(username) + " logged in");
        // BAD: Logged as-is to TraceSource
        new TraceSource("Test").TraceInformation(username + " logged in");

        Microsoft.Extensions.Logging.ILogger logger2 = null;
        // BAD: Logged as-is
        logger2.LogError(username);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
