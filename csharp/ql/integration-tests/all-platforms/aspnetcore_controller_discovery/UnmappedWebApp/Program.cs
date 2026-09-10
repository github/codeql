using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();

var app = builder.Build();
app.MapFallbackToController("Index", "FallbackOnly");
app.MapFallbackToAreaController("admin/{*path:nonfile}", "Index", "AreaFallback", "Admin");
app.Run();
