using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Web;

class BuiltInJsonLoggingController : ControllerBase
{
    public void Action(HttpContext context)
    {
        using var factory = LoggerFactory.Create(logging => logging.AddJsonConsole());
        var logger = factory.CreateLogger("Example");
        var genericLogger = factory.CreateLogger<BuiltInJsonLoggingController>();
        string input = context.Request.QueryString["input"];
        logger.LogInformation("Input: {Input}", input);
        logger.LogInformation($"Input: {input}");
        genericLogger.LogInformation("Input: {Input}", input);

        var explicitlyDisposed = LoggerFactory.Create(logging => logging.AddJsonConsole());
        explicitlyDisposed.Dispose();
    }
}
