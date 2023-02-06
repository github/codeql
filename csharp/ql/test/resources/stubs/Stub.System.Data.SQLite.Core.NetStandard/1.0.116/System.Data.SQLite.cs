// This file contains auto-generated code.

namespace System
{
    namespace Data
    {
        namespace SQLite
        {
            // Generated from `System.Data.SQLite.AssemblySourceIdAttribute` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class AssemblySourceIdAttribute : System.Attribute
            {
                public AssemblySourceIdAttribute(string value) => throw null;
                public string SourceId { get => throw null; }
            }

            // Generated from `System.Data.SQLite.AssemblySourceTimeStampAttribute` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class AssemblySourceTimeStampAttribute : System.Attribute
            {
                public AssemblySourceTimeStampAttribute(string value) => throw null;
                public string SourceTimeStamp { get => throw null; }
            }

            // Generated from `System.Data.SQLite.AuthorizerEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class AuthorizerEventArgs : System.EventArgs
            {
                public System.Data.SQLite.SQLiteAuthorizerActionCode ActionCode;
                public string Argument1;
                public string Argument2;
                public string Context;
                public string Database;
                public System.Data.SQLite.SQLiteAuthorizerReturnCode ReturnCode;
                public System.IntPtr UserData;
            }

            // Generated from `System.Data.SQLite.BusyEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class BusyEventArgs : System.EventArgs
            {
                public int Count;
                public System.Data.SQLite.SQLiteBusyReturnCode ReturnCode;
                public System.IntPtr UserData;
            }

            // Generated from `System.Data.SQLite.CollationEncodingEnum` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum CollationEncodingEnum
            {
                UTF16BE,
                UTF16LE,
                UTF8,
            }

            // Generated from `System.Data.SQLite.CollationSequence` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public struct CollationSequence
            {
                // Stub generator skipped constructor 
                public int Compare(System.Char[] c1, System.Char[] c2) => throw null;
                public int Compare(string s1, string s2) => throw null;
                public System.Data.SQLite.CollationEncodingEnum Encoding;
                public string Name;
                public System.Data.SQLite.CollationTypeEnum Type;
            }

            // Generated from `System.Data.SQLite.CollationTypeEnum` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum CollationTypeEnum
            {
                Binary,
                Custom,
                NoCase,
                Reverse,
            }

            // Generated from `System.Data.SQLite.CommitEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class CommitEventArgs : System.EventArgs
            {
                public bool AbortTransaction;
            }

            // Generated from `System.Data.SQLite.ConnectionEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class ConnectionEventArgs : System.EventArgs
            {
                public System.Data.IDbCommand Command;
                public System.Runtime.InteropServices.CriticalHandle CriticalHandle;
                public object Data;
                public System.Data.IDataReader DataReader;
                public System.Data.StateChangeEventArgs EventArgs;
                public System.Data.SQLite.SQLiteConnectionEventType EventType;
                public string Text;
                public System.Data.IDbTransaction Transaction;
            }

            // Generated from `System.Data.SQLite.FunctionType` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum FunctionType
            {
                Aggregate,
                Collation,
                Scalar,
            }

            // Generated from `System.Data.SQLite.ISQLiteChangeGroup` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteChangeGroup : System.IDisposable
            {
                void AddChangeSet(System.Byte[] rawData);
                void AddChangeSet(System.IO.Stream stream);
                void CreateChangeSet(System.IO.Stream stream);
                void CreateChangeSet(ref System.Byte[] rawData);
            }

            // Generated from `System.Data.SQLite.ISQLiteChangeSet` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteChangeSet : System.Collections.Generic.IEnumerable<System.Data.SQLite.ISQLiteChangeSetMetadataItem>, System.Collections.IEnumerable, System.IDisposable
            {
                void Apply(System.Data.SQLite.SessionConflictCallback conflictCallback, System.Data.SQLite.SessionTableFilterCallback tableFilterCallback, object clientData);
                void Apply(System.Data.SQLite.SessionConflictCallback conflictCallback, object clientData);
                System.Data.SQLite.ISQLiteChangeSet CombineWith(System.Data.SQLite.ISQLiteChangeSet changeSet);
                System.Data.SQLite.ISQLiteChangeSet Invert();
            }

            // Generated from `System.Data.SQLite.ISQLiteChangeSetMetadataItem` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
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

            // Generated from `System.Data.SQLite.ISQLiteConnectionPool` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteConnectionPool
            {
                void Add(string fileName, object handle, int version);
                void ClearAllPools();
                void ClearPool(string fileName);
                void GetCounts(string fileName, ref System.Collections.Generic.Dictionary<string, int> counts, ref int openCount, ref int closeCount, ref int totalCount);
                object Remove(string fileName, int maxPoolSize, out int version);
            }

            // Generated from `System.Data.SQLite.ISQLiteConnectionPool2` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteConnectionPool2 : System.Data.SQLite.ISQLiteConnectionPool
            {
                void GetCounts(ref int openCount, ref int closeCount);
                void Initialize(object argument);
                void ResetCounts();
                void Terminate(object argument);
            }

