// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        namespace Tracing
        {
            // Generated from `System.Diagnostics.Tracing.DiagnosticCounter` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DiagnosticCounter : System.IDisposable
            {
                public void AddMetadata(string key, string value) => throw null;
                internal DiagnosticCounter() => throw null;
                public string DisplayName { get => throw null; set => throw null; }
                public string DisplayUnits { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                public System.Diagnostics.Tracing.EventSource EventSource { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventActivityOptions` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventActivityOptions
            {
                Detachable,
                Disable,
                None,
                Recursive,
            }

            // Generated from `System.Diagnostics.Tracing.EventAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventAttribute : System.Attribute
            {
                public System.Diagnostics.Tracing.EventActivityOptions ActivityOptions { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventChannel Channel { get => throw null; set => throw null; }
                public EventAttribute(int eventId) => throw null;
                public int EventId { get => throw null; }
                public System.Diagnostics.Tracing.EventKeywords Keywords { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventLevel Level { get => throw null; set => throw null; }
                public string Message { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventTask Task { get => throw null; set => throw null; }
                public System.Byte Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventChannel` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventChannel
            {
                Admin,
                Analytic,
                Debug,
                None,
                Operational,
            }

            // Generated from `System.Diagnostics.Tracing.EventCommand` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventCommand
            {
                Disable,
                Enable,
                SendManifest,
                Update,
            }

            // Generated from `System.Diagnostics.Tracing.EventCommandEventArgs` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventCommandEventArgs : System.EventArgs
            {
                public System.Collections.Generic.IDictionary<string, string> Arguments { get => throw null; }
                public System.Diagnostics.Tracing.EventCommand Command { get => throw null; }
                public bool DisableEvent(int eventId) => throw null;
                public bool EnableEvent(int eventId) => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventCounter` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public EventCounter(string name, System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public override string ToString() => throw null;
                public void WriteMetric(double value) => throw null;
                public void WriteMetric(float value) => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventDataAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventDataAttribute : System.Attribute
            {
                public EventDataAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventFieldAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventFieldAttribute : System.Attribute
            {
                public EventFieldAttribute() => throw null;
                public System.Diagnostics.Tracing.EventFieldFormat Format { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventFieldTags Tags { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventFieldFormat` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventFieldFormat
            {
                Boolean,
                Default,
                HResult,
                Hexadecimal,
                Json,
                String,
                Xml,
            }

            // Generated from `System.Diagnostics.Tracing.EventFieldTags` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventFieldTags
            {
                None,
            }

            // Generated from `System.Diagnostics.Tracing.EventIgnoreAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventIgnoreAttribute : System.Attribute
            {
                public EventIgnoreAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventKeywords` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventKeywords
            {
                All,
                AuditFailure,
                AuditSuccess,
                CorrelationHint,
                EventLogClassic,
                MicrosoftTelemetry,
                None,
                Sqm,
                WdiContext,
                WdiDiagnostic,
            }

            // Generated from `System.Diagnostics.Tracing.EventLevel` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventLevel
            {
                Critical,
                Error,
                Informational,
                LogAlways,
                Verbose,
                Warning,
            }

            // Generated from `System.Diagnostics.Tracing.EventListener` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class EventListener : System.IDisposable
            {
                public void DisableEvents(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public virtual void Dispose() => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level) => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords matchAnyKeyword) => throw null;
                public void EnableEvents(System.Diagnostics.Tracing.EventSource eventSource, System.Diagnostics.Tracing.EventLevel level, System.Diagnostics.Tracing.EventKeywords matchAnyKeyword, System.Collections.Generic.IDictionary<string, string> arguments) => throw null;
                protected EventListener() => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventSourceCreatedEventArgs> EventSourceCreated;
                protected static int EventSourceIndex(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventWrittenEventArgs> EventWritten;
                protected internal virtual void OnEventSourceCreated(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                protected internal virtual void OnEventWritten(System.Diagnostics.Tracing.EventWrittenEventArgs eventData) => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventManifestOptions` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventManifestOptions
            {
                AllCultures,
                AllowEventSourceOverride,
                None,
                OnlyIfNeededForRegistration,
                Strict,
            }

            // Generated from `System.Diagnostics.Tracing.EventOpcode` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventOpcode
            {
                DataCollectionStart,
                DataCollectionStop,
                Extension,
                Info,
                Receive,
                Reply,
                Resume,
                Send,
                Start,
                Stop,
                Suspend,
            }

            // Generated from `System.Diagnostics.Tracing.EventSource` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventSource : System.IDisposable
            {
                // Generated from `System.Diagnostics.Tracing.EventSource+EventData` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                protected internal struct EventData
                {
                    public System.IntPtr DataPointer { get => throw null; set => throw null; }
                    // Stub generator skipped constructor 
                    public int Size { get => throw null; set => throw null; }
                }


                public System.Exception ConstructionException { get => throw null; }
                public static System.Guid CurrentThreadActivityId { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public event System.EventHandler<System.Diagnostics.Tracing.EventCommandEventArgs> EventCommandExecuted;
                protected EventSource() => throw null;
                protected EventSource(System.Diagnostics.Tracing.EventSourceSettings settings) => throw null;
                protected EventSource(System.Diagnostics.Tracing.EventSourceSettings settings, params string[] traits) => throw null;
                protected EventSource(bool throwOnEventWriteErrors) => throw null;
                public EventSource(string eventSourceName) => throw null;
                public EventSource(string eventSourceName, System.Diagnostics.Tracing.EventSourceSettings config) => throw null;
                public EventSource(string eventSourceName, System.Diagnostics.Tracing.EventSourceSettings config, params string[] traits) => throw null;
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
                public void Write<T>(string eventName, T data) => throw null;
                public void Write<T>(string eventName, ref System.Diagnostics.Tracing.EventSourceOptions options, ref System.Guid activityId, ref System.Guid relatedActivityId, ref T data) => throw null;
                public void Write<T>(string eventName, ref System.Diagnostics.Tracing.EventSourceOptions options, ref T data) => throw null;
                protected void WriteEvent(int eventId) => throw null;
                protected void WriteEvent(int eventId, System.Byte[] arg1) => throw null;
                protected void WriteEvent(int eventId, int arg1) => throw null;
                protected void WriteEvent(int eventId, int arg1, int arg2) => throw null;
                protected void WriteEvent(int eventId, int arg1, int arg2, int arg3) => throw null;
                protected void WriteEvent(int eventId, int arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, System.Int64 arg1) => throw null;
                protected void WriteEvent(int eventId, System.Int64 arg1, System.Byte[] arg2) => throw null;
                protected void WriteEvent(int eventId, System.Int64 arg1, System.Int64 arg2) => throw null;
                protected void WriteEvent(int eventId, System.Int64 arg1, System.Int64 arg2, System.Int64 arg3) => throw null;
                protected void WriteEvent(int eventId, System.Int64 arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, params object[] args) => throw null;
                protected void WriteEvent(int eventId, string arg1) => throw null;
                protected void WriteEvent(int eventId, string arg1, int arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, int arg2, int arg3) => throw null;
                protected void WriteEvent(int eventId, string arg1, System.Int64 arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, string arg2) => throw null;
                protected void WriteEvent(int eventId, string arg1, string arg2, string arg3) => throw null;
                unsafe protected void WriteEventCore(int eventId, int eventDataCount, System.Diagnostics.Tracing.EventSource.EventData* data) => throw null;
                protected void WriteEventWithRelatedActivityId(int eventId, System.Guid relatedActivityId, params object[] args) => throw null;
                unsafe protected void WriteEventWithRelatedActivityIdCore(int eventId, System.Guid* relatedActivityId, int eventDataCount, System.Diagnostics.Tracing.EventSource.EventData* data) => throw null;
                // ERR: Stub generator didn't handle member: ~EventSource
            }

            // Generated from `System.Diagnostics.Tracing.EventSourceAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventSourceAttribute : System.Attribute
            {
                public EventSourceAttribute() => throw null;
                public string Guid { get => throw null; set => throw null; }
                public string LocalizationResources { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventSourceCreatedEventArgs` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventSourceCreatedEventArgs : System.EventArgs
            {
                public System.Diagnostics.Tracing.EventSource EventSource { get => throw null; }
                public EventSourceCreatedEventArgs() => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventSourceException` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EventSourceException : System.Exception
            {
                public EventSourceException() => throw null;
                protected EventSourceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public EventSourceException(string message) => throw null;
                public EventSourceException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.EventSourceOptions` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct EventSourceOptions
            {
                public System.Diagnostics.Tracing.EventActivityOptions ActivityOptions { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
                public System.Diagnostics.Tracing.EventKeywords Keywords { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventLevel Level { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; set => throw null; }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; set => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.EventSourceSettings` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventSourceSettings
            {
                Default,
                EtwManifestEventFormat,
                EtwSelfDescribingEventFormat,
                ThrowOnEventWriteErrors,
            }

            // Generated from `System.Diagnostics.Tracing.EventTags` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EventTags
            {
                None,
            }

            // Generated from `System.Diagnostics.Tracing.EventTask` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EventTask
            {
                None,
            }

            // Generated from `System.Diagnostics.Tracing.EventWrittenEventArgs` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                public System.Int64 OSThreadId { get => throw null; }
                public System.Diagnostics.Tracing.EventOpcode Opcode { get => throw null; }
                public System.Collections.ObjectModel.ReadOnlyCollection<object> Payload { get => throw null; }
                public System.Collections.ObjectModel.ReadOnlyCollection<string> PayloadNames { get => throw null; }
                public System.Guid RelatedActivityId { get => throw null; }
                public System.Diagnostics.Tracing.EventTags Tags { get => throw null; }
                public System.Diagnostics.Tracing.EventTask Task { get => throw null; }
                public System.DateTime TimeStamp { get => throw null; }
                public System.Byte Version { get => throw null; }
            }

            // Generated from `System.Diagnostics.Tracing.IncrementingEventCounter` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IncrementingEventCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public System.TimeSpan DisplayRateTimeScale { get => throw null; set => throw null; }
                public void Increment(double increment = default(double)) => throw null;
                public IncrementingEventCounter(string name, System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.IncrementingPollingCounter` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IncrementingPollingCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public System.TimeSpan DisplayRateTimeScale { get => throw null; set => throw null; }
                public IncrementingPollingCounter(string name, System.Diagnostics.Tracing.EventSource eventSource, System.Func<double> totalValueProvider) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.NonEventAttribute` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NonEventAttribute : System.Attribute
            {
                public NonEventAttribute() => throw null;
            }

            // Generated from `System.Diagnostics.Tracing.PollingCounter` in `System.Diagnostics.Tracing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PollingCounter : System.Diagnostics.Tracing.DiagnosticCounter
            {
                public PollingCounter(string name, System.Diagnostics.Tracing.EventSource eventSource, System.Func<double> metricProvider) => throw null;
                public override string ToString() => throw null;
            }

        }
    }
}
