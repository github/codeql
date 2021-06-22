// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.LoggingBuilderExtensions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class LoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConfiguration(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
            }

            namespace Configuration
            {
                // Generated from `Microsoft.Extensions.Logging.Configuration.ILoggerProviderConfiguration<>` in `Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ILoggerProviderConfiguration<T>
                {
                    Microsoft.Extensions.Configuration.IConfiguration Configuration { get; }
                }

                // Generated from `Microsoft.Extensions.Logging.Configuration.ILoggerProviderConfigurationFactory` in `Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ILoggerProviderConfigurationFactory
                {
                    Microsoft.Extensions.Configuration.IConfiguration GetConfiguration(System.Type providerType);
                }

                // Generated from `Microsoft.Extensions.Logging.Configuration.LoggerProviderOptions` in `Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class LoggerProviderOptions
                {
                    public static void RegisterProviderOptions<TOptions, TProvider>(Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TOptions : class => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Configuration.LoggerProviderOptionsChangeTokenSource<,>` in `Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LoggerProviderOptionsChangeTokenSource<TOptions, TProvider> : Microsoft.Extensions.Options.ConfigurationChangeTokenSource<TOptions>
                {
                    public LoggerProviderOptionsChangeTokenSource(Microsoft.Extensions.Logging.Configuration.ILoggerProviderConfiguration<TProvider> providerConfiguration) : base(default(Microsoft.Extensions.Configuration.IConfiguration)) => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Configuration.LoggingBuilderConfigurationExtensions` in `Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class LoggingBuilderConfigurationExtensions
                {
                    public static void AddConfiguration(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                }

            }
        }
    }
}
