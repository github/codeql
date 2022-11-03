// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.LoggingServiceCollectionExtensions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LoggingServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.ActivityTrackingOptions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            [System.Flags]
            public enum ActivityTrackingOptions
            {
                None,
                ParentId,
                SpanId,
                TraceFlags,
                TraceId,
                TraceState,
            }

            // Generated from `Microsoft.Extensions.Logging.FilterLoggingBuilderExtensions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class FilterLoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, Microsoft.Extensions.Logging.LogLevel level) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter<T>(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, string category, Microsoft.Extensions.Logging.LogLevel level) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) => throw null;
                public static Microsoft.Extensions.Logging.LoggerFilterOptions AddFilter(this Microsoft.Extensions.Logging.LoggerFilterOptions builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, Microsoft.Extensions.Logging.LogLevel level) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter<T>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) where T : Microsoft.Extensions.Logging.ILoggerProvider => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string category, Microsoft.Extensions.Logging.LogLevel level) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> categoryLevelFilter) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddFilter(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Func<Microsoft.Extensions.Logging.LogLevel, bool> levelFilter) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.ILoggingBuilder` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ILoggingBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerFactory` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LoggerFactory : System.IDisposable, Microsoft.Extensions.Logging.ILoggerFactory
            {
                public void AddProvider(Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                protected virtual bool CheckDisposed() => throw null;
                public static Microsoft.Extensions.Logging.ILoggerFactory Create(System.Action<Microsoft.Extensions.Logging.ILoggingBuilder> configure) => throw null;
                public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                public void Dispose() => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.LoggerFilterOptions> filterOption, Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.LoggerFactoryOptions> options = default(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.LoggerFactoryOptions>)) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.LoggerFilterOptions> filterOption) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers, Microsoft.Extensions.Logging.LoggerFilterOptions filterOptions) => throw null;
                public LoggerFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.ILoggerProvider> providers) => throw null;
                public LoggerFactory() => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerFactoryOptions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LoggerFactoryOptions
            {
                public Microsoft.Extensions.Logging.ActivityTrackingOptions ActivityTrackingOptions { get => throw null; set => throw null; }
                public LoggerFactoryOptions() => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerFilterOptions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LoggerFilterOptions
            {
                public bool CaptureScopes { get => throw null; set => throw null; }
                public LoggerFilterOptions() => throw null;
                public Microsoft.Extensions.Logging.LogLevel MinLevel { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Microsoft.Extensions.Logging.LoggerFilterRule> Rules { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Logging.LoggerFilterRule` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LoggerFilterRule
            {
                public string CategoryName { get => throw null; }
                public System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> Filter { get => throw null; }
                public Microsoft.Extensions.Logging.LogLevel? LogLevel { get => throw null; }
                public LoggerFilterRule(string providerName, string categoryName, Microsoft.Extensions.Logging.LogLevel? logLevel, System.Func<string, string, Microsoft.Extensions.Logging.LogLevel, bool> filter) => throw null;
                public string ProviderName { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.LoggingBuilderExtensions` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.Extensions.Logging.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class LoggingBuilderExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddProvider(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.ILoggerProvider provider) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder ClearProviders(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder Configure(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.LoggerFactoryOptions> action) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder SetMinimumLevel(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.LogLevel level) => throw null;
            }

            // Generated from `Microsoft.Extensions.Logging.ProviderAliasAttribute` in `Microsoft.Extensions.Logging, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProviderAliasAttribute : System.Attribute
            {
                public string Alias { get => throw null; }
                public ProviderAliasAttribute(string alias) => throw null;
            }

        }
    }
}
