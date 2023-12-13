// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Hosting.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static class EnvironmentName
            {
                public static readonly string Development;
                public static readonly string Production;
                public static readonly string Staging;
            }
            public static partial class HostingAbstractionsWebHostBuilderExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CaptureStartupErrors(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, bool captureStartupErrors) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder PreferHostingUrls(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, bool preferHostingUrls) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHost Start(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, params string[] urls) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder SuppressStatusMessages(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, bool suppressStatusMessages) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseConfiguration(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseContentRoot(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, string contentRoot) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseEnvironment(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, string environment) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseServer(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, Microsoft.AspNetCore.Hosting.Server.IServer server) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseShutdownTimeout(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.TimeSpan timeout) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, string startupAssemblyName) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseUrls(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, params string[] urls) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseWebRoot(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, string webRoot) => throw null;
            }
            public static partial class HostingEnvironmentExtensions
            {
                public static bool IsDevelopment(this Microsoft.AspNetCore.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsEnvironment(this Microsoft.AspNetCore.Hosting.IHostingEnvironment hostingEnvironment, string environmentName) => throw null;
                public static bool IsProduction(this Microsoft.AspNetCore.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsStaging(this Microsoft.AspNetCore.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false, AllowMultiple = true)]
            public sealed class HostingStartupAttribute : System.Attribute
            {
                public HostingStartupAttribute(System.Type hostingStartupType) => throw null;
                public System.Type HostingStartupType { get => throw null; }
            }
            public interface IApplicationLifetime
            {
                System.Threading.CancellationToken ApplicationStarted { get; }
                System.Threading.CancellationToken ApplicationStopped { get; }
                System.Threading.CancellationToken ApplicationStopping { get; }
                void StopApplication();
            }
            public interface IHostingEnvironment
            {
                string ApplicationName { get; set; }
                Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; }
                string ContentRootPath { get; set; }
                string EnvironmentName { get; set; }
                Microsoft.Extensions.FileProviders.IFileProvider WebRootFileProvider { get; set; }
                string WebRootPath { get; set; }
            }
            public interface IHostingStartup
            {
                void Configure(Microsoft.AspNetCore.Hosting.IWebHostBuilder builder);
            }
            public interface IStartup
            {
                void Configure(Microsoft.AspNetCore.Builder.IApplicationBuilder app);
                System.IServiceProvider ConfigureServices(Microsoft.Extensions.DependencyInjection.IServiceCollection services);
            }
            public interface IStartupConfigureContainerFilter<TContainerBuilder>
            {
                System.Action<TContainerBuilder> ConfigureContainer(System.Action<TContainerBuilder> container);
            }
            public interface IStartupConfigureServicesFilter
            {
                System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> ConfigureServices(System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> next);
            }
            public interface IStartupFilter
            {
                System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> Configure(System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> next);
            }
            public interface IWebHost : System.IDisposable
            {
                Microsoft.AspNetCore.Http.Features.IFeatureCollection ServerFeatures { get; }
                System.IServiceProvider Services { get; }
                void Start();
                System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IWebHostBuilder
            {
                Microsoft.AspNetCore.Hosting.IWebHost Build();
                Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate);
                Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices);
                Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices);
                string GetSetting(string key);
                Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSetting(string key, string value);
            }
            public interface IWebHostEnvironment : Microsoft.Extensions.Hosting.IHostEnvironment
            {
                Microsoft.Extensions.FileProviders.IFileProvider WebRootFileProvider { get; set; }
                string WebRootPath { get; set; }
            }
            public class WebHostBuilderContext
            {
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set { } }
                public WebHostBuilderContext() => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; set { } }
            }
            public static class WebHostDefaults
            {
                public static readonly string ApplicationKey;
                public static readonly string CaptureStartupErrorsKey;
                public static readonly string ContentRootKey;
                public static readonly string DetailedErrorsKey;
                public static readonly string EnvironmentKey;
                public static readonly string HostingStartupAssembliesKey;
                public static readonly string HostingStartupExcludeAssembliesKey;
                public static readonly string HttpPortsKey;
                public static readonly string HttpsPortsKey;
                public static readonly string PreferHostingUrlsKey;
                public static readonly string PreventHostingStartupKey;
                public static readonly string ServerUrlsKey;
                public static readonly string ShutdownTimeoutKey;
                public static readonly string StartupAssemblyKey;
                public static readonly string StaticWebAssetsKey;
                public static readonly string SuppressStatusMessagesKey;
                public static readonly string WebRootKey;
            }
        }
    }
}
