// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.Activity` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Activity : System.IDisposable
        {
            public Activity(string operationName) => throw null;
            public System.Diagnostics.ActivityTraceFlags ActivityTraceFlags { get => throw null; set => throw null; }
            public System.Diagnostics.Activity AddBaggage(string key, string value) => throw null;
            public System.Diagnostics.Activity AddEvent(System.Diagnostics.ActivityEvent e) => throw null;
            public System.Diagnostics.Activity AddTag(string key, object value) => throw null;
            public System.Diagnostics.Activity AddTag(string key, string value) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> Baggage { get => throw null; }
            public System.Diagnostics.ActivityContext Context { get => throw null; }
            public static System.Diagnostics.Activity Current { get => throw null; set => throw null; }
            public static System.Diagnostics.ActivityIdFormat DefaultIdFormat { get => throw null; set => throw null; }
            public string DisplayName { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public System.TimeSpan Duration { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityEvent> Events { get => throw null; }
            public static bool ForceDefaultIdFormat { get => throw null; set => throw null; }
            public string GetBaggageItem(string key) => throw null;
            public object GetCustomProperty(string propertyName) => throw null;
            public string Id { get => throw null; }
            public System.Diagnostics.ActivityIdFormat IdFormat { get => throw null; }
            public bool IsAllDataRequested { get => throw null; set => throw null; }
            public System.Diagnostics.ActivityKind Kind { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> Links { get => throw null; }
            public string OperationName { get => throw null; }
            public System.Diagnostics.Activity Parent { get => throw null; }
            public string ParentId { get => throw null; }
            public System.Diagnostics.ActivitySpanId ParentSpanId { get => throw null; }
            public bool Recorded { get => throw null; }
            public string RootId { get => throw null; }
            public void SetCustomProperty(string propertyName, object propertyValue) => throw null;
            public System.Diagnostics.Activity SetEndTime(System.DateTime endTimeUtc) => throw null;
            public System.Diagnostics.Activity SetIdFormat(System.Diagnostics.ActivityIdFormat format) => throw null;
            public System.Diagnostics.Activity SetParentId(System.Diagnostics.ActivityTraceId traceId, System.Diagnostics.ActivitySpanId spanId, System.Diagnostics.ActivityTraceFlags activityTraceFlags = default(System.Diagnostics.ActivityTraceFlags)) => throw null;
            public System.Diagnostics.Activity SetParentId(string parentId) => throw null;
            public System.Diagnostics.Activity SetStartTime(System.DateTime startTimeUtc) => throw null;
            public System.Diagnostics.Activity SetTag(string key, object value) => throw null;
            public System.Diagnostics.ActivitySource Source { get => throw null; }
            public System.Diagnostics.ActivitySpanId SpanId { get => throw null; }
            public System.Diagnostics.Activity Start() => throw null;
            public System.DateTime StartTimeUtc { get => throw null; }
            public void Stop() => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> TagObjects { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> Tags { get => throw null; }
            public System.Diagnostics.ActivityTraceId TraceId { get => throw null; }
            public string TraceStateString { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.ActivityContext` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivityContext : System.IEquatable<System.Diagnostics.ActivityContext>
        {
            public static bool operator !=(System.Diagnostics.ActivityContext left, System.Diagnostics.ActivityContext right) => throw null;
            public static bool operator ==(System.Diagnostics.ActivityContext left, System.Diagnostics.ActivityContext right) => throw null;
            // Stub generator skipped constructor 
            public ActivityContext(System.Diagnostics.ActivityTraceId traceId, System.Diagnostics.ActivitySpanId spanId, System.Diagnostics.ActivityTraceFlags traceFlags, string traceState = default(string), bool isRemote = default(bool)) => throw null;
            public bool Equals(System.Diagnostics.ActivityContext value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsRemote { get => throw null; }
            public static System.Diagnostics.ActivityContext Parse(string traceParent, string traceState) => throw null;
            public System.Diagnostics.ActivitySpanId SpanId { get => throw null; }
            public System.Diagnostics.ActivityTraceFlags TraceFlags { get => throw null; }
            public System.Diagnostics.ActivityTraceId TraceId { get => throw null; }
            public string TraceState { get => throw null; }
            public static bool TryParse(string traceParent, string traceState, out System.Diagnostics.ActivityContext context) => throw null;
        }

        // Generated from `System.Diagnostics.ActivityCreationOptions<>` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivityCreationOptions<T>
        {
            // Stub generator skipped constructor 
            public System.Diagnostics.ActivityKind Kind { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> Links { get => throw null; }
            public string Name { get => throw null; }
            public T Parent { get => throw null; }
            public System.Diagnostics.ActivityTagsCollection SamplingTags { get => throw null; }
            public System.Diagnostics.ActivitySource Source { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
            public System.Diagnostics.ActivityTraceId TraceId { get => throw null; }
        }

        // Generated from `System.Diagnostics.ActivityEvent` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivityEvent
        {
            // Stub generator skipped constructor 
            public ActivityEvent(string name) => throw null;
            public ActivityEvent(string name, System.DateTimeOffset timestamp = default(System.DateTimeOffset), System.Diagnostics.ActivityTagsCollection tags = default(System.Diagnostics.ActivityTagsCollection)) => throw null;
            public string Name { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
            public System.DateTimeOffset Timestamp { get => throw null; }
        }

        // Generated from `System.Diagnostics.ActivityIdFormat` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ActivityIdFormat
        {
            Hierarchical,
            Unknown,
            W3C,
        }

        // Generated from `System.Diagnostics.ActivityKind` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ActivityKind
        {
            Client,
            Consumer,
            Internal,
            Producer,
            Server,
        }

        // Generated from `System.Diagnostics.ActivityLink` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivityLink : System.IEquatable<System.Diagnostics.ActivityLink>
        {
            public static bool operator !=(System.Diagnostics.ActivityLink left, System.Diagnostics.ActivityLink right) => throw null;
            public static bool operator ==(System.Diagnostics.ActivityLink left, System.Diagnostics.ActivityLink right) => throw null;
            // Stub generator skipped constructor 
            public ActivityLink(System.Diagnostics.ActivityContext context, System.Diagnostics.ActivityTagsCollection tags = default(System.Diagnostics.ActivityTagsCollection)) => throw null;
            public System.Diagnostics.ActivityContext Context { get => throw null; }
            public bool Equals(System.Diagnostics.ActivityLink value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
        }

        // Generated from `System.Diagnostics.ActivityListener` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ActivityListener : System.IDisposable
        {
            public ActivityListener() => throw null;
            public System.Action<System.Diagnostics.Activity> ActivityStarted { get => throw null; set => throw null; }
            public System.Action<System.Diagnostics.Activity> ActivityStopped { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            public System.Diagnostics.SampleActivity<System.Diagnostics.ActivityContext> Sample { get => throw null; set => throw null; }
            public System.Diagnostics.SampleActivity<string> SampleUsingParentId { get => throw null; set => throw null; }
            public System.Func<System.Diagnostics.ActivitySource, bool> ShouldListenTo { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.ActivitySamplingResult` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ActivitySamplingResult
        {
            AllData,
            AllDataAndRecorded,
            None,
            PropagationData,
        }

        // Generated from `System.Diagnostics.ActivitySource` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ActivitySource : System.IDisposable
        {
            public ActivitySource(string name, string version = default(string)) => throw null;
            public static void AddActivityListener(System.Diagnostics.ActivityListener listener) => throw null;
            public void Dispose() => throw null;
            public bool HasListeners() => throw null;
            public string Name { get => throw null; }
            public System.Diagnostics.Activity StartActivity(string name, System.Diagnostics.ActivityKind kind = default(System.Diagnostics.ActivityKind)) => throw null;
            public System.Diagnostics.Activity StartActivity(string name, System.Diagnostics.ActivityKind kind, System.Diagnostics.ActivityContext parentContext, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.DateTimeOffset startTime = default(System.DateTimeOffset)) => throw null;
            public System.Diagnostics.Activity StartActivity(string name, System.Diagnostics.ActivityKind kind, string parentId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.DateTimeOffset startTime = default(System.DateTimeOffset)) => throw null;
            public string Version { get => throw null; }
        }

        // Generated from `System.Diagnostics.ActivitySpanId` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivitySpanId : System.IEquatable<System.Diagnostics.ActivitySpanId>
        {
            public static bool operator !=(System.Diagnostics.ActivitySpanId spanId1, System.Diagnostics.ActivitySpanId spandId2) => throw null;
            public static bool operator ==(System.Diagnostics.ActivitySpanId spanId1, System.Diagnostics.ActivitySpanId spandId2) => throw null;
            // Stub generator skipped constructor 
            public void CopyTo(System.Span<System.Byte> destination) => throw null;
            public static System.Diagnostics.ActivitySpanId CreateFromBytes(System.ReadOnlySpan<System.Byte> idData) => throw null;
            public static System.Diagnostics.ActivitySpanId CreateFromString(System.ReadOnlySpan<System.Char> idData) => throw null;
            public static System.Diagnostics.ActivitySpanId CreateFromUtf8String(System.ReadOnlySpan<System.Byte> idData) => throw null;
            public static System.Diagnostics.ActivitySpanId CreateRandom() => throw null;
            public bool Equals(System.Diagnostics.ActivitySpanId spanId) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string ToHexString() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `System.Diagnostics.ActivityTagsCollection` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ActivityTagsCollection : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
        {
            // Generated from `System.Diagnostics.ActivityTagsCollection+Enumerator` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public struct Enumerator : System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerator, System.IDisposable
            {
                public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public void Dispose() => throw null;
                // Stub generator skipped constructor 
                public bool MoveNext() => throw null;
                void System.Collections.IEnumerator.Reset() => throw null;
            }


            public ActivityTagsCollection() => throw null;
            public ActivityTagsCollection(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> list) => throw null;
            public void Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public void Add(string key, object value) => throw null;
            public void Clear() => throw null;
            public bool Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public bool ContainsKey(string key) => throw null;
            public void CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
            public int Count { get => throw null; }
            public System.Diagnostics.ActivityTagsCollection.Enumerator GetEnumerator() => throw null;
            System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public object this[string key] { get => throw null; set => throw null; }
            public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
            public bool Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public bool Remove(string key) => throw null;
            public bool TryGetValue(string key, out object value) => throw null;
            public System.Collections.Generic.ICollection<object> Values { get => throw null; }
        }

        // Generated from `System.Diagnostics.ActivityTraceFlags` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum ActivityTraceFlags
        {
            None,
            Recorded,
        }

        // Generated from `System.Diagnostics.ActivityTraceId` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public struct ActivityTraceId : System.IEquatable<System.Diagnostics.ActivityTraceId>
        {
            public static bool operator !=(System.Diagnostics.ActivityTraceId traceId1, System.Diagnostics.ActivityTraceId traceId2) => throw null;
            public static bool operator ==(System.Diagnostics.ActivityTraceId traceId1, System.Diagnostics.ActivityTraceId traceId2) => throw null;
            // Stub generator skipped constructor 
            public void CopyTo(System.Span<System.Byte> destination) => throw null;
            public static System.Diagnostics.ActivityTraceId CreateFromBytes(System.ReadOnlySpan<System.Byte> idData) => throw null;
            public static System.Diagnostics.ActivityTraceId CreateFromString(System.ReadOnlySpan<System.Char> idData) => throw null;
            public static System.Diagnostics.ActivityTraceId CreateFromUtf8String(System.ReadOnlySpan<System.Byte> idData) => throw null;
            public static System.Diagnostics.ActivityTraceId CreateRandom() => throw null;
            public bool Equals(System.Diagnostics.ActivityTraceId traceId) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string ToHexString() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `System.Diagnostics.DiagnosticListener` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DiagnosticListener : System.Diagnostics.DiagnosticSource, System.IDisposable, System.IObservable<System.Collections.Generic.KeyValuePair<string, object>>
        {
            public static System.IObservable<System.Diagnostics.DiagnosticListener> AllListeners { get => throw null; }
            public DiagnosticListener(string name) => throw null;
            public virtual void Dispose() => throw null;
            public bool IsEnabled() => throw null;
            public override bool IsEnabled(string name) => throw null;
            public override bool IsEnabled(string name, object arg1, object arg2 = default(object)) => throw null;
            public string Name { get => throw null; }
            public override void OnActivityExport(System.Diagnostics.Activity activity, object payload) => throw null;
            public override void OnActivityImport(System.Diagnostics.Activity activity, object payload) => throw null;
            public virtual System.IDisposable Subscribe(System.IObserver<System.Collections.Generic.KeyValuePair<string, object>> observer) => throw null;
            public virtual System.IDisposable Subscribe(System.IObserver<System.Collections.Generic.KeyValuePair<string, object>> observer, System.Func<string, object, object, bool> isEnabled) => throw null;
            public virtual System.IDisposable Subscribe(System.IObserver<System.Collections.Generic.KeyValuePair<string, object>> observer, System.Func<string, object, object, bool> isEnabled, System.Action<System.Diagnostics.Activity, object> onActivityImport = default(System.Action<System.Diagnostics.Activity, object>), System.Action<System.Diagnostics.Activity, object> onActivityExport = default(System.Action<System.Diagnostics.Activity, object>)) => throw null;
            public virtual System.IDisposable Subscribe(System.IObserver<System.Collections.Generic.KeyValuePair<string, object>> observer, System.Predicate<string> isEnabled) => throw null;
            public override string ToString() => throw null;
            public override void Write(string name, object value) => throw null;
        }

        // Generated from `System.Diagnostics.DiagnosticSource` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class DiagnosticSource
        {
            protected DiagnosticSource() => throw null;
            public abstract bool IsEnabled(string name);
            public virtual bool IsEnabled(string name, object arg1, object arg2 = default(object)) => throw null;
            public virtual void OnActivityExport(System.Diagnostics.Activity activity, object payload) => throw null;
            public virtual void OnActivityImport(System.Diagnostics.Activity activity, object payload) => throw null;
            public System.Diagnostics.Activity StartActivity(System.Diagnostics.Activity activity, object args) => throw null;
            public void StopActivity(System.Diagnostics.Activity activity, object args) => throw null;
            public abstract void Write(string name, object value);
        }

        // Generated from `System.Diagnostics.SampleActivity<>` in `System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate System.Diagnostics.ActivitySamplingResult SampleActivity<T>(ref System.Diagnostics.ActivityCreationOptions<T> options);

        namespace CodeAnalysis
        {
            /* Duplicate type 'AllowNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DisallowNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DoesNotReturnAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'DoesNotReturnIfAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MaybeNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MaybeNullWhenAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MemberNotNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'MemberNotNullWhenAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullIfNotNullAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'NotNullWhenAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'System.Diagnostics.DiagnosticSource, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
}
