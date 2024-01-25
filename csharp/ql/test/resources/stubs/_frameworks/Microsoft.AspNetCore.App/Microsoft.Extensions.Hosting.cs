// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Hosting, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Hosting
        {
            public enum BackgroundServiceExceptionBehavior
            {
                StopHost = 0,
                Ignore = 1,
            }
            public class ConsoleLifetimeOptions
            {
                public ConsoleLifetimeOptions() => throw null;
                public bool SuppressStatusMessages { get => throw null; set { } }
            }
            public static class Host
            {
                public static Microsoft.Extensions.Hosting.HostApplicationBuilder CreateApplicationBuilder() => throw null;
                public static Microsoft.Extensions.Hosting.HostApplicationBuilder CreateApplicationBuilder(Microsoft.Extensions.Hosting.HostApplicationBuilderSettings settings) => throw null;
                public static Microsoft.Extensions.Hosting.HostApplicationBuilder CreateApplicationBuilder(string[] args) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder CreateDefaultBuilder() => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder CreateDefaultBuilder(string[] args) => throw null;
                public static Microsoft.Extensions.Hosting.HostApplicationBuilder CreateEmptyApplicationBuilder(Microsoft.Extensions.Hosting.HostApplicationBuilderSettings settings) => throw null;
            }
            public sealed class HostApplicationBuilder : Microsoft.Extensions.Hosting.IHostApplicationBuilder
            {
                public Microsoft.Extensions.Hosting.IHost Build() => throw null;
                public Microsoft.Extensions.Configuration.ConfigurationManager Configuration { get => throw null; }
                Microsoft.Extensions.Configuration.IConfigurationManager Microsoft.Extensions.Hosting.IHostApplicationBuilder.Configuration { get => throw null; }
                public void ConfigureContainer<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory, System.Action<TContainerBuilder> configure = default(System.Action<TContainerBuilder>)) => throw null;
                public HostApplicationBuilder() => throw null;
                public HostApplicationBuilder(Microsoft.Extensions.Hosting.HostApplicationBuilderSettings settings) => throw null;
                public HostApplicationBuilder(string[] args) => throw null;
                public Microsoft.Extensions.Hosting.IHostEnvironment Environment { get => throw null; }
                public Microsoft.Extensions.Logging.ILoggingBuilder Logging { get => throw null; }
                public Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder Metrics { get => throw null; }
                System.Collections.Generic.IDictionary<object, object> Microsoft.Extensions.Hosting.IHostApplicationBuilder.Properties { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
            }
            public sealed class HostApplicationBuilderSettings
            {
                public string ApplicationName { get => throw null; set { } }
                public string[] Args { get => throw null; set { } }
                public Microsoft.Extensions.Configuration.ConfigurationManager Configuration { get => throw null; set { } }
                public string ContentRootPath { get => throw null; set { } }
                public HostApplicationBuilderSettings() => throw null;
                public bool DisableDefaults { get => throw null; set { } }
                public string EnvironmentName { get => throw null; set { } }
            }
            public class HostBuilder : Microsoft.Extensions.Hosting.IHostBuilder
            {
                public Microsoft.Extensions.Hosting.IHost Build() => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, TContainerBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostConfiguration(System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate) => throw null;
                public HostBuilder() => throw null;
                public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(System.Func<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder>> factory) => throw null;
            }
            public static partial class HostingHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<TContainerBuilder> configureDelegate) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureDefaults(this Microsoft.Extensions.Hosting.IHostBuilder builder, string[] args) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostOptions(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Hosting.HostOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostOptions(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureLogging(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureLogging(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureMetrics(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder> configureMetrics) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureMetrics(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder> configureMetrics) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate) => throw null;
                public static System.Threading.Tasks.Task RunConsoleAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> configureOptions, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task RunConsoleAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseConsoleLifetime(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseConsoleLifetime(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseContentRoot(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, string contentRoot) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseDefaultServiceProvider(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseDefaultServiceProvider(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseEnvironment(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, string environment) => throw null;
            }
            public class HostOptions
            {
                public Microsoft.Extensions.Hosting.BackgroundServiceExceptionBehavior BackgroundServiceExceptionBehavior { get => throw null; set { } }
                public HostOptions() => throw null;
                public bool ServicesStartConcurrently { get => throw null; set { } }
                public bool ServicesStopConcurrently { get => throw null; set { } }
                public System.TimeSpan ShutdownTimeout { get => throw null; set { } }
                public System.TimeSpan StartupTimeout { get => throw null; set { } }
            }
            namespace Internal
            {
                public class ApplicationLifetime : Microsoft.Extensions.Hosting.IApplicationLifetime, Microsoft.Extensions.Hosting.IHostApplicationLifetime
                {
                    public System.Threading.CancellationToken ApplicationStarted { get => throw null; }
                    public System.Threading.CancellationToken ApplicationStopped { get => throw null; }
                    public System.Threading.CancellationToken ApplicationStopping { get => throw null; }
                    public ApplicationLifetime(Microsoft.Extensions.Logging.ILogger<Microsoft.Extensions.Hosting.Internal.ApplicationLifetime> logger) => throw null;
                    public void NotifyStarted() => throw null;
                    public void NotifyStopped() => throw null;
                    public void StopApplication() => throw null;
                }
                public class ConsoleLifetime : System.IDisposable, Microsoft.Extensions.Hosting.IHostLifetime
                {
                    public ConsoleLifetime(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> options, Microsoft.Extensions.Hosting.IHostEnvironment environment, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.HostOptions> hostOptions) => throw null;
                    public ConsoleLifetime(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> options, Microsoft.Extensions.Hosting.IHostEnvironment environment, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.HostOptions> hostOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public void Dispose() => throw null;
                    public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task WaitForStartAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                }
                public class HostingEnvironment : Microsoft.Extensions.Hosting.IHostEnvironment, Microsoft.Extensions.Hosting.IHostingEnvironment
                {
                    public string ApplicationName { get => throw null; set { } }
                    public Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get => throw null; set { } }
                    public string ContentRootPath { get => throw null; set { } }
                    public HostingEnvironment() => throw null;
                    public string EnvironmentName { get => throw null; set { } }
                }
            }
        }
    }
}
