using System;
using Microsoft.Extensions.DependencyInjection;

namespace Serilog
{
    public interface ILogger
    {
        void Information(string messageTemplate, params object[] propertyValues);
    }

    public static class Log
    {
        public static ILogger Logger { get; set; }
    }

    public class LoggerConfiguration
    {
        public Configuration.LoggerSinkConfiguration WriteTo => throw null;
        public Configuration.LoggerAuditSinkConfiguration AuditTo => throw null;
        public Configuration.LoggerSettingsConfiguration ReadFrom => throw null;
        public Configuration.LoggerEnrichmentConfiguration Enrich => throw null;
        public Core.Logger CreateLogger() => throw null;
    }

    public static class LoggerConfigurationExtensions
    {
        public static Extensions.Hosting.ReloadableLogger CreateBootstrapLogger(
            this LoggerConfiguration configuration) => throw null;
    }

    public static class ConsoleLoggerConfigurationExtensions
    {
        public static LoggerConfiguration Console(
            this Configuration.LoggerSinkConfiguration sinkConfiguration,
            Formatting.ITextFormatter formatter) => throw null;

        public static LoggerConfiguration Console(
            this Configuration.LoggerSinkConfiguration sinkConfiguration) => throw null;
    }

    public static class ConsoleAuditLoggerConfigurationExtensions
    {
        public static LoggerConfiguration Console(
            this Configuration.LoggerAuditSinkConfiguration sinkConfiguration) => throw null;

        public static LoggerConfiguration Console(
            this Configuration.LoggerAuditSinkConfiguration sinkConfiguration,
            Formatting.ITextFormatter formatter) => throw null;
    }

    public static class FileLoggerConfigurationExtensions
    {
        public static LoggerConfiguration File(
            this Configuration.LoggerSinkConfiguration sinkConfiguration,
            Formatting.ITextFormatter formatter,
            string path) => throw null;
    }

    public static class LoggerConfigurationAsyncExtensions
    {
        public static LoggerConfiguration Async(
            this Configuration.LoggerSinkConfiguration sinkConfiguration,
            Action<Configuration.LoggerSinkConfiguration> configure) => throw null;
    }

    public static class ConfigurationLoggerConfigurationExtensions
    {
        public static LoggerConfiguration Configuration(
            this Configuration.LoggerSettingsConfiguration settings,
            Microsoft.Extensions.Configuration.IConfiguration configuration,
            Settings.Configuration.ConfigurationReaderOptions readerOptions = null) => throw null;
    }

    public static class LoggerSettingsConfigurationExtensions
    {
        public static LoggerConfiguration Services(
            this Configuration.LoggerSettingsConfiguration settings,
            IServiceProvider services) => throw null;
    }

    public static class SerilogServiceCollectionExtensions
    {
        public static IServiceCollection AddSerilog(
            this IServiceCollection collection,
            Action<IServiceProvider, LoggerConfiguration> configure,
            bool preserveStaticLogger = false,
            bool writeToProviders = false) => throw null;

        public static IServiceCollection AddSerilog(
            this IServiceCollection collection,
            Action<LoggerConfiguration> configure,
            bool preserveStaticLogger = false,
            bool writeToProviders = false) => throw null;
    }
}

namespace Serilog.Settings.Configuration
{
    public class ConfigurationReaderOptions { }
}

namespace Serilog.Core
{
    public sealed class Logger : Serilog.ILogger, IDisposable
    {
        public void Information(string messageTemplate, params object[] propertyValues) => throw null;
        public void Dispose() => throw null;
    }
}

namespace Serilog.Extensions.Hosting
{
    public sealed class ReloadableLogger : Serilog.ILogger
    {
        public void Information(string messageTemplate, params object[] propertyValues) => throw null;
    }
}

namespace Serilog.Configuration
{
    public class LoggerSinkConfiguration { }
    public class LoggerAuditSinkConfiguration { }
    public class LoggerEnrichmentConfiguration
    {
        public Serilog.LoggerConfiguration FromLogContext() => throw null;
        public Serilog.LoggerConfiguration WithProperty(string name, object value) => throw null;
    }
    public class LoggerFilterConfiguration { }
    public class LoggerMinimumLevelConfiguration { }
    public class LoggerSettingsConfiguration { }
    public class LoggerDestructuringConfiguration { }
}

namespace Serilog.Formatting
{
    public interface ITextFormatter { }
}

namespace Serilog.Formatting.Json
{
    public class JsonValueFormatter
    {
        public JsonValueFormatter(string typeTagName = "_typeTag") { }
    }

    public class JsonFormatter : Serilog.Formatting.ITextFormatter
    {
        public JsonFormatter(
            string closingDelimiter = null,
            bool renderMessage = false,
            IFormatProvider formatProvider = null) { }
    }
}

namespace Serilog.Formatting.Compact
{
    public class CompactJsonFormatter : Serilog.Formatting.ITextFormatter
    {
        public CompactJsonFormatter(Serilog.Formatting.Json.JsonValueFormatter valueFormatter = null) { }
    }

    public class RenderedCompactJsonFormatter : Serilog.Formatting.ITextFormatter
    {
        public RenderedCompactJsonFormatter(
            Serilog.Formatting.Json.JsonValueFormatter valueFormatter = null) { }
    }
}
