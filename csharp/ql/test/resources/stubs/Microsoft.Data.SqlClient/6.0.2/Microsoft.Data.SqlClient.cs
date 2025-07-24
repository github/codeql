// This file contains auto-generated code.
// Generated from `Microsoft.Data.SqlClient, Version=6.0.0.0, Culture=neutral, PublicKeyToken=23ec7fc2d6eaa4a5`.
namespace Microsoft
{
    namespace Data
    {
        public sealed class OperationAbortedException : System.SystemException
        {
        }
        namespace Sql
        {
            public sealed class SqlDataSourceEnumerator : System.Data.Common.DbDataSourceEnumerator
            {
                public SqlDataSourceEnumerator() => throw null;
                public override System.Data.DataTable GetDataSources() => throw null;
                public static Microsoft.Data.Sql.SqlDataSourceEnumerator Instance { get => throw null; }
            }
            public sealed class SqlNotificationRequest
            {
                public SqlNotificationRequest() => throw null;
                public SqlNotificationRequest(string userData, string options, int timeout) => throw null;
                public string Options { get => throw null; set { } }
                public int Timeout { get => throw null; set { } }
                public string UserData { get => throw null; set { } }
            }
        }
        namespace SqlClient
        {
            public sealed class ActiveDirectoryAuthenticationProvider : Microsoft.Data.SqlClient.SqlAuthenticationProvider
            {
                public override System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlAuthenticationToken> AcquireTokenAsync(Microsoft.Data.SqlClient.SqlAuthenticationParameters parameters) => throw null;
                public override void BeforeLoad(Microsoft.Data.SqlClient.SqlAuthenticationMethod authentication) => throw null;
                public override void BeforeUnload(Microsoft.Data.SqlClient.SqlAuthenticationMethod authentication) => throw null;
                public static void ClearUserTokenCache() => throw null;
                public ActiveDirectoryAuthenticationProvider() => throw null;
                public ActiveDirectoryAuthenticationProvider(string applicationClientId) => throw null;
                public ActiveDirectoryAuthenticationProvider(System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeFlowCallbackMethod, string applicationClientId = default(string)) => throw null;
                public override bool IsSupported(Microsoft.Data.SqlClient.SqlAuthenticationMethod authentication) => throw null;
                public void SetAcquireAuthorizationCodeAsyncCallback(System.Func<System.Uri, System.Uri, System.Threading.CancellationToken, System.Threading.Tasks.Task<System.Uri>> acquireAuthorizationCodeAsyncCallback) => throw null;
                public void SetDeviceCodeFlowCallback(System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeFlowCallbackMethod) => throw null;
            }
            public enum ApplicationIntent
            {
                ReadOnly = 1,
                ReadWrite = 0,
            }
            namespace DataClassification
            {
                public class ColumnSensitivity
                {
                    public ColumnSensitivity(System.Collections.Generic.IList<Microsoft.Data.SqlClient.DataClassification.SensitivityProperty> sensitivityProperties) => throw null;
                    public System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.Data.SqlClient.DataClassification.SensitivityProperty> SensitivityProperties { get => throw null; }
                }
                public class InformationType
                {
                    public InformationType(string name, string id) => throw null;
                    public string Id { get => throw null; }
                    public string Name { get => throw null; }
                }
                public class Label
                {
                    public Label(string name, string id) => throw null;
                    public string Id { get => throw null; }
                    public string Name { get => throw null; }
                }
                public class SensitivityClassification
                {
                    public System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.Data.SqlClient.DataClassification.ColumnSensitivity> ColumnSensitivities { get => throw null; }
                    public SensitivityClassification(System.Collections.Generic.IList<Microsoft.Data.SqlClient.DataClassification.Label> labels, System.Collections.Generic.IList<Microsoft.Data.SqlClient.DataClassification.InformationType> informationTypes, System.Collections.Generic.IList<Microsoft.Data.SqlClient.DataClassification.ColumnSensitivity> columnSensitivity, Microsoft.Data.SqlClient.DataClassification.SensitivityRank sensitivityRank) => throw null;
                    public System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.Data.SqlClient.DataClassification.InformationType> InformationTypes { get => throw null; }
                    public System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.Data.SqlClient.DataClassification.Label> Labels { get => throw null; }
                    public Microsoft.Data.SqlClient.DataClassification.SensitivityRank SensitivityRank { get => throw null; }
                }
                public class SensitivityProperty
                {
                    public SensitivityProperty(Microsoft.Data.SqlClient.DataClassification.Label label, Microsoft.Data.SqlClient.DataClassification.InformationType informationType, Microsoft.Data.SqlClient.DataClassification.SensitivityRank sensitivityRank) => throw null;
                    public Microsoft.Data.SqlClient.DataClassification.InformationType InformationType { get => throw null; }
                    public Microsoft.Data.SqlClient.DataClassification.Label Label { get => throw null; }
                    public Microsoft.Data.SqlClient.DataClassification.SensitivityRank SensitivityRank { get => throw null; }
                }
                public enum SensitivityRank
                {
                    NOT_DEFINED = -1,
                    NONE = 0,
                    LOW = 10,
                    MEDIUM = 20,
                    HIGH = 30,
                    CRITICAL = 40,
                }
            }
            namespace Diagnostics
            {
                public sealed class SqlClientCommandAfter : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlCommand Command { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientCommandAfter() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.IDictionary Statistics { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientCommandBefore : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlCommand Command { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientCommandBefore() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientCommandError : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlCommand Command { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientCommandError() => throw null;
                    public System.Exception Exception { get => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientConnectionCloseAfter : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionCloseAfter() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.IDictionary Statistics { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientConnectionCloseBefore : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionCloseBefore() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.IDictionary Statistics { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientConnectionCloseError : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public System.Guid? ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionCloseError() => throw null;
                    public System.Exception Exception { get => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.IDictionary Statistics { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientConnectionOpenAfter : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public string ClientVersion { get => throw null; }
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public System.Guid ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionOpenAfter() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.IDictionary Statistics { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientConnectionOpenBefore : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public string ClientVersion { get => throw null; }
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionOpenBefore() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientConnectionOpenError : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public string ClientVersion { get => throw null; }
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public System.Guid ConnectionId { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientConnectionOpenError() => throw null;
                    public System.Exception Exception { get => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                }
                public sealed class SqlClientTransactionCommitAfter : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionCommitAfter() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientTransactionCommitBefore : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionCommitBefore() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientTransactionCommitError : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionCommitError() => throw null;
                    public System.Exception Exception { get => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                }
                public sealed class SqlClientTransactionRollbackAfter : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionRollbackAfter() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                    public string TransactionName { get => throw null; }
                }
                public sealed class SqlClientTransactionRollbackBefore : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionRollbackBefore() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                    public string TransactionName { get => throw null; }
                }
                public sealed class SqlClientTransactionRollbackError : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                    public int Count { get => throw null; }
                    public SqlClientTransactionRollbackError() => throw null;
                    public System.Exception Exception { get => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                    public const string Name = default;
                    public string Operation { get => throw null; }
                    public System.Guid OperationId { get => throw null; }
                    public System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public long Timestamp { get => throw null; }
                    public long? TransactionId { get => throw null; }
                    public string TransactionName { get => throw null; }
                }
            }
            public delegate void OnChangeEventHandler(object sender, Microsoft.Data.SqlClient.SqlNotificationEventArgs e);
            public enum PoolBlockingPeriod
            {
                Auto = 0,
                AlwaysBlock = 1,
                NeverBlock = 2,
            }
            namespace Server
            {
                public class SqlDataRecord : System.Data.IDataRecord
                {
                    public SqlDataRecord(params Microsoft.Data.SqlClient.Server.SqlMetaData[] metaData) => throw null;
                    public virtual int FieldCount { get => throw null; }
                    public virtual bool GetBoolean(int ordinal) => throw null;
                    public virtual byte GetByte(int ordinal) => throw null;
                    public virtual long GetBytes(int ordinal, long fieldOffset, byte[] buffer, int bufferOffset, int length) => throw null;
                    public virtual char GetChar(int ordinal) => throw null;
                    public virtual long GetChars(int ordinal, long fieldOffset, char[] buffer, int bufferOffset, int length) => throw null;
                    System.Data.IDataReader System.Data.IDataRecord.GetData(int ordinal) => throw null;
                    public virtual string GetDataTypeName(int ordinal) => throw null;
                    public virtual System.DateTime GetDateTime(int ordinal) => throw null;
                    public virtual System.DateTimeOffset GetDateTimeOffset(int ordinal) => throw null;
                    public virtual decimal GetDecimal(int ordinal) => throw null;
                    public virtual double GetDouble(int ordinal) => throw null;
                    public virtual System.Type GetFieldType(int ordinal) => throw null;
                    public virtual float GetFloat(int ordinal) => throw null;
                    public virtual System.Guid GetGuid(int ordinal) => throw null;
                    public virtual short GetInt16(int ordinal) => throw null;
                    public virtual int GetInt32(int ordinal) => throw null;
                    public virtual long GetInt64(int ordinal) => throw null;
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
                    public virtual Microsoft.Data.SqlClient.Server.SqlMetaData GetSqlMetaData(int ordinal) => throw null;
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
                    public virtual void SetBoolean(int ordinal, bool value) => throw null;
                    public virtual void SetByte(int ordinal, byte value) => throw null;
                    public virtual void SetBytes(int ordinal, long fieldOffset, byte[] buffer, int bufferOffset, int length) => throw null;
                    public virtual void SetChar(int ordinal, char value) => throw null;
                    public virtual void SetChars(int ordinal, long fieldOffset, char[] buffer, int bufferOffset, int length) => throw null;
                    public virtual void SetDateTime(int ordinal, System.DateTime value) => throw null;
                    public virtual void SetDateTimeOffset(int ordinal, System.DateTimeOffset value) => throw null;
                    public virtual void SetDBNull(int ordinal) => throw null;
                    public virtual void SetDecimal(int ordinal, decimal value) => throw null;
                    public virtual void SetDouble(int ordinal, double value) => throw null;
                    public virtual void SetFloat(int ordinal, float value) => throw null;
                    public virtual void SetGuid(int ordinal, System.Guid value) => throw null;
                    public virtual void SetInt16(int ordinal, short value) => throw null;
                    public virtual void SetInt32(int ordinal, int value) => throw null;
                    public virtual void SetInt64(int ordinal, long value) => throw null;
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
                    public virtual object this[int ordinal] { get => throw null; }
                    public virtual object this[string name] { get => throw null; }
                }
                public sealed class SqlMetaData
                {
                    public bool Adjust(bool value) => throw null;
                    public byte Adjust(byte value) => throw null;
                    public byte[] Adjust(byte[] value) => throw null;
                    public char Adjust(char value) => throw null;
                    public char[] Adjust(char[] value) => throw null;
                    public System.Data.SqlTypes.SqlBinary Adjust(System.Data.SqlTypes.SqlBinary value) => throw null;
                    public System.Data.SqlTypes.SqlBoolean Adjust(System.Data.SqlTypes.SqlBoolean value) => throw null;
                    public System.Data.SqlTypes.SqlByte Adjust(System.Data.SqlTypes.SqlByte value) => throw null;
                    public System.Data.SqlTypes.SqlBytes Adjust(System.Data.SqlTypes.SqlBytes value) => throw null;
                    public System.Data.SqlTypes.SqlChars Adjust(System.Data.SqlTypes.SqlChars value) => throw null;
                    public System.Data.SqlTypes.SqlDateTime Adjust(System.Data.SqlTypes.SqlDateTime value) => throw null;
                    public System.Data.SqlTypes.SqlDecimal Adjust(System.Data.SqlTypes.SqlDecimal value) => throw null;
                    public System.Data.SqlTypes.SqlDouble Adjust(System.Data.SqlTypes.SqlDouble value) => throw null;
                    public System.Data.SqlTypes.SqlGuid Adjust(System.Data.SqlTypes.SqlGuid value) => throw null;
                    public System.Data.SqlTypes.SqlInt16 Adjust(System.Data.SqlTypes.SqlInt16 value) => throw null;
                    public System.Data.SqlTypes.SqlInt32 Adjust(System.Data.SqlTypes.SqlInt32 value) => throw null;
                    public System.Data.SqlTypes.SqlInt64 Adjust(System.Data.SqlTypes.SqlInt64 value) => throw null;
                    public System.Data.SqlTypes.SqlMoney Adjust(System.Data.SqlTypes.SqlMoney value) => throw null;
                    public System.Data.SqlTypes.SqlSingle Adjust(System.Data.SqlTypes.SqlSingle value) => throw null;
                    public System.Data.SqlTypes.SqlString Adjust(System.Data.SqlTypes.SqlString value) => throw null;
                    public System.Data.SqlTypes.SqlXml Adjust(System.Data.SqlTypes.SqlXml value) => throw null;
                    public System.DateTime Adjust(System.DateTime value) => throw null;
                    public System.DateTimeOffset Adjust(System.DateTimeOffset value) => throw null;
                    public decimal Adjust(decimal value) => throw null;
                    public double Adjust(double value) => throw null;
                    public System.Guid Adjust(System.Guid value) => throw null;
                    public short Adjust(short value) => throw null;
                    public int Adjust(int value) => throw null;
                    public long Adjust(long value) => throw null;
                    public object Adjust(object value) => throw null;
                    public float Adjust(float value) => throw null;
                    public string Adjust(string value) => throw null;
                    public System.TimeSpan Adjust(System.TimeSpan value) => throw null;
                    public System.Data.SqlTypes.SqlCompareOptions CompareOptions { get => throw null; }
                    public SqlMetaData(string name, System.Data.SqlDbType dbType) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, byte precision, byte scale) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, byte precision, byte scale, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength, byte precision, byte scale, long locale, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Type userDefinedType) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength, byte precision, byte scale, long localeId, System.Data.SqlTypes.SqlCompareOptions compareOptions, System.Type userDefinedType, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength, long locale, System.Data.SqlTypes.SqlCompareOptions compareOptions) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, long maxLength, long locale, System.Data.SqlTypes.SqlCompareOptions compareOptions, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, string database, string owningSchema, string objectName) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, string database, string owningSchema, string objectName, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType, string serverTypeName) => throw null;
                    public SqlMetaData(string name, System.Data.SqlDbType dbType, System.Type userDefinedType, string serverTypeName, bool useServerDefault, bool isUniqueKey, Microsoft.Data.SqlClient.SortOrder columnSortOrder, int sortOrdinal) => throw null;
                    public System.Data.DbType DbType { get => throw null; }
                    public static Microsoft.Data.SqlClient.Server.SqlMetaData InferFromValue(object value, string name) => throw null;
                    public bool IsUniqueKey { get => throw null; }
                    public long LocaleId { get => throw null; }
                    public static long Max { get => throw null; }
                    public long MaxLength { get => throw null; }
                    public string Name { get => throw null; }
                    public byte Precision { get => throw null; }
                    public byte Scale { get => throw null; }
                    public Microsoft.Data.SqlClient.SortOrder SortOrder { get => throw null; }
                    public int SortOrdinal { get => throw null; }
                    public System.Data.SqlDbType SqlDbType { get => throw null; }
                    public System.Type Type { get => throw null; }
                    public string TypeName { get => throw null; }
                    public bool UseServerDefault { get => throw null; }
                    public string XmlSchemaCollectionDatabase { get => throw null; }
                    public string XmlSchemaCollectionName { get => throw null; }
                    public string XmlSchemaCollectionOwningSchema { get => throw null; }
                }
            }
            public enum SortOrder
            {
                Unspecified = -1,
                Ascending = 0,
                Descending = 1,
            }
            public abstract class SqlAuthenticationInitializer
            {
                protected SqlAuthenticationInitializer() => throw null;
                public abstract void Initialize();
            }
            public enum SqlAuthenticationMethod
            {
                NotSpecified = 0,
                SqlPassword = 1,
                ActiveDirectoryPassword = 2,
                ActiveDirectoryIntegrated = 3,
                ActiveDirectoryInteractive = 4,
                ActiveDirectoryServicePrincipal = 5,
                ActiveDirectoryDeviceCodeFlow = 6,
                ActiveDirectoryManagedIdentity = 7,
                ActiveDirectoryMSI = 8,
                ActiveDirectoryDefault = 9,
                ActiveDirectoryWorkloadIdentity = 10,
            }
            public class SqlAuthenticationParameters
            {
                public Microsoft.Data.SqlClient.SqlAuthenticationMethod AuthenticationMethod { get => throw null; }
                public string Authority { get => throw null; }
                public System.Guid ConnectionId { get => throw null; }
                public int ConnectionTimeout { get => throw null; }
                protected SqlAuthenticationParameters(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod, string serverName, string databaseName, string resource, string authority, string userId, string password, System.Guid connectionId, int connectionTimeout) => throw null;
                public string DatabaseName { get => throw null; }
                public string Password { get => throw null; }
                public string Resource { get => throw null; }
                public string ServerName { get => throw null; }
                public string UserId { get => throw null; }
            }
            public abstract class SqlAuthenticationProvider
            {
                public abstract System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlAuthenticationToken> AcquireTokenAsync(Microsoft.Data.SqlClient.SqlAuthenticationParameters parameters);
                public virtual void BeforeLoad(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod) => throw null;
                public virtual void BeforeUnload(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod) => throw null;
                protected SqlAuthenticationProvider() => throw null;
                public static Microsoft.Data.SqlClient.SqlAuthenticationProvider GetProvider(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod) => throw null;
                public abstract bool IsSupported(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod);
                public static bool SetProvider(Microsoft.Data.SqlClient.SqlAuthenticationMethod authenticationMethod, Microsoft.Data.SqlClient.SqlAuthenticationProvider provider) => throw null;
            }
            public class SqlAuthenticationToken
            {
                public string AccessToken { get => throw null; }
                public SqlAuthenticationToken(string accessToken, System.DateTimeOffset expiresOn) => throw null;
                public System.DateTimeOffset ExpiresOn { get => throw null; }
            }
            public class SqlBatch : System.Data.Common.DbBatch
            {
                public Microsoft.Data.SqlClient.SqlBatchCommandCollection BatchCommands { get => throw null; }
                public override void Cancel() => throw null;
                public System.Collections.Generic.List<Microsoft.Data.SqlClient.SqlBatchCommand> Commands { get => throw null; }
                public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; set { } }
                protected override System.Data.Common.DbBatchCommand CreateDbBatchCommand() => throw null;
                public SqlBatch() => throw null;
                public SqlBatch(Microsoft.Data.SqlClient.SqlConnection connection, Microsoft.Data.SqlClient.SqlTransaction transaction = default(Microsoft.Data.SqlClient.SqlTransaction)) => throw null;
                protected override System.Data.Common.DbBatchCommandCollection DbBatchCommands { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set { } }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set { } }
                public override void Dispose() => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                protected override System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public override System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public Microsoft.Data.SqlClient.SqlDataReader ExecuteReader() => throw null;
                public System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override object ExecuteScalar() => throw null;
                public override System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void Prepare() => throw null;
                public override System.Threading.Tasks.Task PrepareAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int Timeout { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlTransaction Transaction { get => throw null; set { } }
            }
            public class SqlBatchCommand : System.Data.Common.DbBatchCommand
            {
                public Microsoft.Data.SqlClient.SqlCommandColumnEncryptionSetting ColumnEncryptionSetting { get => throw null; set { } }
                public System.Data.CommandBehavior CommandBehavior { get => throw null; set { } }
                public override string CommandText { get => throw null; set { } }
                public override System.Data.CommandType CommandType { get => throw null; set { } }
                public SqlBatchCommand() => throw null;
                public SqlBatchCommand(string commandText, System.Data.CommandType commandType = default(System.Data.CommandType), System.Collections.Generic.IEnumerable<Microsoft.Data.SqlClient.SqlParameter> parameters = default(System.Collections.Generic.IEnumerable<Microsoft.Data.SqlClient.SqlParameter>), Microsoft.Data.SqlClient.SqlCommandColumnEncryptionSetting columnEncryptionSetting = default(Microsoft.Data.SqlClient.SqlCommandColumnEncryptionSetting)) => throw null;
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                public Microsoft.Data.SqlClient.SqlParameterCollection Parameters { get => throw null; }
                public override int RecordsAffected { get => throw null; }
            }
            public class SqlBatchCommandCollection : System.Data.Common.DbBatchCommandCollection, System.Collections.Generic.ICollection<Microsoft.Data.SqlClient.SqlBatchCommand>, System.Collections.Generic.IEnumerable<Microsoft.Data.SqlClient.SqlBatchCommand>, System.Collections.IEnumerable, System.Collections.Generic.IList<Microsoft.Data.SqlClient.SqlBatchCommand>
            {
                public void Add(Microsoft.Data.SqlClient.SqlBatchCommand item) => throw null;
                public override void Add(System.Data.Common.DbBatchCommand item) => throw null;
                public override void Clear() => throw null;
                public bool Contains(Microsoft.Data.SqlClient.SqlBatchCommand item) => throw null;
                public override bool Contains(System.Data.Common.DbBatchCommand item) => throw null;
                public void CopyTo(Microsoft.Data.SqlClient.SqlBatchCommand[] array, int arrayIndex) => throw null;
                public override void CopyTo(System.Data.Common.DbBatchCommand[] array, int arrayIndex) => throw null;
                public override int Count { get => throw null; }
                public SqlBatchCommandCollection() => throw null;
                protected override System.Data.Common.DbBatchCommand GetBatchCommand(int index) => throw null;
                System.Collections.Generic.IEnumerator<Microsoft.Data.SqlClient.SqlBatchCommand> System.Collections.Generic.IEnumerable<Microsoft.Data.SqlClient.SqlBatchCommand>.GetEnumerator() => throw null;
                public override System.Collections.Generic.IEnumerator<System.Data.Common.DbBatchCommand> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(Microsoft.Data.SqlClient.SqlBatchCommand item) => throw null;
                public override int IndexOf(System.Data.Common.DbBatchCommand item) => throw null;
                public void Insert(int index, Microsoft.Data.SqlClient.SqlBatchCommand item) => throw null;
                public override void Insert(int index, System.Data.Common.DbBatchCommand item) => throw null;
                public override bool IsReadOnly { get => throw null; }
                Microsoft.Data.SqlClient.SqlBatchCommand System.Collections.Generic.IList<Microsoft.Data.SqlClient.SqlBatchCommand>.this[int index] { get => throw null; set { } }
                public bool Remove(Microsoft.Data.SqlClient.SqlBatchCommand item) => throw null;
                public override bool Remove(System.Data.Common.DbBatchCommand item) => throw null;
                public override void RemoveAt(int index) => throw null;
                protected override void SetBatchCommand(int index, System.Data.Common.DbBatchCommand batchCommand) => throw null;
                public Microsoft.Data.SqlClient.SqlBatchCommand this[int index] { get => throw null; set { } }
            }
            public sealed class SqlBulkCopy : System.IDisposable
            {
                public int BatchSize { get => throw null; set { } }
                public int BulkCopyTimeout { get => throw null; set { } }
                public void Close() => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMappingCollection ColumnMappings { get => throw null; }
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHintCollection ColumnOrderHints { get => throw null; }
                public SqlBulkCopy(Microsoft.Data.SqlClient.SqlConnection connection) => throw null;
                public SqlBulkCopy(Microsoft.Data.SqlClient.SqlConnection connection, Microsoft.Data.SqlClient.SqlBulkCopyOptions copyOptions, Microsoft.Data.SqlClient.SqlTransaction externalTransaction) => throw null;
                public SqlBulkCopy(string connectionString) => throw null;
                public SqlBulkCopy(string connectionString, Microsoft.Data.SqlClient.SqlBulkCopyOptions copyOptions) => throw null;
                public string DestinationTableName { get => throw null; set { } }
                void System.IDisposable.Dispose() => throw null;
                public bool EnableStreaming { get => throw null; set { } }
                public int NotifyAfter { get => throw null; set { } }
                public int RowsCopied { get => throw null; }
                public long RowsCopied64 { get => throw null; }
                public event Microsoft.Data.SqlClient.SqlRowsCopiedEventHandler SqlRowsCopied;
                public void WriteToServer(System.Data.Common.DbDataReader reader) => throw null;
                public void WriteToServer(System.Data.DataTable table) => throw null;
                public void WriteToServer(System.Data.DataTable table, System.Data.DataRowState rowState) => throw null;
                public void WriteToServer(System.Data.DataRow[] rows) => throw null;
                public void WriteToServer(System.Data.IDataReader reader) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.Common.DbDataReader reader) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.Common.DbDataReader reader, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataRow[] rows) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataRow[] rows, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Data.DataRowState rowState) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Data.DataRowState rowState, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.DataTable table, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.IDataReader reader) => throw null;
                public System.Threading.Tasks.Task WriteToServerAsync(System.Data.IDataReader reader, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public sealed class SqlBulkCopyColumnMapping
            {
                public SqlBulkCopyColumnMapping() => throw null;
                public SqlBulkCopyColumnMapping(int sourceColumnOrdinal, int destinationOrdinal) => throw null;
                public SqlBulkCopyColumnMapping(int sourceColumnOrdinal, string destinationColumn) => throw null;
                public SqlBulkCopyColumnMapping(string sourceColumn, int destinationOrdinal) => throw null;
                public SqlBulkCopyColumnMapping(string sourceColumn, string destinationColumn) => throw null;
                public string DestinationColumn { get => throw null; set { } }
                public int DestinationOrdinal { get => throw null; set { } }
                public string SourceColumn { get => throw null; set { } }
                public int SourceOrdinal { get => throw null; set { } }
            }
            public sealed class SqlBulkCopyColumnMappingCollection : System.Collections.CollectionBase
            {
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping Add(Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping bulkCopyColumnMapping) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping Add(int sourceColumnIndex, int destinationColumnIndex) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping Add(int sourceColumnIndex, string destinationColumn) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping Add(string sourceColumn, int destinationColumnIndex) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping Add(string sourceColumn, string destinationColumn) => throw null;
                public void Clear() => throw null;
                public bool Contains(Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void CopyTo(Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping[] array, int index) => throw null;
                public int IndexOf(Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void Insert(int index, Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void Remove(Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping value) => throw null;
                public void RemoveAt(int index) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping this[int index] { get => throw null; }
            }
            public sealed class SqlBulkCopyColumnOrderHint
            {
                public string Column { get => throw null; set { } }
                public SqlBulkCopyColumnOrderHint(string column, Microsoft.Data.SqlClient.SortOrder sortOrder) => throw null;
                public Microsoft.Data.SqlClient.SortOrder SortOrder { get => throw null; set { } }
            }
            public sealed class SqlBulkCopyColumnOrderHintCollection : System.Collections.CollectionBase
            {
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint Add(Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint columnOrderHint) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint Add(string column, Microsoft.Data.SqlClient.SortOrder sortOrder) => throw null;
                public void Clear() => throw null;
                public bool Contains(Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint value) => throw null;
                public void CopyTo(Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint[] array, int index) => throw null;
                public SqlBulkCopyColumnOrderHintCollection() => throw null;
                public int IndexOf(Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint value) => throw null;
                public void Insert(int index, Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint columnOrderHint) => throw null;
                public void Remove(Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint columnOrderHint) => throw null;
                public void RemoveAt(int index) => throw null;
                public Microsoft.Data.SqlClient.SqlBulkCopyColumnOrderHint this[int index] { get => throw null; }
            }
            [System.Flags]
            public enum SqlBulkCopyOptions
            {
                AllowEncryptedValueModifications = 64,
                CheckConstraints = 2,
                Default = 0,
                FireTriggers = 16,
                KeepIdentity = 1,
                KeepNulls = 8,
                TableLock = 4,
                UseInternalTransaction = 32,
            }
            public sealed class SqlClientFactory : System.Data.Common.DbProviderFactory
            {
                public override bool CanCreateBatch { get => throw null; }
                public override System.Data.Common.DbBatch CreateBatch() => throw null;
                public override System.Data.Common.DbBatchCommand CreateBatchCommand() => throw null;
                public override System.Data.Common.DbCommand CreateCommand() => throw null;
                public override System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                public override System.Data.Common.DbConnection CreateConnection() => throw null;
                public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                public override System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                public override System.Data.Common.DbDataSourceEnumerator CreateDataSourceEnumerator() => throw null;
                public override System.Data.Common.DbParameter CreateParameter() => throw null;
                public static readonly Microsoft.Data.SqlClient.SqlClientFactory Instance;
            }
            public class SqlClientLogger
            {
                public SqlClientLogger() => throw null;
                public bool IsLoggingEnabled { get => throw null; }
                public bool LogAssert(bool value, string type, string method, string message) => throw null;
                public void LogError(string type, string method, string message) => throw null;
                public void LogInfo(string type, string method, string message) => throw null;
                public void LogWarning(string type, string method, string message) => throw null;
            }
            public static class SqlClientMetaDataCollectionNames
            {
                public static readonly string AllColumns;
                public static readonly string Columns;
                public static readonly string ColumnSetColumns;
                public static readonly string Databases;
                public static readonly string ForeignKeys;
                public static readonly string IndexColumns;
                public static readonly string Indexes;
                public static readonly string ProcedureParameters;
                public static readonly string Procedures;
                public static readonly string StructuredTypeMembers;
                public static readonly string Tables;
                public static readonly string UserDefinedTypes;
                public static readonly string Users;
                public static readonly string ViewColumns;
                public static readonly string Views;
            }
            public class SqlColumnEncryptionCertificateStoreProvider : Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider
            {
                public SqlColumnEncryptionCertificateStoreProvider() => throw null;
                public override byte[] DecryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] encryptedColumnEncryptionKey) => throw null;
                public override byte[] EncryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] columnEncryptionKey) => throw null;
                public const string ProviderName = default;
                public override byte[] SignColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations) => throw null;
                public override bool VerifyColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations, byte[] signature) => throw null;
            }
            public class SqlColumnEncryptionCngProvider : Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider
            {
                public SqlColumnEncryptionCngProvider() => throw null;
                public override byte[] DecryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] encryptedColumnEncryptionKey) => throw null;
                public override byte[] EncryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] columnEncryptionKey) => throw null;
                public const string ProviderName = default;
                public override byte[] SignColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations) => throw null;
                public override bool VerifyColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations, byte[] signature) => throw null;
            }
            public class SqlColumnEncryptionCspProvider : Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider
            {
                public SqlColumnEncryptionCspProvider() => throw null;
                public override byte[] DecryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] encryptedColumnEncryptionKey) => throw null;
                public override byte[] EncryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] columnEncryptionKey) => throw null;
                public const string ProviderName = default;
                public override byte[] SignColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations) => throw null;
                public override bool VerifyColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations, byte[] signature) => throw null;
            }
            public abstract class SqlColumnEncryptionKeyStoreProvider
            {
                public virtual System.TimeSpan? ColumnEncryptionKeyCacheTtl { get => throw null; set { } }
                protected SqlColumnEncryptionKeyStoreProvider() => throw null;
                public abstract byte[] DecryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] encryptedColumnEncryptionKey);
                public abstract byte[] EncryptColumnEncryptionKey(string masterKeyPath, string encryptionAlgorithm, byte[] columnEncryptionKey);
                public virtual byte[] SignColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations) => throw null;
                public virtual bool VerifyColumnMasterKeyMetadata(string masterKeyPath, bool allowEnclaveComputations, byte[] signature) => throw null;
            }
            public sealed class SqlCommand : System.Data.Common.DbCommand, System.ICloneable
            {
                public System.IAsyncResult BeginExecuteNonQuery() => throw null;
                public System.IAsyncResult BeginExecuteNonQuery(System.AsyncCallback callback, object stateObject) => throw null;
                public System.IAsyncResult BeginExecuteReader() => throw null;
                public System.IAsyncResult BeginExecuteReader(System.AsyncCallback callback, object stateObject) => throw null;
                public System.IAsyncResult BeginExecuteReader(System.AsyncCallback callback, object stateObject, System.Data.CommandBehavior behavior) => throw null;
                public System.IAsyncResult BeginExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.IAsyncResult BeginExecuteXmlReader() => throw null;
                public System.IAsyncResult BeginExecuteXmlReader(System.AsyncCallback callback, object stateObject) => throw null;
                public override void Cancel() => throw null;
                object System.ICloneable.Clone() => throw null;
                public Microsoft.Data.SqlClient.SqlCommand Clone() => throw null;
                public Microsoft.Data.SqlClient.SqlCommandColumnEncryptionSetting ColumnEncryptionSetting { get => throw null; }
                public override string CommandText { get => throw null; set { } }
                public override int CommandTimeout { get => throw null; set { } }
                public override System.Data.CommandType CommandType { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; set { } }
                protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                public Microsoft.Data.SqlClient.SqlParameter CreateParameter() => throw null;
                public SqlCommand() => throw null;
                public SqlCommand(string cmdText) => throw null;
                public SqlCommand(string cmdText, Microsoft.Data.SqlClient.SqlConnection connection) => throw null;
                public SqlCommand(string cmdText, Microsoft.Data.SqlClient.SqlConnection connection, Microsoft.Data.SqlClient.SqlTransaction transaction) => throw null;
                public SqlCommand(string cmdText, Microsoft.Data.SqlClient.SqlConnection connection, Microsoft.Data.SqlClient.SqlTransaction transaction, Microsoft.Data.SqlClient.SqlCommandColumnEncryptionSetting columnEncryptionSetting) => throw null;
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; set { } }
                protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set { } }
                public override bool DesignTimeVisible { get => throw null; set { } }
                protected override void Dispose(bool disposing) => throw null;
                public bool EnableOptimizedParameterBinding { get => throw null; set { } }
                public int EndExecuteNonQuery(System.IAsyncResult asyncResult) => throw null;
                public Microsoft.Data.SqlClient.SqlDataReader EndExecuteReader(System.IAsyncResult asyncResult) => throw null;
                public System.Xml.XmlReader EndExecuteXmlReader(System.IAsyncResult asyncResult) => throw null;
                protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                protected override System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public override int ExecuteNonQuery() => throw null;
                public override System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public Microsoft.Data.SqlClient.SqlDataReader ExecuteReader() => throw null;
                public Microsoft.Data.SqlClient.SqlDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlDataReader> ExecuteReaderAsync() => throw null;
                public System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override object ExecuteScalar() => throw null;
                public override System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Xml.XmlReader ExecuteXmlReader() => throw null;
                public System.Threading.Tasks.Task<System.Xml.XmlReader> ExecuteXmlReaderAsync() => throw null;
                public System.Threading.Tasks.Task<System.Xml.XmlReader> ExecuteXmlReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public Microsoft.Data.Sql.SqlNotificationRequest Notification { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlParameterCollection Parameters { get => throw null; }
                public override void Prepare() => throw null;
                public void RegisterColumnEncryptionKeyStoreProvidersOnCommand(System.Collections.Generic.IDictionary<string, Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider> customProviders) => throw null;
                public void ResetCommandTimeout() => throw null;
                public Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider RetryLogicProvider { get => throw null; set { } }
                public event System.Data.StatementCompletedEventHandler StatementCompleted;
                public Microsoft.Data.SqlClient.SqlTransaction Transaction { get => throw null; set { } }
                public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set { } }
            }
            public sealed class SqlCommandBuilder : System.Data.Common.DbCommandBuilder
            {
                protected override void ApplyParameterInfo(System.Data.Common.DbParameter parameter, System.Data.DataRow datarow, System.Data.StatementType statementType, bool whereClause) => throw null;
                public override System.Data.Common.CatalogLocation CatalogLocation { get => throw null; set { } }
                public override string CatalogSeparator { get => throw null; set { } }
                public SqlCommandBuilder() => throw null;
                public SqlCommandBuilder(Microsoft.Data.SqlClient.SqlDataAdapter adapter) => throw null;
                public Microsoft.Data.SqlClient.SqlDataAdapter DataAdapter { get => throw null; set { } }
                public static void DeriveParameters(Microsoft.Data.SqlClient.SqlCommand command) => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetDeleteCommand() => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetDeleteCommand(bool useColumnsForParameterNames) => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetInsertCommand() => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetInsertCommand(bool useColumnsForParameterNames) => throw null;
                protected override string GetParameterName(int parameterOrdinal) => throw null;
                protected override string GetParameterName(string parameterName) => throw null;
                protected override string GetParameterPlaceholder(int parameterOrdinal) => throw null;
                protected override System.Data.DataTable GetSchemaTable(System.Data.Common.DbCommand srcCommand) => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetUpdateCommand() => throw null;
                public Microsoft.Data.SqlClient.SqlCommand GetUpdateCommand(bool useColumnsForParameterNames) => throw null;
                protected override System.Data.Common.DbCommand InitializeCommand(System.Data.Common.DbCommand command) => throw null;
                public override string QuoteIdentifier(string unquotedIdentifier) => throw null;
                public override string QuotePrefix { get => throw null; set { } }
                public override string QuoteSuffix { get => throw null; set { } }
                public override string SchemaSeparator { get => throw null; set { } }
                protected override void SetRowUpdatingHandler(System.Data.Common.DbDataAdapter adapter) => throw null;
                public override string UnquoteIdentifier(string quotedIdentifier) => throw null;
            }
            public enum SqlCommandColumnEncryptionSetting
            {
                Disabled = 3,
                Enabled = 1,
                ResultSetOnly = 2,
                UseConnectionSetting = 0,
            }
            public sealed class SqlConfigurableRetryFactory
            {
                public static Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider CreateExponentialRetryProvider(Microsoft.Data.SqlClient.SqlRetryLogicOption retryLogicOption) => throw null;
                public static Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider CreateFixedRetryProvider(Microsoft.Data.SqlClient.SqlRetryLogicOption retryLogicOption) => throw null;
                public static Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider CreateIncrementalRetryProvider(Microsoft.Data.SqlClient.SqlRetryLogicOption retryLogicOption) => throw null;
                public static Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider CreateNoneRetryProvider() => throw null;
                public SqlConfigurableRetryFactory() => throw null;
            }
            public sealed class SqlConnection : System.Data.Common.DbConnection, System.ICloneable
            {
                public string AccessToken { get => throw null; set { } }
                public System.Func<Microsoft.Data.SqlClient.SqlAuthenticationParameters, System.Threading.CancellationToken, System.Threading.Tasks.Task<Microsoft.Data.SqlClient.SqlAuthenticationToken>> AccessTokenCallback { get => throw null; set { } }
                protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public Microsoft.Data.SqlClient.SqlTransaction BeginTransaction() => throw null;
                public Microsoft.Data.SqlClient.SqlTransaction BeginTransaction(System.Data.IsolationLevel iso) => throw null;
                public Microsoft.Data.SqlClient.SqlTransaction BeginTransaction(System.Data.IsolationLevel iso, string transactionName) => throw null;
                public Microsoft.Data.SqlClient.SqlTransaction BeginTransaction(string transactionName) => throw null;
                public override bool CanCreateBatch { get => throw null; }
                public override void ChangeDatabase(string database) => throw null;
                public static void ChangePassword(string connectionString, Microsoft.Data.SqlClient.SqlCredential credential, System.Security.SecureString newSecurePassword) => throw null;
                public static void ChangePassword(string connectionString, string newPassword) => throw null;
                public static void ClearAllPools() => throw null;
                public static void ClearPool(Microsoft.Data.SqlClient.SqlConnection connection) => throw null;
                public System.Guid ClientConnectionId { get => throw null; }
                object System.ICloneable.Clone() => throw null;
                public override void Close() => throw null;
                public static System.TimeSpan ColumnEncryptionKeyCacheTtl { get => throw null; set { } }
                public static bool ColumnEncryptionQueryMetadataCacheEnabled { get => throw null; set { } }
                public static System.Collections.Generic.IDictionary<string, System.Collections.Generic.IList<string>> ColumnEncryptionTrustedMasterKeyPaths { get => throw null; }
                public int CommandTimeout { get => throw null; }
                public override string ConnectionString { get => throw null; set { } }
                public override int ConnectionTimeout { get => throw null; }
                public Microsoft.Data.SqlClient.SqlCommand CreateCommand() => throw null;
                protected override System.Data.Common.DbBatch CreateDbBatch() => throw null;
                protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                public Microsoft.Data.SqlClient.SqlCredential Credential { get => throw null; set { } }
                public SqlConnection() => throw null;
                public SqlConnection(string connectionString) => throw null;
                public SqlConnection(string connectionString, Microsoft.Data.SqlClient.SqlCredential credential) => throw null;
                public override string Database { get => throw null; }
                public override string DataSource { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public bool FireInfoMessageEventOnUserErrors { get => throw null; set { } }
                public override System.Data.DataTable GetSchema() => throw null;
                public override System.Data.DataTable GetSchema(string collectionName) => throw null;
                public override System.Data.DataTable GetSchema(string collectionName, string[] restrictionValues) => throw null;
                public event Microsoft.Data.SqlClient.SqlInfoMessageEventHandler InfoMessage;
                public override void Open() => throw null;
                public void Open(Microsoft.Data.SqlClient.SqlConnectionOverrides overrides) => throw null;
                public override System.Threading.Tasks.Task OpenAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task OpenAsync(Microsoft.Data.SqlClient.SqlConnectionOverrides overrides, System.Threading.CancellationToken cancellationToken) => throw null;
                public int PacketSize { get => throw null; }
                public static void RegisterColumnEncryptionKeyStoreProviders(System.Collections.Generic.IDictionary<string, Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider> customProviders) => throw null;
                public void RegisterColumnEncryptionKeyStoreProvidersOnConnection(System.Collections.Generic.IDictionary<string, Microsoft.Data.SqlClient.SqlColumnEncryptionKeyStoreProvider> customProviders) => throw null;
                public void ResetStatistics() => throw null;
                public System.Collections.Generic.IDictionary<string, object> RetrieveInternalInfo() => throw null;
                public System.Collections.IDictionary RetrieveStatistics() => throw null;
                public Microsoft.Data.SqlClient.SqlRetryLogicBaseProvider RetryLogicProvider { get => throw null; set { } }
                public int ServerProcessId { get => throw null; }
                public override string ServerVersion { get => throw null; }
                public override System.Data.ConnectionState State { get => throw null; }
                public bool StatisticsEnabled { get => throw null; set { } }
                public string WorkstationId { get => throw null; }
            }
            public enum SqlConnectionAttestationProtocol
            {
                NotSpecified = 0,
                AAS = 1,
                None = 2,
                HGS = 3,
            }
            public enum SqlConnectionColumnEncryptionSetting
            {
                Disabled = 0,
                Enabled = 1,
            }
            public sealed class SqlConnectionEncryptOption
            {
                public SqlConnectionEncryptOption() => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static Microsoft.Data.SqlClient.SqlConnectionEncryptOption Mandatory { get => throw null; }
                public static implicit operator Microsoft.Data.SqlClient.SqlConnectionEncryptOption(bool value) => throw null;
                public static implicit operator bool(Microsoft.Data.SqlClient.SqlConnectionEncryptOption value) => throw null;
                public static Microsoft.Data.SqlClient.SqlConnectionEncryptOption Optional { get => throw null; }
                public static Microsoft.Data.SqlClient.SqlConnectionEncryptOption Parse(string value) => throw null;
                public static Microsoft.Data.SqlClient.SqlConnectionEncryptOption Strict { get => throw null; }
                public override string ToString() => throw null;
                public static bool TryParse(string value, out Microsoft.Data.SqlClient.SqlConnectionEncryptOption result) => throw null;
            }
            public enum SqlConnectionIPAddressPreference
            {
                IPv4First = 0,
                IPv6First = 1,
                UsePlatformDefault = 2,
            }
            public enum SqlConnectionOverrides
            {
                None = 0,
                OpenWithoutRetry = 1,
            }
            public sealed class SqlConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
            {
                public Microsoft.Data.SqlClient.ApplicationIntent ApplicationIntent { get => throw null; set { } }
                public string ApplicationName { get => throw null; set { } }
                public string AttachDBFilename { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlConnectionAttestationProtocol AttestationProtocol { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlAuthenticationMethod Authentication { get => throw null; set { } }
                public override void Clear() => throw null;
                public Microsoft.Data.SqlClient.SqlConnectionColumnEncryptionSetting ColumnEncryptionSetting { get => throw null; set { } }
                public int CommandTimeout { get => throw null; set { } }
                public int ConnectRetryCount { get => throw null; set { } }
                public int ConnectRetryInterval { get => throw null; set { } }
                public int ConnectTimeout { get => throw null; set { } }
                public override bool ContainsKey(string keyword) => throw null;
                public SqlConnectionStringBuilder() => throw null;
                public SqlConnectionStringBuilder(string connectionString) => throw null;
                public string CurrentLanguage { get => throw null; set { } }
                public string DataSource { get => throw null; set { } }
                public string EnclaveAttestationUrl { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlConnectionEncryptOption Encrypt { get => throw null; set { } }
                public bool Enlist { get => throw null; set { } }
                public string FailoverPartner { get => throw null; set { } }
                public string FailoverPartnerSPN { get => throw null; set { } }
                public string HostNameInCertificate { get => throw null; set { } }
                public string InitialCatalog { get => throw null; set { } }
                public bool IntegratedSecurity { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlConnectionIPAddressPreference IPAddressPreference { get => throw null; set { } }
                public override bool IsFixedSize { get => throw null; }
                public override System.Collections.ICollection Keys { get => throw null; }
                public int LoadBalanceTimeout { get => throw null; set { } }
                public int MaxPoolSize { get => throw null; set { } }
                public int MinPoolSize { get => throw null; set { } }
                public bool MultipleActiveResultSets { get => throw null; set { } }
                public bool MultiSubnetFailover { get => throw null; set { } }
                public int PacketSize { get => throw null; set { } }
                public string Password { get => throw null; set { } }
                public bool PersistSecurityInfo { get => throw null; set { } }
                public Microsoft.Data.SqlClient.PoolBlockingPeriod PoolBlockingPeriod { get => throw null; set { } }
                public bool Pooling { get => throw null; set { } }
                public override bool Remove(string keyword) => throw null;
                public bool Replication { get => throw null; set { } }
                public string ServerCertificate { get => throw null; set { } }
                public string ServerSPN { get => throw null; set { } }
                public override bool ShouldSerialize(string keyword) => throw null;
                public override object this[string keyword] { get => throw null; set { } }
                public string TransactionBinding { get => throw null; set { } }
                public bool TrustServerCertificate { get => throw null; set { } }
                public override bool TryGetValue(string keyword, out object value) => throw null;
                public string TypeSystemVersion { get => throw null; set { } }
                public string UserID { get => throw null; set { } }
                public bool UserInstance { get => throw null; set { } }
                public override System.Collections.ICollection Values { get => throw null; }
                public string WorkstationID { get => throw null; set { } }
            }
            public sealed class SqlCredential
            {
                public SqlCredential(string userId, System.Security.SecureString password) => throw null;
                public System.Security.SecureString Password { get => throw null; }
                public string UserId { get => throw null; }
            }
            public sealed class SqlDataAdapter : System.Data.Common.DbDataAdapter, System.ICloneable, System.Data.IDataAdapter, System.Data.IDbDataAdapter
            {
                object System.ICloneable.Clone() => throw null;
                public SqlDataAdapter() => throw null;
                public SqlDataAdapter(Microsoft.Data.SqlClient.SqlCommand selectCommand) => throw null;
                public SqlDataAdapter(string selectCommandText, Microsoft.Data.SqlClient.SqlConnection selectConnection) => throw null;
                public SqlDataAdapter(string selectCommandText, string selectConnectionString) => throw null;
                public Microsoft.Data.SqlClient.SqlCommand DeleteCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.DeleteCommand { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlCommand InsertCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.InsertCommand { get => throw null; set { } }
                protected override void OnRowUpdated(System.Data.Common.RowUpdatedEventArgs value) => throw null;
                protected override void OnRowUpdating(System.Data.Common.RowUpdatingEventArgs value) => throw null;
                public event Microsoft.Data.SqlClient.SqlRowUpdatedEventHandler RowUpdated;
                public event Microsoft.Data.SqlClient.SqlRowUpdatingEventHandler RowUpdating;
                public Microsoft.Data.SqlClient.SqlCommand SelectCommand { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.SelectCommand { get => throw null; set { } }
                public override int UpdateBatchSize { get => throw null; set { } }
                System.Data.IDbCommand System.Data.IDbDataAdapter.UpdateCommand { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlCommand UpdateCommand { get => throw null; set { } }
            }
            public class SqlDataReader : System.Data.Common.DbDataReader, System.Data.IDataReader, System.Data.IDataRecord, System.IDisposable
            {
                public override void Close() => throw null;
                protected Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                public override int Depth { get => throw null; }
                public override int FieldCount { get => throw null; }
                public override bool GetBoolean(int i) => throw null;
                public override byte GetByte(int i) => throw null;
                public override long GetBytes(int i, long dataIndex, byte[] buffer, int bufferIndex, int length) => throw null;
                public override char GetChar(int i) => throw null;
                public override long GetChars(int i, long dataIndex, char[] buffer, int bufferIndex, int length) => throw null;
                public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Common.DbColumn> GetColumnSchema() => throw null;
                System.Data.IDataReader System.Data.IDataRecord.GetData(int i) => throw null;
                public override string GetDataTypeName(int i) => throw null;
                public override System.DateTime GetDateTime(int i) => throw null;
                public virtual System.DateTimeOffset GetDateTimeOffset(int i) => throw null;
                public override decimal GetDecimal(int i) => throw null;
                public override double GetDouble(int i) => throw null;
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                public override System.Type GetFieldType(int i) => throw null;
                public override T GetFieldValue<T>(int i) => throw null;
                public override System.Threading.Tasks.Task<T> GetFieldValueAsync<T>(int i, System.Threading.CancellationToken cancellationToken) => throw null;
                public override float GetFloat(int i) => throw null;
                public override System.Guid GetGuid(int i) => throw null;
                public override short GetInt16(int i) => throw null;
                public override int GetInt32(int i) => throw null;
                public override long GetInt64(int i) => throw null;
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
                public virtual Microsoft.Data.SqlTypes.SqlJson GetSqlJson(int i) => throw null;
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
                protected bool IsCommandBehavior(System.Data.CommandBehavior condition) => throw null;
                public override bool IsDBNull(int i) => throw null;
                public override System.Threading.Tasks.Task<bool> IsDBNullAsync(int i, System.Threading.CancellationToken cancellationToken) => throw null;
                public override bool NextResult() => throw null;
                public override System.Threading.Tasks.Task<bool> NextResultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override bool Read() => throw null;
                public override System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override int RecordsAffected { get => throw null; }
                public Microsoft.Data.SqlClient.DataClassification.SensitivityClassification SensitivityClassification { get => throw null; }
                public override object this[int i] { get => throw null; }
                public override object this[string name] { get => throw null; }
                public override int VisibleFieldCount { get => throw null; }
            }
            public sealed class SqlDependency
            {
                public void AddCommandDependency(Microsoft.Data.SqlClient.SqlCommand command) => throw null;
                public SqlDependency() => throw null;
                public SqlDependency(Microsoft.Data.SqlClient.SqlCommand command) => throw null;
                public SqlDependency(Microsoft.Data.SqlClient.SqlCommand command, string options, int timeout) => throw null;
                public bool HasChanges { get => throw null; }
                public string Id { get => throw null; }
                public event Microsoft.Data.SqlClient.OnChangeEventHandler OnChange;
                public static bool Start(string connectionString) => throw null;
                public static bool Start(string connectionString, string queue) => throw null;
                public static bool Stop(string connectionString) => throw null;
                public static bool Stop(string connectionString, string queue) => throw null;
            }
            public sealed class SqlError
            {
                public byte Class { get => throw null; }
                public int LineNumber { get => throw null; }
                public string Message { get => throw null; }
                public int Number { get => throw null; }
                public string Procedure { get => throw null; }
                public string Server { get => throw null; }
                public string Source { get => throw null; }
                public byte State { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class SqlErrorCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(Microsoft.Data.SqlClient.SqlError[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public Microsoft.Data.SqlClient.SqlError this[int index] { get => throw null; }
            }
            public sealed class SqlException : System.Data.Common.DbException
            {
                public Microsoft.Data.SqlClient.SqlBatchCommand BatchCommand { get => throw null; }
                public byte Class { get => throw null; }
                public System.Guid ClientConnectionId { get => throw null; }
                protected override System.Data.Common.DbBatchCommand DbBatchCommand { get => throw null; }
                public Microsoft.Data.SqlClient.SqlErrorCollection Errors { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
                public int LineNumber { get => throw null; }
                public int Number { get => throw null; }
                public string Procedure { get => throw null; }
                public string Server { get => throw null; }
                public override string Source { get => throw null; }
                public byte State { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class SqlInfoMessageEventArgs : System.EventArgs
            {
                public Microsoft.Data.SqlClient.SqlErrorCollection Errors { get => throw null; }
                public string Message { get => throw null; }
                public string Source { get => throw null; }
                public override string ToString() => throw null;
            }
            public delegate void SqlInfoMessageEventHandler(object sender, Microsoft.Data.SqlClient.SqlInfoMessageEventArgs e);
            public class SqlNotificationEventArgs : System.EventArgs
            {
                public SqlNotificationEventArgs(Microsoft.Data.SqlClient.SqlNotificationType type, Microsoft.Data.SqlClient.SqlNotificationInfo info, Microsoft.Data.SqlClient.SqlNotificationSource source) => throw null;
                public Microsoft.Data.SqlClient.SqlNotificationInfo Info { get => throw null; }
                public Microsoft.Data.SqlClient.SqlNotificationSource Source { get => throw null; }
                public Microsoft.Data.SqlClient.SqlNotificationType Type { get => throw null; }
            }
            public enum SqlNotificationInfo
            {
                AlreadyChanged = -2,
                Alter = 5,
                Delete = 3,
                Drop = 4,
                Error = 7,
                Expired = 12,
                Insert = 1,
                Invalid = 9,
                Isolation = 11,
                Merge = 16,
                Options = 10,
                PreviousFire = 14,
                Query = 8,
                Resource = 13,
                Restart = 6,
                TemplateLimit = 15,
                Truncate = 0,
                Unknown = -1,
                Update = 2,
            }
            public enum SqlNotificationSource
            {
                Client = -2,
                Data = 0,
                Database = 3,
                Environment = 6,
                Execution = 7,
                Object = 2,
                Owner = 8,
                Statement = 5,
                System = 4,
                Timeout = 1,
                Unknown = -1,
            }
            public enum SqlNotificationType
            {
                Change = 0,
                Subscribe = 1,
                Unknown = -1,
            }
            public sealed class SqlParameter : System.Data.Common.DbParameter, System.ICloneable, System.Data.IDataParameter, System.Data.IDbDataParameter
            {
                object System.ICloneable.Clone() => throw null;
                public System.Data.SqlTypes.SqlCompareOptions CompareInfo { get => throw null; set { } }
                public SqlParameter() => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, System.Data.ParameterDirection direction, bool isNullable, byte precision, byte scale, string sourceColumn, System.Data.DataRowVersion sourceVersion, object value) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, System.Data.ParameterDirection direction, byte precision, byte scale, string sourceColumn, System.Data.DataRowVersion sourceVersion, bool sourceColumnNullMapping, object value, string xmlSchemaCollectionDatabase, string xmlSchemaCollectionOwningSchema, string xmlSchemaCollectionName) => throw null;
                public SqlParameter(string parameterName, System.Data.SqlDbType dbType, int size, string sourceColumn) => throw null;
                public SqlParameter(string parameterName, object value) => throw null;
                public override System.Data.DbType DbType { get => throw null; set { } }
                public override System.Data.ParameterDirection Direction { get => throw null; set { } }
                public bool ForceColumnEncryption { get => throw null; set { } }
                public override bool IsNullable { get => throw null; set { } }
                public int LocaleId { get => throw null; set { } }
                public int Offset { get => throw null; set { } }
                public override string ParameterName { get => throw null; set { } }
                public byte Precision { get => throw null; set { } }
                public override void ResetDbType() => throw null;
                public void ResetSqlDbType() => throw null;
                public byte Scale { get => throw null; set { } }
                public override int Size { get => throw null; set { } }
                public override string SourceColumn { get => throw null; set { } }
                public override bool SourceColumnNullMapping { get => throw null; set { } }
                public override System.Data.DataRowVersion SourceVersion { get => throw null; set { } }
                public System.Data.SqlDbType SqlDbType { get => throw null; set { } }
                public object SqlValue { get => throw null; set { } }
                public override string ToString() => throw null;
                public string TypeName { get => throw null; set { } }
                public string UdtTypeName { get => throw null; set { } }
                public override object Value { get => throw null; set { } }
                public string XmlSchemaCollectionDatabase { get => throw null; set { } }
                public string XmlSchemaCollectionName { get => throw null; set { } }
                public string XmlSchemaCollectionOwningSchema { get => throw null; set { } }
            }
            public sealed class SqlParameterCollection : System.Data.Common.DbParameterCollection
            {
                public Microsoft.Data.SqlClient.SqlParameter Add(Microsoft.Data.SqlClient.SqlParameter value) => throw null;
                public override int Add(object value) => throw null;
                public Microsoft.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType) => throw null;
                public Microsoft.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType, int size) => throw null;
                public Microsoft.Data.SqlClient.SqlParameter Add(string parameterName, System.Data.SqlDbType sqlDbType, int size, string sourceColumn) => throw null;
                public void AddRange(Microsoft.Data.SqlClient.SqlParameter[] values) => throw null;
                public override void AddRange(System.Array values) => throw null;
                public Microsoft.Data.SqlClient.SqlParameter AddWithValue(string parameterName, object value) => throw null;
                public override void Clear() => throw null;
                public bool Contains(Microsoft.Data.SqlClient.SqlParameter value) => throw null;
                public override bool Contains(object value) => throw null;
                public override bool Contains(string value) => throw null;
                public override void CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(Microsoft.Data.SqlClient.SqlParameter[] array, int index) => throw null;
                public override int Count { get => throw null; }
                public override System.Collections.IEnumerator GetEnumerator() => throw null;
                protected override System.Data.Common.DbParameter GetParameter(int index) => throw null;
                protected override System.Data.Common.DbParameter GetParameter(string parameterName) => throw null;
                public int IndexOf(Microsoft.Data.SqlClient.SqlParameter value) => throw null;
                public override int IndexOf(object value) => throw null;
                public override int IndexOf(string parameterName) => throw null;
                public void Insert(int index, Microsoft.Data.SqlClient.SqlParameter value) => throw null;
                public override void Insert(int index, object value) => throw null;
                public override bool IsFixedSize { get => throw null; }
                public override bool IsReadOnly { get => throw null; }
                public void Remove(Microsoft.Data.SqlClient.SqlParameter value) => throw null;
                public override void Remove(object value) => throw null;
                public override void RemoveAt(int index) => throw null;
                public override void RemoveAt(string parameterName) => throw null;
                protected override void SetParameter(int index, System.Data.Common.DbParameter value) => throw null;
                protected override void SetParameter(string parameterName, System.Data.Common.DbParameter value) => throw null;
                public override object SyncRoot { get => throw null; }
                public Microsoft.Data.SqlClient.SqlParameter this[int index] { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlParameter this[string parameterName] { get => throw null; set { } }
            }
            public sealed class SqlRetryingEventArgs : System.EventArgs
            {
                public bool Cancel { get => throw null; set { } }
                public SqlRetryingEventArgs(int retryCount, System.TimeSpan delay, System.Collections.Generic.IList<System.Exception> exceptions) => throw null;
                public System.TimeSpan Delay { get => throw null; }
                public System.Collections.Generic.IList<System.Exception> Exceptions { get => throw null; }
                public int RetryCount { get => throw null; }
            }
            public abstract class SqlRetryIntervalBaseEnumerator : System.ICloneable, System.IDisposable, System.Collections.Generic.IEnumerator<System.TimeSpan>, System.Collections.IEnumerator
            {
                public virtual object Clone() => throw null;
                public SqlRetryIntervalBaseEnumerator() => throw null;
                public SqlRetryIntervalBaseEnumerator(System.TimeSpan timeInterval, System.TimeSpan maxTime, System.TimeSpan minTime) => throw null;
                public System.TimeSpan Current { get => throw null; set { } }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public virtual void Dispose() => throw null;
                public System.TimeSpan GapTimeInterval { get => throw null; set { } }
                protected abstract System.TimeSpan GetNextInterval();
                public System.TimeSpan MaxTimeInterval { get => throw null; set { } }
                public System.TimeSpan MinTimeInterval { get => throw null; set { } }
                public virtual bool MoveNext() => throw null;
                public virtual void Reset() => throw null;
                protected virtual void Validate(System.TimeSpan timeInterval, System.TimeSpan maxTimeInterval, System.TimeSpan minTimeInterval) => throw null;
            }
            public abstract class SqlRetryLogicBase : System.ICloneable
            {
                public virtual object Clone() => throw null;
                protected SqlRetryLogicBase() => throw null;
                public int Current { get => throw null; set { } }
                public int NumberOfTries { get => throw null; set { } }
                public abstract void Reset();
                public virtual bool RetryCondition(object sender) => throw null;
                public Microsoft.Data.SqlClient.SqlRetryIntervalBaseEnumerator RetryIntervalEnumerator { get => throw null; set { } }
                public System.Predicate<System.Exception> TransientPredicate { get => throw null; set { } }
                public abstract bool TryNextInterval(out System.TimeSpan intervalTime);
            }
            public abstract class SqlRetryLogicBaseProvider
            {
                protected SqlRetryLogicBaseProvider() => throw null;
                public abstract TResult Execute<TResult>(object sender, System.Func<TResult> function);
                public abstract System.Threading.Tasks.Task<TResult> ExecuteAsync<TResult>(object sender, System.Func<System.Threading.Tasks.Task<TResult>> function, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task ExecuteAsync(object sender, System.Func<System.Threading.Tasks.Task> function, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public System.EventHandler<Microsoft.Data.SqlClient.SqlRetryingEventArgs> Retrying { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlRetryLogicBase RetryLogic { get => throw null; set { } }
            }
            public sealed class SqlRetryLogicOption
            {
                public System.Predicate<string> AuthorizedSqlCondition { get => throw null; set { } }
                public SqlRetryLogicOption() => throw null;
                public System.TimeSpan DeltaTime { get => throw null; set { } }
                public System.TimeSpan MaxTimeInterval { get => throw null; set { } }
                public System.TimeSpan MinTimeInterval { get => throw null; set { } }
                public int NumberOfTries { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<int> TransientErrors { get => throw null; set { } }
            }
            public class SqlRowsCopiedEventArgs : System.EventArgs
            {
                public bool Abort { get => throw null; set { } }
                public SqlRowsCopiedEventArgs(long rowsCopied) => throw null;
                public long RowsCopied { get => throw null; }
            }
            public delegate void SqlRowsCopiedEventHandler(object sender, Microsoft.Data.SqlClient.SqlRowsCopiedEventArgs e);
            public sealed class SqlRowUpdatedEventArgs : System.Data.Common.RowUpdatedEventArgs
            {
                public Microsoft.Data.SqlClient.SqlCommand Command { get => throw null; }
                public SqlRowUpdatedEventArgs(System.Data.DataRow row, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) : base(default(System.Data.DataRow), default(System.Data.IDbCommand), default(System.Data.StatementType), default(System.Data.Common.DataTableMapping)) => throw null;
            }
            public delegate void SqlRowUpdatedEventHandler(object sender, Microsoft.Data.SqlClient.SqlRowUpdatedEventArgs e);
            public sealed class SqlRowUpdatingEventArgs : System.Data.Common.RowUpdatingEventArgs
            {
                protected override System.Data.IDbCommand BaseCommand { get => throw null; set { } }
                public Microsoft.Data.SqlClient.SqlCommand Command { get => throw null; set { } }
                public SqlRowUpdatingEventArgs(System.Data.DataRow row, System.Data.IDbCommand command, System.Data.StatementType statementType, System.Data.Common.DataTableMapping tableMapping) : base(default(System.Data.DataRow), default(System.Data.IDbCommand), default(System.Data.StatementType), default(System.Data.Common.DataTableMapping)) => throw null;
            }
            public delegate void SqlRowUpdatingEventHandler(object sender, Microsoft.Data.SqlClient.SqlRowUpdatingEventArgs e);
            public sealed class SqlTransaction : System.Data.Common.DbTransaction
            {
                public override void Commit() => throw null;
                public Microsoft.Data.SqlClient.SqlConnection Connection { get => throw null; }
                protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                public override void Rollback() => throw null;
                public override void Rollback(string transactionName) => throw null;
                public override void Save(string savePointName) => throw null;
            }
        }
        public static partial class SqlDbTypeExtensions
        {
            public const System.Data.SqlDbType Json = default;
        }
        namespace SqlTypes
        {
            public sealed class SqlFileStream : System.IO.Stream
            {
                public override System.IAsyncResult BeginRead(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public SqlFileStream(string path, byte[] transactionContext, System.IO.FileAccess access) => throw null;
                public SqlFileStream(string path, byte[] transactionContext, System.IO.FileAccess access, System.IO.FileOptions options, long allocationSize) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override long Length { get => throw null; }
                public string Name { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override int ReadByte() => throw null;
                public override int ReadTimeout { get => throw null; }
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public byte[] TransactionContext { get => throw null; }
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override void WriteByte(byte value) => throw null;
                public override int WriteTimeout { get => throw null; }
            }
            public class SqlJson : System.Data.SqlTypes.INullable
            {
                public SqlJson() => throw null;
                public SqlJson(string jsonString) => throw null;
                public SqlJson(System.Text.Json.JsonDocument jsonDoc) => throw null;
                public bool IsNull { get => throw null; }
                public static Microsoft.Data.SqlTypes.SqlJson Null { get => throw null; }
                public string Value { get => throw null; }
            }
        }
    }
}
