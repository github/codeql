// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceCollectionHostedServiceExtensions` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ServiceCollectionHostedServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostedService<THostedService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, THostedService> implementationFactory) where THostedService : class, Microsoft.Extensions.Hosting.IHostedService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostedService<THostedService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where THostedService : class, Microsoft.Extensions.Hosting.IHostedService => throw null;
            }

        }
        namespace Hosting
        {
            // Generated from `Microsoft.Extensions.Hosting.BackgroundService` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class BackgroundService : System.IDisposable, Microsoft.Extensions.Hosting.IHostedService
            {
                protected BackgroundService() => throw null;
                public virtual void Dispose() => throw null;
                protected abstract System.Threading.Tasks.Task ExecuteAsync(System.Threading.CancellationToken stoppingToken);
                public virtual System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.EnvironmentName` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EnvironmentName
            {
                public static string Development;
                public static string Production;
                public static string Staging;
            }

            // Generated from `Microsoft.Extensions.Hosting.Environments` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Environments
            {
                public static string Development;
                public static string Production;
                public static string Staging;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostBuilderContext` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HostBuilderContext
            {
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                public HostBuilderContext(System.Collections.Generic.IDictionary<object, object> properties) => throw null;
                public Microsoft.Extensions.Hosting.IHostEnvironment HostingEnvironment { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Hosting.HostDefaults` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostDefaults
            {
                public static string ApplicationKey;
                public static string ContentRootKey;
                public static string EnvironmentKey;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostEnvironmentEnvExtensions` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostEnvironmentEnvExtensions
            {
                public static bool IsDevelopment(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
                public static bool IsEnvironment(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment, string environmentName) => throw null;
                public static bool IsProduction(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
                public static bool IsStaging(this Microsoft.Extensions.Hosting.IHostEnvironment hostEnvironment) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostingAbstractionsHostBuilderExtensions` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostingAbstractionsHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHost Start(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Extensions.Hosting.IHost> StartAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostingAbstractionsHostExtensions` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostingAbstractionsHostExtensions
            {
                public static void Run(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task RunAsync(this Microsoft.Extensions.Hosting.IHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static void Start(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task StopAsync(this Microsoft.Extensions.Hosting.IHost host, System.TimeSpan timeout) => throw null;
                public static void WaitForShutdown(this Microsoft.Extensions.Hosting.IHost host) => throw null;
                public static System.Threading.Tasks.Task WaitForShutdownAsync(this Microsoft.Extensions.Hosting.IHost host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostingEnvironmentExtensions` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostingEnvironmentExtensions
            {
                public static bool IsDevelopment(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsEnvironment(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment, string environmentName) => throw null;
                public static bool IsProduction(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
                public static bool IsStaging(this Microsoft.Extensions.Hosting.IHostingEnvironment hostingEnvironment) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.IApplicationLifetime` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IApplicationLifetime
            {
                System.Threading.CancellationToken ApplicationStarted { get; }
                System.Threading.CancellationToken ApplicationStopped { get; }
                System.Threading.CancellationToken ApplicationStopping { get; }
                void StopApplication();
            }

            // Generated from `Microsoft.Extensions.Hosting.IHost` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHost : System.IDisposable
            {
                System.IServiceProvider Services { get; }
                System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.Extensions.Hosting.IHostApplicationLifetime` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHostApplicationLifetime
            {
                System.Threading.CancellationToken ApplicationStarted { get; }
                System.Threading.CancellationToken ApplicationStopped { get; }
                System.Threading.CancellationToken ApplicationStopping { get; }
                void StopApplication();
            }

            // Generated from `Microsoft.Extensions.Hosting.IHostBuilder` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.Extensions.Hosting.IHostEnvironment` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHostEnvironment
            {
                string ApplicationName { get; set; }
                Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; }
                string ContentRootPath { get; set; }
                string EnvironmentName { get; set; }
            }

            // Generated from `Microsoft.Extensions.Hosting.IHostLifetime` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHostLifetime
            {
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.Task WaitForStartAsync(System.Threading.CancellationToken cancellationToken);
            }

            // Generated from `Microsoft.Extensions.Hosting.IHostedService` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHostedService
            {
                System.Threading.Tasks.Task StartAsync(System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken);
            }

            // Generated from `Microsoft.Extensions.Hosting.IHostingEnvironment` in `Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'DynamicallyAccessedMemberTypes' is not stubbed in this assembly 'Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'DynamicallyAccessedMembersAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
