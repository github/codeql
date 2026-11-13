using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Formatting.Json;
using System.Web;

class ForwardingLogging
{
    public void Configure(IServiceCollection services)
    {
        services.AddSerilog(configuration => configuration.WriteTo.Console(new JsonFormatter()),
            writeToProviders: true);
    }

    public void Action(HttpContext context, Microsoft.Extensions.Logging.ILogger logger)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input); // $ Alert
    }
}
