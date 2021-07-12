// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.EventLoggerFactoryExtensions` in `Microsoft.Extensions.Logging.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EventLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Action<Microsoft.Extensions.Logging.EventLog.EventLogSettings> configure) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder, Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventLog(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }

            namespace EventLog
            {
                // Generated from `Microsoft.Extensions.Logging.EventLog.EventLogLoggerProvider` in `Microsoft.Extensions.Logging.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EventLogLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ISupportExternalScope, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Logging.EventLog.EventLogSettings> options) => throw null;
                    public EventLogLoggerProvider(Microsoft.Extensions.Logging.EventLog.EventLogSettings settings) => throw null;
                    public EventLogLoggerProvider() => throw null;
                    public void SetScopeProvider(Microsoft.Extensions.Logging.IExternalScopeProvider scopeProvider) => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.EventLog.EventLogSettings` in `Microsoft.Extensions.Logging.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
