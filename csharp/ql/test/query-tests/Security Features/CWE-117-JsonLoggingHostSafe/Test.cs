using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using System.Web;

class JsonHost
{
    public void Configure()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders();
        builder.Logging.AddJsonConsole();

        var genericHost = new HostApplicationBuilder();
        genericHost.Logging.ClearProviders();
        genericHost.Logging.AddJsonConsole();
    }

    public void Action(HttpContext context, ILogger logger)
    {
        string input = context.Request.QueryString["input"];
        logger.LogInformation("Input: {Input}", input);
    }
}
