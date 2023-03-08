// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.EventLog, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public static class EventLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.EventLog.EventLogSettings> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
            }

            namespace EventLog
            {
                public class EventLogLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, Microsoft.Extensions.Logging.ISupportExternalScope, System.IDisposable
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public EventLogLoggerProvider() => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.EventLog.EventLogSettings> options) => throw null;
                    public void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider) => throw null;
                }

                public class EventLogSettings
                {
                    public EventLogSettings() => throw null;
                    public System.Func<string, Microsoft.Extensions.Logging.LogLevel, bool> Filter { get => throw null; set => throw null; }
                    public string LogName { get => throw null; set => throw null; }
                    public string MachineName { get => throw null; set => throw null; }
                    public string SourceName { get => throw null; set => throw null; }
                }

            }
        }
    }
}
