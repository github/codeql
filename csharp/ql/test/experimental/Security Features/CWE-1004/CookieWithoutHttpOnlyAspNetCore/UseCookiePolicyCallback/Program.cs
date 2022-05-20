// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Authentication.Cookies.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Authentication.cs ${testdir}/../../../../../resources/stubs/Microsoft.Extensions.DependencyInjection.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.CookiePolicy.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Hosting.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Http.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Mvc.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Builder.cs

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: HttpOnly is set in callback
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
