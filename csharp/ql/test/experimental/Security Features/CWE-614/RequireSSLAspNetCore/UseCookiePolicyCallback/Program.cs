using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("auth", "secret"); // GOOD: Secure is set in callback
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: Secure is set in callback
    }
}

public class Startup
{
    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        app.UseCookiePolicy();
    }

    public void ConfigureServices(IServiceCollection services)
    {
        services.Configure<CookiePolicyOptions>(options =>
        {
            options.OnAppendCookie = cookieContext => SetCookies(cookieContext.CookieOptions);
        });
    }

    private void SetCookies(CookieOptions options)
    {
        options.Secure = true;
        options.HttpOnly = true;
    }
}
