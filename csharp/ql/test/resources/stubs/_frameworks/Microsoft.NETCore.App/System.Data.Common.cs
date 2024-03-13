// This file contains auto-generated code.
// Generated from `System.Data.Common, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Data
    {
        public enum AcceptRejectRule
        {
            None = 0,
            Cascade = 1,
        }
        [System.Flags]
        public enum CommandBehavior
        {
            Default = 0,
            SingleResult = 1,
            SchemaOnly = 2,
            KeyInfo = 4,
            SingleRow = 8,
            SequentialAccess = 16,
            CloseConnection = 32,
        }
        public enum CommandType
        {
            Text = 1,
            StoredProcedure = 4,
            TableDirect = 512,
        }
        namespace Common
        {
            public enum CatalogLocation
            {
                Start = 1,
                End = 2,
            }
            public class DataAdapter : System.ComponentModel.Component, System.Data.IDataAdapter
            {
                public bool AcceptChangesDuringFill { get => throw null; set { } }
                public bool AcceptChangesDuringUpdate { get => throw null; set { } }
                protected virtual System.Data.Common.DataAdapter CloneInternals() => throw null;
                public bool ContinueUpdateOnError { get => throw null; set { } }
                protected virtual System.Data.Common.DataTableMappingCollection CreateTableMappings() => throw null;
                protected DataAdapter() => throw null;
                protected DataAdapter(System.Data.Common.DataAdapter from) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public virtual int Fill(System.Data.DataSet dataSet) => throw null;
                protected virtual int Fill(System.Data.DataSet dataSet, string srcTable, System.Data.IDataReader dataReader, int startRecord, int maxRecords) => throw null;
                protected virtual int Fill(System.Data.DataTable dataTable, System.Data.IDataReader dataReader) => throw null;
                protected virtual int Fill(System.Data.DataTable[] dataTables, System.Data.IDataReader dataReader, int startRecord, int maxRecords) => throw null;
                public event System.Data.FillErrorEventHandler FillError;
                public System.Data.LoadOption FillLoadOption { get => throw null; set { } }
                public virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, string srcTable, System.Data.IDataReader dataReader) => throw null;
                protected virtual System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType, System.Data.IDataReader dataReader) => throw null;
                public virtual System.Data.IDataParameter[] GetFillParameters() => throw null;
                protected bool HasTableMappings() => throw null;
                public System.Data.MissingMappingAction MissingMappingAction { get => throw null; set { } }
                public System.Data.MissingSchemaAction MissingSchemaAction { get => throw null; set { } }
                protected virtual void OnFillError(System.Data.FillErrorEventArgs value) => throw null;
                public void ResetFillLoadOption() => throw null;
                public virtual bool ReturnProviderSpecificTypes { get => throw null; set { } }
                public virtual bool ShouldSerializeAcceptChangesDuringFill() => throw null;
                public virtual bool ShouldSerializeFillLoadOption() => throw null;
                protected virtual bool ShouldSerializeTableMappings() => throw null;
                System.Data.ITableMappingCollection System.Data.IDataAdapter.TableMappings { get => throw null; }
                public System.Data.Common.DataTableMappingCollection TableMappings { get => throw null; }
                public virtual int Update(System.Data.DataSet dataSet) => throw null;
            }
            public sealed class DataColumnMapping : System.MarshalByRefObject, System.ICloneable, System.Data.IColumnMapping
            {
                object System.ICloneable.Clone() => throw null;
                public DataColumnMapping() => throw null;
                public DataColumnMapping(string sourceColumn, string dataSetColumn) => throw null;
                public string DataSetColumn { get => throw null; set { } }
                public System.Data.DataColumn GetDataColumnBySchemaAction(System.Data.DataTable dataTable, System.Type dataType, System.Data.MissingSchemaAction schemaAction) => throw null;
                public static System.Data.DataColumn GetDataColumnBySchemaAction(string sourceColumn, string dataSetColumn, System.Data.DataTable dataTable, System.Type dataType, System.Data.MissingSchemaAction schemaAction) => throw null;
                public string SourceColumn { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public sealed class DataColumnMappingCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Data.IColumnMappingCollection, System.Collections.IEnumerable, System.Collections.IList
            {
                public int Add(object value) => throw null;
                public System.Data.Common.DataColumnMapping Add(string sourceColumn, string dataSetColumn) => throw null;
                System.Data.IColumnMapping System.Data.IColumnMappingCollection.Add(string sourceColumnName, string dataSetColumnName) => throw null;
                public void AddRange(System.Array values) => throw null;
                public void AddRange(System.Data.Common.DataColumnMapping[] values) => throw null;
                public void Clear() => throw null;
                public bool Contains(object value) => throw null;
                public bool Contains(string value) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Data.Common.DataColumnMapping[] array, int index) => throw null;
                public int Count { get => throw null; }
                public DataColumnMappingCollection() => throw null;
                public System.Data.Common.DataColumnMapping GetByDataSetColumn(string value) => throw null;
                System.Data.IColumnMapping System.Data.IColumnMappingCollection.GetByDataSetColumn(string dataSetColumnName) => throw null;
                public static System.Data.Common.DataColumnMapping GetColumnMappingBySchemaAction(System.Data.Common.DataColumnMappingCollection columnMappings, string sourceColumn, System.Data.MissingMappingAction mappingAction) => throw null;
                public static System.Data.DataColumn GetDataColumn(System.Data.Common.DataColumnMappingCollection columnMappings, string sourceColumn, System.Type dataType, System.Data.DataTable dataTable, System.Data.MissingMappingAction mappingAction, System.Data.MissingSchemaAction schemaAction) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public int IndexOf(object value) => throw null;
                public int IndexOf(string sourceColumn) => throw null;
                public int IndexOfDataSetColumn(string dataSetColumn) => throw null;
                public void Insert(int index, System.Data.Common.DataColumnMapping value) => throw null;
                public void Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                object System.Data.IColumnMappingCollection.this[string index] { get => throw null; set { } }
                public void Remove(System.Data.Common.DataColumnMapping value) => throw null;
                public void Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                public void RemoveAt(string sourceColumn) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public System.Data.Common.DataColumnMapping this[int index] { get => throw null; set { } }
                public System.Data.Common.DataColumnMapping this[string sourceColumn] { get => throw null; set { } }
            }
            public sealed class DataTableMapping : System.MarshalByRefObject, System.ICloneable, System.Data.ITableMapping
            {
                object System.ICloneable.Clone() => throw null;
                public System.Data.Common.DataColumnMappingCollection ColumnMappings { get => throw null; }
                System.Data.IColumnMappingCollection System.Data.ITableMapping.ColumnMappings { get => throw null; }
                public DataTableMapping() => throw null;
                public DataTableMapping(string sourceTable, string dataSetTable) => throw null;
                public DataTableMapping(string sourceTable, string dataSetTable, System.Data.Common.DataColumnMapping[] columnMappings) => throw null;
                public string DataSetTable { get => throw null; set { } }
                public System.Data.Common.DataColumnMapping GetColumnMappingBySchemaAction(string sourceColumn, System.Data.MissingMappingAction mappingAction) => throw null;
                public System.Data.DataColumn GetDataColumn(string sourceColumn, System.Type dataType, System.Data.DataTable dataTable, System.Data.MissingMappingAction mappingAction, System.Data.MissingSchemaAction schemaAction) => throw null;
                public System.Data.DataTable GetDataTableBySchemaAction(System.Data.DataSet dataSet, System.Data.MissingSchemaAction schemaAction) => throw null;
                public string SourceTable { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public sealed class DataTableMappingCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Data.ITableMappingCollection
            {
                public int Add(object value) => throw null;
                public System.Data.Common.DataTableMapping Add(string sourceTable, string dataSetTable) => throw null;
                System.Data.ITableMapping System.Data.ITableMappingCollection.Add(string sourceTableName, string dataSetTableName) => throw null;
                public void AddRange(System.Array values) => throw null;
                public void AddRange(System.Data.Common.DataTableMapping[] values) => throw null;
                public void Clear() => throw null;
                public bool Contains(object value) => throw null;
                public bool Contains(string value) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Data.Common.DataTableMapping[] array, int index) => throw null;
                public int Count { get => throw null; }
                public DataTableMappingCollection() => throw null;
                public System.Data.Common.DataTableMapping GetByDataSetTable(string dataSetTable) => throw null;
                System.Data.ITableMapping System.Data.ITableMappingCollection.GetByDataSetTable(string dataSetTableName) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public static System.Data.Common.DataTableMapping GetTableMappingBySchemaAction(System.Data.Common.DataTableMappingCollection tableMappings, string sourceTable, string dataSetTable, System.Data.MissingMappingAction mappingAction) => throw null;
                public int IndexOf(object value) => throw null;
                public int IndexOf(string sourceTable) => throw null;
                public int IndexOfDataSetTable(string dataSetTable) => throw null;
                public void Insert(int index, System.Data.Common.DataTableMapping value) => throw null;
                public void Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                object System.Data.ITableMappingCollection.this[string index] { get => throw null; set { } }
                public void Remove(System.Data.Common.DataTableMapping value) => throw null;
                public void Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                public void RemoveAt(string sourceTable) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public System.Data.Common.DataTableMapping this[int index] { get => throw null; set { } }
                public System.Data.Common.DataTableMapping this[string sourceTable] { get => throw null; set { } }
            }
            public abstract class DbBatch : System.IAsyncDisposable, System.IDisposable
            {
                public System.Data.Common.DbBatchCommandCollection BatchCommands { get => throw null; }
                public abstract void Cancel();
                public System.Data.Common.DbConnection Connection { get => throw null; set { } }
                public System.Data.Common.DbBatchCommand CreateBatchCommand() => throw null;
                protected abstract System.Data.Common.DbBatchCommand CreateDbBatchCommand();
                protected DbBatch() => throw null;
                protected abstract System.Data.Common.DbBatchCommandCollection DbBatchCommands { get; }
                protected abstract System.Data.Common.DbConnection DbConnection { get; set; }
                protected abstract System.Data.Common.DbTransaction DbTransaction { get; set; }
                public virtual void Dispose() => throw null;
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected abstract System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior);
                protected abstract System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken);
                public abstract int ExecuteNonQuery();
                public abstract System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public System.Data.Common.DbDataReader ExecuteReader(System.Data.CommandBehavior behavior = default(System.Data.CommandBehavior)) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract object ExecuteScalar();
                public abstract System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract void Prepare();
                public abstract System.Threading.Tasks.Task PrepareAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract int Timeout { get; set; }
                public System.Data.Common.DbTransaction Transaction { get => throw null; set { } }
            }
            public abstract class DbBatchCommand
            {
                public virtual bool CanCreateParameter { get => throw null; }
                public abstract string CommandText { get; set; }
                public abstract System.Data.CommandType CommandType { get; set; }
                public virtual System.Data.Common.DbParameter CreateParameter() => throw null;
                protected DbBatchCommand() => throw null;
                protected abstract System.Data.Common.DbParameterCollection DbParameterCollection { get; }
                public System.Data.Common.DbParameterCollection Parameters { get => throw null; }
                public abstract int RecordsAffected { get; }
            }
            public abstract class DbBatchCommandCollection : System.Collections.Generic.ICollection<System.Data.Common.DbBatchCommand>, System.Collections.Generic.IEnumerable<System.Data.Common.DbBatchCommand>, System.Collections.IEnumerable, System.Collections.Generic.IList<System.Data.Common.DbBatchCommand>
            {
                public abstract void Add(System.Data.Common.DbBatchCommand item);
                public abstract void Clear();
                public abstract bool Contains(System.Data.Common.DbBatchCommand item);
                public abstract void CopyTo(System.Data.Common.DbBatchCommand[] array, int arrayIndex);
                public abstract int Count { get; }
                protected DbBatchCommandCollection() => throw null;
                protected abstract System.Data.Common.DbBatchCommand GetBatchCommand(int index);
                public abstract System.Collections.Generic.IEnumerator<System.Data.Common.DbBatchCommand> GetEnumerator();
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public abstract int IndexOf(System.Data.Common.DbBatchCommand item);
                public abstract void Insert(int index, System.Data.Common.DbBatchCommand item);
                public abstract bool IsReadOnly { get; }
                public abstract bool Remove(System.Data.Common.DbBatchCommand item);
                public abstract void RemoveAt(int index);
                protected abstract void SetBatchCommand(int index, System.Data.Common.DbBatchCommand batchCommand);
                public System.Data.Common.DbBatchCommand this[int index] { get => throw null; set { } }
            }
            public abstract class DbColumn
            {
                public bool? AllowDBNull { get => throw null; set { } }
                public string BaseCatalogName { get => throw null; set { } }
                public string BaseColumnName { get => throw null; set { } }
                public string BaseSchemaName { get => throw null; set { } }
                public string BaseServerName { get => throw null; set { } }
                public string BaseTableName { get => throw null; set { } }
                public string ColumnName { get => throw null; set { } }
                public int? ColumnOrdinal { get => throw null; set { } }
                public int? ColumnSize { get => throw null; set { } }
                protected DbColumn() => throw null;
                public System.Type DataType { get => throw null; set { } }
                public string DataTypeName { get => throw null; set { } }
                public bool? IsAliased { get => throw null; set { } }
                public bool? IsAutoIncrement { get => throw null; set { } }
                public bool? IsExpression { get => throw null; set { } }
                public bool? IsHidden { get => throw null; set { } }
                public bool? IsIdentity { get => throw null; set { } }
                public bool? IsKey { get => throw null; set { } }
                public bool? IsLong { get => throw null; set { } }
                public bool? IsReadOnly { get => throw null; set { } }
                public bool? IsUnique { get => throw null; set { } }
                public int? NumericPrecision { get => throw null; set { } }
                public int? NumericScale { get => throw null; set { } }
                public virtual object this[string property] { get => throw null; }
                public string UdtAssemblyQualifiedName { get => throw null; set { } }
            }
            public abstract class DbCommand : System.ComponentModel.Component, System.IAsyncDisposable, System.Data.IDbCommand, System.IDisposable
            {
                public abstract void Cancel();
                public abstract string CommandText { get; set; }
                public abstract int CommandTimeout { get; set; }
                public abstract System.Data.CommandType CommandType { get; set; }
                public System.Data.Common.DbConnection Connection { get => throw null; set { } }
                System.Data.IDbConnection System.Data.IDbCommand.Connection { get => throw null; set { } }
                protected abstract System.Data.Common.DbParameter CreateDbParameter();
                public System.Data.Common.DbParameter CreateParameter() => throw null;
                System.Data.IDbDataParameter System.Data.IDbCommand.CreateParameter() => throw null;
                protected DbCommand() => throw null;
                protected abstract System.Data.Common.DbConnection DbConnection { get; set; }
                protected abstract System.Data.Common.DbParameterCollection DbParameterCollection { get; }
                protected abstract System.Data.Common.DbTransaction DbTransaction { get; set; }
                public abstract bool DesignTimeVisible { get; set; }
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected abstract System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior);
                protected virtual System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract int ExecuteNonQuery();
                public System.Threading.Tasks.Task<int> ExecuteNonQueryAsync() => throw null;
                public virtual System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.Common.DbDataReader ExecuteReader() => throw null;
                public System.Data.Common.DbDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                System.Data.IDataReader System.Data.IDbCommand.ExecuteReader() => throw null;
                System.Data.IDataReader System.Data.IDbCommand.ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync() => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract object ExecuteScalar();
                public System.Threading.Tasks.Task<object> ExecuteScalarAsync() => throw null;
                public virtual System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.Common.DbParameterCollection Parameters { get => throw null; }
                System.Data.IDataParameterCollection System.Data.IDbCommand.Parameters { get => throw null; }
                public abstract void Prepare();
                public virtual System.Threading.Tasks.Task PrepareAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                System.Data.IDbTransaction System.Data.IDbCommand.Transaction { get => throw null; set { } }
                public System.Data.Common.DbTransaction Transaction { get => throw null; set { } }
                public abstract System.Data.UpdateRowSource UpdatedRowSource { get; set; }
            }
            public abstract class DbCommandBuilder : System.ComponentModel.Component
            {
                protected abstract void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow row, System.Data.StatementType statementType, bool whereClause);
                public virtual System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set { } }
                public virtual string CatalogSeparator { get => throw null; set { } }
                public virtual System.Data.ConflictOption ConflictOption { get => throw null; set { } }
                protected DbCommandBuilder() => throw null;
                public System.Data.Common.DbDataAdapter DataAdapter { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                public System.Data.Common.DbCommand GetDeleteCommand() => throw null;
                public System.Data.Common.DbCommand GetDeleteCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.Common.DbCommand GetInsertCommand() => throw null;
                public System.Data.Common.DbCommand GetInsertCommand(bool useColumnsForParameterNames) => throw null;
                protected abstract string GetParameterName(int parameterOrdinal);
                protected abstract string GetParameterName(string parameterName);
                protected abstract string GetParameterPlaceholder(int parameterOrdinal);
                protected virtual System.Data.DataTable GetSchemaTable(System.Data.Common.DbCommand sourceCommand) => throw null;
                public System.Data.Common.DbCommand GetUpdateCommand() => throw null;
                public System.Data.Common.DbCommand GetUpdateCommand(bool useColumnsForParameterNames) => throw null;
                protected virtual System.Data.Common.DbCommand InitializeCommand(System.Data.Common.DbCommand command) => throw null;
                public virtual string QuoteIdentifier(string unquotedIdentifier) => throw null;
                public virtual string QuotePrefix { get => throw null; set { } }
                public virtual string QuoteSuffix { get => throw null; set { } }
                public virtual void RefreshSchema() => throw null;
                protected void RowUpdatingHandler(System.Data.Common.RowUpdatingEventArgs rowUpdatingEvent) => throw null;
                public virtual string SchemaSeparator { get => throw null; set { } }
                public bool SetAllValues { get => throw null; set { } }
                protected abstract void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter);
                public virtual string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }
            public abstract class DbConnection : System.ComponentModel.Component, System.IAsyncDisposable, System.Data.IDbConnection, System.IDisposable
            {
                protected abstract System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel);
                protected virtual System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginDbTransactionAsync(System.Data.IsolationLevel isolationLevel, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.Common.DbTransaction BeginTransaction() => throw null;
                public System.Data.Common.DbTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                System.Data.IDbTransaction System.Data.IDbConnection.BeginTransaction() => throw null;
                System.Data.IDbTransaction System.Data.IDbConnection.BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginTransactionAsync(System.Data.IsolationLevel isolationLevel, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginTransactionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual bool CanCreateBatch { get => throw null; }
                public abstract void ChangeDatabase(string databaseName);
                public virtual System.Threading.Tasks.Task ChangeDatabaseAsync(string databaseName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract void Close();
                public virtual System.Threading.Tasks.Task CloseAsync() => throw null;
                public abstract string ConnectionString { get; set; }
                public virtual int ConnectionTimeout { get => throw null; }
                public System.Data.Common.DbBatch CreateBatch() => throw null;
                public System.Data.Common.DbCommand CreateCommand() => throw null;
                System.Data.IDbCommand System.Data.IDbConnection.CreateCommand() => throw null;
                protected virtual System.Data.Common.DbBatch CreateDbBatch() => throw null;
                protected abstract System.Data.Common.DbCommand CreateDbCommand();
                protected DbConnection() => throw null;
                public abstract string Database { get; }
                public abstract string DataSource { get; }
                protected virtual System.Data.Common.DbProviderFactory DbProviderFactory { get => throw null; }
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public virtual void EnlistTransaction(System.Transactions.Transaction transaction) => throw null;
                public virtual System.Data.DataTable GetSchema() => throw null;
                public virtual System.Data.DataTable GetSchema(string collectionName) => throw null;
                public virtual System.Data.DataTable GetSchema(string collectionName, string[] restrictionValues) => throw null;
                public virtual System.Threading.Tasks.Task<System.Data.DataTable> GetSchemaAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<System.Data.DataTable> GetSchemaAsync(string collectionName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<System.Data.DataTable> GetSchemaAsync(string collectionName, string[] restrictionValues, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected virtual void OnStateChange(System.Data.StateChangeEventArgs stateChange) => throw null;
                public abstract void Open();
                public System.Threading.Tasks.Task OpenAsync() => throw null;
                public virtual System.Threading.Tasks.Task OpenAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract string ServerVersion { get; }
                public abstract System.Data.ConnectionState State { get; }
                public virtual event System.Data.StateChangeEventHandler StateChange;
            }
            public class DbConnectionStringBuilder : System.Collections.ICollection, System.ComponentModel.ICustomTypeDescriptor, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                public void Add(string keyword, object value) => throw null;
                void System.Collections.IDictionary.Add(object keyword, object value) => throw null;
                public static void AppendKeyValuePair(System.Text.StringBuilder builder, string keyword, string value) => throw null;
                public static void AppendKeyValuePair(System.Text.StringBuilder builder, string keyword, string value, bool useOdbcRules) => throw null;
                public bool BrowsableConnectionString { get => throw null; set { } }
                public virtual void Clear() => throw null;
                protected void ClearPropertyDescriptors() => throw null;
                public string ConnectionString { get => throw null; set { } }
                bool System.Collections.IDictionary.Contains(object keyword) => throw null;
                public virtual bool ContainsKey(string keyword) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public virtual int Count { get => throw null; }
                public DbConnectionStringBuilder() => throw null;
                public DbConnectionStringBuilder(bool useOdbcRules) => throw null;
                public virtual bool EquivalentTo(System.Data.Common.DbConnectionStringBuilder connectionStringBuilder) => throw null;
                System.ComponentModel.AttributeCollection System.ComponentModel.ICustomTypeDescriptor.GetAttributes() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetClassName() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetComponentName() => throw null;
                System.ComponentModel.TypeConverter System.ComponentModel.ICustomTypeDescriptor.GetConverter() => throw null;
                System.ComponentModel.EventDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultEvent() => throw null;
                System.ComponentModel.PropertyDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultProperty() => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetEditor(System.Type editorBaseType) => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents() => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents(System.Attribute[] attributes) => throw null;
                protected virtual void GetProperties(System.Collections.Hashtable propertyDescriptors) => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties() => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties(System.Attribute[] attributes) => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
                public virtual bool IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IDictionary.this[object keyword] { get => throw null; set { } }
                public virtual System.Collections.ICollection Keys { get => throw null; }
                public virtual bool Remove(string keyword) => throw null;
                void System.Collections.IDictionary.Remove(object keyword) => throw null;
                public virtual bool ShouldSerialize(string keyword) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public virtual object this[string keyword] { get => throw null; set { } }
                public override string ToString() => throw null;
                public virtual bool TryGetValue(string keyword, out object value) => throw null;
                public virtual System.Collections.ICollection Values { get => throw null; }
            }
            public abstract class DbDataAdapter : System.Data.Common.DataAdapter, System.ICloneable, System.Data.IDataAdapter, System.Data.IDbDataAdapter
            {
                protected virtual int AddToBatch(System.Data.IDbCommand command) => throw null;
                protected virtual void ClearBatch() => throw null;
                object System.ICloneable.Clone() => throw null;
                protected virtual System.Data.Common.RowUpdatedEventArgs CreateRowUpdatedEvent(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                protected virtual System.Data.Common.RowUpdatingEventArgs CreateRowUpdatingEvent(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                protected DbDataAdapter() => throw null;
                protected DbDataAdapter(System.Data.Common.DbDataAdapter adapter) => throw null;
                public const string DefaultSourceTableName = default;
                public System.Data.Common.DbCommand DeleteCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.DeleteCommand { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                protected virtual int ExecuteBatch() => throw null;
                public override int Fill(System.Data.DataSet dataSet) => throw null;
                public int Fill(System.Data.DataSet dataSet, int startRecord, int maxRecords, string srcTable) => throw null;
                protected virtual int Fill(System.Data.DataSet dataSet, int startRecord, int maxRecords, string srcTable, System.Data.IDbCommand command, System.Data.CommandBehavior behavior) => throw null;
                public int Fill(System.Data.DataSet dataSet, string srcTable) => throw null;
                public int Fill(System.Data.DataTable dataTable) => throw null;
                protected virtual int Fill(System.Data.DataTable dataTable, System.Data.IDbCommand command, System.Data.CommandBehavior behavior) => throw null;
                protected virtual int Fill(System.Data.DataTable[] dataTables, int startRecord, int maxRecords, System.Data.IDbCommand command, System.Data.CommandBehavior behavior) => throw null;
                public int Fill(int startRecord, int maxRecords, params System.Data.DataTable[] dataTables) => throw null;
                protected System.Data.CommandBehavior FillCommandBehavior { get => throw null; set { } }
                public override System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, System.Data.IDbCommand command, string srcTable, System.Data.CommandBehavior behavior) => throw null;
                public System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, string srcTable) => throw null;
                public System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType, System.Data.IDbCommand command, System.Data.CommandBehavior behavior) => throw null;
                protected virtual System.Data.IDataParameter GetBatchedParameter(int commandIdentifier, int parameterIndex) => throw null;
                protected virtual bool GetBatchedRecordsAffected(int commandIdentifier, out int recordsAffected, out System.Exception error) => throw null;
                public override System.Data.IDataParameter[] GetFillParameters() => throw null;
                protected virtual void InitializeBatching() => throw null;
                public System.Data.Common.DbCommand InsertCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.InsertCommand { get => throw null; set { } }
                protected virtual void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected virtual void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public System.Data.Common.DbCommand SelectCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.SelectCommand { get => throw null; set { } }
                protected virtual void TerminateBatching() => throw null;
                public int Update(System.Data.DataRow[] dataRows) => throw null;
                protected virtual int Update(System.Data.DataRow[] dataRows, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public override int Update(System.Data.DataSet dataSet) => throw null;
                public int Update(System.Data.DataSet dataSet, string srcTable) => throw null;
                public int Update(System.Data.DataTable dataTable) => throw null;
                public virtual int UpdateBatchSize { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.UpdateCommand { get => throw null; set { } }
                public System.Data.Common.DbCommand UpdateCommand { get => throw null; set { } }
            }
            public abstract class DbDataReader : System.MarshalByRefObject, System.IAsyncDisposable, System.Data.IDataReader, System.Data.IDataRecord, System.IDisposable, System.Collections.IEnumerable
            {
                public virtual void Close() => throw null;
                public virtual System.Threading.Tasks.Task CloseAsync() => throw null;
                protected DbDataReader() => throw null;
                public abstract int Depth { get; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public abstract int FieldCount { get; }
                public abstract bool GetBoolean(int ordinal);
                public abstract byte GetByte(int ordinal);
                public abstract long GetBytes(int ordinal, long dataOffset, byte[] buffer, int bufferOffset, int length);
                public abstract char GetChar(int ordinal);
                public abstract long GetChars(int ordinal, long dataOffset, char[] buffer, int bufferOffset, int length);
                public virtual System.Threading.Tasks.Task<System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn>> GetColumnSchemaAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Data.Common.DbDataReader GetData(int ordinal) => throw null;
                System.Data.IDataReader System.Data.IDataRecord.GetData(int ordinal) => throw null;
                public abstract string GetDataTypeName(int ordinal);
                public abstract System.DateTime GetDateTime(int ordinal);
                protected virtual System.Data.Common.DbDataReader GetDbDataReader(int ordinal) => throw null;
                public abstract decimal GetDecimal(int ordinal);
                public abstract double GetDouble(int ordinal);
                public abstract System.Collections.IEnumerator GetEnumerator();
                public abstract System.Type GetFieldType(int ordinal);
                public virtual T GetFieldValue<T>(int ordinal) => throw null;
                public System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int ordinal) => throw null;
                public virtual System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int ordinal, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract float GetFloat(int ordinal);
                public abstract System.Guid GetGuid(int ordinal);
                public abstract short GetInt16(int ordinal);
                public abstract int GetInt32(int ordinal);
                public abstract long GetInt64(int ordinal);
                public abstract string GetName(int ordinal);
                public abstract int GetOrdinal(string name);
                public virtual System.Type GetProviderSpecificFieldType(int ordinal) => throw null;
                public virtual object GetProviderSpecificValue(int ordinal) => throw null;
                public virtual int GetProviderSpecificValues(object[] values) => throw null;
                public virtual System.Data.DataTable GetSchemaTable() => throw null;
                public virtual System.Threading.Tasks.Task<System.Data.DataTable> GetSchemaTableAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.IO.Stream GetStream(int ordinal) => throw null;
                public abstract string GetString(int ordinal);
                public virtual System.IO.TextReader GetTextReader(int ordinal) => throw null;
                public abstract object GetValue(int ordinal);
                public abstract int GetValues(object[] values);
                public abstract bool HasRows { get; }
                public abstract bool IsClosed { get; }
                public abstract bool IsDBNull(int ordinal);
                public System.Threading.Tasks.Task<bool> IsDBNullAsync(int ordinal) => throw null;
                public virtual System.Threading.Tasks.Task<bool> IsDBNullAsync(int ordinal, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract bool NextResult();
                public System.Threading.Tasks.Task<bool> NextResultAsync() => throw null;
                public virtual System.Threading.Tasks.Task<bool> NextResultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract bool Read();
                public System.Threading.Tasks.Task<bool> ReadAsync() => throw null;
                public virtual System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract int RecordsAffected { get; }
                public abstract object this[int ordinal] { get; }
                public abstract object this[string name] { get; }
                public virtual int VisibleFieldCount { get => throw null; }
            }
            public static partial class DbDataReaderExtensions
            {
                public static bool CanGetColumnSchema(this System.Data.Common.DbDataReader reader) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema(this System.Data.Common.DbDataReader reader) => throw null;
            }
            public abstract class DbDataRecord : System.ComponentModel.ICustomTypeDescriptor, System.Data.IDataRecord
            {
                protected DbDataRecord() => throw null;
                public abstract int FieldCount { get; }
                System.ComponentModel.AttributeCollection System.ComponentModel.ICustomTypeDescriptor.GetAttributes() => throw null;
                public abstract bool GetBoolean(int i);
                public abstract byte GetByte(int i);
                public abstract long GetBytes(int i, long dataIndex, byte[] buffer, int bufferIndex, int length);
                public abstract char GetChar(int i);
                public abstract long GetChars(int i, long dataIndex, char[] buffer, int bufferIndex, int length);
                string System.ComponentModel.ICustomTypeDescriptor.GetClassName() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetComponentName() => throw null;
                System.ComponentModel.TypeConverter System.ComponentModel.ICustomTypeDescriptor.GetConverter() => throw null;
                public System.Data.IDataReader GetData(int i) => throw null;
                public abstract string GetDataTypeName(int i);
                public abstract System.DateTime GetDateTime(int i);
                protected virtual System.Data.Common.DbDataReader GetDbDataReader(int i) => throw null;
                public abstract decimal GetDecimal(int i);
                System.ComponentModel.EventDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultEvent() => throw null;
                System.ComponentModel.PropertyDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultProperty() => throw null;
                public abstract double GetDouble(int i);
                object System.ComponentModel.ICustomTypeDescriptor.GetEditor(System.Type editorBaseType) => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents() => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents(System.Attribute[] attributes) => throw null;
                public abstract System.Type GetFieldType(int i);
                public abstract float GetFloat(int i);
                public abstract System.Guid GetGuid(int i);
                public abstract short GetInt16(int i);
                public abstract int GetInt32(int i);
                public abstract long GetInt64(int i);
                public abstract string GetName(int i);
                public abstract int GetOrdinal(string name);
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties() => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties(System.Attribute[] attributes) => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
                public abstract string GetString(int i);
                public abstract object GetValue(int i);
                public abstract int GetValues(object[] values);
                public abstract bool IsDBNull(int i);
                public abstract object this[int i] { get; }
                public abstract object this[string name] { get; }
            }
            public abstract class DbDataSource : System.IAsyncDisposable, System.IDisposable
            {
                public abstract string ConnectionString { get; }
                public System.Data.Common.DbBatch CreateBatch() => throw null;
                public System.Data.Common.DbCommand CreateCommand(string commandText = default(string)) => throw null;
                public System.Data.Common.DbConnection CreateConnection() => throw null;
                protected virtual System.Data.Common.DbBatch CreateDbBatch() => throw null;
                protected virtual System.Data.Common.DbCommand CreateDbCommand(string commandText = default(string)) => throw null;
                protected abstract System.Data.Common.DbConnection CreateDbConnection();
                protected DbDataSource() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected virtual System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public System.Data.Common.DbConnection OpenConnection() => throw null;
                public System.Threading.Tasks.ValueTask<System.Data.Common.DbConnection> OpenConnectionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected virtual System.Data.Common.DbConnection OpenDbConnection() => throw null;
                protected virtual System.Threading.Tasks.ValueTask<System.Data.Common.DbConnection> OpenDbConnectionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public abstract class DbDataSourceEnumerator
            {
                protected DbDataSourceEnumerator() => throw null;
                public abstract System.Data.DataTable GetDataSources();
            }
            public class DbEnumerator : System.Collections.IEnumerator
            {
                public DbEnumerator(System.Data.Common.DbDataReader reader) => throw null;
                public DbEnumerator(System.Data.Common.DbDataReader reader, bool closeReader) => throw null;
                public DbEnumerator(System.Data.IDataReader reader) => throw null;
                public DbEnumerator(System.Data.IDataReader reader, bool closeReader) => throw null;
                public object Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            public abstract class DbException : System.Runtime.InteropServices.ExternalException
            {
                public System.Data.Common.DbBatchCommand BatchCommand { get => throw null; }
                protected DbException() => throw null;
                protected DbException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected DbException(string message) => throw null;
                protected DbException(string message, System.Exception innerException) => throw null;
                protected DbException(string message, int errorCode) => throw null;
                protected virtual System.Data.Common.DbBatchCommand DbBatchCommand { get => throw null; }
                public virtual bool IsTransient { get => throw null; }
                public virtual string SqlState { get => throw null; }
            }
            public static class DbMetaDataCollectionNames
            {
                public static readonly string DataSourceInformation;
                public static readonly string DataTypes;
                public static readonly string MetaDataCollections;
                public static readonly string ReservedWords;
                public static readonly string Restrictions;
            }
            public static class DbMetaDataColumnNames
            {
                public static readonly string CollectionName;
                public static readonly string ColumnSize;
                public static readonly string CompositeIdentifierSeparatorPattern;
                public static readonly string CreateFormat;
                public static readonly string CreateParameters;
                public static readonly string DataSourceProductName;
                public static readonly string DataSourceProductVersion;
                public static readonly string DataSourceProductVersionNormalized;
                public static readonly string DataType;
                public static readonly string GroupByBehavior;
                public static readonly string IdentifierCase;
                public static readonly string IdentifierPattern;
                public static readonly string IsAutoIncrementable;
                public static readonly string IsBestMatch;
                public static readonly string IsCaseSensitive;
                public static readonly string IsConcurrencyType;
                public static readonly string IsFixedLength;
                public static readonly string IsFixedPrecisionScale;
                public static readonly string IsLiteralSupported;
                public static readonly string IsLong;
                public static readonly string IsNullable;
                public static readonly string IsSearchable;
                public static readonly string IsSearchableWithLike;
                public static readonly string IsUnsigned;
                public static readonly string LiteralPrefix;
                public static readonly string LiteralSuffix;
                public static readonly string MaximumScale;
                public static readonly string MinimumScale;
                public static readonly string NumberOfIdentifierParts;
                public static readonly string NumberOfRestrictions;
                public static readonly string OrderByColumnsInSelect;
                public static readonly string ParameterMarkerFormat;
                public static readonly string ParameterMarkerPattern;
                public static readonly string ParameterNameMaxLength;
                public static readonly string ParameterNamePattern;
                public static readonly string ProviderDbType;
                public static readonly string QuotedIdentifierCase;
                public static readonly string QuotedIdentifierPattern;
                public static readonly string ReservedWord;
                public static readonly string StatementSeparatorPattern;
                public static readonly string StringLiteralPattern;
                public static readonly string SupportedJoinOperators;
                public static readonly string TypeName;
            }
            public abstract class DbParameter : System.MarshalByRefObject, System.Data.IDataParameter, System.Data.IDbDataParameter
            {
                protected DbParameter() => throw null;
                public abstract System.Data.DbType DbType { get; set; }
                public abstract System.Data.ParameterDirection Direction { get; set; }
                public abstract bool IsNullable { get; set; }
                public abstract string ParameterName { get; set; }
                public virtual byte Precision { get => throw null; set { } }
                byte System.Data.IDbDataParameter.Precision { get => throw null; set { } }
                public abstract void ResetDbType();
                public virtual byte Scale { get => throw null; set { } }
                byte System.Data.IDbDataParameter.Scale { get => throw null; set { } }
                public abstract int Size { get; set; }
                public abstract string SourceColumn { get; set; }
                public abstract bool SourceColumnNullMapping { get; set; }
                public virtual System.Data.DataRowVersion SourceVersion { get => throw null; set { } }
                public abstract object Value { get; set; }
            }
            public abstract class DbParameterCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Data.IDataParameterCollection, System.Collections.IEnumerable, System.Collections.IList
            {
                int System.Collections.IList.Add(object value) => throw null;
                public abstract int Add(object value);
                public abstract void AddRange(System.Array values);
                public abstract void Clear();
                bool System.Collections.IList.Contains(object value) => throw null;
                public abstract bool Contains(object value);
                public abstract bool Contains(string value);
                public abstract void CopyTo(System.Array array, int index);
                public abstract int Count { get; }
                protected DbParameterCollection() => throw null;
                public abstract System.Collections.IEnumerator GetEnumerator();
                protected abstract System.Data.Common.DbParameter GetParameter(int index);
                protected abstract System.Data.Common.DbParameter GetParameter(string parameterName);
                int System.Collections.IList.IndexOf(object value) => throw null;
                public abstract int IndexOf(object value);
                public abstract int IndexOf(string parameterName);
                void System.Collections.IList.Insert(int index, object value) => throw null;
                public abstract void Insert(int index, object value);
                public virtual bool IsFixedSize { get => throw null; }
                public virtual bool IsReadOnly { get => throw null; }
                public virtual bool IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                object System.Data.IDataParameterCollection.this[string parameterName] { get => throw null; set { } }
                void System.Collections.IList.Remove(object value) => throw null;
                public abstract void Remove(object value);
                public abstract void RemoveAt(int index);
                public abstract void RemoveAt(string parameterName);
                protected abstract void SetParameter(int index, System.Data.Common.DbParameter value);
                protected abstract void SetParameter(string parameterName, System.Data.Common.DbParameter value);
                public abstract object SyncRoot { get; }
                public System.Data.Common.DbParameter this[int index] { get => throw null; set { } }
                public System.Data.Common.DbParameter this[string parameterName] { get => throw null; set { } }
            }
            public static class DbProviderFactories
            {
                public static System.Data.Common.DbProviderFactory GetFactory(System.Data.Common.DbConnection connection) => throw null;
                public static System.Data.Common.DbProviderFactory GetFactory(System.Data.DataRow providerRow) => throw null;
                public static System.Data.Common.DbProviderFactory GetFactory(string providerInvariantName) => throw null;
                public static System.Data.DataTable GetFactoryClasses() => throw null;
                public static System.Collections.Generic.IEnumerable<string> GetProviderInvariantNames() => throw null;
                public static void RegisterFactory(string providerInvariantName, System.Data.Common.DbProviderFactory factory) => throw null;
                public static void RegisterFactory(string providerInvariantName, string factoryTypeAssemblyQualifiedName) => throw null;
                public static void RegisterFactory(string providerInvariantName, System.Type providerFactoryClass) => throw null;
                public static bool TryGetFactory(string providerInvariantName, out System.Data.Common.DbProviderFactory factory) => throw null;
                public static bool UnregisterFactory(string providerInvariantName) => throw null;
            }
            public abstract class DbProviderFactory
            {
                public virtual bool CanCreateBatch { get => throw null; }
                public virtual bool CanCreateCommandBuilder { get => throw null; }
                public virtual bool CanCreateDataAdapter { get => throw null; }
                public virtual bool CanCreateDataSourceEnumerator { get => throw null; }
                public virtual System.Data.Common.DbBatch CreateBatch() => throw null;
                public virtual System.Data.Common.DbBatchCommand CreateBatchCommand() => throw null;
                public virtual System.Data.Common.DbCommand CreateCommand() => throw null;
                public virtual System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public virtual System.Data.Common.DbConnection CreateConnection() => throw null;
                public virtual System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public virtual System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public virtual System.Data.Common.DbDataSource CreateDataSource(string connectionString) => throw null;
                public virtual System.Data.Common.DbDataSourceEnumerator CreateDataSourceEnumerator() => throw null;
                public virtual System.Data.Common.DbParameter CreateParameter() => throw null;
                protected DbProviderFactory() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
            public sealed class DbProviderSpecificTypePropertyAttribute : System.Attribute
            {
                public DbProviderSpecificTypePropertyAttribute(bool isProviderSpecificTypeProperty) => throw null;
                public bool IsProviderSpecificTypeProperty { get => throw null; }
            }
            public abstract class DbTransaction : System.MarshalByRefObject, System.IAsyncDisposable, System.Data.IDbTransaction, System.IDisposable
            {
                public abstract void Commit();
                public virtual System.Threading.Tasks.Task CommitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Data.Common.DbConnection Connection { get => throw null; }
                System.Data.IDbConnection System.Data.IDbTransaction.Connection { get => throw null; }
                protected DbTransaction() => throw null;
                protected abstract System.Data.Common.DbConnection DbConnection { get; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public abstract System.Data.IsolationLevel IsolationLevel { get; }
                public virtual void Release(string savepointName) => throw null;
                public virtual System.Threading.Tasks.Task ReleaseAsync(string savepointName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract void Rollback();
                public virtual void Rollback(string savepointName) => throw null;
                public virtual System.Threading.Tasks.Task RollbackAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task RollbackAsync(string savepointName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual void Save(string savepointName) => throw null;
                public virtual System.Threading.Tasks.Task SaveAsync(string savepointName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual bool SupportsSavepoints { get => throw null; }
            }
            public enum GroupByBehavior
            {
                Unknown = 0,
                NotSupported = 1,
                Unrelated = 2,
                MustContainAll = 3,
                ExactMatch = 4,
            }
            public interface IDbColumnSchemaGenerator
            {
                System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema();
            }
            public enum IdentifierCase
            {
                Unknown = 0,
                Insensitive = 1,
                Sensitive = 2,
            }
            public class RowUpdatedEventArgs : System.EventArgs
            {
                public System.Data.IDbCommand Command { get => throw null; }
                public void CopyToRows(System.Data.DataRow[] array) => throw null;
                public void CopyToRows(System.Data.DataRow[] array, int arrayIndex) => throw null;
                public RowUpdatedEventArgs(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public System.Exception Errors { get => throw null; set { } }
                public int RecordsAffected { get => throw null; }
                public System.Data.DataRow Row { get => throw null; }
                public int RowCount { get => throw null; }
                public System.Data.StatementType StatementType { get => throw null; }
                public System.Data.UpdateStatus Status { get => throw null; set { } }
                public System.Data.Common.DataTableMapping TableMapping { get => throw null; }
            }
            public class RowUpdatingEventArgs : System.EventArgs
            {
                protected virtual System.Data.IDbCommand BaseCommand { get => throw null; set { } }
                public System.Data.IDbCommand Command { get => throw null; set { } }
                public RowUpdatingEventArgs(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public System.Exception Errors { get => throw null; set { } }
                public System.Data.DataRow Row { get => throw null; }
                public System.Data.StatementType StatementType { get => throw null; }
                public System.Data.UpdateStatus Status { get => throw null; set { } }
                public System.Data.Common.DataTableMapping TableMapping { get => throw null; }
            }
            public static class SchemaTableColumn
            {
                public static readonly string AllowDBNull;
                public static readonly string BaseColumnName;
                public static readonly string BaseSchemaName;
                public static readonly string BaseTableName;
                public static readonly string ColumnName;
                public static readonly string ColumnOrdinal;
                public static readonly string ColumnSize;
                public static readonly string DataType;
                public static readonly string IsAliased;
                public static readonly string IsExpression;
                public static readonly string IsKey;
                public static readonly string IsLong;
                public static readonly string IsUnique;
                public static readonly string NonVersionedProviderType;
                public static readonly string NumericPrecision;
                public static readonly string NumericScale;
                public static readonly string ProviderType;
            }
            public static class SchemaTableOptionalColumn
            {
                public static readonly string AutoIncrementSeed;
                public static readonly string AutoIncrementStep;
                public static readonly string BaseCatalogName;
                public static readonly string BaseColumnNamespace;
                public static readonly string BaseServerName;
                public static readonly string BaseTableNamespace;
                public static readonly string ColumnMapping;
                public static readonly string DefaultValue;
                public static readonly string Expression;
                public static readonly string IsAutoIncrement;
                public static readonly string IsHidden;
                public static readonly string IsReadOnly;
                public static readonly string IsRowVersion;
                public static readonly string ProviderSpecificDataType;
            }
            [System.Flags]
            public enum SupportedJoinOperators
            {
                None = 0,
                Inner = 1,
                LeftOuter = 2,
                RightOuter = 4,
                FullOuter = 8,
            }
        }
        public enum ConflictOption
        {
            CompareAllSearchableValues = 1,
            CompareRowVersion = 2,
            OverwriteChanges = 3,
        }
        [System.Flags]
        public enum ConnectionState
        {
            Closed = 0,
            Open = 1,
            Connecting = 2,
            Executing = 4,
            Fetching = 8,
            Broken = 16,
        }
        public abstract class Constraint
        {
            protected virtual System.Data.DataSet _DataSet { get => throw null; }
            protected void CheckStateForProperty() => throw null;
            public virtual string ConstraintName { get => throw null; set { } }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            protected void SetDataSet(System.Data.DataSet dataSet) => throw null;
            public abstract System.Data.DataTable Table { get; }
            public override string ToString() => throw null;
        }
        public sealed class ConstraintCollection : System.Data.InternalDataCollectionBase
        {
            public void Add(System.Data.Constraint constraint) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn column, bool primaryKey) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn primaryKeyColumn, System.Data.DataColumn foreignKeyColumn) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn[] columns, bool primaryKey) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn[] primaryKeyColumns, System.Data.DataColumn[] foreignKeyColumns) => throw null;
            public void AddRange(System.Data.Constraint[] constraints) => throw null;
            public bool CanRemove(System.Data.Constraint constraint) => throw null;
            public void Clear() => throw null;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanged;
            public bool Contains(string name) => throw null;
            public void CopyTo(System.Data.Constraint[] array, int index) => throw null;
            public int IndexOf(System.Data.Constraint constraint) => throw null;
            public int IndexOf(string constraintName) => throw null;
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.Constraint constraint) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
            public System.Data.Constraint this[int index] { get => throw null; }
            public System.Data.Constraint this[string name] { get => throw null; }
        }
        public class ConstraintException : System.Data.DataException
        {
            public ConstraintException() => throw null;
            protected ConstraintException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ConstraintException(string s) => throw null;
            public ConstraintException(string message, System.Exception innerException) => throw null;
        }
        public class DataColumn : System.ComponentModel.MarshalByValueComponent
        {
            public bool AllowDBNull { get => throw null; set { } }
            public bool AutoIncrement { get => throw null; set { } }
            public long AutoIncrementSeed { get => throw null; set { } }
            public long AutoIncrementStep { get => throw null; set { } }
            public string Caption { get => throw null; set { } }
            protected void CheckNotAllowNull() => throw null;
            protected void CheckUnique() => throw null;
            public virtual System.Data.MappingType ColumnMapping { get => throw null; set { } }
            public string ColumnName { get => throw null; set { } }
            public DataColumn() => throw null;
            public DataColumn(string columnName) => throw null;
            public DataColumn(string columnName, System.Type dataType) => throw null;
            public DataColumn(string columnName, System.Type dataType, string expr) => throw null;
            public DataColumn(string columnName, System.Type dataType, string expr, System.Data.MappingType type) => throw null;
            public System.Type DataType { get => throw null; set { } }
            public System.Data.DataSetDateTime DateTimeMode { get => throw null; set { } }
            public object DefaultValue { get => throw null; set { } }
            public string Expression { get => throw null; set { } }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            public int MaxLength { get => throw null; set { } }
            public string Namespace { get => throw null; set { } }
            protected virtual void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            public int Ordinal { get => throw null; }
            public string Prefix { get => throw null; set { } }
            protected void RaisePropertyChanging(string name) => throw null;
            public bool ReadOnly { get => throw null; set { } }
            public void SetOrdinal(int ordinal) => throw null;
            public System.Data.DataTable Table { get => throw null; }
            public override string ToString() => throw null;
            public bool Unique { get => throw null; set { } }
        }
        public class DataColumnChangeEventArgs : System.EventArgs
        {
            public System.Data.DataColumn Column { get => throw null; }
            public DataColumnChangeEventArgs(System.Data.DataRow row, System.Data.DataColumn column, object value) => throw null;
            public object ProposedValue { get => throw null; set { } }
            public System.Data.DataRow Row { get => throw null; }
        }
        public delegate void DataColumnChangeEventHandler(object sender, System.Data.DataColumnChangeEventArgs e);
        public sealed class DataColumnCollection : System.Data.InternalDataCollectionBase
        {
            public System.Data.DataColumn Add() => throw null;
            public void Add(System.Data.DataColumn column) => throw null;
            public System.Data.DataColumn Add(string columnName) => throw null;
            public System.Data.DataColumn Add(string columnName, System.Type type) => throw null;
            public System.Data.DataColumn Add(string columnName, System.Type type, string expression) => throw null;
            public void AddRange(System.Data.DataColumn[] columns) => throw null;
            public bool CanRemove(System.Data.DataColumn column) => throw null;
            public void Clear() => throw null;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanged;
            public bool Contains(string name) => throw null;
            public void CopyTo(System.Data.DataColumn[] array, int index) => throw null;
            public int IndexOf(System.Data.DataColumn column) => throw null;
            public int IndexOf(string columnName) => throw null;
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.DataColumn column) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
            public System.Data.DataColumn this[int index] { get => throw null; }
            public System.Data.DataColumn this[string name] { get => throw null; }
        }
        public class DataException : System.SystemException
        {
            public DataException() => throw null;
            protected DataException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DataException(string s) => throw null;
            public DataException(string s, System.Exception innerException) => throw null;
        }
        public static partial class DataReaderExtensions
        {
            public static bool GetBoolean(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static byte GetByte(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static long GetBytes(this System.Data.Common.DbDataReader reader, string name, long dataOffset, byte[] buffer, int bufferOffset, int length) => throw null;
            public static char GetChar(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static long GetChars(this System.Data.Common.DbDataReader reader, string name, long dataOffset, char[] buffer, int bufferOffset, int length) => throw null;
            public static System.Data.Common.DbDataReader GetData(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static string GetDataTypeName(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.DateTime GetDateTime(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static decimal GetDecimal(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static double GetDouble(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Type GetFieldType(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static T GetFieldValue<T>(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(this System.Data.Common.DbDataReader reader, string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public static float GetFloat(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Guid GetGuid(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static short GetInt16(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static int GetInt32(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static long GetInt64(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Type GetProviderSpecificFieldType(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static object GetProviderSpecificValue(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.IO.Stream GetStream(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static string GetString(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.IO.TextReader GetTextReader(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static object GetValue(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static bool IsDBNull(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Threading.Tasks.Task<bool> IsDBNullAsync(this System.Data.Common.DbDataReader reader, string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class DataRelation
        {
            protected void CheckStateForProperty() => throw null;
            public virtual System.Data.DataColumn[] ChildColumns { get => throw null; }
            public virtual System.Data.ForeignKeyConstraint ChildKeyConstraint { get => throw null; }
            public virtual System.Data.DataTable ChildTable { get => throw null; }
            public DataRelation(string relationName, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public DataRelation(string relationName, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn, bool createConstraints) => throw null;
            public DataRelation(string relationName, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public DataRelation(string relationName, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns, bool createConstraints) => throw null;
            public DataRelation(string relationName, string parentTableName, string parentTableNamespace, string childTableName, string childTableNamespace, string[] parentColumnNames, string[] childColumnNames, bool nested) => throw null;
            public DataRelation(string relationName, string parentTableName, string childTableName, string[] parentColumnNames, string[] childColumnNames, bool nested) => throw null;
            public virtual System.Data.DataSet DataSet { get => throw null; }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            public virtual bool Nested { get => throw null; set { } }
            protected void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            public virtual System.Data.DataColumn[] ParentColumns { get => throw null; }
            public virtual System.Data.UniqueConstraint ParentKeyConstraint { get => throw null; }
            public virtual System.Data.DataTable ParentTable { get => throw null; }
            protected void RaisePropertyChanging(string name) => throw null;
            public virtual string RelationName { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public abstract class DataRelationCollection : System.Data.InternalDataCollectionBase
        {
            public virtual System.Data.DataRelation Add(System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public virtual System.Data.DataRelation Add(System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public void Add(System.Data.DataRelation relation) => throw null;
            public virtual System.Data.DataRelation Add(string name, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public virtual System.Data.DataRelation Add(string name, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn, bool createConstraints) => throw null;
            public virtual System.Data.DataRelation Add(string name, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public virtual System.Data.DataRelation Add(string name, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns, bool createConstraints) => throw null;
            protected virtual void AddCore(System.Data.DataRelation relation) => throw null;
            public virtual void AddRange(System.Data.DataRelation[] relations) => throw null;
            public virtual bool CanRemove(System.Data.DataRelation relation) => throw null;
            public virtual void Clear() => throw null;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanged;
            public virtual bool Contains(string name) => throw null;
            public void CopyTo(System.Data.DataRelation[] array, int index) => throw null;
            protected DataRelationCollection() => throw null;
            protected abstract System.Data.DataSet GetDataSet();
            public virtual int IndexOf(System.Data.DataRelation relation) => throw null;
            public virtual int IndexOf(string relationName) => throw null;
            protected virtual void OnCollectionChanged(System.ComponentModel.CollectionChangeEventArgs ccevent) => throw null;
            protected virtual void OnCollectionChanging(System.ComponentModel.CollectionChangeEventArgs ccevent) => throw null;
            public void Remove(System.Data.DataRelation relation) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
            protected virtual void RemoveCore(System.Data.DataRelation relation) => throw null;
            public abstract System.Data.DataRelation this[int index] { get; }
            public abstract System.Data.DataRelation this[string name] { get; }
        }
        public class DataRow
        {
            public void AcceptChanges() => throw null;
            public void BeginEdit() => throw null;
            public void CancelEdit() => throw null;
            public void ClearErrors() => throw null;
            protected DataRow(System.Data.DataRowBuilder builder) => throw null;
            public void Delete() => throw null;
            public void EndEdit() => throw null;
            public System.Data.DataRow[] GetChildRows(System.Data.DataRelation relation) => throw null;
            public System.Data.DataRow[] GetChildRows(System.Data.DataRelation relation, System.Data.DataRowVersion version) => throw null;
            public System.Data.DataRow[] GetChildRows(string relationName) => throw null;
            public System.Data.DataRow[] GetChildRows(string relationName, System.Data.DataRowVersion version) => throw null;
            public string GetColumnError(System.Data.DataColumn column) => throw null;
            public string GetColumnError(int columnIndex) => throw null;
            public string GetColumnError(string columnName) => throw null;
            public System.Data.DataColumn[] GetColumnsInError() => throw null;
            public System.Data.DataRow GetParentRow(System.Data.DataRelation relation) => throw null;
            public System.Data.DataRow GetParentRow(System.Data.DataRelation relation, System.Data.DataRowVersion version) => throw null;
            public System.Data.DataRow GetParentRow(string relationName) => throw null;
            public System.Data.DataRow GetParentRow(string relationName, System.Data.DataRowVersion version) => throw null;
            public System.Data.DataRow[] GetParentRows(System.Data.DataRelation relation) => throw null;
            public System.Data.DataRow[] GetParentRows(System.Data.DataRelation relation, System.Data.DataRowVersion version) => throw null;
            public System.Data.DataRow[] GetParentRows(string relationName) => throw null;
            public System.Data.DataRow[] GetParentRows(string relationName, System.Data.DataRowVersion version) => throw null;
            public bool HasErrors { get => throw null; }
            public bool HasVersion(System.Data.DataRowVersion version) => throw null;
            public bool IsNull(System.Data.DataColumn column) => throw null;
            public bool IsNull(System.Data.DataColumn column, System.Data.DataRowVersion version) => throw null;
            public bool IsNull(int columnIndex) => throw null;
            public bool IsNull(string columnName) => throw null;
            public object[] ItemArray { get => throw null; set { } }
            public void RejectChanges() => throw null;
            public string RowError { get => throw null; set { } }
            public System.Data.DataRowState RowState { get => throw null; }
            public void SetAdded() => throw null;
            public void SetColumnError(System.Data.DataColumn column, string error) => throw null;
            public void SetColumnError(int columnIndex, string error) => throw null;
            public void SetColumnError(string columnName, string error) => throw null;
            public void SetModified() => throw null;
            protected void SetNull(System.Data.DataColumn column) => throw null;
            public void SetParentRow(System.Data.DataRow parentRow) => throw null;
            public void SetParentRow(System.Data.DataRow parentRow, System.Data.DataRelation relation) => throw null;
            public System.Data.DataTable Table { get => throw null; }
            public object this[System.Data.DataColumn column] { get => throw null; set { } }
            public object this[System.Data.DataColumn column, System.Data.DataRowVersion version] { get => throw null; }
            public object this[int columnIndex] { get => throw null; set { } }
            public object this[int columnIndex, System.Data.DataRowVersion version] { get => throw null; }
            public object this[string columnName] { get => throw null; set { } }
            public object this[string columnName, System.Data.DataRowVersion version] { get => throw null; }
        }
        [System.Flags]
        public enum DataRowAction
        {
            Nothing = 0,
            Delete = 1,
            Change = 2,
            Rollback = 4,
            Commit = 8,
            Add = 16,
            ChangeOriginal = 32,
            ChangeCurrentAndOriginal = 64,
        }
        public sealed class DataRowBuilder
        {
        }
        public class DataRowChangeEventArgs : System.EventArgs
        {
            public System.Data.DataRowAction Action { get => throw null; }
            public DataRowChangeEventArgs(System.Data.DataRow row, System.Data.DataRowAction action) => throw null;
            public System.Data.DataRow Row { get => throw null; }
        }
        public delegate void DataRowChangeEventHandler(object sender, System.Data.DataRowChangeEventArgs e);
        public sealed class DataRowCollection : System.Data.InternalDataCollectionBase
        {
            public void Add(System.Data.DataRow row) => throw null;
            public System.Data.DataRow Add(params object[] values) => throw null;
            public void Clear() => throw null;
            public bool Contains(object key) => throw null;
            public bool Contains(object[] keys) => throw null;
            public override void CopyTo(System.Array ar, int index) => throw null;
            public void CopyTo(System.Data.DataRow[] array, int index) => throw null;
            public override int Count { get => throw null; }
            public System.Data.DataRow Find(object key) => throw null;
            public System.Data.DataRow Find(object[] keys) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public int IndexOf(System.Data.DataRow row) => throw null;
            public void InsertAt(System.Data.DataRow row, int pos) => throw null;
            public void Remove(System.Data.DataRow row) => throw null;
            public void RemoveAt(int index) => throw null;
            public System.Data.DataRow this[int index] { get => throw null; }
        }
        public static class DataRowComparer
        {
            public static System.Data.DataRowComparer<System.Data.DataRow> Default { get => throw null; }
        }
        public sealed class DataRowComparer<TRow> : System.Collections.Generic.IEqualityComparer<TRow> where TRow : System.Data.DataRow
        {
            public static System.Data.DataRowComparer<TRow> Default { get => throw null; }
            public bool Equals(TRow leftRow, TRow rightRow) => throw null;
            public int GetHashCode(TRow row) => throw null;
        }
        public static partial class DataRowExtensions
        {
            public static T Field<T>(this System.Data.DataRow row, System.Data.DataColumn column) => throw null;
            public static T Field<T>(this System.Data.DataRow row, System.Data.DataColumn column, System.Data.DataRowVersion version) => throw null;
            public static T Field<T>(this System.Data.DataRow row, int columnIndex) => throw null;
            public static T Field<T>(this System.Data.DataRow row, int columnIndex, System.Data.DataRowVersion version) => throw null;
            public static T Field<T>(this System.Data.DataRow row, string columnName) => throw null;
            public static T Field<T>(this System.Data.DataRow row, string columnName, System.Data.DataRowVersion version) => throw null;
            public static void SetField<T>(this System.Data.DataRow row, System.Data.DataColumn column, T value) => throw null;
            public static void SetField<T>(this System.Data.DataRow row, int columnIndex, T value) => throw null;
            public static void SetField<T>(this System.Data.DataRow row, string columnName, T value) => throw null;
        }
        [System.Flags]
        public enum DataRowState
        {
            Detached = 1,
            Unchanged = 2,
            Added = 4,
            Deleted = 8,
            Modified = 16,
        }
        public enum DataRowVersion
        {
            Original = 256,
            Current = 512,
            Proposed = 1024,
            Default = 1536,
        }
        public class DataRowView : System.ComponentModel.ICustomTypeDescriptor, System.ComponentModel.IDataErrorInfo, System.ComponentModel.IEditableObject, System.ComponentModel.INotifyPropertyChanged
        {
            public void BeginEdit() => throw null;
            public void CancelEdit() => throw null;
            public System.Data.DataView CreateChildView(System.Data.DataRelation relation) => throw null;
            public System.Data.DataView CreateChildView(System.Data.DataRelation relation, bool followParent) => throw null;
            public System.Data.DataView CreateChildView(string relationName) => throw null;
            public System.Data.DataView CreateChildView(string relationName, bool followParent) => throw null;
            public System.Data.DataView DataView { get => throw null; }
            public void Delete() => throw null;
            public void EndEdit() => throw null;
            public override bool Equals(object other) => throw null;
            string System.ComponentModel.IDataErrorInfo.Error { get => throw null; }
            System.ComponentModel.AttributeCollection System.ComponentModel.ICustomTypeDescriptor.GetAttributes() => throw null;
            string System.ComponentModel.ICustomTypeDescriptor.GetClassName() => throw null;
            string System.ComponentModel.ICustomTypeDescriptor.GetComponentName() => throw null;
            System.ComponentModel.TypeConverter System.ComponentModel.ICustomTypeDescriptor.GetConverter() => throw null;
            System.ComponentModel.EventDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultEvent() => throw null;
            System.ComponentModel.PropertyDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultProperty() => throw null;
            object System.ComponentModel.ICustomTypeDescriptor.GetEditor(System.Type editorBaseType) => throw null;
            System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents() => throw null;
            System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents(System.Attribute[] attributes) => throw null;
            public override int GetHashCode() => throw null;
            System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties() => throw null;
            System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties(System.Attribute[] attributes) => throw null;
            object System.ComponentModel.ICustomTypeDescriptor.GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
            public bool IsEdit { get => throw null; }
            public bool IsNew { get => throw null; }
            string System.ComponentModel.IDataErrorInfo.this[string colName] { get => throw null; }
            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
            public System.Data.DataRow Row { get => throw null; }
            public System.Data.DataRowVersion RowVersion { get => throw null; }
            public object this[int ndx] { get => throw null; set { } }
            public object this[string property] { get => throw null; set { } }
        }
        public class DataSet : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IListSource, System.Runtime.Serialization.ISerializable, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.Xml.Serialization.IXmlSerializable
        {
            public void AcceptChanges() => throw null;
            public void BeginInit() => throw null;
            public bool CaseSensitive { get => throw null; set { } }
            public void Clear() => throw null;
            public virtual System.Data.DataSet Clone() => throw null;
            bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
            public System.Data.DataSet Copy() => throw null;
            public System.Data.DataTableReader CreateDataReader() => throw null;
            public System.Data.DataTableReader CreateDataReader(params System.Data.DataTable[] dataTables) => throw null;
            public DataSet() => throw null;
            protected DataSet(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            protected DataSet(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context, bool ConstructSchema) => throw null;
            public DataSet(string dataSetName) => throw null;
            public string DataSetName { get => throw null; set { } }
            public System.Data.DataViewManager DefaultViewManager { get => throw null; }
            protected System.Data.SchemaSerializationMode DetermineSchemaSerializationMode(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            protected System.Data.SchemaSerializationMode DetermineSchemaSerializationMode(System.Xml.XmlReader reader) => throw null;
            public void EndInit() => throw null;
            public bool EnforceConstraints { get => throw null; set { } }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            public System.Data.DataSet GetChanges() => throw null;
            public System.Data.DataSet GetChanges(System.Data.DataRowState rowStates) => throw null;
            public static System.Xml.Schema.XmlSchemaComplexType GetDataSetSchema(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
            System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
            public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
            protected virtual System.Xml.Schema.XmlSchema GetSchemaSerializable() => throw null;
            protected void GetSerializationData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public string GetXml() => throw null;
            public string GetXmlSchema() => throw null;
            public bool HasChanges() => throw null;
            public bool HasChanges(System.Data.DataRowState rowStates) => throw null;
            public bool HasErrors { get => throw null; }
            public void InferXmlSchema(System.IO.Stream stream, string[] nsArray) => throw null;
            public void InferXmlSchema(System.IO.TextReader reader, string[] nsArray) => throw null;
            public void InferXmlSchema(string fileName, string[] nsArray) => throw null;
            public void InferXmlSchema(System.Xml.XmlReader reader, string[] nsArray) => throw null;
            public event System.EventHandler Initialized;
            protected virtual void InitializeDerivedDataSet() => throw null;
            protected bool IsBinarySerialized(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsInitialized { get => throw null; }
            public void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, params System.Data.DataTable[] tables) => throw null;
            public virtual void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, System.Data.FillErrorEventHandler errorHandler, params System.Data.DataTable[] tables) => throw null;
            public void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, params string[] tables) => throw null;
            public System.Globalization.CultureInfo Locale { get => throw null; set { } }
            public void Merge(System.Data.DataRow[] rows) => throw null;
            public void Merge(System.Data.DataRow[] rows, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public void Merge(System.Data.DataSet dataSet) => throw null;
            public void Merge(System.Data.DataSet dataSet, bool preserveChanges) => throw null;
            public void Merge(System.Data.DataSet dataSet, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public void Merge(System.Data.DataTable table) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public event System.Data.MergeFailedEventHandler MergeFailed;
            public string Namespace { get => throw null; set { } }
            protected virtual void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            protected virtual void OnRemoveRelation(System.Data.DataRelation relation) => throw null;
            protected virtual void OnRemoveTable(System.Data.DataTable table) => throw null;
            public string Prefix { get => throw null; set { } }
            protected void RaisePropertyChanging(string name) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader, System.Data.XmlReadMode mode) => throw null;
            void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
            public void ReadXmlSchema(System.IO.Stream stream) => throw null;
            public void ReadXmlSchema(System.IO.TextReader reader) => throw null;
            public void ReadXmlSchema(string fileName) => throw null;
            public void ReadXmlSchema(System.Xml.XmlReader reader) => throw null;
            protected virtual void ReadXmlSerializable(System.Xml.XmlReader reader) => throw null;
            public virtual void RejectChanges() => throw null;
            public System.Data.DataRelationCollection Relations { get => throw null; }
            public System.Data.SerializationFormat RemotingFormat { get => throw null; set { } }
            public virtual void Reset() => throw null;
            public virtual System.Data.SchemaSerializationMode SchemaSerializationMode { get => throw null; set { } }
            protected virtual bool ShouldSerializeRelations() => throw null;
            protected virtual bool ShouldSerializeTables() => throw null;
            public override System.ComponentModel.ISite Site { get => throw null; set { } }
            public System.Data.DataTableCollection Tables { get => throw null; }
            void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.IO.Stream stream) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.TextWriter writer) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(string fileName) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(string fileName) => throw null;
            public void WriteXmlSchema(string fileName, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
        }
        public enum DataSetDateTime
        {
            Local = 1,
            Unspecified = 2,
            UnspecifiedLocal = 3,
            Utc = 4,
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class DataSysDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public DataSysDescriptionAttribute(string description) => throw null;
            public override string Description { get => throw null; }
        }
        public class DataTable : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IListSource, System.Runtime.Serialization.ISerializable, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.Xml.Serialization.IXmlSerializable
        {
            public void AcceptChanges() => throw null;
            public virtual void BeginInit() => throw null;
            public void BeginLoadData() => throw null;
            public bool CaseSensitive { get => throw null; set { } }
            public System.Data.DataRelationCollection ChildRelations { get => throw null; }
            public void Clear() => throw null;
            public virtual System.Data.DataTable Clone() => throw null;
            public event System.Data.DataColumnChangeEventHandler ColumnChanged;
            public event System.Data.DataColumnChangeEventHandler ColumnChanging;
            public System.Data.DataColumnCollection Columns { get => throw null; }
            public object Compute(string expression, string filter) => throw null;
            public System.Data.ConstraintCollection Constraints { get => throw null; }
            bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
            public System.Data.DataTable Copy() => throw null;
            public System.Data.DataTableReader CreateDataReader() => throw null;
            protected virtual System.Data.DataTable CreateInstance() => throw null;
            public DataTable() => throw null;
            protected DataTable(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DataTable(string tableName) => throw null;
            public DataTable(string tableName, string tableNamespace) => throw null;
            public System.Data.DataSet DataSet { get => throw null; }
            public System.Data.DataView DefaultView { get => throw null; }
            public string DisplayExpression { get => throw null; set { } }
            public virtual void EndInit() => throw null;
            public void EndLoadData() => throw null;
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            protected bool fInitInProgress;
            public System.Data.DataTable GetChanges() => throw null;
            public System.Data.DataTable GetChanges(System.Data.DataRowState rowStates) => throw null;
            public static System.Xml.Schema.XmlSchemaComplexType GetDataTableSchema(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
            public System.Data.DataRow[] GetErrors() => throw null;
            System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
            public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            protected virtual System.Type GetRowType() => throw null;
            protected virtual System.Xml.Schema.XmlSchema GetSchema() => throw null;
            System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
            public bool HasErrors { get => throw null; }
            public void ImportRow(System.Data.DataRow row) => throw null;
            public event System.EventHandler Initialized;
            public bool IsInitialized { get => throw null; }
            public void Load(System.Data.IDataReader reader) => throw null;
            public void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption) => throw null;
            public virtual void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, System.Data.FillErrorEventHandler errorHandler) => throw null;
            public System.Data.DataRow LoadDataRow(object[] values, bool fAcceptChanges) => throw null;
            public System.Data.DataRow LoadDataRow(object[] values, System.Data.LoadOption loadOption) => throw null;
            public System.Globalization.CultureInfo Locale { get => throw null; set { } }
            public void Merge(System.Data.DataTable table) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public int MinimumCapacity { get => throw null; set { } }
            public string Namespace { get => throw null; set { } }
            public System.Data.DataRow NewRow() => throw null;
            protected System.Data.DataRow[] NewRowArray(int size) => throw null;
            protected virtual System.Data.DataRow NewRowFromBuilder(System.Data.DataRowBuilder builder) => throw null;
            protected virtual void OnColumnChanged(System.Data.DataColumnChangeEventArgs e) => throw null;
            protected virtual void OnColumnChanging(System.Data.DataColumnChangeEventArgs e) => throw null;
            protected virtual void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            protected virtual void OnRemoveColumn(System.Data.DataColumn column) => throw null;
            protected virtual void OnRowChanged(System.Data.DataRowChangeEventArgs e) => throw null;
            protected virtual void OnRowChanging(System.Data.DataRowChangeEventArgs e) => throw null;
            protected virtual void OnRowDeleted(System.Data.DataRowChangeEventArgs e) => throw null;
            protected virtual void OnRowDeleting(System.Data.DataRowChangeEventArgs e) => throw null;
            protected virtual void OnTableCleared(System.Data.DataTableClearEventArgs e) => throw null;
            protected virtual void OnTableClearing(System.Data.DataTableClearEventArgs e) => throw null;
            protected virtual void OnTableNewRow(System.Data.DataTableNewRowEventArgs e) => throw null;
            public System.Data.DataRelationCollection ParentRelations { get => throw null; }
            public string Prefix { get => throw null; set { } }
            public System.Data.DataColumn[] PrimaryKey { get => throw null; set { } }
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader) => throw null;
            void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
            public void ReadXmlSchema(System.IO.Stream stream) => throw null;
            public void ReadXmlSchema(System.IO.TextReader reader) => throw null;
            public void ReadXmlSchema(string fileName) => throw null;
            public void ReadXmlSchema(System.Xml.XmlReader reader) => throw null;
            protected virtual void ReadXmlSerializable(System.Xml.XmlReader reader) => throw null;
            public void RejectChanges() => throw null;
            public System.Data.SerializationFormat RemotingFormat { get => throw null; set { } }
            public virtual void Reset() => throw null;
            public event System.Data.DataRowChangeEventHandler RowChanged;
            public event System.Data.DataRowChangeEventHandler RowChanging;
            public event System.Data.DataRowChangeEventHandler RowDeleted;
            public event System.Data.DataRowChangeEventHandler RowDeleting;
            public System.Data.DataRowCollection Rows { get => throw null; }
            public System.Data.DataRow[] Select() => throw null;
            public System.Data.DataRow[] Select(string filterExpression) => throw null;
            public System.Data.DataRow[] Select(string filterExpression, string sort) => throw null;
            public System.Data.DataRow[] Select(string filterExpression, string sort, System.Data.DataViewRowState recordStates) => throw null;
            public override System.ComponentModel.ISite Site { get => throw null; set { } }
            public event System.Data.DataTableClearEventHandler TableCleared;
            public event System.Data.DataTableClearEventHandler TableClearing;
            public string TableName { get => throw null; set { } }
            public event System.Data.DataTableNewRowEventHandler TableNewRow;
            public override string ToString() => throw null;
            void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.IO.Stream stream) => throw null;
            public void WriteXml(System.IO.Stream stream, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.TextWriter writer) => throw null;
            public void WriteXml(System.IO.TextWriter writer, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(string fileName) => throw null;
            public void WriteXml(string fileName, bool writeHierarchy) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, bool writeHierarchy) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(string fileName) => throw null;
            public void WriteXmlSchema(string fileName, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer, bool writeHierarchy) => throw null;
        }
        public sealed class DataTableClearEventArgs : System.EventArgs
        {
            public DataTableClearEventArgs(System.Data.DataTable dataTable) => throw null;
            public System.Data.DataTable Table { get => throw null; }
            public string TableName { get => throw null; }
            public string TableNamespace { get => throw null; }
        }
        public delegate void DataTableClearEventHandler(object sender, System.Data.DataTableClearEventArgs e);
        public sealed class DataTableCollection : System.Data.InternalDataCollectionBase
        {
            public System.Data.DataTable Add() => throw null;
            public void Add(System.Data.DataTable table) => throw null;
            public System.Data.DataTable Add(string name) => throw null;
            public System.Data.DataTable Add(string name, string tableNamespace) => throw null;
            public void AddRange(System.Data.DataTable[] tables) => throw null;
            public bool CanRemove(System.Data.DataTable table) => throw null;
            public void Clear() => throw null;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanged;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanging;
            public bool Contains(string name) => throw null;
            public bool Contains(string name, string tableNamespace) => throw null;
            public void CopyTo(System.Data.DataTable[] array, int index) => throw null;
            public int IndexOf(System.Data.DataTable table) => throw null;
            public int IndexOf(string tableName) => throw null;
            public int IndexOf(string tableName, string tableNamespace) => throw null;
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.DataTable table) => throw null;
            public void Remove(string name) => throw null;
            public void Remove(string name, string tableNamespace) => throw null;
            public void RemoveAt(int index) => throw null;
            public System.Data.DataTable this[int index] { get => throw null; }
            public System.Data.DataTable this[string name] { get => throw null; }
            public System.Data.DataTable this[string name, string tableNamespace] { get => throw null; }
        }
        public static partial class DataTableExtensions
        {
            public static System.Data.DataView AsDataView(this System.Data.DataTable table) => throw null;
            public static System.Data.DataView AsDataView<T>(this System.Data.EnumerableRowCollection<T> source) where T : System.Data.DataRow => throw null;
            public static System.Data.EnumerableRowCollection<System.Data.DataRow> AsEnumerable(this System.Data.DataTable source) => throw null;
            public static System.Data.DataTable CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Data.DataRow => throw null;
            public static void CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source, System.Data.DataTable table, System.Data.LoadOption options) where T : System.Data.DataRow => throw null;
            public static void CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source, System.Data.DataTable table, System.Data.LoadOption options, System.Data.FillErrorEventHandler errorHandler) where T : System.Data.DataRow => throw null;
        }
        public sealed class DataTableNewRowEventArgs : System.EventArgs
        {
            public DataTableNewRowEventArgs(System.Data.DataRow dataRow) => throw null;
            public System.Data.DataRow Row { get => throw null; }
        }
        public delegate void DataTableNewRowEventHandler(object sender, System.Data.DataTableNewRowEventArgs e);
        public sealed class DataTableReader : System.Data.Common.DbDataReader
        {
            public override void Close() => throw null;
            public DataTableReader(System.Data.DataTable dataTable) => throw null;
            public DataTableReader(System.Data.DataTable[] dataTables) => throw null;
            public override int Depth { get => throw null; }
            public override int FieldCount { get => throw null; }
            public override bool GetBoolean(int ordinal) => throw null;
            public override byte GetByte(int ordinal) => throw null;
            public override long GetBytes(int ordinal, long dataIndex, byte[] buffer, int bufferIndex, int length) => throw null;
            public override char GetChar(int ordinal) => throw null;
            public override long GetChars(int ordinal, long dataIndex, char[] buffer, int bufferIndex, int length) => throw null;
            public override string GetDataTypeName(int ordinal) => throw null;
            public override System.DateTime GetDateTime(int ordinal) => throw null;
            public override decimal GetDecimal(int ordinal) => throw null;
            public override double GetDouble(int ordinal) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public override System.Type GetFieldType(int ordinal) => throw null;
            public override float GetFloat(int ordinal) => throw null;
            public override System.Guid GetGuid(int ordinal) => throw null;
            public override short GetInt16(int ordinal) => throw null;
            public override int GetInt32(int ordinal) => throw null;
            public override long GetInt64(int ordinal) => throw null;
            public override string GetName(int ordinal) => throw null;
            public override int GetOrdinal(string name) => throw null;
            public override System.Type GetProviderSpecificFieldType(int ordinal) => throw null;
            public override object GetProviderSpecificValue(int ordinal) => throw null;
            public override int GetProviderSpecificValues(object[] values) => throw null;
            public override System.Data.DataTable GetSchemaTable() => throw null;
            public override string GetString(int ordinal) => throw null;
            public override object GetValue(int ordinal) => throw null;
            public override int GetValues(object[] values) => throw null;
            public override bool HasRows { get => throw null; }
            public override bool IsClosed { get => throw null; }
            public override bool IsDBNull(int ordinal) => throw null;
            public override bool NextResult() => throw null;
            public override bool Read() => throw null;
            public override int RecordsAffected { get => throw null; }
            public override object this[int ordinal] { get => throw null; }
            public override object this[string name] { get => throw null; }
        }
        public class DataView : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IBindingList, System.ComponentModel.IBindingListView, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.ComponentModel.ITypedList
        {
            int System.Collections.IList.Add(object value) => throw null;
            void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            public virtual System.Data.DataRowView AddNew() => throw null;
            object System.ComponentModel.IBindingList.AddNew() => throw null;
            public bool AllowDelete { get => throw null; set { } }
            public bool AllowEdit { get => throw null; set { } }
            bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
            public bool AllowNew { get => throw null; set { } }
            bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
            bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
            public bool ApplyDefaultSort { get => throw null; set { } }
            void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
            void System.ComponentModel.IBindingListView.ApplySort(System.ComponentModel.ListSortDescriptionCollection sorts) => throw null;
            public void BeginInit() => throw null;
            void System.Collections.IList.Clear() => throw null;
            protected void Close() => throw null;
            protected virtual void ColumnCollectionChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public DataView() => throw null;
            public DataView(System.Data.DataTable table) => throw null;
            public DataView(System.Data.DataTable table, string RowFilter, string Sort, System.Data.DataViewRowState RowState) => throw null;
            public System.Data.DataViewManager DataViewManager { get => throw null; }
            public void Delete(int index) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public void EndInit() => throw null;
            public virtual bool Equals(System.Data.DataView view) => throw null;
            string System.ComponentModel.IBindingListView.Filter { get => throw null; set { } }
            public int Find(object key) => throw null;
            public int Find(object[] key) => throw null;
            int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor property, object key) => throw null;
            public System.Data.DataRowView[] FindRows(object key) => throw null;
            public System.Data.DataRowView[] FindRows(object[] key) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ITypedList.GetItemProperties(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
            string System.ComponentModel.ITypedList.GetListName(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
            protected virtual void IndexListChanged(object sender, System.ComponentModel.ListChangedEventArgs e) => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            public event System.EventHandler Initialized;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            public bool IsInitialized { get => throw null; }
            protected bool IsOpen { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.ComponentModel.IBindingList.IsSorted { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int recordIndex] { get => throw null; set { } }
            public event System.ComponentModel.ListChangedEventHandler ListChanged;
            protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
            protected void Open() => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            void System.ComponentModel.IBindingListView.RemoveFilter() => throw null;
            void System.ComponentModel.IBindingList.RemoveIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            void System.ComponentModel.IBindingList.RemoveSort() => throw null;
            protected void Reset() => throw null;
            public virtual string RowFilter { get => throw null; set { } }
            public System.Data.DataViewRowState RowStateFilter { get => throw null; set { } }
            public string Sort { get => throw null; set { } }
            System.ComponentModel.ListSortDescriptionCollection System.ComponentModel.IBindingListView.SortDescriptions { get => throw null; }
            System.ComponentModel.ListSortDirection System.ComponentModel.IBindingList.SortDirection { get => throw null; }
            System.ComponentModel.PropertyDescriptor System.ComponentModel.IBindingList.SortProperty { get => throw null; }
            bool System.ComponentModel.IBindingListView.SupportsAdvancedSorting { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsChangeNotification { get => throw null; }
            bool System.ComponentModel.IBindingListView.SupportsFiltering { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSearching { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSorting { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public System.Data.DataTable Table { get => throw null; set { } }
            public System.Data.DataRowView this[int recordIndex] { get => throw null; }
            public System.Data.DataTable ToTable() => throw null;
            public System.Data.DataTable ToTable(bool distinct, params string[] columnNames) => throw null;
            public System.Data.DataTable ToTable(string tableName) => throw null;
            public System.Data.DataTable ToTable(string tableName, bool distinct, params string[] columnNames) => throw null;
            protected void UpdateIndex() => throw null;
            protected virtual void UpdateIndex(bool force) => throw null;
        }
        public class DataViewManager : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IBindingList, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.ITypedList
        {
            int System.Collections.IList.Add(object value) => throw null;
            void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            object System.ComponentModel.IBindingList.AddNew() => throw null;
            bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
            bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
            bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
            void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
            void System.Collections.IList.Clear() => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            int System.Collections.ICollection.Count { get => throw null; }
            public System.Data.DataView CreateDataView(System.Data.DataTable table) => throw null;
            public DataViewManager() => throw null;
            public DataViewManager(System.Data.DataSet dataSet) => throw null;
            public System.Data.DataSet DataSet { get => throw null; set { } }
            public string DataViewSettingCollectionString { get => throw null; set { } }
            public System.Data.DataViewSettingCollection DataViewSettings { get => throw null; }
            int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor property, object key) => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ITypedList.GetItemProperties(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
            string System.ComponentModel.ITypedList.GetListName(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.ComponentModel.IBindingList.IsSorted { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            public event System.ComponentModel.ListChangedEventHandler ListChanged;
            protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
            protected virtual void RelationCollectionChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            void System.ComponentModel.IBindingList.RemoveIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            void System.ComponentModel.IBindingList.RemoveSort() => throw null;
            System.ComponentModel.ListSortDirection System.ComponentModel.IBindingList.SortDirection { get => throw null; }
            System.ComponentModel.PropertyDescriptor System.ComponentModel.IBindingList.SortProperty { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsChangeNotification { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSearching { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSorting { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            protected virtual void TableCollectionChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) => throw null;
        }
        [System.Flags]
        public enum DataViewRowState
        {
            None = 0,
            Unchanged = 2,
            Added = 4,
            Deleted = 8,
            ModifiedCurrent = 16,
            CurrentRows = 22,
            ModifiedOriginal = 32,
            OriginalRows = 42,
        }
        public class DataViewSetting
        {
            public bool ApplyDefaultSort { get => throw null; set { } }
            public System.Data.DataViewManager DataViewManager { get => throw null; }
            public string RowFilter { get => throw null; set { } }
            public System.Data.DataViewRowState RowStateFilter { get => throw null; set { } }
            public string Sort { get => throw null; set { } }
            public System.Data.DataTable Table { get => throw null; }
        }
        public class DataViewSettingCollection : System.Collections.ICollection, System.Collections.IEnumerable
        {
            public void CopyTo(System.Array ar, int index) => throw null;
            public void CopyTo(System.Data.DataViewSetting[] ar, int index) => throw null;
            public virtual int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public object SyncRoot { get => throw null; }
            public virtual System.Data.DataViewSetting this[System.Data.DataTable table] { get => throw null; set { } }
            public virtual System.Data.DataViewSetting this[int index] { get => throw null; set { } }
            public virtual System.Data.DataViewSetting this[string tableName] { get => throw null; }
        }
        public sealed class DBConcurrencyException : System.SystemException
        {
            public void CopyToRows(System.Data.DataRow[] array) => throw null;
            public void CopyToRows(System.Data.DataRow[] array, int arrayIndex) => throw null;
            public DBConcurrencyException() => throw null;
            public DBConcurrencyException(string message) => throw null;
            public DBConcurrencyException(string message, System.Exception inner) => throw null;
            public DBConcurrencyException(string message, System.Exception inner, System.Data.DataRow[] dataRows) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Data.DataRow Row { get => throw null; set { } }
            public int RowCount { get => throw null; }
        }
        public enum DbType
        {
            AnsiString = 0,
            Binary = 1,
            Byte = 2,
            Boolean = 3,
            Currency = 4,
            Date = 5,
            DateTime = 6,
            Decimal = 7,
            Double = 8,
            Guid = 9,
            Int16 = 10,
            Int32 = 11,
            Int64 = 12,
            Object = 13,
            SByte = 14,
            Single = 15,
            String = 16,
            Time = 17,
            UInt16 = 18,
            UInt32 = 19,
            UInt64 = 20,
            VarNumeric = 21,
            AnsiStringFixedLength = 22,
            StringFixedLength = 23,
            Xml = 25,
            DateTime2 = 26,
            DateTimeOffset = 27,
        }
        public class DeletedRowInaccessibleException : System.Data.DataException
        {
            public DeletedRowInaccessibleException() => throw null;
            protected DeletedRowInaccessibleException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DeletedRowInaccessibleException(string s) => throw null;
            public DeletedRowInaccessibleException(string message, System.Exception innerException) => throw null;
        }
        public class DuplicateNameException : System.Data.DataException
        {
            public DuplicateNameException() => throw null;
            protected DuplicateNameException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DuplicateNameException(string s) => throw null;
            public DuplicateNameException(string message, System.Exception innerException) => throw null;
        }
        public abstract class EnumerableRowCollection : System.Collections.IEnumerable
        {
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        }
        public class EnumerableRowCollection<TRow> : System.Data.EnumerableRowCollection, System.Collections.Generic.IEnumerable<TRow>, System.Collections.IEnumerable
        {
            public System.Collections.Generic.IEnumerator<TRow> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        }
        public static partial class EnumerableRowCollectionExtensions
        {
            public static System.Data.EnumerableRowCollection<TResult> Cast<TResult>(this System.Data.EnumerableRowCollection source) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderBy<TRow, TKey>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderBy<TRow, TKey>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderByDescending<TRow, TKey>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderByDescending<TRow, TKey>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Data.EnumerableRowCollection<S> Select<TRow, S>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, S> selector) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> ThenBy<TRow, TKey>(this System.Data.OrderedEnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> ThenBy<TRow, TKey>(this System.Data.OrderedEnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> ThenByDescending<TRow, TKey>(this System.Data.OrderedEnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector) => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> ThenByDescending<TRow, TKey>(this System.Data.OrderedEnumerableRowCollection<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
            public static System.Data.EnumerableRowCollection<TRow> Where<TRow>(this System.Data.EnumerableRowCollection<TRow> source, System.Func<TRow, bool> predicate) => throw null;
        }
        public class EvaluateException : System.Data.InvalidExpressionException
        {
            public EvaluateException() => throw null;
            protected EvaluateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public EvaluateException(string s) => throw null;
            public EvaluateException(string message, System.Exception innerException) => throw null;
        }
        public class FillErrorEventArgs : System.EventArgs
        {
            public bool Continue { get => throw null; set { } }
            public FillErrorEventArgs(System.Data.DataTable dataTable, object[] values) => throw null;
            public System.Data.DataTable DataTable { get => throw null; }
            public System.Exception Errors { get => throw null; set { } }
            public object[] Values { get => throw null; }
        }
        public delegate void FillErrorEventHandler(object sender, System.Data.FillErrorEventArgs e);
        public class ForeignKeyConstraint : System.Data.Constraint
        {
            public virtual System.Data.AcceptRejectRule AcceptRejectRule { get => throw null; set { } }
            public virtual System.Data.DataColumn[] Columns { get => throw null; }
            public ForeignKeyConstraint(System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public ForeignKeyConstraint(System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public ForeignKeyConstraint(string constraintName, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public ForeignKeyConstraint(string constraintName, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public ForeignKeyConstraint(string constraintName, string parentTableName, string parentTableNamespace, string[] parentColumnNames, string[] childColumnNames, System.Data.AcceptRejectRule acceptRejectRule, System.Data.Rule deleteRule, System.Data.Rule updateRule) => throw null;
            public ForeignKeyConstraint(string constraintName, string parentTableName, string[] parentColumnNames, string[] childColumnNames, System.Data.AcceptRejectRule acceptRejectRule, System.Data.Rule deleteRule, System.Data.Rule updateRule) => throw null;
            public virtual System.Data.Rule DeleteRule { get => throw null; set { } }
            public override bool Equals(object key) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Data.DataColumn[] RelatedColumns { get => throw null; }
            public virtual System.Data.DataTable RelatedTable { get => throw null; }
            public override System.Data.DataTable Table { get => throw null; }
            public virtual System.Data.Rule UpdateRule { get => throw null; set { } }
        }
        public interface IColumnMapping
        {
            string DataSetColumn { get; set; }
            string SourceColumn { get; set; }
        }
        public interface IColumnMappingCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            System.Data.IColumnMapping Add(string sourceColumnName, string dataSetColumnName);
            bool Contains(string sourceColumnName);
            System.Data.IColumnMapping GetByDataSetColumn(string dataSetColumnName);
            int IndexOf(string sourceColumnName);
            void RemoveAt(string sourceColumnName);
            object this[string index] { get; set; }
        }
        public interface IDataAdapter
        {
            int Fill(System.Data.DataSet dataSet);
            System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType);
            System.Data.IDataParameter[] GetFillParameters();
            System.Data.MissingMappingAction MissingMappingAction { get; set; }
            System.Data.MissingSchemaAction MissingSchemaAction { get; set; }
            System.Data.ITableMappingCollection TableMappings { get; }
            int Update(System.Data.DataSet dataSet);
        }
        public interface IDataParameter
        {
            System.Data.DbType DbType { get; set; }
            System.Data.ParameterDirection Direction { get; set; }
            bool IsNullable { get; }
            string ParameterName { get; set; }
            string SourceColumn { get; set; }
            System.Data.DataRowVersion SourceVersion { get; set; }
            object Value { get; set; }
        }
        public interface IDataParameterCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            bool Contains(string parameterName);
            int IndexOf(string parameterName);
            void RemoveAt(string parameterName);
            object this[string parameterName] { get; set; }
        }
        public interface IDataReader : System.Data.IDataRecord, System.IDisposable
        {
            void Close();
            int Depth { get; }
            System.Data.DataTable GetSchemaTable();
            bool IsClosed { get; }
            bool NextResult();
            bool Read();
            int RecordsAffected { get; }
        }
        public interface IDataRecord
        {
            int FieldCount { get; }
            bool GetBoolean(int i);
            byte GetByte(int i);
            long GetBytes(int i, long fieldOffset, byte[] buffer, int bufferoffset, int length);
            char GetChar(int i);
            long GetChars(int i, long fieldoffset, char[] buffer, int bufferoffset, int length);
            System.Data.IDataReader GetData(int i);
            string GetDataTypeName(int i);
            System.DateTime GetDateTime(int i);
            decimal GetDecimal(int i);
            double GetDouble(int i);
            System.Type GetFieldType(int i);
            float GetFloat(int i);
            System.Guid GetGuid(int i);
            short GetInt16(int i);
            int GetInt32(int i);
            long GetInt64(int i);
            string GetName(int i);
            int GetOrdinal(string name);
            string GetString(int i);
            object GetValue(int i);
            int GetValues(object[] values);
            bool IsDBNull(int i);
            object this[int i] { get; }
            object this[string name] { get; }
        }
        public interface IDbCommand : System.IDisposable
        {
            void Cancel();
            string CommandText { get; set; }
            int CommandTimeout { get; set; }
            System.Data.CommandType CommandType { get; set; }
            System.Data.IDbConnection Connection { get; set; }
            System.Data.IDbDataParameter CreateParameter();
            int ExecuteNonQuery();
            System.Data.IDataReader ExecuteReader();
            System.Data.IDataReader ExecuteReader(System.Data.CommandBehavior behavior);
            object ExecuteScalar();
            System.Data.IDataParameterCollection Parameters { get; }
            void Prepare();
            System.Data.IDbTransaction Transaction { get; set; }
            System.Data.UpdateRowSource UpdatedRowSource { get; set; }
        }
        public interface IDbConnection : System.IDisposable
        {
            System.Data.IDbTransaction BeginTransaction();
            System.Data.IDbTransaction BeginTransaction(System.Data.IsolationLevel il);
            void ChangeDatabase(string databaseName);
            void Close();
            string ConnectionString { get; set; }
            int ConnectionTimeout { get; }
            System.Data.IDbCommand CreateCommand();
            string Database { get; }
            void Open();
            System.Data.ConnectionState State { get; }
        }
        public interface IDbDataAdapter : System.Data.IDataAdapter
        {
            System.Data.IDbCommand DeleteCommand { get; set; }
            System.Data.IDbCommand InsertCommand { get; set; }
            System.Data.IDbCommand SelectCommand { get; set; }
            System.Data.IDbCommand UpdateCommand { get; set; }
        }
        public interface IDbDataParameter : System.Data.IDataParameter
        {
            byte Precision { get; set; }
            byte Scale { get; set; }
            int Size { get; set; }
        }
        public interface IDbTransaction : System.IDisposable
        {
            void Commit();
            System.Data.IDbConnection Connection { get; }
            System.Data.IsolationLevel IsolationLevel { get; }
            void Rollback();
        }
        public class InRowChangingEventException : System.Data.DataException
        {
            public InRowChangingEventException() => throw null;
            protected InRowChangingEventException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InRowChangingEventException(string s) => throw null;
            public InRowChangingEventException(string message, System.Exception innerException) => throw null;
        }
        public class InternalDataCollectionBase : System.Collections.ICollection, System.Collections.IEnumerable
        {
            public virtual void CopyTo(System.Array ar, int index) => throw null;
            public virtual int Count { get => throw null; }
            public InternalDataCollectionBase() => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            protected virtual System.Collections.ArrayList List { get => throw null; }
            public object SyncRoot { get => throw null; }
        }
        public class InvalidConstraintException : System.Data.DataException
        {
            public InvalidConstraintException() => throw null;
            protected InvalidConstraintException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidConstraintException(string s) => throw null;
            public InvalidConstraintException(string message, System.Exception innerException) => throw null;
        }
        public class InvalidExpressionException : System.Data.DataException
        {
            public InvalidExpressionException() => throw null;
            protected InvalidExpressionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidExpressionException(string s) => throw null;
            public InvalidExpressionException(string message, System.Exception innerException) => throw null;
        }
        public enum IsolationLevel
        {
            Unspecified = -1,
            Chaos = 16,
            ReadUncommitted = 256,
            ReadCommitted = 4096,
            RepeatableRead = 65536,
            Serializable = 1048576,
            Snapshot = 16777216,
        }
        public interface ITableMapping
        {
            System.Data.IColumnMappingCollection ColumnMappings { get; }
            string DataSetTable { get; set; }
            string SourceTable { get; set; }
        }
        public interface ITableMappingCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            System.Data.ITableMapping Add(string sourceTableName, string dataSetTableName);
            bool Contains(string sourceTableName);
            System.Data.ITableMapping GetByDataSetTable(string dataSetTableName);
            int IndexOf(string sourceTableName);
            void RemoveAt(string sourceTableName);
            object this[string index] { get; set; }
        }
        public enum KeyRestrictionBehavior
        {
            AllowOnly = 0,
            PreventUsage = 1,
        }
        public enum LoadOption
        {
            OverwriteChanges = 1,
            PreserveChanges = 2,
            Upsert = 3,
        }
        public enum MappingType
        {
            Element = 1,
            Attribute = 2,
            SimpleContent = 3,
            Hidden = 4,
        }
        public class MergeFailedEventArgs : System.EventArgs
        {
            public string Conflict { get => throw null; }
            public MergeFailedEventArgs(System.Data.DataTable table, string conflict) => throw null;
            public System.Data.DataTable Table { get => throw null; }
        }
        public delegate void MergeFailedEventHandler(object sender, System.Data.MergeFailedEventArgs e);
        public enum MissingMappingAction
        {
            Passthrough = 1,
            Ignore = 2,
            Error = 3,
        }
        public class MissingPrimaryKeyException : System.Data.DataException
        {
            public MissingPrimaryKeyException() => throw null;
            protected MissingPrimaryKeyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public MissingPrimaryKeyException(string s) => throw null;
            public MissingPrimaryKeyException(string message, System.Exception innerException) => throw null;
        }
        public enum MissingSchemaAction
        {
            Add = 1,
            Ignore = 2,
            Error = 3,
            AddWithKey = 4,
        }
        public class NoNullAllowedException : System.Data.DataException
        {
            public NoNullAllowedException() => throw null;
            protected NoNullAllowedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public NoNullAllowedException(string s) => throw null;
            public NoNullAllowedException(string message, System.Exception innerException) => throw null;
        }
        public sealed class OrderedEnumerableRowCollection<TRow> : System.Data.EnumerableRowCollection<TRow>
        {
        }
        public enum ParameterDirection
        {
            Input = 1,
            Output = 2,
            InputOutput = 3,
            ReturnValue = 6,
        }
        public class PropertyCollection : System.Collections.Hashtable, System.ICloneable
        {
            public override object Clone() => throw null;
            public PropertyCollection() => throw null;
            protected PropertyCollection(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }
        public class ReadOnlyException : System.Data.DataException
        {
            public ReadOnlyException() => throw null;
            protected ReadOnlyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ReadOnlyException(string s) => throw null;
            public ReadOnlyException(string message, System.Exception innerException) => throw null;
        }
        public class RowNotInTableException : System.Data.DataException
        {
            public RowNotInTableException() => throw null;
            protected RowNotInTableException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public RowNotInTableException(string s) => throw null;
            public RowNotInTableException(string message, System.Exception innerException) => throw null;
        }
        public enum Rule
        {
            None = 0,
            Cascade = 1,
            SetNull = 2,
            SetDefault = 3,
        }
        public enum SchemaSerializationMode
        {
            IncludeSchema = 1,
            ExcludeSchema = 2,
        }
        public enum SchemaType
        {
            Source = 1,
            Mapped = 2,
        }
        public enum SerializationFormat
        {
            Xml = 0,
            Binary = 1,
        }
        public enum SqlDbType
        {
            BigInt = 0,
            Binary = 1,
            Bit = 2,
            Char = 3,
            DateTime = 4,
            Decimal = 5,
            Float = 6,
            Image = 7,
            Int = 8,
            Money = 9,
            NChar = 10,
            NText = 11,
            NVarChar = 12,
            Real = 13,
            UniqueIdentifier = 14,
            SmallDateTime = 15,
            SmallInt = 16,
            SmallMoney = 17,
            Text = 18,
            Timestamp = 19,
            TinyInt = 20,
            VarBinary = 21,
            VarChar = 22,
            Variant = 23,
            Xml = 25,
            Udt = 29,
            Structured = 30,
            Date = 31,
            Time = 32,
            DateTime2 = 33,
            DateTimeOffset = 34,
        }
        namespace SqlTypes
        {
            public interface INullable
            {
                bool IsNull { get; }
            }
            public sealed class SqlAlreadyFilledException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlAlreadyFilledException() => throw null;
                public SqlAlreadyFilledException(string message) => throw null;
                public SqlAlreadyFilledException(string message, System.Exception e) => throw null;
            }
            public struct SqlBinary : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlBinary>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBinary Add(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlBinary value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlBinary Concat(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public SqlBinary(byte[] value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlBinary other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public bool IsNull { get => throw null; }
                public int Length { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static readonly System.Data.SqlTypes.SqlBinary Null;
                public static System.Data.SqlTypes.SqlBinary operator +(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static explicit operator byte[](System.Data.SqlTypes.SqlBinary x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBinary(System.Data.SqlTypes.SqlGuid x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlBinary(byte[] x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public byte this[int index] { get => throw null; }
                public System.Data.SqlTypes.SqlGuid ToSqlGuid() => throw null;
                public override string ToString() => throw null;
                public byte[] Value { get => throw null; }
                public static System.Data.SqlTypes.SqlBinary WrapBytes(byte[] bytes) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public struct SqlBoolean : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlBoolean>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean And(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public byte ByteValue { get => throw null; }
                public int CompareTo(System.Data.SqlTypes.SqlBoolean value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlBoolean(bool value) => throw null;
                public SqlBoolean(int value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlBoolean other) => throw null;
                public override bool Equals(object value) => throw null;
                public static readonly System.Data.SqlTypes.SqlBoolean False;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEquals(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public bool IsFalse { get => throw null; }
                public bool IsNull { get => throw null; }
                public bool IsTrue { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEquals(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static readonly System.Data.SqlTypes.SqlBoolean Null;
                public static readonly System.Data.SqlTypes.SqlBoolean One;
                public static System.Data.SqlTypes.SqlBoolean OnesComplement(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator &(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator |(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ^(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static explicit operator bool(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlByte x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBoolean(System.Data.SqlTypes.SqlString x) => throw null;
                public static bool operator false(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlBoolean(bool x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ~(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static bool operator true(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Or(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public static readonly System.Data.SqlTypes.SqlBoolean True;
                public bool Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Xor(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static readonly System.Data.SqlTypes.SqlBoolean Zero;
            }
            public struct SqlByte : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlByte>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlByte Add(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte BitwiseAnd(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte BitwiseOr(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlByte value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlByte(byte value) => throw null;
                public static System.Data.SqlTypes.SqlByte Divide(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlByte other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static readonly System.Data.SqlTypes.SqlByte MaxValue;
                public static readonly System.Data.SqlTypes.SqlByte MinValue;
                public static System.Data.SqlTypes.SqlByte Mod(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Modulus(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Multiply(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static readonly System.Data.SqlTypes.SqlByte Null;
                public static System.Data.SqlTypes.SqlByte OnesComplement(System.Data.SqlTypes.SqlByte x) => throw null;
                public static System.Data.SqlTypes.SqlByte operator +(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator &(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator |(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator /(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator ^(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator byte(System.Data.SqlTypes.SqlByte x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlByte(byte x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator %(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator *(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator ~(System.Data.SqlTypes.SqlByte x) => throw null;
                public static System.Data.SqlTypes.SqlByte operator -(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlByte Subtract(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public byte Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlByte Xor(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static readonly System.Data.SqlTypes.SqlByte Zero;
            }
            public sealed class SqlBytes : System.Data.SqlTypes.INullable, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
            {
                public byte[] Buffer { get => throw null; }
                public SqlBytes() => throw null;
                public SqlBytes(byte[] buffer) => throw null;
                public SqlBytes(System.Data.SqlTypes.SqlBinary value) => throw null;
                public SqlBytes(System.IO.Stream s) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public long Length { get => throw null; }
                public long MaxLength { get => throw null; }
                public static System.Data.SqlTypes.SqlBytes Null { get => throw null; }
                public static explicit operator System.Data.SqlTypes.SqlBytes(System.Data.SqlTypes.SqlBinary value) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBinary(System.Data.SqlTypes.SqlBytes value) => throw null;
                public long Read(long offset, byte[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public void SetLength(long value) => throw null;
                public void SetNull() => throw null;
                public System.Data.SqlTypes.StorageState Storage { get => throw null; }
                public System.IO.Stream Stream { get => throw null; set { } }
                public byte this[long offset] { get => throw null; set { } }
                public System.Data.SqlTypes.SqlBinary ToSqlBinary() => throw null;
                public byte[] Value { get => throw null; }
                public void Write(long offset, byte[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public sealed class SqlChars : System.Data.SqlTypes.INullable, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
            {
                public char[] Buffer { get => throw null; }
                public SqlChars() => throw null;
                public SqlChars(char[] buffer) => throw null;
                public SqlChars(System.Data.SqlTypes.SqlString value) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public long Length { get => throw null; }
                public long MaxLength { get => throw null; }
                public static System.Data.SqlTypes.SqlChars Null { get => throw null; }
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlChars value) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlChars(System.Data.SqlTypes.SqlString value) => throw null;
                public long Read(long offset, char[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public void SetLength(long value) => throw null;
                public void SetNull() => throw null;
                public System.Data.SqlTypes.StorageState Storage { get => throw null; }
                public char this[long offset] { get => throw null; set { } }
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public char[] Value { get => throw null; }
                public void Write(long offset, char[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            [System.Flags]
            public enum SqlCompareOptions
            {
                None = 0,
                IgnoreCase = 1,
                IgnoreNonSpace = 2,
                IgnoreKanaType = 8,
                IgnoreWidth = 16,
                BinarySort2 = 16384,
                BinarySort = 32768,
            }
            public struct SqlDateTime : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlDateTime>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlDateTime Add(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDateTime value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlDateTime(System.DateTime value) => throw null;
                public SqlDateTime(int dayTicks, int timeTicks) => throw null;
                public SqlDateTime(int year, int month, int day) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second, double millisecond) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second, int bilisecond) => throw null;
                public int DayTicks { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlDateTime other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static readonly System.Data.SqlTypes.SqlDateTime MaxValue;
                public static readonly System.Data.SqlTypes.SqlDateTime MinValue;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static readonly System.Data.SqlTypes.SqlDateTime Null;
                public static System.Data.SqlTypes.SqlDateTime operator +(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static explicit operator System.DateTime(System.Data.SqlTypes.SqlDateTime x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDateTime(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDateTime(System.DateTime value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlDateTime operator -(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public static System.Data.SqlTypes.SqlDateTime Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static readonly int SQLTicksPerHour;
                public static readonly int SQLTicksPerMinute;
                public static readonly int SQLTicksPerSecond;
                public static System.Data.SqlTypes.SqlDateTime Subtract(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public int TimeTicks { get => throw null; }
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public System.DateTime Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public struct SqlDecimal : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlDecimal>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlDecimal Abs(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Add(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal AdjustScale(System.Data.SqlTypes.SqlDecimal n, int digits, bool fRound) => throw null;
                public byte[] BinData { get => throw null; }
                public static System.Data.SqlTypes.SqlDecimal Ceiling(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDecimal value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlDecimal ConvertToPrecScale(System.Data.SqlTypes.SqlDecimal n, int precision, int scale) => throw null;
                public SqlDecimal(byte bPrecision, byte bScale, bool fPositive, int data1, int data2, int data3, int data4) => throw null;
                public SqlDecimal(byte bPrecision, byte bScale, bool fPositive, int[] bits) => throw null;
                public SqlDecimal(decimal value) => throw null;
                public SqlDecimal(double dVal) => throw null;
                public SqlDecimal(int value) => throw null;
                public SqlDecimal(long value) => throw null;
                public int[] Data { get => throw null; }
                public static System.Data.SqlTypes.SqlDecimal Divide(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlDecimal other) => throw null;
                public override bool Equals(object value) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Floor(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public bool IsNull { get => throw null; }
                public bool IsPositive { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static readonly byte MaxPrecision;
                public static readonly byte MaxScale;
                public static readonly System.Data.SqlTypes.SqlDecimal MaxValue;
                public static readonly System.Data.SqlTypes.SqlDecimal MinValue;
                public static System.Data.SqlTypes.SqlDecimal Multiply(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static readonly System.Data.SqlTypes.SqlDecimal Null;
                public static System.Data.SqlTypes.SqlDecimal operator +(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator /(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator decimal(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlString x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(double x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(decimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(long x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator *(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator -(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator -(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Parse(string s) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Power(System.Data.SqlTypes.SqlDecimal n, double exp) => throw null;
                public byte Precision { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Round(System.Data.SqlTypes.SqlDecimal n, int position) => throw null;
                public byte Scale { get => throw null; }
                public static System.Data.SqlTypes.SqlInt32 Sign(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Subtract(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public double ToDouble() => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public static System.Data.SqlTypes.SqlDecimal Truncate(System.Data.SqlTypes.SqlDecimal n, int position) => throw null;
                public decimal Value { get => throw null; }
                public int WriteTdsValue(System.Span<uint> destination) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public struct SqlDouble : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlDouble>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlDouble Add(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDouble value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlDouble(double value) => throw null;
                public static System.Data.SqlTypes.SqlDouble Divide(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlDouble other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static readonly System.Data.SqlTypes.SqlDouble MaxValue;
                public static readonly System.Data.SqlTypes.SqlDouble MinValue;
                public static System.Data.SqlTypes.SqlDouble Multiply(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static readonly System.Data.SqlTypes.SqlDouble Null;
                public static System.Data.SqlTypes.SqlDouble operator +(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator /(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator double(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(double x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator *(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator -(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator -(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static System.Data.SqlTypes.SqlDouble Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlDouble Subtract(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public double Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static readonly System.Data.SqlTypes.SqlDouble Zero;
            }
            public struct SqlGuid : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlGuid>, System.Data.SqlTypes.INullable, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
            {
                public int CompareTo(System.Data.SqlTypes.SqlGuid value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlGuid(byte[] value) => throw null;
                public SqlGuid(System.Guid g) => throw null;
                public SqlGuid(int a, short b, short c, byte d, byte e, byte f, byte g, byte h, byte i, byte j, byte k) => throw null;
                public SqlGuid(string s) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlGuid other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static readonly System.Data.SqlTypes.SqlGuid Null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlGuid(System.Data.SqlTypes.SqlBinary x) => throw null;
                public static explicit operator System.Guid(System.Data.SqlTypes.SqlGuid x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlGuid(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlGuid(System.Guid x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlGuid Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public byte[] ToByteArray() => throw null;
                public System.Data.SqlTypes.SqlBinary ToSqlBinary() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public System.Guid Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public struct SqlInt16 : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlInt16>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlInt16 Add(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 BitwiseAnd(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 BitwiseOr(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt16 value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlInt16(short value) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Divide(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlInt16 other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt16 MaxValue;
                public static readonly System.Data.SqlTypes.SqlInt16 MinValue;
                public static System.Data.SqlTypes.SqlInt16 Mod(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Modulus(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Multiply(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt16 Null;
                public static System.Data.SqlTypes.SqlInt16 OnesComplement(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator +(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator &(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator |(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator /(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator ^(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator short(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt16(short x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator %(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator *(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator ~(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator -(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator -(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Subtract(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public short Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Xor(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt16 Zero;
            }
            public struct SqlInt32 : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlInt32>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlInt32 Add(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 BitwiseAnd(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 BitwiseOr(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt32 value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlInt32(int value) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Divide(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlInt32 other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt32 MaxValue;
                public static readonly System.Data.SqlTypes.SqlInt32 MinValue;
                public static System.Data.SqlTypes.SqlInt32 Mod(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Modulus(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Multiply(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt32 Null;
                public static System.Data.SqlTypes.SqlInt32 OnesComplement(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator +(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator &(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator |(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator /(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator ^(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator int(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(int x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator %(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator *(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator ~(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator -(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator -(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Subtract(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public int Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Xor(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt32 Zero;
            }
            public struct SqlInt64 : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlInt64>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlInt64 Add(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 BitwiseAnd(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 BitwiseOr(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt64 value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlInt64(long value) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Divide(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlInt64 other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt64 MaxValue;
                public static readonly System.Data.SqlTypes.SqlInt64 MinValue;
                public static System.Data.SqlTypes.SqlInt64 Mod(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Modulus(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Multiply(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt64 Null;
                public static System.Data.SqlTypes.SqlInt64 OnesComplement(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator +(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator &(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator |(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator /(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator ^(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator long(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(long x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator %(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator *(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator ~(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator -(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator -(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Subtract(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public long Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Xor(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static readonly System.Data.SqlTypes.SqlInt64 Zero;
            }
            public struct SqlMoney : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlMoney>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlMoney Add(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlMoney value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlMoney(decimal value) => throw null;
                public SqlMoney(double value) => throw null;
                public SqlMoney(int value) => throw null;
                public SqlMoney(long value) => throw null;
                public static System.Data.SqlTypes.SqlMoney Divide(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlMoney other) => throw null;
                public override bool Equals(object value) => throw null;
                public static System.Data.SqlTypes.SqlMoney FromTdsValue(long value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public long GetTdsValue() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static readonly System.Data.SqlTypes.SqlMoney MaxValue;
                public static readonly System.Data.SqlTypes.SqlMoney MinValue;
                public static System.Data.SqlTypes.SqlMoney Multiply(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static readonly System.Data.SqlTypes.SqlMoney Null;
                public static System.Data.SqlTypes.SqlMoney operator +(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator /(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator decimal(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlString x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(double x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(decimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(long x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator *(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator -(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator -(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static System.Data.SqlTypes.SqlMoney Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlMoney Subtract(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public decimal ToDecimal() => throw null;
                public double ToDouble() => throw null;
                public int ToInt32() => throw null;
                public long ToInt64() => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public decimal Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static readonly System.Data.SqlTypes.SqlMoney Zero;
            }
            public sealed class SqlNotFilledException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlNotFilledException() => throw null;
                public SqlNotFilledException(string message) => throw null;
                public SqlNotFilledException(string message, System.Exception e) => throw null;
            }
            public sealed class SqlNullValueException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlNullValueException() => throw null;
                public SqlNullValueException(string message) => throw null;
                public SqlNullValueException(string message, System.Exception e) => throw null;
            }
            public struct SqlSingle : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlSingle>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlSingle Add(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlSingle value) => throw null;
                public int CompareTo(object value) => throw null;
                public SqlSingle(double value) => throw null;
                public SqlSingle(float value) => throw null;
                public static System.Data.SqlTypes.SqlSingle Divide(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlSingle other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static readonly System.Data.SqlTypes.SqlSingle MaxValue;
                public static readonly System.Data.SqlTypes.SqlSingle MinValue;
                public static System.Data.SqlTypes.SqlSingle Multiply(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static readonly System.Data.SqlTypes.SqlSingle Null;
                public static System.Data.SqlTypes.SqlSingle operator +(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator /(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator float(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(float x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator *(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator -(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator -(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static System.Data.SqlTypes.SqlSingle Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlSingle Subtract(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public float Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static readonly System.Data.SqlTypes.SqlSingle Zero;
            }
            public struct SqlString : System.IComparable, System.IEquatable<System.Data.SqlTypes.SqlString>, System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlString Add(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static readonly int BinarySort;
                public static readonly int BinarySort2;
                public System.Data.SqlTypes.SqlString Clone() => throw null;
                public System.Globalization.CompareInfo CompareInfo { get => throw null; }
                public static System.Globalization.CompareOptions CompareOptionsFromSqlCompareOptions(System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlString value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlString Concat(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, byte[] data) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, byte[] data, bool fUnicode) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, byte[] data, int index, int count) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, byte[] data, int index, int count, bool fUnicode) => throw null;
                public SqlString(string data) => throw null;
                public SqlString(string data, int lcid) => throw null;
                public SqlString(string data, int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
                public System.Globalization.CultureInfo CultureInfo { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public bool Equals(System.Data.SqlTypes.SqlString other) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                public byte[] GetNonUnicodeBytes() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public byte[] GetUnicodeBytes() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static readonly int IgnoreCase;
                public static readonly int IgnoreKanaType;
                public static readonly int IgnoreNonSpace;
                public static readonly int IgnoreWidth;
                public bool IsNull { get => throw null; }
                public int LCID { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static readonly System.Data.SqlTypes.SqlString Null;
                public static System.Data.SqlTypes.SqlString operator +(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlByte x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlDateTime x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlGuid x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator string(System.Data.SqlTypes.SqlString x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlString(string x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public System.Data.SqlTypes.SqlCompareOptions SqlCompareOptions { get => throw null; }
                public System.Data.SqlTypes.SqlBoolean ToSqlBoolean() => throw null;
                public System.Data.SqlTypes.SqlByte ToSqlByte() => throw null;
                public System.Data.SqlTypes.SqlDateTime ToSqlDateTime() => throw null;
                public System.Data.SqlTypes.SqlDecimal ToSqlDecimal() => throw null;
                public System.Data.SqlTypes.SqlDouble ToSqlDouble() => throw null;
                public System.Data.SqlTypes.SqlGuid ToSqlGuid() => throw null;
                public System.Data.SqlTypes.SqlInt16 ToSqlInt16() => throw null;
                public System.Data.SqlTypes.SqlInt32 ToSqlInt32() => throw null;
                public System.Data.SqlTypes.SqlInt64 ToSqlInt64() => throw null;
                public System.Data.SqlTypes.SqlMoney ToSqlMoney() => throw null;
                public System.Data.SqlTypes.SqlSingle ToSqlSingle() => throw null;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public sealed class SqlTruncateException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlTruncateException() => throw null;
                public SqlTruncateException(string message) => throw null;
                public SqlTruncateException(string message, System.Exception e) => throw null;
            }
            public class SqlTypeException : System.SystemException
            {
                public SqlTypeException() => throw null;
                protected SqlTypeException(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext sc) => throw null;
                public SqlTypeException(string message) => throw null;
                public SqlTypeException(string message, System.Exception e) => throw null;
            }
            public sealed class SqlXml : System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public System.Xml.XmlReader CreateReader() => throw null;
                public SqlXml() => throw null;
                public SqlXml(System.IO.Stream value) => throw null;
                public SqlXml(System.Xml.XmlReader value) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlXml Null { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public string Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }
            public enum StorageState
            {
                Buffer = 0,
                Stream = 1,
                UnmanagedBuffer = 2,
            }
        }
        public sealed class StateChangeEventArgs : System.EventArgs
        {
            public StateChangeEventArgs(System.Data.ConnectionState originalState, System.Data.ConnectionState currentState) => throw null;
            public System.Data.ConnectionState CurrentState { get => throw null; }
            public System.Data.ConnectionState OriginalState { get => throw null; }
        }
        public delegate void StateChangeEventHandler(object sender, System.Data.StateChangeEventArgs e);
        public sealed class StatementCompletedEventArgs : System.EventArgs
        {
            public StatementCompletedEventArgs(int recordCount) => throw null;
            public int RecordCount { get => throw null; }
        }
        public delegate void StatementCompletedEventHandler(object sender, System.Data.StatementCompletedEventArgs e);
        public enum StatementType
        {
            Select = 0,
            Insert = 1,
            Update = 2,
            Delete = 3,
            Batch = 4,
        }
        public class StrongTypingException : System.Data.DataException
        {
            public StrongTypingException() => throw null;
            protected StrongTypingException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public StrongTypingException(string message) => throw null;
            public StrongTypingException(string s, System.Exception innerException) => throw null;
        }
        public class SyntaxErrorException : System.Data.InvalidExpressionException
        {
            public SyntaxErrorException() => throw null;
            protected SyntaxErrorException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SyntaxErrorException(string s) => throw null;
            public SyntaxErrorException(string message, System.Exception innerException) => throw null;
        }
        public abstract class TypedTableBase<T> : System.Data.DataTable, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable where T : System.Data.DataRow
        {
            public System.Data.EnumerableRowCollection<TResult> Cast<TResult>() => throw null;
            protected TypedTableBase() => throw null;
            protected TypedTableBase(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        }
        public static partial class TypedTableBaseExtensions
        {
            public static System.Data.EnumerableRowCollection<TRow> AsEnumerable<TRow>(this System.Data.TypedTableBase<TRow> source) where TRow : System.Data.DataRow => throw null;
            public static TRow ElementAtOrDefault<TRow>(this System.Data.TypedTableBase<TRow> source, int index) where TRow : System.Data.DataRow => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderBy<TRow, TKey>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, TKey> keySelector) where TRow : System.Data.DataRow => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderBy<TRow, TKey>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) where TRow : System.Data.DataRow => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderByDescending<TRow, TKey>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, TKey> keySelector) where TRow : System.Data.DataRow => throw null;
            public static System.Data.OrderedEnumerableRowCollection<TRow> OrderByDescending<TRow, TKey>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, TKey> keySelector, System.Collections.Generic.IComparer<TKey> comparer) where TRow : System.Data.DataRow => throw null;
            public static System.Data.EnumerableRowCollection<S> Select<TRow, S>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, S> selector) where TRow : System.Data.DataRow => throw null;
            public static System.Data.EnumerableRowCollection<TRow> Where<TRow>(this System.Data.TypedTableBase<TRow> source, System.Func<TRow, bool> predicate) where TRow : System.Data.DataRow => throw null;
        }
        public class UniqueConstraint : System.Data.Constraint
        {
            public virtual System.Data.DataColumn[] Columns { get => throw null; }
            public UniqueConstraint(System.Data.DataColumn column) => throw null;
            public UniqueConstraint(System.Data.DataColumn column, bool isPrimaryKey) => throw null;
            public UniqueConstraint(System.Data.DataColumn[] columns) => throw null;
            public UniqueConstraint(System.Data.DataColumn[] columns, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn column) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn column, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn[] columns) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn[] columns, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, string[] columnNames, bool isPrimaryKey) => throw null;
            public override bool Equals(object key2) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsPrimaryKey { get => throw null; }
            public override System.Data.DataTable Table { get => throw null; }
        }
        public enum UpdateRowSource
        {
            None = 0,
            OutputParameters = 1,
            FirstReturnedRecord = 2,
            Both = 3,
        }
        public enum UpdateStatus
        {
            Continue = 0,
            ErrorsOccurred = 1,
            SkipCurrentRow = 2,
            SkipAllRemainingRows = 3,
        }
        public class VersionNotFoundException : System.Data.DataException
        {
            public VersionNotFoundException() => throw null;
            protected VersionNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public VersionNotFoundException(string s) => throw null;
            public VersionNotFoundException(string message, System.Exception innerException) => throw null;
        }
        public enum XmlReadMode
        {
            Auto = 0,
            ReadSchema = 1,
            IgnoreSchema = 2,
            InferSchema = 3,
            DiffGram = 4,
            Fragment = 5,
            InferTypedSchema = 6,
        }
        public enum XmlWriteMode
        {
            WriteSchema = 0,
            IgnoreSchema = 1,
            DiffGram = 2,
        }
    }
    namespace Xml
    {
        public class XmlDataDocument : System.Xml.XmlDocument
        {
            public override System.Xml.XmlNode CloneNode(bool deep) => throw null;
            public override System.Xml.XmlElement CreateElement(string prefix, string localName, string namespaceURI) => throw null;
            public override System.Xml.XmlEntityReference CreateEntityReference(string name) => throw null;
            protected override System.Xml.XPath.XPathNavigator CreateNavigator(System.Xml.XmlNode node) => throw null;
            public XmlDataDocument() => throw null;
            public XmlDataDocument(System.Data.DataSet dataset) => throw null;
            public System.Data.DataSet DataSet { get => throw null; }
            public override System.Xml.XmlElement GetElementById(string elemId) => throw null;
            public System.Xml.XmlElement GetElementFromRow(System.Data.DataRow r) => throw null;
            public override System.Xml.XmlNodeList GetElementsByTagName(string name) => throw null;
            public System.Data.DataRow GetRowFromElement(System.Xml.XmlElement e) => throw null;
            public override void Load(System.IO.Stream inStream) => throw null;
            public override void Load(System.IO.TextReader txtReader) => throw null;
            public override void Load(string filename) => throw null;
            public override void Load(System.Xml.XmlReader reader) => throw null;
        }
    }
}
