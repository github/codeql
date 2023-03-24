// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Logging.TraceSource, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            public static class TraceSourceFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Diagnostics.SourceSwitch sourceSwitch) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Diagnostics.SourceSwitch sourceSwitch, System.Diagnostics.TraceListener listener) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string switchName) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string switchName, System.Diagnostics.TraceListener listener) => throw null;
            }

            namespace TraceSource
            {
                public class TraceSourceLoggerProvider : Microsoft.Extensions.Logging.ILoggerProvider, System.IDisposable
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public TraceSourceLoggerProvider(System.Diagnostics.SourceSwitch rootSourceSwitch) => throw null;
                    public TraceSourceLoggerProvider(System.Diagnostics.SourceSwitch rootSourceSwitch, System.Diagnostics.TraceListener rootTraceListener) => throw null;
                }

            }
        }
    }
}
