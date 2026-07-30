using IncludedControllers;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);
builder.Services
    .AddControllers()
    .AddApplicationPart(typeof(IncludedController).Assembly);

var app = builder.Build();
app.MapControllers();
app.Run();