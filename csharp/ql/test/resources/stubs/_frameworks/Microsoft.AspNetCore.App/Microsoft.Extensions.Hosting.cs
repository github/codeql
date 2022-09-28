// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.OptionsBuilderExtensions` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class OptionsBuilderExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> ValidateOnStart<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder) where TOptions : class => throw null;
            }

        }
        namespace Hosting
        {
            // Generated from `Microsoft.Extensions.Hosting.BackgroundServiceExceptionBehavior` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum BackgroundServiceExceptionBehavior : int
            {
                Ignore = 1,
                StopHost = 0,
            }

            // Generated from `Microsoft.Extensions.Hosting.ConsoleLifetimeOptions` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConsoleLifetimeOptions
            {
                public ConsoleLifetimeOptions() => throw null;
                public bool SuppressStatusMessages { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.Hosting.Host` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Host
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder CreateDefaultBuilder() => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder CreateDefaultBuilder(string[] args) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostBuilder` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HostBuilder : Microsoft.Extensions.Hosting.IHostBuilder
            {
                public Microsoft.Extensions.Hosting.IHost Build() => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, TContainerBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostConfiguration(System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate) => throw null;
                public HostBuilder() => throw null;
                public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(System.Func<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder>> factory) => throw null;
                public Microsoft.Extensions.Hosting.IHostBuilder UseServiceProviderFactory<TContainerBuilder>(Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<TContainerBuilder> factory) => throw null;
            }

            // Generated from `Microsoft.Extensions.Hosting.HostOptions` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HostOptions
            {
                public Microsoft.Extensions.Hosting.BackgroundServiceExceptionBehavior BackgroundServiceExceptionBehavior { get => throw null; set => throw null; }
                public HostOptions() => throw null;
                public System.TimeSpan ShutdownTimeout { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.Hosting.HostingHostBuilderExtensions` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostingHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureAppConfiguration(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Configuration.IConfigurationBuilder> configureDelegate) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureContainer<TContainerBuilder>(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<TContainerBuilder> configureDelegate) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureDefaults(this Microsoft.Extensions.Hosting.IHostBuilder builder, string[] args) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostOptions(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Hosting.HostOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureHostOptions(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureLogging(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureLogging(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configureLogging) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureServices(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.DependencyInjection.IServiceCollection> configureDelegate) => throw null;
                public static System.Threading.Tasks.Task RunConsoleAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> configureOptions, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task RunConsoleAsync(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseConsoleLifetime(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseConsoleLifetime(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseContentRoot(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, string contentRoot) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseDefaultServiceProvider(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.Hosting.HostBuilderContext, Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseDefaultServiceProvider(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, System.Action<Microsoft.Extensions.DependencyInjection.ServiceProviderOptions> configure) => throw null;
                public static Microsoft.Extensions.Hosting.IHostBuilder UseEnvironment(this Microsoft.Extensions.Hosting.IHostBuilder hostBuilder, string environment) => throw null;
            }

            namespace Internal
            {
                // Generated from `Microsoft.Extensions.Hosting.Internal.ApplicationLifetime` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApplicationLifetime : Microsoft.Extensions.Hosting.IApplicationLifetime, Microsoft.Extensions.Hosting.IHostApplicationLifetime
                {
                    public ApplicationLifetime(Microsoft.Extensions.Logging.ILogger<Microsoft.Extensions.Hosting.Internal.ApplicationLifetime> logger) => throw null;
                    public System.Threading.CancellationToken ApplicationStarted { get => throw null; }
                    public System.Threading.CancellationToken ApplicationStopped { get => throw null; }
                    public System.Threading.CancellationToken ApplicationStopping { get => throw null; }
                    public void NotifyStarted() => throw null;
                    public void NotifyStopped() => throw null;
                    public void StopApplication() => throw null;
                }

                // Generated from `Microsoft.Extensions.Hosting.Internal.ConsoleLifetime` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConsoleLifetime : Microsoft.Extensions.Hosting.IHostLifetime, System.IDisposable
                {
                    public ConsoleLifetime(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> options, Microsoft.Extensions.Hosting.IHostEnvironment environment, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.HostOptions> hostOptions) => throw null;
                    public ConsoleLifetime(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.ConsoleLifetimeOptions> options, Microsoft.Extensions.Hosting.IHostEnvironment environment, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Hosting.HostOptions> hostOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public void Dispose() => throw null;
                    public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task WaitForStartAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                }

                // Generated from `Microsoft.Extensions.Hosting.Internal.HostingEnvironment` in `Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HostingEnvironment : Microsoft.Extensions.Hosting.IHostEnvironment, Microsoft.Extensions.Hosting.IHostingEnvironment
                {
                    public string ApplicationName { get => throw null; set => throw null; }
                    public Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get => throw null; set => throw null; }
                    public string ContentRootPath { get => throw null; set => throw null; }
                    public string EnvironmentName { get => throw null; set => throw null; }
                    public HostingEnvironment() => throw null;
                }

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
            /* Duplicate type 'DynamicallyAccessedMemberTypes' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'DynamicallyAccessedMembersAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'SupportedOSPlatformGuardAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'UnsupportedOSPlatformGuardAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Hosting, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
