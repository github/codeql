// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.ConsoleLoggerExtensions` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConsoleLoggerExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsoleFormatter<TFormatter, TOptions>(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<TOptions> configure) where TFormatter : Microsoft.Extensions.Logging.Console.ConsoleFormatter where TOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddConsoleFormatter<TFormatter, TOptions>(this Microsoft.Extensions.Logging.ILoggingBuilder builder) where TFormatter : Microsoft.Extensions.Logging.Console.ConsoleFormatter where TOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddJsonConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.JsonConsoleFormatterOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddJsonConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSimpleConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.SimpleConsoleFormatterOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSimpleConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSystemdConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddSystemdConsole(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }

            namespace Console
            {
                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleFormatter` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ConsoleFormatter
                {
                    protected ConsoleFormatter(string name) => throw null;
                    public string Name { get => throw null; }
                    public abstract void Write<TState>(Microsoft.Extensions.Logging.Abstractions.LogEntry<TState> logEntry, Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider, System.IO.TextWriter textWriter);
                }

                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleFormatterNames` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ConsoleFormatterNames
                {
                    public const string Json = default;
                    public const string Simple = default;
                    public const string Systemd = default;
                }

                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConsoleFormatterOptions
                {
                    public ConsoleFormatterOptions() => throw null;
                    public bool IncludeScopes { get => throw null; set => throw null; }
                    public string TimestampFormat { get => throw null; set => throw null; }
                    public bool UseUtcTimestamp { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleLoggerFormat` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ConsoleLoggerFormat
                {
                    Default,
                    Systemd,
                }

                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConsoleLoggerOptions
                {
                    public ConsoleLoggerOptions() => throw null;
                    public bool DisableColors { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Logging.Console.ConsoleLoggerFormat Format { get => throw null; set => throw null; }
                    public string FormatterName { get => throw null; set => throw null; }
                    public bool IncludeScopes { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Logging.LogLevel LogToStandardErrorThreshold { get => throw null; set => throw null; }
                    public string TimestampFormat { get => throw null; set => throw null; }
                    public bool UseUtcTimestamp { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Logging.Console.ConsoleLoggerProvider` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConsoleLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ISupportExternalScope, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public ConsoleLoggerProvider(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> options, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Logging.Console.ConsoleFormatter> formatters) => throw null;
                    public ConsoleLoggerProvider(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Extensions.Logging.Console.ConsoleLoggerOptions> options) => throw null;
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider) => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.Console.JsonConsoleFormatterOptions` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JsonConsoleFormatterOptions : Microsoft.Extensions.Logging.Console.ConsoleFormatterOptions
                {
                    public JsonConsoleFormatterOptions() => throw null;
                    public System.Text.Json.JsonWriterOptions JsonWriterOptions { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Logging.Console.LoggerColorBehavior` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum LoggerColorBehavior
                {
                    Default,
                    Disabled,
                    Enabled,
                }

                // Generated from `Microsoft.Extensions.Logging.Console.SimpleConsoleFormatterOptions` in `Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'DynamicallyAccessedMemberTypes' is not stubbed in this assembly 'Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'DynamicallyAccessedMembersAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Logging.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
