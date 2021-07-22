// This file contains auto-generated code.

namespace Microsoft
{
    namespace SqlServer
    {
        namespace Server
        {
            // Generated from `Microsoft.SqlServer.Server.DataAccessKind` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum DataAccessKind
            {
                None,
                Read,
            }

            // Generated from `Microsoft.SqlServer.Server.Format` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum Format
            {
                Native,
                Unknown,
                UserDefined,
            }

            // Generated from `Microsoft.SqlServer.Server.IBinarySerialize` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IBinarySerialize
            {
                void Read(System.IO.BinaryReader r);
                void Write(System.IO.BinaryWriter w);
            }

            // Generated from `Microsoft.SqlServer.Server.InvalidUdtException` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidUdtException : System.SystemException
            {
            }

            // Generated from `Microsoft.SqlServer.Server.SqlDataRecord` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlDataRecord : System.Data.IDataRecord
            {
                public virtual int FieldCount { get => throw null; }
                public virtual bool GetBoolean(int ordinal) => throw null;
                public virtual System.Byte GetByte(int ordinal) => throw null;
                public virtual System.Int64 GetBytes(int ordinal, System.Int64 fieldOffset, System.Byte[] buffer, int bufferOffset, int length) => throw null;
                public virtual System.Char GetChar(int ordinal) => throw null;
                public virtual System.Int64 GetChars(int ordinal, System.Int64 fieldOffset, System.Char[] buffer, int bufferOffset, int length) => throw null;
                System.Data.IDataReader System.Data.IDataRecord.GetData(int ordinal) => throw null;
                public virtual string GetDataTypeName(int ordinal) => throw null;
                public virtual System.DateTime GetDateTime(int ordinal) => throw null;
                public virtual System.DateTimeOffset GetDateTimeOffset(int ordinal) => throw null;
                public virtual System.Decimal GetDecimal(int ordinal) => throw null;
                public virtual double GetDouble(int ordinal) => throw null;
                public virtual System.Type GetFieldType(int ordinal) => throw null;
                public virtual float GetFloat(int ordinal) => throw null;
                public virtual System.Guid GetGuid(int ordinal) => throw null;
                public virtual System.Int16 GetInt16(int ordinal) => throw null;
                public virtual int GetInt32(int ordinal) => throw null;
                public virtual System.Int64 GetInt64(int ordinal) => throw null;
                public virtual string GetName(int ordinal) => throw null;
                public virtual int GetOrdinal(string name) => throw null;
                public virtual System.Data.SqlTypes.SqlBinary GetSqlBinary(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlBoolean GetSqlBoolean(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlByte GetSqlByte(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlBytes GetSqlBytes(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlChars GetSqlChars(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlDateTime GetSqlDateTime(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlDecimal GetSqlDecimal(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlDouble GetSqlDouble(int ordinal) => throw null;
                public virtual System.Type GetSqlFieldType(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlGuid GetSqlGuid(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlInt16 GetSqlInt16(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlInt32 GetSqlInt32(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlInt64 GetSqlInt64(int ordinal) => throw null;
                public virtual Microsoft.SqlServer.Server.SqlMetaData GetSqlMetaData(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlMoney GetSqlMoney(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlSingle GetSqlSingle(int ordinal) => throw null;
                public virtual System.Data.SqlTypes.SqlString GetSqlString(int ordinal) => throw null;
                public virtual object GetSqlValue(int ordinal) => throw null;
                public virtual int GetSqlValues(object[] values) => throw null;
                public virtual System.Data.SqlTypes.SqlXml GetSqlXml(int ordinal) => throw null;
                public virtual string GetString(int ordinal) => throw null;
                public virtual System.TimeSpan GetTimeSpan(int ordinal) => throw null;
                public virtual object GetValue(int ordinal) => throw null;
                public virtual int GetValues(object[] values) => throw null;
                public virtual bool IsDBNull(int ordinal) => throw null;
                public virtual object this[string name] { get => throw null; }
                public virtual object this[int ordinal] { get => throw null; }
                public virtual void SetBoolean(int ordinal, bool value) => throw null;
                public virtual void SetByte(int ordinal, System.Byte value) => throw null;
                public virtual void SetBytes(int ordinal, System.Int64 fieldOffset, System.Byte[] buffer, int bufferOffset, int length) => throw null;
                public virtual void SetChar(int ordinal, System.Char value) => throw null;
                public virtual void SetChars(int ordinal, System.Int64 fieldOffset, System.Char[] buffer, int bufferOffset, int length) => throw null;
                public virtual void SetDBNull(int ordinal) => throw null;
                public virtual void SetDateTime(int ordinal, System.DateTime value) => throw null;
                public virtual void SetDateTimeOffset(int ordinal, System.DateTimeOffset value) => throw null;
                public virtual void SetDecimal(int ordinal, System.Decimal value) => throw null;
                public virtual void SetDouble(int ordinal, double value) => throw null;
                public virtual void SetFloat(int ordinal, float value) => throw null;
                public virtual void SetGuid(int ordinal, System.Guid value) => throw null;
                public virtual void SetInt16(int ordinal, System.Int16 value) => throw null;
                public virtual void SetInt32(int ordinal, int value) => throw null;
                public virtual void SetInt64(int ordinal, System.Int64 value) => throw null;
                public virtual void SetSqlBinary(int ordinal, System.Data.SqlTypes.SqlBinary value) => throw null;
                public virtual void SetSqlBoolean(int ordinal, System.Data.SqlTypes.SqlBoolean value) => throw null;
                public virtual void SetSqlByte(int ordinal, System.Data.SqlTypes.SqlByte value) => throw null;
                public virtual void SetSqlBytes(int ordinal, System.Data.SqlTypes.SqlBytes value) => throw null;
                public virtual void SetSqlChars(int ordinal, System.Data.SqlTypes.SqlChars value) => throw null;
                public virtual void SetSqlDateTime(int ordinal, System.Data.SqlTypes.SqlDateTime value) => throw null;
                public virtual void SetSqlDecimal(int ordinal, System.Data.SqlTypes.SqlDecimal value) => throw null;
                public virtual void SetSqlDouble(int ordinal, System.Data.SqlTypes.SqlDouble value) => throw null;
                public virtual void SetSqlGuid(int ordinal, System.Data.SqlTypes.SqlGuid value) => throw null;
                public virtual void SetSqlInt16(int ordinal, System.Data.SqlTypes.SqlInt16 value) => throw null;
                public virtual void SetSqlInt32(int ordinal, System.Data.SqlTypes.SqlInt32 value) => throw null;
                public virtual void SetSqlInt64(int ordinal, System.Data.SqlTypes.SqlInt64 value) => throw null;
                public virtual void SetSqlMoney(int ordinal, System.Data.SqlTypes.SqlMoney value) => throw null;
                public virtual void SetSqlSingle(int ordinal, System.Data.SqlTypes.SqlSingle value) => throw null;
                public virtual void SetSqlString(int ordinal, System.Data.SqlTypes.SqlString value) => throw null;
                public virtual void SetSqlXml(int ordinal, System.Data.SqlTypes.SqlXml value) => throw null;
                public virtual void SetString(int ordinal, string value) => throw null;
                public virtual void SetTimeSpan(int ordinal, System.TimeSpan value) => throw null;
                public virtual void SetValue(int ordinal, object value) => throw null;
                public virtual int SetValues(params object[] values) => throw null;
                public SqlDataRecord(params Microsoft.SqlServer.Server.SqlMetaData[] metaData) => throw null;
            }

            // Generated from `Microsoft.SqlServer.Server.SqlFacetAttribute` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlFacetAttribute : System.Attribute
            {
                public bool IsFixedLength { get => throw null; set => throw null; }
                public bool IsNullable { get => throw null; set => throw null; }
                public int MaxSize { get => throw null; set => throw null; }
                public int Precision { get => throw null; set => throw null; }
                public int Scale { get => throw null; set => throw null; }
                public SqlFacetAttribute() => throw null;
            }

            // Generated from `Microsoft.SqlServer.Server.SqlFunctionAttribute` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlFunctionAttribute : System.Attribute
            {
                public Microsoft.SqlServer.Server.DataAccessKind DataAccess { get => throw null; set => throw null; }
                public string FillRowMethodName { get => throw null; set => throw null; }
                public bool IsDeterministic { get => throw null; set => throw null; }
                public bool IsPrecise { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public SqlFunctionAttribute() => throw null;
                public Microsoft.SqlServer.Server.SystemDataAccessKind SystemDataAccess { get => throw null; set => throw null; }
                public string TableDefinition { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.SqlServer.Server.SqlMetaData` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlMetaData
            {
                public string Adjust(string value) => throw null;
                public object Adjust(object value) => throw null;
                public int Adjust(int value) => throw null;
                public float Adjust(float value) => throw null;
                public double Adjust(double value) => throw null;
                public bool Adjust(bool value) => throw null;
                public System.TimeSpan Adjust(System.TimeSpan value) => throw null;
                public System.Int64 Adjust(System.Int64 value) => throw null;
                public System.Int16 Adjust(System.Int16 value) => throw null;
                public System.Guid Adjust(System.Guid value) => throw null;
                public System.Decimal Adjust(System.Decimal value) => throw null;
                public System.DateTimeOffset Adjust(System.DateTimeOffset value) => throw null;
                public System.DateTime Adjust(System.DateTime value) => throw null;
                public System.Data.SqlTypes.SqlXml Adjust(System.Data.SqlTypes.SqlXml value) => throw null;
                public System.Data.SqlTypes.SqlString Adjust(System.Data.SqlTypes.SqlString value) => throw null;
                public System.Data.SqlTypes.SqlSingle Adjust(System.Data.SqlTypes.SqlSingle value) => throw null;
                public System.Data.SqlTypes.SqlMoney Adjust(System.Data.SqlTypes.SqlMoney value) => throw null;
                public System.Data.SqlTypes.SqlInt64 Adjust(System.Data.SqlTypes.SqlInt64 value) => throw null;
                public System.Data.SqlTypes.SqlInt32 Adjust(System.Data.SqlTypes.SqlInt32 value) => throw null;
                public System.Data.SqlTypes.SqlInt16 Adjust(System.Data.SqlTypes.SqlInt16 value) => throw null;
                public System.Data.SqlTypes.SqlGuid Adjust(System.Data.SqlTypes.SqlGuid value) => throw null;
                public System.Data.SqlTypes.SqlDouble Adjust(System.Data.SqlTypes.SqlDouble value) => throw null;
                public System.Data.SqlTypes.SqlDecimal Adjust(System.Data.SqlTypes.SqlDecimal value) => throw null;
                public System.Data.SqlTypes.SqlDateTime Adjust(System.Data.SqlTypes.SqlDateTime value) => throw null;
                public System.Data.SqlTypes.SqlChars Adjust(System.Data.SqlTypes.SqlChars value) => throw null;
                public System.Data.SqlTypes.SqlBytes Adjust(System.Data.SqlTypes.SqlBytes value) => throw null;
                public System.Data.SqlTypes.SqlByte Adjust(System.Data.SqlTypes.SqlByte value) => throw null;
                public System.Data.SqlTypes.SqlBoolean Adjust(System.Data.SqlTypes.SqlBoolean value) => throw null;
                public System.Data.SqlTypes.SqlBinary Adjust(System.Data.SqlTypes.SqlBinary value) => throw null;
                public System.Char[] Adjust(System.Char[] value) => throw null;
                public System.Char Adjust(System.Char value) => throw null;
                public System.Byte[] Adjust(System.Byte[] value) => throw null;
                public System.Byte Adjust(System.Byte value) => throw null;
                public System.Data.SqlTypes.SqlCompareOptions CompareOptions { get => throw null; }
                public System.Data.DbType DbType { get => throw null; }
                public static Microsoft.SqlServer.Server.SqlMetaData InferFromValue(object value, string name) => throw null;
                public bool IsUniqueKey { get => throw null; }
                public System.Int64 LocaleId { get => throw null; }
                public static System.Int64 Max { get => throw null; }
                public System.Int64 MaxLength { get => throw null; }
                public string Name { get => throw null; }
                public System.Byte Precision { get => throw null; }
                public System.Byte Scale { get => throw null; }
                public System.Data.SqlClient.SortOrder SortOrder { get => throw null; }
                public int SortOrdinal { get => throw null; }
                public System.Data.SqlDbType SqlDbType { get => throw null; }
                public SqlMetaData(string name, System.Data.SqlDbType dbType, string database, string owningSchema, string objectName, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, string database, string owningSchema, string objectName) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType, string serverTypeName, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType, string serverTypeName) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength, System.Int64 locale, System.Data.SqlTypes.SqlCompareOptions compareOptions, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength, System.Int64 locale, System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength, System.Byte precision, System.Byte scale, System.Int64 localeId, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Type userDefinedType, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength, System.Byte precision, System.Byte scale, System.Int64 locale, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Type userDefinedType) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Int64 maxLength) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Byte precision, System.Byte scale, bool useServerDefault, bool isUniqueKey, System.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Byte precision, System.Byte scale) => throw null;
                public SqlMetaData(string name, System.Data.SqlDbType dbType) => throw null;
                public System.Type Type { get => throw null; }
                public string TypeName { get => throw null; }
                public bool UseServerDefault { get => throw null; }
                public string XmlSchemaCollectionDatabase { get => throw null; }
                public string XmlSchemaCollectionName { get => throw null; }
                public string XmlSchemaCollectionOwningSchema { get => throw null; }
            }

            // Generated from `Microsoft.SqlServer.Server.SqlMethodAttribute` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlMethodAttribute : Microsoft.SqlServer.Server.SqlFunctionAttribute
            {
                public bool InvokeIfReceiverIsNull { get => throw null; set => throw null; }
                public bool IsMutator { get => throw null; set => throw null; }
                public bool OnNullCall { get => throw null; set => throw null; }
                public SqlMethodAttribute() => throw null;
            }

            // Generated from `Microsoft.SqlServer.Server.SqlUserDefinedAggregateAttribute` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlUserDefinedAggregateAttribute : System.Attribute
            {
                public Microsoft.SqlServer.Server.Format Format { get => throw null; }
                public bool IsInvariantToDuplicates { get => throw null; set => throw null; }
                public bool IsInvariantToNulls { get => throw null; set => throw null; }
                public bool IsInvariantToOrder { get => throw null; set => throw null; }
                public bool IsNullIfEmpty { get => throw null; set => throw null; }
                public int MaxByteSize { get => throw null; set => throw null; }
                public const int MaxByteSizeValue = default;
                public string Name { get => throw null; set => throw null; }
                public SqlUserDefinedAggregateAttribute(Microsoft.SqlServer.Server.Format format) => throw null;
            }

            // Generated from `Microsoft.SqlServer.Server.SqlUserDefinedTypeAttribute` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlUserDefinedTypeAttribute : System.Attribute
            {
                public Microsoft.SqlServer.Server.Format Format { get => throw null; }
                public bool IsByteOrdered { get => throw null; set => throw null; }
                public bool IsFixedLength { get => throw null; set => throw null; }
                public int MaxByteSize { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public SqlUserDefinedTypeAttribute(Microsoft.SqlServer.Server.Format format) => throw null;
                public string ValidationMethodName { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.SqlServer.Server.SystemDataAccessKind` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SystemDataAccessKind
            {
                None,
                Read,
            }

        }
    }
}
namespace System
{
    namespace Data
    {
        // Generated from `System.Data.OperationAbortedException` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class OperationAbortedException : System.SystemException
        {
        }

        namespace Sql
        {
            // Generated from `System.Data.Sql.SqlNotificationRequest` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlNotificationRequest
            {
                public string Options { get => throw null; set => throw null; }
                public SqlNotificationRequest(string userData, string options, int timeout) => throw null;
                public SqlNotificationRequest() => throw null;
                public int Timeout { get => throw null; set => throw null; }
                public string UserData { get => throw null; set => throw null; }
            }

        }
        namespace SqlClient
        {
            // Generated from `System.Data.SqlClient.ApplicationIntent` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ApplicationIntent
            {
                ReadOnly,
                ReadWrite,
            }

            // Generated from `System.Data.SqlClient.OnChangeEventHandler` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void OnChangeEventHandler(object sender, System.Data.SqlClient.SqlNotificationEventArgs e);

            // Generated from `System.Data.SqlClient.PoolBlockingPeriod` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PoolBlockingPeriod
            {
                AlwaysBlock,
                Auto,
                NeverBlock,
            }

            // Generated from `System.Data.SqlClient.SortOrder` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SortOrder
            {
                Ascending,
                Descending,
                Unspecified,
            }

            // Generated from `System.Data.SqlClient.SqlBulkCopy` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlBulkCopy : System.IDisposable
            {
                public int BatchSize { get => throw null; set => throw null; }
                public int BulkCopyTimeout { get => throw null; set => throw null; }
                public void Close() => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMappingCollection ColumnMappings { get => throw null; }
                public string DestinationTableName { get => throw null; set => throw null; }
                void System.IDisposable.Dispose() => throw null;
                public bool EnableStreaming { get => throw null; set => throw null; }
                public int NotifyAfter { get => throw null; set => throw null; }
                public SqlBulkCopy(string connectionString, System.Data.SqlClient.SqlBulkCopyOptions copyOptions) => throw null;
                public SqlBulkCopy(string connectionString) => throw null;
                public SqlBulkCopy(System.Data.SqlClient.SqlConnection connection, System.Data.SqlClient.SqlBulkCopyOptions copyOptions, System.Data.SqlClient.SqlTransaction externalTransaction) => throw null;
                public SqlBulkCopy(System.Data.SqlClient.SqlConnection connection) => throw null;
                public event System.Data.SqlClient.SqlRowsCopiedEventHandler SqlRowsCopied;
                public void WriteToServer(System.Data.IDataReader reader) => throw null;
                public void WriteToServer(System.Data.DataTable table, System.Data.DataRowState rowState) => throw null;
                public void WriteToServer(System.Data.DataTable table) => throw null;
                public void WriteToServer(System.Data.DataRow[] rows) => throw null;
                public void WriteToServer(System.Data.Common.DbDataReader reader) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.IDataReader reader, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.IDataReader reader) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Data.DataRowState rowState, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Data.DataRowState rowState) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataRow[] rows, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataRow[] rows) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.Common.DbDataReader reader, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.Common.DbDataReader reader) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlBulkCopyColumnMapping` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlBulkCopyColumnMapping
            {
                public string DestinationColumn { get => throw null; set => throw null; }
                public int DestinationOrdinal { get => throw null; set => throw null; }
                public string SourceColumn { get => throw null; set => throw null; }
                public int SourceOrdinal { get => throw null; set => throw null; }
                public SqlBulkCopyColumnMapping(string sourceColumn, string destinationColumn) => throw null;
                public SqlBulkCopyColumnMapping(string sourceColumn, int destinationOrdinal) => throw null;
                public SqlBulkCopyColumnMapping(int sourceColumnOrdinal, string destinationColumn) => throw null;
                public SqlBulkCopyColumnMapping(int sourceColumnOrdinal, int destinationOrdinal) => throw null;
                public SqlBulkCopyColumnMapping() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlBulkCopyColumnMappingCollection` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlBulkCopyColumnMappingCollection : System.Collections.CollectionBase
            {
                public System.Data.SqlClient.SqlBulkCopyColumnMapping Add(string sourceColumn, string destinationColumn) => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMapping Add(string sourceColumn, int destinationColumnIndex) => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMapping Add(int sourceColumnIndex, string destinationColumn) => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMapping Add(int sourceColumnIndex, int destinationColumnIndex) => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMapping Add(System.Data.SqlClient.SqlBulkCopyColumnMapping bulkCopyColumnMapping) => throw null;
                public void Clear() => throw null;
                public bool Contains(System.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void CopyTo(System.Data.SqlClient.SqlBulkCopyColumnMapping[] array, int index) => throw null;
                public int IndexOf(System.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void Insert(int index, System.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public System.Data.SqlClient.SqlBulkCopyColumnMapping this[int index] { get => throw null; }
                public void Remove(System.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void RemoveAt(int index) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlBulkCopyOptions` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SqlBulkCopyOptions
            {
                CheckConstraints,
                Default,
                FireTriggers,
                KeepIdentity,
                KeepNulls,
                TableLock,
                UseInternalTransaction,
            }

            // Generated from `System.Data.SqlClient.SqlClientFactory` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlClientFactory : System.Data.Common.DbProviderFactory
            {
                public override System.Data.Common.DbCommand CreateCommand() => throw null;
                public override System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public override System.Data.Common.DbConnection CreateConnection() => throw null;
                public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public override System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public override System.Data.Common.DbParameter CreateParameter() => throw null;
                public static System.Data.SqlClient.SqlClientFactory Instance;
            }

            // Generated from `System.Data.SqlClient.SqlClientMetaDataCollectionNames` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class SqlClientMetaDataCollectionNames
            {
                public static string Columns;
                public static string Databases;
                public static string ForeignKeys;
                public static string IndexColumns;
                public static string Indexes;
                public static string Parameters;
                public static string ProcedureColumns;
                public static string Procedures;
                public static string Tables;
                public static string UserDefinedTypes;
                public static string Users;
                public static string ViewColumns;
                public static string Views;
            }

            // Generated from `System.Data.SqlClient.SqlCommand` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlCommand : System.Data.Common.DbCommand, System.ICloneable
            {
                public System.IAsyncResult BeginExecuteNonQuery(System.AsyncCallback callback, object stateObject) => throw null;
                public System.IAsyncResult BeginExecuteNonQuery() => throw null;
                public System.IAsyncResult BeginExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.IAsyncResult BeginExecuteReader(System.AsyncCallback callback, object stateObject, System.Data.CommandBehavior behavior) => throw null;
                public System.IAsyncResult BeginExecuteReader(System.AsyncCallback callback, object stateObject) => throw null;
                public System.IAsyncResult BeginExecuteReader() => throw null;
                public System.IAsyncResult BeginExecuteXmlReader(System.AsyncCallback callback, object stateObject) => throw null;
                public System.IAsyncResult BeginExecuteXmlReader() => throw null;
                public override void Cancel() => throw null;
                public System.Data.SqlClient.SqlCommand Clone() => throw null;
                object System.ICloneable.Clone() => throw null;
                public override string CommandText { get => throw null; set => throw null; }
                public override int CommandTimeout { get => throw null; set => throw null; }
                public override System.Data.CommandType CommandType { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlConnection Connection { get => throw null; set => throw null; }
                protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                public System.Data.SqlClient.SqlParameter CreateParameter() => throw null;
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set => throw null; }
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set => throw null; }
                public override bool DesignTimeVisible { get => throw null; set => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public int EndExecuteNonQuery(System.IAsyncResult asyncResult) => throw null;
                public System.Data.SqlClient.SqlDataReader EndExecuteReader(System.IAsyncResult asyncResult) => throw null;
                public System.Xml.XmlReader EndExecuteXmlReader(System.IAsyncResult asyncResult) => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                protected override System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public override System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Data.SqlClient.SqlDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.Data.SqlClient.SqlDataReader ExecuteReader() => throw null;
                public System.Threading.Tasks.Task<System.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<System.Data.SqlClient.SqlDataReader> ExecuteReaderAsync() => throw null;
                public override object ExecuteScalar() => throw null;
                public override System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Xml.XmlReader ExecuteXmlReader() => throw null;
                public System.Threading.Tasks.Task<System.Xml.XmlReader> ExecuteXmlReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Xml.XmlReader> ExecuteXmlReaderAsync() => throw null;
                public System.Data.Sql.SqlNotificationRequest Notification { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlParameterCollection Parameters { get => throw null; }
                public override void Prepare() => throw null;
                public void ResetCommandTimeout() => throw null;
                public SqlCommand(string cmdText, System.Data.SqlClient.SqlConnection connection, System.Data.SqlClient.SqlTransaction transaction) => throw null;
                public SqlCommand(string cmdText, System.Data.SqlClient.SqlConnection connection) => throw null;
                public SqlCommand(string cmdText) => throw null;
                public SqlCommand() => throw null;
                public event System.Data.StatementCompletedEventHandler StatementCompleted;
                public System.Data.SqlClient.SqlTransaction Transaction { get => throw null; set => throw null; }
                public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlCommandBuilder` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlCommandBuilder : System.Data.Common.DbCommandBuilder
            {
                protected override void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow datarow, System.Data.StatementType statementType, bool whereClause) => throw null;
                public override System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set => throw null; }
                public override string CatalogSeparator { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlDataAdapter DataAdapter { get => throw null; set => throw null; }
                public static void DeriveParameters(System.Data.SqlClient.SqlCommand command) => throw null;
                public System.Data.SqlClient.SqlCommand GetDeleteCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.SqlClient.SqlCommand GetDeleteCommand() => throw null;
                public System.Data.SqlClient.SqlCommand GetInsertCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.SqlClient.SqlCommand GetInsertCommand() => throw null;
                protected override string GetParameterName(string parameterName) => throw null;
                protected override string GetParameterName(int parameterOrdinal) => throw null;
                protected override string GetParameterPlaceholder(int parameterOrdinal) => throw null;
                protected override System.Data.DataTable GetSchemaTable(System.Data.Common.DbCommand srcCommand) => throw null;
                public System.Data.SqlClient.SqlCommand GetUpdateCommand(bool useColumnsForParameterNames) => throw null;
                public System.Data.SqlClient.SqlCommand GetUpdateCommand() => throw null;
                protected override System.Data.Common.DbCommand InitializeCommand(System.Data.Common.DbCommand command) => throw null;
                public override string QuoteIdentifier(string unquotedIdentifier) => throw null;
                public override string QuotePrefix { get => throw null; set => throw null; }
                public override string QuoteSuffix { get => throw null; set => throw null; }
                public override string SchemaSeparator { get => throw null; set => throw null; }
                protected override void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter) => throw null;
                public SqlCommandBuilder(System.Data.SqlClient.SqlDataAdapter adapter) => throw null;
                public SqlCommandBuilder() => throw null;
                public override string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlConnection` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlConnection : System.Data.Common.DbConnection, System.ICloneable
            {
                public string AccessToken { get => throw null; set => throw null; }
                protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public System.Data.SqlClient.SqlTransaction BeginTransaction(string transactionName) => throw null;
                public System.Data.SqlClient.SqlTransaction BeginTransaction(System.Data.IsolationLevel iso, string transactionName) => throw null;
                public System.Data.SqlClient.SqlTransaction BeginTransaction(System.Data.IsolationLevel iso) => throw null;
                public System.Data.SqlClient.SqlTransaction BeginTransaction() => throw null;
                public override void ChangeDatabase(string database) => throw null;
                public static void ChangePassword(string connectionString, string newPassword) => throw null;
                public static void ChangePassword(string connectionString, System.Data.SqlClient.SqlCredential credential, System.Security.SecureString newPassword) => throw null;
                public static void ClearAllPools() => throw null;
                public static void ClearPool(System.Data.SqlClient.SqlConnection connection) => throw null;
                public System.Guid ClientConnectionId { get => throw null; }
                object System.ICloneable.Clone() => throw null;
                public override void Close() => throw null;
                public override string ConnectionString { get => throw null; set => throw null; }
                public override int ConnectionTimeout { get => throw null; }
                public System.Data.SqlClient.SqlCommand CreateCommand() => throw null;
                protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                public System.Data.SqlClient.SqlCredential Credential { get => throw null; set => throw null; }
                public override string DataSource { get => throw null; }
                public override string Database { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public bool FireInfoMessageEventOnUserErrors { get => throw null; set => throw null; }
                public override System.Data.DataTable GetSchema(string collectionName, string[] restrictionValues) => throw null;
                public override System.Data.DataTable GetSchema(string collectionName) => throw null;
                public override System.Data.DataTable GetSchema() => throw null;
                public event System.Data.SqlClient.SqlInfoMessageEventHandler InfoMessage;
                public override void Open() => throw null;
                public override System.Threading.Tasks.Task OpenAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public int PacketSize { get => throw null; }
                public void ResetStatistics() => throw null;
                public System.Collections.IDictionary RetrieveStatistics() => throw null;
                public override string ServerVersion { get => throw null; }
                public SqlConnection(string connectionString, System.Data.SqlClient.SqlCredential credential) => throw null;
                public SqlConnection(string connectionString) => throw null;
                public SqlConnection() => throw null;
                public override System.Data.ConnectionState State { get => throw null; }
                public bool StatisticsEnabled { get => throw null; set => throw null; }
                public string WorkstationId { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlConnectionStringBuilder` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
            {
                public System.Data.SqlClient.ApplicationIntent ApplicationIntent { get => throw null; set => throw null; }
                public string ApplicationName { get => throw null; set => throw null; }
                public string AttachDBFilename { get => throw null; set => throw null; }
                public override void Clear() => throw null;
                public int ConnectRetryCount { get => throw null; set => throw null; }
                public int ConnectRetryInterval { get => throw null; set => throw null; }
                public int ConnectTimeout { get => throw null; set => throw null; }
                public override bool ContainsKey(string keyword) => throw null;
                public string CurrentLanguage { get => throw null; set => throw null; }
                public string DataSource { get => throw null; set => throw null; }
                public bool Encrypt { get => throw null; set => throw null; }
                public bool Enlist { get => throw null; set => throw null; }
                public string FailoverPartner { get => throw null; set => throw null; }
                public string InitialCatalog { get => throw null; set => throw null; }
                public bool IntegratedSecurity { get => throw null; set => throw null; }
                public override object this[string keyword] { get => throw null; set => throw null; }
                public override System.Collections.ICollection Keys { get => throw null; }
                public int LoadBalanceTimeout { get => throw null; set => throw null; }
                public int MaxPoolSize { get => throw null; set => throw null; }
                public int MinPoolSize { get => throw null; set => throw null; }
                public bool MultiSubnetFailover { get => throw null; set => throw null; }
                public bool MultipleActiveResultSets { get => throw null; set => throw null; }
                public int PacketSize { get => throw null; set => throw null; }
                public string Password { get => throw null; set => throw null; }
                public bool PersistSecurityInfo { get => throw null; set => throw null; }
                public System.Data.SqlClient.PoolBlockingPeriod PoolBlockingPeriod { get => throw null; set => throw null; }
                public bool Pooling { get => throw null; set => throw null; }
                public override bool Remove(string keyword) => throw null;
                public bool Replication { get => throw null; set => throw null; }
                public override bool ShouldSerialize(string keyword) => throw null;
                public SqlConnectionStringBuilder(string connectionString) => throw null;
                public SqlConnectionStringBuilder() => throw null;
                public string TransactionBinding { get => throw null; set => throw null; }
                public bool TrustServerCertificate { get => throw null; set => throw null; }
                public override bool TryGetValue(string keyword, out object value) => throw null;
                public string TypeSystemVersion { get => throw null; set => throw null; }
                public string UserID { get => throw null; set => throw null; }
                public bool UserInstance { get => throw null; set => throw null; }
                public override System.Collections.ICollection Values { get => throw null; }
                public string WorkstationID { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlCredential` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlCredential
            {
                public System.Security.SecureString Password { get => throw null; }
                public SqlCredential(string userId, System.Security.SecureString password) => throw null;
                public string UserId { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlDataAdapter` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlDataAdapter : System.Data.Common.DbDataAdapter, System.ICloneable, System.Data.IDbDataAdapter, System.Data.IDataAdapter
            {
                object System.ICloneable.Clone() => throw null;
                public System.Data.SqlClient.SqlCommand DeleteCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.DeleteCommand { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlCommand InsertCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.InsertCommand { get => throw null; set => throw null; }
                protected override void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected override void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public event System.Data.SqlClient.SqlRowUpdatedEventHandler RowUpdated;
                public event System.Data.SqlClient.SqlRowUpdatingEventHandler RowUpdating;
                public System.Data.SqlClient.SqlCommand SelectCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.SelectCommand { get => throw null; set => throw null; }
                public SqlDataAdapter(string selectCommandText, string selectConnectionString) => throw null;
                public SqlDataAdapter(string selectCommandText, System.Data.SqlClient.SqlConnection selectConnection) => throw null;
                public SqlDataAdapter(System.Data.SqlClient.SqlCommand selectCommand) => throw null;
                public SqlDataAdapter() => throw null;
                public override int UpdateBatchSize { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlCommand UpdateCommand { get => throw null; set => throw null; }
                System.Data.IDbCommand System.Data.IDbDataAdapter.UpdateCommand { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlDataReader` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlDataReader : System.Data.Common.DbDataReader, System.IDisposable, System.Data.Common.IDbColumnSchemaGenerator
            {
                protected System.Data.SqlClient.SqlConnection Connection { get => throw null; }
                public override int Depth { get => throw null; }
                public override int FieldCount { get => throw null; }
                public override bool GetBoolean(int i) => throw null;
                public override System.Byte GetByte(int i) => throw null;
                public override System.Int64 GetBytes(int i, System.Int64 dataIndex, System.Byte[] buffer, int bufferIndex, int length) => throw null;
                public override System.Char GetChar(int i) => throw null;
                public override System.Int64 GetChars(int i, System.Int64 dataIndex, System.Char[] buffer, int bufferIndex, int length) => throw null;
                public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema() => throw null;
                public override string GetDataTypeName(int i) => throw null;
                public override System.DateTime GetDateTime(int i) => throw null;
                public virtual System.DateTimeOffset GetDateTimeOffset(int i) => throw null;
                public override System.Decimal GetDecimal(int i) => throw null;
                public override double GetDouble(int i) => throw null;
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                public override System.Type GetFieldType(int i) => throw null;
                public override T GetFieldValue<T>(int i) => throw null;
                public override System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int i, System.Threading.CancellationToken cancellationToken) => throw null;
                public override float GetFloat(int i) => throw null;
                public override System.Guid GetGuid(int i) => throw null;
                public override System.Int16 GetInt16(int i) => throw null;
                public override int GetInt32(int i) => throw null;
                public override System.Int64 GetInt64(int i) => throw null;
                public override string GetName(int i) => throw null;
                public override int GetOrdinal(string name) => throw null;
                public override System.Type GetProviderSpecificFieldType(int i) => throw null;
                public override object GetProviderSpecificValue(int i) => throw null;
                public override int GetProviderSpecificValues(object[] values) => throw null;
                public override System.Data.DataTable GetSchemaTable() => throw null;
                public virtual System.Data.SqlTypes.SqlBinary GetSqlBinary(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlBoolean GetSqlBoolean(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlByte GetSqlByte(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlBytes GetSqlBytes(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlChars GetSqlChars(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlDateTime GetSqlDateTime(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlDecimal GetSqlDecimal(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlDouble GetSqlDouble(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlGuid GetSqlGuid(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlInt16 GetSqlInt16(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlInt32 GetSqlInt32(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlInt64 GetSqlInt64(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlMoney GetSqlMoney(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlSingle GetSqlSingle(int i) => throw null;
                public virtual System.Data.SqlTypes.SqlString GetSqlString(int i) => throw null;
                public virtual object GetSqlValue(int i) => throw null;
                public virtual int GetSqlValues(object[] values) => throw null;
                public virtual System.Data.SqlTypes.SqlXml GetSqlXml(int i) => throw null;
                public override System.IO.Stream GetStream(int i) => throw null;
                public override string GetString(int i) => throw null;
                public override System.IO.TextReader GetTextReader(int i) => throw null;
                public virtual System.TimeSpan GetTimeSpan(int i) => throw null;
                public override object GetValue(int i) => throw null;
                public override int GetValues(object[] values) => throw null;
                public virtual System.Xml.XmlReader GetXmlReader(int i) => throw null;
                public override bool HasRows { get => throw null; }
                public override bool IsClosed { get => throw null; }
                protected internal bool IsCommandBehavior(System.Data.CommandBehavior condition) => throw null;
                public override bool IsDBNull(int i) => throw null;
                public override System.Threading.Tasks.Task<bool> IsDBNullAsync(int i, System.Threading.CancellationToken cancellationToken) => throw null;
                public override object this[string name] { get => throw null; }
                public override object this[int i] { get => throw null; }
                public override bool NextResult() => throw null;
                public override System.Threading.Tasks.Task<bool> NextResultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override bool Read() => throw null;
                public override System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override int RecordsAffected { get => throw null; }
                public override int VisibleFieldCount { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlDependency` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlDependency
            {
                public void AddCommandDependency(System.Data.SqlClient.SqlCommand command) => throw null;
                public bool HasChanges { get => throw null; }
                public string Id { get => throw null; }
                public event System.Data.SqlClient.OnChangeEventHandler OnChange;
                public SqlDependency(System.Data.SqlClient.SqlCommand command, string options, int timeout) => throw null;
                public SqlDependency(System.Data.SqlClient.SqlCommand command) => throw null;
                public SqlDependency() => throw null;
                public static bool Start(string connectionString, string queue) => throw null;
                public static bool Start(string connectionString) => throw null;
                public static bool Stop(string connectionString, string queue) => throw null;
                public static bool Stop(string connectionString) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlError` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlError
            {
                public System.Byte Class { get => throw null; }
                public int LineNumber { get => throw null; }
                public string Message { get => throw null; }
                public int Number { get => throw null; }
                public string Procedure { get => throw null; }
                public string Server { get => throw null; }
                public string Source { get => throw null; }
                public System.Byte State { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlErrorCollection` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlErrorCollection : System.Collections.IEnumerable, System.Collections.ICollection
            {
                public void CopyTo(System.Data.SqlClient.SqlError[] array, int index) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public System.Data.SqlClient.SqlError this[int index] { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlException` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlException : System.Data.Common.DbException
            {
                public System.Byte Class { get => throw null; }
                public System.Guid ClientConnectionId { get => throw null; }
                public System.Data.SqlClient.SqlErrorCollection Errors { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
                public int LineNumber { get => throw null; }
                public int Number { get => throw null; }
                public string Procedure { get => throw null; }
                public string Server { get => throw null; }
                public override string Source { get => throw null; }
                public System.Byte State { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlInfoMessageEventArgs` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlInfoMessageEventArgs : System.EventArgs
            {
                public System.Data.SqlClient.SqlErrorCollection Errors { get => throw null; }
                public string Message { get => throw null; }
                public string Source { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlInfoMessageEventHandler` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void SqlInfoMessageEventHandler(object sender, System.Data.SqlClient.SqlInfoMessageEventArgs e);

            // Generated from `System.Data.SqlClient.SqlNotificationEventArgs` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlNotificationEventArgs : System.EventArgs
            {
                public System.Data.SqlClient.SqlNotificationInfo Info { get => throw null; }
                public System.Data.SqlClient.SqlNotificationSource Source { get => throw null; }
                public SqlNotificationEventArgs(System.Data.SqlClient.SqlNotificationType type, System.Data.SqlClient.SqlNotificationInfo info, System.Data.SqlClient.SqlNotificationSource source) => throw null;
                public System.Data.SqlClient.SqlNotificationType Type { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlNotificationInfo` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SqlNotificationInfo
            {
                AlreadyChanged,
                Alter,
                Delete,
                Drop,
                Error,
                Expired,
                Insert,
                Invalid,
                Isolation,
                Merge,
                Options,
                PreviousFire,
                Query,
                Resource,
                Restart,
                TemplateLimit,
                Truncate,
                Unknown,
                Update,
            }

            // Generated from `System.Data.SqlClient.SqlNotificationSource` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SqlNotificationSource
            {
                Client,
                Data,
                Database,
                Environment,
                Execution,
                Object,
                Owner,
                Statement,
                System,
                Timeout,
                Unknown,
            }

            // Generated from `System.Data.SqlClient.SqlNotificationType` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SqlNotificationType
            {
                Change,
                Subscribe,
                Unknown,
            }

            // Generated from `System.Data.SqlClient.SqlParameter` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlParameter : System.Data.Common.DbParameter, System.ICloneable
            {
                object System.ICloneable.Clone() => throw null;
                public System.Data.SqlTypes.SqlCompareOptions CompareInfo { get => throw null; set => throw null; }
                public override System.Data.DbType DbType { get => throw null; set => throw null; }
                public override System.Data.ParameterDirection Direction { get => throw null; set => throw null; }
                public override bool IsNullable { get => throw null; set => throw null; }
                public int LocaleId { get => throw null; set => throw null; }
                public int Offset { get => throw null; set => throw null; }
                public override string ParameterName { get => throw null; set => throw null; }
                public System.Byte Precision { get => throw null; set => throw null; }
                public override void ResetDbType() => throw null;
                public void ResetSqlDbType() => throw null;
                public System.Byte Scale { get => throw null; set => throw null; }
                public override int Size { get => throw null; set => throw null; }
                public override string SourceColumn { get => throw null; set => throw null; }
                public override bool SourceColumnNullMapping { get => throw null; set => throw null; }
                public override System.Data.DataRowVersion SourceVersion { get => throw null; set => throw null; }
                public System.Data.SqlDbType SqlDbType { get => throw null; set => throw null; }
                public SqlParameter(string parameterName, object value) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, string sourceColumn) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, System.Data.ParameterDirection direction, bool isNullable, System.Byte precision, System.Byte scale, string sourceColumn, System.Data.DataRowVersion sourceVersion, object value) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, System.Data.ParameterDirection direction, System.Byte precision, System.Byte scale, string sourceColumn, System.Data.DataRowVersion sourceVersion, bool sourceColumnNullMapping, object value, string xmlSchemaCollectionDatabase, string xmlSchemaCollectionOwningSchema, string xmlSchemaCollectionName) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType) => throw null;
                public SqlParameter() => throw null;
                public object SqlValue { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public string TypeName { get => throw null; set => throw null; }
                public string UdtTypeName { get => throw null; set => throw null; }
                public override object Value { get => throw null; set => throw null; }
                public string XmlSchemaCollectionDatabase { get => throw null; set => throw null; }
                public string XmlSchemaCollectionName { get => throw null; set => throw null; }
                public string XmlSchemaCollectionOwningSchema { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlParameterCollection` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlParameterCollection : System.Data.Common.DbParameterCollection
            {
                public override int Add(object value) => throw null;
                public System.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType, int size, string sourceColumn) => throw null;
                public System.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType, int size) => throw null;
                public System.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType) => throw null;
                public System.Data.SqlClient.SqlParameter Add(System.Data.SqlClient.SqlParameter value) => throw null;
                public void AddRange(System.Data.SqlClient.SqlParameter[] values) => throw null;
                public override void AddRange(System.Array values) => throw null;
                public System.Data.SqlClient.SqlParameter AddWithValue(string parameterName, object value) => throw null;
                public override void Clear() => throw null;
                public override bool Contains(string value) => throw null;
                public override bool Contains(object value) => throw null;
                public bool Contains(System.Data.SqlClient.SqlParameter value) => throw null;
                public void CopyTo(System.Data.SqlClient.SqlParameter[] array, int index) => throw null;
                public override void CopyTo(System.Array array, int index) => throw null;
                public override int Count { get => throw null; }
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                protected override System.Data.Common.DbParameter GetParameter(string parameterName) => throw null;
                protected override System.Data.Common.DbParameter GetParameter(int index) => throw null;
                public override int IndexOf(string parameterName) => throw null;
                public override int IndexOf(object value) => throw null;
                public int IndexOf(System.Data.SqlClient.SqlParameter value) => throw null;
                public void Insert(int index, System.Data.SqlClient.SqlParameter value) => throw null;
                public override void Insert(int index, object value) => throw null;
                public override bool IsFixedSize { get => throw null; }
                public override bool IsReadOnly { get => throw null; }
                public System.Data.SqlClient.SqlParameter this[string parameterName] { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlParameter this[int index] { get => throw null; set => throw null; }
                public void Remove(System.Data.SqlClient.SqlParameter value) => throw null;
                public override void Remove(object value) => throw null;
                public override void RemoveAt(string parameterName) => throw null;
                public override void RemoveAt(int index) => throw null;
                protected override void SetParameter(string parameterName, System.Data.Common.DbParameter value) => throw null;
                protected override void SetParameter(int index, System.Data.Common.DbParameter value) => throw null;
                public override object SyncRoot { get => throw null; }
            }

            // Generated from `System.Data.SqlClient.SqlRowUpdatedEventArgs` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlRowUpdatedEventArgs : System.Data.Common.RowUpdatedEventArgs
            {
                public System.Data.SqlClient.SqlCommand Command { get => throw null; }
                public SqlRowUpdatedEventArgs(System.Data.DataRow row, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) : base(default(System.Data.DataRow), default(System.Data.IDbCommand), default(System.Data.StatementType), default(System.Data.Common.DataTableMapping)) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlRowUpdatedEventHandler` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void SqlRowUpdatedEventHandler(object sender, System.Data.SqlClient.SqlRowUpdatedEventArgs e);

            // Generated from `System.Data.SqlClient.SqlRowUpdatingEventArgs` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlRowUpdatingEventArgs : System.Data.Common.RowUpdatingEventArgs
            {
                protected override System.Data.IDbCommand BaseCommand { get => throw null; set => throw null; }
                public System.Data.SqlClient.SqlCommand Command { get => throw null; set => throw null; }
                public SqlRowUpdatingEventArgs(System.Data.DataRow row, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) : base(default(System.Data.DataRow), default(System.Data.IDbCommand), default(System.Data.StatementType), default(System.Data.Common.DataTableMapping)) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlRowUpdatingEventHandler` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void SqlRowUpdatingEventHandler(object sender, System.Data.SqlClient.SqlRowUpdatingEventArgs e);

            // Generated from `System.Data.SqlClient.SqlRowsCopiedEventArgs` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlRowsCopiedEventArgs : System.EventArgs
            {
                public bool Abort { get => throw null; set => throw null; }
                public System.Int64 RowsCopied { get => throw null; }
                public SqlRowsCopiedEventArgs(System.Int64 rowsCopied) => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlRowsCopiedEventHandler` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void SqlRowsCopiedEventHandler(object sender, System.Data.SqlClient.SqlRowsCopiedEventArgs e);

            // Generated from `System.Data.SqlClient.SqlTransaction` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlTransaction : System.Data.Common.DbTransaction
            {
                public override void Commit() => throw null;
                public System.Data.SqlClient.SqlConnection Connection { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                public void Rollback(string transactionName) => throw null;
                public override void Rollback() => throw null;
                public void Save(string savePointName) => throw null;
            }

        }
        namespace SqlTypes
        {
            // Generated from `System.Data.SqlTypes.SqlFileStream` in `System.Data.SqlClient, Version=4.6.1.2, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SqlFileStream : System.IO.Stream
            {
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public override void Flush() => throw null;
                public override System.Int64 Length { get => throw null; }
                public string Name { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public SqlFileStream(string path, System.Byte[] transactionContext, System.IO.FileAccess access, System.IO.FileOptions options, System.Int64 allocationSize) => throw null;
                public SqlFileStream(string path, System.Byte[] transactionContext, System.IO.FileAccess access) => throw null;
                public System.Byte[] TransactionContext { get => throw null; }
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
            }

        }
    }
}
