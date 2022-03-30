// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Authentication.Cookies.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Authentication.cs ${testdir}/../../../../../resources/stubs/Microsoft.Extensions.DependencyInjection.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.CookiePolicy.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Hosting.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Http.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Mvc.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Builder.cs

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
