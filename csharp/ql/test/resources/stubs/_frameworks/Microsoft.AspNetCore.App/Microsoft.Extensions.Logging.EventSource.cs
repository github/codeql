// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.EventSource, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public static class EventSourceLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventSourceLogger(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }

            namespace EventSource
            {
                public class EventSourceLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, System.IDisposable
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public void Dispose() => throw null;
                    public EventSourceLoggerProvider(Microsoft.Extensions.Logging.EventSource.LoggingEventSource eventSource) => throw null;
                }

                public class LoggingEventSource : System.Diagnostics.Tracing.EventSource
                {
                    public static class Keywords
                    {
                        public const System.Diagnostics.Tracing.EventKeywords FormattedMessage = default;
                        public const System.Diagnostics.Tracing.EventKeywords JsonMessage = default;
                        public const System.Diagnostics.Tracing.EventKeywords Message = default;
                        public const System.Diagnostics.Tracing.EventKeywords Meta = default;
                    }


                    protected override void OnEventCommand(System.Diagnostics.Tracing.EventCommandEventArgs command) => throw null;
                }

            }
        }
    }
}
