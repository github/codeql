// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.Configuration, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public static partial class LoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConfiguration(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
            }

            namespace Configuration
            {
                public interface ILoggerProviderConfiguration<T>
                {
                    Microsoft.Extensions.Configuration.IConfiguration Configuration { get; }
                }

                public interface ILoggerProviderConfigurationFactory
                {
                    Microsoft.Extensions.Configuration.IConfiguration GetConfiguration(System.Type providerType);
                }

                public static class LoggerProviderOptions
                {
                    public static void RegisterProviderOptions<TOptions, TProvider>(Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TOptions : class => throw null;
                }

                public class LoggerProviderOptionsChangeTokenSource<TOptions, TProvider> : Microsoft.Extensions.Options.ConfigurationChangeTokenSource<TOptions>
                {
                    public LoggerProviderOptionsChangeTokenSource(Microsoft.Extensions.Logging.Configuration.ILoggerProviderConfiguration<TProvider> providerConfiguration) : base(default(Microsoft.Extensions.Configuration.IConfiguration)) => throw null;
                }

                public static class LoggingBuilderConfigurationExtensions
                {
                    public static void AddConfiguration(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                }

            }
        }
    }
}
