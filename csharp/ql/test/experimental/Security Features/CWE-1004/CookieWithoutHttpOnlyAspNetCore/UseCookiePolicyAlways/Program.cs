// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.CookiePolicy.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Hosting.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Http.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Mvc.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Builder.cs

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("auth", "secret"); // GOOD: HttpOnly is set in policy
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: HttpOnly is set in policy
    }
}

public class Startup
{
    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        app.UseCookiePolicy(new CookiePolicyOptions() { HttpOnly = Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy.Always});
    }
}
