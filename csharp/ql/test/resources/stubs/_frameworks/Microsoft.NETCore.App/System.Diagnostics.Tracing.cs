// This file contains auto-generated code.
// Generated from `System.Diagnostics.Tracing, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Diagnostics
    {
        namespace Tracing
        {
            public abstract class DiagnosticCounter : System.IDisposable
            {
                public void AddMetadata(string key, string value) => throw null;
                public string DisplayName { get => throw null; set { } }
                public string DisplayUnits { get => throw null; set { } }
                public void Dispose() => throw null;
                public System.Diagnostics.Tracing.EventSource EventSource { get => throw null; }
                public string Name { get => throw null; }
            }
            [System.Flags]
            public enum EventActivityOptions
            {
                None = 0,
                Disable = 2,
                Recursive = 4,
                Detachable = 8,
            }
            [System.AttributeUsage((System.AttributeTargets)64)]
            public sealed class EventAttribute : System.Attribute
            {
                public System.Diagnostics.Tracing.EventActivityOptions ActivityOptions { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventChannel Channel { get => throw null; set { } }
                public EventAttribute(int eventId) => throw null;
                public int EventId { get => throw null; }
                public System.Diagnostics.Tracing.EventKeywords Keywords { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventLevel Level { get => throw null; set { } }
                public string Message { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventTask Task { get => throw null; set { } }
                public byte Version { get => throw null; set { } }
            }
            public enum EventChannel : byte
            {
                None = 0,
                Admin = 16,
                Operational = 17,
                Analytic = 18,
                Debug = 19,
            }
            public enum EventCommand
            {
                Disable = -3,
                Enable = -2,
                SendManifest = -1,
                Update = 0,
            }
            public class EventCommandEventArgs : System.EventArgs
            {
                public System.Collections.Generic.IDictionary<string, string> Arguments { get => throw null; }
                public System.Diagnostics.Tracing.EventCommand Command { get => throw null; }
                public bool DisableEvent(int eventId) => throw null;
                public bool EnableEvent(int eventId) => throw null;
            }
            public class EventCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public EventCounter(string name, System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public override string ToString() => throw null;
                public void WriteMetric(double value) => throw null;
                public void WriteMetric(float value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)12, Inherited = false)]
            public class EventDataAttribute : System.Attribute
            {
                public EventDataAttribute() => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)128)]
            public class EventFieldAttribute : System.Attribute
            {
                public EventFieldAttribute() => throw null;
                public System.Diagnostics.Tracing.EventFieldFormat Format { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventFieldTags Tags { get => throw null; set { } }
            }
            public enum EventFieldFormat
            {
                Default = 0,
                String = 2,
                Boolean = 3,
                Hexadecimal = 4,
                Xml = 11,
                Json = 12,
                HResult = 15,
            }
            [System.Flags]
            public enum EventFieldTags
            {
                None = 0,
            }
            [System.AttributeUsage((System.AttributeTargets)128)]
            public class EventIgnoreAttribute : System.Attribute
            {
                public EventIgnoreAttribute() => throw null;
            }
            [System.Flags]
            public enum EventKeywords : long
            {
                All = -1,
                None = 0,
                MicrosoftTelemetry = 562949953421312,
                WdiContext = 562949953421312,
                WdiDiagnostic = 1125899906842624,
                Sqm = 2251799813685248,
                AuditFailure = 4503599627370496,
                CorrelationHint = 4503599627370496,
                AuditSuccess = 9007199254740992,
                EventLogClassic = 36028797018963968,
            }
            public enum EventLevel
            {
                LogAlways = 0,
                Critical = 1,
                Error = 2,
                Warning = 3,
                Informational = 4,
                Verbose = 5,
            }
            public abstract class EventListener : System.IDisposable
            {
                protected EventListener() => throw null;
                public void DisableEvents(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public virtual void Dispose() => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level) => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords matchAnyKeyword) => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords matchAnyKeyword, System.Collections.Generic.IDictionary<string, string> arguments) => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventSourceCreatedEventArgs> EventSourceCreated;
                protected static int EventSourceIndex(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventWrittenEventArgs> EventWritten;
                protected virtual void OnEventSourceCreated(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                protected virtual void OnEventWritten(System.Diagnostics.Tracing.EventWrittenEventArgs eventData) => throw null;
            }
            [System.Flags]
            public enum EventManifestOptions
            {
                None = 0,
                Strict = 1,
                AllCultures = 2,
                OnlyIfNeededForRegistration = 4,
                AllowEventSourceOverride = 8,
            }
            public enum EventOpcode
            {
                Info = 0,
                Start = 1,
                Stop = 2,
                DataCollectionStart = 3,
                DataCollectionStop = 4,
                Extension = 5,
                Reply = 6,
                Resume = 7,
                Suspend = 8,
                Send = 9,
                Receive = 240,
            }
            public class EventSource : System.IDisposable
            {
                public System.Exception ConstructionException { get => throw null; }
                protected EventSource() => throw null;
                protected EventSource(bool throwOnEventWriteErrors) => throw null;
                protected EventSource(System.Diagnostics.Tracing.EventSourceSettings settings) => throw null;
                protected EventSource(System.Diagnostics.Tracing.EventSourceSettings settings, params string[] traits) => throw null;
                public EventSource(string eventSourceName) => throw null;
                public EventSource(string eventSourceName, System.Diagnostics.Tracing.EventSourceSettings config) => throw null;
                public EventSource(string eventSourceName, System.Diagnostics.Tracing.EventSourceSettings config, params string[] traits) => throw null;
                public static System.Guid CurrentThreadActivityId { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventCommandEventArgs> EventCommandExecuted;
                protected struct EventData
                {
                    public nint DataPointer { get => throw null; set { } }
                    public int Size { get => throw null; set { } }
                }
                public struct EventSourcePrimitive
                {
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(bool value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(byte value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(short value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(int value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(long value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(sbyte value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(ushort value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(uint value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(ulong value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(nuint value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(float value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(double value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(decimal value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(string value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(byte[] value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(System.Guid value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(System.DateTime value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(nint value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(char value) => throw null;
                    public static implicit operator System.Diagnostics.Tracing.EventSource.EventSourcePrimitive(System.Enum value) => throw null;
                }
                public static string GenerateManifest(System.Type eventSourceType, string assemblyPathToIncludeInManifest) => throw null;
                public static string GenerateManifest(System.Type eventSourceType, string assemblyPathToIncludeInManifest, System.Diagnostics.Tracing.EventManifestOptions flags) => throw null;
                public static System.Guid GetGuid(System.Type eventSourceType) => throw null;
                public static string GetName(System.Type eventSourceType) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Diagnostics.Tracing.EventSource> GetSources() => throw null;
                public string GetTrait(string key) => throw null;
                public System.Guid Guid { get => throw null; }
                public bool IsEnabled() => throw null;
                public bool IsEnabled(System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords keywords) => throw null;
                public bool IsEnabled(System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords keywords, System.Diagnostics.Tracing.EventChannel channel) => throw null;
                public string Name { get => throw null; }
                protected virtual void OnEventCommand(System.Diagnostics.Tracing.EventCommandEventArgs command) => throw null;
                public static void SendCommand(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventCommand command, System.Collections.Generic.IDictionary<string, string> commandArguments) => throw null;
                public static void SetCurrentThreadActivityId(System.Guid activityId) => throw null;
                public static void SetCurrentThreadActivityId(System.Guid activityId, out System.Guid oldActivityThatWillContinue) => throw null;
                public System.Diagnostics.Tracing.EventSourceSettings Settings { get => throw null; }
                public override string ToString() => throw null;
                public void Write(string eventName) => throw null;
                public void Write(string eventName, System.Diagnostics.Tracing.EventSourceOptions options) => throw null;
                public void Write<T>(string eventName, System.Diagnostics.Tracing.EventSourceOptions options, T data) => throw null;
                public void Write<T>(string eventName, ref System.Diagnostics.Tracing.EventSourceOptions options, ref System.Guid activityId, ref System.Guid relatedActivityId, ref T data) => throw null;
                public void Write<T>(string eventName, ref System.Diagnostics.Tracing.EventSourceOptions options, ref T data) => throw null;
                public void Write<T>(string eventName, T data) => throw null;
                protected void WriteEvent(int eventId) => throw null;
                protected void WriteEvent(int eventId, byte[] arg1) => throw null;
                protected void WriteEvent(int eventId, int arg1) => throw null;
                protected void WriteEvent(int eventId, int arg1, int arg2) => throw null;
                protected void WriteEvent(int eventId, int arg1, int arg2, int arg3) => throw null;
                protected void WriteEvent(int eventId, int arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, long arg1) => throw null;
                protected void WriteEvent(int eventId, long arg1, byte[] arg2) => throw null;
                protected void WriteEvent(int eventId, long arg1, long arg2) => throw null;
                protected void WriteEvent(int eventId, long arg1, long arg2, long arg3) => throw null;
                protected void WriteEvent(int eventId, long arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, params System.Diagnostics.Tracing.EventSource.EventSourcePrimitive[] args) => throw null;
                protected void WriteEvent(int eventId, params object[] args) => throw null;
                protected void WriteEvent(int eventId, string arg1) => throw null;
                protected void WriteEvent(int eventId, string arg1, int arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, int arg2, int arg3) => throw null;
                protected void WriteEvent(int eventId, string arg1, long arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, string arg2, string arg3) => throw null;
                protected unsafe void WriteEventCore(int eventId, int eventDataCount, System.Diagnostics.Tracing.EventSource.EventData* data) => throw null;
                protected void WriteEventWithRelatedActivityId(int eventId, System.Guid relatedActivityId, params object[] args) => throw null;
                protected unsafe void WriteEventWithRelatedActivityIdCore(int eventId, System.Guid* relatedActivityId, int eventDataCount, System.Diagnostics.Tracing.EventSource.EventData* data) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4)]
            public sealed class EventSourceAttribute : System.Attribute
            {
                public EventSourceAttribute() => throw null;
                public string Guid { get => throw null; set { } }
                public string LocalizationResources { get => throw null; set { } }
                public string Name { get => throw null; set { } }
            }
            public class EventSourceCreatedEventArgs : System.EventArgs
            {
                public EventSourceCreatedEventArgs() => throw null;
                public System.Diagnostics.Tracing.EventSource EventSource { get => throw null; }
            }
            public class EventSourceException : System.Exception
            {
                public EventSourceException() => throw null;
                protected EventSourceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public EventSourceException(string message) => throw null;
                public EventSourceException(string message, System.Exception innerException) => throw null;
            }
            public struct EventSourceOptions
            {
                public System.Diagnostics.Tracing.EventActivityOptions ActivityOptions { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventKeywords Keywords { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventLevel Level { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; set { } }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; set { } }
            }
            [System.Flags]
            public enum EventSourceSettings
            {
                Default = 0,
                ThrowOnEventWriteErrors = 1,
                EtwManifestEventFormat = 4,
                EtwSelfDescribingEventFormat = 8,
            }
            [System.Flags]
            public enum EventTags
            {
                None = 0,
            }
            public enum EventTask
            {
                None = 0,
            }
            public class EventWrittenEventArgs : System.EventArgs
            {
                public System.Guid ActivityId { get => throw null; }
                public System.Diagnostics.Tracing.EventChannel Channel { get => throw null; }
                public int EventId { get => throw null; }
                public string EventName { get => throw null; }
                public System.Diagnostics.Tracing.EventSource EventSource { get => throw null; }
                public System.Diagnostics.Tracing.EventKeywords Keywords { get => throw null; }
                public System.Diagnostics.Tracing.EventLevel Level { get => throw null; }
                public string Message { get => throw null; }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; }
                public long OSThreadId { get => throw null; }
                public System.Collections.ObjectModel.ReadOnlyCollection<object> Payload { get => throw null; }
                public System.Collections.ObjectModel.ReadOnlyCollection<string> PayloadNames { get => throw null; }
                public System.Guid RelatedActivityId { get => throw null; }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; }
                public System.Diagnostics.Tracing.EventTask Task { get => throw null; }
                public System.DateTime TimeStamp { get => throw null; }
                public byte Version { get => throw null; }
            }
            public class IncrementingEventCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public IncrementingEventCounter(string name, System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public System.TimeSpan DisplayRateTimeScale { get => throw null; set { } }
                public void Increment(double increment = default(double)) => throw null;
                public override string ToString() => throw null;
            }
            public class IncrementingPollingCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public IncrementingPollingCounter(string name, System.Diagnostics.Tracing.EventSource eventSource, System.Func<double> totalValueProvider) => throw null;
                public System.TimeSpan DisplayRateTimeScale { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64)]
            public sealed class NonEventAttribute : System.Attribute
            {
                public NonEventAttribute() => throw null;
            }
            public class PollingCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public PollingCounter(string name, System.Diagnostics.Tracing.EventSource eventSource, System.Func<double> metricProvider) => throw null;
                public override string ToString() => throw null;
            }
        }
    }
}
