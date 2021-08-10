// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.EventSourceLoggerFactoryExtensions` in `Microsoft.Extensions.Logging.EventSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EventSourceLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventSourceLogger(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }

            namespace EventSource
            {
                // Generated from `Microsoft.Extensions.Logging.EventSource.EventSourceLoggerProvider` in `Microsoft.Extensions.Logging.EventSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EventSourceLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public void Dispose() => throw null;
                    public EventSourceLoggerProvider(Microsoft.Extensions.Logging.EventSource.LoggingEventSource eventSource) => throw null;
                }

                // Generated from `Microsoft.Extensions.Logging.EventSource.LoggingEventSource` in `Microsoft.Extensions.Logging.EventSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LoggingEventSource : System.Diagnostics.Tracing.EventSource
                {
                    // Generated from `Microsoft.Extensions.Logging.EventSource.LoggingEventSource+Keywords` in `Microsoft.Extensions.Logging.EventSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
