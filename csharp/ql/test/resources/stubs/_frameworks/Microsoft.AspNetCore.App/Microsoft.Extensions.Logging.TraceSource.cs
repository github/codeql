// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Logging
        {
            // Generated from `Microsoft.Extensions.Logging.TraceSourceFactoryExtensions` in `Microsoft.Extensions.Logging.TraceSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class TraceSourceFactoryExtensions
            {
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string switchName, System.Diagnostics.TraceListener listener) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, string switchName) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Diagnostics.SourceSwitch sourceSwitch, System.Diagnostics.TraceListener listener) => throw null;
                public static Microsoft.Extensions.Logging.ILoggingBuilder AddTraceSource(this Microsoft.Extensions.Logging.ILoggingBuilder builder, System.Diagnostics.SourceSwitch sourceSwitch) => throw null;
            }

            namespace TraceSource
            {
                // Generated from `Microsoft.Extensions.Logging.TraceSource.TraceSourceLoggerProvider` in `Microsoft.Extensions.Logging.TraceSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TraceSourceLoggerProvider : System.IDisposable, Microsoft.Extensions.Logging.ILoggerProvider
                {
                    public Microsoft.Extensions.Logging.ILogger CreateLogger(string name) => throw null;
                    public void Dispose() => throw null;
                    public TraceSourceLoggerProvider(System.Diagnostics.SourceSwitch rootSourceSwitch, System.Diagnostics.TraceListener rootTraceListener) => throw null;
                    public TraceSourceLoggerProvider(System.Diagnostics.SourceSwitch rootSourceSwitch) => throw null;
                }

            }
        }
    }
}
