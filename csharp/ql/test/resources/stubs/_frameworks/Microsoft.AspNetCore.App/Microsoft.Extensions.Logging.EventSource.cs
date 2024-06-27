// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.EventSource, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            namespace EventSource
            {
                public class EventSourceLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string categoryName) => throw null;
                    public EventSourceLoggerProvider(Microsoft.Extensions.Logging.EventSource.LoggingEventSource eventSource) => throw null;
                    public void Dispose() => throw null;
                }
                public sealed class LoggingEventSource : System.Diagnostics.Tracing.EventSource
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
            public static partial class EventSourceLoggerFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggerFactory AddEventSourceLogger(this Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddEventSourceLogger(this Microsoft.Extensions.Logging.ILoggingBuilder builder) => throw null;
            }
        }
    }
}
