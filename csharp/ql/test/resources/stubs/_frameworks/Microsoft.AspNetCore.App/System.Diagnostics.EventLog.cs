// This file contains auto-generated code.
// Generated from `System.Diagnostics.EventLog, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Diagnostics
    {
        public class EntryWrittenEventArgs : System.EventArgs
        {
            public EntryWrittenEventArgs() => throw null;
            public EntryWrittenEventArgs(System.Diagnostics.EventLogEntry entry) => throw null;
            public System.Diagnostics.EventLogEntry Entry { get => throw null; }
        }
        public delegate void EntryWrittenEventHandler(object sender, System.Diagnostics.EntryWrittenEventArgs e);
        namespace Eventing
        {
            namespace Reader
            {
                public sealed class EventBookmark
                {
                    public string BookmarkXml { get => throw null; }
                    public EventBookmark(string bookmarkXml) => throw null;
                }
                public sealed class EventKeyword
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public long Value { get => throw null; }
                }
                public sealed class EventLevel
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }
                public class EventLogConfiguration : System.IDisposable
                {
                    public EventLogConfiguration(string logName) => throw null;
                    public EventLogConfiguration(string logName, System.Diagnostics.Eventing.Reader.EventLogSession session) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public bool IsClassicLog { get => throw null; }
                    public bool IsEnabled { get => throw null; set { } }
                    public string LogFilePath { get => throw null; set { } }
                    public System.Diagnostics.Eventing.Reader.EventLogIsolation LogIsolation { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogMode LogMode { get => throw null; set { } }
                    public string LogName { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogType LogType { get => throw null; }
                    public long MaximumSizeInBytes { get => throw null; set { } }
                    public string OwningProviderName { get => throw null; }
                    public int? ProviderBufferSize { get => throw null; }
                    public System.Guid? ProviderControlGuid { get => throw null; }
                    public long? ProviderKeywords { get => throw null; set { } }
                    public int? ProviderLatency { get => throw null; }
                    public int? ProviderLevel { get => throw null; set { } }
                    public int? ProviderMaximumNumberOfBuffers { get => throw null; }
                    public int? ProviderMinimumNumberOfBuffers { get => throw null; }
                    public System.Collections.Generic.IEnumerable<string> ProviderNames { get => throw null; }
                    public void SaveChanges() => throw null;
                    public string SecurityDescriptor { get => throw null; set { } }
                }
                public class EventLogException : System.Exception
                {
                    public EventLogException() => throw null;
                    protected EventLogException(int errorCode) => throw null;
                    protected EventLogException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public EventLogException(string message) => throw null;
                    public EventLogException(string message, System.Exception innerException) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public override string Message { get => throw null; }
                }
                public sealed class EventLogInformation
                {
                    public int? Attributes { get => throw null; }
                    public System.DateTime? CreationTime { get => throw null; }
                    public long? FileSize { get => throw null; }
                    public bool? IsLogFull { get => throw null; }
                    public System.DateTime? LastAccessTime { get => throw null; }
                    public System.DateTime? LastWriteTime { get => throw null; }
                    public long? OldestRecordNumber { get => throw null; }
                    public long? RecordCount { get => throw null; }
                }
                public class EventLogInvalidDataException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogInvalidDataException() => throw null;
                    protected EventLogInvalidDataException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public EventLogInvalidDataException(string message) => throw null;
                    public EventLogInvalidDataException(string message, System.Exception innerException) => throw null;
                }
                public enum EventLogIsolation
                {
                    Application = 0,
                    System = 1,
                    Custom = 2,
                }
                public sealed class EventLogLink
                {
                    public string DisplayName { get => throw null; }
                    public bool IsImported { get => throw null; }
                    public string LogName { get => throw null; }
                }
                public enum EventLogMode
                {
                    Circular = 0,
                    AutoBackup = 1,
                    Retain = 2,
                }
                public class EventLogNotFoundException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogNotFoundException() => throw null;
                    protected EventLogNotFoundException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public EventLogNotFoundException(string message) => throw null;
                    public EventLogNotFoundException(string message, System.Exception innerException) => throw null;
                }
                public class EventLogPropertySelector : System.IDisposable
                {
                    public EventLogPropertySelector(System.Collections.Generic.IEnumerable<string> propertyQueries) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                }
                public class EventLogProviderDisabledException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogProviderDisabledException() => throw null;
                    protected EventLogProviderDisabledException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public EventLogProviderDisabledException(string message) => throw null;
                    public EventLogProviderDisabledException(string message, System.Exception innerException) => throw null;
                }
                public class EventLogQuery
                {
                    public EventLogQuery(string path, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public EventLogQuery(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query) => throw null;
                    public bool ReverseDirection { get => throw null; set { } }
                    public System.Diagnostics.Eventing.Reader.EventLogSession Session { get => throw null; set { } }
                    public bool TolerateQueryErrors { get => throw null; set { } }
                }
                public class EventLogReader : System.IDisposable
                {
                    public int BatchSize { get => throw null; set { } }
                    public void CancelReading() => throw null;
                    public EventLogReader(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery) => throw null;
                    public EventLogReader(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                    public EventLogReader(string path) => throw null;
                    public EventLogReader(string path, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventLogStatus> LogStatus { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventRecord ReadEvent() => throw null;
                    public System.Diagnostics.Eventing.Reader.EventRecord ReadEvent(System.TimeSpan timeout) => throw null;
                    public void Seek(System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                    public void Seek(System.Diagnostics.Eventing.Reader.EventBookmark bookmark, long offset) => throw null;
                    public void Seek(System.IO.SeekOrigin origin, long offset) => throw null;
                }
                public class EventLogReadingException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogReadingException() => throw null;
                    protected EventLogReadingException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public EventLogReadingException(string message) => throw null;
                    public EventLogReadingException(string message, System.Exception innerException) => throw null;
                }
                public class EventLogRecord : System.Diagnostics.Eventing.Reader.EventRecord
                {
                    public override System.Guid? ActivityId { get => throw null; }
                    public override System.Diagnostics.Eventing.Reader.EventBookmark Bookmark { get => throw null; }
                    public string ContainerLog { get => throw null; }
                    protected override void Dispose(bool disposing) => throw null;
                    public override string FormatDescription() => throw null;
                    public override string FormatDescription(System.Collections.Generic.IEnumerable<object> values) => throw null;
                    public System.Collections.Generic.IList<object> GetPropertyValues(System.Diagnostics.Eventing.Reader.EventLogPropertySelector propertySelector) => throw null;
                    public override int Id { get => throw null; }
                    public override long? Keywords { get => throw null; }
                    public override System.Collections.Generic.IEnumerable<string> KeywordsDisplayNames { get => throw null; }
                    public override byte? Level { get => throw null; }
                    public override string LevelDisplayName { get => throw null; }
                    public override string LogName { get => throw null; }
                    public override string MachineName { get => throw null; }
                    public System.Collections.Generic.IEnumerable<int> MatchedQueryIds { get => throw null; }
                    public override short? Opcode { get => throw null; }
                    public override string OpcodeDisplayName { get => throw null; }
                    public override int? ProcessId { get => throw null; }
                    public override System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventProperty> Properties { get => throw null; }
                    public override System.Guid? ProviderId { get => throw null; }
                    public override string ProviderName { get => throw null; }
                    public override int? Qualifiers { get => throw null; }
                    public override long? RecordId { get => throw null; }
                    public override System.Guid? RelatedActivityId { get => throw null; }
                    public override int? Task { get => throw null; }
                    public override string TaskDisplayName { get => throw null; }
                    public override int? ThreadId { get => throw null; }
                    public override System.DateTime? TimeCreated { get => throw null; }
                    public override string ToXml() => throw null;
                    public override System.Security.Principal.SecurityIdentifier UserId { get => throw null; }
                    public override byte? Version { get => throw null; }
                }
                public class EventLogSession : System.IDisposable
                {
                    public void CancelCurrentOperations() => throw null;
                    public void ClearLog(string logName) => throw null;
                    public void ClearLog(string logName, string backupPath) => throw null;
                    public EventLogSession() => throw null;
                    public EventLogSession(string server) => throw null;
                    public EventLogSession(string server, string domain, string user, System.Security.SecureString password, System.Diagnostics.Eventing.Reader.SessionAuthentication logOnType) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public void ExportLog(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath) => throw null;
                    public void ExportLog(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath, bool tolerateQueryErrors) => throw null;
                    public void ExportLogAndMessages(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath) => throw null;
                    public void ExportLogAndMessages(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath, bool tolerateQueryErrors, System.Globalization.CultureInfo targetCultureInfo) => throw null;
                    public System.Diagnostics.Eventing.Reader.EventLogInformation GetLogInformation(string logName, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetLogNames() => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetProviderNames() => throw null;
                    public static System.Diagnostics.Eventing.Reader.EventLogSession GlobalSession { get => throw null; }
                }
                public sealed class EventLogStatus
                {
                    public string LogName { get => throw null; }
                    public int StatusCode { get => throw null; }
                }
                public enum EventLogType
                {
                    Administrative = 0,
                    Operational = 1,
                    Analytical = 2,
                    Debug = 3,
                }
                public class EventLogWatcher : System.IDisposable
                {
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery) => throw null;
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark, bool readExistingEvents) => throw null;
                    public EventLogWatcher(string path) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public bool Enabled { get => throw null; set { } }
                    public event System.EventHandler<System.Diagnostics.Eventing.Reader.EventRecordWrittenEventArgs> EventRecordWritten;
                }
                public sealed class EventMetadata
                {
                    public string Description { get => throw null; }
                    public long Id { get => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Diagnostics.Eventing.Reader.EventKeyword> Keywords { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLevel Level { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogLink LogLink { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventOpcode Opcode { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventTask Task { get => throw null; }
                    public string Template { get => throw null; }
                    public byte Version { get => throw null; }
                }
                public sealed class EventOpcode
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }
                public sealed class EventProperty
                {
                    public object Value { get => throw null; }
                }
                public abstract class EventRecord : System.IDisposable
                {
                    public abstract System.Guid? ActivityId { get; }
                    public abstract System.Diagnostics.Eventing.Reader.EventBookmark Bookmark { get; }
                    protected EventRecord() => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public abstract string FormatDescription();
                    public abstract string FormatDescription(System.Collections.Generic.IEnumerable<object> values);
                    public abstract int Id { get; }
                    public abstract long? Keywords { get; }
                    public abstract System.Collections.Generic.IEnumerable<string> KeywordsDisplayNames { get; }
                    public abstract byte? Level { get; }
                    public abstract string LevelDisplayName { get; }
                    public abstract string LogName { get; }
                    public abstract string MachineName { get; }
                    public abstract short? Opcode { get; }
                    public abstract string OpcodeDisplayName { get; }
                    public abstract int? ProcessId { get; }
                    public abstract System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventProperty> Properties { get; }
                    public abstract System.Guid? ProviderId { get; }
                    public abstract string ProviderName { get; }
                    public abstract int? Qualifiers { get; }
                    public abstract long? RecordId { get; }
                    public abstract System.Guid? RelatedActivityId { get; }
                    public abstract int? Task { get; }
                    public abstract string TaskDisplayName { get; }
                    public abstract int? ThreadId { get; }
                    public abstract System.DateTime? TimeCreated { get; }
                    public abstract string ToXml();
                    public abstract System.Security.Principal.SecurityIdentifier UserId { get; }
                    public abstract byte? Version { get; }
                }
                public sealed class EventRecordWrittenEventArgs : System.EventArgs
                {
                    public System.Exception EventException { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventRecord EventRecord { get => throw null; }
                }
                public sealed class EventTask
                {
                    public string DisplayName { get => throw null; }
                    public System.Guid EventGuid { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }
                public enum PathType
                {
                    LogName = 1,
                    FilePath = 2,
                }
                public class ProviderMetadata : System.IDisposable
                {
                    public ProviderMetadata(string providerName) => throw null;
                    public ProviderMetadata(string providerName, System.Diagnostics.Eventing.Reader.EventLogSession session, System.Globalization.CultureInfo targetCultureInfo) => throw null;
                    public string DisplayName { get => throw null; }
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Diagnostics.Eventing.Reader.EventMetadata> Events { get => throw null; }
                    public System.Uri HelpLink { get => throw null; }
                    public System.Guid Id { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventKeyword> Keywords { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventLevel> Levels { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventLogLink> LogLinks { get => throw null; }
                    public string MessageFilePath { get => throw null; }
                    public string Name { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventOpcode> Opcodes { get => throw null; }
                    public string ParameterFilePath { get => throw null; }
                    public string ResourceFilePath { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventTask> Tasks { get => throw null; }
                }
                public enum SessionAuthentication
                {
                    Default = 0,
                    Negotiate = 1,
                    Kerberos = 2,
                    Ntlm = 3,
                }
                [System.Flags]
                public enum StandardEventKeywords : long
                {
                    None = 0,
                    ResponseTime = 281474976710656,
                    WdiContext = 562949953421312,
                    WdiDiagnostic = 1125899906842624,
                    Sqm = 2251799813685248,
                    AuditFailure = 4503599627370496,
                    CorrelationHint = 4503599627370496,
                    AuditSuccess = 9007199254740992,
                    CorrelationHint2 = 18014398509481984,
                    EventLogClassic = 36028797018963968,
                }
                public enum StandardEventLevel
                {
                    LogAlways = 0,
                    Critical = 1,
                    Error = 2,
                    Warning = 3,
                    Informational = 4,
                    Verbose = 5,
                }
                public enum StandardEventOpcode
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
                public enum StandardEventTask
                {
                    None = 0,
                }
            }
        }
        public class EventInstance
        {
            public int CategoryId { get => throw null; set { } }
            public EventInstance(long instanceId, int categoryId) => throw null;
            public EventInstance(long instanceId, int categoryId, System.Diagnostics.EventLogEntryType entryType) => throw null;
            public System.Diagnostics.EventLogEntryType EntryType { get => throw null; set { } }
            public long InstanceId { get => throw null; set { } }
        }
        public class EventLog : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public void BeginInit() => throw null;
            public void Clear() => throw null;
            public void Close() => throw null;
            public static void CreateEventSource(System.Diagnostics.EventSourceCreationData sourceData) => throw null;
            public static void CreateEventSource(string source, string logName) => throw null;
            public static void CreateEventSource(string source, string logName, string machineName) => throw null;
            public EventLog() => throw null;
            public EventLog(string logName) => throw null;
            public EventLog(string logName, string machineName) => throw null;
            public EventLog(string logName, string machineName, string source) => throw null;
            public static void Delete(string logName) => throw null;
            public static void Delete(string logName, string machineName) => throw null;
            public static void DeleteEventSource(string source) => throw null;
            public static void DeleteEventSource(string source, string machineName) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public bool EnableRaisingEvents { get => throw null; set { } }
            public void EndInit() => throw null;
            public System.Diagnostics.EventLogEntryCollection Entries { get => throw null; }
            public event System.Diagnostics.EntryWrittenEventHandler EntryWritten;
            public static bool Exists(string logName) => throw null;
            public static bool Exists(string logName, string machineName) => throw null;
            public static System.Diagnostics.EventLog[] GetEventLogs() => throw null;
            public static System.Diagnostics.EventLog[] GetEventLogs(string machineName) => throw null;
            public string Log { get => throw null; set { } }
            public string LogDisplayName { get => throw null; }
            public static string LogNameFromSourceName(string source, string machineName) => throw null;
            public string MachineName { get => throw null; set { } }
            public long MaximumKilobytes { get => throw null; set { } }
            public int MinimumRetentionDays { get => throw null; }
            public void ModifyOverflowPolicy(System.Diagnostics.OverflowAction action, int retentionDays) => throw null;
            public System.Diagnostics.OverflowAction OverflowAction { get => throw null; }
            public void RegisterDisplayName(string resourceFile, long resourceId) => throw null;
            public string Source { get => throw null; set { } }
            public static bool SourceExists(string source) => throw null;
            public static bool SourceExists(string source, string machineName) => throw null;
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set { } }
            public void WriteEntry(string message) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID, short category) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID, short category, byte[] rawData) => throw null;
            public static void WriteEntry(string source, string message) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID, short category) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID, short category, byte[] rawData) => throw null;
            public void WriteEvent(System.Diagnostics.EventInstance instance, byte[] data, params object[] values) => throw null;
            public void WriteEvent(System.Diagnostics.EventInstance instance, params object[] values) => throw null;
            public static void WriteEvent(string source, System.Diagnostics.EventInstance instance, byte[] data, params object[] values) => throw null;
            public static void WriteEvent(string source, System.Diagnostics.EventInstance instance, params object[] values) => throw null;
        }
        public sealed class EventLogEntry : System.ComponentModel.Component, System.Runtime.Serialization.ISerializable
        {
            public string Category { get => throw null; }
            public short CategoryNumber { get => throw null; }
            public byte[] Data { get => throw null; }
            public System.Diagnostics.EventLogEntryType EntryType { get => throw null; }
            public bool Equals(System.Diagnostics.EventLogEntry otherEntry) => throw null;
            public int EventID { get => throw null; }
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public int Index { get => throw null; }
            public long InstanceId { get => throw null; }
            public string MachineName { get => throw null; }
            public string Message { get => throw null; }
            public string[] ReplacementStrings { get => throw null; }
            public string Source { get => throw null; }
            public System.DateTime TimeGenerated { get => throw null; }
            public System.DateTime TimeWritten { get => throw null; }
            public string UserName { get => throw null; }
        }
        public class EventLogEntryCollection : System.Collections.ICollection, System.Collections.IEnumerable
        {
            public void CopyTo(System.Diagnostics.EventLogEntry[] entries, int index) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public virtual System.Diagnostics.EventLogEntry this[int index] { get => throw null; }
        }
        public enum EventLogEntryType
        {
            Error = 1,
            Warning = 2,
            Information = 4,
            SuccessAudit = 8,
            FailureAudit = 16,
        }
        public sealed class EventLogTraceListener : System.Diagnostics.TraceListener
        {
            public override void Close() => throw null;
            public EventLogTraceListener() => throw null;
            public EventLogTraceListener(System.Diagnostics.EventLog eventLog) => throw null;
            public EventLogTraceListener(string source) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public System.Diagnostics.EventLog EventLog { get => throw null; set { } }
            public override string Name { get => throw null; set { } }
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, object data) => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, params object[] data) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, string message) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, string format, params object[] args) => throw null;
            public override void Write(string message) => throw null;
            public override void WriteLine(string message) => throw null;
        }
        public class EventSourceCreationData
        {
            public int CategoryCount { get => throw null; set { } }
            public string CategoryResourceFile { get => throw null; set { } }
            public EventSourceCreationData(string source, string logName) => throw null;
            public string LogName { get => throw null; set { } }
            public string MachineName { get => throw null; set { } }
            public string MessageResourceFile { get => throw null; set { } }
            public string ParameterResourceFile { get => throw null; set { } }
            public string Source { get => throw null; set { } }
        }
        public enum OverflowAction
        {
            DoNotOverwrite = -1,
            OverwriteAsNeeded = 0,
            OverwriteOlder = 1,
        }
    }
}
