// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.EventLog, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            namespace EventLog
            {
                public class EventLogLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ILoggerProvider, Microsoft.Extensions.Logging.ISupportExternalScope
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public EventLogLoggerProvider() => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.EventLog.EventLogSettings> options) => throw null;
                    public void Dispose() => throw null;
                    public void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider) => throw null;
                }
                public class EventLogSettings
                {
                    public EventLogSettings() => throw null;
                    public System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> Filter { get => throw null; set { } }
                    public string LogName { get => throw null; set { } }
                    public string MachineName { get => throw null; set { } }
                    public string SourceName { get => throw null; set { } }
                }
            }
            public static partial class EventLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggerFactory AddEventLog(this Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                public static Microsoft.Extensions.Logging.ILoggerFactory AddEventLog(this Microsoft.Extensions.Logging.ILoggerFactory factory, Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                public static Microsoft.Extensions.Logging.ILoggerFactory AddEventLog(this Microsoft.Extensions.Logging.ILoggerFactory factory, Microsoft.Extensions.Logging.LogLevel minLevel) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.EventLog.EventLogSettings> configure) => throw null;
            }
        }
    }
}
