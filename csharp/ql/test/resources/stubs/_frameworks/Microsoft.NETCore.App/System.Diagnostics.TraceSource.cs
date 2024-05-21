// This file contains auto-generated code.
// Generated from `System.Diagnostics.TraceSource, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Diagnostics
    {
        public class BooleanSwitch : System.Diagnostics.Switch
        {
            public BooleanSwitch(string displayName, string description) : base(default(string), default(string)) => throw null;
            public BooleanSwitch(string displayName, string description, string defaultSwitchValue) : base(default(string), default(string)) => throw null;
            public bool Enabled { get => throw null; set { } }
            protected override void OnValueChanged() => throw null;
        }
        public class CorrelationManager
        {
            public System.Guid ActivityId { get => throw null; set { } }
            public System.Collections.Stack LogicalOperationStack { get => throw null; }
            public void StartLogicalOperation() => throw null;
            public void StartLogicalOperation(object operationId) => throw null;
            public void StopLogicalOperation() => throw null;
        }
        public class DefaultTraceListener : System.Diagnostics.TraceListener
        {
            public bool AssertUiEnabled { get => throw null; set { } }
            public DefaultTraceListener() => throw null;
            public override void Fail(string message) => throw null;
            public override void Fail(string message, string detailMessage) => throw null;
            public string LogFileName { get => throw null; set { } }
            public override void Write(string message) => throw null;
            public override void WriteLine(string message) => throw null;
        }
        public class EventTypeFilter : System.Diagnostics.TraceFilter
        {
            public EventTypeFilter(System.Diagnostics.SourceLevels level) => throw null;
            public System.Diagnostics.SourceLevels EventType { get => throw null; set { } }
            public override bool ShouldTrace(System.Diagnostics.TraceEventCache cache, string source, System.Diagnostics.TraceEventType eventType, int id, string formatOrMessage, object[] args, object data1, object[] data) => throw null;
        }
        public sealed class InitializingSwitchEventArgs : System.EventArgs
        {
            public InitializingSwitchEventArgs(System.Diagnostics.Switch @switch) => throw null;
            public System.Diagnostics.Switch Switch { get => throw null; }
        }
        public sealed class InitializingTraceSourceEventArgs : System.EventArgs
        {
            public InitializingTraceSourceEventArgs(System.Diagnostics.TraceSource traceSource) => throw null;
            public System.Diagnostics.TraceSource TraceSource { get => throw null; }
            public bool WasInitialized { get => throw null; set { } }
        }
        public class SourceFilter : System.Diagnostics.TraceFilter
        {
            public SourceFilter(string source) => throw null;
            public override bool ShouldTrace(System.Diagnostics.TraceEventCache cache, string source, System.Diagnostics.TraceEventType eventType, int id, string formatOrMessage, object[] args, object data1, object[] data) => throw null;
            public string Source { get => throw null; set { } }
        }
        [System.Flags]
        public enum SourceLevels
        {
            All = -1,
            Off = 0,
            Critical = 1,
            Error = 3,
            Warning = 7,
            Information = 15,
            Verbose = 31,
            ActivityTracing = 65280,
        }
        public class SourceSwitch : System.Diagnostics.Switch
        {
            public SourceSwitch(string name) : base(default(string), default(string)) => throw null;
            public SourceSwitch(string displayName, string defaultSwitchValue) : base(default(string), default(string)) => throw null;
            public System.Diagnostics.SourceLevels Level { get => throw null; set { } }
            protected override void OnValueChanged() => throw null;
            public bool ShouldTrace(System.Diagnostics.TraceEventType eventType) => throw null;
        }
        public abstract class Switch
        {
            public System.Collections.Specialized.StringDictionary Attributes { get => throw null; }
            protected Switch(string displayName, string description) => throw null;
            protected Switch(string displayName, string description, string defaultSwitchValue) => throw null;
            public string DefaultValue { get => throw null; }
            public string Description { get => throw null; }
            public string DisplayName { get => throw null; }
            protected virtual string[] GetSupportedAttributes() => throw null;
            public static event System.EventHandler<System.Diagnostics.InitializingSwitchEventArgs> Initializing;
            protected virtual void OnSwitchSettingChanged() => throw null;
            protected virtual void OnValueChanged() => throw null;
            public void Refresh() => throw null;
            protected int SwitchSetting { get => throw null; set { } }
            public string Value { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)741)]
        public sealed class SwitchAttribute : System.Attribute
        {
            public SwitchAttribute(string switchName, System.Type switchType) => throw null;
            public static System.Diagnostics.SwitchAttribute[] GetAll(System.Reflection.Assembly assembly) => throw null;
            public string SwitchDescription { get => throw null; set { } }
            public string SwitchName { get => throw null; set { } }
            public System.Type SwitchType { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class SwitchLevelAttribute : System.Attribute
        {
            public SwitchLevelAttribute(System.Type switchLevelType) => throw null;
            public System.Type SwitchLevelType { get => throw null; set { } }
        }
        public sealed class Trace
        {
            public static void Assert(bool condition) => throw null;
            public static void Assert(bool condition, string message) => throw null;
            public static void Assert(bool condition, string message, string detailMessage) => throw null;
            public static bool AutoFlush { get => throw null; set { } }
            public static void Close() => throw null;
            public static System.Diagnostics.CorrelationManager CorrelationManager { get => throw null; }
            public static void Fail(string message) => throw null;
            public static void Fail(string message, string detailMessage) => throw null;
            public static void Flush() => throw null;
            public static void Indent() => throw null;
            public static int IndentLevel { get => throw null; set { } }
            public static int IndentSize { get => throw null; set { } }
            public static System.Diagnostics.TraceListenerCollection Listeners { get => throw null; }
            public static void Refresh() => throw null;
            public static event System.EventHandler Refreshing;
            public static void TraceError(string message) => throw null;
            public static void TraceError(string format, params object[] args) => throw null;
            public static void TraceInformation(string message) => throw null;
            public static void TraceInformation(string format, params object[] args) => throw null;
            public static void TraceWarning(string message) => throw null;
            public static void TraceWarning(string format, params object[] args) => throw null;
            public static void Unindent() => throw null;
            public static bool UseGlobalLock { get => throw null; set { } }
            public static void Write(object value) => throw null;
            public static void Write(object value, string category) => throw null;
            public static void Write(string message) => throw null;
            public static void Write(string message, string category) => throw null;
            public static void WriteIf(bool condition, object value) => throw null;
            public static void WriteIf(bool condition, object value, string category) => throw null;
            public static void WriteIf(bool condition, string message) => throw null;
            public static void WriteIf(bool condition, string message, string category) => throw null;
            public static void WriteLine(object value) => throw null;
            public static void WriteLine(object value, string category) => throw null;
            public static void WriteLine(string message) => throw null;
            public static void WriteLine(string message, string category) => throw null;
            public static void WriteLineIf(bool condition, object value) => throw null;
            public static void WriteLineIf(bool condition, object value, string category) => throw null;
            public static void WriteLineIf(bool condition, string message) => throw null;
            public static void WriteLineIf(bool condition, string message, string category) => throw null;
        }
        public class TraceEventCache
        {
            public string Callstack { get => throw null; }
            public TraceEventCache() => throw null;
            public System.DateTime DateTime { get => throw null; }
            public System.Collections.Stack LogicalOperationStack { get => throw null; }
            public int ProcessId { get => throw null; }
            public string ThreadId { get => throw null; }
            public long Timestamp { get => throw null; }
        }
        public enum TraceEventType
        {
            Critical = 1,
            Error = 2,
            Warning = 4,
            Information = 8,
            Verbose = 16,
            Start = 256,
            Stop = 512,
            Suspend = 1024,
            Resume = 2048,
            Transfer = 4096,
        }
        public abstract class TraceFilter
        {
            protected TraceFilter() => throw null;
            public abstract bool ShouldTrace(System.Diagnostics.TraceEventCache cache, string source, System.Diagnostics.TraceEventType eventType, int id, string formatOrMessage, object[] args, object data1, object[] data);
        }
        public enum TraceLevel
        {
            Off = 0,
            Error = 1,
            Warning = 2,
            Info = 3,
            Verbose = 4,
        }
        public abstract class TraceListener : System.MarshalByRefObject, System.IDisposable
        {
            public System.Collections.Specialized.StringDictionary Attributes { get => throw null; }
            public virtual void Close() => throw null;
            protected TraceListener() => throw null;
            protected TraceListener(string name) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public virtual void Fail(string message) => throw null;
            public virtual void Fail(string message, string detailMessage) => throw null;
            public System.Diagnostics.TraceFilter Filter { get => throw null; set { } }
            public virtual void Flush() => throw null;
            protected virtual string[] GetSupportedAttributes() => throw null;
            public int IndentLevel { get => throw null; set { } }
            public int IndentSize { get => throw null; set { } }
            public virtual bool IsThreadSafe { get => throw null; }
            public virtual string Name { get => throw null; set { } }
            protected bool NeedIndent { get => throw null; set { } }
            public virtual void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, object data) => throw null;
            public virtual void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, params object[] data) => throw null;
            public virtual void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id) => throw null;
            public virtual void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string message) => throw null;
            public virtual void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string format, params object[] args) => throw null;
            public System.Diagnostics.TraceOptions TraceOutputOptions { get => throw null; set { } }
            public virtual void TraceTransfer(System.Diagnostics.TraceEventCache eventCache, string source, int id, string message, System.Guid relatedActivityId) => throw null;
            public virtual void Write(object o) => throw null;
            public virtual void Write(object o, string category) => throw null;
            public abstract void Write(string message);
            public virtual void Write(string message, string category) => throw null;
            protected virtual void WriteIndent() => throw null;
            public virtual void WriteLine(object o) => throw null;
            public virtual void WriteLine(object o, string category) => throw null;
            public abstract void WriteLine(string message);
            public virtual void WriteLine(string message, string category) => throw null;
        }
        public class TraceListenerCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            public int Add(System.Diagnostics.TraceListener listener) => throw null;
            int System.Collections.IList.Add(object value) => throw null;
            public void AddRange(System.Diagnostics.TraceListenerCollection value) => throw null;
            public void AddRange(System.Diagnostics.TraceListener[] value) => throw null;
            public void Clear() => throw null;
            public bool Contains(System.Diagnostics.TraceListener listener) => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            public void CopyTo(System.Diagnostics.TraceListener[] listeners, int index) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public int IndexOf(System.Diagnostics.TraceListener listener) => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            public void Insert(int index, System.Diagnostics.TraceListener listener) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            public void Remove(System.Diagnostics.TraceListener listener) => throw null;
            public void Remove(string name) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public System.Diagnostics.TraceListener this[int i] { get => throw null; set { } }
            public System.Diagnostics.TraceListener this[string name] { get => throw null; }
        }
        [System.Flags]
        public enum TraceOptions
        {
            None = 0,
            LogicalOperationStack = 1,
            DateTime = 2,
            Timestamp = 4,
            ProcessId = 8,
            ThreadId = 16,
            Callstack = 32,
        }
        public class TraceSource
        {
            public System.Collections.Specialized.StringDictionary Attributes { get => throw null; }
            public void Close() => throw null;
            public TraceSource(string name) => throw null;
            public TraceSource(string name, System.Diagnostics.SourceLevels defaultLevel) => throw null;
            public System.Diagnostics.SourceLevels DefaultLevel { get => throw null; }
            public void Flush() => throw null;
            protected virtual string[] GetSupportedAttributes() => throw null;
            public static event System.EventHandler<System.Diagnostics.InitializingTraceSourceEventArgs> Initializing;
            public System.Diagnostics.TraceListenerCollection Listeners { get => throw null; }
            public string Name { get => throw null; }
            public System.Diagnostics.SourceSwitch Switch { get => throw null; set { } }
            public void TraceData(System.Diagnostics.TraceEventType eventType, int id, object data) => throw null;
            public void TraceData(System.Diagnostics.TraceEventType eventType, int id, params object[] data) => throw null;
            public void TraceEvent(System.Diagnostics.TraceEventType eventType, int id) => throw null;
            public void TraceEvent(System.Diagnostics.TraceEventType eventType, int id, string message) => throw null;
            public void TraceEvent(System.Diagnostics.TraceEventType eventType, int id, string format, params object[] args) => throw null;
            public void TraceInformation(string message) => throw null;
            public void TraceInformation(string format, params object[] args) => throw null;
            public void TraceTransfer(int id, string message, System.Guid relatedActivityId) => throw null;
        }
        public class TraceSwitch : System.Diagnostics.Switch
        {
            public TraceSwitch(string displayName, string description) : base(default(string), default(string)) => throw null;
            public TraceSwitch(string displayName, string description, string defaultSwitchValue) : base(default(string), default(string)) => throw null;
            public System.Diagnostics.TraceLevel Level { get => throw null; set { } }
            protected override void OnSwitchSettingChanged() => throw null;
            protected override void OnValueChanged() => throw null;
            public bool TraceError { get => throw null; }
            public bool TraceInfo { get => throw null; }
            public bool TraceVerbose { get => throw null; }
            public bool TraceWarning { get => throw null; }
        }
    }
}
