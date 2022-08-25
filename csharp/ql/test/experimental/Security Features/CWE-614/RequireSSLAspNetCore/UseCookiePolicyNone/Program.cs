using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("auth", "secret"); // Bad: Secure policy set to None
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Append("auth", "secret", cookieOptions); // Bad: Secure policy set to None
    }
}

public class Startup
{
    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        app.UseCookiePolicy(new CookiePolicyOptions() { Secure = Microsoft.AspNetCore.Http.CookieSecurePolicy.None });
    }
}
