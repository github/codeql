using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Logging;
using System.Web;

class MixedHosts
{
    public void SafeFactory()
    {
        LoggerFactory.Create(logging => logging.AddJsonConsole());
    }

    public void DefaultHost()
    {
        WebApplication.CreateBuilder();
    }

    public void Action(HttpContext context, ILogger logger)
    {
        string input = context.Request.QueryString["input"]; // $ Source
        logger.LogInformation("Input: {Input}", input); // $ Alert
    }
}
