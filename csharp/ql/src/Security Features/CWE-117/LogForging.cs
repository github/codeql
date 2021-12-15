using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Web;

public class LogForgingHandler : IHttpHandler
{
    private ILogger logger;

    public void ProcessRequest(HttpContext ctx)
    {
        String username = ctx.Request.QueryString["username"];
        // BAD: User input logged as-is
        logger.Warn(username + " log in requested.");
        // GOOD: User input logged with new-lines removed
        logger.Warn(username.Replace(Environment.NewLine, "") + " log in requested");
    }
}
