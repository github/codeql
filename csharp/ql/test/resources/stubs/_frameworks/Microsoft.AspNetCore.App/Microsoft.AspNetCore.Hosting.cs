// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Hosting, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            namespace Builder
            {
                public class ApplicationBuilderFactory : Microsoft.AspNetCore.Hosting.Builder.IApplicationBuilderFactory
                {
                    public Microsoft.AspNetCore.Builder.IApplicationBuilder CreateBuilder(Microsoft.AspNetCore.Http.Features.IFeatureCollection serverFeatures) => throw null;
                    public ApplicationBuilderFactory(System.IServiceProvider serviceProvider) => throw null;
                }
                public interface IApplicationBuilderFactory
                {
                    Microsoft.AspNetCore.Builder.IApplicationBuilder CreateBuilder(Microsoft.AspNetCore.Http.Features.IFeatureCollection serverFeatures);
                }
            }
            public class DelegateStartup : Microsoft.AspNetCore.Hosting.StartupBase<Microsoft.Extensions.DependencyInjection.IServiceCollection>
            {
                public override void Configure(Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public DelegateStartup(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<Microsoft.Extensions.DependencyInjection.IServiceCollection> factory, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configureApp) : base(default(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<Microsoft.Extensions.DependencyInjection.IServiceCollection>)) => throw null;
            }
            namespace Infrastructure
            {
                public interface ISupportsConfigureWebHost
                {
                    Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHost(System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure, System.Action<Microsoft.Extensions.Hosting.WebHostBuilderOptions> configureOptions);
                }
                public interface ISupportsStartup
                {
                    Microsoft.AspNetCore.Hosting.IWebHostBuilder Configure(System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configure);
                    Microsoft.AspNetCore.Hosting.IWebHostBuilder Configure(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.AspNetCore.Builder.IApplicationBuilder> configure);
                    Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup(System.Type startupType);
                    Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup<TStartup>(System.Func<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, TStartup> startupFactory);
                }
            }
            namespace Server
            {
                namespace Features
                {
                    public class ServerAddressesFeature : Microsoft.AspNetCore.Hosting.Server.Features.IServerAddressesFeature
                    {
                        public System.Collections.Generic.ICollection<string> Addresses { get => throw null; }
                        public ServerAddressesFeature() => throw null;
                        public bool PreferHostingUrls { get => throw null; set { } }
                    }
                }
            }
            public abstract class StartupBase : Microsoft.AspNetCore.Hosting.IStartup
            {
                public abstract void Configure(Microsoft.AspNetCore.Builder.IApplicationBuilder app);
                System.IServiceProvider Microsoft.AspNetCore.Hosting.IStartup.ConfigureServices(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public virtual void ConfigureServices(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public virtual System.IServiceProvider CreateServiceProvider(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                protected StartupBase() => throw null;
            }
            public abstract class StartupBase<TBuilder> : Microsoft.AspNetCore.Hosting.StartupBase
            {
                public virtual void ConfigureContainer(TBuilder builder) => throw null;
                public override System.IServiceProvider CreateServiceProvider(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public StartupBase(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TBuilder> factory) => throw null;
            }
            namespace StaticWebAssets
            {
                public class StaticWebAssetsLoader
                {
                    public StaticWebAssetsLoader() => throw null;
                    public static void UseStaticWebAssets(Microsoft.AspNetCore.Hosting.IWebHostEnvironment environment, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                }
            }
            public class WebHostBuilder : Microsoft.AspNetCore.Hosting.IWebHostBuilder
            {
                public Microsoft.AspNetCore.Hosting.IWebHost Build() => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureServices(System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureServices) => throw null;
                public WebHostBuilder() => throw null;
                public string GetSetting(string key) => throw null;
                public Microsoft.AspNetCore.Hosting.IWebHostBuilder UseSetting(string key, string value) => throw null;
            }
            public static partial class WebHostBuilderExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder Configure(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configureApp) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder Configure(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.AspNetCore.Builder.IApplicationBuilder> configureApp) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureAppConfiguration(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureLogging(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder ConfigureLogging(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseDefaultServiceProvider(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseDefaultServiceProvider(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup<TStartup>(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Func<Microsoft.AspNetCore.Hosting.WebHostBuilderContext, TStartup> startupFactory) where TStartup : class => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Type startupType) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStartup<TStartup>(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) where TStartup : class => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseStaticWebAssets(this Microsoft.AspNetCore.Hosting.IWebHostBuilder builder) => throw null;
            }
            public static partial class WebHostExtensions
            {
                public static void Run(this Microsoft.AspNetCore.Hosting.IWebHost host) => throw null;
                public static System.Threading.Tasks.Task RunAsync(this Microsoft.AspNetCore.Hosting.IWebHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task StopAsync(this Microsoft.AspNetCore.Hosting.IWebHost host, System.TimeSpan timeout) => throw null;
                public static void WaitForShutdown(this Microsoft.AspNetCore.Hosting.IWebHost host) => throw null;
                public static System.Threading.Tasks.Task WaitForShutdownAsync(this Microsoft.AspNetCore.Hosting.IWebHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            }
        }
        namespace Http
        {
            public class DefaultHttpContextFactory : Microsoft.AspNetCore.Http.IHttpContextFactory
            {
                public Microsoft.AspNetCore.Http.HttpContext Create(Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection) => throw null;
                public DefaultHttpContextFactory(System.IServiceProvider serviceProvider) => throw null;
                public void Dispose(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace Hosting
        {
            public static partial class GenericHostWebHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureSlimWebHost(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure, System.Action<Microsoft.Extensions.Hosting.WebHostBuilderOptions> configureWebHostBuilder) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHost(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHost(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure, System.Action<Microsoft.Extensions.Hosting.WebHostBuilderOptions> configureWebHostBuilder) => throw null;
            }
            public class WebHostBuilderOptions
            {
                public WebHostBuilderOptions() => throw null;
                public bool SuppressEnvironmentConfiguration { get => throw null; set { } }
            }
        }
    }
}
