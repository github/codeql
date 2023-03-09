// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Hosting.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static class EnvironmentName
            {
                public static string Development;
                public static string Production;
                public static string Staging;
            }

            public static class HostingAbstractionsWebHostBuilderExtensions
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

            public class HostingStartupAttribute : System.Attribute
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
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; set => throw null; }
                public WebHostBuilderContext() => throw null;
            }

            public static class WebHostDefaults
            {
                public static string ApplicationKey;
                public static string CaptureStartupErrorsKey;
                public static string ContentRootKey;
                public static string DetailedErrorsKey;
                public static string EnvironmentKey;
                public static string HostingStartupAssembliesKey;
                public static string HostingStartupExcludeAssembliesKey;
                public static string PreferHostingUrlsKey;
                public static string PreventHostingStartupKey;
                public static string ServerUrlsKey;
                public static string ShutdownTimeoutKey;
                public static string StartupAssemblyKey;
                public static string StaticWebAssetsKey;
                public static string SuppressStatusMessagesKey;
                public static string WebRootKey;
            }

        }
    }
}
