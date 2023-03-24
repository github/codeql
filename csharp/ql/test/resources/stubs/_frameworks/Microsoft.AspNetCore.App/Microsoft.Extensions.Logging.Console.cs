// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.Console, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public static class ConsoleLoggerExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsoleFormatter<TFormatter, TOptions>(this Microsoft.Extensions.Logging.ILoggingBuilder builder) where TFormatter : Microsoft.Extensions.Logging.Console.ConsoleFormatter where TOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsoleFormatter<TFormatter, TOptions>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<TOptions> configure) where TFormatter : Microsoft.Extensions.Logging.Console.ConsoleFormatter where TOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddJsonConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddJsonConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.JsonConsoleFormatterOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSimpleConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSimpleConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.SimpleConsoleFormatterOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSystemdConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSystemdConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions> configure) => throw null;
            }

            namespace Console
            {
                public abstract class ConsoleFormatter
                {
                    protected ConsoleFormatter(string name) => throw null;
                    public string Name { get => throw null; }
                    public abstract void Write<TState>(Microsoft.Extensions.Logging.Abstractions.LogEntry<TState> logEntry, Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider, System.IO.TextWriter textWriter);
                }

                public static class ConsoleFormatterNames
                {
                    public const string Json = default;
                    public const string Simple = default;
                    public const string Systemd = default;
                }

                public class ConsoleFormatterOptions
                {
                    public ConsoleFormatterOptions() => throw null;
                    public bool IncludeScopes { get => throw null; set => throw null; }
                    public string TimestampFormat { get => throw null; set => throw null; }
                    public bool UseUtcTimestamp { get => throw null; set => throw null; }
                }

                public enum ConsoleLoggerFormat : int
                {
                    Default = 0,
                    Systemd = 1,
                }

                public class ConsoleLoggerOptions
                {
                    public ConsoleLoggerOptions() => throw null;
                    public bool DisableColors { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Logging.Console.ConsoleLoggerFormat Format { get => throw null; set => throw null; }
                    public string FormatterName { get => throw null; set => throw null; }
                    public bool IncludeScopes { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Logging.LogLevel LogToStandardErrorThreshold { get => throw null; set => throw null; }
                    public int MaxQueueLength { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Logging.Console.ConsoleLoggerQueueFullMode QueueFullMode { get => throw null; set => throw null; }
                    public string TimestampFormat { get => throw null; set => throw null; }
                    public bool UseUtcTimestamp { get => throw null; set => throw null; }
                }

                public class ConsoleLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, Microsoft.Extensions.Logging.ISupportExternalScope, System.IDisposable
                {
                    public ConsoleLoggerProvider(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> options) => throw null;
                    public ConsoleLoggerProvider(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> options, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.Console.ConsoleFormatter> formatters) => throw null;
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider) => throw null;
                }

                public enum ConsoleLoggerQueueFullMode : int
                {
                    DropWrite = 1,
                    Wait = 0,
                }

                public class JsonConsoleFormatterOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions
                {
                    public JsonConsoleFormatterOptions() => throw null;
                    public System.Text.Json.JsonWriterOptions JsonWriterOptions { get => throw null; set => throw null; }
                }

                public enum LoggerColorBehavior : int
                {
                    Default = 0,
                    Disabled = 2,
                    Enabled = 1,
                }

                public class SimpleConsoleFormatterOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions
                {
                    public Microsoft.Extensions.Logging.Console.LoggerColorBehavior ColorBehavior { get => throw null; set => throw null; }
                    public SimpleConsoleFormatterOptions() => throw null;
                    public bool SingleLine { get => throw null; set => throw null; }
                }

            }
        }
    }
}
