// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class ConfigureHostBuilder : Microsoft.Extensions.Hosting.IHostBuilder, Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsConfigureWebHost
            {
                Microsoft.Extensions.Hosting.IHost Microsoft.Extensions.Hosting.IHostBuilder.Build() => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, TContainerBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostConfiguration(System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate) => throw null;
                Microsoft.Extensions.Hosting.IHostBuilder Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsConfigureWebHost.ConfigureWebHost(System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure, System.Action<Microsoft.Extensions.Hosting.WebHostBuilderOptions> configureOptions) => throw null;
                public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(System.Func<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder>> factory) => throw null;
            }
            public sealed class ConfigureWebHostBuilder : Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsStartup, Microsoft.AspNetCore.Hosting.IWebHostBuilder
            {
                Microsoft.AspNetCore.Hosting.IWebHost Microsoft.AspNetCore.Hosting.IWebHostBuilder.Build() => throw null;
                Microsoft.AspNetCore.Hosting.IWebHostBuilder Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsStartup.Configure(System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configure) => throw null;
                Microsoft.AspNetCore.Hosting.IWebHostBuilder Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsStartup.Configure(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.AspNetCore.Builder.IApplicationBuilder> configure) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices) => throw null;
                public string GetSetting(string key) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSetting(string key, string value) => throw null;
                Microsoft.AspNetCore.Hosting.IWebHostBuilder Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsStartup.UseStartup(System.Type startupType) => throw null;
                Microsoft.AspNetCore.Hosting.IWebHostBuilder Microsoft.AspNetCore.Hosting.Infrastructure.ISupportsStartup.UseStartup<TStartup>(System.Func<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, TStartup> startupFactory) => throw null;
            }
            public sealed class WebApplication : Microsoft.AspNetCore.Builder.IApplicationBuilder, System.IAsyncDisposable, System.IDisposable, Microsoft.AspNetCore.Routing.IEndpointRouteBuilder, Microsoft.Extensions.Hosting.IHost
            {
                System.IServiceProvider Microsoft.AspNetCore.Builder.IApplicationBuilder.ApplicationServices { get => throw null; set { } }
                Microsoft.AspNetCore.Http.RequestDelegate Microsoft.AspNetCore.Builder.IApplicationBuilder.Build() => throw null;
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; }
                public static Microsoft.AspNetCore.Builder.WebApplication Create(string[] args = default(string[])) => throw null;
                Microsoft.AspNetCore.Builder.IApplicationBuilder Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.CreateApplicationBuilder() => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateBuilder() => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateBuilder(string[] args) => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateBuilder(Microsoft.AspNetCore.Builder.WebApplicationOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateEmptyBuilder(Microsoft.AspNetCore.Builder.WebApplicationOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateSlimBuilder() => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateSlimBuilder(string[] args) => throw null;
                public static Microsoft.AspNetCore.Builder.WebApplicationBuilder CreateSlimBuilder(Microsoft.AspNetCore.Builder.WebApplicationOptions options) => throw null;
                System.Collections.Generic.ICollection<Microsoft.AspNetCore.Routing.EndpointDataSource> Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.DataSources { get => throw null; }
                void System.IDisposable.Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment { get => throw null; }
                public Microsoft.Extensions.Hosting.IHostApplicationLifetime Lifetime { get => throw null; }
                public Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                Microsoft.AspNetCore.Builder.IApplicationBuilder Microsoft.AspNetCore.Builder.IApplicationBuilder.New() => throw null;
                System.Collections.Generic.IDictionary<string, object> Microsoft.AspNetCore.Builder.IApplicationBuilder.Properties { get => throw null; }
                public void Run(string url = default(string)) => throw null;
                public System.Threading.Tasks.Task RunAsync(string url = default(string)) => throw null;
                Microsoft.AspNetCore.Http.Features.IFeatureCollection Microsoft.AspNetCore.Builder.IApplicationBuilder.ServerFeatures { get => throw null; }
                System.IServiceProvider Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.ServiceProvider { get => throw null; }
                public System.IServiceProvider Services { get => throw null; }
                public System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Collections.Generic.ICollection<string> Urls { get => throw null; }
                public Microsoft.AspNetCore.Builder.IApplicationBuilder Use(System.Func<Microsoft.AspNetCore.Http.RequestDelegate, Microsoft.AspNetCore.Http.RequestDelegate> middleware) => throw null;
            }
            public sealed class WebApplicationBuilder : Microsoft.Extensions.Hosting.IHostApplicationBuilder
            {
                public Microsoft.AspNetCore.Builder.WebApplication Build() => throw null;
                public Microsoft.Extensions.Configuration.ConfigurationManager Configuration { get => throw null; }
                Microsoft.Extensions.Configuration.IConfigurationManager Microsoft.Extensions.Hosting.IHostApplicationBuilder.Configuration { get => throw null; }
                void Microsoft.Extensions.Hosting.IHostApplicationBuilder.ConfigureContainer<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory, System.Action<TContainerBuilder> configure) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment { get => throw null; }
                Microsoft.Extensions.Hosting.IHostEnvironment Microsoft.Extensions.Hosting.IHostApplicationBuilder.Environment { get => throw null; }
                public Microsoft.AspNetCore.Builder.ConfigureHostBuilder Host { get => throw null; }
                public Microsoft.Extensions.Logging.ILoggingBuilder Logging { get => throw null; }
                public Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder Metrics { get => throw null; }
                System.Collections.Generic.IDictionary<object, object> Microsoft.Extensions.Hosting.IHostApplicationBuilder.Properties { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
                public Microsoft.AspNetCore.Builder.ConfigureWebHostBuilder WebHost { get => throw null; }
            }
            public class WebApplicationOptions
            {
                public string ApplicationName { get => throw null; set { } }
                public string[] Args { get => throw null; set { } }
                public string ContentRootPath { get => throw null; set { } }
                public WebApplicationOptions() => throw null;
                public string EnvironmentName { get => throw null; set { } }
                public string WebRootPath { get => throw null; set { } }
            }
        }
        public static class WebHost
        {
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder() => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder(string[] args) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder<TStartup>(string[] args) where TStartup : class => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(Microsoft.AspNetCore.Http.RequestDelegate app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(string url, Microsoft.AspNetCore.Http.RequestDelegate app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> routeBuilder) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(string url, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> routeBuilder) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost StartWith(System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost StartWith(string url, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> app) => throw null;
        }
    }
    namespace Extensions
    {
        namespace Hosting
        {
            public static partial class GenericHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHostDefaults(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHostDefaults(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure, System.Action<Microsoft.Extensions.Hosting.WebHostBuilderOptions> configureOptions) => throw null;
            }
        }
    }
}
