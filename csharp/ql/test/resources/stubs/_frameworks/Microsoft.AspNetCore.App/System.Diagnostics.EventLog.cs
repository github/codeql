// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.EntryWrittenEventArgs` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EntryWrittenEventArgs : System.EventArgs
        {
            public System.Diagnostics.EventLogEntry Entry { get => throw null; }
            public EntryWrittenEventArgs(System.Diagnostics.EventLogEntry entry) => throw null;
            public EntryWrittenEventArgs() => throw null;
        }

        // Generated from `System.Diagnostics.EntryWrittenEventHandler` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void EntryWrittenEventHandler(object sender, System.Diagnostics.EntryWrittenEventArgs e);

        // Generated from `System.Diagnostics.EventInstance` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventInstance
        {
            public int CategoryId { get => throw null; set => throw null; }
            public System.Diagnostics.EventLogEntryType EntryType { get => throw null; set => throw null; }
            public EventInstance(System.Int64 instanceId, int categoryId, System.Diagnostics.EventLogEntryType entryType) => throw null;
            public EventInstance(System.Int64 instanceId, int categoryId) => throw null;
            public System.Int64 InstanceId { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.EventLog` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLog : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public void BeginInit() => throw null;
            public void Clear() => throw null;
            public void Close() => throw null;
            public static void CreateEventSource(string source, string logName, string machineName) => throw null;
            public static void CreateEventSource(string source, string logName) => throw null;
            public static void CreateEventSource(System.Diagnostics.EventSourceCreationData sourceData) => throw null;
            public static void Delete(string logName, string machineName) => throw null;
            public static void Delete(string logName) => throw null;
            public static void DeleteEventSource(string source, string machineName) => throw null;
            public static void DeleteEventSource(string source) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public bool EnableRaisingEvents { get => throw null; set => throw null; }
            public void EndInit() => throw null;
            public System.Diagnostics.EventLogEntryCollection Entries { get => throw null; }
            public event System.Diagnostics.EntryWrittenEventHandler EntryWritten;
            public EventLog(string logName, string machineName, string source) => throw null;
            public EventLog(string logName, string machineName) => throw null;
            public EventLog(string logName) => throw null;
            public EventLog() => throw null;
            public static bool Exists(string logName, string machineName) => throw null;
            public static bool Exists(string logName) => throw null;
            public static System.Diagnostics.EventLog[] GetEventLogs(string machineName) => throw null;
            public static System.Diagnostics.EventLog[] GetEventLogs() => throw null;
            public string Log { get => throw null; set => throw null; }
            public string LogDisplayName { get => throw null; }
            public static string LogNameFromSourceName(string source, string machineName) => throw null;
            public string MachineName { get => throw null; set => throw null; }
            public System.Int64 MaximumKilobytes { get => throw null; set => throw null; }
            public int MinimumRetentionDays { get => throw null; }
            public void ModifyOverflowPolicy(System.Diagnostics.OverflowAction action, int retentionDays) => throw null;
            public System.Diagnostics.OverflowAction OverflowAction { get => throw null; }
            public void RegisterDisplayName(string resourceFile, System.Int64 resourceId) => throw null;
            public string Source { get => throw null; set => throw null; }
            public static bool SourceExists(string source, string machineName) => throw null;
            public static bool SourceExists(string source) => throw null;
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set => throw null; }
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID, System.Int16 category, System.Byte[] rawData) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID, System.Int16 category) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type, int eventID) => throw null;
            public void WriteEntry(string message, System.Diagnostics.EventLogEntryType type) => throw null;
            public void WriteEntry(string message) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID, System.Int16 category, System.Byte[] rawData) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID, System.Int16 category) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type, int eventID) => throw null;
            public static void WriteEntry(string source, string message, System.Diagnostics.EventLogEntryType type) => throw null;
            public static void WriteEntry(string source, string message) => throw null;
            public void WriteEvent(System.Diagnostics.EventInstance instance, params object[] values) => throw null;
            public void WriteEvent(System.Diagnostics.EventInstance instance, System.Byte[] data, params object[] values) => throw null;
            public static void WriteEvent(string source, System.Diagnostics.EventInstance instance, params object[] values) => throw null;
            public static void WriteEvent(string source, System.Diagnostics.EventInstance instance, System.Byte[] data, params object[] values) => throw null;
        }

        // Generated from `System.Diagnostics.EventLogEntry` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogEntry : System.ComponentModel.Component, System.Runtime.Serialization.ISerializable
        {
            public string Category { get => throw null; }
            public System.Int16 CategoryNumber { get => throw null; }
            public System.Byte[] Data { get => throw null; }
            public System.Diagnostics.EventLogEntryType EntryType { get => throw null; }
            public bool Equals(System.Diagnostics.EventLogEntry otherEntry) => throw null;
            public int EventID { get => throw null; }
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public int Index { get => throw null; }
            public System.Int64 InstanceId { get => throw null; }
            public string MachineName { get => throw null; }
            public string Message { get => throw null; }
            public string[] ReplacementStrings { get => throw null; }
            public string Source { get => throw null; }
            public System.DateTime TimeGenerated { get => throw null; }
            public System.DateTime TimeWritten { get => throw null; }
            public string UserName { get => throw null; }
        }

        // Generated from `System.Diagnostics.EventLogEntryCollection` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogEntryCollection : System.Collections.IEnumerable, System.Collections.ICollection
        {
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public void CopyTo(System.Diagnostics.EventLogEntry[] entries, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public virtual System.Diagnostics.EventLogEntry this[int index] { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }

        // Generated from `System.Diagnostics.EventLogEntryType` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum EventLogEntryType
        {
            Error,
            FailureAudit,
            Information,
            SuccessAudit,
            Warning,
        }

        // Generated from `System.Diagnostics.EventLogTraceListener` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogTraceListener : System.Diagnostics.TraceListener
        {
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public System.Diagnostics.EventLog EventLog { get => throw null; set => throw null; }
            public EventLogTraceListener(string source) => throw null;
            public EventLogTraceListener(System.Diagnostics.EventLog eventLog) => throw null;
            public EventLogTraceListener() => throw null;
            public override string Name { get => throw null; set => throw null; }
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, params object[] data) => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, object data) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, string message) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType severity, int id, string format, params object[] args) => throw null;
            public override void Write(string message) => throw null;
            public override void WriteLine(string message) => throw null;
        }

        // Generated from `System.Diagnostics.EventSourceCreationData` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventSourceCreationData
        {
            public int CategoryCount { get => throw null; set => throw null; }
            public string CategoryResourceFile { get => throw null; set => throw null; }
            public EventSourceCreationData(string source, string logName) => throw null;
            public string LogName { get => throw null; set => throw null; }
            public string MachineName { get => throw null; set => throw null; }
            public string MessageResourceFile { get => throw null; set => throw null; }
            public string ParameterResourceFile { get => throw null; set => throw null; }
            public string Source { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.OverflowAction` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum OverflowAction
        {
            DoNotOverwrite,
            OverwriteAsNeeded,
            OverwriteOlder,
        }

        namespace Eventing
        {
            namespace Reader
            {
                // Generated from `System.Diagnostics.Eventing.Reader.EventBookmark` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventBookmark
                {
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventKeyword` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventKeyword
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public System.Int64 Value { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLevel` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLevel
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogConfiguration` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogConfiguration : System.IDisposable
                {
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public EventLogConfiguration(string logName, System.Diagnostics.Eventing.Reader.EventLogSession session) => throw null;
                    public EventLogConfiguration(string logName) => throw null;
                    public bool IsClassicLog { get => throw null; }
                    public bool IsEnabled { get => throw null; set => throw null; }
                    public string LogFilePath { get => throw null; set => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogIsolation LogIsolation { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogMode LogMode { get => throw null; set => throw null; }
                    public string LogName { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogType LogType { get => throw null; }
                    public System.Int64 MaximumSizeInBytes { get => throw null; set => throw null; }
                    public string OwningProviderName { get => throw null; }
                    public int? ProviderBufferSize { get => throw null; }
                    public System.Guid? ProviderControlGuid { get => throw null; }
                    public System.Int64? ProviderKeywords { get => throw null; set => throw null; }
                    public int? ProviderLatency { get => throw null; }
                    public int? ProviderLevel { get => throw null; set => throw null; }
                    public int? ProviderMaximumNumberOfBuffers { get => throw null; }
                    public int? ProviderMinimumNumberOfBuffers { get => throw null; }
                    public System.Collections.Generic.IEnumerable<string> ProviderNames { get => throw null; }
                    public void SaveChanges() => throw null;
                    public string SecurityDescriptor { get => throw null; set => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogException` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogException : System.Exception
                {
                    public EventLogException(string message, System.Exception innerException) => throw null;
                    public EventLogException(string message) => throw null;
                    public EventLogException() => throw null;
                    protected EventLogException(int errorCode) => throw null;
                    protected EventLogException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public override string Message { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogInformation` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogInformation
                {
                    public int? Attributes { get => throw null; }
                    public System.DateTime? CreationTime { get => throw null; }
                    public System.Int64? FileSize { get => throw null; }
                    public bool? IsLogFull { get => throw null; }
                    public System.DateTime? LastAccessTime { get => throw null; }
                    public System.DateTime? LastWriteTime { get => throw null; }
                    public System.Int64? OldestRecordNumber { get => throw null; }
                    public System.Int64? RecordCount { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogInvalidDataException` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogInvalidDataException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogInvalidDataException(string message, System.Exception innerException) => throw null;
                    public EventLogInvalidDataException(string message) => throw null;
                    public EventLogInvalidDataException() => throw null;
                    protected EventLogInvalidDataException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogIsolation` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum EventLogIsolation
                {
                    Application,
                    Custom,
                    System,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogLink` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogLink
                {
                    public string DisplayName { get => throw null; }
                    public bool IsImported { get => throw null; }
                    public string LogName { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogMode` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum EventLogMode
                {
                    AutoBackup,
                    Circular,
                    Retain,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogNotFoundException` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogNotFoundException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogNotFoundException(string message, System.Exception innerException) => throw null;
                    public EventLogNotFoundException(string message) => throw null;
                    public EventLogNotFoundException() => throw null;
                    protected EventLogNotFoundException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogPropertySelector` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogPropertySelector : System.IDisposable
                {
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public EventLogPropertySelector(System.Collections.Generic.IEnumerable<string> propertyQueries) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogProviderDisabledException` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogProviderDisabledException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogProviderDisabledException(string message, System.Exception innerException) => throw null;
                    public EventLogProviderDisabledException(string message) => throw null;
                    public EventLogProviderDisabledException() => throw null;
                    protected EventLogProviderDisabledException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogQuery` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogQuery
                {
                    public EventLogQuery(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query) => throw null;
                    public EventLogQuery(string path, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public bool ReverseDirection { get => throw null; set => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogSession Session { get => throw null; set => throw null; }
                    public bool TolerateQueryErrors { get => throw null; set => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogReader` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogReader : System.IDisposable
                {
                    public int BatchSize { get => throw null; set => throw null; }
                    public void CancelReading() => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public EventLogReader(string path, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public EventLogReader(string path) => throw null;
                    public EventLogReader(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                    public EventLogReader(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery) => throw null;
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventLogStatus> LogStatus { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventRecord ReadEvent(System.TimeSpan timeout) => throw null;
                    public System.Diagnostics.Eventing.Reader.EventRecord ReadEvent() => throw null;
                    public void Seek(System.IO.SeekOrigin origin, System.Int64 offset) => throw null;
                    public void Seek(System.Diagnostics.Eventing.Reader.EventBookmark bookmark, System.Int64 offset) => throw null;
                    public void Seek(System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogReadingException` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogReadingException : System.Diagnostics.Eventing.Reader.EventLogException
                {
                    public EventLogReadingException(string message, System.Exception innerException) => throw null;
                    public EventLogReadingException(string message) => throw null;
                    public EventLogReadingException() => throw null;
                    protected EventLogReadingException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogRecord` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogRecord : System.Diagnostics.Eventing.Reader.EventRecord
                {
                    public override System.Guid? ActivityId { get => throw null; }
                    public override System.Diagnostics.Eventing.Reader.EventBookmark Bookmark { get => throw null; }
                    public string ContainerLog { get => throw null; }
                    protected override void Dispose(bool disposing) => throw null;
                    public override string FormatDescription(System.Collections.Generic.IEnumerable<object> values) => throw null;
                    public override string FormatDescription() => throw null;
                    public System.Collections.Generic.IList<object> GetPropertyValues(System.Diagnostics.Eventing.Reader.EventLogPropertySelector propertySelector) => throw null;
                    public override int Id { get => throw null; }
                    public override System.Int64? Keywords { get => throw null; }
                    public override System.Collections.Generic.IEnumerable<string> KeywordsDisplayNames { get => throw null; }
                    public override System.Byte? Level { get => throw null; }
                    public override string LevelDisplayName { get => throw null; }
                    public override string LogName { get => throw null; }
                    public override string MachineName { get => throw null; }
                    public System.Collections.Generic.IEnumerable<int> MatchedQueryIds { get => throw null; }
                    public override System.Int16? Opcode { get => throw null; }
                    public override string OpcodeDisplayName { get => throw null; }
                    public override int? ProcessId { get => throw null; }
                    public override System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventProperty> Properties { get => throw null; }
                    public override System.Guid? ProviderId { get => throw null; }
                    public override string ProviderName { get => throw null; }
                    public override int? Qualifiers { get => throw null; }
                    public override System.Int64? RecordId { get => throw null; }
                    public override System.Guid? RelatedActivityId { get => throw null; }
                    public override int? Task { get => throw null; }
                    public override string TaskDisplayName { get => throw null; }
                    public override int? ThreadId { get => throw null; }
                    public override System.DateTime? TimeCreated { get => throw null; }
                    public override string ToXml() => throw null;
                    public override System.Security.Principal.SecurityIdentifier UserId { get => throw null; }
                    public override System.Byte? Version { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogSession` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogSession : System.IDisposable
                {
                    public void CancelCurrentOperations() => throw null;
                    public void ClearLog(string logName, string backupPath) => throw null;
                    public void ClearLog(string logName) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public EventLogSession(string server, string domain, string user, System.Security.SecureString password, System.Diagnostics.Eventing.Reader.SessionAuthentication logOnType) => throw null;
                    public EventLogSession(string server) => throw null;
                    public EventLogSession() => throw null;
                    public void ExportLog(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath, bool tolerateQueryErrors) => throw null;
                    public void ExportLog(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath) => throw null;
                    public void ExportLogAndMessages(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath, bool tolerateQueryErrors, System.Globalization.CultureInfo targetCultureInfo) => throw null;
                    public void ExportLogAndMessages(string path, System.Diagnostics.Eventing.Reader.PathType pathType, string query, string targetFilePath) => throw null;
                    public System.Diagnostics.Eventing.Reader.EventLogInformation GetLogInformation(string logName, System.Diagnostics.Eventing.Reader.PathType pathType) => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetLogNames() => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetProviderNames() => throw null;
                    public static System.Diagnostics.Eventing.Reader.EventLogSession GlobalSession { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogStatus` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogStatus
                {
                    public string LogName { get => throw null; }
                    public int StatusCode { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogType` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum EventLogType
                {
                    Administrative,
                    Analytical,
                    Debug,
                    Operational,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventLogWatcher` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventLogWatcher : System.IDisposable
                {
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public bool Enabled { get => throw null; set => throw null; }
                    public EventLogWatcher(string path) => throw null;
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark, bool readExistingEvents) => throw null;
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery, System.Diagnostics.Eventing.Reader.EventBookmark bookmark) => throw null;
                    public EventLogWatcher(System.Diagnostics.Eventing.Reader.EventLogQuery eventQuery) => throw null;
                    public event System.EventHandler<System.Diagnostics.Eventing.Reader.EventRecordWrittenEventArgs> EventRecordWritten;
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventMetadata` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventMetadata
                {
                    public string Description { get => throw null; }
                    public System.Int64 Id { get => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Diagnostics.Eventing.Reader.EventKeyword> Keywords { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLevel Level { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventLogLink LogLink { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventOpcode Opcode { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventTask Task { get => throw null; }
                    public string Template { get => throw null; }
                    public System.Byte Version { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventOpcode` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventOpcode
                {
                    public string DisplayName { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventProperty` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventProperty
                {
                    public object Value { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventRecord` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public abstract class EventRecord : System.IDisposable
                {
                    public abstract System.Guid? ActivityId { get; }
                    public abstract System.Diagnostics.Eventing.Reader.EventBookmark Bookmark { get; }
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    protected EventRecord() => throw null;
                    public abstract string FormatDescription(System.Collections.Generic.IEnumerable<object> values);
                    public abstract string FormatDescription();
                    public abstract int Id { get; }
                    public abstract System.Int64? Keywords { get; }
                    public abstract System.Collections.Generic.IEnumerable<string> KeywordsDisplayNames { get; }
                    public abstract System.Byte? Level { get; }
                    public abstract string LevelDisplayName { get; }
                    public abstract string LogName { get; }
                    public abstract string MachineName { get; }
                    public abstract System.Int16? Opcode { get; }
                    public abstract string OpcodeDisplayName { get; }
                    public abstract int? ProcessId { get; }
                    public abstract System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventProperty> Properties { get; }
                    public abstract System.Guid? ProviderId { get; }
                    public abstract string ProviderName { get; }
                    public abstract int? Qualifiers { get; }
                    public abstract System.Int64? RecordId { get; }
                    public abstract System.Guid? RelatedActivityId { get; }
                    public abstract int? Task { get; }
                    public abstract string TaskDisplayName { get; }
                    public abstract int? ThreadId { get; }
                    public abstract System.DateTime? TimeCreated { get; }
                    public abstract string ToXml();
                    public abstract System.Security.Principal.SecurityIdentifier UserId { get; }
                    public abstract System.Byte? Version { get; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventRecordWrittenEventArgs` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventRecordWrittenEventArgs : System.EventArgs
                {
                    public System.Exception EventException { get => throw null; }
                    public System.Diagnostics.Eventing.Reader.EventRecord EventRecord { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.EventTask` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class EventTask
                {
                    public string DisplayName { get => throw null; }
                    public System.Guid EventGuid { get => throw null; }
                    public string Name { get => throw null; }
                    public int Value { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.PathType` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum PathType
                {
                    FilePath,
                    LogName,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.ProviderMetadata` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class ProviderMetadata : System.IDisposable
                {
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
                    public ProviderMetadata(string providerName, System.Diagnostics.Eventing.Reader.EventLogSession session, System.Globalization.CultureInfo targetCultureInfo) => throw null;
                    public ProviderMetadata(string providerName) => throw null;
                    public string ResourceFilePath { get => throw null; }
                    public System.Collections.Generic.IList<System.Diagnostics.Eventing.Reader.EventTask> Tasks { get => throw null; }
                }

                // Generated from `System.Diagnostics.Eventing.Reader.SessionAuthentication` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum SessionAuthentication
                {
                    Default,
                    Kerberos,
                    Negotiate,
                    Ntlm,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.StandardEventKeywords` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                [System.Flags]
                public enum StandardEventKeywords
                {
                    AuditFailure,
                    AuditSuccess,
                    CorrelationHint,
                    CorrelationHint2,
                    EventLogClassic,
                    None,
                    ResponseTime,
                    Sqm,
                    WdiContext,
                    WdiDiagnostic,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.StandardEventLevel` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum StandardEventLevel
                {
                    Critical,
                    Error,
                    Informational,
                    LogAlways,
                    Verbose,
                    Warning,
                }

                // Generated from `System.Diagnostics.Eventing.Reader.StandardEventOpcode` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum StandardEventOpcode
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

                // Generated from `System.Diagnostics.Eventing.Reader.StandardEventTask` in `System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum StandardEventTask
                {
                    None,
                }

            }
        }
    }
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Diagnostics.EventLog, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
}
