using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Formatting.Json;
using System.Web;

class UnsafeJsonLoggingController : ControllerBase
{
    public void Configure(IServiceCollection services,
        Microsoft.Extensions.Configuration.IConfiguration externalConfiguration)
    {
        services.AddSerilog(configuration => configuration
            .WriteTo.Console(new JsonFormatter()));

        // A discovered external configuration reader vetoes the database-wide optimization.
        new LoggerConfiguration().ReadFrom.Configuration(externalConfiguration).CreateLogger();
    }

    public void Action(HttpContext context, Microsoft.Extensions.Logging.ILogger logger)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input); // $ Alert
    }
}
