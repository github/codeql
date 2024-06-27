// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class LoggingServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configure) => throw null;
            }
        }
        namespace Logging
        {
            [System.Flags]
            public enum ActivityTrackingOptions
            {
                None = 0,
                SpanId = 1,
                TraceId = 2,
                ParentId = 4,
                TraceState = 8,
                TraceFlags = 16,
                Tags = 32,
                Baggage = 64,
            }
            public static partial class FilterLoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, Microsoft.Extensions.Logging.LogLevel level) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, Microsoft.Extensions.Logging.LogLevel level) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, Microsoft.Extensions.Logging.LogLevel level) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, Microsoft.Extensions.Logging.LogLevel level) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
            }
            public class LoggerFactory : System.IDisposable, Microsoft.Extensions.Logging.ILoggerFactory
            {
                public void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                protected virtual bool CheckDisposed() => throw null;
                public static Microsoft.Extensions.Logging.ILoggerFactory Create(System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configure) => throw null;
                public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                public LoggerFactory() => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Logging.LoggerFilterOptions filterOptions) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.LoggerFilterOptions> filterOption) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.LoggerFilterOptions> filterOption, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.LoggerFactoryOptions> options) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.LoggerFilterOptions> filterOption, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.LoggerFactoryOptions> options = default(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.LoggerFactoryOptions>), Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider = default(Microsoft.Extensions.Logging.IExternalScopeProvider)) => throw null;
                public void Dispose() => throw null;
            }
            public class LoggerFactoryOptions
            {
                public Microsoft.Extensions.Logging.ActivityTrackingOptions ActivityTrackingOptions { get => throw null; set { } }
                public LoggerFactoryOptions() => throw null;
            }
            public class LoggerFilterOptions
            {
                public bool CaptureScopes { get => throw null; set { } }
                public LoggerFilterOptions() => throw null;
                public Microsoft.Extensions.Logging.LogLevel MinLevel { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.Extensions.Logging.LoggerFilterRule> Rules { get => throw null; }
            }
            public class LoggerFilterRule
            {
                public string CategoryName { get => throw null; }
                public LoggerFilterRule(string providerName, string categoryName, Microsoft.Extensions.Logging.LogLevel? logLevel, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> Filter { get => throw null; }
                public Microsoft.Extensions.Logging.LogLevel? LogLevel { get => throw null; }
                public string ProviderName { get => throw null; }
                public override string ToString() => throw null;
            }
            public static partial class LoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddProvider(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder ClearProviders(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder Configure(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.LoggerFactoryOptions> action) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder SetMinimumLevel(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.LogLevel level) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = false)]
            public class ProviderAliasAttribute : System.Attribute
            {
                public string Alias { get => throw null; }
                public ProviderAliasAttribute(string alias) => throw null;
            }
        }
    }
}
