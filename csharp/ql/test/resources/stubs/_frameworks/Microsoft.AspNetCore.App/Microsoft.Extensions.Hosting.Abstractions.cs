// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Hosting.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class ServiceCollectionHostedServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostedService<THostedService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where THostedService : class, Microsoft.Extensions.Hosting.IHostedService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostedService<THostedService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, THostedService> implementationFactory) where THostedService : class, Microsoft.Extensions.Hosting.IHostedService => throw null;
            }

        }
        namespace Hosting
        {
            public abstract class BackgroundService : Microsoft.Extensions.Hosting.IHostedService, System.IDisposable
            {
                protected BackgroundService() => throw null;
                public virtual void Dispose() => throw null;
                protected abstract System.Threading.Tasks.Task ExecuteAsync(System.Threading.CancellationToken stoppingToken);
                public virtual System.Threading.Tasks.Task ExecuteTask { get => throw null; }
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }

            public static class EnvironmentName
            {
                public static string Development;
                public static string Production;
                public static string Staging;
            }

            public static class Environments
            {
                public static string Development;
                public static string Production;
                public static string Staging;
            }

            public class HostAbortedException : System.Exception
            {
                public HostAbortedException() => throw null;
                public HostAbortedException(string message) => throw null;
                public HostAbortedException(string message, System.Exception innerException) => throw null;
            }

            public class HostBuilderContext
            {
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                public HostBuilderContext(System.Collections.Generic.IDictionary<object, object> properties) => throw null;
                public Microsoft.Extensions.Hosting.IHostEnvironment HostingEnvironment { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
            }

            public static class HostDefaults
            {
                public static string ApplicationKey;
                public static string ContentRootKey;
                public static string EnvironmentKey;
            }

            public static class HostEnvironmentEnvExtensions
            {
                public static bool IsDevelopment(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
                public static bool IsEnvironment(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment, string environmentName) => throw null;
                public static bool IsProduction(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
                public static bool IsStaging(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
            }

            public static class HostingAbstractionsHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHost Start(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Extensions.Hosting.IHost> StartAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            public static class HostingAbstractionsHostExtensions
            {
                public static void Run(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task RunAsync(this Microsoft.Extensions.Hosting.IHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static void Start(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task StopAsync(this Microsoft.Extensions.Hosting.IHost host, System.TimeSpan timeout) => throw null;
                public static void WaitForShutdown(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task WaitForShutdownAsync(this Microsoft.Extensions.Hosting.IHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            }

            public static class HostingEnvironmentExtensions
            {
                public static bool IsDevelopment(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsEnvironment(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment, string environmentName) => throw null;
                public static bool IsProduction(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsStaging(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
            }

            public interface IApplicationLifetime
            {
                System.Threading.CancellationToken ApplicationStarted { get; }
                System.Threading.CancellationToken ApplicationStopped { get; }
                System.Threading.CancellationToken ApplicationStopping { get; }
                void StopApplication();
            }

            public interface IHost : System.IDisposable
            {
                System.IServiceProvider Services { get; }
                System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            public interface IHostApplicationLifetime
            {
                System.Threading.CancellationToken ApplicationStarted { get; }
                System.Threading.CancellationToken ApplicationStopped { get; }
                System.Threading.CancellationToken ApplicationStopping { get; }
                void StopApplication();
            }

            public interface IHostBuilder
            {
                Microsoft.Extensions.Hosting.IHost Build();
                Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate);
                Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, TContainerBuilder> configureDelegate);
                Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostConfiguration(System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate);
                Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate);
                System.Collections.Generic.IDictionary<object, object> Properties { get; }
                Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(System.Func<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder>> factory);
                Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory);
            }

            public interface IHostEnvironment
            {
                string ApplicationName { get; set; }
                Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; }
                string ContentRootPath { get; set; }
                string EnvironmentName { get; set; }
            }

            public interface IHostLifetime
            {
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.Task WaitForStartAsync(System.Threading.CancellationToken cancellationToken);
            }

            public interface IHostedService
            {
                System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
            }

            public interface IHostingEnvironment
            {
                string ApplicationName { get; set; }
                Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; }
                string ContentRootPath { get; set; }
                string EnvironmentName { get; set; }
            }

        }
    }
}
