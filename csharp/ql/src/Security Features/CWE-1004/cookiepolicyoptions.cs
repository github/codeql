public class Startup
{
    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        app.UseCookiePolicy(new CookiePolicyOptions()
        {
            Secure = Microsoft.AspNetCore.Http.CookieSecurePolicy.Always,
            HttpOnly = Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy.Always
        });
    }
}