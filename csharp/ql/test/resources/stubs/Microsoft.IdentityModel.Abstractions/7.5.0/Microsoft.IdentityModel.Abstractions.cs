// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Abstractions, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Abstractions
        {
            public enum EventLogLevel
            {
                LogAlways = 0,
                Critical = 1,
                Error = 2,
                Warning = 3,
                Informational = 4,
                Verbose = 5,
            }
            public interface IIdentityLogger
            {
                bool IsEnabled(Microsoft.IdentityModel.Abstractions.EventLogLevel eventLogLevel);
                void Log(Microsoft.IdentityModel.Abstractions.LogEntry entry);
            }
            public interface ITelemetryClient
            {
                string ClientId { get; set; }
                void Initialize();
                bool IsEnabled();
                bool IsEnabled(string eventName);
                void TrackEvent(Microsoft.IdentityModel.Abstractions.TelemetryEventDetails eventDetails);
                void TrackEvent(string eventName, System.Collections.Generic.IDictionary<string, string> stringProperties = default(System.Collections.Generic.IDictionary<string, string>), System.Collections.Generic.IDictionary<string, long> longProperties = default(System.Collections.Generic.IDictionary<string, long>), System.Collections.Generic.IDictionary<string, bool> boolProperties = default(System.Collections.Generic.IDictionary<string, bool>), System.Collections.Generic.IDictionary<string, System.DateTime> dateTimeProperties = default(System.Collections.Generic.IDictionary<string, System.DateTime>), System.Collections.Generic.IDictionary<string, double> doubleProperties = default(System.Collections.Generic.IDictionary<string, double>), System.Collections.Generic.IDictionary<string, System.Guid> guidProperties = default(System.Collections.Generic.IDictionary<string, System.Guid>));
            }
            public class LogEntry
            {
                public string CorrelationId { get => throw null; set { } }
                public LogEntry() => throw null;
                public Microsoft.IdentityModel.Abstractions.EventLogLevel EventLogLevel { get => throw null; set { } }
                public string Message { get => throw null; set { } }
            }
            public sealed class NullIdentityModelLogger : Microsoft.IdentityModel.Abstractions.IIdentityLogger
            {
                public static Microsoft.IdentityModel.Abstractions.NullIdentityModelLogger Instance { get => throw null; }
                public bool IsEnabled(Microsoft.IdentityModel.Abstractions.EventLogLevel eventLogLevel) => throw null;
                public void Log(Microsoft.IdentityModel.Abstractions.LogEntry entry) => throw null;
            }
            public class NullTelemetryClient : Microsoft.IdentityModel.Abstractions.ITelemetryClient
            {
                public string ClientId { get => throw null; set { } }
                public void Initialize() => throw null;
                public static Microsoft.IdentityModel.Abstractions.NullTelemetryClient Instance { get => throw null; }
                public bool IsEnabled() => throw null;
                public bool IsEnabled(string eventName) => throw null;
                public void TrackEvent(Microsoft.IdentityModel.Abstractions.TelemetryEventDetails eventDetails) => throw null;
                public void TrackEvent(string eventName, System.Collections.Generic.IDictionary<string, string> stringProperties = default(System.Collections.Generic.IDictionary<string, string>), System.Collections.Generic.IDictionary<string, long> longProperties = default(System.Collections.Generic.IDictionary<string, long>), System.Collections.Generic.IDictionary<string, bool> boolProperties = default(System.Collections.Generic.IDictionary<string, bool>), System.Collections.Generic.IDictionary<string, System.DateTime> dateTimeProperties = default(System.Collections.Generic.IDictionary<string, System.DateTime>), System.Collections.Generic.IDictionary<string, double> doubleProperties = default(System.Collections.Generic.IDictionary<string, double>), System.Collections.Generic.IDictionary<string, System.Guid> guidProperties = default(System.Collections.Generic.IDictionary<string, System.Guid>)) => throw null;
            }
            public static class ObservabilityConstants
            {
                public const string ActivityId = default;
                public const string ClientId = default;
                public const string Duration = default;
                public const string Succeeded = default;
            }
            public abstract class TelemetryEventDetails
            {
                protected TelemetryEventDetails() => throw null;
                public virtual string Name { get => throw null; set { } }
                public virtual System.Collections.Generic.IReadOnlyDictionary<string, object> Properties { get => throw null; }
                protected System.Collections.Generic.IDictionary<string, object> PropertyValues { get => throw null; }
                public virtual void SetProperty(string key, string value) => throw null;
                public virtual void SetProperty(string key, long value) => throw null;
                public virtual void SetProperty(string key, bool value) => throw null;
                public virtual void SetProperty(string key, System.DateTime value) => throw null;
                public virtual void SetProperty(string key, double value) => throw null;
                public virtual void SetProperty(string key, System.Guid value) => throw null;
            }
        }
    }
}
