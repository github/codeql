using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication;

public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddAuthentication().AddCookie(o =>
        {
            o.Cookie.HttpOnly = false;
            o.Cookie.SecurePolicy = Microsoft.AspNetCore.Http.CookieSecurePolicy.None;
        });

        services.AddSession(options =>
        {
            options.Cookie.SecurePolicy = Microsoft.AspNetCore.Http.CookieSecurePolicy.None;
            options.Cookie.HttpOnly = false;
        });
    }
}
