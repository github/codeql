using System;
using System.Diagnostics;
using System.Web;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Formatting.Json;
using Serilog.Formatting.Compact;
using Company;

namespace Custom
{
    class ILogger
    {
        public void Warn(string message) { }
    }
}

class JsonLoggingController : ControllerBase
{
    public void Configure()
    {
        Log.Logger = new LoggerConfiguration()
            .WriteTo.Async(write => write.Console(new JsonFormatter()))
            .CreateBootstrapLogger();

        var builder = WebApplication.CreateBuilder();
        builder.AddCompanyDefaults();
        builder.Services.AddBusinessServices();
        builder.Services.AddSerilog((provider, configuration) => configuration
            .Enrich.FromLogContext()
            .Enrich.WithProperty("Application", "test")
            .WriteTo.Console(new JsonFormatter())
            .WriteTo.Console(new JsonFormatter(closingDelimiter: null, renderMessage: true))
            .WriteTo.Console(new CompactJsonFormatter())
            .WriteTo.Console(new RenderedCompactJsonFormatter(new JsonValueFormatter()))
            .WriteTo.File(new JsonFormatter(), "safe.log")
            .AuditTo.Console(new JsonFormatter()),
            preserveStaticLogger: false,
            writeToProviders: false);
        var app = builder.Build();
        app.MapGet("/", (Microsoft.AspNetCore.Http.HttpContext context,
            Microsoft.Extensions.Logging.ILogger<JsonLoggingController> logger) =>
        {
            string input = context.Request.Query["input"].ToString();
            logger.LogInformation("Input: {Input}", input);
            return input;
        });
    }

    public void Action(HttpContext context, Microsoft.Extensions.Logging.ILogger logger, Serilog.ILogger serilog)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input);
        logger.LogInformation($"Input: {input}");
        serilog.Information("Input: {Input}", input);

        var concrete = new LoggerConfiguration()
            .WriteTo.Console(new JsonFormatter())
            .CreateLogger();
        concrete.Information("Input: {Input}", input);

        new Custom.ILogger().Warn(input); // $ Alert
        new TraceSource("test").TraceInformation(input); // $ Alert
    }
}
