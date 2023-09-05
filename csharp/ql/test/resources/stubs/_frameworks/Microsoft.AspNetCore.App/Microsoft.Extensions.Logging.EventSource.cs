// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.EventSource, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            namespace EventSource
            {
                public class EventSourceLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, System.IDisposable
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public EventSourceLoggerProvider(Microsoft.Extensions.Logging.EventSource.LoggingEventSource eventSource) => throw null;
                    public void Dispose() => throw null;
                }
                public sealed class LoggingEventSource : System.Diagnostics.Tracing.EventSource
                {
                    public static class Keywords
                    {
                        public static System.Diagnostics.Tracing.EventKeywords FormattedMessage;
                        public static System.Diagnostics.Tracing.EventKeywords JsonMessage;
                        public static System.Diagnostics.Tracing.EventKeywords Message;
                        public static System.Diagnostics.Tracing.EventKeywords Meta;
                    }
                    protected override void OnEventCommand(System.Diagnostics.Tracing.EventCommandEventArgs command) => throw null;
                }
            }
            public static partial class EventSourceLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventSourceLogger(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }
        }
    }
}
