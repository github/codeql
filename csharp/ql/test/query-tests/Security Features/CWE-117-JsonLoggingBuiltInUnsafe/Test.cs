using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Web;

class MixedBuiltInLoggingController : ControllerBase
{
    public void Configure()
    {
        LoggerFactory.Create(logging => logging.ClearProviders().AddJsonConsole());
        LoggerFactory.Create(logging => logging.AddConsole());
    }

    public void Action(HttpContext context, ILogger logger)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input); // $ Alert
    }
}
