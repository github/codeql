void Configure(IApplicationBuilder app)
{
    app.Use(async (context, next) =>
    {
        context.Response.Headers["Content-Security-Policy"] = "frame-ancestors 'none'";
        await next();
    });
}
