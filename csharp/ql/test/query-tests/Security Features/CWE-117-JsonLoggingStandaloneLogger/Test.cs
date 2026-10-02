using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Formatting.Json;
using System.Web;

class StandaloneLogger
{
    public void Configure()
    {
        // A safe static logger does not establish the configuration of an injected logger.
        Log.Logger = new LoggerConfiguration().WriteTo.Console(new JsonFormatter()).CreateLogger();
    }

    public void Action(HttpContext context, Microsoft.Extensions.Logging.ILogger logger)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input); // $ Alert
    }
}