            // Generated from `System.Data.SQLite.ISQLiteManagedModule` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteManagedModule
            {
                System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index);
                System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index);
                System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                bool Declared { get; }
                System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table);
                bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values);
                bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref System.IntPtr pClientData);
                string Name { get; }
                System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                System.Data.SQLite.SQLiteErrorCode Release(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName);
                System.Data.SQLite.SQLiteErrorCode Rollback(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode RollbackTo(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref System.Int64 rowId);
                System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table);
                System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref System.Int64 rowId);
            }

            // Generated from `System.Data.SQLite.ISQLiteNativeHandle` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteNativeHandle
            {
                System.IntPtr NativeHandle { get; }
            }

            // Generated from `System.Data.SQLite.ISQLiteNativeModule` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteNativeModule
            {
                System.Data.SQLite.SQLiteErrorCode xBegin(System.IntPtr pVtab);
                System.Data.SQLite.SQLiteErrorCode xBestIndex(System.IntPtr pVtab, System.IntPtr pIndex);
                System.Data.SQLite.SQLiteErrorCode xClose(System.IntPtr pCursor);
                System.Data.SQLite.SQLiteErrorCode xColumn(System.IntPtr pCursor, System.IntPtr pContext, int index);
                System.Data.SQLite.SQLiteErrorCode xCommit(System.IntPtr pVtab);
                System.Data.SQLite.SQLiteErrorCode xConnect(System.IntPtr pDb, System.IntPtr pAux, int argc, System.IntPtr argv, ref System.IntPtr pVtab, ref System.IntPtr pError);
                System.Data.SQLite.SQLiteErrorCode xCreate(System.IntPtr pDb, System.IntPtr pAux, int argc, System.IntPtr argv, ref System.IntPtr pVtab, ref System.IntPtr pError);
                System.Data.SQLite.SQLiteErrorCode xDestroy(System.IntPtr pVtab);
                System.Data.SQLite.SQLiteErrorCode xDisconnect(System.IntPtr pVtab);
                int xEof(System.IntPtr pCursor);
                System.Data.SQLite.SQLiteErrorCode xFilter(System.IntPtr pCursor, int idxNum, System.IntPtr idxStr, int argc, System.IntPtr argv);
                int xFindFunction(System.IntPtr pVtab, int nArg, System.IntPtr zName, ref System.Data.SQLite.SQLiteCallback callback, ref System.IntPtr pClientData);
                System.Data.SQLite.SQLiteErrorCode xNext(System.IntPtr pCursor);
                System.Data.SQLite.SQLiteErrorCode xOpen(System.IntPtr pVtab, ref System.IntPtr pCursor);
                System.Data.SQLite.SQLiteErrorCode xRelease(System.IntPtr pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xRename(System.IntPtr pVtab, System.IntPtr zNew);
                System.Data.SQLite.SQLiteErrorCode xRollback(System.IntPtr pVtab);
                System.Data.SQLite.SQLiteErrorCode xRollbackTo(System.IntPtr pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xRowId(System.IntPtr pCursor, ref System.Int64 rowId);
                System.Data.SQLite.SQLiteErrorCode xSavepoint(System.IntPtr pVtab, int iSavepoint);
                System.Data.SQLite.SQLiteErrorCode xSync(System.IntPtr pVtab);
                System.Data.SQLite.SQLiteErrorCode xUpdate(System.IntPtr pVtab, int argc, System.IntPtr argv, ref System.Int64 rowId);
            }

            // Generated from `System.Data.SQLite.ISQLiteSchemaExtensions` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteSchemaExtensions
            {
                void BuildTempSchema(System.Data.SQLite.SQLiteConnection connection);
            }

            // Generated from `System.Data.SQLite.ISQLiteSession` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public interface ISQLiteSession : System.IDisposable
            {
                void AttachTable(string name);
                void CreateChangeSet(System.IO.Stream stream);
                void CreateChangeSet(ref System.Byte[] rawData);
                void CreatePatchSet(System.IO.Stream stream);
                void CreatePatchSet(ref System.Byte[] rawData);
                System.Int64 GetMemoryBytesInUse();
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

            // Generated from `System.Data.SQLite.LogEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class LogEventArgs : System.EventArgs
            {
                public object Data;
                public object ErrorCode;
                public string Message;
            }

            // Generated from `System.Data.SQLite.ProgressEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class ProgressEventArgs : System.EventArgs
            {
                public System.Data.SQLite.SQLiteProgressReturnCode ReturnCode;
                public System.IntPtr UserData;
            }

            // Generated from `System.Data.SQLite.SQLiteAuthorizerActionCode` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteAuthorizerActionCode
            {
                AlterTable,
                Analyze,
                Attach,
                Copy,
                CreateIndex,
                CreateTable,
                CreateTempIndex,
                CreateTempTable,
                CreateTempTrigger,
                CreateTempView,
                CreateTrigger,
                CreateView,
                CreateVtable,
                Delete,
                Detach,
                DropIndex,
                DropTable,
                DropTempIndex,
                DropTempTable,
                DropTempTrigger,
                DropTempView,
                DropTrigger,
                DropView,
                DropVtable,
                Function,
                Insert,
                None,
                Pragma,
                Read,
                Recursive,
                Reindex,
                Savepoint,
                Select,
                Transaction,
                Update,
            }

            // Generated from `System.Data.SQLite.SQLiteAuthorizerEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteAuthorizerEventHandler(object sender, System.Data.SQLite.AuthorizerEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteAuthorizerReturnCode` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteAuthorizerReturnCode
            {
                Deny,
                Ignore,
                Ok,
            }

            // Generated from `System.Data.SQLite.SQLiteBackupCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate bool SQLiteBackupCallback(System.Data.SQLite.SQLiteConnection source, string sourceName, System.Data.SQLite.SQLiteConnection destination, string destinationName, int pages, int remainingPages, int totalPages, bool retry);

            // Generated from `System.Data.SQLite.SQLiteBindValueCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteBindValueCallback(System.Data.SQLite.SQLiteConvert convert, System.Data.SQLite.SQLiteCommand command, System.Data.SQLite.SQLiteConnectionFlags flags, System.Data.SQLite.SQLiteParameter parameter, string typeName, int index, object userData, out bool complete);

            // Generated from `System.Data.SQLite.SQLiteBlob` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteBlob : System.IDisposable
            {
                public void Close() => throw null;
                public static System.Data.SQLite.SQLiteBlob Create(System.Data.SQLite.SQLiteConnection connection, string databaseName, string tableName, string columnName, System.Int64 rowId, bool readOnly) => throw null;
                public static System.Data.SQLite.SQLiteBlob Create(System.Data.SQLite.SQLiteDataReader dataReader, int i, bool readOnly) => throw null;
                public void Dispose() => throw null;
                public int GetCount() => throw null;
                public void Read(System.Byte[] buffer, int count, int offset) => throw null;
                public void Reopen(System.Int64 rowId) => throw null;
                public void Write(System.Byte[] buffer, int count, int offset) => throw null;
                // ERR: Stub generator didn't handle member: ~SQLiteBlob
            }

            // Generated from `System.Data.SQLite.SQLiteBusyEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteBusyEventHandler(object sender, System.Data.SQLite.BusyEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteBusyReturnCode` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteBusyReturnCode
            {
                Retry,
                Stop,
            }

            // Generated from `System.Data.SQLite.SQLiteCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteCallback(System.IntPtr context, int argc, System.IntPtr argv);

            // Generated from `System.Data.SQLite.SQLiteChangeSetConflictResult` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteChangeSetConflictResult
            {
                Abort,
                Omit,
                Replace,
            }

            // Generated from `System.Data.SQLite.SQLiteChangeSetConflictType` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteChangeSetConflictType
            {
                Conflict,
                Constraint,
                Data,
                ForeignKey,
                NotFound,
            }

            // Generated from `System.Data.SQLite.SQLiteChangeSetStartFlags` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteChangeSetStartFlags
            {
                Invert,
                None,
            }

            // Generated from `System.Data.SQLite.SQLiteCommand` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteCommand : System.Data.Common.DbCommand, System.ICloneable
            {
                public override void Cancel() => throw null;
                public object Clone() => throw null;
                public override string CommandText { get => throw null; set => throw null; }
                public override int CommandTimeout { get => throw null; set => throw null; }
                public override System.Data.CommandType CommandType { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteConnection Connection { get => throw null; set => throw null; }
                protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                public System.Data.SQLite.SQLiteParameter CreateParameter() => throw null;
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set => throw null; }
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set => throw null; }
                public override bool DesignTimeVisible { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, System.Data.CommandBehavior commandBehavior, System.Data.SQLite.SQLiteConnection connection, params object[] args) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, System.Data.CommandBehavior commandBehavior, string connectionString, params object[] args) => throw null;
                public static object Execute(string commandText, System.Data.SQLite.SQLiteExecuteType executeType, string connectionString, params object[] args) => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public int ExecuteNonQuery(System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SQLite.SQLiteDataReader ExecuteReader() => throw null;
                public System.Data.SQLite.SQLiteDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public override object ExecuteScalar() => throw null;
                public object ExecuteScalar(System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SQLite.SQLiteParameterCollection Parameters { get => throw null; }
                public override void Prepare() => throw null;
                public void Reset() => throw null;
                public void Reset(bool clearBindings, bool ignoreErrors) => throw null;
                public SQLiteCommand() => throw null;
                public SQLiteCommand(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteCommand(string commandText) => throw null;
                public SQLiteCommand(string commandText, System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteCommand(string commandText, System.Data.SQLite.SQLiteConnection connection, System.Data.SQLite.SQLiteTransaction transaction) => throw null;
                public System.Data.SQLite.SQLiteTransaction Transaction { get => throw null; set => throw null; }
                public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set => throw null; }
                public void VerifyOnly() => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteCommandBuilder` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteCommandBuilder : System.Data.Common.DbCommandBuilder
            {
                protected override void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow row, System.Data.StatementType statementType, bool whereClause) => throw null;
                public override System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set => throw null; }
                public override string CatalogSeparator { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteDataAdapter DataAdapter { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.SQLite.SQLiteCommand GetDeleteCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetDeleteCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.SQLite.SQLiteCommand GetInsertCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetInsertCommand(bool useColumnsForParameterNames) => throw null;
                protected override string GetParameterName(int parameterOrdinal) => throw null;
                protected override string GetParameterName(string parameterName) => throw null;
                protected override string GetParameterPlaceholder(int parameterOrdinal) => throw null;
                protected override System.Data.DataTable GetSchemaTable(System.Data.Common.DbCommand sourceCommand) => throw null;
                public System.Data.SQLite.SQLiteCommand GetUpdateCommand() => throw null;
                public System.Data.SQLite.SQLiteCommand GetUpdateCommand(bool useColumnsForParameterNames) => throw null;
                public override string QuoteIdentifier(string unquotedIdentifier) => throw null;
                public override string QuotePrefix { get => throw null; set => throw null; }
                public override string QuoteSuffix { get => throw null; set => throw null; }
                public SQLiteCommandBuilder() => throw null;
                public SQLiteCommandBuilder(System.Data.SQLite.SQLiteDataAdapter adp) => throw null;
                public override string SchemaSeparator { get => throw null; set => throw null; }
                protected override void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter) => throw null;
                public override string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteCommitHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteCommitHandler(object sender, System.Data.SQLite.CommitEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteCompareDelegate` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate int SQLiteCompareDelegate(string param0, string param1, string param2);

            // Generated from `System.Data.SQLite.SQLiteConfigDbOpsEnum` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteConfigDbOpsEnum
            {
                SQLITE_DBCONFIG_DEFENSIVE,
                SQLITE_DBCONFIG_DQS_DDL,
                SQLITE_DBCONFIG_DQS_DML,
                SQLITE_DBCONFIG_ENABLE_FKEY,
                SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER,
                SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION,
                SQLITE_DBCONFIG_ENABLE_QPSG,
                SQLITE_DBCONFIG_ENABLE_TRIGGER,
                SQLITE_DBCONFIG_ENABLE_VIEW,
                SQLITE_DBCONFIG_LEGACY_ALTER_TABLE,
                SQLITE_DBCONFIG_LEGACY_FILE_FORMAT,
                SQLITE_DBCONFIG_LOOKASIDE,
                SQLITE_DBCONFIG_MAINDBNAME,
                SQLITE_DBCONFIG_NONE,
                SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE,
                SQLITE_DBCONFIG_RESET_DATABASE,
                SQLITE_DBCONFIG_TRIGGER_EQP,
                SQLITE_DBCONFIG_TRUSTED_SCHEMA,
                SQLITE_DBCONFIG_WRITABLE_SCHEMA,
            }

            // Generated from `System.Data.SQLite.SQLiteConnection` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteConnection : System.Data.Common.DbConnection, System.ICloneable, System.IDisposable
            {
                public int AddTypeMapping(string typeName, System.Data.DbType dataType, bool primary) => throw null;
                public event System.Data.SQLite.SQLiteAuthorizerEventHandler Authorize;
                public bool AutoCommit { get => throw null; }
                public void BackupDatabase(System.Data.SQLite.SQLiteConnection destination, string destinationName, string sourceName, int pages, System.Data.SQLite.SQLiteBackupCallback callback, int retryMilliseconds) => throw null;
                protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction() => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel, bool deferredLock) => throw null;
                public System.Data.SQLite.SQLiteTransaction BeginTransaction(bool deferredLock) => throw null;
                public void BindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute, System.Delegate callback1, System.Delegate callback2) => throw null;
                public void BindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute, System.Data.SQLite.SQLiteFunction function) => throw null;
                public event System.Data.SQLite.SQLiteBusyEventHandler Busy;
                public int BusyTimeout { get => throw null; set => throw null; }
                public void Cancel() => throw null;
                public override void ChangeDatabase(string databaseName) => throw null;
                public void ChangePassword(System.Byte[] newPassword) => throw null;
                public void ChangePassword(string newPassword) => throw null;
                public static event System.Data.SQLite.SQLiteConnectionEventHandler Changed;
                public int Changes { get => throw null; }
                public static void ClearAllPools() => throw null;
                public int ClearCachedSettings() => throw null;
                public static void ClearPool(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public int ClearTypeCallbacks() => throw null;
                public int ClearTypeMappings() => throw null;
                public object Clone() => throw null;
                public override void Close() => throw null;
                public static System.Int64 CloseCount { get => throw null; }
                public event System.Data.SQLite.SQLiteCommitHandler Commit;
                public static System.Data.SQLite.ISQLiteConnectionPool ConnectionPool { get => throw null; set => throw null; }
                public override string ConnectionString { get => throw null; set => throw null; }
                public System.Data.SQLite.ISQLiteChangeGroup CreateChangeGroup() => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.Byte[] rawData) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.Byte[] rawData, System.Data.SQLite.SQLiteChangeSetStartFlags flags) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.IO.Stream inputStream, System.IO.Stream outputStream) => throw null;
                public System.Data.SQLite.ISQLiteChangeSet CreateChangeSet(System.IO.Stream inputStream, System.IO.Stream outputStream, System.Data.SQLite.SQLiteChangeSetStartFlags flags) => throw null;
                public System.Data.SQLite.SQLiteCommand CreateCommand() => throw null;
                public static System.Int64 CreateCount { get => throw null; }
                protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                public static void CreateFile(string databaseFileName) => throw null;
                public static object CreateHandle(System.IntPtr nativeHandle) => throw null;
                public void CreateModule(System.Data.SQLite.SQLiteModule module) => throw null;
                public static System.Data.SQLite.ISQLiteConnectionPool CreatePool(string typeName, object argument) => throw null;
                public System.Data.SQLite.ISQLiteSession CreateSession(string databaseName) => throw null;
                public override string DataSource { get => throw null; }
                public override string Database { get => throw null; }
                protected override System.Data.Common.DbProviderFactory DbProviderFactory { get => throw null; }
                public static string DecryptLegacyDatabase(string fileName, System.Byte[] passwordBytes, int? pageSize, System.Data.SQLite.SQLiteProgressEventHandler progress) => throw null;
                public System.Data.DbType? DefaultDbType { get => throw null; set => throw null; }
                public static System.Data.SQLite.SQLiteConnectionFlags DefaultFlags { get => throw null; }
                public int DefaultTimeout { get => throw null; set => throw null; }
                public string DefaultTypeName { get => throw null; set => throw null; }
                public static string DefineConstants { get => throw null; }
                public void Dispose() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public static System.Int64 DisposeCount { get => throw null; }
                public void EnableExtensions(bool enable) => throw null;
                public override void EnlistTransaction(System.Transactions.Transaction transaction) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ExtendedResultCode() => throw null;
                public string FileName { get => throw null; }
                public System.Data.SQLite.SQLiteConnectionFlags Flags { get => throw null; set => throw null; }
                public object GetCriticalHandle() => throw null;
                public static void GetMemoryStatistics(ref System.Collections.Generic.IDictionary<string, System.Int64> statistics) => throw null;
                public override System.Data.DataTable GetSchema() => throw null;
                public override System.Data.DataTable GetSchema(string collectionName) => throw null;
                public override System.Data.DataTable GetSchema(string collectionName, string[] restrictionValues) => throw null;
                public System.Collections.Generic.Dictionary<string, object> GetTypeMappings() => throw null;
                public static string InteropCompileOptions { get => throw null; }
                public static string InteropSourceId { get => throw null; }
                public static string InteropVersion { get => throw null; }
                public bool IsReadOnly(string name) => throw null;
                public System.Int64 LastInsertRowId { get => throw null; }
                public void LoadExtension(string fileName) => throw null;
                public void LoadExtension(string fileName, string procName) => throw null;
                public void LogMessage(System.Data.SQLite.SQLiteErrorCode iErrCode, string zMessage) => throw null;
                public void LogMessage(int iErrCode, string zMessage) => throw null;
                public System.Int64 MemoryHighwater { get => throw null; }
                public System.Int64 MemoryUsed { get => throw null; }
                public override void Open() => throw null;
                public System.Data.SQLite.SQLiteConnection OpenAndReturn() => throw null;
                public static System.Int64 OpenCount { get => throw null; }
                public bool OwnHandle { get => throw null; }
                public bool ParseViaFramework { get => throw null; set => throw null; }
                public int PoolCount { get => throw null; }
                public int PrepareRetries { get => throw null; set => throw null; }
                public event System.Data.SQLite.SQLiteProgressEventHandler Progress;
                public int ProgressOps { get => throw null; set => throw null; }
                public static string ProviderSourceId { get => throw null; }
                public static string ProviderVersion { get => throw null; }
                public void ReleaseMemory() => throw null;
                public static System.Data.SQLite.SQLiteErrorCode ReleaseMemory(int nBytes, bool reset, bool compact, ref int nFree, ref bool resetOk, ref System.UInt32 nLargest) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ResultCode() => throw null;
                public event System.EventHandler RollBack;
                public static string SQLiteCompileOptions { get => throw null; }
                public SQLiteConnection() => throw null;
                public SQLiteConnection(System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteConnection(string connectionString) => throw null;
                public SQLiteConnection(string connectionString, bool parseViaFramework) => throw null;
                public static string SQLiteSourceId { get => throw null; }
                public static string SQLiteVersion { get => throw null; }
                public override string ServerVersion { get => throw null; }
                public System.Data.SQLite.SQLiteErrorCode SetAvRetry(ref int count, ref int interval) => throw null;
                public System.Data.SQLite.SQLiteErrorCode SetChunkSize(int size) => throw null;
                public void SetConfigurationOption(System.Data.SQLite.SQLiteConfigDbOpsEnum option, object value) => throw null;
                public void SetExtendedResultCodes(bool bOnOff) => throw null;
                public int SetLimitOption(System.Data.SQLite.SQLiteLimitOpsEnum option, int value) => throw null;
                public static System.Data.SQLite.SQLiteErrorCode SetMemoryStatus(bool value) => throw null;
                public void SetPassword(System.Byte[] databasePassword) => throw null;
                public void SetPassword(string databasePassword) => throw null;
                public bool SetTypeCallbacks(string typeName, System.Data.SQLite.SQLiteTypeCallbacks callbacks) => throw null;
                public static System.Data.SQLite.SQLiteConnectionFlags SharedFlags { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteErrorCode Shutdown() => throw null;
                public static void Shutdown(bool directories, bool noThrow) => throw null;
                public override System.Data.ConnectionState State { get => throw null; }
                public override event System.Data.StateChangeEventHandler StateChange;
                public event System.Data.SQLite.SQLiteTraceEventHandler Trace;
                public bool TryGetTypeCallbacks(string typeName, out System.Data.SQLite.SQLiteTypeCallbacks callbacks) => throw null;
                public bool UnbindAllFunctions(bool registered) => throw null;
                public bool UnbindFunction(System.Data.SQLite.SQLiteFunctionAttribute functionAttribute) => throw null;
                public event System.Data.SQLite.SQLiteUpdateEventHandler Update;
                public string VfsName { get => throw null; set => throw null; }
                public bool WaitForEnlistmentReset(int timeoutMilliseconds, bool? returnOnDisposed) => throw null;
                public int WaitTimeout { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteConnectionEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteConnectionEventHandler(object sender, System.Data.SQLite.ConnectionEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteConnectionEventType` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteConnectionEventType
            {
                ChangeDatabase,
                Closed,
                ClosedToPool,
                Closing,
                ClosingDataReader,
                ConnectionString,
                DisposingCommand,
                DisposingDataReader,
                EnlistTransaction,
                Invalid,
                NewCommand,
                NewCriticalHandle,
                NewDataReader,
                NewTransaction,
                Opened,
                OpenedFromPool,
                Opening,
                Unknown,
            }

            // Generated from `System.Data.SQLite.SQLiteConnectionFlags` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            [System.Flags]
            public enum SQLiteConnectionFlags
            {
                AllowNestedTransactions,
                BindAllAsText,
                BindAndGetAllAsInvariantText,
                BindAndGetAllAsText,
                BindDateTimeWithKind,
                BindDecimalAsText,
                BindInvariantDecimal,
                BindInvariantText,
                BindUInt32AsInt64,
                ConvertAndBindAndGetAllAsInvariantText,
                ConvertAndBindInvariantText,
                ConvertInvariantText,
                Default,
                DefaultAndLogAll,
                DenyOnException,
                DetectStringType,
                DetectTextAffinity,
                GetAllAsText,
                GetDecimalAsText,
                GetInvariantDecimal,
                GetInvariantDouble,
                GetInvariantInt64,
                HidePassword,
                InterruptOnException,
                LogAll,
                LogBackup,
                LogBind,
                LogCallbackException,
                LogDefault,
                LogModuleError,
                LogModuleException,
                LogPreBind,
                LogPrepare,
                MapIsolationLevels,
                NoBindFunctions,
                NoConnectionPool,
                NoConvertSettings,
                NoCoreFunctions,
                NoCreateModule,
                NoExtensionFunctions,
                NoGlobalTypes,
                NoLoadExtension,
                NoLogModule,
                NoVerifyTextAffinity,
                NoVerifyTypeAffinity,
                None,
                RollbackOnException,
                StickyHasRows,
                StopOnException,
                StrictConformance,
                StrictEnlistment,
                TraceWarning,
                UnbindFunctionsOnClose,
                UseConnectionAllValueCallbacks,
                UseConnectionBindValueCallbacks,
                UseConnectionPool,
                UseConnectionReadValueCallbacks,
                UseConnectionTypes,
                UseParameterAnythingForTypeName,
                UseParameterDbTypeForTypeName,
                UseParameterNameForTypeName,
                WaitForEnlistmentReset,
            }

            // Generated from `System.Data.SQLite.SQLiteConnectionStringBuilder` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
            {
                public string BaseSchemaName { get => throw null; set => throw null; }
                public bool BinaryGUID { get => throw null; set => throw null; }
                public int BusyTimeout { get => throw null; set => throw null; }
                public int CacheSize { get => throw null; set => throw null; }
                public string DataSource { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteDateFormats DateTimeFormat { get => throw null; set => throw null; }
                public string DateTimeFormatString { get => throw null; set => throw null; }
                public System.DateTimeKind DateTimeKind { get => throw null; set => throw null; }
                public System.Data.DbType DefaultDbType { get => throw null; set => throw null; }
                public System.Data.IsolationLevel DefaultIsolationLevel { get => throw null; set => throw null; }
                public int DefaultTimeout { get => throw null; set => throw null; }
                public string DefaultTypeName { get => throw null; set => throw null; }
                public bool Enlist { get => throw null; set => throw null; }
                public bool FailIfMissing { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteConnectionFlags Flags { get => throw null; set => throw null; }
                public bool ForeignKeys { get => throw null; set => throw null; }
                public string FullUri { get => throw null; set => throw null; }
                public System.Byte[] HexPassword { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteJournalModeEnum JournalMode { get => throw null; set => throw null; }
                public bool LegacyFormat { get => throw null; set => throw null; }
                public int MaxPageCount { get => throw null; set => throw null; }
                public bool NoDefaultFlags { get => throw null; set => throw null; }
                public bool NoSharedFlags { get => throw null; set => throw null; }
                public int PageSize { get => throw null; set => throw null; }
                public string Password { get => throw null; set => throw null; }
                public bool Pooling { get => throw null; set => throw null; }
                public int PrepareRetries { get => throw null; set => throw null; }
                public int ProgressOps { get => throw null; set => throw null; }
                public bool ReadOnly { get => throw null; set => throw null; }
                public bool RecursiveTriggers { get => throw null; set => throw null; }
                public SQLiteConnectionStringBuilder() => throw null;
                public SQLiteConnectionStringBuilder(string connectionString) => throw null;
                public bool SetDefaults { get => throw null; set => throw null; }
                public System.Data.SQLite.SynchronizationModes SyncMode { get => throw null; set => throw null; }
                public string TextPassword { get => throw null; set => throw null; }
                public bool ToFullPath { get => throw null; set => throw null; }
                public override bool TryGetValue(string keyword, out object value) => throw null;
                public string Uri { get => throw null; set => throw null; }
                public bool UseUTF16Encoding { get => throw null; set => throw null; }
                public int Version { get => throw null; set => throw null; }
                public string VfsName { get => throw null; set => throw null; }
                public int WaitTimeout { get => throw null; set => throw null; }
                public string ZipVfsVersion { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteContext` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteContext : System.Data.SQLite.ISQLiteNativeHandle
            {
                public System.IntPtr NativeHandle { get => throw null; }
                public void SetBlob(System.Byte[] value) => throw null;
                public void SetDouble(double value) => throw null;
                public void SetError(string value) => throw null;
                public void SetErrorCode(System.Data.SQLite.SQLiteErrorCode value) => throw null;
                public void SetErrorNoMemory() => throw null;
                public void SetErrorTooBig() => throw null;
                public void SetInt(int value) => throw null;
                public void SetInt64(System.Int64 value) => throw null;
                public void SetNull() => throw null;
                public void SetString(string value) => throw null;
                public void SetValue(System.Data.SQLite.SQLiteValue value) => throw null;
                public void SetZeroBlob(int value) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteConvert` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public abstract class SQLiteConvert
            {
                public static string GetStringOrNull(object value) => throw null;
                internal SQLiteConvert(System.Data.SQLite.SQLiteDateFormats fmt, System.DateTimeKind kind, string fmtString) => throw null;
                public static string[] Split(string source, System.Char separator) => throw null;
                public static bool ToBoolean(object source) => throw null;
                public static bool ToBoolean(string source) => throw null;
                public System.DateTime ToDateTime(double julianDay) => throw null;
                public static System.DateTime ToDateTime(double julianDay, System.DateTimeKind kind) => throw null;
                public System.DateTime ToDateTime(string dateText) => throw null;
                public static System.DateTime ToDateTime(string dateText, System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString) => throw null;
                public static double ToJulianDay(System.DateTime value) => throw null;
                public string ToString(System.DateTime dateValue) => throw null;
                public static string ToString(System.DateTime dateValue, System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString) => throw null;
                public virtual string ToString(System.IntPtr nativestring, int nativestringlen) => throw null;
                public static string ToStringWithProvider(object obj, System.IFormatProvider provider) => throw null;
                public System.Byte[] ToUTF8(System.DateTime dateTimeValue) => throw null;
                public static System.Byte[] ToUTF8(string sourceText) => throw null;
                public static System.Int64 ToUnixEpoch(System.DateTime value) => throw null;
                public static string UTF8ToString(System.IntPtr nativestring, int nativestringlen) => throw null;
                protected static System.DateTime UnixEpoch;
            }

            // Generated from `System.Data.SQLite.SQLiteDataAdapter` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteDataAdapter : System.Data.Common.DbDataAdapter
            {
                public System.Data.SQLite.SQLiteCommand DeleteCommand { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.SQLite.SQLiteCommand InsertCommand { get => throw null; set => throw null; }
                protected override void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected override void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public event System.EventHandler<System.Data.Common.RowUpdatedEventArgs> RowUpdated;
                public event System.EventHandler<System.Data.Common.RowUpdatingEventArgs> RowUpdating;
                public SQLiteDataAdapter() => throw null;
                public SQLiteDataAdapter(System.Data.SQLite.SQLiteCommand cmd) => throw null;
                public SQLiteDataAdapter(string commandText, System.Data.SQLite.SQLiteConnection connection) => throw null;
                public SQLiteDataAdapter(string commandText, string connectionString) => throw null;
                public SQLiteDataAdapter(string commandText, string connectionString, bool parseViaFramework) => throw null;
                public System.Data.SQLite.SQLiteCommand SelectCommand { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteCommand UpdateCommand { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteDataReader` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteDataReader : System.Data.Common.DbDataReader
            {
                public override void Close() => throw null;
                public override int Depth { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override int FieldCount { get => throw null; }
                public System.Data.SQLite.SQLiteBlob GetBlob(int i, bool readOnly) => throw null;
                public override bool GetBoolean(int i) => throw null;
                public override System.Byte GetByte(int i) => throw null;
                public override System.Int64 GetBytes(int i, System.Int64 fieldOffset, System.Byte[] buffer, int bufferoffset, int length) => throw null;
                public override System.Char GetChar(int i) => throw null;
                public override System.Int64 GetChars(int i, System.Int64 fieldoffset, System.Char[] buffer, int bufferoffset, int length) => throw null;
                public override string GetDataTypeName(int i) => throw null;
                public string GetDatabaseName(int i) => throw null;
                public override System.DateTime GetDateTime(int i) => throw null;
                public override System.Decimal GetDecimal(int i) => throw null;
                public override double GetDouble(int i) => throw null;
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                public System.Data.SQLite.TypeAffinity GetFieldAffinity(int i) => throw null;
                public override System.Type GetFieldType(int i) => throw null;
                public override float GetFloat(int i) => throw null;
                public override System.Guid GetGuid(int i) => throw null;
                public override System.Int16 GetInt16(int i) => throw null;
                public override int GetInt32(int i) => throw null;
                public override System.Int64 GetInt64(int i) => throw null;
                public override string GetName(int i) => throw null;
                public override int GetOrdinal(string name) => throw null;
                public string GetOriginalName(int i) => throw null;
                public override System.Data.DataTable GetSchemaTable() => throw null;
                public override string GetString(int i) => throw null;
                public string GetTableName(int i) => throw null;
                public override object GetValue(int i) => throw null;
                public System.Collections.Specialized.NameValueCollection GetValues() => throw null;
                public override int GetValues(object[] values) => throw null;
                public override bool HasRows { get => throw null; }
                public override bool IsClosed { get => throw null; }
                public override bool IsDBNull(int i) => throw null;
                public override object this[int i] { get => throw null; }
                public override object this[string name] { get => throw null; }
                public override bool NextResult() => throw null;
                public override bool Read() => throw null;
                public override int RecordsAffected { get => throw null; }
                public void RefreshFlags() => throw null;
                public int StepCount { get => throw null; }
                public override int VisibleFieldCount { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteDataReaderValue` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteDataReaderValue
            {
                public System.Data.SQLite.SQLiteBlob BlobValue;
                public bool? BooleanValue;
                public System.Byte? ByteValue;
                public System.Byte[] BytesValue;
                public System.Char? CharValue;
                public System.Char[] CharsValue;
                public System.DateTime? DateTimeValue;
                public System.Decimal? DecimalValue;
                public double? DoubleValue;
                public float? FloatValue;
                public System.Guid? GuidValue;
                public System.Int16? Int16Value;
                public int? Int32Value;
                public System.Int64? Int64Value;
                public SQLiteDataReaderValue() => throw null;
                public string StringValue;
                public object Value;
            }

            // Generated from `System.Data.SQLite.SQLiteDateFormats` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteDateFormats
            {
                CurrentCulture,
                Default,
                ISO8601,
                InvariantCulture,
                JulianDay,
                Ticks,
                UnixEpoch,
            }

            // Generated from `System.Data.SQLite.SQLiteDelegateFunction` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteDelegateFunction : System.Data.SQLite.SQLiteFunction
            {
                public virtual System.Delegate Callback1 { get => throw null; set => throw null; }
                public virtual System.Delegate Callback2 { get => throw null; set => throw null; }
                public override int Compare(string param1, string param2) => throw null;
                public override object Final(object contextData) => throw null;
                protected virtual object[] GetCompareArgs(string param1, string param2, bool earlyBound) => throw null;
                protected virtual object[] GetFinalArgs(object contextData, bool earlyBound) => throw null;
                protected virtual object[] GetInvokeArgs(object[] args, bool earlyBound) => throw null;
                protected virtual object[] GetStepArgs(object[] args, int stepNumber, object contextData, bool earlyBound) => throw null;
                public override object Invoke(object[] args) => throw null;
                public SQLiteDelegateFunction() => throw null;
                public SQLiteDelegateFunction(System.Delegate callback1, System.Delegate callback2) => throw null;
                public override void Step(object[] args, int stepNumber, ref object contextData) => throw null;
                protected virtual void UpdateStepArgs(object[] args, ref object contextData, bool earlyBound) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteErrorCode` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteErrorCode
            {
                Abort,
                Abort_Rollback,
                Auth,
                Auth_User,
                Busy,
                Busy_Recovery,
                Busy_Snapshot,
                Busy_Timeout,
                CantOpen,
                CantOpen_ConvPath,
                CantOpen_DirtyWal,
                CantOpen_FullPath,
                CantOpen_IsDir,
                CantOpen_NoTempDir,
                CantOpen_SymLink,
                Constraint,
                Constraint_Check,
                Constraint_CommitHook,
                Constraint_DataType,
                Constraint_ForeignKey,
                Constraint_Function,
                Constraint_NotNull,
                Constraint_Pinned,
                Constraint_PrimaryKey,
                Constraint_RowId,
                Constraint_Trigger,
                Constraint_Unique,
                Constraint_Vtab,
                Corrupt,
                Corrupt_Index,
                Corrupt_Sequence,
                Corrupt_Vtab,
                Done,
                Empty,
                Error,
                Error_Missing_CollSeq,
                Error_Retry,
                Error_Snapshot,
                Format,
                Full,
                Internal,
                Interrupt,
                IoErr,
                IoErr_Access,
                IoErr_Auth,
                IoErr_Begin_Atomic,
                IoErr_Blocked,
                IoErr_CheckReservedLock,
                IoErr_Close,
                IoErr_Commit_Atomic,
                IoErr_ConvPath,
                IoErr_CorruptFs,
                IoErr_Data,
                IoErr_Delete,
                IoErr_Delete_NoEnt,
                IoErr_Dir_Close,
                IoErr_Dir_Fsync,
                IoErr_Fstat,
                IoErr_Fsync,
                IoErr_GetTempPath,
                IoErr_Lock,
                IoErr_Mmap,
                IoErr_NoMem,
                IoErr_RdLock,
                IoErr_Read,
                IoErr_Rollback_Atomic,
                IoErr_Seek,
                IoErr_ShmLock,
                IoErr_ShmMap,
                IoErr_ShmOpen,
                IoErr_ShmSize,
                IoErr_Short_Read,
                IoErr_Truncate,
                IoErr_Unlock,
                IoErr_VNode,
                IoErr_Write,
                Locked,
                Locked_SharedCache,
                Locked_Vtab,
                Mismatch,
                Misuse,
                Misuse_No_License,
                NoLfs,
                NoMem,
                NonExtendedMask,
                NotADb,
                NotFound,
                Notice,
                Notice_Recover_Rollback,
                Notice_Recover_Wal,
                Ok,
                Ok_Load_Permanently,
                Ok_SymLink,
                Perm,
                Protocol,
                Range,
                ReadOnly,
                ReadOnly_CantInit,
                ReadOnly_CantLock,
                ReadOnly_DbMoved,
                ReadOnly_Directory,
                ReadOnly_Recovery,
                ReadOnly_Rollback,
                Row,
                Schema,
                TooBig,
                Unknown,
                Warning,
                Warning_AutoIndex,
            }

            // Generated from `System.Data.SQLite.SQLiteException` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteException : System.Data.Common.DbException, System.Runtime.Serialization.ISerializable
            {
                public override int ErrorCode { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Data.SQLite.SQLiteErrorCode ResultCode { get => throw null; }
                public SQLiteException() => throw null;
                public SQLiteException(System.Data.SQLite.SQLiteErrorCode errorCode, string message) => throw null;
                public SQLiteException(string message) => throw null;
                public SQLiteException(string message, System.Exception innerException) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteExecuteType` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteExecuteType
            {
                Default,
                NonQuery,
                None,
                Reader,
                Scalar,
            }

            // Generated from `System.Data.SQLite.SQLiteExtra` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public static class SQLiteExtra
            {
                public static int Configure(string argument) => throw null;
                public static int Verify(string argument) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteFactory` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteFactory : System.Data.Common.DbProviderFactory, System.IDisposable, System.IServiceProvider
            {
                public override System.Data.Common.DbCommand CreateCommand() => throw null;
                public override System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public override System.Data.Common.DbConnection CreateConnection() => throw null;
                public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public override System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public override System.Data.Common.DbParameter CreateParameter() => throw null;
                public void Dispose() => throw null;
                object System.IServiceProvider.GetService(System.Type serviceType) => throw null;
                public static System.Data.SQLite.SQLiteFactory Instance;
                public event System.Data.SQLite.SQLiteLogEventHandler Log;
                public SQLiteFactory() => throw null;
                // ERR: Stub generator didn't handle member: ~SQLiteFactory
            }

            // Generated from `System.Data.SQLite.SQLiteFinalDelegate` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate object SQLiteFinalDelegate(string param0, object contextData);

            // Generated from `System.Data.SQLite.SQLiteFunction` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public abstract class SQLiteFunction : System.IDisposable
            {
                public virtual int Compare(string param1, string param2) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual object Final(object contextData) => throw null;
                public virtual object Invoke(object[] args) => throw null;
                public static void RegisterFunction(System.Type typ) => throw null;
                public static void RegisterFunction(string name, int argumentCount, System.Data.SQLite.FunctionType functionType, System.Type instanceType, System.Delegate callback1, System.Delegate callback2) => throw null;
                public System.Data.SQLite.SQLiteConvert SQLiteConvert { get => throw null; }
                protected SQLiteFunction() => throw null;
                protected SQLiteFunction(System.Data.SQLite.SQLiteDateFormats format, System.DateTimeKind kind, string formatString, bool utf16) => throw null;
                public virtual void Step(object[] args, int stepNumber, ref object contextData) => throw null;
                // ERR: Stub generator didn't handle member: ~SQLiteFunction
            }

            // Generated from `System.Data.SQLite.SQLiteFunctionAttribute` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteFunctionAttribute : System.Attribute
            {
                public int Arguments { get => throw null; set => throw null; }
                public System.Data.SQLite.FunctionType FuncType { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public SQLiteFunctionAttribute() => throw null;
                public SQLiteFunctionAttribute(string name, int argumentCount, System.Data.SQLite.FunctionType functionType) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteFunctionEx` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteFunctionEx : System.Data.SQLite.SQLiteFunction
            {
                protected override void Dispose(bool disposing) => throw null;
                protected System.Data.SQLite.CollationSequence GetCollationSequence() => throw null;
                public SQLiteFunctionEx() => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteIndex` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndex
            {
                public System.Data.SQLite.SQLiteIndexInputs Inputs { get => throw null; }
                public System.Data.SQLite.SQLiteIndexOutputs Outputs { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteIndexConstraint` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndexConstraint
            {
                public int iColumn;
                public int iTermOffset;
                public System.Data.SQLite.SQLiteIndexConstraintOp op;
                public System.Byte usable;
            }

            // Generated from `System.Data.SQLite.SQLiteIndexConstraintOp` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteIndexConstraintOp
            {
                EqualTo,
                Glob,
                GreaterThan,
                GreaterThanOrEqualTo,
                Is,
                IsNot,
                IsNotNull,
                IsNull,
                LessThan,
                LessThanOrEqualTo,
                Like,
                Match,
                NotEqualTo,
                Regexp,
            }

            // Generated from `System.Data.SQLite.SQLiteIndexConstraintUsage` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndexConstraintUsage
            {
                public int argvIndex;
                public System.Byte omit;
            }

            // Generated from `System.Data.SQLite.SQLiteIndexFlags` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            [System.Flags]
            public enum SQLiteIndexFlags
            {
                None,
                ScanUnique,
            }

            // Generated from `System.Data.SQLite.SQLiteIndexInputs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndexInputs
            {
                public System.Data.SQLite.SQLiteIndexConstraint[] Constraints { get => throw null; }
                public System.Data.SQLite.SQLiteIndexOrderBy[] OrderBys { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteIndexOrderBy` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndexOrderBy
            {
                public System.Byte desc;
                public int iColumn;
            }

            // Generated from `System.Data.SQLite.SQLiteIndexOutputs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteIndexOutputs
            {
                public bool CanUseColumnsUsed() => throw null;
                public bool CanUseEstimatedRows() => throw null;
                public bool CanUseIndexFlags() => throw null;
                public System.Int64? ColumnsUsed { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteIndexConstraintUsage[] ConstraintUsages { get => throw null; }
                public double? EstimatedCost { get => throw null; set => throw null; }
                public System.Int64? EstimatedRows { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteIndexFlags? IndexFlags { get => throw null; set => throw null; }
                public int IndexNumber { get => throw null; set => throw null; }
                public string IndexString { get => throw null; set => throw null; }
                public int NeedToFreeIndexString { get => throw null; set => throw null; }
                public int OrderByConsumed { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteInvokeDelegate` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate object SQLiteInvokeDelegate(string param0, object[] args);

            // Generated from `System.Data.SQLite.SQLiteJournalModeEnum` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteJournalModeEnum
            {
                Default,
                Delete,
                Memory,
                Off,
                Persist,
                Truncate,
                Wal,
            }

            // Generated from `System.Data.SQLite.SQLiteLimitOpsEnum` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteLimitOpsEnum
            {
                SQLITE_LIMIT_ATTACHED,
                SQLITE_LIMIT_COLUMN,
                SQLITE_LIMIT_COMPOUND_SELECT,
                SQLITE_LIMIT_EXPR_DEPTH,
                SQLITE_LIMIT_FUNCTION_ARG,
                SQLITE_LIMIT_LENGTH,
                SQLITE_LIMIT_LIKE_PATTERN_LENGTH,
                SQLITE_LIMIT_NONE,
                SQLITE_LIMIT_SQL_LENGTH,
                SQLITE_LIMIT_TRIGGER_DEPTH,
                SQLITE_LIMIT_VARIABLE_NUMBER,
                SQLITE_LIMIT_VDBE_OP,
                SQLITE_LIMIT_WORKER_THREADS,
            }

            // Generated from `System.Data.SQLite.SQLiteLog` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public static class SQLiteLog
            {
                public static void AddDefaultHandler() => throw null;
                public static bool Enabled { get => throw null; set => throw null; }
                public static void Initialize() => throw null;
                public static event System.Data.SQLite.SQLiteLogEventHandler Log;
                public static void LogMessage(System.Data.SQLite.SQLiteErrorCode errorCode, string message) => throw null;
                public static void LogMessage(int errorCode, string message) => throw null;
                public static void LogMessage(string message) => throw null;
                public static void RemoveDefaultHandler() => throw null;
                public static void Uninitialize() => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteLogEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteLogEventHandler(object sender, System.Data.SQLite.LogEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteMetaDataCollectionNames` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public static class SQLiteMetaDataCollectionNames
            {
                public static string Catalogs;
                public static string Columns;
                public static string ForeignKeys;
                public static string IndexColumns;
                public static string Indexes;
                public static string Tables;
                public static string Triggers;
                public static string ViewColumns;
                public static string Views;
            }

            // Generated from `System.Data.SQLite.SQLiteModule` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public abstract class SQLiteModule : System.Data.SQLite.ISQLiteManagedModule, System.IDisposable
            {
                protected virtual System.IntPtr AllocateCursor() => throw null;
                protected virtual System.IntPtr AllocateTable() => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index);
                public abstract System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index);
                public abstract System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                public abstract System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error);
                protected virtual System.Data.SQLite.ISQLiteNativeModule CreateNativeModuleImpl() => throw null;
                protected virtual System.Data.SQLite.SQLiteVirtualTableCursor CursorFromIntPtr(System.IntPtr pVtab, System.IntPtr pCursor) => throw null;
                protected virtual System.IntPtr CursorToIntPtr(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode DeclareFunction(System.Data.SQLite.SQLiteConnection connection, int argumentCount, string name, ref string error) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode DeclareTable(System.Data.SQLite.SQLiteConnection connection, string sql, ref string error) => throw null;
                public virtual bool Declared { get => throw null; set => throw null; }
                public abstract System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table);
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public abstract bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values);
                public abstract bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref System.IntPtr pClientData);
                protected virtual void FreeCursor(System.IntPtr pCursor) => throw null;
                protected virtual void FreeTable(System.IntPtr pVtab) => throw null;
                protected virtual string GetFunctionKey(int argumentCount, string name, System.Data.SQLite.SQLiteFunction function) => throw null;
                protected virtual System.Data.SQLite.ISQLiteNativeModule GetNativeModuleImpl() => throw null;
                public virtual bool LogErrors { get => throw null; set => throw null; }
                protected virtual bool LogErrorsNoThrow { get => throw null; set => throw null; }
                public virtual bool LogExceptions { get => throw null; set => throw null; }
                protected virtual bool LogExceptionsNoThrow { get => throw null; set => throw null; }
                public virtual string Name { get => throw null; }
                public abstract System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor);
                public abstract System.Data.SQLite.SQLiteErrorCode Release(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                public abstract System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName);
                public abstract System.Data.SQLite.SQLiteErrorCode Rollback(System.Data.SQLite.SQLiteVirtualTable table);
                public abstract System.Data.SQLite.SQLiteErrorCode RollbackTo(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                public abstract System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref System.Int64 rowId);
                public SQLiteModule(string name) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint);
                protected virtual bool SetCursorError(System.Data.SQLite.SQLiteVirtualTableCursor cursor, string error) => throw null;
                protected virtual bool SetEstimatedCost(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetEstimatedCost(System.Data.SQLite.SQLiteIndex index, double? estimatedCost) => throw null;
                protected virtual bool SetEstimatedRows(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetEstimatedRows(System.Data.SQLite.SQLiteIndex index, System.Int64? estimatedRows) => throw null;
                protected virtual bool SetIndexFlags(System.Data.SQLite.SQLiteIndex index) => throw null;
                protected virtual bool SetIndexFlags(System.Data.SQLite.SQLiteIndex index, System.Data.SQLite.SQLiteIndexFlags? indexFlags) => throw null;
                protected virtual bool SetTableError(System.IntPtr pVtab, string error) => throw null;
                protected virtual bool SetTableError(System.Data.SQLite.SQLiteVirtualTable table, string error) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table);
                protected virtual System.IntPtr TableFromCursor(System.IntPtr pCursor) => throw null;
                protected virtual System.Data.SQLite.SQLiteVirtualTable TableFromIntPtr(System.IntPtr pVtab) => throw null;
                protected virtual System.IntPtr TableToIntPtr(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public abstract System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref System.Int64 rowId);
                protected virtual void ZeroTable(System.IntPtr pVtab) => throw null;
                // ERR: Stub generator didn't handle member: ~SQLiteModule
            }

            // Generated from `System.Data.SQLite.SQLiteModuleCommon` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteModuleCommon : System.Data.SQLite.SQLiteModuleNoop
            {
                protected virtual System.Data.SQLite.SQLiteErrorCode CursorTypeMismatchError(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Type type) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual System.Int64 GetRowIdFromObject(System.Data.SQLite.SQLiteVirtualTableCursor cursor, object value) => throw null;
                protected virtual string GetSqlForDeclareTable() => throw null;
                protected virtual string GetStringFromObject(System.Data.SQLite.SQLiteVirtualTableCursor cursor, object value) => throw null;
                protected virtual System.Int64 MakeRowId(int rowIndex, int hashCode) => throw null;
                public SQLiteModuleCommon(string name) : base(default(string)) => throw null;
                public SQLiteModuleCommon(string name, bool objectIdentity) : base(default(string)) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteModuleEnumerable` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteModuleEnumerable : System.Data.SQLite.SQLiteModuleCommon
            {
                public override System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                protected virtual System.Data.SQLite.SQLiteErrorCode CursorEndOfEnumeratorError(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Next(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Rename(System.Data.SQLite.SQLiteVirtualTable table, string newName) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref System.Int64 rowId) => throw null;
                public SQLiteModuleEnumerable(string name, System.Collections.IEnumerable enumerable) : base(default(string)) => throw null;
                public SQLiteModuleEnumerable(string name, System.Collections.IEnumerable enumerable, bool objectIdentity) : base(default(string)) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref System.Int64 rowId) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteModuleNoop` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteModuleNoop : System.Data.SQLite.SQLiteModule
            {
                public override System.Data.SQLite.SQLiteErrorCode Begin(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode BestIndex(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteIndex index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Close(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Commit(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Connect(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Create(System.Data.SQLite.SQLiteConnection connection, System.IntPtr pClientData, string[] arguments, ref System.Data.SQLite.SQLiteVirtualTable table, ref string error) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Destroy(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Disconnect(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override bool Eof(System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Filter(System.Data.SQLite.SQLiteVirtualTableCursor cursor, int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public override bool FindFunction(System.Data.SQLite.SQLiteVirtualTable table, int argumentCount, string name, ref System.Data.SQLite.SQLiteFunction function, ref System.IntPtr pClientData) => throw null;
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
                public override System.Data.SQLite.SQLiteErrorCode RowId(System.Data.SQLite.SQLiteVirtualTableCursor cursor, ref System.Int64 rowId) => throw null;
                public SQLiteModuleNoop(string name) : base(default(string)) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Savepoint(System.Data.SQLite.SQLiteVirtualTable table, int savepoint) => throw null;
                protected virtual bool SetMethodResultCode(string methodName, System.Data.SQLite.SQLiteErrorCode resultCode) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Sync(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public override System.Data.SQLite.SQLiteErrorCode Update(System.Data.SQLite.SQLiteVirtualTable table, System.Data.SQLite.SQLiteValue[] values, ref System.Int64 rowId) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteParameter` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteParameter : System.Data.Common.DbParameter, System.ICloneable
            {
                public object Clone() => throw null;
                public System.Data.IDbCommand Command { get => throw null; set => throw null; }
                public override System.Data.DbType DbType { get => throw null; set => throw null; }
                public override System.Data.ParameterDirection Direction { get => throw null; set => throw null; }
                public override bool IsNullable { get => throw null; set => throw null; }
                public override string ParameterName { get => throw null; set => throw null; }
                public override void ResetDbType() => throw null;
                public SQLiteParameter() => throw null;
                public SQLiteParameter(System.Data.DbType dbType) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public SQLiteParameter(System.Data.DbType parameterType, int parameterSize, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, object value) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, string sourceColumn) => throw null;
                public SQLiteParameter(System.Data.DbType dbType, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(string parameterName) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, System.Data.ParameterDirection direction, bool isNullable, System.Byte precision, System.Byte scale, string sourceColumn, System.Data.DataRowVersion rowVersion, object value) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, System.Data.ParameterDirection direction, System.Byte precision, System.Byte scale, string sourceColumn, System.Data.DataRowVersion rowVersion, bool sourceColumnNullMapping, object value) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType, string sourceColumn) => throw null;
                public SQLiteParameter(string parameterName, System.Data.DbType dbType, string sourceColumn, System.Data.DataRowVersion rowVersion) => throw null;
                public SQLiteParameter(string parameterName, object value) => throw null;
                public override int Size { get => throw null; set => throw null; }
                public override string SourceColumn { get => throw null; set => throw null; }
                public override bool SourceColumnNullMapping { get => throw null; set => throw null; }
                public override System.Data.DataRowVersion SourceVersion { get => throw null; set => throw null; }
                public string TypeName { get => throw null; set => throw null; }
                public override object Value { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteParameterCollection` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteParameterCollection : System.Data.Common.DbParameterCollection
            {
                public int Add(System.Data.SQLite.SQLiteParameter parameter) => throw null;
                public override int Add(object value) => throw null;
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType) => throw null;
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType, int parameterSize) => throw null;
                public System.Data.SQLite.SQLiteParameter Add(string parameterName, System.Data.DbType parameterType, int parameterSize, string sourceColumn) => throw null;
                public override void AddRange(System.Array values) => throw null;
                public void AddRange(System.Data.SQLite.SQLiteParameter[] values) => throw null;
                public System.Data.SQLite.SQLiteParameter AddWithValue(string parameterName, object value) => throw null;
                public override void Clear() => throw null;
                public override bool Contains(object value) => throw null;
                public override bool Contains(string parameterName) => throw null;
                public override void CopyTo(System.Array array, int index) => throw null;
                public override int Count { get => throw null; }
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                protected override System.Data.Common.DbParameter GetParameter(int index) => throw null;
                protected override System.Data.Common.DbParameter GetParameter(string parameterName) => throw null;
                public override int IndexOf(object value) => throw null;
                public override int IndexOf(string parameterName) => throw null;
                public override void Insert(int index, object value) => throw null;
                public override bool IsFixedSize { get => throw null; }
                public override bool IsReadOnly { get => throw null; }
                public override bool IsSynchronized { get => throw null; }
                public System.Data.SQLite.SQLiteParameter this[int index] { get => throw null; set => throw null; }
                public System.Data.SQLite.SQLiteParameter this[string parameterName] { get => throw null; set => throw null; }
                public override void Remove(object value) => throw null;
                public override void RemoveAt(int index) => throw null;
                public override void RemoveAt(string parameterName) => throw null;
                protected override void SetParameter(int index, System.Data.Common.DbParameter value) => throw null;
                protected override void SetParameter(string parameterName, System.Data.Common.DbParameter value) => throw null;
                public override object SyncRoot { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteProgressEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteProgressEventHandler(object sender, System.Data.SQLite.ProgressEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteProgressReturnCode` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SQLiteProgressReturnCode
            {
                Continue,
                Interrupt,
            }

            // Generated from `System.Data.SQLite.SQLiteReadArrayEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteReadArrayEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public int BufferOffset { get => throw null; set => throw null; }
                public System.Byte[] ByteBuffer { get => throw null; }
                public System.Char[] CharBuffer { get => throw null; }
                public System.Int64 DataOffset { get => throw null; set => throw null; }
                public int Length { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteReadBlobEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteReadBlobEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public bool ReadOnly { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteReadEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public abstract class SQLiteReadEventArgs : System.EventArgs
            {
                protected SQLiteReadEventArgs() => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteReadValueCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteReadValueCallback(System.Data.SQLite.SQLiteConvert convert, System.Data.SQLite.SQLiteDataReader dataReader, System.Data.SQLite.SQLiteConnectionFlags flags, System.Data.SQLite.SQLiteReadEventArgs eventArgs, string typeName, int index, object userData, out bool complete);

            // Generated from `System.Data.SQLite.SQLiteReadValueEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteReadValueEventArgs : System.Data.SQLite.SQLiteReadEventArgs
            {
                public System.Data.SQLite.SQLiteReadEventArgs ExtraEventArgs { get => throw null; }
                public string MethodName { get => throw null; }
                public System.Data.SQLite.SQLiteDataReaderValue Value { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteStepDelegate` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteStepDelegate(string param0, object[] args, int stepNumber, ref object contextData);

            // Generated from `System.Data.SQLite.SQLiteTraceEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteTraceEventHandler(object sender, System.Data.SQLite.TraceEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteTransaction` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteTransaction : System.Data.SQLite.SQLiteTransactionBase
            {
                protected override void Begin(bool deferredLock) => throw null;
                public override void Commit() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void IssueRollback(bool throwError) => throw null;
                internal SQLiteTransaction(System.Data.SQLite.SQLiteConnection connection, bool deferredLock) : base(default(System.Data.SQLite.SQLiteConnection), default(bool)) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteTransaction2` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteTransaction2 : System.Data.SQLite.SQLiteTransaction
            {
                protected override void Begin(bool deferredLock) => throw null;
                public override void Commit() => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override void IssueRollback(bool throwError) => throw null;
                internal SQLiteTransaction2(System.Data.SQLite.SQLiteConnection connection, bool deferredLock) : base(default(System.Data.SQLite.SQLiteConnection), default(bool)) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteTransactionBase` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public abstract class SQLiteTransactionBase : System.Data.Common.DbTransaction
            {
                protected abstract void Begin(bool deferredLock);
                public System.Data.SQLite.SQLiteConnection Connection { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                protected abstract void IssueRollback(bool throwError);
                public override void Rollback() => throw null;
                internal SQLiteTransactionBase(System.Data.SQLite.SQLiteConnection connection, bool deferredLock) => throw null;
            }

            // Generated from `System.Data.SQLite.SQLiteTypeCallbacks` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteTypeCallbacks
            {
                public System.Data.SQLite.SQLiteBindValueCallback BindValueCallback { get => throw null; }
                public object BindValueUserData { get => throw null; }
                public static System.Data.SQLite.SQLiteTypeCallbacks Create(System.Data.SQLite.SQLiteBindValueCallback bindValueCallback, System.Data.SQLite.SQLiteReadValueCallback readValueCallback, object bindValueUserData, object readValueUserData) => throw null;
                public System.Data.SQLite.SQLiteReadValueCallback ReadValueCallback { get => throw null; }
                public object ReadValueUserData { get => throw null; }
                public string TypeName { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteUpdateEventHandler` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate void SQLiteUpdateEventHandler(object sender, System.Data.SQLite.UpdateEventArgs e);

            // Generated from `System.Data.SQLite.SQLiteValue` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteValue : System.Data.SQLite.ISQLiteNativeHandle
            {
                public System.Byte[] GetBlob() => throw null;
                public int GetBytes() => throw null;
                public double GetDouble() => throw null;
                public int GetInt() => throw null;
                public System.Int64 GetInt64() => throw null;
                public object GetObject() => throw null;
                public string GetString() => throw null;
                public System.Data.SQLite.TypeAffinity GetTypeAffinity() => throw null;
                public System.IntPtr NativeHandle { get => throw null; }
                public bool Persist() => throw null;
                public bool Persisted { get => throw null; }
                public object Value { get => throw null; }
            }

            // Generated from `System.Data.SQLite.SQLiteVirtualTable` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteVirtualTable : System.Data.SQLite.ISQLiteNativeHandle, System.IDisposable
            {
                public virtual string[] Arguments { get => throw null; }
                public virtual bool BestIndex(System.Data.SQLite.SQLiteIndex index) => throw null;
                public virtual string DatabaseName { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Data.SQLite.SQLiteIndex Index { get => throw null; }
                public virtual string ModuleName { get => throw null; }
                public virtual System.IntPtr NativeHandle { get => throw null; set => throw null; }
                public virtual bool Rename(string name) => throw null;
                public SQLiteVirtualTable(string[] arguments) => throw null;
                public virtual string TableName { get => throw null; }
                // ERR: Stub generator didn't handle member: ~SQLiteVirtualTable
            }

            // Generated from `System.Data.SQLite.SQLiteVirtualTableCursor` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteVirtualTableCursor : System.Data.SQLite.ISQLiteNativeHandle, System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual void Filter(int indexNumber, string indexString, System.Data.SQLite.SQLiteValue[] values) => throw null;
                public virtual int GetRowIndex() => throw null;
                public virtual int IndexNumber { get => throw null; }
                public virtual string IndexString { get => throw null; }
                protected static int InvalidRowIndex;
                public virtual System.IntPtr NativeHandle { get => throw null; set => throw null; }
                public virtual void NextRowIndex() => throw null;
                public SQLiteVirtualTableCursor(System.Data.SQLite.SQLiteVirtualTable table) => throw null;
                public virtual System.Data.SQLite.SQLiteVirtualTable Table { get => throw null; }
                protected virtual int TryPersistValues(System.Data.SQLite.SQLiteValue[] values) => throw null;
                public virtual System.Data.SQLite.SQLiteValue[] Values { get => throw null; }
                // ERR: Stub generator didn't handle member: ~SQLiteVirtualTableCursor
            }

            // Generated from `System.Data.SQLite.SQLiteVirtualTableCursorEnumerator` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class SQLiteVirtualTableCursorEnumerator : System.Data.SQLite.SQLiteVirtualTableCursor, System.Collections.IEnumerator
            {
                public virtual void CheckClosed() => throw null;
                public virtual void Close() => throw null;
                public virtual object Current { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public virtual bool EndOfEnumerator { get => throw null; }
                public virtual bool IsOpen { get => throw null; }
                public virtual bool MoveNext() => throw null;
                public virtual void Reset() => throw null;
                public SQLiteVirtualTableCursorEnumerator(System.Data.SQLite.SQLiteVirtualTable table, System.Collections.IEnumerator enumerator) : base(default(System.Data.SQLite.SQLiteVirtualTable)) => throw null;
            }

            // Generated from `System.Data.SQLite.SessionConflictCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate System.Data.SQLite.SQLiteChangeSetConflictResult SessionConflictCallback(object clientData, System.Data.SQLite.SQLiteChangeSetConflictType type, System.Data.SQLite.ISQLiteChangeSetMetadataItem item);

            // Generated from `System.Data.SQLite.SessionTableFilterCallback` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public delegate bool SessionTableFilterCallback(object clientData, string name);

            // Generated from `System.Data.SQLite.SynchronizationModes` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum SynchronizationModes
            {
                Full,
                Normal,
                Off,
            }

            // Generated from `System.Data.SQLite.TraceEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class TraceEventArgs : System.EventArgs
            {
                public string Statement;
            }

            // Generated from `System.Data.SQLite.TypeAffinity` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum TypeAffinity
            {
                Blob,
                DateTime,
                Double,
                Int64,
                None,
                Null,
                Text,
                Uninitialized,
            }

            // Generated from `System.Data.SQLite.UpdateEventArgs` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public class UpdateEventArgs : System.EventArgs
            {
                public string Database;
                public System.Data.SQLite.UpdateEventType Event;
                public System.Int64 RowId;
                public string Table;
            }

            // Generated from `System.Data.SQLite.UpdateEventType` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
            public enum UpdateEventType
            {
                Delete,
                Insert,
                Update,
            }

            namespace Generic
            {
                // Generated from `System.Data.SQLite.Generic.SQLiteModuleEnumerable<>` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
                public class SQLiteModuleEnumerable<T> : System.Data.SQLite.SQLiteModuleEnumerable
                {
                    public override System.Data.SQLite.SQLiteErrorCode Column(System.Data.SQLite.SQLiteVirtualTableCursor cursor, System.Data.SQLite.SQLiteContext context, int index) => throw null;
                    protected override void Dispose(bool disposing) => throw null;
                    public override System.Data.SQLite.SQLiteErrorCode Open(System.Data.SQLite.SQLiteVirtualTable table, ref System.Data.SQLite.SQLiteVirtualTableCursor cursor) => throw null;
                    public SQLiteModuleEnumerable(string name, System.Collections.Generic.IEnumerable<T> enumerable) : base(default(string), default(System.Collections.IEnumerable)) => throw null;
                }

                // Generated from `System.Data.SQLite.Generic.SQLiteVirtualTableCursorEnumerator<>` in `System.Data.SQLite, Version=1.0.116.0, Culture=neutral, PublicKeyToken=db937bc2d44ff139`
                public class SQLiteVirtualTableCursorEnumerator<T> : System.Data.SQLite.SQLiteVirtualTableCursorEnumerator, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator, System.IDisposable
                {
                    public override void Close() => throw null;
                    T System.Collections.Generic.IEnumerator<T>.Current { get => throw null; }
                    protected override void Dispose(bool disposing) => throw null;
                    public SQLiteVirtualTableCursorEnumerator(System.Data.SQLite.SQLiteVirtualTable table, System.Collections.Generic.IEnumerator<T> enumerator) : base(default(System.Data.SQLite.SQLiteVirtualTable), default(System.Collections.IEnumerator)) => throw null;
                }

            }
        }
    }
}
