using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using System;
using Microsoft.Extensions.DependencyInjection;

public class Startup {
  public void ConfigureServices(string[] args) {
    var builder = WebApplication.CreateBuilder(args);
    var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

    builder.Services.AddCors(options => {
      options.AddPolicy(MyAllowSpecificOrigins,
        policy => {
          policy.SetIsOriginAllowed(test => true).AllowCredentials().AllowAnyHeader().AllowAnyMethod();
        });
    });

    var app = builder.Build();

    app.MapGet("/", () => "Hello World!");
    app.UseCors(MyAllowSpecificOrigins);

    app.Run();
  }
}