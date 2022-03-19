// This file contains auto-generated code.

namespace System
{
    namespace Data
    {
        // Generated from `System.Data.AcceptRejectRule` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum AcceptRejectRule
        {
            Cascade,
            None,
        }

        // Generated from `System.Data.CommandBehavior` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum CommandBehavior
        {
            CloseConnection,
            Default,
            KeyInfo,
            SchemaOnly,
            SequentialAccess,
            SingleResult,
            SingleRow,
        }

        // Generated from `System.Data.CommandType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CommandType
        {
            StoredProcedure,
            TableDirect,
            Text,
        }

        // Generated from `System.Data.ConflictOption` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ConflictOption
        {
            CompareAllSearchableValues,
            CompareRowVersion,
            OverwriteChanges,
        }

        // Generated from `System.Data.ConnectionState` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum ConnectionState
        {
            Broken,
            Closed,
            Connecting,
            Executing,
            Fetching,
            Open,
        }

        // Generated from `System.Data.Constraint` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class Constraint
        {
            protected void CheckStateForProperty() => throw null;
            internal Constraint() => throw null;
            public virtual string ConstraintName { get => throw null; set => throw null; }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            protected internal void SetDataSet(System.Data.DataSet dataSet) => throw null;
            public abstract System.Data.DataTable Table { get; }
            public override string ToString() => throw null;
            protected virtual System.Data.DataSet _DataSet { get => throw null; }
        }

