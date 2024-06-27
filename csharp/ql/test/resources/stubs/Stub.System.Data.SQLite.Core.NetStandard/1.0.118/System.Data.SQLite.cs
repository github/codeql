// This file contains auto-generated code.
// Generated from `System.Data.SQLite, Version=1.0.118.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`.
namespace System
{
    namespace Data
    {
        namespace SQLite
        {
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false)]
            public sealed class AssemblySourceIdAttribute : System.Attribute
            {
                public AssemblySourceIdAttribute(string value) => throw null;
                public string SourceId { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)1, Inherited = false)]
            public sealed class AssemblySourceTimeStampAttribute : System.Attribute
            {
                public AssemblySourceTimeStampAttribute(string value) => throw null;
                public string SourceTimeStamp { get => throw null; }
            }
            public class AuthorizerEventArgs : System.EventArgs
            {
                public readonly System.Data.SQLite.SQLiteAuthorizerActionCode ActionCode;
                public readonly string Argument1;
                public readonly string Argument2;
                public readonly string Context;
                public readonly string Database;
                public System.Data.SQLite.SQLiteAuthorizerReturnCode ReturnCode;
                public readonly nint UserData;
            }
            public class BusyEventArgs : System.EventArgs
            {
                public readonly int Count;
                public System.Data.SQLite.SQLiteBusyReturnCode ReturnCode;
                public readonly nint UserData;
            }
            public enum CollationEncodingEnum
            {
                UTF8 = 1,
                UTF16LE = 2,
                UTF16BE = 3,
            }
            public struct CollationSequence
            {
                public int Compare(string s1, string s2) => throw null;
                public int Compare(char[] c1, char[] c2) => throw null;
                public System.Data.SQLite.CollationEncodingEnum Encoding;
                public string Name;
                public System.Data.SQLite.CollationTypeEnum Type;
            }
            public enum CollationTypeEnum
            {
                Binary = 1,
                NoCase = 2,
                Reverse = 3,
                Custom = 0,
            }
            public class CommitEventArgs : System.EventArgs
            {
                public bool AbortTransaction;
            }
            public class ConnectionEventArgs : System.EventArgs
            {
                public readonly System.Data.IDbCommand Command;
                public readonly System.Runtime.InteropServices.CriticalHandle CriticalHandle;
                public readonly object Data;
                public readonly System.Data.IDataReader DataReader;
                public readonly System.Data.StateChangeEventArgs EventArgs;
                public readonly System.Data.SQLite.SQLiteConnectionEventType EventType;
                public string Result { get => throw null; set { } }
                public readonly string Text;
                public readonly System.Data.IDbTransaction Transaction;
            }
            public enum FunctionType
            {
                Scalar = 0,
                Aggregate = 1,
                Collation = 2,
                Window = 3,
            }
            namespace Generic
            {
                public class SQLiteModuleEnumerable<T> : System.Data.SQLite.SQLiteModuleEnumerable
                {
                    public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                    public SQLiteModuleEnumerable(string name, System.Collections.Generic.IEnumerable<T> enumerable) : base(default(string), default(System.Collections.IEnumerable)) => throw null;
                    protected override void Dispose(bool disposing) => throw null;
                    public override System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                }
                public class SQLiteVirtualTableCursorEnumerator<T> : System.Data.SQLite.SQLiteVirtualTableCursorEnumerator, System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    public override void Close() => throw null;
                    public SQLiteVirtualTableCursorEnumerator(System.Data.SQLite.SQLiteVirtualTable table, System.Collections.Generic.IEnumerator<T> enumerator) : base(default(System.Data.SQLite.SQLiteVirtualTable), default(System.Collections.IEnumerator)) => throw null;
                    T System.Collections.Generic.IEnumerator<T>.Current { get => throw null; }
                    protected override void Dispose(bool disposing) => throw null;
                }
            }
            public interface ISQLiteChangeGroup : System.IDisposable
            {
                void AddChangeSet(byte[] rawData);
                void AddChangeSet(System.IO.Stream stream);
                void CreateChangeSet(ref byte[] rawData);
                void CreateChangeSet(System.IO.Stream stream);
            }
            public interface ISQLiteChangeSet : System.IDisposable, System.Collections.Generic.IEnumerable<System.Data.SQLite.ISQLiteChangeSetMetadataItem>, System.Collections.IEnumerable
            {
                void Apply(System.Data.SQLite.SessionConflictCallback conflictCallback, object clientData);
                void Apply(System.Data.SQLite.SessionConflictCallback conflictCallback, System.Data.SQLite.SessionTableFilterCallback tableFilterCallback, object clientData);
                System.Data.SQLite.ISQLiteChangeSet CombineWith(System.Data.SQLite.ISQLiteChangeSet changeSet);
                System.Data.SQLite.ISQLiteChangeSet Invert();
            }
            public interface ISQLiteChangeSetMetadataItem : System.IDisposable
            {
                System.Data.SQLite.SQLiteValue GetConflictValue(int columnIndex);
                System.Data.SQLite.SQLiteValue GetNewValue(int columnIndex);
                System.Data.SQLite.SQLiteValue GetOldValue(int columnIndex);
                bool Indirect { get; }
                int NumberOfColumns { get; }
                int NumberOfForeignKeyConflicts { get; }
                System.Data.SQLite.SQLiteAuthorizerActionCode OperationCode { get; }
                bool[] PrimaryKeyColumns { get; }
                string TableName { get; }
            }
            public interface ISQLiteConnectionPool
            {
                void Add(string fileName, object handle, int version);
                void ClearAllPools();
                void ClearPool(string fileName);
                void GetCounts(string fileName, ref System.Collections.Generic.Dictionary<string, int> counts, ref int openCount, ref int closeCount, ref int totalCount);
                object Remove(string fileName, int maxPoolSize, out int version);
            }
            public interface ISQLiteConnectionPool2 : System.Data.SQLite.ISQLiteConnectionPool
            {
                void GetCounts(ref int openCount, ref int closeCount);
                void Initialize(object argument);
                void ResetCounts();
                void Terminate(object argument);
            }
            public interface ISQLiteManagedModule
            {
                System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index);
                System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index);
                System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                bool Declared { get; }
                System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table);
                bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values);
                bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref nint pClientData);
                string Name { get; }
                System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Release(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName);
                System.Data.SQLite.SQLiteErrorCode Rollback(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode RollbackTo(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref long rowId);
                System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref long rowId);
            }
            public interface ISQLiteNativeHandle
            {
                nint NativeHandle { get; }
            }
            public interface ISQLiteNativeModule
            {
                System.Data.SQLite.SQLiteErrorCode xBegin(nint pVtab);
                System.Data.SQLite.SQLiteErrorCode xBestIndex(nint pVtab, nint pIndex);
                System.Data.SQLite.SQLiteErrorCode xClose(nint pCursor);
                System.Data.SQLite.SQLiteErrorCode xColumn(nint pCursor, nint pContext, int index);
                System.Data.SQLite.SQLiteErrorCode xCommit(nint pVtab);
                System.Data.SQLite.SQLiteErrorCode xConnect(nint pDb, nint pAux, int argc, nint argv, ref nint pVtab, ref nint pError);
                System.Data.SQLite.SQLiteErrorCode xCreate(nint pDb, nint pAux, int argc, nint argv, ref nint pVtab, ref nint pError);
                System.Data.SQLite.SQLiteErrorCode xDestroy(nint pVtab);
                System.Data.SQLite.SQLiteErrorCode xDisconnect(nint pVtab);
                int xEof(nint pCursor);
                System.Data.SQLite.SQLiteErrorCode xFilter(nint pCursor, int idxNum, nint idxStr, int argc, nint argv);
                int xFindFunction(nint pVtab, int nArg, nint zName, ref System.Data.SQLite.SQLiteCallback callback, ref nint pClientData);
                System.Data.SQLite.SQLiteErrorCode xNext(nint pCursor);
                System.Data.SQLite.SQLiteErrorCode xOpen(nint pVtab, ref nint pCursor);
                System.Data.SQLite.SQLiteErrorCode xRelease(nint pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xRename(nint pVtab, nint zNew);
                System.Data.SQLite.SQLiteErrorCode xRollback(nint pVtab);
                System.Data.SQLite.SQLiteErrorCode xRollbackTo(nint pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xRowId(nint pCursor, ref long rowId);
                System.Data.SQLite.SQLiteErrorCode xSavepoint(nint pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xSync(nint pVtab);
                System.Data.SQLite.SQLiteErrorCode xUpdate(nint pVtab, int argc, nint argv, ref long rowId);
            }
            public interface ISQLiteSchemaExtensions
            {
                void BuildTempSchema(System.Data.SQLite.SQLiteConnection connection);
            }
            public interface ISQLiteSession : System.IDisposable
            {
                void AttachTable(string name);
                void CreateChangeSet(ref byte[] rawData);
                void CreateChangeSet(System.IO.Stream stream);
                void CreatePatchSet(ref byte[] rawData);
                void CreatePatchSet(System.IO.Stream stream);
                long GetMemoryBytesInUse();
                bool IsEmpty();
                bool IsEnabled();
                bool IsIndirect();
                void LoadDifferencesFromTable(string fromDatabaseName, string tableName);
                void SetTableFilter(System.Data.SQLite.SessionTableFilterCallback callback, object clientData);
                void SetToDirect();
                void SetToDisabled();
                void SetToEnabled();
                void SetToIndirect();
            }
            public class LogEventArgs : System.EventArgs
            {
                public readonly object Data;
                public readonly object ErrorCode;
                public readonly string Message;
            }
            public class ProgressEventArgs : System.EventArgs
            {
                public System.Data.SQLite.SQLiteProgressReturnCode ReturnCode;
                public readonly nint UserData;
            }
            public delegate System.Data.SQLite.SQLiteChangeSetConflictResult SessionConflictCallback(object clientData, System.Data.SQLite.SQLiteChangeSetConflictType type, System.Data.SQLite.ISQLiteChangeSetMetadataItem item);
            public delegate bool SessionTableFilterCallback(object clientData, string name);
            public enum SQLiteAuthorizerActionCode
            {
                None = -1,
                Copy = 0,
                CreateIndex = 1,
                CreateTable = 2,
                CreateTempIndex = 3,
                CreateTempTable = 4,
                CreateTempTrigger = 5,
                CreateTempView = 6,
                CreateTrigger = 7,
                CreateView = 8,
                Delete = 9,
                DropIndex = 10,
                DropTable = 11,
                DropTempIndex = 12,
                DropTempTable = 13,
                DropTempTrigger = 14,
                DropTempView = 15,
                DropTrigger = 16,
                DropView = 17,
                Insert = 18,
                Pragma = 19,
                Read = 20,
                Select = 21,
                Transaction = 22,
                Update = 23,
                Attach = 24,
                Detach = 25,
                AlterTable = 26,
                Reindex = 27,
                Analyze = 28,
                CreateVtable = 29,
                DropVtable = 30,
                Function = 31,
                Savepoint = 32,
                Recursive = 33,
            }
            public delegate void SQLiteAuthorizerEventHandler(object sender, System.Data.SQLite.AuthorizerEventArgs e);
            public enum SQLiteAuthorizerReturnCode
            {
                Ok = 0,
                Deny = 1,
                Ignore = 2,
            }
            public delegate bool SQLiteBackupCallback(System.Data.SQLite.SQLiteConnection source, string sourceName, System.Data.SQLite.SQLiteConnection destination, string destinationName, int pages, int remainingPages, int totalPages, bool retry);
            public delegate void SQLiteBindValueCallback(System.Data.SQLite.SQLiteConvert convert, System.Data.SQLite.SQLiteCommand command, System.Data.SQLite.SQLiteConnectionFlags flags, System.Data.SQLite.SQLiteParameter parameter, string typeName, int index, object userData, out bool complete);
            public sealed class SQLiteBlob : System.IDisposable
            {
                public void Close() => throw null;
                public static System.Data.SQLite.SQLiteBlob Create(System.Data.SQLite.SQLiteDataReader dataReader, int i, bool readOnly) => throw null;
                public static System.Data.SQLite.SQLiteBlob Create(System.Data.SQLite.SQLiteConnection connection, string databaseName, string tableName, string columnName, long rowId, bool readOnly) => throw null;
                public void Dispose() => throw null;
                public int GetCount() => throw null;
                public void Read(byte[] buffer, int count, int offset) => throw null;
                public void Reopen(long rowId) => throw null;
                public void Write(byte[] buffer, int count, int offset) => throw null;
            }
            public delegate void SQLiteBusyEventHandler(object sender, System.Data.SQLite.BusyEventArgs e);
            public enum SQLiteBusyReturnCode
            {
                Stop = 0,
                Retry = 1,
            }
            public delegate void SQLiteCallback(nint context, int argc, nint argv);
            public enum SQLiteChangeSetConflictResult
            {
                Omit = 0,
                Replace = 1,
                Abort = 2,
            }
            public enum SQLiteChangeSetConflictType
            {
                Data = 1,
                NotFound = 2,
                Conflict = 3,
                Constraint = 4,
                ForeignKey = 5,
            }
            public enum SQLiteChangeSetStartFlags
            {
                None = 0,
                Invert = 2,
            }
            public sealed class SQLiteCommand : System.Data.Common.DbCommand, System.ICloneable
            {
                public override void Cancel() => throw null;
                public object Clone() => throw null;
                public static System.Data.CommandBehavior? CombineBehaviors(System.Data.CommandBehavior? behavior, string flags, out string error) => throw null;
                public override string CommandText { get => throw null; set { } }
                public override int CommandTimeout { get => throw null; set { } }
                public override System.Data.CommandType CommandType { get => throw null; set { } }
                public System.Data.SQLite.SQLiteConnection Connection { get => throw null; set { } }
                protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                public System.Data.SQLite.SQLiteParameter CreateParameter() => throw null;
                public SQLiteCommand() => throw null;
                public SQLiteCommand(string commandText) => throw null;
                public SQLiteCommand(string commandText, System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteCommand(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteCommand(string commandText, System.Data.SQLite.SQLiteConnection connection, System.Data.SQLite.SQLiteTransaction transaction) => throw null;
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set { } }
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set { } }
                public override bool DesignTimeVisible { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, string connectionString, params object[] args) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, System.Data.CommandBehavior commandBehavior, string connectionString, params object[] args) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, System.Data.CommandBehavior commandBehavior, System.Data.SQLite.SQLiteConnection connection, params object[] args) => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public int ExecuteNonQuery(System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SQLite.SQLiteDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SQLite.SQLiteDataReader ExecuteReader() => throw null;
                public override object ExecuteScalar() => throw null;
                public object ExecuteScalar(System.Data.CommandBehavior behavior) => throw null;
                public const System.Data.CommandBehavior ForceExtraReads = default;
                public string GetDiagnostics() => throw null;
                public static System.Data.CommandBehavior? GlobalCommandBehaviors;
                public int MaximumSleepTime { get => throw null; set { } }
                public int MaybeReadRemaining(System.Data.SQLite.SQLiteDataReader reader, System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SQLite.SQLiteParameterCollection Parameters { get => throw null; }
                public override void Prepare() => throw null;
                public void Reset() => throw null;
                public void Reset(bool clearBindings, bool ignoreErrors) => throw null;
                public const System.Data.CommandBehavior SkipExtraReads = default;
                public System.Data.SQLite.SQLiteTransaction Transaction { get => throw null; set { } }
                public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set { } }
                public void VerifyOnly() => throw null;
            }
            public sealed class SQLiteCommandBuilder : System.Data.Common.DbCommandBuilder
            {
                protected override void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow row, System.Data.StatementType statementType, bool whereClause) => throw null;
                public override System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set { } }
                public override string CatalogSeparator { get => throw null; set { } }
                public SQLiteCommandBuilder() => throw null;
                public SQLiteCommandBuilder(System.Data.SQLite.SQLiteDataAdapter adp) => throw null;
                public System.Data.SQLite.SQLiteDataAdapter DataAdapter { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.SQLite.SQLiteCommand GetDeleteCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetDeleteCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.SQLite.SQLiteCommand GetInsertCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetInsertCommand(bool useColumnsForParameterNames) => throw null;
                protected override string GetParameterName(string parameterName) => throw null;
                protected override string GetParameterName(int parameterOrdinal) => throw null;
                protected override string GetParameterPlaceholder(int parameterOrdinal) => throw null;
                protected override System.Data.DataTable GetSchemaTable(System.Data.Common.DbCommand sourceCommand) => throw null;
                public System.Data.SQLite.SQLiteCommand GetUpdateCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetUpdateCommand(bool useColumnsForParameterNames) => throw null;
                public override string QuoteIdentifier(string unquotedIdentifier) => throw null;
                public override string QuotePrefix { get => throw null; set { } }
                public override string QuoteSuffix { get => throw null; set { } }
                public override string SchemaSeparator { get => throw null; set { } }
                protected override void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter) => throw null;
                public override string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }
            public delegate void SQLiteCommitHandler(object sender, System.Data.SQLite.CommitEventArgs e);
            public delegate int SQLiteCompareDelegate(string param0, string param1, string param2);
            public enum SQLiteConfigDbOpsEnum
            {
                SQLITE_DBCONFIG_NONE = 0,
                SQLITE_DBCONFIG_MAINDBNAME = 1000,
                SQLITE_DBCONFIG_LOOKASIDE = 1001,
                SQLITE_DBCONFIG_ENABLE_FKEY = 1002,
                SQLITE_DBCONFIG_ENABLE_TRIGGER = 1003,
                SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER = 1004,
                SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION = 1005,
                SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE = 1006,
                SQLITE_DBCONFIG_ENABLE_QPSG = 1007,
                SQLITE_DBCONFIG_TRIGGER_EQP = 1008,
                SQLITE_DBCONFIG_RESET_DATABASE = 1009,
                SQLITE_DBCONFIG_DEFENSIVE = 1010,
                SQLITE_DBCONFIG_WRITABLE_SCHEMA = 1011,
                SQLITE_DBCONFIG_LEGACY_ALTER_TABLE = 1012,
                SQLITE_DBCONFIG_DQS_DML = 1013,
                SQLITE_DBCONFIG_DQS_DDL = 1014,
                SQLITE_DBCONFIG_ENABLE_VIEW = 1015,
                SQLITE_DBCONFIG_LEGACY_FILE_FORMAT = 1016,
                SQLITE_DBCONFIG_TRUSTED_SCHEMA = 1017,
                SQLITE_DBCONFIG_STMT_SCANSTATUS = 1018,
                SQLITE_DBCONFIG_REVERSE_SCANORDER = 1019,
            }
            public sealed class SQLiteConnection : System.Data.Common.DbConnection, System.ICloneable, System.IDisposable
            {
                public int AddTypeMapping(string typeName, System.Data.DbType dataType, bool primary) => throw null;
                public event System.Data.SQLite.SQLiteAuthorizerEventHandler Authorize;
                public bool AutoCommit { get => throw null; }
                public void BackupDatabase(System.Data.SQLite.SQLiteConnection destination, string destinationName, string sourceName, int pages, System.Data.SQLite.SQLiteBackupCallback callback, int retryMilliseconds) => throw null;
                protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel, bool deferredLock) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(bool deferredLock) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction() => throw null;
                public void BindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute, System.Data.SQLite.SQLiteFunction function) => throw null;
                public void BindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute, System.Delegate callback1, System.Delegate callback2) => throw null;
                public event System.Data.SQLite.SQLiteBusyEventHandler Busy;
                public int BusyTimeout { get => throw null; set { } }
                public void Cancel() => throw null;
                public static event System.Data.SQLite.SQLiteConnectionEventHandler Changed;
                public override void ChangeDatabase(string databaseName) => throw null;
                public void ChangePassword(string newPassword) => throw null;
                public void ChangePassword(byte[] newPassword) => throw null;
                public int Changes { get => throw null; }
                public static void ClearAllPools() => throw null;
                public int ClearCachedSettings() => throw null;
                public static void ClearPool(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public int ClearTypeCallbacks() => throw null;
                public int ClearTypeMappings() => throw null;
                public object Clone() => throw null;
                public override void Close() => throw null;
                public static long CloseCount { get => throw null; }
                public event System.Data.SQLite.SQLiteCommitHandler Commit;
                public static System.Data.SQLite.ISQLiteConnectionPool ConnectionPool { get => throw null; set { } }
                public override string ConnectionString { get => throw null; set { } }
                public System.Data.SQLite.ISQLiteChangeGroup CreateChangeGroup() => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(byte[] rawData) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(byte[] rawData, System.Data.SQLite.SQLiteChangeSetStartFlags flags) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.IO.Stream inputStream, System.IO.Stream outputStream) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.IO.Stream inputStream, System.IO.Stream outputStream, System.Data.SQLite.SQLiteChangeSetStartFlags flags) => throw null;
                public System.Data.SQLite.SQLiteCommand CreateCommand() => throw null;
                public static long CreateCount { get => throw null; }
                protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                public static void CreateFile(string databaseFileName) => throw null;
                public static object CreateHandle(nint nativeHandle) => throw null;
                public void CreateModule(System.Data.SQLite.SQLiteModule module) => throw null;
                public static System.Data.SQLite.ISQLiteConnectionPool CreatePool(string typeName, object argument) => throw null;
                public System.Data.SQLite.ISQLiteSession CreateSession(string databaseName) => throw null;
                public SQLiteConnection() => throw null;
                public SQLiteConnection(string connectionString) => throw null;
                public SQLiteConnection(string connectionString, bool parseViaFramework) => throw null;
                public SQLiteConnection(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public override string Database { get => throw null; }
                public override string DataSource { get => throw null; }
                protected override System.Data.Common.DbProviderFactory DbProviderFactory { get => throw null; }
                public static string DecryptLegacyDatabase(string fileName, byte[] passwordBytes, int? pageSize, System.Data.SQLite.SQLiteProgressEventHandler progress) => throw null;
                public System.Data.DbType? DefaultDbType { get => throw null; set { } }
                public static System.Data.SQLite.SQLiteConnectionFlags DefaultFlags { get => throw null; }
                public int DefaultMaximumSleepTime { get => throw null; set { } }
                public int DefaultTimeout { get => throw null; set { } }
                public string DefaultTypeName { get => throw null; set { } }
                public static string DefineConstants { get => throw null; }
                public void Dispose() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public static long DisposeCount { get => throw null; }
                public void EnableExtensions(bool enable) => throw null;
                public override void EnlistTransaction(System.Transactions.Transaction transaction) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ExtendedResultCode() => throw null;
                public string FileName { get => throw null; }
                public System.Data.SQLite.SQLiteConnectionFlags Flags { get => throw null; set { } }
                public object GetCriticalHandle() => throw null;
                public static void GetMemoryStatistics(ref System.Collections.Generic.IDictionary<string, long> statistics) => throw null;
                public override System.Data.DataTable GetSchema() => throw null;
                public override System.Data.DataTable GetSchema(string collectionName) => throw null;
                public override System.Data.DataTable GetSchema(string collectionName, string[] restrictionValues) => throw null;
                public System.Collections.Generic.Dictionary<string, object> GetTypeMappings() => throw null;
                public static string InteropCompileOptions { get => throw null; }
                public static string InteropSourceId { get => throw null; }
                public static string InteropVersion { get => throw null; }
                public bool IsCanceled() => throw null;
                public bool IsReadOnly(string name) => throw null;
                public long LastInsertRowId { get => throw null; }
                public void LoadExtension(string fileName) => throw null;
                public void LoadExtension(string fileName, string procName) => throw null;
                public void LogMessage(System.Data.SQLite.SQLiteErrorCode iErrCode, string zMessage) => throw null;
                public void LogMessage(int iErrCode, string zMessage) => throw null;
                public long MemoryHighwater { get => throw null; }
                public long MemoryUsed { get => throw null; }
                public override void Open() => throw null;
                public System.Data.SQLite.SQLiteConnection OpenAndReturn() => throw null;
                public static long OpenCount { get => throw null; }
                public bool OwnHandle { get => throw null; }
                public static System.Collections.Generic.SortedList<string, string> ParseConnectionString(System.Data.SQLite.SQLiteConnection connection, string connectionString, bool parseViaFramework, bool allowNameOnly, bool strict) => throw null;
                public bool ParseViaFramework { get => throw null; set { } }
                public int PoolCount { get => throw null; }
                public int PrepareRetries { get => throw null; set { } }
                public event System.Data.SQLite.SQLiteProgressEventHandler Progress;
                public int ProgressOps { get => throw null; set { } }
                public static string ProviderSourceId { get => throw null; }
                public static string ProviderVersion { get => throw null; }
                public void ReleaseMemory() => throw null;
                public static System.Data.SQLite.SQLiteErrorCode ReleaseMemory(int nBytes, bool reset, bool compact, ref int nFree, ref bool resetOk, ref uint nLargest) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ResultCode() => throw null;
                public event System.EventHandler RollBack;
                public override string ServerVersion { get => throw null; }
                public System.Data.SQLite.SQLiteErrorCode SetAvRetry(ref int count, ref int interval) => throw null;
                public System.Data.SQLite.SQLiteErrorCode SetChunkSize(int size) => throw null;
                public void SetConfigurationOption(System.Data.SQLite.SQLiteConfigDbOpsEnum option, object value) => throw null;
                public void SetExtendedResultCodes(bool bOnOff) => throw null;
                public int SetLimitOption(System.Data.SQLite.SQLiteLimitOpsEnum option, int value) => throw null;
                public static System.Data.SQLite.SQLiteErrorCode SetMemoryStatus(bool value) => throw null;
                public void SetPassword(string databasePassword) => throw null;
                public void SetPassword(byte[] databasePassword) => throw null;
                public bool SetTypeCallbacks(string typeName, System.Data.SQLite.SQLiteTypeCallbacks callbacks) => throw null;
                public static System.Data.SQLite.SQLiteConnectionFlags SharedFlags { get => throw null; set { } }
                public System.Data.SQLite.SQLiteErrorCode Shutdown() => throw null;
                public static void Shutdown(bool directories, bool noThrow) => throw null;
                public static string SQLiteCompileOptions { get => throw null; }
                public static string SQLiteSourceId { get => throw null; }
                public static string SQLiteVersion { get => throw null; }
                public override System.Data.ConnectionState State { get => throw null; }
                public override event System.Data.StateChangeEventHandler StateChange;
                public int StepRetries { get => throw null; set { } }
                public event System.Data.SQLite.SQLiteTraceEventHandler Trace;
                public event System.Data.SQLite.SQLiteTraceEventHandler Trace2;
                public System.Data.SQLite.SQLiteTraceFlags TraceFlags { get => throw null; set { } }
                public bool TryGetTypeCallbacks(string typeName, out System.Data.SQLite.SQLiteTypeCallbacks callbacks) => throw null;
                public bool UnbindAllFunctions(bool registered) => throw null;
                public bool UnbindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute) => throw null;
                public event System.Data.SQLite.SQLiteUpdateEventHandler Update;
                public string VfsName { get => throw null; set { } }
                public bool WaitForEnlistmentReset(int timeoutMilliseconds, bool? returnOnDisposed) => throw null;
                public int WaitTimeout { get => throw null; set { } }
            }
            public delegate void SQLiteConnectionEventHandler(object sender, System.Data.SQLite.ConnectionEventArgs e);
            public enum SQLiteConnectionEventType
            {
                Invalid = -1,
                Unknown = 0,
                Opening = 1,
                ConnectionString = 2,
                Opened = 3,
                ChangeDatabase = 4,
                NewTransaction = 5,
                EnlistTransaction = 6,
                NewCommand = 7,
                NewDataReader = 8,
                NewCriticalHandle = 9,
                Closing = 10,
                Closed = 11,
                DisposingCommand = 12,
                DisposingDataReader = 13,
                ClosingDataReader = 14,
                OpenedFromPool = 15,
                ClosedToPool = 16,
                DisposingConnection = 17,
                DisposedConnection = 18,
                FinalizingConnection = 19,
                FinalizedConnection = 20,
                NothingToDo = 21,
                ConnectionStringPreview = 22,
                SqlStringPreview = 23,
                Canceled = 24,
            }
            [System.Flags]
            public enum SQLiteConnectionFlags : long
            {
                None = 0,
                LogPrepare = 1,
                LogPreBind = 2,
                LogBind = 4,
                LogCallbackException = 8,
                LogBackup = 16,
                NoExtensionFunctions = 32,
                BindUInt32AsInt64 = 64,
                BindAllAsText = 128,
                GetAllAsText = 256,
                NoLoadExtension = 512,
                NoCreateModule = 1024,
                NoBindFunctions = 2048,
                NoLogModule = 4096,
                LogModuleError = 8192,
                LogModuleException = 16384,
                TraceWarning = 32768,
                ConvertInvariantText = 65536,
                BindInvariantText = 131072,
                NoConnectionPool = 262144,
                UseConnectionPool = 524288,
                UseConnectionTypes = 1048576,
                NoGlobalTypes = 2097152,
                StickyHasRows = 4194304,
                StrictEnlistment = 8388608,
                MapIsolationLevels = 16777216,
                DetectTextAffinity = 33554432,
                DetectStringType = 67108864,
                NoConvertSettings = 134217728,
                BindDateTimeWithKind = 268435456,
                RollbackOnException = 536870912,
                DenyOnException = 1073741824,
                InterruptOnException = 2147483648,
                UnbindFunctionsOnClose = 4294967296,
                NoVerifyTextAffinity = 8589934592,
                UseConnectionBindValueCallbacks = 17179869184,
                UseConnectionReadValueCallbacks = 34359738368,
                UseParameterNameForTypeName = 68719476736,
                UseParameterDbTypeForTypeName = 137438953472,
                NoVerifyTypeAffinity = 274877906944,
                AllowNestedTransactions = 549755813888,
                BindDecimalAsText = 1099511627776,
                GetDecimalAsText = 2199023255552,
                BindInvariantDecimal = 4398046511104,
                GetInvariantDecimal = 8796093022208,
                WaitForEnlistmentReset = 17592186044416,
                GetInvariantInt64 = 35184372088832,
                GetInvariantDouble = 70368744177664,
                StrictConformance = 140737488355328,
                HidePassword = 281474976710656,
                NoCoreFunctions = 562949953421312,
                StopOnException = 1125899906842624,
                LogRetry = 2251799813685248,
                BindAndGetAllAsText = 384,
                ConvertAndBindInvariantText = 196608,
                BindAndGetAllAsInvariantText = 131456,
                ConvertAndBindAndGetAllAsInvariantText = 196992,
                UseConnectionAllValueCallbacks = 51539607552,
                UseParameterAnythingForTypeName = 206158430208,
                LogAll = 2251799813709855,
                LogDefault = 16392,
                Default = 13194139549704,
                DefaultAndLogAll = 2264993953243167,
            }
            public sealed class SQLiteConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
            {
                public string BaseSchemaName { get => throw null; set { } }
                public bool BinaryGUID { get => throw null; set { } }
                public int BusyTimeout { get => throw null; set { } }
                public int CacheSize { get => throw null; set { } }
                public SQLiteConnectionStringBuilder() => throw null;
                public SQLiteConnectionStringBuilder(string connectionString) => throw null;
                public string DataSource { get => throw null; set { } }
                public System.Data.SQLite.SQLiteDateFormats DateTimeFormat { get => throw null; set { } }
                public string DateTimeFormatString { get => throw null; set { } }
                public System.DateTimeKind DateTimeKind { get => throw null; set { } }
                public System.Data.DbType DefaultDbType { get => throw null; set { } }
                public System.Data.IsolationLevel DefaultIsolationLevel { get => throw null; set { } }
                public int DefaultMaximumSleepTime { get => throw null; set { } }
                public int DefaultTimeout { get => throw null; set { } }
                public string DefaultTypeName { get => throw null; set { } }
                public bool Enlist { get => throw null; set { } }
                public bool FailIfMissing { get => throw null; set { } }
                public System.Data.SQLite.SQLiteConnectionFlags Flags { get => throw null; set { } }
                public bool ForeignKeys { get => throw null; set { } }
                public string FullUri { get => throw null; set { } }
                public byte[] HexPassword { get => throw null; set { } }
                public System.Data.SQLite.SQLiteJournalModeEnum JournalMode { get => throw null; set { } }
                public bool LegacyFormat { get => throw null; set { } }
                public int MaxPageCount { get => throw null; set { } }
                public bool NoDefaultFlags { get => throw null; set { } }
                public bool NoSharedFlags { get => throw null; set { } }
                public int PageSize { get => throw null; set { } }
                public string Password { get => throw null; set { } }
                public bool Pooling { get => throw null; set { } }
                public int PrepareRetries { get => throw null; set { } }
                public int ProgressOps { get => throw null; set { } }
                public bool ReadOnly { get => throw null; set { } }
                public bool RecursiveTriggers { get => throw null; set { } }
                public bool SetDefaults { get => throw null; set { } }
                public int StepRetries { get => throw null; set { } }
                public System.Data.SQLite.SynchronizationModes SyncMode { get => throw null; set { } }
                public byte[] TextHexPassword { get => throw null; set { } }
                public string TextPassword { get => throw null; set { } }
                public bool ToFullPath { get => throw null; set { } }
                public override bool TryGetValue(string keyword, out object value) => throw null;
                public string Uri { get => throw null; set { } }
                public bool UseUTF16Encoding { get => throw null; set { } }
                public int Version { get => throw null; set { } }
                public string VfsName { get => throw null; set { } }
                public int WaitTimeout { get => throw null; set { } }
                public string ZipVfsVersion { get => throw null; set { } }
            }
            public sealed class SQLiteContext : System.Data.SQLite.ISQLiteNativeHandle
            {
                public nint NativeHandle { get => throw null; }
                public int NoChange() => throw null;
                public void SetBlob(byte[] value) => throw null;
                public void SetDouble(double value) => throw null;
                public void SetError(string value) => throw null;
                public void SetErrorCode(System.Data.SQLite.SQLiteErrorCode value) => throw null;
                public void SetErrorNoMemory() => throw null;
                public void SetErrorTooBig() => throw null;
                public void SetInt(int value) => throw null;
                public void SetInt64(long value) => throw null;
                public void SetNull() => throw null;
                public void SetString(string value) => throw null;
                public void SetSubType(uint value) => throw null;
                public void SetValue(System.Data.SQLite.SQLiteValue value) => throw null;
                public void SetZeroBlob(int value) => throw null;
            }
            public abstract class SQLiteConvert
            {
                public static string GetStringOrNull(object value) => throw null;
                public static string[] Split(string source, char separator) => throw null;
                public static bool ToBoolean(object source) => throw null;
                public static bool ToBoolean(string source) => throw null;
                public System.DateTime ToDateTime(string dateText) => throw null;
                public static System.DateTime ToDateTime(string dateText, System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString) => throw null;
                public System.DateTime ToDateTime(double julianDay) => throw null;
                public static System.DateTime ToDateTime(double julianDay, System.DateTimeKind kind) => throw null;
                public static double ToJulianDay(System.DateTime? value) => throw null;
                public virtual string ToString(nint nativestring, int nativestringlen) => throw null;
                public string ToString(System.DateTime dateValue) => throw null;
                public static string ToString(System.DateTime dateValue, System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString) => throw null;
                public static string ToStringWithProvider(object obj, System.IFormatProvider provider) => throw null;
                public static long ToUnixEpoch(System.DateTime value) => throw null;
                public static byte[] ToUTF8(string sourceText) => throw null;
                public byte[] ToUTF8(System.DateTime dateTimeValue) => throw null;
                protected static readonly System.DateTime UnixEpoch;
                public static string UTF8ToString(nint nativestring, int nativestringlen) => throw null;
            }
            public sealed class SQLiteDataAdapter : System.Data.Common.DbDataAdapter
            {
                public SQLiteDataAdapter() => throw null;
                public SQLiteDataAdapter(System.Data.SQLite.SQLiteCommand cmd) => throw null;
                public SQLiteDataAdapter(string commandText, System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteDataAdapter(string commandText, string connectionString) => throw null;
                public SQLiteDataAdapter(string commandText, string connectionString, bool parseViaFramework) => throw null;
                public System.Data.SQLite.SQLiteCommand DeleteCommand { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.SQLite.SQLiteCommand InsertCommand { get => throw null; set { } }
                protected override void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected override void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public event System.EventHandler<System.Data.Common.RowUpdatedEventArgs> RowUpdated;
                public event System.EventHandler<System.Data.Common.RowUpdatingEventArgs> RowUpdating;
                public System.Data.SQLite.SQLiteCommand SelectCommand { get => throw null; set { } }
                public System.Data.SQLite.SQLiteCommand UpdateCommand { get => throw null; set { } }
            }
            public sealed class SQLiteDataReader : System.Data.Common.DbDataReader
            {
                public override void Close() => throw null;
                public override int Depth { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override int FieldCount { get => throw null; }
                public System.Data.SQLite.SQLiteBlob GetBlob(int i, bool readOnly) => throw null;
                public override bool GetBoolean(int i) => throw null;
                public override byte GetByte(int i) => throw null;
                public override long GetBytes(int i, long fieldOffset, byte[] buffer, int bufferoffset, int length) => throw null;
                public override char GetChar(int i) => throw null;
                public override long GetChars(int i, long fieldoffset, char[] buffer, int bufferoffset, int length) => throw null;
                public string GetDatabaseName(int i) => throw null;
                public override string GetDataTypeName(int i) => throw null;
                public override System.DateTime GetDateTime(int i) => throw null;
                public override decimal GetDecimal(int i) => throw null;
                public override double GetDouble(int i) => throw null;
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                public System.Data.SQLite.TypeAffinity GetFieldAffinity(int i) => throw null;
                public override System.Type GetFieldType(int i) => throw null;
                public override float GetFloat(int i) => throw null;
                public override System.Guid GetGuid(int i) => throw null;
                public override short GetInt16(int i) => throw null;
                public override int GetInt32(int i) => throw null;
                public override long GetInt64(int i) => throw null;
                public override string GetName(int i) => throw null;
                public override int GetOrdinal(string name) => throw null;
                public string GetOriginalName(int i) => throw null;
                public override System.Data.DataTable GetSchemaTable() => throw null;
                public override string GetString(int i) => throw null;
                public string GetTableName(int i) => throw null;
                public override object GetValue(int i) => throw null;
                public override int GetValues(object[] values) => throw null;
                public System.Collections.Specialized.NameValueCollection GetValues() => throw null;
                public override bool HasRows { get => throw null; }
                public override bool IsClosed { get => throw null; }
                public override bool IsDBNull(int i) => throw null;
                public override bool NextResult() => throw null;
                public override bool Read() => throw null;
                public override int RecordsAffected { get => throw null; }
                public void RefreshFlags() => throw null;
                public int StepCount { get => throw null; }
                public override object this[string name] { get => throw null; }
                public override object this[int i] { get => throw null; }
                public override int VisibleFieldCount { get => throw null; }
            }
            public sealed class SQLiteDataReaderValue
            {
                public System.Data.SQLite.SQLiteBlob BlobValue;
                public bool? BooleanValue;
                public byte[] BytesValue;
                public byte? ByteValue;
                public char[] CharsValue;
                public char? CharValue;
                public SQLiteDataReaderValue() => throw null;
                public System.DateTime? DateTimeValue;
                public decimal? DecimalValue;
                public double? DoubleValue;
                public float? FloatValue;
                public System.Guid? GuidValue;
                public short? Int16Value;
                public int? Int32Value;
                public long? Int64Value;
                public string StringValue;
                public object Value;
            }
            public enum SQLiteDateFormats
            {
                Ticks = 0,
                ISO8601 = 1,
                JulianDay = 2,
                UnixEpoch = 3,
                InvariantCulture = 4,
                CurrentCulture = 5,
                Default = 1,
            }
            public class SQLiteDelegateFunction : System.Data.SQLite.SQLiteFunction
            {
                public virtual System.Delegate Callback1 { get => throw null; set { } }
                public virtual System.Delegate Callback2 { get => throw null; set { } }
                public virtual System.Delegate Callback3 { get => throw null; set { } }
                public virtual System.Delegate Callback4 { get => throw null; set { } }
                public override int Compare(string param1, string param2) => throw null;
                public SQLiteDelegateFunction() => throw null;
                public SQLiteDelegateFunction(System.Delegate callback1, System.Delegate callback2) => throw null;
                public SQLiteDelegateFunction(System.Delegate callback1, System.Delegate callback2, System.Delegate callback3, System.Delegate callback4) => throw null;
                public override object Final(object contextData) => throw null;
                protected virtual object[] GetCompareArgs(string param1, string param2, bool earlyBound) => throw null;
                protected virtual object[] GetFinalArgs(object contextData, bool earlyBound) => throw null;
                protected virtual object[] GetInverseArgs(object[] args, int stepNumber, object contextData, bool earlyBound) => throw null;
                protected virtual object[] GetInvokeArgs(object[] args, bool earlyBound) => throw null;
                protected virtual object[] GetStepArgs(object[] args, int stepNumber, object contextData, bool earlyBound) => throw null;
                protected virtual object[] GetValueArgs(object contextData, bool earlyBound) => throw null;
                public override void Inverse(object[] args, int stepNumber, ref object contextData) => throw null;
                public override object Invoke(object[] args) => throw null;
                public override void Step(object[] args, int stepNumber, ref object contextData) => throw null;
                protected virtual void UpdateInverseArgs(object[] args, ref object contextData, bool earlyBound) => throw null;
                protected virtual void UpdateStepArgs(object[] args, ref object contextData, bool earlyBound) => throw null;
                public override object Value(object contextData) => throw null;
            }
            public enum SQLiteErrorCode
            {
                Unknown = -1,
                Ok = 0,
                Error = 1,
                Internal = 2,
                Perm = 3,
                Abort = 4,
                Busy = 5,
                Locked = 6,
                NoMem = 7,
                ReadOnly = 8,
                Interrupt = 9,
                IoErr = 10,
                Corrupt = 11,
                NotFound = 12,
                Full = 13,
                CantOpen = 14,
                Protocol = 15,
                Empty = 16,
                Schema = 17,
                TooBig = 18,
                Constraint = 19,
                Mismatch = 20,
                Misuse = 21,
                NoLfs = 22,
                Auth = 23,
                Format = 24,
                Range = 25,
                NotADb = 26,
                Notice = 27,
                Warning = 28,
                Row = 100,
                Done = 101,
                NonExtendedMask = 255,
                Error_Missing_CollSeq = 257,
                Error_Retry = 513,
                Error_Snapshot = 769,
                IoErr_Read = 266,
                IoErr_Short_Read = 522,
                IoErr_Write = 778,
                IoErr_Fsync = 1034,
                IoErr_Dir_Fsync = 1290,
                IoErr_Truncate = 1546,
                IoErr_Fstat = 1802,
                IoErr_Unlock = 2058,
                IoErr_RdLock = 2314,
                IoErr_Delete = 2570,
                IoErr_Blocked = 2826,
                IoErr_NoMem = 3082,
                IoErr_Access = 3338,
                IoErr_CheckReservedLock = 3594,
                IoErr_Lock = 3850,
                IoErr_Close = 4106,
                IoErr_Dir_Close = 4362,
                IoErr_ShmOpen = 4618,
                IoErr_ShmSize = 4874,
                IoErr_ShmLock = 5130,
                IoErr_ShmMap = 5386,
                IoErr_Seek = 5642,
                IoErr_Delete_NoEnt = 5898,
                IoErr_Mmap = 6154,
                IoErr_GetTempPath = 6410,
                IoErr_ConvPath = 6666,
                IoErr_VNode = 6922,
                IoErr_Auth = 7178,
                IoErr_Begin_Atomic = 7434,
                IoErr_Commit_Atomic = 7690,
                IoErr_Rollback_Atomic = 7946,
                IoErr_Data = 8202,
                IoErr_CorruptFs = 8458,
                Locked_SharedCache = 262,
                Locked_Vtab = 518,
                Busy_Recovery = 261,
                Busy_Snapshot = 517,
                Busy_Timeout = 773,
                CantOpen_NoTempDir = 270,
                CantOpen_IsDir = 526,
                CantOpen_FullPath = 782,
                CantOpen_ConvPath = 1038,
                CantOpen_DirtyWal = 1294,
                CantOpen_SymLink = 1550,
                Corrupt_Vtab = 267,
                Corrupt_Sequence = 523,
                Corrupt_Index = 779,
                ReadOnly_Recovery = 264,
                ReadOnly_CantLock = 520,
                ReadOnly_Rollback = 776,
                ReadOnly_DbMoved = 1032,
                ReadOnly_CantInit = 1288,
                ReadOnly_Directory = 1544,
                Abort_Rollback = 516,
                Constraint_Check = 275,
                Constraint_CommitHook = 531,
                Constraint_ForeignKey = 787,
                Constraint_Function = 1043,
                Constraint_NotNull = 1299,
                Constraint_PrimaryKey = 1555,
                Constraint_Trigger = 1811,
                Constraint_Unique = 2067,
                Constraint_Vtab = 2323,
                Constraint_RowId = 2579,
                Constraint_Pinned = 2835,
                Constraint_DataType = 3091,
                Misuse_No_License = 277,
                Notice_Recover_Wal = 283,
                Notice_Recover_Rollback = 539,
                Notice_Rbu = 795,
                Warning_AutoIndex = 284,
                Auth_User = 279,
                Ok_Load_Permanently = 256,
                Ok_SymLink = 512,
            }
            public sealed class SQLiteException : System.Data.Common.DbException, System.Runtime.Serialization.ISerializable
            {
                public SQLiteException(System.Data.SQLite.SQLiteErrorCode errorCode, string message) => throw null;
                public SQLiteException(string message) => throw null;
                public SQLiteException() => throw null;
                public SQLiteException(string message, System.Exception innerException) => throw null;
                public override int ErrorCode { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ResultCode { get => throw null; }
                public override string ToString() => throw null;
            }
            public enum SQLiteExecuteType
            {
                None = 0,
                NonQuery = 1,
                Scalar = 2,
                Reader = 3,
                Default = 1,
            }
            public static class SQLiteExtra
            {
                public static int Cleanup() => throw null;
                public static int Configure(string argument) => throw null;
                public static int Verify(string argument) => throw null;
            }
            public sealed class SQLiteFactory : System.Data.Common.DbProviderFactory, System.IDisposable, System.IServiceProvider
            {
                public override System.Data.Common.DbCommand CreateCommand() => throw null;
                public override System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public override System.Data.Common.DbConnection CreateConnection() => throw null;
                public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public override System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public override System.Data.Common.DbParameter CreateParameter() => throw null;
                public SQLiteFactory() => throw null;
                public void Dispose() => throw null;
                object System.IServiceProvider.GetService(System.Type serviceType) => throw null;
                public static readonly System.Data.SQLite.SQLiteFactory Instance;
                public event System.Data.SQLite.SQLiteLogEventHandler Log;
            }
            public delegate object SQLiteFinalDelegate(string param0, object contextData);
            public abstract class SQLiteFunction : System.IDisposable
            {
                public virtual int Compare(string param1, string param2) => throw null;
                protected SQLiteFunction() => throw null;
                protected SQLiteFunction(System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString, bool utf16) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual object Final(object contextData) => throw null;
                public int GetParameterFromBind(int index) => throw null;
                public int GetParameterNoChange(int index) => throw null;
                public System.Data.SQLite.TypeAffinity GetParameterNumericType(int index) => throw null;
                public uint GetParameterSubType(int index) => throw null;
                public virtual void Inverse(object[] args, int stepNumber, ref object contextData) => throw null;
                public virtual object Invoke(object[] args) => throw null;
                public static void RegisterFunction(System.Type typ) => throw null;
                public static void RegisterFunction(string name, int argumentCount, System.Data.SQLite.FunctionType functionType, System.Type instanceType, System.Delegate callback1, System.Delegate callback2) => throw null;
                public static void RegisterFunction(string name, int argumentCount, System.Data.SQLite.FunctionType functionType, System.Data.SQLite.SQLiteFunctionFlags functionFlags, System.Type instanceType, System.Delegate callback1, System.Delegate callback2, System.Delegate callback3, System.Delegate callback4) => throw null;
                public void SetReturnSubType(uint value) => throw null;
                public System.Data.SQLite.SQLiteConvert SQLiteConvert { get => throw null; }
                public virtual void Step(object[] args, int stepNumber, ref object contextData) => throw null;
                public virtual object Value(object contextData) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, Inherited = false, AllowMultiple = true)]
            public sealed class SQLiteFunctionAttribute : System.Attribute
            {
                public int Arguments { get => throw null; set { } }
                public SQLiteFunctionAttribute() => throw null;
                public SQLiteFunctionAttribute(string name, int argumentCount, System.Data.SQLite.FunctionType functionType) => throw null;
                public SQLiteFunctionAttribute(string name, int argumentCount, System.Data.SQLite.FunctionType functionType, System.Data.SQLite.SQLiteFunctionFlags functionFlags) => throw null;
                public System.Data.SQLite.SQLiteFunctionFlags FuncFlags { get => throw null; set { } }
                public System.Data.SQLite.FunctionType FuncType { get => throw null; set { } }
                public string Name { get => throw null; set { } }
            }
            public class SQLiteFunctionEx : System.Data.SQLite.SQLiteFunction
            {
                public SQLiteFunctionEx() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected System.Data.SQLite.CollationSequence GetCollationSequence() => throw null;
            }
            [System.Flags]
            public enum SQLiteFunctionFlags
            {
                NONE = 0,
                SQLITE_UTF8 = 1,
                SQLITE_UTF16LE = 2,
                SQLITE_UTF16BE = 3,
                SQLITE_UTF16 = 4,
                SQLITE_ANY = 5,
                SQLITE_UTF16_ALIGNED = 8,
                ENCODING_MASK = 15,
                SQLITE_DETERMINISTIC = 2048,
                SQLITE_DIRECTONLY = 524288,
                SQLITE_SUBTYPE = 1048576,
                SQLITE_INNOCUOUS = 2097152,
            }
            public sealed class SQLiteIndex
            {
                public System.Data.SQLite.SQLiteIndexInputs Inputs { get => throw null; }
                public System.Data.SQLite.SQLiteIndexOutputs Outputs { get => throw null; }
            }
            public sealed class SQLiteIndexConstraint
            {
                public int iColumn;
                public int iTermOffset;
                public System.Data.SQLite.SQLiteIndexConstraintOp op;
                public byte usable;
            }
            public enum SQLiteIndexConstraintOp : byte
            {
                EqualTo = 2,
                GreaterThan = 4,
                LessThanOrEqualTo = 8,
                LessThan = 16,
                GreaterThanOrEqualTo = 32,
                Match = 64,
                Like = 65,
                Glob = 66,
                Regexp = 67,
                NotEqualTo = 68,
                IsNot = 69,
                IsNotNull = 70,
                IsNull = 71,
                Is = 72,
            }
            public sealed class SQLiteIndexConstraintUsage
            {
                public int argvIndex;
                public byte omit;
            }
            [System.Flags]
            public enum SQLiteIndexFlags
            {
                None = 0,
                ScanUnique = 1,
            }
            public sealed class SQLiteIndexInputs
            {
                public System.Data.SQLite.SQLiteIndexConstraint[] Constraints { get => throw null; }
                public System.Data.SQLite.SQLiteIndexOrderBy[] OrderBys { get => throw null; }
            }
            public sealed class SQLiteIndexOrderBy
            {
                public byte desc;
                public int iColumn;
            }
            public sealed class SQLiteIndexOutputs
            {
                public bool CanUseColumnsUsed() => throw null;
                public bool CanUseEstimatedRows() => throw null;
                public bool CanUseIndexFlags() => throw null;
                public long? ColumnsUsed { get => throw null; set { } }
                public System.Data.SQLite.SQLiteIndexConstraintUsage[] ConstraintUsages { get => throw null; }
                public double? EstimatedCost { get => throw null; set { } }
                public long? EstimatedRows { get => throw null; set { } }
                public System.Data.SQLite.SQLiteIndexFlags? IndexFlags { get => throw null; set { } }
                public int IndexNumber { get => throw null; set { } }
                public string IndexString { get => throw null; set { } }
                public int NeedToFreeIndexString { get => throw null; set { } }
                public int OrderByConsumed { get => throw null; set { } }
            }
            public delegate object SQLiteInvokeDelegate(string param0, object[] args);
            public enum SQLiteJournalModeEnum
            {
                Default = -1,
                Delete = 0,
                Persist = 1,
                Off = 2,
                Truncate = 3,
                Memory = 4,
                Wal = 5,
            }
            public enum SQLiteLimitOpsEnum
            {
                SQLITE_LIMIT_NONE = -1,
                SQLITE_LIMIT_LENGTH = 0,
                SQLITE_LIMIT_SQL_LENGTH = 1,
                SQLITE_LIMIT_COLUMN = 2,
                SQLITE_LIMIT_EXPR_DEPTH = 3,
                SQLITE_LIMIT_COMPOUND_SELECT = 4,
                SQLITE_LIMIT_VDBE_OP = 5,
                SQLITE_LIMIT_FUNCTION_ARG = 6,
                SQLITE_LIMIT_ATTACHED = 7,
                SQLITE_LIMIT_LIKE_PATTERN_LENGTH = 8,
                SQLITE_LIMIT_VARIABLE_NUMBER = 9,
                SQLITE_LIMIT_TRIGGER_DEPTH = 10,
                SQLITE_LIMIT_WORKER_THREADS = 11,
            }
            public static class SQLiteLog
            {
                public static void AddDefaultHandler() => throw null;
                public static bool Enabled { get => throw null; set { } }
                public static void Initialize() => throw null;
                public static event System.Data.SQLite.SQLiteLogEventHandler Log;
                public static void LogMessage(string message) => throw null;
                public static void LogMessage(System.Data.SQLite.SQLiteErrorCode errorCode, string message) => throw null;
                public static void LogMessage(int errorCode, string message) => throw null;
                public static void RemoveDefaultHandler() => throw null;
                public static void Uninitialize() => throw null;
            }
            public delegate void SQLiteLogEventHandler(object sender, System.Data.SQLite.LogEventArgs e);
            public static class SQLiteMetaDataCollectionNames
            {
                public static readonly string Catalogs;
                public static readonly string Columns;
                public static readonly string ForeignKeys;
                public static readonly string IndexColumns;
                public static readonly string Indexes;
                public static readonly string Tables;
                public static readonly string Triggers;
                public static readonly string ViewColumns;
                public static readonly string Views;
            }
            public abstract class SQLiteModule : System.IDisposable, System.Data.SQLite.ISQLiteManagedModule
            {
                protected virtual nint AllocateCursor() => throw null;
                protected virtual nint AllocateTable() => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index);
                public abstract System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index);
                public abstract System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                public abstract System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                protected virtual System.Data.SQLite.ISQLiteNativeModule CreateNativeModuleImpl() => throw null;
                public SQLiteModule(string name) => throw null;
                protected virtual System.Data.SQLite.SQLiteVirtualTableCursor CursorFromIntPtr(nint pVtab, nint pCursor) => throw null;
                protected virtual nint CursorToIntPtr(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public virtual bool Declared { get => throw null; set { } }
                protected virtual System.Data.SQLite.SQLiteErrorCode DeclareFunction(System.Data.SQLite.SQLiteConnection connection, int argumentCount, string name, ref string error) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode DeclareTable(System.Data.SQLite.SQLiteConnection connection, string sql, ref string error) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table);
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public abstract bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values);
                public abstract bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref nint pClientData);
                protected virtual void FreeCursor(nint pCursor) => throw null;
                protected virtual void FreeTable(nint pVtab) => throw null;
                protected virtual string GetFunctionKey(int argumentCount, string name, System.Data.SQLite.SQLiteFunction function) => throw null;
                protected virtual System.Data.SQLite.ISQLiteNativeModule GetNativeModuleImpl() => throw null;
                public virtual bool LogErrors { get => throw null; set { } }
                protected virtual bool LogErrorsNoThrow { get => throw null; set { } }
                public virtual bool LogExceptions { get => throw null; set { } }
                protected virtual bool LogExceptionsNoThrow { get => throw null; set { } }
                public virtual string Name { get => throw null; }
                public abstract System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Release(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                public abstract System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName);
                public abstract System.Data.SQLite.SQLiteErrorCode Rollback(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode RollbackTo(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                public abstract System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref long rowId);
                public abstract System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                protected virtual bool SetCursorError(System.Data.SQLite.SQLiteVirtualTableCursor cursor, string error) => throw null;
                protected virtual bool SetEstimatedCost(System.Data.SQLite.SQLiteIndex index, double? estimatedCost) => throw null;
                protected virtual bool SetEstimatedCost(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetEstimatedRows(System.Data.SQLite.SQLiteIndex index, long? estimatedRows) => throw null;
                protected virtual bool SetEstimatedRows(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetIndexFlags(System.Data.SQLite.SQLiteIndex index, System.Data.SQLite.SQLiteIndexFlags? indexFlags) => throw null;
                protected virtual bool SetIndexFlags(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetTableError(nint pVtab, string error) => throw null;
                protected virtual bool SetTableError(System.Data.SQLite.SQLiteVirtualTable table, string error) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table);
                protected virtual nint TableFromCursor(nint pCursor) => throw null;
                protected virtual System.Data.SQLite.SQLiteVirtualTable TableFromIntPtr(nint pVtab) => throw null;
                protected virtual nint TableToIntPtr(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref long rowId);
                protected virtual void ZeroTable(nint pVtab) => throw null;
            }
            public class SQLiteModuleCommon : System.Data.SQLite.SQLiteModuleNoop
            {
                public SQLiteModuleCommon(string name) : base(default(string)) => throw null;
                public SQLiteModuleCommon(string name, bool objectIdentity) : base(default(string)) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode CursorTypeMismatchError(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Type type) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual long GetRowIdFromObject(System.Data.SQLite.SQLiteVirtualTableCursor cursor, object value) => throw null;
                protected virtual string GetSqlForDeclareTable() => throw null;
                protected virtual string GetStringFromObject(System.Data.SQLite.SQLiteVirtualTableCursor cursor, object value) => throw null;
                protected virtual long MakeRowId(int rowIndex, int hashCode) => throw null;
            }
            public class SQLiteModuleEnumerable : System.Data.SQLite.SQLiteModuleCommon
            {
                public override System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public SQLiteModuleEnumerable(string name, System.Collections.IEnumerable enumerable) : base(default(string)) => throw null;
                public SQLiteModuleEnumerable(string name, System.Collections.IEnumerable enumerable, bool objectIdentity) : base(default(string)) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode CursorEndOfEnumeratorError(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref long rowId) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref long rowId) => throw null;
            }
            public class SQLiteModuleNoop : System.Data.SQLite.SQLiteModule
            {
                public override System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, nint pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public SQLiteModuleNoop(string name) : base(default(string)) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public override bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref nint pClientData) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode GetDefaultResultCode() => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode GetMethodResultCode(string methodName) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Release(System.Data.SQLite.SQLiteVirtualTable table, int savepoint) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName) => throw null;
                protected virtual bool ResultCodeToEofResult(System.Data.SQLite.SQLiteErrorCode resultCode) => throw null;
                protected virtual bool ResultCodeToFindFunctionResult(System.Data.SQLite.SQLiteErrorCode resultCode) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Rollback(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode RollbackTo(System.Data.SQLite.SQLiteVirtualTable table, int savepoint) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref long rowId) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint) => throw null;
                protected virtual bool SetMethodResultCode(string methodName, System.Data.SQLite.SQLiteErrorCode resultCode) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref long rowId) => throw null;
            }
            public sealed class SQLiteParameter : System.Data.Common.DbParameter, System.ICloneable
            {
                public object Clone() => throw null;
                public System.Data.IDbCommand Command { get => throw null; set { } }
                public SQLiteParameter() => throw null;
                public SQLiteParameter(string parameterName) => throw null;
                public SQLiteParameter(string parameterName, object value) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType, string sourceColumn) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(System.Data.DbType dbType) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, object value) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, string sourceColumn) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, System.Data.ParameterDirection direction, bool isNullable, byte precision, byte scale, string sourceColumn, System.Data.DataRowVersion rowVersion, object value) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, System.Data.ParameterDirection direction, byte precision, byte scale, string sourceColumn, System.Data.DataRowVersion rowVersion, bool sourceColumnNullMapping, object value) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public override System.Data.DbType DbType { get => throw null; set { } }
                public override System.Data.ParameterDirection Direction { get => throw null; set { } }
                public override bool IsNullable { get => throw null; set { } }
                public override string ParameterName { get => throw null; set { } }
                public override void ResetDbType() => throw null;
                public override int Size { get => throw null; set { } }
                public override string SourceColumn { get => throw null; set { } }
                public override bool SourceColumnNullMapping { get => throw null; set { } }
                public override System.Data.DataRowVersion SourceVersion { get => throw null; set { } }
                public string TypeName { get => throw null; set { } }
                public override object Value { get => throw null; set { } }
            }
            public sealed class SQLiteParameterCollection : System.Data.Common.DbParameterCollection
            {
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType, int parameterSize) => throw null;
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType) => throw null;
                public int Add(System.Data.SQLite.SQLiteParameter parameter) => throw null;
                public override int Add(object value) => throw null;
                public void AddRange(System.Data.SQLite.SQLiteParameter[] values) => throw null;
                public override void AddRange(System.Array values) => throw null;
                public System.Data.SQLite.SQLiteParameter AddWithValue(string parameterName, object value) => throw null;
                public override void Clear() => throw null;
                public override bool Contains(string parameterName) => throw null;
                public override bool Contains(object value) => throw null;
                public override void CopyTo(System.Array array, int index) => throw null;
                public override int Count { get => throw null; }
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                protected override System.Data.Common.DbParameter GetParameter(string parameterName) => throw null;
                protected override System.Data.Common.DbParameter GetParameter(int index) => throw null;
                public override int IndexOf(string parameterName) => throw null;
                public override int IndexOf(object value) => throw null;
                public override void Insert(int index, object value) => throw null;
                public override bool IsFixedSize { get => throw null; }
                public override bool IsReadOnly { get => throw null; }
                public override bool IsSynchronized { get => throw null; }
                public override void Remove(object value) => throw null;
                public override void RemoveAt(string parameterName) => throw null;
                public override void RemoveAt(int index) => throw null;
                protected override void SetParameter(string parameterName, System.Data.Common.DbParameter value) => throw null;
                protected override void SetParameter(int index, System.Data.Common.DbParameter value) => throw null;
                public override object SyncRoot { get => throw null; }
                public System.Data.SQLite.SQLiteParameter this[string parameterName] { get => throw null; set { } }
                public System.Data.SQLite.SQLiteParameter this[int index] { get => throw null; set { } }
            }
            public delegate void SQLiteProgressEventHandler(object sender, System.Data.SQLite.ProgressEventArgs e);
            public enum SQLiteProgressReturnCode
            {
                Continue = 0,
                Interrupt = 1,
            }
            public class SQLiteReadArrayEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public int BufferOffset { get => throw null; set { } }
                public byte[] ByteBuffer { get => throw null; }
                public char[] CharBuffer { get => throw null; }
                public long DataOffset { get => throw null; set { } }
                public int Length { get => throw null; set { } }
            }
            public class SQLiteReadBlobEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public bool ReadOnly { get => throw null; set { } }
            }
            public abstract class SQLiteReadEventArgs : System.EventArgs
            {
                protected SQLiteReadEventArgs() => throw null;
            }
            public delegate void SQLiteReadValueCallback(System.Data.SQLite.SQLiteConvert convert, System.Data.SQLite.SQLiteDataReader dataReader, System.Data.SQLite.SQLiteConnectionFlags flags, System.Data.SQLite.SQLiteReadEventArgs eventArgs, string typeName, int index, object userData, out bool complete);
            public class SQLiteReadValueEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public System.Data.SQLite.SQLiteReadEventArgs ExtraEventArgs { get => throw null; }
                public string MethodName { get => throw null; }
                public System.Data.SQLite.SQLiteDataReaderValue Value { get => throw null; }
            }
            public delegate void SQLiteStepDelegate(string param0, object[] args, int stepNumber, ref object contextData);
            public delegate void SQLiteTraceEventHandler(object sender, System.Data.SQLite.TraceEventArgs e);
            [System.Flags]
            public enum SQLiteTraceFlags
            {
                SQLITE_TRACE_NONE = 0,
                SQLITE_TRACE_STMT = 1,
                SQLITE_TRACE_PROFILE = 2,
                SQLITE_TRACE_ROW = 4,
                SQLITE_TRACE_CLOSE = 8,
                SQLITE_TRACE_ALL = 15,
            }
            public class SQLiteTransaction : System.Data.SQLite.SQLiteTransactionBase
            {
                protected override void Begin(bool deferredLock) => throw null;
                public override void Commit() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void IssueRollback(bool throwError) => throw null;
            }
            public sealed class SQLiteTransaction2 : System.Data.SQLite.SQLiteTransaction
            {
                protected override void Begin(bool deferredLock) => throw null;
                public override void Commit() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void IssueRollback(bool throwError) => throw null;
            }
            public abstract class SQLiteTransactionBase : System.Data.Common.DbTransaction
            {
                protected abstract void Begin(bool deferredLock);
                public System.Data.SQLite.SQLiteConnection Connection { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                protected abstract void IssueRollback(bool throwError);
                public override void Rollback() => throw null;
            }
            public sealed class SQLiteTypeCallbacks
            {
                public System.Data.SQLite.SQLiteBindValueCallback BindValueCallback { get => throw null; }
                public object BindValueUserData { get => throw null; }
                public static System.Data.SQLite.SQLiteTypeCallbacks Create(System.Data.SQLite.SQLiteBindValueCallback bindValueCallback, System.Data.SQLite.SQLiteReadValueCallback readValueCallback, object bindValueUserData, object readValueUserData) => throw null;
                public System.Data.SQLite.SQLiteReadValueCallback ReadValueCallback { get => throw null; }
                public object ReadValueUserData { get => throw null; }
                public string TypeName { get => throw null; }
            }
            public delegate void SQLiteUpdateEventHandler(object sender, System.Data.SQLite.UpdateEventArgs e);
            public sealed class SQLiteValue : System.Data.SQLite.ISQLiteNativeHandle
            {
                public int FromBind { get => throw null; }
                public byte[] GetBlob() => throw null;
                public int GetBytes() => throw null;
                public double GetDouble() => throw null;
                public int GetFromBind() => throw null;
                public int GetInt() => throw null;
                public long GetInt64() => throw null;
                public int GetNoChange() => throw null;
                public System.Data.SQLite.TypeAffinity GetNumericType() => throw null;
                public object GetObject() => throw null;
                public string GetString() => throw null;
                public uint GetSubType() => throw null;
                public System.Data.SQLite.TypeAffinity GetTypeAffinity() => throw null;
                public nint NativeHandle { get => throw null; }
                public int NoChange { get => throw null; }
                public bool Persist() => throw null;
                public bool Persisted { get => throw null; }
                public uint SubType { get => throw null; }
                public object Value { get => throw null; }
            }
            public class SQLiteVirtualTable : System.IDisposable, System.Data.SQLite.ISQLiteNativeHandle
            {
                public virtual string[] Arguments { get => throw null; }
                public virtual bool BestIndex(System.Data.SQLite.SQLiteIndex index) => throw null;
                public SQLiteVirtualTable(string[] arguments) => throw null;
                public virtual string DatabaseName { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Data.SQLite.SQLiteIndex Index { get => throw null; }
                public virtual string ModuleName { get => throw null; }
                public virtual nint NativeHandle { get => throw null; set { } }
                public virtual bool Rename(string name) => throw null;
                public virtual string TableName { get => throw null; }
            }
            public class SQLiteVirtualTableCursor : System.IDisposable, System.Data.SQLite.ISQLiteNativeHandle
            {
                public SQLiteVirtualTableCursor(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual void Filter(int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public virtual int GetRowIndex() => throw null;
                public virtual int IndexNumber { get => throw null; }
                public virtual string IndexString { get => throw null; }
                protected static readonly int InvalidRowIndex;
                public virtual nint NativeHandle { get => throw null; set { } }
                public virtual void NextRowIndex() => throw null;
                public virtual System.Data.SQLite.SQLiteVirtualTable Table { get => throw null; }
                protected virtual int TryPersistValues(System.Data.SQLite.SQLiteValue[] values) => throw null;
                public virtual System.Data.SQLite.SQLiteValue[] Values { get => throw null; }
            }
            public class SQLiteVirtualTableCursorEnumerator : System.Data.SQLite.SQLiteVirtualTableCursor, System.Collections.IEnumerator
            {
                public virtual void CheckClosed() => throw null;
                public virtual void Close() => throw null;
                public SQLiteVirtualTableCursorEnumerator(System.Data.SQLite.SQLiteVirtualTable table, System.Collections.IEnumerator enumerator) : base(default(System.Data.SQLite.SQLiteVirtualTable)) => throw null;
                public virtual object Current { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public virtual bool EndOfEnumerator { get => throw null; }
                public virtual bool IsOpen { get => throw null; }
                public virtual bool MoveNext() => throw null;
                public virtual void Reset() => throw null;
            }
            public enum SynchronizationModes
            {
                Normal = 0,
                Full = 1,
                Off = 2,
            }
            public class TraceEventArgs : System.EventArgs
            {
                public readonly nint? DatabaseConnection;
                public readonly long? Elapsed;
                public readonly System.Data.SQLite.SQLiteTraceFlags? Flags;
                public readonly nint? PreparedStatement;
                public readonly string Statement;
            }
            public enum TypeAffinity
            {
                Uninitialized = 0,
                Int64 = 1,
                Double = 2,
                Text = 3,
                Blob = 4,
                Null = 5,
                DateTime = 10,
                None = 11,
            }
            public class UpdateEventArgs : System.EventArgs
            {
                public readonly string Database;
                public readonly System.Data.SQLite.UpdateEventType Event;
                public readonly long RowId;
                public readonly string Table;
            }
            public enum UpdateEventType
            {
                Delete = 9,
                Insert = 18,
                Update = 23,
            }
        }
    }
}
