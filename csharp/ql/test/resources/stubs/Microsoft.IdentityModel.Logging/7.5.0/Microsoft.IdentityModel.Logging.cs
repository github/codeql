// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Logging, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Logging
        {
            public class IdentityModelEventSource : System.Diagnostics.Tracing.EventSource
            {
                public static bool HeaderWritten { get => throw null; set { } }
                public static string HiddenPIIString { get => throw null; }
                public static string HiddenSecurityArtifactString { get => throw null; }
                public static bool LogCompleteSecurityArtifact { get => throw null; set { } }
                public static Microsoft.IdentityModel.Logging.IdentityModelEventSource Logger { get => throw null; }
                public System.Diagnostics.Tracing.EventLevel LogLevel { get => throw null; set { } }
                public static bool ShowPII { get => throw null; set { } }
                public void Write(System.Diagnostics.Tracing.EventLevel level, System.Exception innerException, string message) => throw null;
                public void Write(System.Diagnostics.Tracing.EventLevel level, System.Exception innerException, string message, params object[] args) => throw null;
                public void WriteAlways(string message) => throw null;
                public void WriteAlways(string message, params object[] args) => throw null;
                public void WriteCritical(string message) => throw null;
                public void WriteCritical(string message, params object[] args) => throw null;
                public void WriteError(string message) => throw null;
                public void WriteError(string message, params object[] args) => throw null;
                public void WriteInformation(string message) => throw null;
                public void WriteInformation(string message, params object[] args) => throw null;
                public void WriteVerbose(string message) => throw null;
                public void WriteVerbose(string message, params object[] args) => throw null;
                public void WriteWarning(string message) => throw null;
                public void WriteWarning(string message, params object[] args) => throw null;
            }
            public static class IdentityModelTelemetryUtil
            {
                public static bool AddTelemetryData(string key, string value) => throw null;
                public static string ClientSku { get => throw null; }
                public static string ClientVer { get => throw null; }
                public static bool RemoveTelemetryData(string key) => throw null;
            }
            public interface ISafeLogSecurityArtifact
            {
                string UnsafeToString();
            }
            public class LoggerContext
            {
                public System.Guid ActivityId { get => throw null; set { } }
                public bool CaptureLogs { get => throw null; set { } }
                public LoggerContext() => throw null;
                public LoggerContext(System.Guid activityId) => throw null;
                public virtual string DebugId { get => throw null; set { } }
                public System.Collections.Generic.ICollection<string> Logs { get => throw null; }
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; set { } }
            }
            public class LogHelper
            {
                public LogHelper() => throw null;
                public static string FormatInvariant(string format, params object[] args) => throw null;
                public static bool IsEnabled(Microsoft.IdentityModel.Abstractions.EventLogLevel level) => throw null;
                public static T LogArgumentException<T>(string argumentName, string message) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(string argumentName, string format, params object[] args) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(string argumentName, System.Exception innerException, string message) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(string argumentName, System.Exception innerException, string format, params object[] args) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string argumentName, string message) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string argumentName, string format, params object[] args) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string argumentName, System.Exception innerException, string message) where T : System.ArgumentException => throw null;
                public static T LogArgumentException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string argumentName, System.Exception innerException, string format, params object[] args) where T : System.ArgumentException => throw null;
                public static System.ArgumentNullException LogArgumentNullException(string argument) => throw null;
                public static T LogException<T>(string message) where T : System.Exception => throw null;
                public static T LogException<T>(string format, params object[] args) where T : System.Exception => throw null;
                public static T LogException<T>(System.Exception innerException, string message) where T : System.Exception => throw null;
                public static T LogException<T>(System.Exception innerException, string format, params object[] args) where T : System.Exception => throw null;
                public static T LogException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string message) where T : System.Exception => throw null;
                public static T LogException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, string format, params object[] args) where T : System.Exception => throw null;
                public static T LogException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, System.Exception innerException, string message) where T : System.Exception => throw null;
                public static T LogException<T>(System.Diagnostics.Tracing.EventLevel eventLevel, System.Exception innerException, string format, params object[] args) where T : System.Exception => throw null;
                public static System.Exception LogExceptionMessage(System.Exception exception) => throw null;
                public static System.Exception LogExceptionMessage(System.Diagnostics.Tracing.EventLevel eventLevel, System.Exception exception) => throw null;
                public static Microsoft.IdentityModel.Abstractions.IIdentityLogger Logger { get => throw null; set { } }
                public static void LogInformation(string message, params object[] args) => throw null;
                public static void LogVerbose(string message, params object[] args) => throw null;
                public static void LogWarning(string message, params object[] args) => throw null;
                public static object MarkAsNonPII(object arg) => throw null;
                public static object MarkAsSecurityArtifact(object arg, System.Func<object, string> callback) => throw null;
                public static object MarkAsSecurityArtifact(object arg, System.Func<object, string> callback, System.Func<object, string> callbackUnsafe) => throw null;
                public static object MarkAsUnsafeSecurityArtifact(object arg, System.Func<object, string> callbackUnsafe) => throw null;
            }
            public class TextWriterEventListener : System.Diagnostics.Tracing.EventListener
            {
                public TextWriterEventListener() => throw null;
                public TextWriterEventListener(string filePath) => throw null;
                public TextWriterEventListener(System.IO.StreamWriter streamWriter) => throw null;
                public static readonly string DefaultLogFileName;
                public override void Dispose() => throw null;
                protected override void OnEventWritten(System.Diagnostics.Tracing.EventWrittenEventArgs eventData) => throw null;
            }
        }
    }
}