        // Generated from `System.Data.ConstraintCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ConstraintCollection : System.Data.InternalDataCollectionBase
        {
            public void Add(System.Data.Constraint constraint) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn primaryKeyColumn, System.Data.DataColumn foreignKeyColumn) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn column, bool primaryKey) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn[] primaryKeyColumns, System.Data.DataColumn[] foreignKeyColumns) => throw null;
            public System.Data.Constraint Add(string name, System.Data.DataColumn[] columns, bool primaryKey) => throw null;
            public void AddRange(System.Data.Constraint[] constraints) => throw null;
            public bool CanRemove(System.Data.Constraint constraint) => throw null;
            public void Clear() => throw null;
            public event System.ComponentModel.CollectionChangeEventHandler CollectionChanged;
            public bool Contains(string name) => throw null;
            public void CopyTo(System.Data.Constraint[] array, int index) => throw null;
            public int IndexOf(System.Data.Constraint constraint) => throw null;
            public int IndexOf(string constraintName) => throw null;
            public System.Data.Constraint this[int index] { get => throw null; }
            public System.Data.Constraint this[string name] { get => throw null; }
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.Constraint constraint) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Data.ConstraintException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ConstraintException : System.Data.DataException
        {
            public ConstraintException() => throw null;
            protected ConstraintException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ConstraintException(string s) => throw null;
            public ConstraintException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.DBConcurrencyException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DBConcurrencyException : System.SystemException
        {
            public void CopyToRows(System.Data.DataRow[] array) => throw null;
            public void CopyToRows(System.Data.DataRow[] array, int arrayIndex) => throw null;
            public DBConcurrencyException() => throw null;
            public DBConcurrencyException(string message) => throw null;
            public DBConcurrencyException(string message, System.Exception inner) => throw null;
            public DBConcurrencyException(string message, System.Exception inner, System.Data.DataRow[] dataRows) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Data.DataRow Row { get => throw null; set => throw null; }
            public int RowCount { get => throw null; }
        }

        // Generated from `System.Data.DataColumn` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataColumn : System.ComponentModel.MarshalByValueComponent
        {
            public bool AllowDBNull { get => throw null; set => throw null; }
            public bool AutoIncrement { get => throw null; set => throw null; }
            public System.Int64 AutoIncrementSeed { get => throw null; set => throw null; }
            public System.Int64 AutoIncrementStep { get => throw null; set => throw null; }
            public string Caption { get => throw null; set => throw null; }
            protected internal void CheckNotAllowNull() => throw null;
            protected void CheckUnique() => throw null;
            public virtual System.Data.MappingType ColumnMapping { get => throw null; set => throw null; }
            public string ColumnName { get => throw null; set => throw null; }
            public DataColumn() => throw null;
            public DataColumn(string columnName) => throw null;
            public DataColumn(string columnName, System.Type dataType) => throw null;
            public DataColumn(string columnName, System.Type dataType, string expr) => throw null;
            public DataColumn(string columnName, System.Type dataType, string expr, System.Data.MappingType type) => throw null;
            public System.Type DataType { get => throw null; set => throw null; }
            public System.Data.DataSetDateTime DateTimeMode { get => throw null; set => throw null; }
            public object DefaultValue { get => throw null; set => throw null; }
            public string Expression { get => throw null; set => throw null; }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            public int MaxLength { get => throw null; set => throw null; }
            public string Namespace { get => throw null; set => throw null; }
            protected virtual void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            public int Ordinal { get => throw null; }
            public string Prefix { get => throw null; set => throw null; }
            protected internal void RaisePropertyChanging(string name) => throw null;
            public bool ReadOnly { get => throw null; set => throw null; }
            public void SetOrdinal(int ordinal) => throw null;
            public System.Data.DataTable Table { get => throw null; }
            public override string ToString() => throw null;
            public bool Unique { get => throw null; set => throw null; }
        }

        // Generated from `System.Data.DataColumnChangeEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataColumnChangeEventArgs : System.EventArgs
        {
            public System.Data.DataColumn Column { get => throw null; }
            public DataColumnChangeEventArgs(System.Data.DataRow row, System.Data.DataColumn column, object value) => throw null;
            public object ProposedValue { get => throw null; set => throw null; }
            public System.Data.DataRow Row { get => throw null; }
        }

        // Generated from `System.Data.DataColumnChangeEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DataColumnChangeEventHandler(object sender, System.Data.DataColumnChangeEventArgs e);

        // Generated from `System.Data.DataColumnCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataColumnCollection : System.Data.InternalDataCollectionBase
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
            public System.Data.DataColumn this[int index] { get => throw null; }
            public System.Data.DataColumn this[string name] { get => throw null; }
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.DataColumn column) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Data.DataException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataException : System.SystemException
        {
            public DataException() => throw null;
            protected DataException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DataException(string s) => throw null;
            public DataException(string s, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.DataReaderExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class DataReaderExtensions
        {
            public static bool GetBoolean(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Byte GetByte(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Int64 GetBytes(this System.Data.Common.DbDataReader reader, string name, System.Int64 dataOffset, System.Byte[] buffer, int bufferOffset, int length) => throw null;
            public static System.Char GetChar(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Int64 GetChars(this System.Data.Common.DbDataReader reader, string name, System.Int64 dataOffset, System.Char[] buffer, int bufferOffset, int length) => throw null;
            public static System.Data.Common.DbDataReader GetData(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static string GetDataTypeName(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.DateTime GetDateTime(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Decimal GetDecimal(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static double GetDouble(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Type GetFieldType(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static T GetFieldValue<T>(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(this System.Data.Common.DbDataReader reader, string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public static float GetFloat(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Guid GetGuid(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Int16 GetInt16(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static int GetInt32(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Int64 GetInt64(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Type GetProviderSpecificFieldType(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static object GetProviderSpecificValue(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.IO.Stream GetStream(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static string GetString(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.IO.TextReader GetTextReader(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static object GetValue(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static bool IsDBNull(this System.Data.Common.DbDataReader reader, string name) => throw null;
            public static System.Threading.Tasks.Task<bool> IsDBNullAsync(this System.Data.Common.DbDataReader reader, string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `System.Data.DataRelation` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public DataRelation(string relationName, string parentTableName, string childTableName, string[] parentColumnNames, string[] childColumnNames, bool nested) => throw null;
            public DataRelation(string relationName, string parentTableName, string parentTableNamespace, string childTableName, string childTableNamespace, string[] parentColumnNames, string[] childColumnNames, bool nested) => throw null;
            public virtual System.Data.DataSet DataSet { get => throw null; }
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
            public virtual bool Nested { get => throw null; set => throw null; }
            protected internal void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            public virtual System.Data.DataColumn[] ParentColumns { get => throw null; }
            public virtual System.Data.UniqueConstraint ParentKeyConstraint { get => throw null; }
            public virtual System.Data.DataTable ParentTable { get => throw null; }
            protected internal void RaisePropertyChanging(string name) => throw null;
            public virtual string RelationName { get => throw null; set => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Data.DataRelationCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public abstract System.Data.DataRelation this[int index] { get; }
            public abstract System.Data.DataRelation this[string name] { get; }
            protected virtual void OnCollectionChanged(System.ComponentModel.CollectionChangeEventArgs ccevent) => throw null;
            protected virtual void OnCollectionChanging(System.ComponentModel.CollectionChangeEventArgs ccevent) => throw null;
            public void Remove(System.Data.DataRelation relation) => throw null;
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
            protected virtual void RemoveCore(System.Data.DataRelation relation) => throw null;
        }

        // Generated from `System.Data.DataRow` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataRow
        {
            public void AcceptChanges() => throw null;
            public void BeginEdit() => throw null;
            public void CancelEdit() => throw null;
            public void ClearErrors() => throw null;
            protected internal DataRow(System.Data.DataRowBuilder builder) => throw null;
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
            public object[] ItemArray { get => throw null; set => throw null; }
            public object this[System.Data.DataColumn column, System.Data.DataRowVersion version] { get => throw null; }
            public object this[System.Data.DataColumn column] { get => throw null; set => throw null; }
            public object this[int columnIndex, System.Data.DataRowVersion version] { get => throw null; }
            public object this[int columnIndex] { get => throw null; set => throw null; }
            public object this[string columnName, System.Data.DataRowVersion version] { get => throw null; }
            public object this[string columnName] { get => throw null; set => throw null; }
            public void RejectChanges() => throw null;
            public string RowError { get => throw null; set => throw null; }
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
        }

        // Generated from `System.Data.DataRowAction` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum DataRowAction
        {
            Add,
            Change,
            ChangeCurrentAndOriginal,
            ChangeOriginal,
            Commit,
            Delete,
            Nothing,
            Rollback,
        }

        // Generated from `System.Data.DataRowBuilder` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataRowBuilder
        {
        }

        // Generated from `System.Data.DataRowChangeEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataRowChangeEventArgs : System.EventArgs
        {
            public System.Data.DataRowAction Action { get => throw null; }
            public DataRowChangeEventArgs(System.Data.DataRow row, System.Data.DataRowAction action) => throw null;
            public System.Data.DataRow Row { get => throw null; }
        }

        // Generated from `System.Data.DataRowChangeEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DataRowChangeEventHandler(object sender, System.Data.DataRowChangeEventArgs e);

        // Generated from `System.Data.DataRowCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataRowCollection : System.Data.InternalDataCollectionBase
        {
            public void Add(System.Data.DataRow row) => throw null;
            public System.Data.DataRow Add(params object[] values) => throw null;
            public void Clear() => throw null;
            public bool Contains(object[] keys) => throw null;
            public bool Contains(object key) => throw null;
            public override void CopyTo(System.Array ar, int index) => throw null;
            public void CopyTo(System.Data.DataRow[] array, int index) => throw null;
            public override int Count { get => throw null; }
            public System.Data.DataRow Find(object[] keys) => throw null;
            public System.Data.DataRow Find(object key) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public int IndexOf(System.Data.DataRow row) => throw null;
            public void InsertAt(System.Data.DataRow row, int pos) => throw null;
            public System.Data.DataRow this[int index] { get => throw null; }
            public void Remove(System.Data.DataRow row) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Data.DataRowComparer` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class DataRowComparer
        {
            public static System.Data.DataRowComparer<System.Data.DataRow> Default { get => throw null; }
        }

        // Generated from `System.Data.DataRowComparer<>` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataRowComparer<TRow> : System.Collections.Generic.IEqualityComparer<TRow> where TRow : System.Data.DataRow
        {
            public static System.Data.DataRowComparer<TRow> Default { get => throw null; }
            public bool Equals(TRow leftRow, TRow rightRow) => throw null;
            public int GetHashCode(TRow row) => throw null;
        }

        // Generated from `System.Data.DataRowExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class DataRowExtensions
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

        // Generated from `System.Data.DataRowState` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum DataRowState
        {
            Added,
            Deleted,
            Detached,
            Modified,
            Unchanged,
        }

        // Generated from `System.Data.DataRowVersion` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DataRowVersion
        {
            Current,
            Default,
            Original,
            Proposed,
        }

        // Generated from `System.Data.DataRowView` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public object this[int ndx] { get => throw null; set => throw null; }
            public object this[string property] { get => throw null; set => throw null; }
            string System.ComponentModel.IDataErrorInfo.this[string colName] { get => throw null; }
            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
            public System.Data.DataRow Row { get => throw null; }
            public System.Data.DataRowVersion RowVersion { get => throw null; }
        }

        // Generated from `System.Data.DataSet` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataSet : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IListSource, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
        {
            public void AcceptChanges() => throw null;
            public void BeginInit() => throw null;
            public bool CaseSensitive { get => throw null; set => throw null; }
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
            public string DataSetName { get => throw null; set => throw null; }
            public System.Data.DataViewManager DefaultViewManager { get => throw null; }
            protected System.Data.SchemaSerializationMode DetermineSchemaSerializationMode(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            protected System.Data.SchemaSerializationMode DetermineSchemaSerializationMode(System.Xml.XmlReader reader) => throw null;
            public void EndInit() => throw null;
            public bool EnforceConstraints { get => throw null; set => throw null; }
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
            public void InferXmlSchema(System.Xml.XmlReader reader, string[] nsArray) => throw null;
            public void InferXmlSchema(string fileName, string[] nsArray) => throw null;
            protected virtual void InitializeDerivedDataSet() => throw null;
            public event System.EventHandler Initialized;
            protected bool IsBinarySerialized(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsInitialized { get => throw null; }
            public virtual void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, System.Data.FillErrorEventHandler errorHandler, params System.Data.DataTable[] tables) => throw null;
            public void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, params System.Data.DataTable[] tables) => throw null;
            public void Load(System.Data.IDataReader reader, System.Data.LoadOption loadOption, params string[] tables) => throw null;
            public System.Globalization.CultureInfo Locale { get => throw null; set => throw null; }
            public void Merge(System.Data.DataRow[] rows) => throw null;
            public void Merge(System.Data.DataRow[] rows, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public void Merge(System.Data.DataSet dataSet) => throw null;
            public void Merge(System.Data.DataSet dataSet, bool preserveChanges) => throw null;
            public void Merge(System.Data.DataSet dataSet, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public void Merge(System.Data.DataTable table) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public event System.Data.MergeFailedEventHandler MergeFailed;
            public string Namespace { get => throw null; set => throw null; }
            protected virtual void OnPropertyChanging(System.ComponentModel.PropertyChangedEventArgs pcevent) => throw null;
            protected virtual void OnRemoveRelation(System.Data.DataRelation relation) => throw null;
            protected internal virtual void OnRemoveTable(System.Data.DataTable table) => throw null;
            public string Prefix { get => throw null; set => throw null; }
            protected internal void RaisePropertyChanging(string name) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader) => throw null;
            void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader, System.Data.XmlReadMode mode) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName, System.Data.XmlReadMode mode) => throw null;
            public void ReadXmlSchema(System.IO.Stream stream) => throw null;
            public void ReadXmlSchema(System.IO.TextReader reader) => throw null;
            public void ReadXmlSchema(System.Xml.XmlReader reader) => throw null;
            public void ReadXmlSchema(string fileName) => throw null;
            protected virtual void ReadXmlSerializable(System.Xml.XmlReader reader) => throw null;
            public virtual void RejectChanges() => throw null;
            public System.Data.DataRelationCollection Relations { get => throw null; }
            public System.Data.SerializationFormat RemotingFormat { get => throw null; set => throw null; }
            public virtual void Reset() => throw null;
            public virtual System.Data.SchemaSerializationMode SchemaSerializationMode { get => throw null; set => throw null; }
            protected virtual bool ShouldSerializeRelations() => throw null;
            protected virtual bool ShouldSerializeTables() => throw null;
            public override System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public System.Data.DataTableCollection Tables { get => throw null; }
            public void WriteXml(System.IO.Stream stream) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.TextWriter writer) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer) => throw null;
            void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(string fileName) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
            public void WriteXmlSchema(string fileName) => throw null;
            public void WriteXmlSchema(string fileName, System.Converter<System.Type, string> multipleTargetConverter) => throw null;
        }

        // Generated from `System.Data.DataSetDateTime` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DataSetDateTime
        {
            Local,
            Unspecified,
            UnspecifiedLocal,
            Utc,
        }

        // Generated from `System.Data.DataSysDescriptionAttribute` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataSysDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public DataSysDescriptionAttribute(string description) => throw null;
            public override string Description { get => throw null; }
        }

        // Generated from `System.Data.DataTable` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataTable : System.ComponentModel.MarshalByValueComponent, System.ComponentModel.IListSource, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
        {
            public void AcceptChanges() => throw null;
            public virtual void BeginInit() => throw null;
            public void BeginLoadData() => throw null;
            public bool CaseSensitive { get => throw null; set => throw null; }
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
            public System.Data.DataSet DataSet { get => throw null; }
            public DataTable() => throw null;
            protected DataTable(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DataTable(string tableName) => throw null;
            public DataTable(string tableName, string tableNamespace) => throw null;
            public System.Data.DataView DefaultView { get => throw null; }
            public string DisplayExpression { get => throw null; set => throw null; }
            public virtual void EndInit() => throw null;
            public void EndLoadData() => throw null;
            public System.Data.PropertyCollection ExtendedProperties { get => throw null; }
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
            public System.Data.DataRow LoadDataRow(object[] values, System.Data.LoadOption loadOption) => throw null;
            public System.Data.DataRow LoadDataRow(object[] values, bool fAcceptChanges) => throw null;
            public System.Globalization.CultureInfo Locale { get => throw null; set => throw null; }
            public void Merge(System.Data.DataTable table) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges) => throw null;
            public void Merge(System.Data.DataTable table, bool preserveChanges, System.Data.MissingSchemaAction missingSchemaAction) => throw null;
            public int MinimumCapacity { get => throw null; set => throw null; }
            public string Namespace { get => throw null; set => throw null; }
            public System.Data.DataRow NewRow() => throw null;
            protected internal System.Data.DataRow[] NewRowArray(int size) => throw null;
            protected virtual System.Data.DataRow NewRowFromBuilder(System.Data.DataRowBuilder builder) => throw null;
            protected internal virtual void OnColumnChanged(System.Data.DataColumnChangeEventArgs e) => throw null;
            protected internal virtual void OnColumnChanging(System.Data.DataColumnChangeEventArgs e) => throw null;
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
            public string Prefix { get => throw null; set => throw null; }
            public System.Data.DataColumn[] PrimaryKey { get => throw null; set => throw null; }
            public System.Data.XmlReadMode ReadXml(System.IO.Stream stream) => throw null;
            public System.Data.XmlReadMode ReadXml(System.IO.TextReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(System.Xml.XmlReader reader) => throw null;
            void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
            public System.Data.XmlReadMode ReadXml(string fileName) => throw null;
            public void ReadXmlSchema(System.IO.Stream stream) => throw null;
            public void ReadXmlSchema(System.IO.TextReader reader) => throw null;
            public void ReadXmlSchema(System.Xml.XmlReader reader) => throw null;
            public void ReadXmlSchema(string fileName) => throw null;
            protected virtual void ReadXmlSerializable(System.Xml.XmlReader reader) => throw null;
            public void RejectChanges() => throw null;
            public System.Data.SerializationFormat RemotingFormat { get => throw null; set => throw null; }
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
            public override System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public event System.Data.DataTableClearEventHandler TableCleared;
            public event System.Data.DataTableClearEventHandler TableClearing;
            public string TableName { get => throw null; set => throw null; }
            public event System.Data.DataTableNewRowEventHandler TableNewRow;
            public override string ToString() => throw null;
            public void WriteXml(System.IO.Stream stream) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.Stream stream, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.Stream stream, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.TextWriter writer) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.IO.TextWriter writer, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(System.IO.TextWriter writer, bool writeHierarchy) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer) => throw null;
            void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(System.Xml.XmlWriter writer, bool writeHierarchy) => throw null;
            public void WriteXml(string fileName) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode) => throw null;
            public void WriteXml(string fileName, System.Data.XmlWriteMode mode, bool writeHierarchy) => throw null;
            public void WriteXml(string fileName, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream) => throw null;
            public void WriteXmlSchema(System.IO.Stream stream, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer) => throw null;
            public void WriteXmlSchema(System.IO.TextWriter writer, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer) => throw null;
            public void WriteXmlSchema(System.Xml.XmlWriter writer, bool writeHierarchy) => throw null;
            public void WriteXmlSchema(string fileName) => throw null;
            public void WriteXmlSchema(string fileName, bool writeHierarchy) => throw null;
            protected internal bool fInitInProgress;
        }

        // Generated from `System.Data.DataTableClearEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataTableClearEventArgs : System.EventArgs
        {
            public DataTableClearEventArgs(System.Data.DataTable dataTable) => throw null;
            public System.Data.DataTable Table { get => throw null; }
            public string TableName { get => throw null; }
            public string TableNamespace { get => throw null; }
        }

        // Generated from `System.Data.DataTableClearEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DataTableClearEventHandler(object sender, System.Data.DataTableClearEventArgs e);

        // Generated from `System.Data.DataTableCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataTableCollection : System.Data.InternalDataCollectionBase
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
            public System.Data.DataTable this[int index] { get => throw null; }
            public System.Data.DataTable this[string name, string tableNamespace] { get => throw null; }
            public System.Data.DataTable this[string name] { get => throw null; }
            protected override System.Collections.ArrayList List { get => throw null; }
            public void Remove(System.Data.DataTable table) => throw null;
            public void Remove(string name) => throw null;
            public void Remove(string name, string tableNamespace) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Data.DataTableExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class DataTableExtensions
        {
            public static System.Data.DataView AsDataView(this System.Data.DataTable table) => throw null;
            public static System.Data.DataView AsDataView<T>(this System.Data.EnumerableRowCollection<T> source) where T : System.Data.DataRow => throw null;
            public static System.Data.EnumerableRowCollection<System.Data.DataRow> AsEnumerable(this System.Data.DataTable source) => throw null;
            public static System.Data.DataTable CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source) where T : System.Data.DataRow => throw null;
            public static void CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source, System.Data.DataTable table, System.Data.LoadOption options) where T : System.Data.DataRow => throw null;
            public static void CopyToDataTable<T>(this System.Collections.Generic.IEnumerable<T> source, System.Data.DataTable table, System.Data.LoadOption options, System.Data.FillErrorEventHandler errorHandler) where T : System.Data.DataRow => throw null;
        }

        // Generated from `System.Data.DataTableNewRowEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataTableNewRowEventArgs : System.EventArgs
        {
            public DataTableNewRowEventArgs(System.Data.DataRow dataRow) => throw null;
            public System.Data.DataRow Row { get => throw null; }
        }

        // Generated from `System.Data.DataTableNewRowEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DataTableNewRowEventHandler(object sender, System.Data.DataTableNewRowEventArgs e);

        // Generated from `System.Data.DataTableReader` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataTableReader : System.Data.Common.DbDataReader
        {
            public override void Close() => throw null;
            public DataTableReader(System.Data.DataTable dataTable) => throw null;
            public DataTableReader(System.Data.DataTable[] dataTables) => throw null;
            public override int Depth { get => throw null; }
            public override int FieldCount { get => throw null; }
            public override bool GetBoolean(int ordinal) => throw null;
            public override System.Byte GetByte(int ordinal) => throw null;
            public override System.Int64 GetBytes(int ordinal, System.Int64 dataIndex, System.Byte[] buffer, int bufferIndex, int length) => throw null;
            public override System.Char GetChar(int ordinal) => throw null;
            public override System.Int64 GetChars(int ordinal, System.Int64 dataIndex, System.Char[] buffer, int bufferIndex, int length) => throw null;
            public override string GetDataTypeName(int ordinal) => throw null;
            public override System.DateTime GetDateTime(int ordinal) => throw null;
            public override System.Decimal GetDecimal(int ordinal) => throw null;
            public override double GetDouble(int ordinal) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public override System.Type GetFieldType(int ordinal) => throw null;
            public override float GetFloat(int ordinal) => throw null;
            public override System.Guid GetGuid(int ordinal) => throw null;
            public override System.Int16 GetInt16(int ordinal) => throw null;
            public override int GetInt32(int ordinal) => throw null;
            public override System.Int64 GetInt64(int ordinal) => throw null;
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
            public override object this[int ordinal] { get => throw null; }
            public override object this[string name] { get => throw null; }
            public override bool NextResult() => throw null;
            public override bool Read() => throw null;
            public override int RecordsAffected { get => throw null; }
        }

        // Generated from `System.Data.DataView` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataView : System.ComponentModel.MarshalByValueComponent, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.IBindingList, System.ComponentModel.IBindingListView, System.ComponentModel.ISupportInitialize, System.ComponentModel.ISupportInitializeNotification, System.ComponentModel.ITypedList
        {
            int System.Collections.IList.Add(object value) => throw null;
            void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            public virtual System.Data.DataRowView AddNew() => throw null;
            object System.ComponentModel.IBindingList.AddNew() => throw null;
            public bool AllowDelete { get => throw null; set => throw null; }
            public bool AllowEdit { get => throw null; set => throw null; }
            bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
            public bool AllowNew { get => throw null; set => throw null; }
            bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
            bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
            public bool ApplyDefaultSort { get => throw null; set => throw null; }
            void System.ComponentModel.IBindingListView.ApplySort(System.ComponentModel.ListSortDescriptionCollection sorts) => throw null;
            void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
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
            string System.ComponentModel.IBindingListView.Filter { get => throw null; set => throw null; }
            public int Find(object[] key) => throw null;
            int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor property, object key) => throw null;
            public int Find(object key) => throw null;
            public System.Data.DataRowView[] FindRows(object[] key) => throw null;
            public System.Data.DataRowView[] FindRows(object key) => throw null;
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
            public System.Data.DataRowView this[int recordIndex] { get => throw null; }
            object System.Collections.IList.this[int recordIndex] { get => throw null; set => throw null; }
            public event System.ComponentModel.ListChangedEventHandler ListChanged;
            protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
            protected void Open() => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            void System.ComponentModel.IBindingListView.RemoveFilter() => throw null;
            void System.ComponentModel.IBindingList.RemoveIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
            void System.ComponentModel.IBindingList.RemoveSort() => throw null;
            protected void Reset() => throw null;
            public virtual string RowFilter { get => throw null; set => throw null; }
            public System.Data.DataViewRowState RowStateFilter { get => throw null; set => throw null; }
            public string Sort { get => throw null; set => throw null; }
            System.ComponentModel.ListSortDescriptionCollection System.ComponentModel.IBindingListView.SortDescriptions { get => throw null; }
            System.ComponentModel.ListSortDirection System.ComponentModel.IBindingList.SortDirection { get => throw null; }
            System.ComponentModel.PropertyDescriptor System.ComponentModel.IBindingList.SortProperty { get => throw null; }
            bool System.ComponentModel.IBindingListView.SupportsAdvancedSorting { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsChangeNotification { get => throw null; }
            bool System.ComponentModel.IBindingListView.SupportsFiltering { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSearching { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSorting { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public System.Data.DataTable Table { get => throw null; set => throw null; }
            public System.Data.DataTable ToTable() => throw null;
            public System.Data.DataTable ToTable(bool distinct, params string[] columnNames) => throw null;
            public System.Data.DataTable ToTable(string tableName) => throw null;
            public System.Data.DataTable ToTable(string tableName, bool distinct, params string[] columnNames) => throw null;
            protected void UpdateIndex() => throw null;
            protected virtual void UpdateIndex(bool force) => throw null;
        }

        // Generated from `System.Data.DataViewManager` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataViewManager : System.ComponentModel.MarshalByValueComponent, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.IBindingList, System.ComponentModel.ITypedList
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
            public System.Data.DataSet DataSet { get => throw null; set => throw null; }
            public DataViewManager() => throw null;
            public DataViewManager(System.Data.DataSet dataSet) => throw null;
            public string DataViewSettingCollectionString { get => throw null; set => throw null; }
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
            object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
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

        // Generated from `System.Data.DataViewRowState` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum DataViewRowState
        {
            Added,
            CurrentRows,
            Deleted,
            ModifiedCurrent,
            ModifiedOriginal,
            None,
            OriginalRows,
            Unchanged,
        }

        // Generated from `System.Data.DataViewSetting` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataViewSetting
        {
            public bool ApplyDefaultSort { get => throw null; set => throw null; }
            public System.Data.DataViewManager DataViewManager { get => throw null; }
            public string RowFilter { get => throw null; set => throw null; }
            public System.Data.DataViewRowState RowStateFilter { get => throw null; set => throw null; }
            public string Sort { get => throw null; set => throw null; }
            public System.Data.DataTable Table { get => throw null; }
        }

        // Generated from `System.Data.DataViewSettingCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataViewSettingCollection : System.Collections.ICollection, System.Collections.IEnumerable
        {
            public void CopyTo(System.Array ar, int index) => throw null;
            public void CopyTo(System.Data.DataViewSetting[] ar, int index) => throw null;
            public virtual int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public virtual System.Data.DataViewSetting this[System.Data.DataTable table] { get => throw null; set => throw null; }
            public virtual System.Data.DataViewSetting this[int index] { get => throw null; set => throw null; }
            public virtual System.Data.DataViewSetting this[string tableName] { get => throw null; }
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Data.DbType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DbType
        {
            AnsiString,
            AnsiStringFixedLength,
            Binary,
            Boolean,
            Byte,
            Currency,
            Date,
            DateTime,
            DateTime2,
            DateTimeOffset,
            Decimal,
            Double,
            Guid,
            Int16,
            Int32,
            Int64,
            Object,
            SByte,
            Single,
            String,
            StringFixedLength,
            Time,
            UInt16,
            UInt32,
            UInt64,
            VarNumeric,
            Xml,
        }

        // Generated from `System.Data.DeletedRowInaccessibleException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DeletedRowInaccessibleException : System.Data.DataException
        {
            public DeletedRowInaccessibleException() => throw null;
            protected DeletedRowInaccessibleException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DeletedRowInaccessibleException(string s) => throw null;
            public DeletedRowInaccessibleException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.DuplicateNameException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DuplicateNameException : System.Data.DataException
        {
            public DuplicateNameException() => throw null;
            protected DuplicateNameException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DuplicateNameException(string s) => throw null;
            public DuplicateNameException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.EnumerableRowCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EnumerableRowCollection : System.Collections.IEnumerable
        {
            internal EnumerableRowCollection() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        }

        // Generated from `System.Data.EnumerableRowCollection<>` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EnumerableRowCollection<TRow> : System.Data.EnumerableRowCollection, System.Collections.Generic.IEnumerable<TRow>, System.Collections.IEnumerable
        {
            internal EnumerableRowCollection() => throw null;
            public System.Collections.Generic.IEnumerator<TRow> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        }

        // Generated from `System.Data.EnumerableRowCollectionExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class EnumerableRowCollectionExtensions
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

        // Generated from `System.Data.EvaluateException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EvaluateException : System.Data.InvalidExpressionException
        {
            public EvaluateException() => throw null;
            protected EvaluateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public EvaluateException(string s) => throw null;
            public EvaluateException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.FillErrorEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FillErrorEventArgs : System.EventArgs
        {
            public bool Continue { get => throw null; set => throw null; }
            public System.Data.DataTable DataTable { get => throw null; }
            public System.Exception Errors { get => throw null; set => throw null; }
            public FillErrorEventArgs(System.Data.DataTable dataTable, object[] values) => throw null;
            public object[] Values { get => throw null; }
        }

        // Generated from `System.Data.FillErrorEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void FillErrorEventHandler(object sender, System.Data.FillErrorEventArgs e);

        // Generated from `System.Data.ForeignKeyConstraint` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ForeignKeyConstraint : System.Data.Constraint
        {
            public virtual System.Data.AcceptRejectRule AcceptRejectRule { get => throw null; set => throw null; }
            public virtual System.Data.DataColumn[] Columns { get => throw null; }
            public virtual System.Data.Rule DeleteRule { get => throw null; set => throw null; }
            public override bool Equals(object key) => throw null;
            public ForeignKeyConstraint(System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public ForeignKeyConstraint(System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public ForeignKeyConstraint(string constraintName, System.Data.DataColumn parentColumn, System.Data.DataColumn childColumn) => throw null;
            public ForeignKeyConstraint(string constraintName, System.Data.DataColumn[] parentColumns, System.Data.DataColumn[] childColumns) => throw null;
            public ForeignKeyConstraint(string constraintName, string parentTableName, string[] parentColumnNames, string[] childColumnNames, System.Data.AcceptRejectRule acceptRejectRule, System.Data.Rule deleteRule, System.Data.Rule updateRule) => throw null;
            public ForeignKeyConstraint(string constraintName, string parentTableName, string parentTableNamespace, string[] parentColumnNames, string[] childColumnNames, System.Data.AcceptRejectRule acceptRejectRule, System.Data.Rule deleteRule, System.Data.Rule updateRule) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Data.DataColumn[] RelatedColumns { get => throw null; }
            public virtual System.Data.DataTable RelatedTable { get => throw null; }
            public override System.Data.DataTable Table { get => throw null; }
            public virtual System.Data.Rule UpdateRule { get => throw null; set => throw null; }
        }

        // Generated from `System.Data.IColumnMapping` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IColumnMapping
        {
            string DataSetColumn { get; set; }
            string SourceColumn { get; set; }
        }

        // Generated from `System.Data.IColumnMappingCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IColumnMappingCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            System.Data.IColumnMapping Add(string sourceColumnName, string dataSetColumnName);
            bool Contains(string sourceColumnName);
            System.Data.IColumnMapping GetByDataSetColumn(string dataSetColumnName);
            int IndexOf(string sourceColumnName);
            object this[string index] { get; set; }
            void RemoveAt(string sourceColumnName);
        }

        // Generated from `System.Data.IDataAdapter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Data.IDataParameter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Data.IDataParameterCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDataParameterCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            bool Contains(string parameterName);
            int IndexOf(string parameterName);
            object this[string parameterName] { get; set; }
            void RemoveAt(string parameterName);
        }

        // Generated from `System.Data.IDataReader` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Data.IDataRecord` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDataRecord
        {
            int FieldCount { get; }
            bool GetBoolean(int i);
            System.Byte GetByte(int i);
            System.Int64 GetBytes(int i, System.Int64 fieldOffset, System.Byte[] buffer, int bufferoffset, int length);
            System.Char GetChar(int i);
            System.Int64 GetChars(int i, System.Int64 fieldoffset, System.Char[] buffer, int bufferoffset, int length);
            System.Data.IDataReader GetData(int i);
            string GetDataTypeName(int i);
            System.DateTime GetDateTime(int i);
            System.Decimal GetDecimal(int i);
            double GetDouble(int i);
            System.Type GetFieldType(int i);
            float GetFloat(int i);
            System.Guid GetGuid(int i);
            System.Int16 GetInt16(int i);
            int GetInt32(int i);
            System.Int64 GetInt64(int i);
            string GetName(int i);
            int GetOrdinal(string name);
            string GetString(int i);
            object GetValue(int i);
            int GetValues(object[] values);
            bool IsDBNull(int i);
            object this[int i] { get; }
            object this[string name] { get; }
        }

        // Generated from `System.Data.IDbCommand` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Data.IDbConnection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Data.IDbDataAdapter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDbDataAdapter : System.Data.IDataAdapter
        {
            System.Data.IDbCommand DeleteCommand { get; set; }
            System.Data.IDbCommand InsertCommand { get; set; }
            System.Data.IDbCommand SelectCommand { get; set; }
            System.Data.IDbCommand UpdateCommand { get; set; }
        }

        // Generated from `System.Data.IDbDataParameter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDbDataParameter : System.Data.IDataParameter
        {
            System.Byte Precision { get; set; }
            System.Byte Scale { get; set; }
            int Size { get; set; }
        }

        // Generated from `System.Data.IDbTransaction` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDbTransaction : System.IDisposable
        {
            void Commit();
            System.Data.IDbConnection Connection { get; }
            System.Data.IsolationLevel IsolationLevel { get; }
            void Rollback();
        }

        // Generated from `System.Data.ITableMapping` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ITableMapping
        {
            System.Data.IColumnMappingCollection ColumnMappings { get; }
            string DataSetTable { get; set; }
            string SourceTable { get; set; }
        }

        // Generated from `System.Data.ITableMappingCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ITableMappingCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            System.Data.ITableMapping Add(string sourceTableName, string dataSetTableName);
            bool Contains(string sourceTableName);
            System.Data.ITableMapping GetByDataSetTable(string dataSetTableName);
            int IndexOf(string sourceTableName);
            object this[string index] { get; set; }
            void RemoveAt(string sourceTableName);
        }

        // Generated from `System.Data.InRowChangingEventException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InRowChangingEventException : System.Data.DataException
        {
            public InRowChangingEventException() => throw null;
            protected InRowChangingEventException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InRowChangingEventException(string s) => throw null;
            public InRowChangingEventException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.InternalDataCollectionBase` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InternalDataCollectionBase : System.Collections.ICollection, System.Collections.IEnumerable
        {
            public virtual void CopyTo(System.Array ar, int index) => throw null;
            public virtual int Count { get => throw null; }
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            public InternalDataCollectionBase() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            protected virtual System.Collections.ArrayList List { get => throw null; }
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Data.InvalidConstraintException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidConstraintException : System.Data.DataException
        {
            public InvalidConstraintException() => throw null;
            protected InvalidConstraintException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidConstraintException(string s) => throw null;
            public InvalidConstraintException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.InvalidExpressionException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidExpressionException : System.Data.DataException
        {
            public InvalidExpressionException() => throw null;
            protected InvalidExpressionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidExpressionException(string s) => throw null;
            public InvalidExpressionException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.IsolationLevel` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum IsolationLevel
        {
            Chaos,
            ReadCommitted,
            ReadUncommitted,
            RepeatableRead,
            Serializable,
            Snapshot,
            Unspecified,
        }

        // Generated from `System.Data.KeyRestrictionBehavior` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum KeyRestrictionBehavior
        {
            AllowOnly,
            PreventUsage,
        }

        // Generated from `System.Data.LoadOption` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum LoadOption
        {
            OverwriteChanges,
            PreserveChanges,
            Upsert,
        }

        // Generated from `System.Data.MappingType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MappingType
        {
            Attribute,
            Element,
            Hidden,
            SimpleContent,
        }

        // Generated from `System.Data.MergeFailedEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MergeFailedEventArgs : System.EventArgs
        {
            public string Conflict { get => throw null; }
            public MergeFailedEventArgs(System.Data.DataTable table, string conflict) => throw null;
            public System.Data.DataTable Table { get => throw null; }
        }

        // Generated from `System.Data.MergeFailedEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void MergeFailedEventHandler(object sender, System.Data.MergeFailedEventArgs e);

        // Generated from `System.Data.MissingMappingAction` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MissingMappingAction
        {
            Error,
            Ignore,
            Passthrough,
        }

        // Generated from `System.Data.MissingPrimaryKeyException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MissingPrimaryKeyException : System.Data.DataException
        {
            public MissingPrimaryKeyException() => throw null;
            protected MissingPrimaryKeyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public MissingPrimaryKeyException(string s) => throw null;
            public MissingPrimaryKeyException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.MissingSchemaAction` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MissingSchemaAction
        {
            Add,
            AddWithKey,
            Error,
            Ignore,
        }

        // Generated from `System.Data.NoNullAllowedException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NoNullAllowedException : System.Data.DataException
        {
            public NoNullAllowedException() => throw null;
            protected NoNullAllowedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public NoNullAllowedException(string s) => throw null;
            public NoNullAllowedException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.OrderedEnumerableRowCollection<>` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class OrderedEnumerableRowCollection<TRow> : System.Data.EnumerableRowCollection<TRow>
        {
        }

        // Generated from `System.Data.ParameterDirection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ParameterDirection
        {
            Input,
            InputOutput,
            Output,
            ReturnValue,
        }

        // Generated from `System.Data.PropertyCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PropertyCollection : System.Collections.Hashtable, System.ICloneable
        {
            public override object Clone() => throw null;
            public PropertyCollection() => throw null;
            protected PropertyCollection(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Data.ReadOnlyException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReadOnlyException : System.Data.DataException
        {
            public ReadOnlyException() => throw null;
            protected ReadOnlyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ReadOnlyException(string s) => throw null;
            public ReadOnlyException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.RowNotInTableException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RowNotInTableException : System.Data.DataException
        {
            public RowNotInTableException() => throw null;
            protected RowNotInTableException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public RowNotInTableException(string s) => throw null;
            public RowNotInTableException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.Rule` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum Rule
        {
            Cascade,
            None,
            SetDefault,
            SetNull,
        }

        // Generated from `System.Data.SchemaSerializationMode` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SchemaSerializationMode
        {
            ExcludeSchema,
            IncludeSchema,
        }

        // Generated from `System.Data.SchemaType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SchemaType
        {
            Mapped,
            Source,
        }

        // Generated from `System.Data.SerializationFormat` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SerializationFormat
        {
            Binary,
            Xml,
        }

        // Generated from `System.Data.SqlDbType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum SqlDbType
        {
            BigInt,
            Binary,
            Bit,
            Char,
            Date,
            DateTime,
            DateTime2,
            DateTimeOffset,
            Decimal,
            Float,
            Image,
            Int,
            Money,
            NChar,
            NText,
            NVarChar,
            Real,
            SmallDateTime,
            SmallInt,
            SmallMoney,
            Structured,
            Text,
            Time,
            Timestamp,
            TinyInt,
            Udt,
            UniqueIdentifier,
            VarBinary,
            VarChar,
            Variant,
            Xml,
        }

        // Generated from `System.Data.StateChangeEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StateChangeEventArgs : System.EventArgs
        {
            public System.Data.ConnectionState CurrentState { get => throw null; }
            public System.Data.ConnectionState OriginalState { get => throw null; }
            public StateChangeEventArgs(System.Data.ConnectionState originalState, System.Data.ConnectionState currentState) => throw null;
        }

        // Generated from `System.Data.StateChangeEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void StateChangeEventHandler(object sender, System.Data.StateChangeEventArgs e);

        // Generated from `System.Data.StatementCompletedEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StatementCompletedEventArgs : System.EventArgs
        {
            public int RecordCount { get => throw null; }
            public StatementCompletedEventArgs(int recordCount) => throw null;
        }

        // Generated from `System.Data.StatementCompletedEventHandler` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void StatementCompletedEventHandler(object sender, System.Data.StatementCompletedEventArgs e);

        // Generated from `System.Data.StatementType` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum StatementType
        {
            Batch,
            Delete,
            Insert,
            Select,
            Update,
        }

        // Generated from `System.Data.StrongTypingException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StrongTypingException : System.Data.DataException
        {
            public StrongTypingException() => throw null;
            protected StrongTypingException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public StrongTypingException(string message) => throw null;
            public StrongTypingException(string s, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.SyntaxErrorException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SyntaxErrorException : System.Data.InvalidExpressionException
        {
            public SyntaxErrorException() => throw null;
            protected SyntaxErrorException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SyntaxErrorException(string s) => throw null;
            public SyntaxErrorException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.TypedTableBase<>` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TypedTableBase<T> : System.Data.DataTable, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable where T : System.Data.DataRow
        {
            public System.Data.EnumerableRowCollection<TResult> Cast<TResult>() => throw null;
            public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            protected TypedTableBase() => throw null;
            protected TypedTableBase(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Data.TypedTableBaseExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class TypedTableBaseExtensions
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

        // Generated from `System.Data.UniqueConstraint` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UniqueConstraint : System.Data.Constraint
        {
            public virtual System.Data.DataColumn[] Columns { get => throw null; }
            public override bool Equals(object key2) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsPrimaryKey { get => throw null; }
            public override System.Data.DataTable Table { get => throw null; }
            public UniqueConstraint(System.Data.DataColumn column) => throw null;
            public UniqueConstraint(System.Data.DataColumn column, bool isPrimaryKey) => throw null;
            public UniqueConstraint(System.Data.DataColumn[] columns) => throw null;
            public UniqueConstraint(System.Data.DataColumn[] columns, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn column) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn column, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn[] columns) => throw null;
            public UniqueConstraint(string name, System.Data.DataColumn[] columns, bool isPrimaryKey) => throw null;
            public UniqueConstraint(string name, string[] columnNames, bool isPrimaryKey) => throw null;
        }

        // Generated from `System.Data.UpdateRowSource` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum UpdateRowSource
        {
            Both,
            FirstReturnedRecord,
            None,
            OutputParameters,
        }

        // Generated from `System.Data.UpdateStatus` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum UpdateStatus
        {
            Continue,
            ErrorsOccurred,
            SkipAllRemainingRows,
            SkipCurrentRow,
        }

        // Generated from `System.Data.VersionNotFoundException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VersionNotFoundException : System.Data.DataException
        {
            public VersionNotFoundException() => throw null;
            protected VersionNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public VersionNotFoundException(string s) => throw null;
            public VersionNotFoundException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Data.XmlReadMode` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum XmlReadMode
        {
            Auto,
            DiffGram,
            Fragment,
            IgnoreSchema,
            InferSchema,
            InferTypedSchema,
            ReadSchema,
        }

        // Generated from `System.Data.XmlWriteMode` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum XmlWriteMode
        {
            DiffGram,
            IgnoreSchema,
            WriteSchema,
        }

        namespace Common
        {
            // Generated from `System.Data.Common.CatalogLocation` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CatalogLocation
            {
                End,
                Start,
            }

            // Generated from `System.Data.Common.DataAdapter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataAdapter : System.ComponentModel.Component, System.Data.IDataAdapter
            {
                public bool AcceptChangesDuringFill { get => throw null; set => throw null; }
                public bool AcceptChangesDuringUpdate { get => throw null; set => throw null; }
                protected virtual System.Data.Common.DataAdapter CloneInternals() => throw null;
                public bool ContinueUpdateOnError { get => throw null; set => throw null; }
                protected virtual System.Data.Common.DataTableMappingCollection CreateTableMappings() => throw null;
                protected DataAdapter() => throw null;
                protected DataAdapter(System.Data.Common.DataAdapter from) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public virtual int Fill(System.Data.DataSet dataSet) => throw null;
                protected virtual int Fill(System.Data.DataSet dataSet, string srcTable, System.Data.IDataReader dataReader, int startRecord, int maxRecords) => throw null;
                protected virtual int Fill(System.Data.DataTable dataTable, System.Data.IDataReader dataReader) => throw null;
                protected virtual int Fill(System.Data.DataTable[] dataTables, System.Data.IDataReader dataReader, int startRecord, int maxRecords) => throw null;
                public event System.Data.FillErrorEventHandler FillError;
                public System.Data.LoadOption FillLoadOption { get => throw null; set => throw null; }
                public virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, string srcTable, System.Data.IDataReader dataReader) => throw null;
                protected virtual System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType, System.Data.IDataReader dataReader) => throw null;
                public virtual System.Data.IDataParameter[] GetFillParameters() => throw null;
                protected bool HasTableMappings() => throw null;
                public System.Data.MissingMappingAction MissingMappingAction { get => throw null; set => throw null; }
                public System.Data.MissingSchemaAction MissingSchemaAction { get => throw null; set => throw null; }
                protected virtual void OnFillError(System.Data.FillErrorEventArgs value) => throw null;
                public void ResetFillLoadOption() => throw null;
                public virtual bool ReturnProviderSpecificTypes { get => throw null; set => throw null; }
                public virtual bool ShouldSerializeAcceptChangesDuringFill() => throw null;
                public virtual bool ShouldSerializeFillLoadOption() => throw null;
                protected virtual bool ShouldSerializeTableMappings() => throw null;
                public System.Data.Common.DataTableMappingCollection TableMappings { get => throw null; }
                System.Data.ITableMappingCollection System.Data.IDataAdapter.TableMappings { get => throw null; }
                public virtual int Update(System.Data.DataSet dataSet) => throw null;
            }

            // Generated from `System.Data.Common.DataColumnMapping` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataColumnMapping : System.MarshalByRefObject, System.Data.IColumnMapping, System.ICloneable
            {
                object System.ICloneable.Clone() => throw null;
                public DataColumnMapping() => throw null;
                public DataColumnMapping(string sourceColumn, string dataSetColumn) => throw null;
                public string DataSetColumn { get => throw null; set => throw null; }
                public System.Data.DataColumn GetDataColumnBySchemaAction(System.Data.DataTable dataTable, System.Type dataType, System.Data.MissingSchemaAction schemaAction) => throw null;
                public static System.Data.DataColumn GetDataColumnBySchemaAction(string sourceColumn, string dataSetColumn, System.Data.DataTable dataTable, System.Type dataType, System.Data.MissingSchemaAction schemaAction) => throw null;
                public string SourceColumn { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.Common.DataColumnMappingCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataColumnMappingCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Data.IColumnMappingCollection
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
                public System.Data.Common.DataColumnMapping this[int index] { get => throw null; set => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                public System.Data.Common.DataColumnMapping this[string sourceColumn] { get => throw null; set => throw null; }
                object System.Data.IColumnMappingCollection.this[string index] { get => throw null; set => throw null; }
                public void Remove(System.Data.Common.DataColumnMapping value) => throw null;
                public void Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                public void RemoveAt(string sourceColumn) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

            // Generated from `System.Data.Common.DataTableMapping` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataTableMapping : System.MarshalByRefObject, System.Data.ITableMapping, System.ICloneable
            {
                object System.ICloneable.Clone() => throw null;
                public System.Data.Common.DataColumnMappingCollection ColumnMappings { get => throw null; }
                System.Data.IColumnMappingCollection System.Data.ITableMapping.ColumnMappings { get => throw null; }
                public string DataSetTable { get => throw null; set => throw null; }
                public DataTableMapping() => throw null;
                public DataTableMapping(string sourceTable, string dataSetTable) => throw null;
                public DataTableMapping(string sourceTable, string dataSetTable, System.Data.Common.DataColumnMapping[] columnMappings) => throw null;
                public System.Data.Common.DataColumnMapping GetColumnMappingBySchemaAction(string sourceColumn, System.Data.MissingMappingAction mappingAction) => throw null;
                public System.Data.DataColumn GetDataColumn(string sourceColumn, System.Type dataType, System.Data.DataTable dataTable, System.Data.MissingMappingAction mappingAction, System.Data.MissingSchemaAction schemaAction) => throw null;
                public System.Data.DataTable GetDataTableBySchemaAction(System.Data.DataSet dataSet, System.Data.MissingSchemaAction schemaAction) => throw null;
                public string SourceTable { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.Common.DataTableMappingCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataTableMappingCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Data.ITableMappingCollection
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
                public System.Data.Common.DataTableMapping this[int index] { get => throw null; set => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                public System.Data.Common.DataTableMapping this[string sourceTable] { get => throw null; set => throw null; }
                object System.Data.ITableMappingCollection.this[string index] { get => throw null; set => throw null; }
                public void Remove(System.Data.Common.DataTableMapping value) => throw null;
                public void Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                public void RemoveAt(string sourceTable) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

            // Generated from `System.Data.Common.DbColumn` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbColumn
            {
                public bool? AllowDBNull { get => throw null; set => throw null; }
                public string BaseCatalogName { get => throw null; set => throw null; }
                public string BaseColumnName { get => throw null; set => throw null; }
                public string BaseSchemaName { get => throw null; set => throw null; }
                public string BaseServerName { get => throw null; set => throw null; }
                public string BaseTableName { get => throw null; set => throw null; }
                public string ColumnName { get => throw null; set => throw null; }
                public int? ColumnOrdinal { get => throw null; set => throw null; }
                public int? ColumnSize { get => throw null; set => throw null; }
                public System.Type DataType { get => throw null; set => throw null; }
                public string DataTypeName { get => throw null; set => throw null; }
                protected DbColumn() => throw null;
                public bool? IsAliased { get => throw null; set => throw null; }
                public bool? IsAutoIncrement { get => throw null; set => throw null; }
                public bool? IsExpression { get => throw null; set => throw null; }
                public bool? IsHidden { get => throw null; set => throw null; }
                public bool? IsIdentity { get => throw null; set => throw null; }
                public bool? IsKey { get => throw null; set => throw null; }
                public bool? IsLong { get => throw null; set => throw null; }
                public bool? IsReadOnly { get => throw null; set => throw null; }
                public bool? IsUnique { get => throw null; set => throw null; }
                public virtual object this[string property] { get => throw null; }
                public int? NumericPrecision { get => throw null; set => throw null; }
                public int? NumericScale { get => throw null; set => throw null; }
                public string UdtAssemblyQualifiedName { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.Common.DbCommand` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbCommand : System.ComponentModel.Component, System.Data.IDbCommand, System.IAsyncDisposable, System.IDisposable
            {
                public abstract void Cancel();
                public abstract string CommandText { get; set; }
                public abstract int CommandTimeout { get; set; }
                public abstract System.Data.CommandType CommandType { get; set; }
                public System.Data.Common.DbConnection Connection { get => throw null; set => throw null; }
                System.Data.IDbConnection System.Data.IDbCommand.Connection { get => throw null; set => throw null; }
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
                System.Data.IDataReader System.Data.IDbCommand.ExecuteReader() => throw null;
                public System.Data.Common.DbDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                System.Data.IDataReader System.Data.IDbCommand.ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync() => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract object ExecuteScalar();
                public System.Threading.Tasks.Task<object> ExecuteScalarAsync() => throw null;
                public virtual System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.Common.DbParameterCollection Parameters { get => throw null; }
                System.Data.IDataParameterCollection System.Data.IDbCommand.Parameters { get => throw null; }
                public abstract void Prepare();
                public virtual System.Threading.Tasks.Task PrepareAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Data.Common.DbTransaction Transaction { get => throw null; set => throw null; }
                System.Data.IDbTransaction System.Data.IDbCommand.Transaction { get => throw null; set => throw null; }
                public abstract System.Data.UpdateRowSource UpdatedRowSource { get; set; }
            }

            // Generated from `System.Data.Common.DbCommandBuilder` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbCommandBuilder : System.ComponentModel.Component
            {
                protected abstract void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow row, System.Data.StatementType statementType, bool whereClause);
                public virtual System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set => throw null; }
                public virtual string CatalogSeparator { get => throw null; set => throw null; }
                public virtual System.Data.ConflictOption ConflictOption { get => throw null; set => throw null; }
                public System.Data.Common.DbDataAdapter DataAdapter { get => throw null; set => throw null; }
                protected DbCommandBuilder() => throw null;
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
                public virtual string QuotePrefix { get => throw null; set => throw null; }
                public virtual string QuoteSuffix { get => throw null; set => throw null; }
                public virtual void RefreshSchema() => throw null;
                protected void RowUpdatingHandler(System.Data.Common.RowUpdatingEventArgs rowUpdatingEvent) => throw null;
                public virtual string SchemaSeparator { get => throw null; set => throw null; }
                public bool SetAllValues { get => throw null; set => throw null; }
                protected abstract void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter);
                public virtual string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }

            // Generated from `System.Data.Common.DbConnection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbConnection : System.ComponentModel.Component, System.Data.IDbConnection, System.IAsyncDisposable, System.IDisposable
            {
                protected abstract System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel);
                protected virtual System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginDbTransactionAsync(System.Data.IsolationLevel isolationLevel, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.Common.DbTransaction BeginTransaction() => throw null;
                System.Data.IDbTransaction System.Data.IDbConnection.BeginTransaction() => throw null;
                public System.Data.Common.DbTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                System.Data.IDbTransaction System.Data.IDbConnection.BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginTransactionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Data.Common.DbTransaction> BeginTransactionAsync(System.Data.IsolationLevel isolationLevel, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract void ChangeDatabase(string databaseName);
                public virtual System.Threading.Tasks.Task ChangeDatabaseAsync(string databaseName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract void Close();
                public virtual System.Threading.Tasks.Task CloseAsync() => throw null;
                public abstract string ConnectionString { get; set; }
                public virtual int ConnectionTimeout { get => throw null; }
                public System.Data.Common.DbCommand CreateCommand() => throw null;
                System.Data.IDbCommand System.Data.IDbConnection.CreateCommand() => throw null;
                protected abstract System.Data.Common.DbCommand CreateDbCommand();
                public abstract string DataSource { get; }
                public abstract string Database { get; }
                protected DbConnection() => throw null;
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

            // Generated from `System.Data.Common.DbConnectionStringBuilder` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DbConnectionStringBuilder : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable, System.ComponentModel.ICustomTypeDescriptor
            {
                void System.Collections.IDictionary.Add(object keyword, object value) => throw null;
                public void Add(string keyword, object value) => throw null;
                public static void AppendKeyValuePair(System.Text.StringBuilder builder, string keyword, string value) => throw null;
                public static void AppendKeyValuePair(System.Text.StringBuilder builder, string keyword, string value, bool useOdbcRules) => throw null;
                public bool BrowsableConnectionString { get => throw null; set => throw null; }
                public virtual void Clear() => throw null;
                protected internal void ClearPropertyDescriptors() => throw null;
                public string ConnectionString { get => throw null; set => throw null; }
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
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties() => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties(System.Attribute[] attributes) => throw null;
                protected virtual void GetProperties(System.Collections.Hashtable propertyDescriptors) => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
                public virtual bool IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IDictionary.this[object keyword] { get => throw null; set => throw null; }
                public virtual object this[string keyword] { get => throw null; set => throw null; }
                public virtual System.Collections.ICollection Keys { get => throw null; }
                void System.Collections.IDictionary.Remove(object keyword) => throw null;
                public virtual bool Remove(string keyword) => throw null;
                public virtual bool ShouldSerialize(string keyword) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public override string ToString() => throw null;
                public virtual bool TryGetValue(string keyword, out object value) => throw null;
                public virtual System.Collections.ICollection Values { get => throw null; }
            }

            // Generated from `System.Data.Common.DbDataAdapter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbDataAdapter : System.Data.Common.DataAdapter, System.Data.IDataAdapter, System.Data.IDbDataAdapter, System.ICloneable
            {
                protected virtual int AddToBatch(System.Data.IDbCommand command) => throw null;
                protected virtual void ClearBatch() => throw null;
                object System.ICloneable.Clone() => throw null;
                protected virtual System.Data.Common.RowUpdatedEventArgs CreateRowUpdatedEvent(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                protected virtual System.Data.Common.RowUpdatingEventArgs CreateRowUpdatingEvent(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                protected DbDataAdapter() => throw null;
                protected DbDataAdapter(System.Data.Common.DbDataAdapter adapter) => throw null;
                public const string DefaultSourceTableName = default;
                public System.Data.Common.DbCommand DeleteCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.DeleteCommand { get => throw null; set => throw null; }
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
                protected internal System.Data.CommandBehavior FillCommandBehavior { get => throw null; set => throw null; }
                public override System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, System.Data.IDbCommand command, string srcTable, System.Data.CommandBehavior behavior) => throw null;
                public System.Data.DataTable[] FillSchema(System.Data.DataSet dataSet, System.Data.SchemaType schemaType, string srcTable) => throw null;
                public System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType) => throw null;
                protected virtual System.Data.DataTable FillSchema(System.Data.DataTable dataTable, System.Data.SchemaType schemaType, System.Data.IDbCommand command, System.Data.CommandBehavior behavior) => throw null;
                protected virtual System.Data.IDataParameter GetBatchedParameter(int commandIdentifier, int parameterIndex) => throw null;
                protected virtual bool GetBatchedRecordsAffected(int commandIdentifier, out int recordsAffected, out System.Exception error) => throw null;
                public override System.Data.IDataParameter[] GetFillParameters() => throw null;
                protected virtual void InitializeBatching() => throw null;
                public System.Data.Common.DbCommand InsertCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.InsertCommand { get => throw null; set => throw null; }
                protected virtual void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected virtual void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public System.Data.Common.DbCommand SelectCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.SelectCommand { get => throw null; set => throw null; }
                protected virtual void TerminateBatching() => throw null;
                public int Update(System.Data.DataRow[] dataRows) => throw null;
                protected virtual int Update(System.Data.DataRow[] dataRows, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public override int Update(System.Data.DataSet dataSet) => throw null;
                public int Update(System.Data.DataSet dataSet, string srcTable) => throw null;
                public int Update(System.Data.DataTable dataTable) => throw null;
                public virtual int UpdateBatchSize { get => throw null; set => throw null; }
                public System.Data.Common.DbCommand UpdateCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.UpdateCommand { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.Common.DbDataReader` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbDataReader : System.MarshalByRefObject, System.Collections.IEnumerable, System.Data.IDataReader, System.Data.IDataRecord, System.IAsyncDisposable, System.IDisposable
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
                public abstract System.Byte GetByte(int ordinal);
                public abstract System.Int64 GetBytes(int ordinal, System.Int64 dataOffset, System.Byte[] buffer, int bufferOffset, int length);
                public abstract System.Char GetChar(int ordinal);
                public abstract System.Int64 GetChars(int ordinal, System.Int64 dataOffset, System.Char[] buffer, int bufferOffset, int length);
                public virtual System.Threading.Tasks.Task<System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn>> GetColumnSchemaAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Data.Common.DbDataReader GetData(int ordinal) => throw null;
                System.Data.IDataReader System.Data.IDataRecord.GetData(int ordinal) => throw null;
                public abstract string GetDataTypeName(int ordinal);
                public abstract System.DateTime GetDateTime(int ordinal);
                protected virtual System.Data.Common.DbDataReader GetDbDataReader(int ordinal) => throw null;
                public abstract System.Decimal GetDecimal(int ordinal);
                public abstract double GetDouble(int ordinal);
                public abstract System.Collections.IEnumerator GetEnumerator();
                public abstract System.Type GetFieldType(int ordinal);
                public virtual T GetFieldValue<T>(int ordinal) => throw null;
                public System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int ordinal) => throw null;
                public virtual System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int ordinal, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract float GetFloat(int ordinal);
                public abstract System.Guid GetGuid(int ordinal);
                public abstract System.Int16 GetInt16(int ordinal);
                public abstract int GetInt32(int ordinal);
                public abstract System.Int64 GetInt64(int ordinal);
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
                public abstract object this[int ordinal] { get; }
                public abstract object this[string name] { get; }
                public abstract bool NextResult();
                public System.Threading.Tasks.Task<bool> NextResultAsync() => throw null;
                public virtual System.Threading.Tasks.Task<bool> NextResultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract bool Read();
                public System.Threading.Tasks.Task<bool> ReadAsync() => throw null;
                public virtual System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract int RecordsAffected { get; }
                public virtual int VisibleFieldCount { get => throw null; }
            }

            // Generated from `System.Data.Common.DbDataReaderExtensions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class DbDataReaderExtensions
            {
                public static bool CanGetColumnSchema(this System.Data.Common.DbDataReader reader) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema(this System.Data.Common.DbDataReader reader) => throw null;
            }

            // Generated from `System.Data.Common.DbDataRecord` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbDataRecord : System.ComponentModel.ICustomTypeDescriptor, System.Data.IDataRecord
            {
                protected DbDataRecord() => throw null;
                public abstract int FieldCount { get; }
                System.ComponentModel.AttributeCollection System.ComponentModel.ICustomTypeDescriptor.GetAttributes() => throw null;
                public abstract bool GetBoolean(int i);
                public abstract System.Byte GetByte(int i);
                public abstract System.Int64 GetBytes(int i, System.Int64 dataIndex, System.Byte[] buffer, int bufferIndex, int length);
                public abstract System.Char GetChar(int i);
                public abstract System.Int64 GetChars(int i, System.Int64 dataIndex, System.Char[] buffer, int bufferIndex, int length);
                string System.ComponentModel.ICustomTypeDescriptor.GetClassName() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetComponentName() => throw null;
                System.ComponentModel.TypeConverter System.ComponentModel.ICustomTypeDescriptor.GetConverter() => throw null;
                public System.Data.IDataReader GetData(int i) => throw null;
                public abstract string GetDataTypeName(int i);
                public abstract System.DateTime GetDateTime(int i);
                protected virtual System.Data.Common.DbDataReader GetDbDataReader(int i) => throw null;
                public abstract System.Decimal GetDecimal(int i);
                System.ComponentModel.EventDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultEvent() => throw null;
                System.ComponentModel.PropertyDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultProperty() => throw null;
                public abstract double GetDouble(int i);
                object System.ComponentModel.ICustomTypeDescriptor.GetEditor(System.Type editorBaseType) => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents() => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents(System.Attribute[] attributes) => throw null;
                public abstract System.Type GetFieldType(int i);
                public abstract float GetFloat(int i);
                public abstract System.Guid GetGuid(int i);
                public abstract System.Int16 GetInt16(int i);
                public abstract int GetInt32(int i);
                public abstract System.Int64 GetInt64(int i);
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

            // Generated from `System.Data.Common.DbDataSourceEnumerator` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbDataSourceEnumerator
            {
                protected DbDataSourceEnumerator() => throw null;
                public abstract System.Data.DataTable GetDataSources();
            }

            // Generated from `System.Data.Common.DbEnumerator` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DbEnumerator : System.Collections.IEnumerator
            {
                public object Current { get => throw null; }
                public DbEnumerator(System.Data.Common.DbDataReader reader) => throw null;
                public DbEnumerator(System.Data.Common.DbDataReader reader, bool closeReader) => throw null;
                public DbEnumerator(System.Data.IDataReader reader) => throw null;
                public DbEnumerator(System.Data.IDataReader reader, bool closeReader) => throw null;
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Data.Common.DbException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbException : System.Runtime.InteropServices.ExternalException
            {
                protected DbException() => throw null;
                protected DbException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected DbException(string message) => throw null;
                protected DbException(string message, System.Exception innerException) => throw null;
                protected DbException(string message, int errorCode) => throw null;
                public virtual bool IsTransient { get => throw null; }
                public virtual string SqlState { get => throw null; }
            }

            // Generated from `System.Data.Common.DbMetaDataCollectionNames` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class DbMetaDataCollectionNames
            {
                public static string DataSourceInformation;
                public static string DataTypes;
                public static string MetaDataCollections;
                public static string ReservedWords;
                public static string Restrictions;
            }

            // Generated from `System.Data.Common.DbMetaDataColumnNames` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class DbMetaDataColumnNames
            {
                public static string CollectionName;
                public static string ColumnSize;
                public static string CompositeIdentifierSeparatorPattern;
                public static string CreateFormat;
                public static string CreateParameters;
                public static string DataSourceProductName;
                public static string DataSourceProductVersion;
                public static string DataSourceProductVersionNormalized;
                public static string DataType;
                public static string GroupByBehavior;
                public static string IdentifierCase;
                public static string IdentifierPattern;
                public static string IsAutoIncrementable;
                public static string IsBestMatch;
                public static string IsCaseSensitive;
                public static string IsConcurrencyType;
                public static string IsFixedLength;
                public static string IsFixedPrecisionScale;
                public static string IsLiteralSupported;
                public static string IsLong;
                public static string IsNullable;
                public static string IsSearchable;
                public static string IsSearchableWithLike;
                public static string IsUnsigned;
                public static string LiteralPrefix;
                public static string LiteralSuffix;
                public static string MaximumScale;
                public static string MinimumScale;
                public static string NumberOfIdentifierParts;
                public static string NumberOfRestrictions;
                public static string OrderByColumnsInSelect;
                public static string ParameterMarkerFormat;
                public static string ParameterMarkerPattern;
                public static string ParameterNameMaxLength;
                public static string ParameterNamePattern;
                public static string ProviderDbType;
                public static string QuotedIdentifierCase;
                public static string QuotedIdentifierPattern;
                public static string ReservedWord;
                public static string StatementSeparatorPattern;
                public static string StringLiteralPattern;
                public static string SupportedJoinOperators;
                public static string TypeName;
            }

            // Generated from `System.Data.Common.DbParameter` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbParameter : System.MarshalByRefObject, System.Data.IDataParameter, System.Data.IDbDataParameter
            {
                protected DbParameter() => throw null;
                public abstract System.Data.DbType DbType { get; set; }
                public abstract System.Data.ParameterDirection Direction { get; set; }
                public abstract bool IsNullable { get; set; }
                public abstract string ParameterName { get; set; }
                public virtual System.Byte Precision { get => throw null; set => throw null; }
                System.Byte System.Data.IDbDataParameter.Precision { get => throw null; set => throw null; }
                public abstract void ResetDbType();
                public virtual System.Byte Scale { get => throw null; set => throw null; }
                System.Byte System.Data.IDbDataParameter.Scale { get => throw null; set => throw null; }
                public abstract int Size { get; set; }
                public abstract string SourceColumn { get; set; }
                public abstract bool SourceColumnNullMapping { get; set; }
                public virtual System.Data.DataRowVersion SourceVersion { get => throw null; set => throw null; }
                public abstract object Value { get; set; }
            }

            // Generated from `System.Data.Common.DbParameterCollection` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbParameterCollection : System.MarshalByRefObject, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Data.IDataParameterCollection
            {
                public abstract int Add(object value);
                int System.Collections.IList.Add(object value) => throw null;
                public abstract void AddRange(System.Array values);
                public abstract void Clear();
                public abstract bool Contains(object value);
                bool System.Collections.IList.Contains(object value) => throw null;
                public abstract bool Contains(string value);
                public abstract void CopyTo(System.Array array, int index);
                public abstract int Count { get; }
                protected DbParameterCollection() => throw null;
                public abstract System.Collections.IEnumerator GetEnumerator();
                protected abstract System.Data.Common.DbParameter GetParameter(int index);
                protected abstract System.Data.Common.DbParameter GetParameter(string parameterName);
                public abstract int IndexOf(object value);
                int System.Collections.IList.IndexOf(object value) => throw null;
                public abstract int IndexOf(string parameterName);
                public abstract void Insert(int index, object value);
                void System.Collections.IList.Insert(int index, object value) => throw null;
                public virtual bool IsFixedSize { get => throw null; }
                public virtual bool IsReadOnly { get => throw null; }
                public virtual bool IsSynchronized { get => throw null; }
                public System.Data.Common.DbParameter this[int index] { get => throw null; set => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                public System.Data.Common.DbParameter this[string parameterName] { get => throw null; set => throw null; }
                object System.Data.IDataParameterCollection.this[string parameterName] { get => throw null; set => throw null; }
                public abstract void Remove(object value);
                void System.Collections.IList.Remove(object value) => throw null;
                public abstract void RemoveAt(int index);
                public abstract void RemoveAt(string parameterName);
                protected abstract void SetParameter(int index, System.Data.Common.DbParameter value);
                protected abstract void SetParameter(string parameterName, System.Data.Common.DbParameter value);
                public abstract object SyncRoot { get; }
            }

            // Generated from `System.Data.Common.DbProviderFactories` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class DbProviderFactories
            {
                public static System.Data.Common.DbProviderFactory GetFactory(System.Data.DataRow providerRow) => throw null;
                public static System.Data.Common.DbProviderFactory GetFactory(System.Data.Common.DbConnection connection) => throw null;
                public static System.Data.Common.DbProviderFactory GetFactory(string providerInvariantName) => throw null;
                public static System.Data.DataTable GetFactoryClasses() => throw null;
                public static System.Collections.Generic.IEnumerable<string> GetProviderInvariantNames() => throw null;
                public static void RegisterFactory(string providerInvariantName, System.Data.Common.DbProviderFactory factory) => throw null;
                public static void RegisterFactory(string providerInvariantName, System.Type providerFactoryClass) => throw null;
                public static void RegisterFactory(string providerInvariantName, string factoryTypeAssemblyQualifiedName) => throw null;
                public static bool TryGetFactory(string providerInvariantName, out System.Data.Common.DbProviderFactory factory) => throw null;
                public static bool UnregisterFactory(string providerInvariantName) => throw null;
            }

            // Generated from `System.Data.Common.DbProviderFactory` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbProviderFactory
            {
                public virtual bool CanCreateCommandBuilder { get => throw null; }
                public virtual bool CanCreateDataAdapter { get => throw null; }
                public virtual bool CanCreateDataSourceEnumerator { get => throw null; }
                public virtual System.Data.Common.DbCommand CreateCommand() => throw null;
                public virtual System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public virtual System.Data.Common.DbConnection CreateConnection() => throw null;
                public virtual System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public virtual System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public virtual System.Data.Common.DbDataSourceEnumerator CreateDataSourceEnumerator() => throw null;
                public virtual System.Data.Common.DbParameter CreateParameter() => throw null;
                protected DbProviderFactory() => throw null;
            }

            // Generated from `System.Data.Common.DbProviderSpecificTypePropertyAttribute` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DbProviderSpecificTypePropertyAttribute : System.Attribute
            {
                public DbProviderSpecificTypePropertyAttribute(bool isProviderSpecificTypeProperty) => throw null;
                public bool IsProviderSpecificTypeProperty { get => throw null; }
            }

            // Generated from `System.Data.Common.DbTransaction` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DbTransaction : System.MarshalByRefObject, System.Data.IDbTransaction, System.IAsyncDisposable, System.IDisposable
            {
                public abstract void Commit();
                public virtual System.Threading.Tasks.Task CommitAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Data.Common.DbConnection Connection { get => throw null; }
                System.Data.IDbConnection System.Data.IDbTransaction.Connection { get => throw null; }
                protected abstract System.Data.Common.DbConnection DbConnection { get; }
                protected DbTransaction() => throw null;
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

            // Generated from `System.Data.Common.GroupByBehavior` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum GroupByBehavior
            {
                ExactMatch,
                MustContainAll,
                NotSupported,
                Unknown,
                Unrelated,
            }

            // Generated from `System.Data.Common.IDbColumnSchemaGenerator` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDbColumnSchemaGenerator
            {
                System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema();
            }

            // Generated from `System.Data.Common.IdentifierCase` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum IdentifierCase
            {
                Insensitive,
                Sensitive,
                Unknown,
            }

            // Generated from `System.Data.Common.RowUpdatedEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RowUpdatedEventArgs : System.EventArgs
            {
                public System.Data.IDbCommand Command { get => throw null; }
                public void CopyToRows(System.Data.DataRow[] array) => throw null;
                public void CopyToRows(System.Data.DataRow[] array, int arrayIndex) => throw null;
                public System.Exception Errors { get => throw null; set => throw null; }
                public int RecordsAffected { get => throw null; }
                public System.Data.DataRow Row { get => throw null; }
                public int RowCount { get => throw null; }
                public RowUpdatedEventArgs(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public System.Data.StatementType StatementType { get => throw null; }
                public System.Data.UpdateStatus Status { get => throw null; set => throw null; }
                public System.Data.Common.DataTableMapping TableMapping { get => throw null; }
            }

            // Generated from `System.Data.Common.RowUpdatingEventArgs` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RowUpdatingEventArgs : System.EventArgs
            {
                protected virtual System.Data.IDbCommand BaseCommand { get => throw null; set => throw null; }
                public System.Data.IDbCommand Command { get => throw null; set => throw null; }
                public System.Exception Errors { get => throw null; set => throw null; }
                public System.Data.DataRow Row { get => throw null; }
                public RowUpdatingEventArgs(System.Data.DataRow dataRow, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) => throw null;
                public System.Data.StatementType StatementType { get => throw null; }
                public System.Data.UpdateStatus Status { get => throw null; set => throw null; }
                public System.Data.Common.DataTableMapping TableMapping { get => throw null; }
            }

            // Generated from `System.Data.Common.SchemaTableColumn` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class SchemaTableColumn
            {
                public static string AllowDBNull;
                public static string BaseColumnName;
                public static string BaseSchemaName;
                public static string BaseTableName;
                public static string ColumnName;
                public static string ColumnOrdinal;
                public static string ColumnSize;
                public static string DataType;
                public static string IsAliased;
                public static string IsExpression;
                public static string IsKey;
                public static string IsLong;
                public static string IsUnique;
                public static string NonVersionedProviderType;
                public static string NumericPrecision;
                public static string NumericScale;
                public static string ProviderType;
            }

            // Generated from `System.Data.Common.SchemaTableOptionalColumn` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class SchemaTableOptionalColumn
            {
                public static string AutoIncrementSeed;
                public static string AutoIncrementStep;
                public static string BaseCatalogName;
                public static string BaseColumnNamespace;
                public static string BaseServerName;
                public static string BaseTableNamespace;
                public static string ColumnMapping;
                public static string DefaultValue;
                public static string Expression;
                public static string IsAutoIncrement;
                public static string IsHidden;
                public static string IsReadOnly;
                public static string IsRowVersion;
                public static string ProviderSpecificDataType;
            }

            // Generated from `System.Data.Common.SupportedJoinOperators` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SupportedJoinOperators
            {
                FullOuter,
                Inner,
                LeftOuter,
                None,
                RightOuter,
            }

        }
        namespace SqlTypes
        {
            // Generated from `System.Data.SqlTypes.INullable` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface INullable
            {
                bool IsNull { get; }
            }

            // Generated from `System.Data.SqlTypes.SqlAlreadyFilledException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlAlreadyFilledException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlAlreadyFilledException() => throw null;
                public SqlAlreadyFilledException(string message) => throw null;
                public SqlAlreadyFilledException(string message, System.Exception e) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlBinary` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlBinary : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBinary operator +(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBinary Add(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlBinary value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlBinary Concat(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public bool IsNull { get => throw null; }
                public System.Byte this[int index] { get => throw null; }
                public int Length { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlBinary x, System.Data.SqlTypes.SqlBinary y) => throw null;
                public static System.Data.SqlTypes.SqlBinary Null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlBinary(System.Byte[] value) => throw null;
                public System.Data.SqlTypes.SqlGuid ToSqlGuid() => throw null;
                public override string ToString() => throw null;
                public System.Byte[] Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.Byte[](System.Data.SqlTypes.SqlBinary x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBinary(System.Data.SqlTypes.SqlGuid x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlBinary(System.Byte[] x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlBoolean` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlBoolean : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator &(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean And(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public System.Byte ByteValue { get => throw null; }
                public int CompareTo(System.Data.SqlTypes.SqlBoolean value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public override bool Equals(object value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean False;
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
                public static System.Data.SqlTypes.SqlBoolean Null;
                public static System.Data.SqlTypes.SqlBoolean One;
                public static System.Data.SqlTypes.SqlBoolean OnesComplement(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Or(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlBoolean(bool value) => throw null;
                public SqlBoolean(int value) => throw null;
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
                public static System.Data.SqlTypes.SqlBoolean True;
                public bool Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Xor(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Zero;
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
                public static implicit operator System.Data.SqlTypes.SqlBoolean(bool x) => throw null;
                public static bool operator true(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator |(System.Data.SqlTypes.SqlBoolean x, System.Data.SqlTypes.SqlBoolean y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ~(System.Data.SqlTypes.SqlBoolean x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlByte` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlByte : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator %(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator &(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator *(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator +(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator -(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator /(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Add(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte BitwiseAnd(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte BitwiseOr(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlByte value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlByte Divide(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte MaxValue;
                public static System.Data.SqlTypes.SqlByte MinValue;
                public static System.Data.SqlTypes.SqlByte Mod(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Modulus(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Multiply(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Null;
                public static System.Data.SqlTypes.SqlByte OnesComplement(System.Data.SqlTypes.SqlByte x) => throw null;
                public static System.Data.SqlTypes.SqlByte Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlByte(System.Byte value) => throw null;
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
                public System.Byte Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlByte Xor(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte Zero;
                public static System.Data.SqlTypes.SqlByte operator ^(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Byte(System.Data.SqlTypes.SqlByte x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlByte(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlByte(System.Byte x) => throw null;
                public static System.Data.SqlTypes.SqlByte operator |(System.Data.SqlTypes.SqlByte x, System.Data.SqlTypes.SqlByte y) => throw null;
                public static System.Data.SqlTypes.SqlByte operator ~(System.Data.SqlTypes.SqlByte x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlBytes` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlBytes : System.Data.SqlTypes.INullable, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
            {
                public System.Byte[] Buffer { get => throw null; }
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public System.Byte this[System.Int64 offset] { get => throw null; set => throw null; }
                public System.Int64 Length { get => throw null; }
                public System.Int64 MaxLength { get => throw null; }
                public static System.Data.SqlTypes.SqlBytes Null { get => throw null; }
                public System.Int64 Read(System.Int64 offset, System.Byte[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public void SetLength(System.Int64 value) => throw null;
                public void SetNull() => throw null;
                public SqlBytes() => throw null;
                public SqlBytes(System.Byte[] buffer) => throw null;
                public SqlBytes(System.Data.SqlTypes.SqlBinary value) => throw null;
                public SqlBytes(System.IO.Stream s) => throw null;
                public System.Data.SqlTypes.StorageState Storage { get => throw null; }
                public System.IO.Stream Stream { get => throw null; set => throw null; }
                public System.Data.SqlTypes.SqlBinary ToSqlBinary() => throw null;
                public System.Byte[] Value { get => throw null; }
                public void Write(System.Int64 offset, System.Byte[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBytes(System.Data.SqlTypes.SqlBinary value) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlBinary(System.Data.SqlTypes.SqlBytes value) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlChars` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlChars : System.Data.SqlTypes.INullable, System.Runtime.Serialization.ISerializable, System.Xml.Serialization.IXmlSerializable
            {
                public System.Char[] Buffer { get => throw null; }
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public System.Char this[System.Int64 offset] { get => throw null; set => throw null; }
                public System.Int64 Length { get => throw null; }
                public System.Int64 MaxLength { get => throw null; }
                public static System.Data.SqlTypes.SqlChars Null { get => throw null; }
                public System.Int64 Read(System.Int64 offset, System.Char[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public void SetLength(System.Int64 value) => throw null;
                public void SetNull() => throw null;
                public SqlChars() => throw null;
                public SqlChars(System.Char[] buffer) => throw null;
                public SqlChars(System.Data.SqlTypes.SqlString value) => throw null;
                public System.Data.SqlTypes.StorageState Storage { get => throw null; }
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public System.Char[] Value { get => throw null; }
                public void Write(System.Int64 offset, System.Char[] buffer, int offsetInBuffer, int count) => throw null;
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlString(System.Data.SqlTypes.SqlChars value) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlChars(System.Data.SqlTypes.SqlString value) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlCompareOptions` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SqlCompareOptions
            {
                BinarySort,
                BinarySort2,
                IgnoreCase,
                IgnoreKanaType,
                IgnoreNonSpace,
                IgnoreWidth,
                None,
            }

            // Generated from `System.Data.SqlTypes.SqlDateTime` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlDateTime : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlDateTime operator +(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public static System.Data.SqlTypes.SqlDateTime operator -(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlDateTime Add(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDateTime value) => throw null;
                public int CompareTo(object value) => throw null;
                public int DayTicks { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlDateTime MaxValue;
                public static System.Data.SqlTypes.SqlDateTime MinValue;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDateTime x, System.Data.SqlTypes.SqlDateTime y) => throw null;
                public static System.Data.SqlTypes.SqlDateTime Null;
                public static System.Data.SqlTypes.SqlDateTime Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static int SQLTicksPerHour;
                public static int SQLTicksPerMinute;
                public static int SQLTicksPerSecond;
                // Stub generator skipped constructor 
                public SqlDateTime(System.DateTime value) => throw null;
                public SqlDateTime(int dayTicks, int timeTicks) => throw null;
                public SqlDateTime(int year, int month, int day) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second, double millisecond) => throw null;
                public SqlDateTime(int year, int month, int day, int hour, int minute, int second, int bilisecond) => throw null;
                public static System.Data.SqlTypes.SqlDateTime Subtract(System.Data.SqlTypes.SqlDateTime x, System.TimeSpan t) => throw null;
                public int TimeTicks { get => throw null; }
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public System.DateTime Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.DateTime(System.Data.SqlTypes.SqlDateTime x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDateTime(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDateTime(System.DateTime value) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlDecimal` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlDecimal : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator *(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator +(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator -(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator -(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal operator /(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Abs(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Add(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal AdjustScale(System.Data.SqlTypes.SqlDecimal n, int digits, bool fRound) => throw null;
                public System.Byte[] BinData { get => throw null; }
                public static System.Data.SqlTypes.SqlDecimal Ceiling(System.Data.SqlTypes.SqlDecimal n) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDecimal value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlDecimal ConvertToPrecScale(System.Data.SqlTypes.SqlDecimal n, int precision, int scale) => throw null;
                public int[] Data { get => throw null; }
                public static System.Data.SqlTypes.SqlDecimal Divide(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
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
                public static System.Byte MaxPrecision;
                public static System.Byte MaxScale;
                public static System.Data.SqlTypes.SqlDecimal MaxValue;
                public static System.Data.SqlTypes.SqlDecimal MinValue;
                public static System.Data.SqlTypes.SqlDecimal Multiply(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDecimal x, System.Data.SqlTypes.SqlDecimal y) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Null;
                public static System.Data.SqlTypes.SqlDecimal Parse(string s) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Power(System.Data.SqlTypes.SqlDecimal n, double exp) => throw null;
                public System.Byte Precision { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public static System.Data.SqlTypes.SqlDecimal Round(System.Data.SqlTypes.SqlDecimal n, int position) => throw null;
                public System.Byte Scale { get => throw null; }
                public static System.Data.SqlTypes.SqlInt32 Sign(System.Data.SqlTypes.SqlDecimal n) => throw null;
                // Stub generator skipped constructor 
                public SqlDecimal(System.Byte bPrecision, System.Byte bScale, bool fPositive, int[] bits) => throw null;
                public SqlDecimal(System.Byte bPrecision, System.Byte bScale, bool fPositive, int data1, int data2, int data3, int data4) => throw null;
                public SqlDecimal(System.Decimal value) => throw null;
                public SqlDecimal(double dVal) => throw null;
                public SqlDecimal(int value) => throw null;
                public SqlDecimal(System.Int64 value) => throw null;
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
                public System.Decimal Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Decimal(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlString x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDecimal(double x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Decimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDecimal(System.Int64 x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlDouble` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlDouble : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator *(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator +(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator -(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator -(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble operator /(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble Add(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlDouble value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlDouble Divide(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble MaxValue;
                public static System.Data.SqlTypes.SqlDouble MinValue;
                public static System.Data.SqlTypes.SqlDouble Multiply(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlDouble x, System.Data.SqlTypes.SqlDouble y) => throw null;
                public static System.Data.SqlTypes.SqlDouble Null;
                public static System.Data.SqlTypes.SqlDouble Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlDouble(double value) => throw null;
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
                public static System.Data.SqlTypes.SqlDouble Zero;
                public static explicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator double(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlDouble(double x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlGuid` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlGuid : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlGuid value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlGuid x, System.Data.SqlTypes.SqlGuid y) => throw null;
                public static System.Data.SqlTypes.SqlGuid Null;
                public static System.Data.SqlTypes.SqlGuid Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlGuid(System.Byte[] value) => throw null;
                public SqlGuid(System.Guid g) => throw null;
                public SqlGuid(int a, System.Int16 b, System.Int16 c, System.Byte d, System.Byte e, System.Byte f, System.Byte g, System.Byte h, System.Byte i, System.Byte j, System.Byte k) => throw null;
                public SqlGuid(string s) => throw null;
                public System.Byte[] ToByteArray() => throw null;
                public System.Data.SqlTypes.SqlBinary ToSqlBinary() => throw null;
                public System.Data.SqlTypes.SqlString ToSqlString() => throw null;
                public override string ToString() => throw null;
                public System.Guid Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlGuid(System.Data.SqlTypes.SqlBinary x) => throw null;
                public static explicit operator System.Guid(System.Data.SqlTypes.SqlGuid x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlGuid(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlGuid(System.Guid x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlInt16` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlInt16 : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator %(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator &(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator *(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator +(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator -(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator -(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator /(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Add(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 BitwiseAnd(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 BitwiseOr(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt16 value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Divide(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 MaxValue;
                public static System.Data.SqlTypes.SqlInt16 MinValue;
                public static System.Data.SqlTypes.SqlInt16 Mod(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Modulus(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Multiply(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Null;
                public static System.Data.SqlTypes.SqlInt16 OnesComplement(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlInt16(System.Int16 value) => throw null;
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
                public System.Int16 Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Xor(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 Zero;
                public static System.Data.SqlTypes.SqlInt16 operator ^(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Int16(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt16(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt16(System.Int16 x) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator |(System.Data.SqlTypes.SqlInt16 x, System.Data.SqlTypes.SqlInt16 y) => throw null;
                public static System.Data.SqlTypes.SqlInt16 operator ~(System.Data.SqlTypes.SqlInt16 x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlInt32` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlInt32 : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator %(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator &(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator *(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator +(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator -(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator -(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator /(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Add(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 BitwiseAnd(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 BitwiseOr(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt32 value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Divide(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 MaxValue;
                public static System.Data.SqlTypes.SqlInt32 MinValue;
                public static System.Data.SqlTypes.SqlInt32 Mod(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Modulus(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Multiply(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Null;
                public static System.Data.SqlTypes.SqlInt32 OnesComplement(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlInt32(int value) => throw null;
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
                public static System.Data.SqlTypes.SqlInt32 Zero;
                public static System.Data.SqlTypes.SqlInt32 operator ^(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator int(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt32(int x) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator |(System.Data.SqlTypes.SqlInt32 x, System.Data.SqlTypes.SqlInt32 y) => throw null;
                public static System.Data.SqlTypes.SqlInt32 operator ~(System.Data.SqlTypes.SqlInt32 x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlInt64` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlInt64 : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator %(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator &(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator *(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator +(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator -(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator -(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator /(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Add(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 BitwiseAnd(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 BitwiseOr(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlInt64 value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Divide(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 MaxValue;
                public static System.Data.SqlTypes.SqlInt64 MinValue;
                public static System.Data.SqlTypes.SqlInt64 Mod(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Modulus(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Multiply(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Null;
                public static System.Data.SqlTypes.SqlInt64 OnesComplement(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlInt64(System.Int64 value) => throw null;
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
                public System.Int64 Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Xor(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 Zero;
                public static System.Data.SqlTypes.SqlInt64 operator ^(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Int64(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlInt64(System.Int64 x) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator |(System.Data.SqlTypes.SqlInt64 x, System.Data.SqlTypes.SqlInt64 y) => throw null;
                public static System.Data.SqlTypes.SqlInt64 operator ~(System.Data.SqlTypes.SqlInt64 x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlMoney` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlMoney : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator *(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator +(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator -(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator -(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney operator /(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney Add(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlMoney value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlMoney Divide(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney MaxValue;
                public static System.Data.SqlTypes.SqlMoney MinValue;
                public static System.Data.SqlTypes.SqlMoney Multiply(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public static System.Data.SqlTypes.SqlMoney Null;
                public static System.Data.SqlTypes.SqlMoney Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlMoney(System.Decimal value) => throw null;
                public SqlMoney(double value) => throw null;
                public SqlMoney(int value) => throw null;
                public SqlMoney(System.Int64 value) => throw null;
                public static System.Data.SqlTypes.SqlMoney Subtract(System.Data.SqlTypes.SqlMoney x, System.Data.SqlTypes.SqlMoney y) => throw null;
                public System.Decimal ToDecimal() => throw null;
                public double ToDouble() => throw null;
                public int ToInt32() => throw null;
                public System.Int64 ToInt64() => throw null;
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
                public System.Decimal Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
                public static System.Data.SqlTypes.SqlMoney Zero;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator System.Decimal(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlString x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlMoney(double x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Decimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlMoney(System.Int64 x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlNotFilledException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlNotFilledException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlNotFilledException() => throw null;
                public SqlNotFilledException(string message) => throw null;
                public SqlNotFilledException(string message, System.Exception e) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlNullValueException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlNullValueException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlNullValueException() => throw null;
                public SqlNullValueException(string message) => throw null;
                public SqlNullValueException(string message, System.Exception e) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlSingle` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlSingle : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator *(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator +(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator -(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator -(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle operator /(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle Add(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlSingle value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlSingle Divide(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle MaxValue;
                public static System.Data.SqlTypes.SqlSingle MinValue;
                public static System.Data.SqlTypes.SqlSingle Multiply(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlSingle x, System.Data.SqlTypes.SqlSingle y) => throw null;
                public static System.Data.SqlTypes.SqlSingle Null;
                public static System.Data.SqlTypes.SqlSingle Parse(string s) => throw null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                // Stub generator skipped constructor 
                public SqlSingle(double value) => throw null;
                public SqlSingle(float value) => throw null;
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
                public static System.Data.SqlTypes.SqlSingle Zero;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlBoolean x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlDouble x) => throw null;
                public static explicit operator float(System.Data.SqlTypes.SqlSingle x) => throw null;
                public static explicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlString x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlByte x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlDecimal x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt16 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt32 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlInt64 x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(System.Data.SqlTypes.SqlMoney x) => throw null;
                public static implicit operator System.Data.SqlTypes.SqlSingle(float x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlString` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SqlString : System.Data.SqlTypes.INullable, System.IComparable, System.Xml.Serialization.IXmlSerializable
            {
                public static System.Data.SqlTypes.SqlBoolean operator !=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlString operator +(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator <=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator ==(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean operator >=(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlString Add(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static int BinarySort;
                public static int BinarySort2;
                public System.Data.SqlTypes.SqlString Clone() => throw null;
                public System.Globalization.CompareInfo CompareInfo { get => throw null; }
                public static System.Globalization.CompareOptions CompareOptionsFromSqlCompareOptions(System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
                public int CompareTo(System.Data.SqlTypes.SqlString value) => throw null;
                public int CompareTo(object value) => throw null;
                public static System.Data.SqlTypes.SqlString Concat(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public System.Globalization.CultureInfo CultureInfo { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean Equals(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                public System.Byte[] GetNonUnicodeBytes() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public System.Byte[] GetUnicodeBytes() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThan(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean GreaterThanOrEqual(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static int IgnoreCase;
                public static int IgnoreKanaType;
                public static int IgnoreNonSpace;
                public static int IgnoreWidth;
                public bool IsNull { get => throw null; }
                public int LCID { get => throw null; }
                public static System.Data.SqlTypes.SqlBoolean LessThan(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean LessThanOrEqual(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlBoolean NotEquals(System.Data.SqlTypes.SqlString x, System.Data.SqlTypes.SqlString y) => throw null;
                public static System.Data.SqlTypes.SqlString Null;
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader reader) => throw null;
                public System.Data.SqlTypes.SqlCompareOptions SqlCompareOptions { get => throw null; }
                // Stub generator skipped constructor 
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Byte[] data) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Byte[] data, bool fUnicode) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Byte[] data, int index, int count) => throw null;
                public SqlString(int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Byte[] data, int index, int count, bool fUnicode) => throw null;
                public SqlString(string data) => throw null;
                public SqlString(string data, int lcid) => throw null;
                public SqlString(string data, int lcid, System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
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
                public static implicit operator System.Data.SqlTypes.SqlString(string x) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlTruncateException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlTruncateException : System.Data.SqlTypes.SqlTypeException
            {
                public SqlTruncateException() => throw null;
                public SqlTruncateException(string message) => throw null;
                public SqlTruncateException(string message, System.Exception e) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlTypeException` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlTypeException : System.SystemException
            {
                public SqlTypeException() => throw null;
                protected SqlTypeException(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext sc) => throw null;
                public SqlTypeException(string message) => throw null;
                public SqlTypeException(string message, System.Exception e) => throw null;
            }

            // Generated from `System.Data.SqlTypes.SqlXml` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlXml : System.Data.SqlTypes.INullable, System.Xml.Serialization.IXmlSerializable
            {
                public System.Xml.XmlReader CreateReader() => throw null;
                System.Xml.Schema.XmlSchema System.Xml.Serialization.IXmlSerializable.GetSchema() => throw null;
                public static System.Xml.XmlQualifiedName GetXsdType(System.Xml.Schema.XmlSchemaSet schemaSet) => throw null;
                public bool IsNull { get => throw null; }
                public static System.Data.SqlTypes.SqlXml Null { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.ReadXml(System.Xml.XmlReader r) => throw null;
                public SqlXml() => throw null;
                public SqlXml(System.IO.Stream value) => throw null;
                public SqlXml(System.Xml.XmlReader value) => throw null;
                public string Value { get => throw null; }
                void System.Xml.Serialization.IXmlSerializable.WriteXml(System.Xml.XmlWriter writer) => throw null;
            }

            // Generated from `System.Data.SqlTypes.StorageState` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum StorageState
            {
                Buffer,
                Stream,
                UnmanagedBuffer,
            }

        }
    }
    namespace Xml
    {
        // Generated from `System.Xml.XmlDataDocument` in `System.Data.Common, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlDataDocument : System.Xml.XmlDocument
        {
            public override System.Xml.XmlNode CloneNode(bool deep) => throw null;
            public override System.Xml.XmlElement CreateElement(string prefix, string localName, string namespaceURI) => throw null;
            public override System.Xml.XmlEntityReference CreateEntityReference(string name) => throw null;
            protected internal override System.Xml.XPath.XPathNavigator CreateNavigator(System.Xml.XmlNode node) => throw null;
            public System.Data.DataSet DataSet { get => throw null; }
            public override System.Xml.XmlElement GetElementById(string elemId) => throw null;
            public System.Xml.XmlElement GetElementFromRow(System.Data.DataRow r) => throw null;
            public override System.Xml.XmlNodeList GetElementsByTagName(string name) => throw null;
            public System.Data.DataRow GetRowFromElement(System.Xml.XmlElement e) => throw null;
            public override void Load(System.IO.Stream inStream) => throw null;
            public override void Load(System.IO.TextReader txtReader) => throw null;
            public override void Load(System.Xml.XmlReader reader) => throw null;
            public override void Load(string filename) => throw null;
            public XmlDataDocument() => throw null;
            public XmlDataDocument(System.Data.DataSet dataset) => throw null;
        }

    }
}
