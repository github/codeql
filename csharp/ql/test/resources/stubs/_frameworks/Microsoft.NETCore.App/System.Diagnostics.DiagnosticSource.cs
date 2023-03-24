// This file contains auto-generated code.
// Generated from `System.Diagnostics.DiagnosticSource, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Diagnostics
    {
        public class Activity : System.IDisposable
        {
            public struct Enumerator<T>
            {
                public T Current { get => throw null; }
                // Stub generator skipped constructor 
                public System.Diagnostics.Activity.Enumerator<T> GetEnumerator() => throw null;
                public bool MoveNext() => throw null;
            }


            public Activity(string operationName) => throw null;
            public System.Diagnostics.ActivityTraceFlags ActivityTraceFlags { get => throw null; set => throw null; }
            public System.Diagnostics.Activity AddBaggage(string key, string value) => throw null;
            public System.Diagnostics.Activity AddEvent(System.Diagnostics.ActivityEvent e) => throw null;
            public System.Diagnostics.Activity AddTag(string key, object value) => throw null;
            public System.Diagnostics.Activity AddTag(string key, string value) => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> Baggage { get => throw null; }
            public System.Diagnostics.ActivityContext Context { get => throw null; }
            public static System.Diagnostics.Activity Current { get => throw null; set => throw null; }
            public static event System.EventHandler<System.Diagnostics.ActivityChangedEventArgs> CurrentChanged;
            public static System.Diagnostics.ActivityIdFormat DefaultIdFormat { get => throw null; set => throw null; }
            public string DisplayName { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public System.TimeSpan Duration { get => throw null; }
            public System.Diagnostics.Activity.Enumerator<System.Diagnostics.ActivityEvent> EnumerateEvents() => throw null;
            public System.Diagnostics.Activity.Enumerator<System.Diagnostics.ActivityLink> EnumerateLinks() => throw null;
            public System.Diagnostics.Activity.Enumerator<System.Collections.Generic.KeyValuePair<string, object>> EnumerateTagObjects() => throw null;
            public System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityEvent> Events { get => throw null; }
            public static bool ForceDefaultIdFormat { get => throw null; set => throw null; }
            public string GetBaggageItem(string key) => throw null;
            public object GetCustomProperty(string propertyName) => throw null;
            public object GetTagItem(string key) => throw null;
            public bool HasRemoteParent { get => throw null; }
            public string Id { get => throw null; }
            public System.Diagnostics.ActivityIdFormat IdFormat { get => throw null; }
            public bool IsAllDataRequested { get => throw null; set => throw null; }
            public bool IsStopped { get => throw null; }
            public System.Diagnostics.ActivityKind Kind { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> Links { get => throw null; }
            public string OperationName { get => throw null; }
            public System.Diagnostics.Activity Parent { get => throw null; }
            public string ParentId { get => throw null; }
            public System.Diagnostics.ActivitySpanId ParentSpanId { get => throw null; }
            public bool Recorded { get => throw null; }
            public string RootId { get => throw null; }
            public System.Diagnostics.Activity SetBaggage(string key, string value) => throw null;
            public void SetCustomProperty(string propertyName, object propertyValue) => throw null;
            public System.Diagnostics.Activity SetEndTime(System.DateTime endTimeUtc) => throw null;
            public System.Diagnostics.Activity SetIdFormat(System.Diagnostics.ActivityIdFormat format) => throw null;
            public System.Diagnostics.Activity SetParentId(System.Diagnostics.ActivityTraceId traceId, System.Diagnostics.ActivitySpanId spanId, System.Diagnostics.ActivityTraceFlags activityTraceFlags = default(System.Diagnostics.ActivityTraceFlags)) => throw null;
            public System.Diagnostics.Activity SetParentId(string parentId) => throw null;
            public System.Diagnostics.Activity SetStartTime(System.DateTime startTimeUtc) => throw null;
            public System.Diagnostics.Activity SetStatus(System.Diagnostics.ActivityStatusCode code, string description = default(string)) => throw null;
            public System.Diagnostics.Activity SetTag(string key, object value) => throw null;
            public System.Diagnostics.ActivitySource Source { get => throw null; }
            public System.Diagnostics.ActivitySpanId SpanId { get => throw null; }
            public System.Diagnostics.Activity Start() => throw null;
            public System.DateTime StartTimeUtc { get => throw null; }
            public System.Diagnostics.ActivityStatusCode Status { get => throw null; }
            public string StatusDescription { get => throw null; }
            public void Stop() => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> TagObjects { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> Tags { get => throw null; }
            public System.Diagnostics.ActivityTraceId TraceId { get => throw null; }
            public static System.Func<System.Diagnostics.ActivityTraceId> TraceIdGenerator { get => throw null; set => throw null; }
            public string TraceStateString { get => throw null; set => throw null; }
        }

        public struct ActivityChangedEventArgs
        {
            // Stub generator skipped constructor 
            public System.Diagnostics.Activity Current { get => throw null; set => throw null; }
            public System.Diagnostics.Activity Previous { get => throw null; set => throw null; }
        }

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
            public static bool TryParse(string traceParent, string traceState, bool isRemote, out System.Diagnostics.ActivityContext context) => throw null;
            public static bool TryParse(string traceParent, string traceState, out System.Diagnostics.ActivityContext context) => throw null;
        }

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
            public string TraceState { get => throw null; set => throw null; }
        }

        public struct ActivityEvent
        {
            // Stub generator skipped constructor 
            public ActivityEvent(string name) => throw null;
            public ActivityEvent(string name, System.DateTimeOffset timestamp = default(System.DateTimeOffset), System.Diagnostics.ActivityTagsCollection tags = default(System.Diagnostics.ActivityTagsCollection)) => throw null;
            public System.Diagnostics.Activity.Enumerator<System.Collections.Generic.KeyValuePair<string, object>> EnumerateTagObjects() => throw null;
            public string Name { get => throw null; }
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
            public System.DateTimeOffset Timestamp { get => throw null; }
        }

        public enum ActivityIdFormat : int
        {
            Hierarchical = 1,
            Unknown = 0,
            W3C = 2,
        }

        public enum ActivityKind : int
        {
            Client = 2,
            Consumer = 4,
            Internal = 0,
            Producer = 3,
            Server = 1,
        }

        public struct ActivityLink : System.IEquatable<System.Diagnostics.ActivityLink>
        {
            public static bool operator !=(System.Diagnostics.ActivityLink left, System.Diagnostics.ActivityLink right) => throw null;
            public static bool operator ==(System.Diagnostics.ActivityLink left, System.Diagnostics.ActivityLink right) => throw null;
            // Stub generator skipped constructor 
            public ActivityLink(System.Diagnostics.ActivityContext context, System.Diagnostics.ActivityTagsCollection tags = default(System.Diagnostics.ActivityTagsCollection)) => throw null;
            public System.Diagnostics.ActivityContext Context { get => throw null; }
            public System.Diagnostics.Activity.Enumerator<System.Collections.Generic.KeyValuePair<string, object>> EnumerateTagObjects() => throw null;
            public bool Equals(System.Diagnostics.ActivityLink value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
        }

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

        public enum ActivitySamplingResult : int
        {
            AllData = 2,
            AllDataAndRecorded = 3,
            None = 0,
            PropagationData = 1,
        }

        public class ActivitySource : System.IDisposable
        {
            public ActivitySource(string name, string version = default(string)) => throw null;
            public static void AddActivityListener(System.Diagnostics.ActivityListener listener) => throw null;
            public System.Diagnostics.Activity CreateActivity(string name, System.Diagnostics.ActivityKind kind) => throw null;
            public System.Diagnostics.Activity CreateActivity(string name, System.Diagnostics.ActivityKind kind, System.Diagnostics.ActivityContext parentContext, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.Diagnostics.ActivityIdFormat idFormat = default(System.Diagnostics.ActivityIdFormat)) => throw null;
            public System.Diagnostics.Activity CreateActivity(string name, System.Diagnostics.ActivityKind kind, string parentId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.Diagnostics.ActivityIdFormat idFormat = default(System.Diagnostics.ActivityIdFormat)) => throw null;
            public void Dispose() => throw null;
            public bool HasListeners() => throw null;
            public string Name { get => throw null; }
            public System.Diagnostics.Activity StartActivity(System.Diagnostics.ActivityKind kind, System.Diagnostics.ActivityContext parentContext = default(System.Diagnostics.ActivityContext), System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.DateTimeOffset startTime = default(System.DateTimeOffset), string name = default(string)) => throw null;
            public System.Diagnostics.Activity StartActivity(string name = default(string), System.Diagnostics.ActivityKind kind = default(System.Diagnostics.ActivityKind)) => throw null;
            public System.Diagnostics.Activity StartActivity(string name, System.Diagnostics.ActivityKind kind, System.Diagnostics.ActivityContext parentContext, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.DateTimeOffset startTime = default(System.DateTimeOffset)) => throw null;
            public System.Diagnostics.Activity StartActivity(string name, System.Diagnostics.ActivityKind kind, string parentId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>), System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink> links = default(System.Collections.Generic.IEnumerable<System.Diagnostics.ActivityLink>), System.DateTimeOffset startTime = default(System.DateTimeOffset)) => throw null;
            public string Version { get => throw null; }
        }

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

        public enum ActivityStatusCode : int
        {
            Error = 2,
            Ok = 1,
            Unset = 0,
        }

        public class ActivityTagsCollection : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
        {
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

        [System.Flags]
        public enum ActivityTraceFlags : int
        {
            None = 0,
            Recorded = 1,
        }

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

        public abstract class DistributedContextPropagator
        {
            public delegate void PropagatorGetterCallback(object carrier, string fieldName, out string fieldValue, out System.Collections.Generic.IEnumerable<string> fieldValues);


            public delegate void PropagatorSetterCallback(object carrier, string fieldName, string fieldValue);


            public static System.Diagnostics.DistributedContextPropagator CreateDefaultPropagator() => throw null;
            public static System.Diagnostics.DistributedContextPropagator CreateNoOutputPropagator() => throw null;
            public static System.Diagnostics.DistributedContextPropagator CreatePassThroughPropagator() => throw null;
            public static System.Diagnostics.DistributedContextPropagator Current { get => throw null; set => throw null; }
            protected DistributedContextPropagator() => throw null;
            public abstract System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> ExtractBaggage(object carrier, System.Diagnostics.DistributedContextPropagator.PropagatorGetterCallback getter);
            public abstract void ExtractTraceIdAndState(object carrier, System.Diagnostics.DistributedContextPropagator.PropagatorGetterCallback getter, out string traceId, out string traceState);
            public abstract System.Collections.Generic.IReadOnlyCollection<string> Fields { get; }
            public abstract void Inject(System.Diagnostics.Activity activity, object carrier, System.Diagnostics.DistributedContextPropagator.PropagatorSetterCallback setter);
        }

        public delegate System.Diagnostics.ActivitySamplingResult SampleActivity<T>(ref System.Diagnostics.ActivityCreationOptions<T> options);

        public struct TagList : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
        {
            public struct Enumerator : System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerator, System.IDisposable
            {
                public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public void Dispose() => throw null;
                // Stub generator skipped constructor 
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }


            public void Add(System.Collections.Generic.KeyValuePair<string, object> tag) => throw null;
            public void Add(string key, object value) => throw null;
            public void Clear() => throw null;
            public bool Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public void CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
            public void CopyTo(System.Span<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
            public int Count { get => throw null; }
            public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public int IndexOf(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public void Insert(int index, System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public bool IsReadOnly { get => throw null; }
            public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; set => throw null; }
            public bool Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
            public void RemoveAt(int index) => throw null;
            // Stub generator skipped constructor 
            public TagList(System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tagList) => throw null;
        }

        namespace Metrics
        {
            public class Counter<T> : System.Diagnostics.Metrics.Instrument<T> where T : struct
            {
                public void Add(T delta) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2, System.Collections.Generic.KeyValuePair<string, object> tag3) => throw null;
                public void Add(T delta, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                public void Add(T delta, System.Diagnostics.TagList tagList) => throw null;
                public void Add(T delta, params System.Collections.Generic.KeyValuePair<string, object>[] tags) => throw null;
                internal Counter(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
            }

            public class Histogram<T> : System.Diagnostics.Metrics.Instrument<T> where T : struct
            {
                internal Histogram(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                public void Record(T value) => throw null;
                public void Record(T value, System.Collections.Generic.KeyValuePair<string, object> tag) => throw null;
                public void Record(T value, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2) => throw null;
                public void Record(T value, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2, System.Collections.Generic.KeyValuePair<string, object> tag3) => throw null;
                public void Record(T value, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                public void Record(T value, System.Diagnostics.TagList tagList) => throw null;
                public void Record(T value, params System.Collections.Generic.KeyValuePair<string, object>[] tags) => throw null;
            }

            public abstract class Instrument
            {
                public string Description { get => throw null; }
                public bool Enabled { get => throw null; }
                protected Instrument(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) => throw null;
                public virtual bool IsObservable { get => throw null; }
                public System.Diagnostics.Metrics.Meter Meter { get => throw null; }
                public string Name { get => throw null; }
                protected void Publish() => throw null;
                public string Unit { get => throw null; }
            }

            public abstract class Instrument<T> : System.Diagnostics.Metrics.Instrument where T : struct
            {
                protected Instrument(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                protected void RecordMeasurement(T measurement) => throw null;
                protected void RecordMeasurement(T measurement, System.Collections.Generic.KeyValuePair<string, object> tag) => throw null;
                protected void RecordMeasurement(T measurement, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2) => throw null;
                protected void RecordMeasurement(T measurement, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2, System.Collections.Generic.KeyValuePair<string, object> tag3) => throw null;
                protected void RecordMeasurement(T measurement, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                protected void RecordMeasurement(T measurement, System.Diagnostics.TagList tagList) => throw null;
            }

            public struct Measurement<T> where T : struct
            {
                // Stub generator skipped constructor 
                public Measurement(T value) => throw null;
                public Measurement(T value, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                public Measurement(T value, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                public Measurement(T value, params System.Collections.Generic.KeyValuePair<string, object>[] tags) => throw null;
                public System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> Tags { get => throw null; }
                public T Value { get => throw null; }
            }

            public delegate void MeasurementCallback<T>(System.Diagnostics.Metrics.Instrument instrument, T measurement, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags, object state);

            public class Meter : System.IDisposable
            {
                public System.Diagnostics.Metrics.Counter<T> CreateCounter<T>(string name, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.Histogram<T> CreateHistogram<T>(string name, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableCounter<T> CreateObservableCounter<T>(string name, System.Func<System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>>> observeValues, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableCounter<T> CreateObservableCounter<T>(string name, System.Func<System.Diagnostics.Metrics.Measurement<T>> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableCounter<T> CreateObservableCounter<T>(string name, System.Func<T> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableGauge<T> CreateObservableGauge<T>(string name, System.Func<System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>>> observeValues, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableGauge<T> CreateObservableGauge<T>(string name, System.Func<System.Diagnostics.Metrics.Measurement<T>> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableGauge<T> CreateObservableGauge<T>(string name, System.Func<T> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableUpDownCounter<T> CreateObservableUpDownCounter<T>(string name, System.Func<System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>>> observeValues, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableUpDownCounter<T> CreateObservableUpDownCounter<T>(string name, System.Func<System.Diagnostics.Metrics.Measurement<T>> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.ObservableUpDownCounter<T> CreateObservableUpDownCounter<T>(string name, System.Func<T> observeValue, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public System.Diagnostics.Metrics.UpDownCounter<T> CreateUpDownCounter<T>(string name, string unit = default(string), string description = default(string)) where T : struct => throw null;
                public void Dispose() => throw null;
                public Meter(string name) => throw null;
                public Meter(string name, string version) => throw null;
                public string Name { get => throw null; }
                public string Version { get => throw null; }
            }

            public class MeterListener : System.IDisposable
            {
                public object DisableMeasurementEvents(System.Diagnostics.Metrics.Instrument instrument) => throw null;
                public void Dispose() => throw null;
                public void EnableMeasurementEvents(System.Diagnostics.Metrics.Instrument instrument, object state = default(object)) => throw null;
                public System.Action<System.Diagnostics.Metrics.Instrument, System.Diagnostics.Metrics.MeterListener> InstrumentPublished { get => throw null; set => throw null; }
                public System.Action<System.Diagnostics.Metrics.Instrument, object> MeasurementsCompleted { get => throw null; set => throw null; }
                public MeterListener() => throw null;
                public void RecordObservableInstruments() => throw null;
                public void SetMeasurementEventCallback<T>(System.Diagnostics.Metrics.MeasurementCallback<T> measurementCallback) where T : struct => throw null;
                public void Start() => throw null;
            }

            public class ObservableCounter<T> : System.Diagnostics.Metrics.ObservableInstrument<T> where T : struct
            {
                internal ObservableCounter(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                protected override System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>> Observe() => throw null;
            }

            public class ObservableGauge<T> : System.Diagnostics.Metrics.ObservableInstrument<T> where T : struct
            {
                internal ObservableGauge(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                protected override System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>> Observe() => throw null;
            }

            public abstract class ObservableInstrument<T> : System.Diagnostics.Metrics.Instrument where T : struct
            {
                public override bool IsObservable { get => throw null; }
                protected ObservableInstrument(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                protected abstract System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>> Observe();
            }

            public class ObservableUpDownCounter<T> : System.Diagnostics.Metrics.ObservableInstrument<T> where T : struct
            {
                internal ObservableUpDownCounter(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
                protected override System.Collections.Generic.IEnumerable<System.Diagnostics.Metrics.Measurement<T>> Observe() => throw null;
            }

            public class UpDownCounter<T> : System.Diagnostics.Metrics.Instrument<T> where T : struct
            {
                public void Add(T delta) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2) => throw null;
                public void Add(T delta, System.Collections.Generic.KeyValuePair<string, object> tag1, System.Collections.Generic.KeyValuePair<string, object> tag2, System.Collections.Generic.KeyValuePair<string, object> tag3) => throw null;
                public void Add(T delta, System.ReadOnlySpan<System.Collections.Generic.KeyValuePair<string, object>> tags) => throw null;
                public void Add(T delta, System.Diagnostics.TagList tagList) => throw null;
                public void Add(T delta, params System.Collections.Generic.KeyValuePair<string, object>[] tags) => throw null;
                internal UpDownCounter(System.Diagnostics.Metrics.Meter meter, string name, string unit, string description) : base(default(System.Diagnostics.Metrics.Meter), default(string), default(string), default(string)) => throw null;
            }

        }
    }
}
