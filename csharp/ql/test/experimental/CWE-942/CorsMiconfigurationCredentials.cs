using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using System;

var builder = WebApplication.CreateBuilder(args);
var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";


builder.Services.AddCors(options =>
{
    options.AddPolicy(MyAllowSpecificOrigins,
                      policy =>
                      {
                          policy.SetIsOriginAllowed(test => true).AllowCredentials().AllowAnyHeader().AllowAnyMethod();
                      });
});

var app = builder.Build();



app.MapGet("/", () => "Hello World!");
app.UseCors(MyAllowSpecificOrigins);

app.Run();