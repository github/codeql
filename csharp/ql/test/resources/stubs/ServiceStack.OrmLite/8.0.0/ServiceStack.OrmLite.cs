// This file contains auto-generated code.
// Generated from `ServiceStack.OrmLite, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace ServiceStack
{
    namespace OrmLite
    {
        public class AliasNamingStrategy : ServiceStack.OrmLite.OrmLiteNamingStrategyBase
        {
            public System.Collections.Generic.Dictionary<string, string> ColumnAliases;
            public AliasNamingStrategy() => throw null;
            public override string GetColumnName(string name) => throw null;
            public override string GetTableName(string name) => throw null;
            public System.Collections.Generic.Dictionary<string, string> TableAliases;
            public ServiceStack.OrmLite.INamingStrategy UseNamingStrategy { get => throw null; set { } }
        }
        public class BulkInsertConfig
        {
            public int BatchSize { get => throw null; set { } }
            public BulkInsertConfig() => throw null;
            public System.Collections.Generic.ICollection<string> InsertFields { get => throw null; set { } }
            public ServiceStack.OrmLite.BulkInsertMode Mode { get => throw null; set { } }
        }
        public enum BulkInsertMode
        {
            Optimized = 0,
            Csv = 1,
            Sql = 2,
        }
        public class CaptureSqlFilter : ServiceStack.OrmLite.OrmLiteResultsFilter
        {
            public CaptureSqlFilter() : base(default(System.Collections.IEnumerable)) => throw null;
            public System.Collections.Generic.List<ServiceStack.OrmLite.SqlCommandDetails> SqlCommandHistory { get => throw null; set { } }
            public System.Collections.Generic.List<string> SqlStatements { get => throw null; }
        }
        public class ColumnSchema
        {
            public bool AllowDBNull { get => throw null; set { } }
            public string BaseCatalogName { get => throw null; set { } }
            public string BaseColumnName { get => throw null; set { } }
            public string BaseSchemaName { get => throw null; set { } }
            public string BaseServerName { get => throw null; set { } }
            public string BaseTableName { get => throw null; set { } }
            public string CollationType { get => throw null; set { } }
            public string ColumnDefinition { get => throw null; }
            public string ColumnName { get => throw null; set { } }
            public int ColumnOrdinal { get => throw null; set { } }
            public int ColumnSize { get => throw null; set { } }
            public ColumnSchema() => throw null;
            public System.Type DataType { get => throw null; set { } }
            public string DataTypeName { get => throw null; set { } }
            public object DefaultValue { get => throw null; set { } }
            public bool IsAliased { get => throw null; set { } }
            public bool IsAutoIncrement { get => throw null; set { } }
            public bool IsExpression { get => throw null; set { } }
            public bool IsHidden { get => throw null; set { } }
            public bool IsKey { get => throw null; set { } }
            public bool IsLong { get => throw null; set { } }
            public bool IsReadOnly { get => throw null; set { } }
            public bool IsRowVersion { get => throw null; set { } }
            public bool IsUnique { get => throw null; set { } }
            public int NumericPrecision { get => throw null; set { } }
            public int NumericScale { get => throw null; set { } }
            public System.Type ProviderSpecificDataType { get => throw null; set { } }
            public int ProviderType { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public class ConflictResolution
        {
            public ConflictResolution() => throw null;
            public const string Ignore = default;
        }
        namespace Converters
        {
            public class BoolAsIntConverter : ServiceStack.OrmLite.Converters.BoolConverter
            {
                public BoolAsIntConverter() => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class BoolConverter : ServiceStack.OrmLite.NativeValueOrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public BoolConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
            }
            public class ByteArrayConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public ByteArrayConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class ByteConverter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public ByteConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class CharArrayConverter : ServiceStack.OrmLite.Converters.StringConverter
            {
                public CharArrayConverter() => throw null;
                public CharArrayConverter(int stringLength) => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
            }
            public class CharConverter : ServiceStack.OrmLite.Converters.StringConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public CharConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override string GetColumnDefinition(int? stringLength) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
            }
            public class DateOnlyConverter : ServiceStack.OrmLite.Converters.DateTimeConverter
            {
                public DateOnlyConverter() => throw null;
                public override object FromDbValue(object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class DateTimeConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public DateTimeConverter() => throw null;
                public System.DateTimeKind DateStyle { get => throw null; set { } }
                public virtual string DateTimeFmt(System.DateTime dateTime, string dateTimeFormat) => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public virtual object FromDbValue(object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class DateTimeOffsetConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public DateTimeOffsetConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
            }
            public class DecimalConverter : ServiceStack.OrmLite.Converters.FloatConverter, ServiceStack.OrmLite.IHasColumnDefinitionPrecision
            {
                public override string ColumnDefinition { get => throw null; }
                public DecimalConverter() => throw null;
                public DecimalConverter(int precision, int scale) => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public virtual string GetColumnDefinition(int? precision, int? scale) => throw null;
                public int Precision { get => throw null; set { } }
                public int Scale { get => throw null; set { } }
            }
            public class DoubleConverter : ServiceStack.OrmLite.Converters.FloatConverter
            {
                public DoubleConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class EnumConverter : ServiceStack.OrmLite.Converters.StringConverter
            {
                public EnumConverter() => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public static ServiceStack.OrmLite.Converters.EnumKind GetEnumKind(System.Type enumType) => throw null;
                public static bool HasEnumMembers(System.Type enumType) => throw null;
                public override void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType) => throw null;
                public static bool IsIntEnum(System.Type fieldType) => throw null;
                public static char ToCharValue(object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public enum EnumKind
            {
                String = 0,
                Int = 1,
                Char = 2,
                EnumMember = 3,
            }
            public class FloatConverter : ServiceStack.OrmLite.NativeValueOrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public FloatConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class GuidConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public GuidConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
            }
            public class Int16Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public Int16Converter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class Int32Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public Int32Converter() => throw null;
            }
            public class Int64Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public Int64Converter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public abstract class IntegerConverter : ServiceStack.OrmLite.NativeValueOrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                protected IntegerConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
            }
            public class ReferenceTypeConverter : ServiceStack.OrmLite.Converters.StringConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public ReferenceTypeConverter() => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override string GetColumnDefinition(int? stringLength) => throw null;
                public override string MaxColumnDefinition { get => throw null; }
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class RowVersionConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public RowVersionConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
            }
            public class SByteConverter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public SByteConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class StringConverter : ServiceStack.OrmLite.OrmLiteConverter, ServiceStack.OrmLite.IHasColumnDefinitionLength
            {
                public override string ColumnDefinition { get => throw null; }
                public StringConverter() => throw null;
                public StringConverter(int stringLength) => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public virtual string GetColumnDefinition(int? stringLength) => throw null;
                public override void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType) => throw null;
                protected string maxColumnDefinition;
                public virtual string MaxColumnDefinition { get => throw null; set { } }
                public virtual int MaxVarCharLength { get => throw null; }
                public int StringLength { get => throw null; set { } }
                public bool UseUnicode { get => throw null; set { } }
            }
            public class TimeOnlyConverter : ServiceStack.OrmLite.Converters.TimeSpanAsIntConverter
            {
                public TimeOnlyConverter() => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class TimeSpanAsIntConverter : ServiceStack.OrmLite.OrmLiteConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public TimeSpanAsIntConverter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
            public class UInt16Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public UInt16Converter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class UInt32Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public UInt32Converter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class UInt64Converter : ServiceStack.OrmLite.Converters.IntegerConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public UInt64Converter() => throw null;
                public override System.Data.DbType DbType { get => throw null; }
            }
            public class ValueTypeConverter : ServiceStack.OrmLite.Converters.StringConverter
            {
                public override string ColumnDefinition { get => throw null; }
                public ValueTypeConverter() => throw null;
                public override object FromDbValue(System.Type fieldType, object value) => throw null;
                public override string GetColumnDefinition(int? stringLength) => throw null;
                public override string MaxColumnDefinition { get => throw null; }
                public override object ToDbValue(System.Type fieldType, object value) => throw null;
                public override string ToQuotedString(System.Type fieldType, object value) => throw null;
            }
        }
        namespace Dapper
        {
            public struct CommandDefinition
            {
                public bool Buffered { get => throw null; }
                public System.Threading.CancellationToken CancellationToken { get => throw null; }
                public string CommandText { get => throw null; }
                public int? CommandTimeout { get => throw null; }
                public System.Data.CommandType? CommandType { get => throw null; }
                public CommandDefinition(string commandText, object parameters = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?), ServiceStack.OrmLite.Dapper.CommandFlags flags = default(ServiceStack.OrmLite.Dapper.CommandFlags), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public ServiceStack.OrmLite.Dapper.CommandFlags Flags { get => throw null; }
                public object Parameters { get => throw null; }
                public bool Pipelined { get => throw null; }
                public System.Data.IDbTransaction Transaction { get => throw null; }
            }
            [System.Flags]
            public enum CommandFlags
            {
                None = 0,
                Buffered = 1,
                Pipelined = 2,
                NoCache = 4,
            }
            public sealed class CustomPropertyTypeMap : ServiceStack.OrmLite.Dapper.SqlMapper.ITypeMap
            {
                public CustomPropertyTypeMap(System.Type type, System.Func<System.Type, string, System.Reflection.PropertyInfo> propertySelector) => throw null;
                public System.Reflection.ConstructorInfo FindConstructor(string[] names, System.Type[] types) => throw null;
                public System.Reflection.ConstructorInfo FindExplicitConstructor() => throw null;
                public ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName) => throw null;
                public ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetMember(string columnName) => throw null;
            }
            public sealed class DbString : ServiceStack.OrmLite.Dapper.SqlMapper.ICustomQueryParameter
            {
                public void AddParameter(System.Data.IDbCommand command, string name) => throw null;
                public DbString() => throw null;
                public const int DefaultLength = 4000;
                public bool IsAnsi { get => throw null; set { } }
                public static bool IsAnsiDefault { get => throw null; set { } }
                public bool IsFixedLength { get => throw null; set { } }
                public int Length { get => throw null; set { } }
                public string Value { get => throw null; set { } }
            }
            public sealed class DefaultTypeMap : ServiceStack.OrmLite.Dapper.SqlMapper.ITypeMap
            {
                public DefaultTypeMap(System.Type type) => throw null;
                public System.Reflection.ConstructorInfo FindConstructor(string[] names, System.Type[] types) => throw null;
                public System.Reflection.ConstructorInfo FindExplicitConstructor() => throw null;
                public ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName) => throw null;
                public ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetMember(string columnName) => throw null;
                public static bool MatchNamesWithUnderscores { get => throw null; set { } }
                public System.Collections.Generic.List<System.Reflection.PropertyInfo> Properties { get => throw null; }
            }
            public class DynamicParameters : ServiceStack.OrmLite.Dapper.SqlMapper.IDynamicParameters, ServiceStack.OrmLite.Dapper.SqlMapper.IParameterCallbacks, ServiceStack.OrmLite.Dapper.SqlMapper.IParameterLookup
            {
                public void Add(string name, object value, System.Data.DbType? dbType, System.Data.ParameterDirection? direction, int? size) => throw null;
                public void Add(string name, object value = default(object), System.Data.DbType? dbType = default(System.Data.DbType?), System.Data.ParameterDirection? direction = default(System.Data.ParameterDirection?), int? size = default(int?), byte? precision = default(byte?), byte? scale = default(byte?)) => throw null;
                public void AddDynamicParams(object param) => throw null;
                void ServiceStack.OrmLite.Dapper.SqlMapper.IDynamicParameters.AddParameters(System.Data.IDbCommand command, ServiceStack.OrmLite.Dapper.SqlMapper.Identity identity) => throw null;
                protected void AddParameters(System.Data.IDbCommand command, ServiceStack.OrmLite.Dapper.SqlMapper.Identity identity) => throw null;
                public DynamicParameters() => throw null;
                public DynamicParameters(object template) => throw null;
                public T Get<T>(string name) => throw null;
                object ServiceStack.OrmLite.Dapper.SqlMapper.IParameterLookup.this[string name] { get => throw null; }
                void ServiceStack.OrmLite.Dapper.SqlMapper.IParameterCallbacks.OnCompleted() => throw null;
                public ServiceStack.OrmLite.Dapper.DynamicParameters Output<T>(T target, System.Linq.Expressions.Expression<System.Func<T, object>> expression, System.Data.DbType? dbType = default(System.Data.DbType?), int? size = default(int?)) => throw null;
                public System.Collections.Generic.IEnumerable<string> ParameterNames { get => throw null; }
                public bool RemoveUnused { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)32, AllowMultiple = false)]
            public sealed class ExplicitConstructorAttribute : System.Attribute
            {
                public ExplicitConstructorAttribute() => throw null;
            }
            public interface IWrappedDataReader : System.Data.IDataReader, System.Data.IDataRecord, System.IDisposable
            {
                System.Data.IDbCommand Command { get; }
                System.Data.IDataReader Reader { get; }
            }
            public static class SqlMapper
            {
                public static void AddTypeHandler(System.Type type, ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler handler) => throw null;
                public static void AddTypeHandler<T>(ServiceStack.OrmLite.Dapper.SqlMapper.TypeHandler<T> handler) => throw null;
                public static void AddTypeHandlerImpl(System.Type type, ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler handler, bool clone) => throw null;
                public static void AddTypeMap(System.Type type, System.Data.DbType dbType) => throw null;
                public static System.Collections.Generic.List<T> AsList<T>(this System.Collections.Generic.IEnumerable<T> source) => throw null;
                public static ServiceStack.OrmLite.Dapper.SqlMapper.ICustomQueryParameter AsTableValuedParameter(this System.Data.DataTable table, string typeName = default(string)) => throw null;
                public static ServiceStack.OrmLite.Dapper.SqlMapper.ICustomQueryParameter AsTableValuedParameter<T>(this System.Collections.Generic.IEnumerable<T> list, string typeName = default(string)) where T : System.Data.IDataRecord => throw null;
                public static System.Collections.Generic.IEqualityComparer<string> ConnectionStringComparer { get => throw null; set { } }
                public static System.Action<System.Data.IDbCommand, object> CreateParamInfoGenerator(ServiceStack.OrmLite.Dapper.SqlMapper.Identity identity, bool checkForDuplicates, bool removeUnused) => throw null;
                public static int Execute(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static int Execute(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<int> ExecuteAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<int> ExecuteAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
                public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
                public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
                public static object ExecuteScalar(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T ExecuteScalar<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static object ExecuteScalar(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static T ExecuteScalar<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<object> ExecuteScalarAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<T> ExecuteScalarAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> ExecuteScalarAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> ExecuteScalarAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Data.IDbDataParameter FindOrAddParameter(System.Data.IDataParameterCollection parameters, System.Data.IDbCommand command, string name) => throw null;
                public static string Format(object value) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Tuple<string, string, int>> GetCachedSQL(int ignoreHitCountAbove = default(int)) => throw null;
                public static int GetCachedSQLCount() => throw null;
                public static System.Data.DbType GetDbType(object value) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Tuple<int, int>> GetHashCollissions() => throw null;
                public static System.Func<System.Data.IDataReader, object> GetRowParser(this System.Data.IDataReader reader, System.Type type, int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
                public static System.Func<System.Data.IDataReader, T> GetRowParser<T>(this System.Data.IDataReader reader, System.Type concreteType = default(System.Type), int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
                public static System.Func<System.Data.IDataReader, object> GetTypeDeserializer(System.Type type, System.Data.IDataReader reader, int startBound = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
                public static ServiceStack.OrmLite.Dapper.SqlMapper.ITypeMap GetTypeMap(System.Type type) => throw null;
                public static string GetTypeName(this System.Data.DataTable table) => throw null;
                public class GridReader : System.IDisposable
                {
                    public System.Data.IDbCommand Command { get => throw null; set { } }
                    public void Dispose() => throw null;
                    public bool IsConsumed { get => throw null; }
                    public System.Collections.Generic.IEnumerable<dynamic> Read(bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<T> Read<T>(bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<object> Read(System.Type type, bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TReturn>(System.Func<TFirst, TSecond, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TThird, TReturn>(System.Func<TFirst, TSecond, TThird, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TThird, TFourth, TReturn>(System.Func<TFirst, TSecond, TThird, TFourth, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> func, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<TReturn> Read<TReturn>(System.Type[] types, System.Func<object[], TReturn> map, string splitOn = default(string), bool buffered = default(bool)) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<dynamic>> ReadAsync(bool buffered = default(bool)) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<object>> ReadAsync(System.Type type, bool buffered = default(bool)) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> ReadAsync<T>(bool buffered = default(bool)) => throw null;
                    public dynamic ReadFirst() => throw null;
                    public T ReadFirst<T>() => throw null;
                    public object ReadFirst(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<dynamic> ReadFirstAsync() => throw null;
                    public System.Threading.Tasks.Task<object> ReadFirstAsync(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<T> ReadFirstAsync<T>() => throw null;
                    public dynamic ReadFirstOrDefault() => throw null;
                    public T ReadFirstOrDefault<T>() => throw null;
                    public object ReadFirstOrDefault(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<dynamic> ReadFirstOrDefaultAsync() => throw null;
                    public System.Threading.Tasks.Task<object> ReadFirstOrDefaultAsync(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<T> ReadFirstOrDefaultAsync<T>() => throw null;
                    public dynamic ReadSingle() => throw null;
                    public T ReadSingle<T>() => throw null;
                    public object ReadSingle(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<dynamic> ReadSingleAsync() => throw null;
                    public System.Threading.Tasks.Task<object> ReadSingleAsync(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<T> ReadSingleAsync<T>() => throw null;
                    public dynamic ReadSingleOrDefault() => throw null;
                    public T ReadSingleOrDefault<T>() => throw null;
                    public object ReadSingleOrDefault(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<dynamic> ReadSingleOrDefaultAsync() => throw null;
                    public System.Threading.Tasks.Task<object> ReadSingleOrDefaultAsync(System.Type type) => throw null;
                    public System.Threading.Tasks.Task<T> ReadSingleOrDefaultAsync<T>() => throw null;
                }
                public interface ICustomQueryParameter
                {
                    void AddParameter(System.Data.IDbCommand command, string name);
                }
                public class Identity : System.IEquatable<ServiceStack.OrmLite.Dapper.SqlMapper.Identity>
                {
                    public readonly System.Data.CommandType? commandType;
                    public readonly string connectionString;
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(ServiceStack.OrmLite.Dapper.SqlMapper.Identity other) => throw null;
                    public ServiceStack.OrmLite.Dapper.SqlMapper.Identity ForDynamicParameters(System.Type type) => throw null;
                    public override int GetHashCode() => throw null;
                    public readonly int gridIndex;
                    public readonly int hashCode;
                    public readonly System.Type parametersType;
                    public readonly string sql;
                    public override string ToString() => throw null;
                    public readonly System.Type type;
                }
                public interface IDynamicParameters
                {
                    void AddParameters(System.Data.IDbCommand command, ServiceStack.OrmLite.Dapper.SqlMapper.Identity identity);
                }
                public interface IMemberMap
                {
                    string ColumnName { get; }
                    System.Reflection.FieldInfo Field { get; }
                    System.Type MemberType { get; }
                    System.Reflection.ParameterInfo Parameter { get; }
                    System.Reflection.PropertyInfo Property { get; }
                }
                public interface IParameterCallbacks : ServiceStack.OrmLite.Dapper.SqlMapper.IDynamicParameters
                {
                    void OnCompleted();
                }
                public interface IParameterLookup : ServiceStack.OrmLite.Dapper.SqlMapper.IDynamicParameters
                {
                    object this[string name] { get; }
                }
                public interface ITypeHandler
                {
                    object Parse(System.Type destinationType, object value);
                    void SetValue(System.Data.IDbDataParameter parameter, object value);
                }
                public interface ITypeMap
                {
                    System.Reflection.ConstructorInfo FindConstructor(string[] names, System.Type[] types);
                    System.Reflection.ConstructorInfo FindExplicitConstructor();
                    ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName);
                    ServiceStack.OrmLite.Dapper.SqlMapper.IMemberMap GetMember(string columnName);
                }
                public static System.Data.DbType LookupDbType(System.Type type, string name, bool demand, out ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler handler) => throw null;
                public static void PackListParameters(System.Data.IDbCommand command, string namePrefix, object value) => throw null;
                public static System.Collections.Generic.IEnumerable<T> Parse<T>(this System.Data.IDataReader reader) => throw null;
                public static System.Collections.Generic.IEnumerable<object> Parse(this System.Data.IDataReader reader, System.Type type) => throw null;
                public static System.Collections.Generic.IEnumerable<dynamic> Parse(this System.Data.IDataReader reader) => throw null;
                public static void PurgeQueryCache() => throw null;
                public static System.Collections.Generic.IEnumerable<dynamic> Query(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<T> Query<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<object> Query(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<T> Query<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Collections.Generic.IEnumerable<TReturn> Query<TReturn>(this System.Data.IDbConnection cnn, string sql, System.Type[] types, System.Func<object[], TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<dynamic>> QueryAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<dynamic>> QueryAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> QueryAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<object>> QueryAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> QueryAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<object>> QueryAsync(this System.Data.IDbConnection cnn, System.Type type, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, string splitOn = default(string)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TReturn>(this System.Data.IDbConnection cnn, string sql, System.Type[] types, System.Func<object[], TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static event System.EventHandler QueryCachePurged;
                public static dynamic QueryFirst(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QueryFirst<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static object QueryFirst(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QueryFirst<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QueryFirstAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QueryFirstAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QueryFirstAsync(this System.Data.IDbConnection cnn, System.Type type, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QueryFirstAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static dynamic QueryFirstOrDefault(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QueryFirstOrDefault<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static object QueryFirstOrDefault(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QueryFirstOrDefault<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QueryFirstOrDefaultAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QueryFirstOrDefaultAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static ServiceStack.OrmLite.Dapper.SqlMapper.GridReader QueryMultiple(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static ServiceStack.OrmLite.Dapper.SqlMapper.GridReader QueryMultiple(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<ServiceStack.OrmLite.Dapper.SqlMapper.GridReader> QueryMultipleAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<ServiceStack.OrmLite.Dapper.SqlMapper.GridReader> QueryMultipleAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static dynamic QuerySingle(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QuerySingle<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static object QuerySingle(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QuerySingle<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QuerySingleAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QuerySingleAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QuerySingleAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QuerySingleAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QuerySingleAsync(this System.Data.IDbConnection cnn, System.Type type, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QuerySingleAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static dynamic QuerySingleOrDefault(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QuerySingleOrDefault<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static object QuerySingleOrDefault(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static T QuerySingleOrDefault<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QuerySingleOrDefaultAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<dynamic> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
                public static System.Threading.Tasks.Task<object> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static System.Threading.Tasks.Task<T> QuerySingleOrDefaultAsync<T>(this System.Data.IDbConnection cnn, ServiceStack.OrmLite.Dapper.CommandDefinition command) => throw null;
                public static char ReadChar(object value) => throw null;
                public static char? ReadNullableChar(object value) => throw null;
                public static void RemoveTypeMap(System.Type type) => throw null;
                public static void ReplaceLiterals(this ServiceStack.OrmLite.Dapper.SqlMapper.IParameterLookup parameters, System.Data.IDbCommand command) => throw null;
                public static void ResetTypeHandlers() => throw null;
                public static object SanitizeParameterValue(object value) => throw null;
                public static class Settings
                {
                    public static bool ApplyNullValues { get => throw null; set { } }
                    public static int? CommandTimeout { get => throw null; set { } }
                    public static int InListStringSplitCount { get => throw null; set { } }
                    public static bool PadListExpansions { get => throw null; set { } }
                    public static void SetDefaults() => throw null;
                    public static bool UseSingleResultOptimization { get => throw null; set { } }
                    public static bool UseSingleRowOptimization { get => throw null; set { } }
                }
                public static void SetTypeMap(System.Type type, ServiceStack.OrmLite.Dapper.SqlMapper.ITypeMap map) => throw null;
                public static void SetTypeName(this System.Data.DataTable table, string typeName) => throw null;
                public abstract class StringTypeHandler<T> : ServiceStack.OrmLite.Dapper.SqlMapper.TypeHandler<T>
                {
                    protected StringTypeHandler() => throw null;
                    protected abstract string Format(T xml);
                    protected abstract T Parse(string xml);
                    public override T Parse(object value) => throw null;
                    public override void SetValue(System.Data.IDbDataParameter parameter, T value) => throw null;
                }
                public static void ThrowDataException(System.Exception ex, int index, System.Data.IDataReader reader, object value) => throw null;
                public abstract class TypeHandler<T> : ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler
                {
                    protected TypeHandler() => throw null;
                    public abstract T Parse(object value);
                    object ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler.Parse(System.Type destinationType, object value) => throw null;
                    public abstract void SetValue(System.Data.IDbDataParameter parameter, T value);
                    void ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler.SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
                }
                public static class TypeHandlerCache<T>
                {
                    public static T Parse(object value) => throw null;
                    public static void SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
                }
                public static System.Func<System.Type, ServiceStack.OrmLite.Dapper.SqlMapper.ITypeMap> TypeMapProvider;
                public class UdtTypeHandler : ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler
                {
                    public UdtTypeHandler(string udtTypeName) => throw null;
                    object ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler.Parse(System.Type destinationType, object value) => throw null;
                    void ServiceStack.OrmLite.Dapper.SqlMapper.ITypeHandler.SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
                }
            }
        }
        public static partial class DbDataParameterExtensions
        {
            public static System.Data.IDbDataParameter AddParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDbCommand dbCmd, object value, ServiceStack.OrmLite.FieldDefinition fieldDef, System.Action<System.Data.IDbDataParameter> paramFilter) => throw null;
            public static System.Data.IDbDataParameter AddQueryParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDbCommand dbCmd, object value, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static System.Data.IDbDataParameter AddUpdateParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDbCommand dbCmd, object value, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static System.Data.IDbDataParameter CreateParam(this System.Data.IDbConnection db, string name, object value = default(object), System.Type fieldType = default(System.Type), System.Data.DbType? dbType = default(System.Data.DbType?), byte? precision = default(byte?), byte? scale = default(byte?), int? size = default(int?)) => throw null;
            public static System.Data.IDbDataParameter CreateParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, string name, object value = default(object), System.Type fieldType = default(System.Type), System.Data.DbType? dbType = default(System.Data.DbType?), byte? precision = default(byte?), byte? scale = default(byte?), int? size = default(int?)) => throw null;
            public static string GetInsertParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDbCommand dbCmd, object value, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string GetUpdateParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDbCommand dbCmd, object value, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
        }
        public class DbScripts : ServiceStack.Script.ScriptMethods
        {
            public DbScripts() => throw null;
            public string[] dbColumnNames(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public string[] dbColumnNames(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbColumns(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbColumns(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public long dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public long dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public long dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbDesc(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbDesc(ServiceStack.Script.ScriptScopeContext scope, string sql, object options) => throw null;
            public int dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public int dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public int dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public bool dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public bool dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public bool dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public ServiceStack.Data.IDbConnectionFactory DbFactory { get => throw null; set { } }
            public System.Collections.Generic.List<string> dbNamedConnections() => throw null;
            public object dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public object dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public object dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Collections.Generic.List<string> dbTableNames(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<string> dbTableNames(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Collections.Generic.List<string> dbTableNames(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public bool isUnsafeSql(string sql) => throw null;
            public bool isUnsafeSqlFragment(string sql) => throw null;
            public System.Data.IDbConnection OpenDbConnection(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public string ormliteVar(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string sqlBool(ServiceStack.Script.ScriptScopeContext scope, bool value) => throw null;
            public string sqlCast(ServiceStack.Script.ScriptScopeContext scope, object fieldOrValue, string castAs) => throw null;
            public string sqlConcat(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> values) => throw null;
            public string sqlCurrency(ServiceStack.Script.ScriptScopeContext scope, string fieldOrValue) => throw null;
            public string sqlCurrency(ServiceStack.Script.ScriptScopeContext scope, string fieldOrValue, string symbol) => throw null;
            public string sqlFalse(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string sqlLimit(ServiceStack.Script.ScriptScopeContext scope, int? offset, int? limit) => throw null;
            public string sqlLimit(ServiceStack.Script.ScriptScopeContext scope, int? limit) => throw null;
            public string sqlOrderByFields(ServiceStack.Script.ScriptScopeContext scope, string orderBy) => throw null;
            public string sqlQuote(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string sqlSkip(ServiceStack.Script.ScriptScopeContext scope, int? offset) => throw null;
            public string sqlTake(ServiceStack.Script.ScriptScopeContext scope, int? limit) => throw null;
            public string sqlTrue(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string sqlVerifyFragment(string sql) => throw null;
            public ServiceStack.Script.IgnoreResult useDb(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> dbConnOptions) => throw null;
        }
        public class DbScriptsAsync : ServiceStack.Script.ScriptMethods
        {
            public DbScriptsAsync() => throw null;
            public System.Threading.Tasks.Task<object> dbColumnNames(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public System.Threading.Tasks.Task<object> dbColumnNames(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public string[] dbColumnNamesSync(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public string[] dbColumnNamesSync(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbColumns(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public System.Threading.Tasks.Task<object> dbColumns(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbColumnsSync(ServiceStack.Script.ScriptScopeContext scope, string tableName) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbColumnsSync(ServiceStack.Script.ScriptScopeContext scope, string tableName, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbCount(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public long dbCountSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public long dbCountSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public long dbCountSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbDesc(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbDesc(ServiceStack.Script.ScriptScopeContext scope, string sql, object options) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbDescSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public ServiceStack.OrmLite.ColumnSchema[] dbDescSync(ServiceStack.Script.ScriptScopeContext scope, string sql, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbExec(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public int dbExecSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public int dbExecSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public int dbExecSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbExists(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public bool dbExistsSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public bool dbExistsSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public bool dbExistsSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public ServiceStack.Data.IDbConnectionFactory DbFactory { get => throw null; set { } }
            public System.Collections.Generic.List<string> dbNamedConnections() => throw null;
            public System.Threading.Tasks.Task<object> dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbScalar(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public object dbScalarSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbScalarSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbScalarSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbSelect(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public object dbSelectSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbSelectSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbSelectSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public System.Threading.Tasks.Task<object> dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbSingle(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public object dbSingleSync(ServiceStack.Script.ScriptScopeContext scope, string sql) => throw null;
            public object dbSingleSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public object dbSingleSync(ServiceStack.Script.ScriptScopeContext scope, string sql, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNames(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNames(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNames(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Collections.Generic.List<string> dbTableNamesSync(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<string> dbTableNamesSync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Collections.Generic.List<string> dbTableNamesSync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Threading.Tasks.Task<object> dbTableNamesWithRowCounts(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCountsSync(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCountsSync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> dbTableNamesWithRowCountsSync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> args, object options) => throw null;
            public bool isUnsafeSql(string sql) => throw null;
            public bool isUnsafeSqlFragment(string sql) => throw null;
            public System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> options) => throw null;
            public string ormliteVar(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string sqlBool(ServiceStack.Script.ScriptScopeContext scope, bool value) => throw null;
            public string sqlCast(ServiceStack.Script.ScriptScopeContext scope, object fieldOrValue, string castAs) => throw null;
            public string sqlConcat(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.IEnumerable<object> values) => throw null;
            public string sqlCurrency(ServiceStack.Script.ScriptScopeContext scope, string fieldOrValue) => throw null;
            public string sqlCurrency(ServiceStack.Script.ScriptScopeContext scope, string fieldOrValue, string symbol) => throw null;
            public string sqlFalse(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string sqlLimit(ServiceStack.Script.ScriptScopeContext scope, int? offset, int? limit) => throw null;
            public string sqlLimit(ServiceStack.Script.ScriptScopeContext scope, int? limit) => throw null;
            public string sqlOrderByFields(ServiceStack.Script.ScriptScopeContext scope, string orderBy) => throw null;
            public string sqlQuote(ServiceStack.Script.ScriptScopeContext scope, string name) => throw null;
            public string sqlSkip(ServiceStack.Script.ScriptScopeContext scope, int? offset) => throw null;
            public string sqlTake(ServiceStack.Script.ScriptScopeContext scope, int? limit) => throw null;
            public string sqlTrue(ServiceStack.Script.ScriptScopeContext scope) => throw null;
            public string sqlVerifyFragment(string sql) => throw null;
            public ServiceStack.Script.IgnoreResult useDb(ServiceStack.Script.ScriptScopeContext scope, System.Collections.Generic.Dictionary<string, object> dbConnOptions) => throw null;
        }
        public class DbTypes<TDialect> where TDialect : ServiceStack.OrmLite.IOrmLiteDialectProvider
        {
            public System.Collections.Generic.Dictionary<System.Type, System.Data.DbType> ColumnDbTypeMap;
            public System.Collections.Generic.Dictionary<System.Type, string> ColumnTypeMap;
            public DbTypes() => throw null;
            public System.Data.DbType DbType;
            public void Set<T>(System.Data.DbType dbType, string fieldDefinition) => throw null;
            public bool ShouldQuoteValue;
            public string TextDefinition;
        }
        public struct DictionaryRow : ServiceStack.OrmLite.IDynamicRow<System.Collections.Generic.Dictionary<string, object>>, ServiceStack.OrmLite.IDynamicRow
        {
            public DictionaryRow(System.Type type, System.Collections.Generic.Dictionary<string, object> fields) => throw null;
            public System.Collections.Generic.Dictionary<string, object> Fields { get => throw null; }
            public System.Type Type { get => throw null; }
        }
        public static class DynamicRowUtils
        {
        }
        public class EnumMemberAccess : ServiceStack.OrmLite.PartialSqlString
        {
            public EnumMemberAccess(string text, System.Type enumType) : base(default(string)) => throw null;
            public System.Type EnumType { get => throw null; }
        }
        public class FieldDefinition
        {
            public string Alias { get => throw null; set { } }
            public bool AutoId { get => throw null; set { } }
            public bool AutoIncrement { get => throw null; set { } }
            public string BelongToModelName { get => throw null; set { } }
            public string CheckConstraint { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition Clone(System.Action<ServiceStack.OrmLite.FieldDefinition> modifier = default(System.Action<ServiceStack.OrmLite.FieldDefinition>)) => throw null;
            public System.Type ColumnType { get => throw null; }
            public string ComputeExpression { get => throw null; set { } }
            public FieldDefinition() => throw null;
            public string CustomFieldDefinition { get => throw null; set { } }
            public string CustomInsert { get => throw null; set { } }
            public string CustomSelect { get => throw null; set { } }
            public string CustomUpdate { get => throw null; set { } }
            public string DefaultValue { get => throw null; set { } }
            public int? FieldLength { get => throw null; set { } }
            public string FieldName { get => throw null; }
            public ServiceStack.OrmLite.FieldReference FieldReference { get => throw null; set { } }
            public System.Type FieldType { get => throw null; set { } }
            public object FieldTypeDefaultValue { get => throw null; set { } }
            public ServiceStack.OrmLite.ForeignKeyConstraint ForeignKey { get => throw null; set { } }
            public string GetQuotedName(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public string GetQuotedValue(object fromInstance, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public object GetValue(object instance) => throw null;
            public ServiceStack.GetMemberDelegate GetValueFn { get => throw null; set { } }
            public bool IgnoreOnInsert { get => throw null; set { } }
            public bool IgnoreOnUpdate { get => throw null; set { } }
            public string IndexName { get => throw null; set { } }
            public bool IsClustered { get => throw null; set { } }
            public bool IsComputed { get => throw null; set { } }
            public bool IsIndexed { get => throw null; set { } }
            public bool IsNonClustered { get => throw null; set { } }
            public bool IsNullable { get => throw null; set { } }
            public bool IsPersisted { get => throw null; set { } }
            public bool IsPrimaryKey { get => throw null; set { } }
            public bool IsReference { get => throw null; set { } }
            public bool IsRefType { get => throw null; set { } }
            public bool IsRowVersion { get => throw null; set { } }
            public bool IsSelfRefField(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public bool IsSelfRefField(string name) => throw null;
            public bool IsUniqueConstraint { get => throw null; set { } }
            public bool IsUniqueIndex { get => throw null; set { } }
            public ServiceStack.OrmLite.ModelDefinition ModelDef { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public int Order { get => throw null; set { } }
            public System.Reflection.PropertyInfo PropertyInfo { get => throw null; set { } }
            public bool RequiresAlias { get => throw null; }
            public bool ReturnOnInsert { get => throw null; set { } }
            public int? Scale { get => throw null; set { } }
            public string Sequence { get => throw null; set { } }
            public void SetValue(object instance, object value) => throw null;
            public ServiceStack.SetMemberDelegate SetValueFn { get => throw null; set { } }
            public bool ShouldSkipDelete() => throw null;
            public bool ShouldSkipInsert() => throw null;
            public bool ShouldSkipUpdate() => throw null;
            public override string ToString() => throw null;
            public System.Type TreatAsType { get => throw null; set { } }
        }
        public class FieldReference
        {
            public FieldReference(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public ServiceStack.OrmLite.FieldDefinition FieldDef { get => throw null; }
            public string RefField { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition RefFieldDef { get => throw null; }
            public string RefId { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition RefIdFieldDef { get => throw null; }
            public System.Type RefModel { get => throw null; set { } }
            public ServiceStack.OrmLite.ModelDefinition RefModelDef { get => throw null; }
        }
        public class ForeignKeyConstraint
        {
            public ForeignKeyConstraint(System.Type type, string onDelete = default(string), string onUpdate = default(string), string foreignKeyName = default(string)) => throw null;
            public string ForeignKeyName { get => throw null; }
            public string GetForeignKeyName(ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.ModelDefinition refModelDef, ServiceStack.OrmLite.INamingStrategy namingStrategy, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public string OnDelete { get => throw null; }
            public string OnUpdate { get => throw null; }
            public System.Type ReferenceType { get => throw null; }
        }
        public delegate object GetValueDelegate(int i);
        public interface IDynamicRow
        {
            System.Type Type { get; }
        }
        public interface IDynamicRow<T> : ServiceStack.OrmLite.IDynamicRow
        {
            T Fields { get; }
        }
        public interface IHasColumnDefinitionLength
        {
            string GetColumnDefinition(int? length);
        }
        public interface IHasColumnDefinitionPrecision
        {
            string GetColumnDefinition(int? precision, int? scale);
        }
        public interface IHasDialectProvider
        {
            ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get; }
        }
        public interface IHasUntypedSqlExpression
        {
            ServiceStack.OrmLite.IUntypedSqlExpression GetUntyped();
        }
        public interface INamingStrategy
        {
            string ApplyNameRestrictions(string name);
            string GetColumnName(string name);
            string GetSchemaName(string name);
            string GetSchemaName(ServiceStack.OrmLite.ModelDefinition modelDef);
            string GetSequenceName(string modelName, string fieldName);
            string GetTableName(string name);
            string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef);
        }
        public class IndexFieldsCacheKey
        {
            public IndexFieldsCacheKey(string[] fields, ServiceStack.OrmLite.ModelDefinition modelDefinition, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public ServiceStack.OrmLite.IOrmLiteDialectProvider Dialect { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public string[] Fields { get => throw null; }
            public override int GetHashCode() => throw null;
            public ServiceStack.OrmLite.ModelDefinition ModelDefinition { get => throw null; }
        }
        public interface IOrmLiteConverter
        {
            string ColumnDefinition { get; }
            System.Data.DbType DbType { get; }
            ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get; set; }
            object FromDbValue(System.Type fieldType, object value);
            object GetValue(System.Data.IDataReader reader, int columnIndex, object[] values);
            void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType);
            object ToDbValue(System.Type fieldType, object value);
            string ToQuotedString(System.Type fieldType, object value);
        }
        public interface IOrmLiteDialectProvider
        {
            void BulkInsert<T>(System.Data.IDbConnection db, System.Collections.Generic.IEnumerable<T> objs, ServiceStack.OrmLite.BulkInsertConfig config = default(ServiceStack.OrmLite.BulkInsertConfig));
            System.Data.IDbConnection CreateConnection(string filePath, System.Collections.Generic.Dictionary<string, string> options);
            System.Data.IDbDataParameter CreateParam();
            System.Data.IDbCommand CreateParameterizedDeleteStatement(System.Data.IDbConnection connection, object objWithProperties);
            void DisableForeignKeysCheck(System.Data.IDbCommand cmd);
            System.Threading.Tasks.Task DisableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void DisableIdentityInsert<T>(System.Data.IDbCommand cmd);
            System.Threading.Tasks.Task DisableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            bool DoesColumnExist(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string));
            System.Threading.Tasks.Task<bool> DoesColumnExistAsync(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            bool DoesSchemaExist(System.Data.IDbCommand dbCmd, string schema);
            System.Threading.Tasks.Task<bool> DoesSchemaExistAsync(System.Data.IDbCommand dbCmd, string schema, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            bool DoesSequenceExist(System.Data.IDbCommand dbCmd, string sequence);
            System.Threading.Tasks.Task<bool> DoesSequenceExistAsync(System.Data.IDbCommand dbCmd, string sequenceName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            bool DoesTableExist(System.Data.IDbConnection db, string tableName, string schema = default(string));
            bool DoesTableExist(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string));
            System.Threading.Tasks.Task<bool> DoesTableExistAsync(System.Data.IDbConnection db, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> DoesTableExistAsync(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void EnableForeignKeysCheck(System.Data.IDbCommand cmd);
            System.Threading.Tasks.Task EnableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void EnableIdentityInsert<T>(System.Data.IDbCommand cmd);
            System.Threading.Tasks.Task EnableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string EscapeWildcards(string value);
            ServiceStack.OrmLite.IOrmLiteExecFilter ExecFilter { get; set; }
            System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            object FromDbRowVersion(System.Type fieldType, object value);
            object FromDbValue(object value, System.Type type);
            string GenerateComment(in string text);
            string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef);
            string GetColumnNames(ServiceStack.OrmLite.ModelDefinition modelDef);
            ServiceStack.OrmLite.SelectItem[] GetColumnNames(ServiceStack.OrmLite.ModelDefinition modelDef, string tablePrefix);
            ServiceStack.OrmLite.IOrmLiteConverter GetConverter(System.Type type);
            ServiceStack.OrmLite.IOrmLiteConverter GetConverterBestMatch(System.Type type);
            ServiceStack.OrmLite.IOrmLiteConverter GetConverterBestMatch(ServiceStack.OrmLite.FieldDefinition fieldDef);
            string GetDefaultValue(System.Type tableType, string fieldName);
            string GetDefaultValue(ServiceStack.OrmLite.FieldDefinition fieldDef);
            string GetDropForeignKeyConstraints(ServiceStack.OrmLite.ModelDefinition modelDef);
            System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.FieldDefinition> GetFieldDefinitionMap(ServiceStack.OrmLite.ModelDefinition modelDef);
            string GetFieldReferenceSql(string subSql, ServiceStack.OrmLite.FieldDefinition fieldDef, ServiceStack.OrmLite.FieldReference fieldRef);
            object GetFieldValue(ServiceStack.OrmLite.FieldDefinition fieldDef, object value);
            object GetFieldValue(System.Type fieldType, object value);
            long GetLastInsertId(System.Data.IDbCommand command);
            string GetLastInsertIdSqlSuffix<T>();
            string GetLoadChildrenSubSelect<From>(ServiceStack.OrmLite.SqlExpression<From> expr);
            object GetParamValue(object value, System.Type fieldType);
            string GetQuotedColumnName(string columnName);
            string GetQuotedName(string name);
            string GetQuotedName(string name, string schema);
            string GetQuotedTableName(System.Type modelType);
            string GetQuotedTableName(ServiceStack.OrmLite.ModelDefinition modelDef);
            string GetQuotedTableName(string tableName, string schema = default(string));
            string GetQuotedTableName(string tableName, string schema, bool useStrategy);
            string GetQuotedValue(string paramValue);
            string GetQuotedValue(object value, System.Type fieldType);
            string GetRefFieldSql(string subSql, ServiceStack.OrmLite.ModelDefinition refModelDef, ServiceStack.OrmLite.FieldDefinition refField);
            string GetRefSelfSql<From>(ServiceStack.OrmLite.SqlExpression<From> refQ, ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.FieldDefinition refSelf, ServiceStack.OrmLite.ModelDefinition refModelDef);
            string GetRowVersionColumn(ServiceStack.OrmLite.FieldDefinition field, string tablePrefix = default(string));
            ServiceStack.OrmLite.SelectItem GetRowVersionSelectColumn(ServiceStack.OrmLite.FieldDefinition field, string tablePrefix = default(string));
            System.Collections.Generic.List<string> GetSchemas(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> GetSchemaTables(System.Data.IDbCommand dbCmd);
            string GetTableName(System.Type modelType);
            string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef);
            string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef, bool useStrategy);
            string GetTableName(string table, string schema = default(string));
            string GetTableName(string table, string schema, bool useStrategy);
            object GetValue(System.Data.IDataReader reader, int columnIndex, System.Type type);
            int GetValues(System.Data.IDataReader reader, object[] values);
            bool HasInsertReturnValues(ServiceStack.OrmLite.ModelDefinition modelDef);
            void Init(string connectionString);
            void InitConnection(System.Data.IDbConnection dbConn);
            void InitQueryParam(System.Data.IDbDataParameter param);
            void InitUpdateParam(System.Data.IDbDataParameter param);
            System.Threading.Tasks.Task<long> InsertAndGetLastInsertIdAsync<T>(System.Data.IDbCommand dbCmd, System.Threading.CancellationToken token);
            string MergeParamsIntoSql(string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> dbParams);
            ServiceStack.OrmLite.INamingStrategy NamingStrategy { get; set; }
            System.Action<System.Data.IDbConnection> OnOpenConnection { get; set; }
            System.Threading.Tasks.Task OpenAsync(System.Data.IDbConnection db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Func<string, string> ParamNameFilter { get; set; }
            string ParamString { get; set; }
            void PrepareInsertRowStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args);
            bool PrepareParameterizedDeleteStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.IDictionary<string, object> deleteFieldValues);
            void PrepareParameterizedInsertStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>), System.Func<ServiceStack.OrmLite.FieldDefinition, bool> shouldInclude = default(System.Func<ServiceStack.OrmLite.FieldDefinition, bool>));
            bool PrepareParameterizedUpdateStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>));
            void PrepareStoredProcedureStatement<T>(System.Data.IDbCommand cmd, T obj);
            void PrepareUpdateRowAddStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args, string sqlFilter);
            void PrepareUpdateRowStatement(System.Data.IDbCommand dbCmd, object objWithProperties, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>));
            void PrepareUpdateRowStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args, string sqlFilter);
            System.Threading.Tasks.Task<bool> ReadAsync(System.Data.IDataReader reader, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ReaderEach<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<Return> ReaderEach<Return>(System.Data.IDataReader reader, System.Action fn, Return source, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> ReaderRead<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void RegisterConverter<T>(ServiceStack.OrmLite.IOrmLiteConverter converter);
            string SanitizeFieldNameForParamName(string fieldName);
            System.Collections.Generic.List<string> SequenceList(System.Type tableType);
            System.Threading.Tasks.Task<System.Collections.Generic.List<string>> SequenceListAsync(System.Type tableType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void SetParameter(ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDbDataParameter p);
            void SetParameterValues<T>(System.Data.IDbCommand dbCmd, object obj);
            string SqlBool(bool value);
            string SqlCast(object fieldOrValue, string castAs);
            string SqlConcat(System.Collections.Generic.IEnumerable<object> args);
            string SqlConflict(string sql, string conflictResolution);
            string SqlCurrency(string fieldOrValue);
            string SqlCurrency(string fieldOrValue, string currencySymbol);
            ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>();
            string SqlLimit(int? offset = default(int?), int? rows = default(int?));
            string SqlRandom { get; }
            ServiceStack.Text.IStringSerializer StringSerializer { get; set; }
            bool SupportsSchema { get; }
            string ToAddColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef);
            string ToAddForeignKeyStatement<T, TForeign>(System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Linq.Expressions.Expression<System.Func<TForeign, object>> foreignField, ServiceStack.OrmLite.OnFkOption onUpdate, ServiceStack.OrmLite.OnFkOption onDelete, string foreignKeyName = default(string));
            string ToAlterColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef);
            string ToChangeColumnNameStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumn);
            string ToCreateIndexStatement<T>(System.Linq.Expressions.Expression<System.Func<T, object>> field, string indexName = default(string), bool unique = default(bool));
            System.Collections.Generic.List<string> ToCreateIndexStatements(System.Type tableType);
            string ToCreateSavePoint(string name);
            string ToCreateSchemaStatement(string schema);
            string ToCreateSequenceStatement(System.Type tableType, string sequenceName);
            System.Collections.Generic.List<string> ToCreateSequenceStatements(System.Type tableType);
            string ToCreateTableStatement(System.Type tableType);
            object ToDbValue(object value, System.Type type);
            string ToDeleteStatement(System.Type tableType, string sqlFilter, params object[] filterParams);
            string ToDropColumnStatement(string schema, string table, string column);
            string ToDropForeignKeyStatement(string schema, string table, string foreignKeyName);
            string ToExecuteProcedureStatement(object objWithProperties);
            string ToExistStatement(System.Type fromTableType, object objWithProperties, string sqlFilter, params object[] filterParams);
            string ToInsertRowSql<T>(T obj, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>));
            string ToInsertRowsSql<T>(System.Collections.Generic.IEnumerable<T> objs, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>));
            string ToInsertRowStatement(System.Data.IDbCommand cmd, object objWithProperties, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>));
            string ToInsertStatement<T>(System.Data.IDbCommand dbCmd, T item, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>));
            string ToPostCreateTableStatement(ServiceStack.OrmLite.ModelDefinition modelDef);
            string ToPostDropTableStatement(ServiceStack.OrmLite.ModelDefinition modelDef);
            string ToReleaseSavePoint(string name);
            string ToRenameColumnStatement(string schema, string table, string oldColumn, string newColumn);
            string ToRollbackSavePoint(string name);
            string ToRowCountStatement(string innerSql);
            string ToSelectFromProcedureStatement(object fromObjWithProperties, System.Type outputModelType, string sqlFilter, params object[] filterParams);
            string ToSelectStatement(System.Type tableType, string sqlFilter, params object[] filterParams);
            string ToSelectStatement(ServiceStack.OrmLite.QueryType queryType, ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?), System.Collections.Generic.ISet<string> tags = default(System.Collections.Generic.ISet<string>));
            string ToTableNamesStatement(string schema);
            string ToTableNamesWithRowCountsStatement(bool live, string schema);
            string ToUpdateStatement<T>(System.Data.IDbCommand dbCmd, T item, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>));
            System.Collections.Generic.Dictionary<string, string> Variables { get; }
        }
        public interface IOrmLiteExecFilter
        {
            System.Data.IDbCommand CreateCommand(System.Data.IDbConnection dbConn);
            void DisposeCommand(System.Data.IDbCommand dbCmd, System.Data.IDbConnection dbConn);
            T Exec<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, T> filter);
            System.Data.IDbCommand Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Data.IDbCommand> filter);
            System.Threading.Tasks.Task<T> Exec<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<T>> filter);
            System.Threading.Tasks.Task<System.Data.IDbCommand> Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<System.Data.IDbCommand>> filter);
            void Exec(System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> filter);
            System.Threading.Tasks.Task Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task> filter);
            System.Collections.Generic.IEnumerable<T> ExecLazy<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Collections.Generic.IEnumerable<T>> filter);
            ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>(System.Data.IDbConnection dbConn);
        }
        public interface IOrmLiteResultsFilter
        {
            int ExecuteSql(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.List<T> GetColumn<T>(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.HashSet<T> GetColumnDistinct<T>(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.Dictionary<K, V> GetDictionary<K, V>(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>> GetKeyValuePairs<K, V>(System.Data.IDbCommand dbCmd);
            long GetLastInsertId(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.List<T> GetList<T>(System.Data.IDbCommand dbCmd);
            long GetLongScalar(System.Data.IDbCommand dbCmd);
            System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> GetLookup<K, V>(System.Data.IDbCommand dbCmd);
            System.Collections.IList GetRefList(System.Data.IDbCommand dbCmd, System.Type refType);
            object GetRefSingle(System.Data.IDbCommand dbCmd, System.Type refType);
            T GetScalar<T>(System.Data.IDbCommand dbCmd);
            object GetScalar(System.Data.IDbCommand dbCmd);
            T GetSingle<T>(System.Data.IDbCommand dbCmd);
        }
        public interface IPropertyInvoker
        {
            System.Func<object, System.Type, object> ConvertValueFn { get; set; }
            object GetPropertyValue(System.Reflection.PropertyInfo propertyInfo, object fromInstance);
            void SetPropertyValue(System.Reflection.PropertyInfo propertyInfo, System.Type fieldType, object onInstance, object withValue);
        }
        public interface ISqlExpression
        {
            System.Collections.Generic.List<System.Data.IDbDataParameter> Params { get; }
            string SelectInto<TModel>();
            string SelectInto<TModel>(ServiceStack.OrmLite.QueryType forType);
            string ToSelectStatement();
            string ToSelectStatement(ServiceStack.OrmLite.QueryType forType);
        }
        public interface IUntypedApi
        {
            System.Collections.IEnumerable Cast(System.Collections.IEnumerable results);
            System.Data.IDbConnection Db { get; set; }
            System.Data.IDbCommand DbCmd { get; set; }
            int Delete(object obj, object anonType);
            int DeleteAll();
            int DeleteById(object id);
            int DeleteByIds(System.Collections.IEnumerable idValues);
            int DeleteNonDefaults(object obj, object filter);
            long Insert(object obj, bool selectIdentity = default(bool));
            long Insert(object obj, System.Action<System.Data.IDbCommand> commandFilter, bool selectIdentity = default(bool));
            void InsertAll(System.Collections.IEnumerable objs);
            void InsertAll(System.Collections.IEnumerable objs, System.Action<System.Data.IDbCommand> commandFilter);
            bool Save(object obj);
            int SaveAll(System.Collections.IEnumerable objs);
            System.Threading.Tasks.Task<int> SaveAllAsync(System.Collections.IEnumerable objs, System.Threading.CancellationToken token);
            System.Threading.Tasks.Task<bool> SaveAsync(object obj, System.Threading.CancellationToken token);
            int Update(object obj);
            int UpdateAll(System.Collections.IEnumerable objs);
            int UpdateAll(System.Collections.IEnumerable objs, System.Action<System.Data.IDbCommand> commandFilter);
            System.Threading.Tasks.Task<int> UpdateAsync(object obj, System.Threading.CancellationToken token);
        }
        public interface IUntypedSqlExpression : ServiceStack.OrmLite.ISqlExpression
        {
            ServiceStack.OrmLite.IUntypedSqlExpression AddCondition(string condition, string sqlFilter, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression And(string sqlFilter, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression And<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate);
            ServiceStack.OrmLite.IUntypedSqlExpression And<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate);
            string BodyExpression { get; }
            ServiceStack.OrmLite.IUntypedSqlExpression ClearLimits();
            ServiceStack.OrmLite.IUntypedSqlExpression Clone();
            System.Data.IDbDataParameter CreateParam(string name, object value = default(object), System.Data.ParameterDirection direction = default(System.Data.ParameterDirection), System.Data.DbType? dbType = default(System.Data.DbType?));
            ServiceStack.OrmLite.IUntypedSqlExpression CrossJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>));
            ServiceStack.OrmLite.IUntypedSqlExpression CustomJoin(string joinString);
            ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Ensure(string sqlFilter, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression Ensure<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate);
            ServiceStack.OrmLite.IUntypedSqlExpression Ensure<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate);
            System.Tuple<ServiceStack.OrmLite.ModelDefinition, ServiceStack.OrmLite.FieldDefinition> FirstMatchingField(string fieldName);
            ServiceStack.OrmLite.IUntypedSqlExpression From(string tables);
            string FromExpression { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression FullJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>));
            System.Collections.Generic.IList<string> GetAllFields();
            ServiceStack.OrmLite.ModelDefinition GetModelDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef);
            ServiceStack.OrmLite.IUntypedSqlExpression GroupBy();
            ServiceStack.OrmLite.IUntypedSqlExpression GroupBy(string groupBy);
            string GroupByExpression { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Having();
            ServiceStack.OrmLite.IUntypedSqlExpression Having(string sqlFilter, params object[] filterParams);
            string HavingExpression { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Insert(System.Collections.Generic.List<string> insertFields);
            ServiceStack.OrmLite.IUntypedSqlExpression Insert();
            System.Collections.Generic.List<string> InsertFields { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Join<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>));
            ServiceStack.OrmLite.IUntypedSqlExpression Join(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression));
            ServiceStack.OrmLite.IUntypedSqlExpression LeftJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>));
            ServiceStack.OrmLite.IUntypedSqlExpression LeftJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression));
            ServiceStack.OrmLite.IUntypedSqlExpression Limit(int skip, int rows);
            ServiceStack.OrmLite.IUntypedSqlExpression Limit(int? skip, int? rows);
            ServiceStack.OrmLite.IUntypedSqlExpression Limit(int rows);
            ServiceStack.OrmLite.IUntypedSqlExpression Limit();
            ServiceStack.OrmLite.ModelDefinition ModelDef { get; }
            int? Offset { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Or(string sqlFilter, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression Or<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate);
            ServiceStack.OrmLite.IUntypedSqlExpression Or<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderBy();
            ServiceStack.OrmLite.IUntypedSqlExpression OrderBy(string orderBy);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByDescending(string orderBy);
            string OrderByExpression { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByFields(params ServiceStack.OrmLite.FieldDefinition[] fields);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByFields(params string[] fieldNames);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByFieldsDescending(params ServiceStack.OrmLite.FieldDefinition[] fields);
            ServiceStack.OrmLite.IUntypedSqlExpression OrderByFieldsDescending(params string[] fieldNames);
            bool PrefixFieldWithTableName { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression RightJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>));
            int? Rows { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Select();
            ServiceStack.OrmLite.IUntypedSqlExpression Select(string selectExpression);
            ServiceStack.OrmLite.IUntypedSqlExpression Select<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields);
            ServiceStack.OrmLite.IUntypedSqlExpression Select<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields);
            ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields);
            ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields);
            ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct();
            string SelectExpression { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Skip(int? skip = default(int?));
            string SqlColumn(string columnName);
            string SqlTable(ServiceStack.OrmLite.ModelDefinition modelDef);
            string TableAlias { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Take(int? take = default(int?));
            ServiceStack.OrmLite.IUntypedSqlExpression ThenBy(string orderBy);
            ServiceStack.OrmLite.IUntypedSqlExpression ThenBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector);
            ServiceStack.OrmLite.IUntypedSqlExpression ThenByDescending(string orderBy);
            ServiceStack.OrmLite.IUntypedSqlExpression ThenByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector);
            string ToCountStatement();
            string ToDeleteRowStatement();
            ServiceStack.OrmLite.IUntypedSqlExpression UnsafeAnd(string rawSql, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression UnsafeFrom(string rawFrom);
            ServiceStack.OrmLite.IUntypedSqlExpression UnsafeOr(string rawSql, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression UnsafeSelect(string rawSelect);
            ServiceStack.OrmLite.IUntypedSqlExpression UnsafeWhere(string rawSql, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression Update(System.Collections.Generic.List<string> updateFields);
            ServiceStack.OrmLite.IUntypedSqlExpression Update();
            System.Collections.Generic.List<string> UpdateFields { get; set; }
            ServiceStack.OrmLite.IUntypedSqlExpression Where();
            ServiceStack.OrmLite.IUntypedSqlExpression Where(string sqlFilter, params object[] filterParams);
            ServiceStack.OrmLite.IUntypedSqlExpression Where<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate);
            ServiceStack.OrmLite.IUntypedSqlExpression Where<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate);
            string WhereExpression { get; set; }
            bool WhereStatementWithoutWhereString { get; set; }
        }
        public delegate string JoinFormatDelegate(ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.ModelDefinition tableDef, string joinExpr);
        namespace Legacy
        {
            public static class OrmLiteReadApiAsyncLegacy
            {
                public static System.Threading.Tasks.Task<System.Collections.Generic.HashSet<T>> ColumnDistinctFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.HashSet<T>> ColumnDistinctFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ColumnFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ColumnFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, V>> DictionaryFmtAsync<K, V>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, V>> DictionaryFmtAsync<K, V>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<bool> ExistsAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<bool> ExistsFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<bool> ExistsFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>>> LookupFmtAsync<K, V>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>>> LookupFmtAsync<K, V>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<T> ScalarFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<T> ScalarFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<TModel>> SelectFmtAsync<TModel>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, System.Type fromTableType, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<TModel>> SelectFmtAsync<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<TOutputModel>> SqlProcedureFmtAsync<TOutputModel>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, object anonType, string sqlFilter, params object[] filterParams) where TOutputModel : new() => throw null;
            }
            public static class OrmLiteReadApiLegacy
            {
                public static System.Collections.Generic.HashSet<T> ColumnDistinctFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Collections.Generic.List<T> ColumnFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Collections.Generic.Dictionary<K, V> DictionaryFmt<K, V>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static bool Exists<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression) => throw null;
                public static bool ExistsFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> LookupFmt<K, V>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static T ScalarFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] sqlParams) => throw null;
                public static System.Collections.Generic.List<T> SelectFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Collections.Generic.List<TModel> SelectFmt<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Collections.Generic.IEnumerable<T> SelectLazyFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
                public static T SingleFmt<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
            }
            public static class OrmLiteReadExpressionsApiAsyncLegacy
            {
                public static System.Threading.Tasks.Task<long> CountAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> LoadSelectAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<Into>> SelectAsync<Into, From>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<From>, ServiceStack.OrmLite.SqlExpression<From>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<T> SingleFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFormat, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<T> SingleFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFormat, params object[] filterParams) => throw null;
            }
            public static class OrmLiteReadExpressionsApiLegacy
            {
                public static long Count<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression) => throw null;
                public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Collections.Generic.IEnumerable<string> include = default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression, System.Func<T, object> include) => throw null;
                public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression) => throw null;
                public static System.Collections.Generic.List<Into> Select<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression) => throw null;
                public static System.Collections.Generic.List<Into> Select<Into, From>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<From>, ServiceStack.OrmLite.SqlExpression<From>> expression) => throw null;
                public static T Single<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> expression) => throw null;
                public static ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>(this System.Data.IDbConnection dbConn) => throw null;
            }
            public static class OrmLiteWriteApiAsyncLegacy
            {
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, string sqlFilter, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync<T>(this System.Data.IDbConnection dbConn, string sqlFilter, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, System.Type tableType, string sqlFilter, params object[] filterParams) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync(this System.Data.IDbConnection dbConn, System.Type tableType, string sqlFilter, params object[] filterParams) => throw null;
            }
            public static class OrmLiteWriteCommandExtensionsLegacy
            {
                public static int DeleteFmt<T>(this System.Data.IDbConnection dbConn, string sqlFilter, params object[] filterParams) => throw null;
                public static int DeleteFmt(this System.Data.IDbConnection dbConn, System.Type tableType, string sqlFilter, params object[] filterParams) => throw null;
            }
            public static class OrmLiteWriteExpressionsApiAsyncLegacy
            {
                public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> where, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync<T>(this System.Data.IDbConnection dbConn, string where, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync<T>(this System.Data.IDbConnection dbConn, string where = default(string)) => throw null;
                public static System.Threading.Tasks.Task<int> DeleteFmtAsync(this System.Data.IDbConnection dbConn, string table = default(string), string where = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task InsertOnlyAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> onlyFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task InsertOnlyAsync<T>(this System.Data.IDbConnection dbConn, T obj, ServiceStack.OrmLite.SqlExpression<T> onlyFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> UpdateFmtAsync<T>(this System.Data.IDbConnection dbConn, string set = default(string), string where = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> UpdateFmtAsync(this System.Data.IDbConnection dbConn, string table = default(string), string set = default(string), string where = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, T model, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> onlyFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            }
            public static class OrmLiteWriteExpressionsApiLegacy
            {
                public static int Delete<T>(this System.Data.IDbConnection dbConn, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> where) => throw null;
                public static int DeleteFmt<T>(this System.Data.IDbConnection dbConn, string where = default(string)) => throw null;
                public static int DeleteFmt(this System.Data.IDbConnection dbConn, string table = default(string), string where = default(string)) => throw null;
                public static void InsertOnly<T>(this System.Data.IDbConnection dbConn, T obj, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> onlyFields) => throw null;
                public static void InsertOnly<T>(this System.Data.IDbConnection dbConn, T obj, ServiceStack.OrmLite.SqlExpression<T> onlyFields) => throw null;
                public static int UpdateFmt<T>(this System.Data.IDbConnection dbConn, string set = default(string), string where = default(string)) => throw null;
                public static int UpdateFmt(this System.Data.IDbConnection dbConn, string table = default(string), string set = default(string), string where = default(string)) => throw null;
                public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, T model, System.Func<ServiceStack.OrmLite.SqlExpression<T>, ServiceStack.OrmLite.SqlExpression<T>> onlyFields) => throw null;
            }
        }
        public class LowercaseUnderscoreNamingStrategy : ServiceStack.OrmLite.OrmLiteNamingStrategyBase
        {
            public LowercaseUnderscoreNamingStrategy() => throw null;
            public override string GetColumnName(string name) => throw null;
            public override string GetTableName(string name) => throw null;
        }
        public static class Messages
        {
            public const string LegacyApi = default;
        }
        public class Migration : ServiceStack.IMeta
        {
            public System.DateTime? CompletedDate { get => throw null; set { } }
            public string ConnectionString { get => throw null; set { } }
            public System.DateTime CreatedDate { get => throw null; set { } }
            public Migration() => throw null;
            public string Description { get => throw null; set { } }
            public string ErrorCode { get => throw null; set { } }
            public string ErrorMessage { get => throw null; set { } }
            public string ErrorStackTrace { get => throw null; set { } }
            public long Id { get => throw null; set { } }
            public string Log { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public string NamedConnection { get => throw null; set { } }
        }
        public abstract class MigrationBase : ServiceStack.IAppTask
        {
            public virtual void AfterOpen() => throw null;
            public virtual void BeforeCommit() => throw null;
            public virtual void BeforeRollback() => throw null;
            public System.DateTime? CompletedDate { get => throw null; set { } }
            protected MigrationBase() => throw null;
            public System.Data.IDbConnection Db { get => throw null; set { } }
            public ServiceStack.Data.IDbConnectionFactory DbFactory { get => throw null; set { } }
            public virtual void Down() => throw null;
            public System.Exception Error { get => throw null; set { } }
            public string Log { get => throw null; set { } }
            public System.Text.StringBuilder MigrationLog { get => throw null; set { } }
            public System.DateTime? StartedAt { get => throw null; set { } }
            public System.Data.IDbTransaction Transaction { get => throw null; set { } }
            public virtual void Up() => throw null;
        }
        public class Migrator
        {
            public const string All = default;
            public static void Clear(System.Data.IDbConnection db) => throw null;
            public Migrator(ServiceStack.Data.IDbConnectionFactory dbFactory, params System.Reflection.Assembly[] migrationAssemblies) => throw null;
            public Migrator(ServiceStack.Data.IDbConnectionFactory dbFactory, params System.Type[] migrationTypes) => throw null;
            public ServiceStack.Data.IDbConnectionFactory DbFactory { get => throw null; }
            public static ServiceStack.AppTaskResult Down(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Type migrationType) => throw null;
            public static ServiceStack.AppTaskResult Down(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Type[] migrationTypes) => throw null;
            public static System.Collections.Generic.List<System.Type> GetAllMigrationTypes(params System.Reflection.Assembly[] migrationAssemblies) => throw null;
            public static void Init(System.Data.IDbConnection db) => throw null;
            public const string Last = default;
            public ServiceStack.Logging.ILog Log { get => throw null; set { } }
            public System.Type[] MigrationTypes { get => throw null; }
            public static void Recreate(System.Data.IDbConnection db) => throw null;
            public ServiceStack.AppTaskResult Revert(string migrationName) => throw null;
            public ServiceStack.AppTaskResult Revert(string migrationName, bool throwIfError) => throw null;
            public ServiceStack.AppTaskResult Run() => throw null;
            public ServiceStack.AppTaskResult Run(bool throwIfError) => throw null;
            public static ServiceStack.OrmLite.MigrationBase Run(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Type nextRun, System.Action<ServiceStack.OrmLite.MigrationBase> migrateAction, string namedConnection = default(string)) => throw null;
            public static ServiceStack.AppTaskResult RunAll(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Collections.Generic.IEnumerable<System.Type> migrationTypes, System.Action<ServiceStack.OrmLite.MigrationBase> migrateAction) => throw null;
            public System.TimeSpan Timeout { get => throw null; set { } }
            public static ServiceStack.AppTaskResult Up(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Type migrationType) => throw null;
            public static ServiceStack.AppTaskResult Up(ServiceStack.Data.IDbConnectionFactory dbFactory, System.Type[] migrationTypes) => throw null;
        }
        public class ModelDefinition
        {
            public void AfterInit() => throw null;
            public string Alias { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition[] AllFieldDefinitionsArray { get => throw null; }
            public ServiceStack.OrmLite.FieldDefinition AssertFieldDefinition(string fieldName) => throw null;
            public ServiceStack.OrmLite.FieldDefinition AssertFieldDefinition(string fieldName, System.Func<string, string> sanitizeFieldName) => throw null;
            public ServiceStack.OrmLite.FieldDefinition[] AutoIdFields { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.DataAnnotations.CompositeIndexAttribute> CompositeIndexes { get => throw null; set { } }
            public ModelDefinition() => throw null;
            public System.Collections.Generic.List<ServiceStack.OrmLite.FieldDefinition> FieldDefinitions { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition[] FieldDefinitionsArray { get => throw null; }
            public ServiceStack.OrmLite.FieldDefinition[] FieldDefinitionsWithAliases { get => throw null; }
            public static ServiceStack.OrmLite.ModelDefinition For(System.Type modelType) => throw null;
            public System.Collections.Generic.List<ServiceStack.OrmLite.FieldDefinition> GetAutoIdFieldDefinitions() => throw null;
            public ServiceStack.OrmLite.FieldDefinition GetFieldDefinition<T>(System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public ServiceStack.OrmLite.FieldDefinition GetFieldDefinition(string fieldName) => throw null;
            public ServiceStack.OrmLite.FieldDefinition GetFieldDefinition(string fieldName, System.Func<string, string> sanitizeFieldName) => throw null;
            public ServiceStack.OrmLite.FieldDefinition GetFieldDefinition(System.Func<string, bool> predicate) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.FieldDefinition> GetFieldDefinitionMap(System.Func<string, string> sanitizeFieldName) => throw null;
            public ServiceStack.OrmLite.FieldDefinition[] GetOrderedFieldDefinitions(System.Collections.Generic.ICollection<string> fieldNames, System.Func<string, string> sanitizeFieldName = default(System.Func<string, string>)) => throw null;
            public object GetPrimaryKey(object instance) => throw null;
            public string GetQuotedName(string fieldName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public bool HasAnyReferences(System.Collections.Generic.IEnumerable<string> fieldNames) => throw null;
            public bool HasAutoIncrementId { get => throw null; }
            public bool HasSequenceAttribute { get => throw null; }
            public System.Collections.Generic.List<ServiceStack.OrmLite.FieldDefinition> IgnoredFieldDefinitions { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition[] IgnoredFieldDefinitionsArray { get => throw null; }
            public bool IsInSchema { get => throw null; }
            public bool IsReference(string fieldName) => throw null;
            public bool IsRefField(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public string ModelName { get => throw null; }
            public System.Type ModelType { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public string PostCreateTableSql { get => throw null; set { } }
            public string PostDropTableSql { get => throw null; set { } }
            public string PreCreateTableSql { get => throw null; set { } }
            public string PreDropTableSql { get => throw null; set { } }
            public ServiceStack.OrmLite.FieldDefinition PrimaryKey { get => throw null; }
            public ServiceStack.OrmLite.FieldDefinition[] ReferenceFieldDefinitionsArray { get => throw null; }
            public System.Collections.Generic.HashSet<string> ReferenceFieldNames { get => throw null; }
            public ServiceStack.OrmLite.FieldDefinition RowVersion { get => throw null; set { } }
            public const string RowVersionName = default;
            public string Schema { get => throw null; set { } }
            public override string ToString() => throw null;
            public System.Collections.Generic.List<ServiceStack.DataAnnotations.UniqueConstraintAttribute> UniqueConstraints { get => throw null; set { } }
        }
        public static class ModelDefinition<T>
        {
            public static ServiceStack.OrmLite.ModelDefinition Definition { get => throw null; }
            public static string PrimaryKeyName { get => throw null; }
        }
        public abstract class NativeValueOrmLiteConverter : ServiceStack.OrmLite.OrmLiteConverter
        {
            protected NativeValueOrmLiteConverter() => throw null;
            public override string ToQuotedString(System.Type fieldType, object value) => throw null;
        }
        public struct ObjectRow : ServiceStack.OrmLite.IDynamicRow<object>, ServiceStack.OrmLite.IDynamicRow
        {
            public ObjectRow(System.Type type, object fields) => throw null;
            public object Fields { get => throw null; }
            public System.Type Type { get => throw null; }
        }
        public enum OnFkOption
        {
            Cascade = 0,
            SetNull = 1,
            NoAction = 2,
            SetDefault = 3,
            Restrict = 4,
        }
        public class OrmLiteCommand : System.Data.IDbCommand, System.IDisposable, ServiceStack.Data.IHasDbCommand, ServiceStack.OrmLite.IHasDialectProvider
        {
            public void Cancel() => throw null;
            public string CommandText { get => throw null; set { } }
            public int CommandTimeout { get => throw null; set { } }
            public System.Data.CommandType CommandType { get => throw null; set { } }
            public System.Data.IDbConnection Connection { get => throw null; set { } }
            public System.Guid ConnectionId { get => throw null; }
            public System.Data.IDbDataParameter CreateParameter() => throw null;
            public OrmLiteCommand(ServiceStack.OrmLite.OrmLiteConnection dbConn, System.Data.IDbCommand dbCmd) => throw null;
            public System.Data.IDbCommand DbCommand { get => throw null; }
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public void Dispose() => throw null;
            public int ExecuteNonQuery() => throw null;
            public System.Data.IDataReader ExecuteReader() => throw null;
            public System.Data.IDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
            public object ExecuteScalar() => throw null;
            public bool IsDisposed { get => throw null; }
            public System.Data.IDataParameterCollection Parameters { get => throw null; }
            public void Prepare() => throw null;
            public System.Data.IDbTransaction Transaction { get => throw null; set { } }
            public System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set { } }
        }
        public static class OrmLiteConfig
        {
            public static System.Action<System.Data.IDbCommand> AfterExecFilter { get => throw null; set { } }
            public static System.Action<System.Data.IDbCommand> BeforeExecFilter { get => throw null; set { } }
            public static void ClearCache() => throw null;
            public static int CommandTimeout { get => throw null; set { } }
            public static bool DeoptimizeReader { get => throw null; set { } }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Dialect(this System.Data.IDbCommand dbCmd) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Dialect(this System.Data.IDbConnection db) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public static bool DisableColumnGuessFallback { get => throw null; set { } }
            public static System.Action<System.Data.IDbCommand, System.Exception> ExceptionFilter { get => throw null; set { } }
            public static ServiceStack.OrmLite.IOrmLiteExecFilter ExecFilter { get => throw null; set { } }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider GetDialectProvider(this System.Data.IDbCommand dbCmd) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider GetDialectProvider(this System.Data.IDbConnection db) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteExecFilter GetExecFilter(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteExecFilter GetExecFilter(this System.Data.IDbCommand dbCmd) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteExecFilter GetExecFilter(this System.Data.IDbConnection db) => throw null;
            public static ServiceStack.OrmLite.ModelDefinition GetModelMetadata(this System.Type modelType) => throw null;
            public static ServiceStack.OrmLite.INamingStrategy GetNamingStrategy(this System.Data.IDbConnection db) => throw null;
            public const string IdField = default;
            public static bool IncludeTablePrefixes { get => throw null; set { } }
            public static System.Action<System.Data.IDbCommand, object> InsertFilter { get => throw null; set { } }
            public static bool IsCaseInsensitive { get => throw null; set { } }
            public static System.Func<System.Type, string, string> LoadReferenceSelectFilter { get => throw null; set { } }
            public static System.Func<ServiceStack.OrmLite.FieldDefinition, object> OnDbNullFilter { get => throw null; set { } }
            public static System.Action<ServiceStack.OrmLite.ModelDefinition> OnModelDefinitionInit { get => throw null; set { } }
            public static System.Data.IDbConnection OpenDbConnection(this string dbConnectionStringOrFilePath) => throw null;
            public static System.Data.IDbConnection OpenReadOnlyDbConnection(this string dbConnectionStringOrFilePath) => throw null;
            public static System.Func<string, string> ParamNameFilter { get => throw null; set { } }
            public static System.Action<object> PopulatedObjectFilter { get => throw null; set { } }
            public static void ResetLogFactory(ServiceStack.Logging.ILogFactory logFactory = default(ServiceStack.Logging.ILogFactory)) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteResultsFilter ResultsFilter { get => throw null; set { } }
            public static System.Func<string, string> SanitizeFieldNameForParamNameFn;
            public static void SetCommandTimeout(this System.Data.IDbConnection db, int? commandTimeout) => throw null;
            public static void SetLastCommandText(this System.Data.IDbConnection db, string sql) => throw null;
            public static bool SkipForeignKeys { get => throw null; set { } }
            public static System.Action<ServiceStack.OrmLite.IUntypedSqlExpression> SqlExpressionInitFilter { get => throw null; set { } }
            public static System.Action<ServiceStack.OrmLite.IUntypedSqlExpression> SqlExpressionSelectFilter { get => throw null; set { } }
            public static System.Func<string, string> StringFilter { get => throw null; set { } }
            public static bool StripUpperInLike { get => throw null; set { } }
            public static bool ThrowOnError { get => throw null; set { } }
            public static System.Data.IDbConnection ToDbConnection(this string dbConnectionStringOrFilePath) => throw null;
            public static System.Data.IDbConnection ToDbConnection(this string dbConnectionStringOrFilePath, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public static System.Action<System.Data.IDbCommand, object> UpdateFilter { get => throw null; set { } }
        }
        public static class OrmLiteConflictResolutions
        {
            public static void OnConflict(this System.Data.IDbCommand dbCmd, string conflictResolution) => throw null;
            public static void OnConflictIgnore(this System.Data.IDbCommand dbCmd) => throw null;
        }
        public class OrmLiteConnection : System.Data.IDbConnection, System.IDisposable, ServiceStack.Data.IHasDbConnection, ServiceStack.Data.IHasDbTransaction, ServiceStack.OrmLite.IHasDialectProvider
        {
            public bool AutoDisposeConnection { get => throw null; set { } }
            public System.Data.IDbTransaction BeginTransaction() => throw null;
            public System.Data.IDbTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
            public void ChangeDatabase(string databaseName) => throw null;
            public void Close() => throw null;
            public int? CommandTimeout { get => throw null; set { } }
            public System.Guid ConnectionId { get => throw null; set { } }
            public string ConnectionString { get => throw null; set { } }
            public int ConnectionTimeout { get => throw null; }
            public System.Data.IDbCommand CreateCommand() => throw null;
            public OrmLiteConnection(ServiceStack.OrmLite.OrmLiteConnectionFactory factory) => throw null;
            public string Database { get => throw null; }
            public System.Data.IDbConnection DbConnection { get => throw null; }
            public System.Data.IDbTransaction DbTransaction { get => throw null; }
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public void Dispose() => throw null;
            public readonly ServiceStack.OrmLite.OrmLiteConnectionFactory Factory;
            public string LastCommandText { get => throw null; set { } }
            public static explicit operator System.Data.Common.DbConnection(ServiceStack.OrmLite.OrmLiteConnection dbConn) => throw null;
            public void Open() => throw null;
            public System.Threading.Tasks.Task OpenAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Data.ConnectionState State { get => throw null; }
            public System.Data.IDbTransaction Transaction { get => throw null; set { } }
        }
        public class OrmLiteConnectionFactory : ServiceStack.Data.IDbConnectionFactory, ServiceStack.Data.IDbConnectionFactoryExtended
        {
            public System.Data.IDbCommand AlwaysReturnCommand { get => throw null; set { } }
            public System.Data.IDbTransaction AlwaysReturnTransaction { get => throw null; set { } }
            public bool AutoDisposeConnection { get => throw null; set { } }
            public System.Func<System.Data.IDbConnection, System.Data.IDbConnection> ConnectionFilter { get => throw null; set { } }
            public string ConnectionString { get => throw null; set { } }
            public virtual System.Data.IDbConnection CreateDbConnection() => throw null;
            public static System.Data.IDbConnection CreateDbConnection(string namedConnection) => throw null;
            public OrmLiteConnectionFactory() => throw null;
            public OrmLiteConnectionFactory(string connectionString) => throw null;
            public OrmLiteConnectionFactory(string connectionString, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public OrmLiteConnectionFactory(string connectionString, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, bool setGlobalDialectProvider) => throw null;
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public static System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.IOrmLiteDialectProvider> DialectProviders { get => throw null; }
            public static System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.OrmLiteConnectionFactory> NamedConnections { get => throw null; }
            public System.Action<ServiceStack.OrmLite.OrmLiteConnection> OnDispose { get => throw null; set { } }
            public virtual System.Data.IDbConnection OpenDbConnection() => throw null;
            public virtual System.Data.IDbConnection OpenDbConnection(string namedConnection) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(string namedConnection, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Data.IDbConnection OpenDbConnectionString(string connectionString) => throw null;
            public virtual System.Data.IDbConnection OpenDbConnectionString(string connectionString, string providerName) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionStringAsync(string connectionString, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionStringAsync(string connectionString, string providerName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void RegisterConnection(string namedConnection, string connectionString, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public virtual void RegisterConnection(string namedConnection, ServiceStack.OrmLite.OrmLiteConnectionFactory connectionFactory) => throw null;
            public virtual void RegisterDialectProvider(string providerName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
        }
        public static partial class OrmLiteConnectionFactoryExtensions
        {
            public static System.Guid GetConnectionId(this System.Data.IDbConnection db) => throw null;
            public static System.Guid GetConnectionId(this System.Data.IDbCommand dbCmd) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider GetDialectProvider(this ServiceStack.Data.IDbConnectionFactory connectionFactory, ServiceStack.ConnectionInfo dbInfo) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider GetDialectProvider(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string providerName = default(string), string namedConnection = default(string)) => throw null;
            public static System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.OrmLiteConnectionFactory> GetNamedConnections(this ServiceStack.Data.IDbConnectionFactory dbFactory) => throw null;
            public static System.Data.IDbConnection Open(this ServiceStack.Data.IDbConnectionFactory connectionFactory) => throw null;
            public static System.Data.IDbConnection Open(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string namedConnection) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string namedConnection, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Data.IDbConnection OpenDbConnection(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string namedConnection) => throw null;
            public static System.Data.IDbConnection OpenDbConnection(this ServiceStack.Data.IDbConnectionFactory dbFactory, ServiceStack.ConnectionInfo connInfo) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string namedConnection, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionAsync(this ServiceStack.Data.IDbConnectionFactory dbFactory, ServiceStack.ConnectionInfo connInfo) => throw null;
            public static System.Data.IDbConnection OpenDbConnectionString(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string connectionString) => throw null;
            public static System.Data.IDbConnection OpenDbConnectionString(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string connectionString, string providerName) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionStringAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string connectionString, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbConnection> OpenDbConnectionStringAsync(this ServiceStack.Data.IDbConnectionFactory connectionFactory, string connectionString, string providerName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static void RegisterConnection(this ServiceStack.Data.IDbConnectionFactory dbFactory, string namedConnection, string connectionString, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public static void RegisterConnection(this ServiceStack.Data.IDbConnectionFactory dbFactory, string namedConnection, ServiceStack.OrmLite.OrmLiteConnectionFactory connectionFactory) => throw null;
            public static System.Data.IDbCommand ToDbCommand(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Data.IDbConnection ToDbConnection(this System.Data.IDbConnection db) => throw null;
            public static System.Data.IDbTransaction ToDbTransaction(this System.Data.IDbTransaction dbTrans) => throw null;
        }
        public static class OrmLiteConnectionUtils
        {
            public static System.Data.IDbTransaction GetTransaction(this System.Data.IDbConnection db) => throw null;
            public static bool InTransaction(this System.Data.IDbConnection db) => throw null;
        }
        public class OrmLiteContext
        {
            public void ClearItems() => throw null;
            public static System.Collections.IDictionary ContextItems;
            public static ServiceStack.OrmLite.OrmLiteState CreateNewState() => throw null;
            public OrmLiteContext() => throw null;
            public T GetOrCreate<T>(System.Func<T> createFn) => throw null;
            public static ServiceStack.OrmLite.OrmLiteState GetOrCreateState() => throw null;
            public static readonly ServiceStack.OrmLite.OrmLiteContext Instance;
            public virtual System.Collections.IDictionary Items { get => throw null; set { } }
            public static ServiceStack.OrmLite.OrmLiteState OrmLiteState { get => throw null; set { } }
            public static bool UseThreadStatic;
        }
        public abstract class OrmLiteConverter : ServiceStack.OrmLite.IOrmLiteConverter
        {
            public abstract string ColumnDefinition { get; }
            protected OrmLiteConverter() => throw null;
            public virtual System.Data.DbType DbType { get => throw null; }
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public virtual object FromDbValue(System.Type fieldType, object value) => throw null;
            public virtual object GetValue(System.Data.IDataReader reader, int columnIndex, object[] values) => throw null;
            public virtual void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType) => throw null;
            public static ServiceStack.Logging.ILog Log;
            public virtual object ToDbValue(System.Type fieldType, object value) => throw null;
            public virtual string ToQuotedString(System.Type fieldType, object value) => throw null;
        }
        public static partial class OrmLiteConverterExtensions
        {
            public static object ConvertNumber(this ServiceStack.OrmLite.IOrmLiteConverter converter, System.Type toIntegerType, object value) => throw null;
            public static object ConvertNumber(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Type toIntegerType, object value) => throw null;
        }
        public class OrmLiteDataParameter : System.Data.IDataParameter, System.Data.IDbDataParameter
        {
            public OrmLiteDataParameter() => throw null;
            public System.Data.DbType DbType { get => throw null; set { } }
            public System.Data.ParameterDirection Direction { get => throw null; set { } }
            public bool IsNullable { get => throw null; set { } }
            public string ParameterName { get => throw null; set { } }
            public byte Precision { get => throw null; set { } }
            public byte Scale { get => throw null; set { } }
            public int Size { get => throw null; set { } }
            public string SourceColumn { get => throw null; set { } }
            public System.Data.DataRowVersion SourceVersion { get => throw null; set { } }
            public object Value { get => throw null; set { } }
        }
        public class OrmLiteDefaultNamingStrategy : ServiceStack.OrmLite.OrmLiteNamingStrategyBase
        {
            public OrmLiteDefaultNamingStrategy() => throw null;
        }
        public abstract class OrmLiteDialectProviderBase<TDialect> : ServiceStack.OrmLite.IOrmLiteDialectProvider where TDialect : ServiceStack.OrmLite.IOrmLiteDialectProvider
        {
            protected System.Data.IDbDataParameter AddParameter(System.Data.IDbCommand cmd, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public bool AllowLoadLocalInfile { set { } }
            public virtual void AppendFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDbCommand cmd) => throw null;
            public virtual void AppendInsertRowValueSql(System.Text.StringBuilder sbColumnValues, ServiceStack.OrmLite.FieldDefinition fieldDef, object obj) => throw null;
            public virtual void AppendNullFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            protected virtual void ApplyTags(System.Text.StringBuilder sqlBuilder, System.Collections.Generic.ISet<string> tags) => throw null;
            public string AutoIncrementDefinition;
            public virtual void BulkInsert<T>(System.Data.IDbConnection db, System.Collections.Generic.IEnumerable<T> objs, ServiceStack.OrmLite.BulkInsertConfig config = default(ServiceStack.OrmLite.BulkInsertConfig)) => throw null;
            public virtual string ColumnNameOnly(string columnExpr) => throw null;
            public System.Collections.Generic.List<string> ConnectionCommands { get => throw null; }
            public System.Collections.Generic.Dictionary<System.Type, ServiceStack.OrmLite.IOrmLiteConverter> Converters;
            public abstract System.Data.IDbConnection CreateConnection(string filePath, System.Collections.Generic.Dictionary<string, string> options);
            public abstract System.Data.IDbDataParameter CreateParam();
            public System.Data.IDbCommand CreateParameterizedDeleteStatement(System.Data.IDbConnection connection, object objWithProperties) => throw null;
            public System.Func<ServiceStack.OrmLite.ModelDefinition, System.Collections.Generic.IEnumerable<ServiceStack.OrmLite.FieldDefinition>> CreateTableFieldsStrategy { get => throw null; set { } }
            protected OrmLiteDialectProviderBase() => throw null;
            public ServiceStack.OrmLite.Converters.DecimalConverter DecimalConverter { get => throw null; }
            public string DefaultValueFormat;
            public virtual void DisableForeignKeysCheck(System.Data.IDbCommand cmd) => throw null;
            public virtual System.Threading.Tasks.Task DisableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void DisableIdentityInsert<T>(System.Data.IDbCommand cmd) => throw null;
            public virtual System.Threading.Tasks.Task DisableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual bool DoesColumnExist(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string)) => throw null;
            public virtual System.Threading.Tasks.Task<bool> DoesColumnExistAsync(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public abstract bool DoesSchemaExist(System.Data.IDbCommand dbCmd, string schemaName);
            public virtual System.Threading.Tasks.Task<bool> DoesSchemaExistAsync(System.Data.IDbCommand dbCmd, string schema, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual bool DoesSequenceExist(System.Data.IDbCommand dbCmd, string sequence) => throw null;
            public virtual System.Threading.Tasks.Task<bool> DoesSequenceExistAsync(System.Data.IDbCommand dbCmd, string sequenceName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual bool DoesTableExist(System.Data.IDbConnection db, string tableName, string schema = default(string)) => throw null;
            public virtual bool DoesTableExist(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string)) => throw null;
            public virtual System.Threading.Tasks.Task<bool> DoesTableExistAsync(System.Data.IDbConnection db, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<bool> DoesTableExistAsync(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void EnableForeignKeysCheck(System.Data.IDbCommand cmd) => throw null;
            public virtual System.Threading.Tasks.Task EnableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void EnableIdentityInsert<T>(System.Data.IDbCommand cmd) => throw null;
            public virtual System.Threading.Tasks.Task EnableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public ServiceStack.OrmLite.Converters.EnumConverter EnumConverter { get => throw null; set { } }
            public virtual string EscapeWildcards(string value) => throw null;
            public ServiceStack.OrmLite.IOrmLiteExecFilter ExecFilter { get => throw null; set { } }
            public virtual System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            protected virtual string FkOptionToString(ServiceStack.OrmLite.OnFkOption option) => throw null;
            public virtual object FromDbRowVersion(System.Type fieldType, object value) => throw null;
            public virtual object FromDbValue(object value, System.Type type) => throw null;
            public virtual string GenerateComment(in string text) => throw null;
            public virtual string GetAutoIdDefaultValue(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string GetCheckConstraint(ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string GetColumnNames(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual ServiceStack.OrmLite.SelectItem[] GetColumnNames(ServiceStack.OrmLite.ModelDefinition modelDef, string tablePrefix) => throw null;
            public string GetColumnTypeDefinition(System.Type columnType, int? fieldLength, int? scale) => throw null;
            protected virtual string GetCompositeIndexName(ServiceStack.DataAnnotations.CompositeIndexAttribute compositeIndex, ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            protected virtual string GetCompositeIndexNameWithSchema(ServiceStack.DataAnnotations.CompositeIndexAttribute compositeIndex, ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public ServiceStack.OrmLite.IOrmLiteConverter GetConverter(System.Type type) => throw null;
            public ServiceStack.OrmLite.IOrmLiteConverter GetConverterBestMatch(System.Type type) => throw null;
            public virtual ServiceStack.OrmLite.IOrmLiteConverter GetConverterBestMatch(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public string GetDefaultValue(System.Type tableType, string fieldName) => throw null;
            public virtual string GetDefaultValue(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string GetDropForeignKeyConstraints(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.OrmLite.FieldDefinition> GetFieldDefinitionMap(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public static System.Collections.Generic.IEnumerable<ServiceStack.OrmLite.FieldDefinition> GetFieldDefinitions(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string GetFieldReferenceSql(string subSql, ServiceStack.OrmLite.FieldDefinition fieldDef, ServiceStack.OrmLite.FieldReference fieldRef) => throw null;
            public object GetFieldValue(ServiceStack.OrmLite.FieldDefinition fieldDef, object value) => throw null;
            public object GetFieldValue(System.Type fieldType, object value) => throw null;
            public virtual string GetForeignKeyOnDeleteClause(ServiceStack.OrmLite.ForeignKeyConstraint foreignKey) => throw null;
            public virtual string GetForeignKeyOnUpdateClause(ServiceStack.OrmLite.ForeignKeyConstraint foreignKey) => throw null;
            protected virtual string GetIndexName(bool isUnique, string modelName, string fieldName) => throw null;
            protected virtual object GetInsertDefaultValue(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual ServiceStack.OrmLite.FieldDefinition[] GetInsertFieldDefinitions(ServiceStack.OrmLite.ModelDefinition modelDef, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual long GetLastInsertId(System.Data.IDbCommand dbCmd) => throw null;
            public virtual string GetLastInsertIdSqlSuffix<T>() => throw null;
            public virtual string GetLoadChildrenSubSelect<From>(ServiceStack.OrmLite.SqlExpression<From> expr) => throw null;
            protected static ServiceStack.OrmLite.ModelDefinition GetModel(System.Type modelType) => throw null;
            public virtual object GetParamValue(object value, System.Type fieldType) => throw null;
            public virtual string GetQuotedColumnName(string columnName) => throw null;
            public virtual string GetQuotedName(string name) => throw null;
            public virtual string GetQuotedName(string name, string schema) => throw null;
            public virtual string GetQuotedTableName(System.Type modelType) => throw null;
            public virtual string GetQuotedTableName(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string GetQuotedTableName(string tableName, string schema = default(string)) => throw null;
            public virtual string GetQuotedTableName(string tableName, string schema, bool useStrategy) => throw null;
            public virtual string GetQuotedValue(string paramValue) => throw null;
            public virtual string GetQuotedValue(object value, System.Type fieldType) => throw null;
            protected virtual object GetQuotedValueOrDbNull<T>(ServiceStack.OrmLite.FieldDefinition fieldDef, object obj) => throw null;
            public virtual string GetRefFieldSql(string subSql, ServiceStack.OrmLite.ModelDefinition refModelDef, ServiceStack.OrmLite.FieldDefinition refField) => throw null;
            public virtual string GetRefSelfSql<From>(ServiceStack.OrmLite.SqlExpression<From> refQ, ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.FieldDefinition refSelf, ServiceStack.OrmLite.ModelDefinition refModelDef) => throw null;
            public virtual string GetRowVersionColumn(ServiceStack.OrmLite.FieldDefinition field, string tablePrefix = default(string)) => throw null;
            public virtual ServiceStack.OrmLite.SelectItem GetRowVersionSelectColumn(ServiceStack.OrmLite.FieldDefinition field, string tablePrefix = default(string)) => throw null;
            public virtual string GetSchemaName(string schema) => throw null;
            public virtual System.Collections.Generic.List<string> GetSchemas(System.Data.IDbCommand dbCmd) => throw null;
            public virtual System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> GetSchemaTables(System.Data.IDbCommand dbCmd) => throw null;
            public virtual string GetTableName(System.Type modelType) => throw null;
            public virtual string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef, bool useStrategy) => throw null;
            public virtual string GetTableName(string table, string schema = default(string)) => throw null;
            public virtual string GetTableName(string table, string schema, bool useStrategy) => throw null;
            protected virtual string GetUniqueConstraintName(ServiceStack.DataAnnotations.UniqueConstraintAttribute constraint, string tableName) => throw null;
            public virtual string GetUniqueConstraints(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public object GetValue(System.Data.IDataReader reader, int columnIndex, System.Type type) => throw null;
            protected virtual object GetValue(ServiceStack.OrmLite.FieldDefinition fieldDef, object obj) => throw null;
            protected virtual object GetValueOrDbNull(ServiceStack.OrmLite.FieldDefinition fieldDef, object obj) => throw null;
            public virtual int GetValues(System.Data.IDataReader reader, object[] values) => throw null;
            public virtual bool HasInsertReturnValues(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual void Init(string connectionString) => throw null;
            protected void InitColumnTypeMap() => throw null;
            public virtual void InitConnection(System.Data.IDbConnection dbConn) => throw null;
            public virtual void InitDbParam(System.Data.IDbDataParameter dbParam, System.Type columnType) => throw null;
            public virtual void InitQueryParam(System.Data.IDbDataParameter param) => throw null;
            public virtual void InitUpdateParam(System.Data.IDbDataParameter param) => throw null;
            public virtual System.Threading.Tasks.Task<long> InsertAndGetLastInsertIdAsync<T>(System.Data.IDbCommand dbCmd, System.Threading.CancellationToken token) => throw null;
            public virtual bool IsFullSelectStatement(string sql) => throw null;
            protected static readonly ServiceStack.Logging.ILog Log;
            public virtual string MergeParamsIntoSql(string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> dbParams) => throw null;
            public ServiceStack.OrmLite.INamingStrategy NamingStrategy { get => throw null; set { } }
            public System.Collections.Generic.List<string> OneTimeConnectionCommands { get => throw null; }
            public System.Action<System.Data.IDbConnection> OnOpenConnection { get => throw null; set { } }
            public virtual System.Threading.Tasks.Task OpenAsync(System.Data.IDbConnection db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public System.Func<string, string> ParamNameFilter { get => throw null; set { } }
            public string ParamString { get => throw null; set { } }
            public virtual void PrepareInsertRowStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args) => throw null;
            public virtual bool PrepareParameterizedDeleteStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.IDictionary<string, object> deleteFieldValues) => throw null;
            public virtual void PrepareParameterizedInsertStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>), System.Func<ServiceStack.OrmLite.FieldDefinition, bool> shouldInclude = default(System.Func<ServiceStack.OrmLite.FieldDefinition, bool>)) => throw null;
            public virtual bool PrepareParameterizedUpdateStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual void PrepareStoredProcedureStatement<T>(System.Data.IDbCommand cmd, T obj) => throw null;
            public virtual void PrepareUpdateRowAddStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args, string sqlFilter) => throw null;
            public virtual void PrepareUpdateRowStatement(System.Data.IDbCommand dbCmd, object objWithProperties, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual void PrepareUpdateRowStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args, string sqlFilter) => throw null;
            public virtual string QuoteIfRequired(string name) => throw null;
            public virtual System.Threading.Tasks.Task<bool> ReadAsync(System.Data.IDataReader reader, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ReaderEach<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Return> ReaderEach<Return>(System.Data.IDataReader reader, System.Action fn, Return source, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<T> ReaderRead<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public ServiceStack.OrmLite.Converters.ReferenceTypeConverter ReferenceTypeConverter { get => throw null; set { } }
            public void RegisterConverter<T>(ServiceStack.OrmLite.IOrmLiteConverter converter) => throw null;
            public void RemoveConverter<T>() => throw null;
            public virtual string ResolveFragment(string sql) => throw null;
            public ServiceStack.OrmLite.Converters.RowVersionConverter RowVersionConverter { get => throw null; set { } }
            public virtual string SanitizeFieldNameForParamName(string fieldName) => throw null;
            public virtual string SelectIdentitySql { get => throw null; set { } }
            public virtual System.Collections.Generic.List<string> SequenceList(System.Type tableType) => throw null;
            public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<string>> SequenceListAsync(System.Type tableType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public virtual void SetParameter(ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDbDataParameter p) => throw null;
            protected virtual void SetParameterSize(ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDataParameter p) => throw null;
            public virtual void SetParameterValue(ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDataParameter p, object obj) => throw null;
            public virtual void SetParameterValues<T>(System.Data.IDbCommand dbCmd, object obj) => throw null;
            public virtual bool ShouldQuote(string name) => throw null;
            public virtual bool ShouldQuoteValue(System.Type fieldType) => throw null;
            protected virtual bool ShouldSkipInsert(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string SqlBool(bool value) => throw null;
            public virtual string SqlCast(object fieldOrValue, string castAs) => throw null;
            public virtual string SqlConcat(System.Collections.Generic.IEnumerable<object> args) => throw null;
            public virtual string SqlConflict(string sql, string conflictResolution) => throw null;
            public virtual string SqlCurrency(string fieldOrValue) => throw null;
            public virtual string SqlCurrency(string fieldOrValue, string currencySymbol) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>() => throw null;
            public virtual string SqlLimit(int? offset = default(int?), int? rows = default(int?)) => throw null;
            public virtual string SqlRandom { get => throw null; }
            public ServiceStack.OrmLite.Converters.StringConverter StringConverter { get => throw null; }
            public ServiceStack.Text.IStringSerializer StringSerializer { get => throw null; set { } }
            public virtual bool SupportsSchema { get => throw null; }
            public virtual string ToAddColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string ToAddForeignKeyStatement<T, TForeign>(System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Linq.Expressions.Expression<System.Func<TForeign, object>> foreignField, ServiceStack.OrmLite.OnFkOption onUpdate, ServiceStack.OrmLite.OnFkOption onDelete, string foreignKeyName = default(string)) => throw null;
            public virtual string ToAlterColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public virtual string ToChangeColumnNameStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumn) => throw null;
            protected virtual string ToCreateIndexStatement(bool isUnique, string indexName, ServiceStack.OrmLite.ModelDefinition modelDef, string fieldName, bool isCombined = default(bool), ServiceStack.OrmLite.FieldDefinition fieldDef = default(ServiceStack.OrmLite.FieldDefinition)) => throw null;
            public virtual string ToCreateIndexStatement<T>(System.Linq.Expressions.Expression<System.Func<T, object>> field, string indexName = default(string), bool unique = default(bool)) => throw null;
            public virtual System.Collections.Generic.List<string> ToCreateIndexStatements(System.Type tableType) => throw null;
            public virtual string ToCreateSavePoint(string name) => throw null;
            public abstract string ToCreateSchemaStatement(string schemaName);
            public virtual string ToCreateSequenceStatement(System.Type tableType, string sequenceName) => throw null;
            public virtual System.Collections.Generic.List<string> ToCreateSequenceStatements(System.Type tableType) => throw null;
            public virtual string ToCreateTableStatement(System.Type tableType) => throw null;
            public virtual object ToDbValue(object value, System.Type type) => throw null;
            public virtual string ToDeleteStatement(System.Type tableType, string sqlFilter, params object[] filterParams) => throw null;
            public virtual string ToDropColumnStatement(string schema, string table, string column) => throw null;
            public virtual string ToDropForeignKeyStatement(string schema, string table, string foreignKeyName) => throw null;
            public virtual string ToExecuteProcedureStatement(object objWithProperties) => throw null;
            public virtual string ToExistStatement(System.Type fromTableType, object objWithProperties, string sqlFilter, params object[] filterParams) => throw null;
            public virtual string ToInsertRowSql<T>(T obj, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual string ToInsertRowsSql<T>(System.Collections.Generic.IEnumerable<T> objs, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual string ToInsertRowStatement(System.Data.IDbCommand cmd, object objWithProperties, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual string ToInsertStatement<T>(System.Data.IDbCommand dbCmd, T item, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public virtual string ToPostCreateTableStatement(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string ToPostDropTableStatement(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string ToReleaseSavePoint(string name) => throw null;
            public virtual string ToRenameColumnStatement(string schema, string table, string oldColumn, string newColumn) => throw null;
            public virtual string ToRollbackSavePoint(string name) => throw null;
            public virtual string ToRowCountStatement(string innerSql) => throw null;
            public virtual string ToSelectFromProcedureStatement(object fromObjWithProperties, System.Type outputModelType, string sqlFilter, params object[] filterParams) => throw null;
            public virtual string ToSelectStatement(System.Type tableType, string sqlFilter, params object[] filterParams) => throw null;
            public virtual string ToSelectStatement(ServiceStack.OrmLite.QueryType queryType, ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?), System.Collections.Generic.ISet<string> tags = default(System.Collections.Generic.ISet<string>)) => throw null;
            public virtual string ToTableNamesStatement(string schema) => throw null;
            public virtual string ToTableNamesWithRowCountsStatement(bool live, string schema) => throw null;
            public virtual string ToUpdateStatement<T>(System.Data.IDbCommand dbCmd, T item, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public ServiceStack.OrmLite.Converters.ValueTypeConverter ValueTypeConverter { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, string> Variables { get => throw null; set { } }
        }
        public static partial class OrmLiteDialectProviderExtensions
        {
            public static string FmtColumn(this string columnName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string FmtTable(this string tableName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static object FromDbValue(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Data.IDataReader reader, int columnIndex, System.Type type) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteConverter GetConverter<T>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static ServiceStack.OrmLite.Converters.DateTimeConverter GetDateTimeConverter(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static ServiceStack.OrmLite.Converters.DecimalConverter GetDecimalConverter(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static string GetParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, string name, string format) => throw null;
            public static string GetParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, string name) => throw null;
            public static string GetParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, int indexNo = default(int)) => throw null;
            public static string GetQuotedColumnName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string GetQuotedColumnName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.ModelDefinition tableDef, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string GetQuotedColumnName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.ModelDefinition tableDef, string tableAlias, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string GetQuotedColumnName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.ModelDefinition tableDef, string fieldName) => throw null;
            public static string GetQuotedColumnName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, ServiceStack.OrmLite.ModelDefinition tableDef, string tableAlias, string fieldName) => throw null;
            public static ServiceStack.OrmLite.Converters.StringConverter GetStringConverter(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static bool HasConverter(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type type) => throw null;
            public static void InitDbParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Data.IDbDataParameter dbParam, System.Type columnType) => throw null;
            public static void InitDbParam(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Data.IDbDataParameter dbParam, System.Type columnType, object value) => throw null;
            public static bool IsMySqlConnector(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static string SqlSpread<T>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, params T[] values) => throw null;
            public static string ToAddColumnStatement(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string ToAlterColumnStatement(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static string ToChangeColumnNameStatement(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumnName) => throw null;
            public static string ToDropColumnStatement(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type modelType, string columnName) => throw null;
            public static string ToFieldName(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, string paramName) => throw null;
            public static string ToRenameColumnStatement(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Type modelType, string oldColumnName, string newColumnName) => throw null;
        }
        public class OrmLiteExecFilter : ServiceStack.OrmLite.IOrmLiteExecFilter
        {
            public virtual System.Data.IDbCommand CreateCommand(System.Data.IDbConnection dbConn) => throw null;
            public OrmLiteExecFilter() => throw null;
            public virtual void DisposeCommand(System.Data.IDbCommand dbCmd, System.Data.IDbConnection dbConn) => throw null;
            public virtual T Exec<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, T> filter) => throw null;
            public virtual System.Data.IDbCommand Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Data.IDbCommand> filter) => throw null;
            public virtual void Exec(System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> filter) => throw null;
            public virtual System.Threading.Tasks.Task<T> Exec<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<T>> filter) => throw null;
            public virtual System.Threading.Tasks.Task<System.Data.IDbCommand> Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<System.Data.IDbCommand>> filter) => throw null;
            public virtual System.Threading.Tasks.Task Exec(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task> filter) => throw null;
            public virtual System.Collections.Generic.IEnumerable<T> ExecLazy<T>(System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Collections.Generic.IEnumerable<T>> filter) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>(System.Data.IDbConnection dbConn) => throw null;
        }
        public class OrmLiteNamingStrategyBase : ServiceStack.OrmLite.INamingStrategy
        {
            public virtual string ApplyNameRestrictions(string name) => throw null;
            public OrmLiteNamingStrategyBase() => throw null;
            public virtual string GetColumnName(string name) => throw null;
            public virtual string GetSchemaName(string name) => throw null;
            public virtual string GetSchemaName(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public virtual string GetSequenceName(string modelName, string fieldName) => throw null;
            public virtual string GetTableName(string name) => throw null;
            public virtual string GetTableName(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
        }
        public class OrmLitePersistenceProvider : System.IDisposable, ServiceStack.Data.IEntityStore
        {
            protected System.Data.IDbConnection connection;
            public System.Data.IDbConnection Connection { get => throw null; }
            protected string ConnectionString { get => throw null; set { } }
            public OrmLitePersistenceProvider(string connectionString) => throw null;
            public OrmLitePersistenceProvider(System.Data.IDbConnection connection) => throw null;
            public void Delete<T>(T entity) => throw null;
            public void DeleteAll<TEntity>() => throw null;
            public void DeleteById<T>(object id) => throw null;
            public void DeleteByIds<T>(System.Collections.ICollection ids) => throw null;
            public void Dispose() => throw null;
            protected bool DisposeConnection;
            public T GetById<T>(object id) => throw null;
            public System.Collections.Generic.IList<T> GetByIds<T>(System.Collections.ICollection ids) => throw null;
            public T Store<T>(T entity) => throw null;
            public void StoreAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
        }
        public static class OrmLiteReadApi
        {
            public static System.Collections.Generic.List<T> Column<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static System.Collections.Generic.List<T> Column<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.List<T> Column<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.HashSet<T> ColumnDistinct<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static System.Collections.Generic.HashSet<T> ColumnDistinct<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.HashSet<T> ColumnDistinct<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.IEnumerable<T> ColumnLazy<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static System.Collections.Generic.IEnumerable<T> ColumnLazy<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.IEnumerable<T> ColumnLazy<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.Dictionary<K, V> Dictionary<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static System.Collections.Generic.Dictionary<K, V> Dictionary<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static int ExecuteNonQuery(this System.Data.IDbConnection dbConn, string sql) => throw null;
            public static int ExecuteNonQuery(this System.Data.IDbConnection dbConn, string sql, object anonType) => throw null;
            public static int ExecuteNonQuery(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static int ExecuteNonQuery(this System.Data.IDbConnection dbConn, string sql, System.Action<System.Data.IDbCommand> dbCmdFilter) => throw null;
            public static bool Exists<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> expression) => throw null;
            public static bool Exists<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static bool Exists<T>(this System.Data.IDbConnection dbConn, object anonType) => throw null;
            public static bool Exists<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>> KeyValuePairs<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>> KeyValuePairs<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static long LastInsertId(this System.Data.IDbConnection dbConn) => throw null;
            public static void LoadReferences<T>(this System.Data.IDbConnection dbConn, T instance) => throw null;
            public static T LoadSingleById<T>(this System.Data.IDbConnection dbConn, object idValue, string[] include = default(string[])) => throw null;
            public static T LoadSingleById<T>(this System.Data.IDbConnection dbConn, object idValue, System.Linq.Expressions.Expression<System.Func<T, object>> include) => throw null;
            public static long LongScalar(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> Lookup<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> Lookup<K, V>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> Lookup<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static T Scalar<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static T Scalar<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static T Scalar<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, string sql) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, string sql, object anonType) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static System.Collections.Generic.List<TModel> Select<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType, string sql, object anonType) => throw null;
            public static System.Collections.Generic.List<TModel> Select<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType) => throw null;
            public static System.Collections.Generic.List<T> SelectByIds<T>(this System.Data.IDbConnection dbConn, System.Collections.IEnumerable idValues) => throw null;
            public static System.Collections.Generic.IEnumerable<T> SelectLazy<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Collections.Generic.IEnumerable<T> SelectLazy<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.IEnumerable<T> SelectLazy<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<T> SelectNonDefaults<T>(this System.Data.IDbConnection dbConn, T filter) => throw null;
            public static System.Collections.Generic.List<T> SelectNonDefaults<T>(this System.Data.IDbConnection dbConn, string sql, T filter) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, object anonType) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static T SingleById<T>(this System.Data.IDbConnection dbConn, object idValue) => throw null;
            public static T SingleWhere<T>(this System.Data.IDbConnection dbConn, string name, object value) => throw null;
            public static System.Collections.Generic.List<T> SqlColumn<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static System.Collections.Generic.List<T> SqlColumn<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.List<T> SqlColumn<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.List<T> SqlColumn<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static System.Collections.Generic.List<T> SqlList<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static System.Collections.Generic.List<T> SqlList<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Collections.Generic.List<T> SqlList<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.List<T> SqlList<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static System.Collections.Generic.List<T> SqlList<T>(this System.Data.IDbConnection dbConn, string sql, System.Action<System.Data.IDbCommand> dbCmdFilter) => throw null;
            public static System.Data.IDbCommand SqlProc(this System.Data.IDbConnection dbConn, string name, object inParams = default(object), bool excludeDefaults = default(bool)) => throw null;
            public static System.Collections.Generic.List<TOutputModel> SqlProcedure<TOutputModel>(this System.Data.IDbConnection dbConn, object anonType) => throw null;
            public static System.Collections.Generic.List<TOutputModel> SqlProcedure<TOutputModel>(this System.Data.IDbConnection dbConn, object anonType, string sqlFilter, params object[] filterParams) where TOutputModel : new() => throw null;
            public static T SqlScalar<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static T SqlScalar<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static T SqlScalar<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static T SqlScalar<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static System.Collections.Generic.List<T> Where<T>(this System.Data.IDbConnection dbConn, string name, object value) => throw null;
            public static System.Collections.Generic.List<T> Where<T>(this System.Data.IDbConnection dbConn, object anonType) => throw null;
            public static System.Collections.Generic.IEnumerable<T> WhereLazy<T>(this System.Data.IDbConnection dbConn, object anonType) => throw null;
        }
        public static class OrmLiteReadApiAsync
        {
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ColumnAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ColumnAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ColumnAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.HashSet<T>> ColumnDistinctAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.HashSet<T>> ColumnDistinctAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.HashSet<T>> ColumnDistinctAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, V>> DictionaryAsync<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, V>> DictionaryAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, V>> DictionaryAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(this System.Data.IDbConnection dbConn, string sql, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(this System.Data.IDbConnection dbConn, string sql, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> ExistsAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> ExistsAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> ExistsAsync<T>(this System.Data.IDbConnection dbConn, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> ExistsAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>>> KeyValuePairsAsync<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>>> KeyValuePairsAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>>> KeyValuePairsAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task LoadReferencesAsync<T>(this System.Data.IDbConnection dbConn, T instance, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> LoadSingleByIdAsync<T>(this System.Data.IDbConnection dbConn, object idValue, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> LoadSingleByIdAsync<T>(this System.Data.IDbConnection dbConn, object idValue, System.Linq.Expressions.Expression<System.Func<T, object>> include, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> LongScalarAsync(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>>> LookupAsync<K, V>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>>> LookupAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>>> LookupAsync<K, V>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static T ScalarAsync<T>(this System.Data.IDbCommand dbCmd, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<TModel>> SelectAsync<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<TModel>> SelectAsync<TModel>(this System.Data.IDbConnection dbConn, System.Type fromTableType, string sqlFilter, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectByIdsAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.IEnumerable idValues, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, T filter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, string sql, T filter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleByIdAsync<T>(this System.Data.IDbConnection dbConn, object idValue, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleWhereAsync<T>(this System.Data.IDbConnection dbConn, string name, object value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlColumnAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlColumnAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlColumnAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlColumnAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlListAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlListAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlListAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlListAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SqlListAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Action<System.Data.IDbCommand> dbCmdFilter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<TOutputModel>> SqlProcedureAsync<TOutputModel>(this System.Data.IDbConnection dbConn, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SqlScalarAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SqlScalarAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SqlScalarAsync<T>(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SqlScalarAsync<T>(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> WhereAsync<T>(this System.Data.IDbConnection dbConn, string name, object value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> WhereAsync<T>(this System.Data.IDbConnection dbConn, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public static partial class OrmLiteReadCommandExtensions
        {
            public static System.Data.IDbDataParameter AddParam(this System.Data.IDbCommand dbCmd, string name, object value = default(object), System.Data.ParameterDirection direction = default(System.Data.ParameterDirection), System.Data.DbType? dbType = default(System.Data.DbType?), byte? precision = default(byte?), byte? scale = default(byte?), int? size = default(int?), System.Action<System.Data.IDbDataParameter> paramFilter = default(System.Action<System.Data.IDbDataParameter>)) => throw null;
            public static void ClearFilters(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Data.IDbDataParameter CreateParam(this System.Data.IDbCommand dbCmd, string name, object value = default(object), System.Data.ParameterDirection direction = default(System.Data.ParameterDirection), System.Data.DbType? dbType = default(System.Data.DbType?), byte? precision = default(byte?), byte? scale = default(byte?), int? size = default(int?)) => throw null;
            public static ServiceStack.OrmLite.FieldDefinition GetRefFieldDef(this ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.ModelDefinition refModelDef, System.Type refType) => throw null;
            public static ServiceStack.OrmLite.FieldDefinition GetRefFieldDefIfExists(this ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.ModelDefinition refModelDef) => throw null;
            public static ServiceStack.OrmLite.FieldDefinition GetSelfRefFieldDefIfExists(this ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.ModelDefinition refModelDef, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void LoadReferences<T>(this System.Data.IDbCommand dbCmd, T instance, System.Collections.Generic.IEnumerable<string> include = default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            public static long LongScalar(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> Lookup<K, V>(this System.Data.IDbCommand dbCmd, string sql, object anonType = default(object)) => throw null;
            public static System.Data.IDbCommand SetFilters<T>(this System.Data.IDbCommand dbCmd, object anonType) => throw null;
            public static System.Collections.Generic.List<T> SqlColumn<T>(this System.Data.IDbCommand dbCmd, string sql, object anonType = default(object)) => throw null;
            public const string UseDbConnectionExtensions = default;
        }
        public static class OrmLiteReadExpressionsApi
        {
            public static long Count<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> expression) => throw null;
            public static long Count<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static long Count<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static void DisableForeignKeysCheck(this System.Data.IDbConnection dbConn) => throw null;
            public static void EnableForeignKeysCheck(this System.Data.IDbConnection dbConn) => throw null;
            public static T Exec<T>(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, T> filter) => throw null;
            public static void Exec(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> filter) => throw null;
            public static System.Threading.Tasks.Task<T> Exec<T>(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<T>> filter) => throw null;
            public static System.Threading.Tasks.Task Exec(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task> filter) => throw null;
            public static System.Data.IDbCommand Exec(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Data.IDbCommand> filter) => throw null;
            public static System.Threading.Tasks.Task<System.Data.IDbCommand> Exec(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<System.Data.IDbCommand>> filter) => throw null;
            public static System.Collections.Generic.IEnumerable<T> ExecLazy<T>(this System.Data.IDbConnection dbConn, System.Func<System.Data.IDbCommand, System.Collections.Generic.IEnumerable<T>> filter) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T>(this System.Data.IDbConnection dbConn, System.Action<ServiceStack.OrmLite.SqlExpression<T>> options) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T, JoinWith>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, JoinWith, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, JoinWith, bool>>)) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T>(this System.Data.IDbConnection dbConn, string fromExpression) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.TableOptions tableOptions) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> From<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.TableOptions tableOptions, System.Action<ServiceStack.OrmLite.SqlExpression<T>> options) => throw null;
            public static string GetQuotedTableName<T>(this System.Data.IDbConnection db) => throw null;
            public static System.Data.DataTable GetSchemaTable(this System.Data.IDbConnection dbConn, string sql) => throw null;
            public static ServiceStack.OrmLite.ColumnSchema[] GetTableColumns<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static ServiceStack.OrmLite.ColumnSchema[] GetTableColumns(this System.Data.IDbConnection dbConn, System.Type type) => throw null;
            public static ServiceStack.OrmLite.ColumnSchema[] GetTableColumns(this System.Data.IDbConnection dbConn, string sql) => throw null;
            public static string GetTableName<T>(this System.Data.IDbConnection db) => throw null;
            public static System.Collections.Generic.List<string> GetTableNames(this System.Data.IDbConnection db) => throw null;
            public static System.Collections.Generic.List<string> GetTableNames(this System.Data.IDbConnection db, string schema) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<string>> GetTableNamesAsync(this System.Data.IDbConnection db) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<string>> GetTableNamesAsync(this System.Data.IDbConnection db, string schema) => throw null;
            public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>> GetTableNamesWithRowCounts(this System.Data.IDbConnection db, bool live = default(bool), string schema = default(string)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, long>>> GetTableNamesWithRowCountsAsync(this System.Data.IDbConnection db, bool live = default(bool), string schema = default(string)) => throw null;
            public static ServiceStack.OrmLite.JoinFormatDelegate JoinAlias(this System.Data.IDbConnection db, string alias) => throw null;
            public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, string[] include = default(string[])) => throw null;
            public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, System.Linq.Expressions.Expression<System.Func<T, object>> include) => throw null;
            public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression = default(ServiceStack.OrmLite.SqlExpression<T>), string[] include = default(string[])) => throw null;
            public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Collections.Generic.IEnumerable<string> include) => throw null;
            public static System.Collections.Generic.List<T> LoadSelect<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Linq.Expressions.Expression<System.Func<T, object>> include) => throw null;
            public static System.Collections.Generic.List<Into> LoadSelect<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, string[] include = default(string[])) => throw null;
            public static System.Collections.Generic.List<Into> LoadSelect<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, System.Collections.Generic.IEnumerable<string> include) => throw null;
            public static System.Collections.Generic.List<Into> LoadSelect<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, System.Linq.Expressions.Expression<System.Func<Into, object>> include) => throw null;
            public static System.Data.IDbCommand OpenCommand(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Data.IDbTransaction OpenTransaction(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Data.IDbTransaction OpenTransaction(this System.Data.IDbConnection dbConn, System.Data.IsolationLevel isolationLevel) => throw null;
            public static System.Data.IDbTransaction OpenTransactionIfNotExists(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Data.IDbTransaction OpenTransactionIfNotExists(this System.Data.IDbConnection dbConn, System.Data.IsolationLevel isolationLevel) => throw null;
            public static long RowCount<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static long RowCount(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object)) => throw null;
            public static long RowCount(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams) => throw null;
            public static ServiceStack.OrmLite.SavePoint SavePoint(this System.Data.IDbTransaction trans, string name) => throw null;
            public static System.Threading.Tasks.Task<ServiceStack.OrmLite.SavePoint> SavePointAsync(this System.Data.IDbTransaction trans, string name) => throw null;
            public static TKey Scalar<T, TKey>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public static TKey Scalar<T, TKey>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<T> Select<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression expression, object anonType = default(object)) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2>> SelectMulti<T, T2>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3>> SelectMulti<T, T2, T3>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4>> SelectMulti<T, T2, T3, T4>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5>> SelectMulti<T, T2, T3, T4, T5>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6>> SelectMulti<T, T2, T3, T4, T5, T6>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7>> SelectMulti<T, T2, T3, T4, T5, T6, T7>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7, T8>> SelectMulti<T, T2, T3, T4, T5, T6, T7, T8>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2>> SelectMulti<T, T2>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3>> SelectMulti<T, T2, T3>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4>> SelectMulti<T, T2, T3, T4>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5>> SelectMulti<T, T2, T3, T4, T5>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6>> SelectMulti<T, T2, T3, T4, T5, T6>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7>> SelectMulti<T, T2, T3, T4, T5, T6, T7>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7, T8>> SelectMulti<T, T2, T3, T4, T5, T6, T7, T8>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression) => throw null;
            public static T Single<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression expression) => throw null;
            public static ServiceStack.OrmLite.TableOptions TableAlias(this System.Data.IDbConnection db, string alias) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> TagWith<T>(this ServiceStack.OrmLite.SqlExpression<T> expression, string tag) => throw null;
            public static ServiceStack.OrmLite.SqlExpression<T> TagWithCallSite<T>(this ServiceStack.OrmLite.SqlExpression<T> expression, string filePath = default(string), int lineNumber = default(int)) => throw null;
        }
        public static class OrmLiteReadExpressionsApiAsync
        {
            public static System.Threading.Tasks.Task<long> CountAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> CountAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> CountAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task DisableForeignKeysCheckAsync(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task EnableForeignKeysCheckAsync(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Data.DataTable> GetSchemaTableAsync(this System.Data.IDbConnection dbConn, string sql, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<ServiceStack.OrmLite.ColumnSchema[]> GetTableColumnsAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<ServiceStack.OrmLite.ColumnSchema[]> GetTableColumnsAsync(this System.Data.IDbConnection dbConn, System.Type type, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<ServiceStack.OrmLite.ColumnSchema[]> GetTableColumnsAsync(this System.Data.IDbConnection dbConn, string sql, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> LoadSelectAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> LoadSelectAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, System.Linq.Expressions.Expression<System.Func<T, object>> include) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> LoadSelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> LoadSelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Collections.Generic.IEnumerable<string> include, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<Into>> LoadSelectAsync<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, string[] include = default(string[]), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<Into>> LoadSelectAsync<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, System.Collections.Generic.IEnumerable<string> include, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<Into>> LoadSelectAsync<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, System.Linq.Expressions.Expression<System.Func<Into, object>> include) => throw null;
            public static System.Threading.Tasks.Task<long> RowCountAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> RowCountAsync(this System.Data.IDbConnection dbConn, string sql, object anonType = default(object), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<TKey> ScalarAsync<T, TKey>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<TKey> ScalarAsync<T, TKey>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<Into>> SelectAsync<Into, From>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<From> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> SelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2>>> SelectMultiAsync<T, T2>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3>>> SelectMultiAsync<T, T2, T3>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4>>> SelectMultiAsync<T, T2, T3, T4>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5>>> SelectMultiAsync<T, T2, T3, T4, T5>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6>>> SelectMultiAsync<T, T2, T3, T4, T5, T6>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7>>> SelectMultiAsync<T, T2, T3, T4, T5, T6, T7>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7, T8>>> SelectMultiAsync<T, T2, T3, T4, T5, T6, T7, T8>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2>>> SelectMultiAsync<T, T2>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3>>> SelectMultiAsync<T, T2, T3>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4>>> SelectMultiAsync<T, T2, T3, T4>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5>>> SelectMultiAsync<T, T2, T3, T4, T5>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6>>> SelectMultiAsync<T, T2, T3, T4, T5, T6>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7>>> SelectMultiAsync<T, T2, T3, T4, T5, T6, T7>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<System.Tuple<T, T2, T3, T4, T5, T6, T7, T8>>> SelectMultiAsync<T, T2, T3, T4, T5, T6, T7, T8>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, string[] tableSelects, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> SingleAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression expression, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public class OrmLiteResultsFilter : System.IDisposable, ServiceStack.OrmLite.IOrmLiteResultsFilter
        {
            public System.Collections.IEnumerable ColumnDistinctResults { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Collections.IEnumerable> ColumnDistinctResultsFn { get => throw null; set { } }
            public System.Collections.IEnumerable ColumnResults { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Collections.IEnumerable> ColumnResultsFn { get => throw null; set { } }
            public OrmLiteResultsFilter(System.Collections.IEnumerable results = default(System.Collections.IEnumerable)) => throw null;
            public System.Collections.IDictionary DictionaryResults { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Type, System.Collections.IDictionary> DictionaryResultsFn { get => throw null; set { } }
            public void Dispose() => throw null;
            public int ExecuteSql(System.Data.IDbCommand dbCmd) => throw null;
            public System.Func<System.Data.IDbCommand, int> ExecuteSqlFn { get => throw null; set { } }
            public int ExecuteSqlResult { get => throw null; set { } }
            public System.Collections.Generic.List<T> GetColumn<T>(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.Generic.HashSet<T> GetColumnDistinct<T>(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.Generic.Dictionary<K, V> GetDictionary<K, V>(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<K, V>> GetKeyValuePairs<K, V>(System.Data.IDbCommand dbCmd) => throw null;
            public long GetLastInsertId(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.Generic.List<T> GetList<T>(System.Data.IDbCommand dbCmd) => throw null;
            public long GetLongScalar(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.Generic.Dictionary<K, System.Collections.Generic.List<V>> GetLookup<K, V>(System.Data.IDbCommand dbCmd) => throw null;
            public System.Collections.IList GetRefList(System.Data.IDbCommand dbCmd, System.Type refType) => throw null;
            public object GetRefSingle(System.Data.IDbCommand dbCmd, System.Type refType) => throw null;
            public T GetScalar<T>(System.Data.IDbCommand dbCmd) => throw null;
            public object GetScalar(System.Data.IDbCommand dbCmd) => throw null;
            public T GetSingle<T>(System.Data.IDbCommand dbCmd) => throw null;
            public long LastInsertId { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, long> LastInsertIdFn { get => throw null; set { } }
            public long LongScalarResult { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, long> LongScalarResultFn { get => throw null; set { } }
            public System.Collections.IDictionary LookupResults { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Type, System.Collections.IDictionary> LookupResultsFn { get => throw null; set { } }
            public bool PrintSql { get => throw null; set { } }
            public System.Collections.IEnumerable RefResults { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Collections.IEnumerable> RefResultsFn { get => throw null; set { } }
            public object RefSingleResult { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, object> RefSingleResultFn { get => throw null; set { } }
            public System.Collections.IEnumerable Results { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, System.Collections.IEnumerable> ResultsFn { get => throw null; set { } }
            public object ScalarResult { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, object> ScalarResultFn { get => throw null; set { } }
            public object SingleResult { get => throw null; set { } }
            public System.Func<System.Data.IDbCommand, System.Type, object> SingleResultFn { get => throw null; set { } }
            public System.Action<System.Data.IDbCommand> SqlCommandFilter { get => throw null; set { } }
            public System.Action<string> SqlFilter { get => throw null; set { } }
        }
        public static partial class OrmLiteResultsFilterExtensions
        {
            public static T ConvertTo<T>(this System.Data.IDbCommand dbCmd, string sql = default(string)) => throw null;
            public static System.Collections.Generic.List<T> ConvertToList<T>(this System.Data.IDbCommand dbCmd, string sql = default(string)) => throw null;
            public static System.Collections.IList ConvertToList(this System.Data.IDbCommand dbCmd, System.Type refType, string sql = default(string)) => throw null;
            public static long ExecLongScalar(this System.Data.IDbCommand dbCmd, string sql = default(string)) => throw null;
            public static int ExecNonQuery(this System.Data.IDbCommand dbCmd, string sql, object anonType = default(object)) => throw null;
            public static int ExecNonQuery(this System.Data.IDbCommand dbCmd, string sql, System.Collections.Generic.Dictionary<string, object> dict) => throw null;
            public static int ExecNonQuery(this System.Data.IDbCommand dbCmd) => throw null;
            public static int ExecNonQuery(this System.Data.IDbCommand dbCmd, string sql, System.Action<System.Data.IDbCommand> dbCmdFilter) => throw null;
            public static System.Data.IDbDataParameter PopulateWith(this System.Data.IDbDataParameter to, System.Data.IDbDataParameter from) => throw null;
            public static object Scalar(this System.Data.IDbCommand dbCmd, ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static object Scalar(this System.Data.IDbCommand dbCmd, string sql = default(string)) => throw null;
        }
        public static class OrmLiteResultsFilterExtensionsAsync
        {
            public static System.Threading.Tasks.Task<T> ConvertToAsync<T>(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Threading.Tasks.Task<T> ConvertToAsync<T>(this System.Data.IDbCommand dbCmd, string sql, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ConvertToListAsync<T>(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ConvertToListAsync<T>(this System.Data.IDbCommand dbCmd, string sql, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.IList> ConvertToListAsync(this System.Data.IDbCommand dbCmd, System.Type refType) => throw null;
            public static System.Threading.Tasks.Task<System.Collections.IList> ConvertToListAsync(this System.Data.IDbCommand dbCmd, System.Type refType, string sql, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<long> ExecLongScalarAsync(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Threading.Tasks.Task<long> ExecLongScalarAsync(this System.Data.IDbCommand dbCmd, string sql, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<int> ExecNonQueryAsync(this System.Data.IDbCommand dbCmd, string sql, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecNonQueryAsync(this System.Data.IDbCommand dbCmd, string sql, System.Collections.Generic.Dictionary<string, object> dict, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecNonQueryAsync(this System.Data.IDbCommand dbCmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbCommand dbCmd, string sql, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<T> ScalarAsync<T>(this System.Data.IDbCommand dbCmd, string sql, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<object> ScalarAsync(this System.Data.IDbCommand dbCmd) => throw null;
            public static System.Threading.Tasks.Task<object> ScalarAsync(this System.Data.IDbCommand dbCmd, ServiceStack.OrmLite.ISqlExpression expression, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<object> ScalarAsync(this System.Data.IDbCommand dbCmd, string sql, System.Threading.CancellationToken token) => throw null;
        }
        public static class OrmLiteSchemaApi
        {
            public static bool ColumnExists(this System.Data.IDbConnection dbConn, string columnName, string tableName, string schema = default(string)) => throw null;
            public static bool ColumnExists<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public static System.Threading.Tasks.Task<bool> ColumnExistsAsync(this System.Data.IDbConnection dbConn, string columnName, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> ColumnExistsAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static void CreateSchema<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static bool CreateSchema(this System.Data.IDbConnection dbConn, string schemaName) => throw null;
            public static void CreateTable(this System.Data.IDbConnection dbConn, bool overwrite, System.Type modelType) => throw null;
            public static void CreateTable<T>(this System.Data.IDbConnection dbConn, bool overwrite = default(bool)) => throw null;
            public static void CreateTableIfNotExists(this System.Data.IDbConnection dbConn, params System.Type[] tableTypes) => throw null;
            public static bool CreateTableIfNotExists<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static bool CreateTableIfNotExists(this System.Data.IDbConnection dbConn, System.Type modelType) => throw null;
            public static void CreateTables(this System.Data.IDbConnection dbConn, bool overwrite, params System.Type[] tableTypes) => throw null;
            public static void DropAndCreateTable<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static void DropAndCreateTable(this System.Data.IDbConnection dbConn, System.Type modelType) => throw null;
            public static void DropAndCreateTables(this System.Data.IDbConnection dbConn, params System.Type[] tableTypes) => throw null;
            public static void DropTable(this System.Data.IDbConnection dbConn, System.Type modelType) => throw null;
            public static void DropTable<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static void DropTables(this System.Data.IDbConnection dbConn, params System.Type[] tableTypes) => throw null;
            public static System.Collections.Generic.List<string> GetSchemas(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> GetSchemaTables(this System.Data.IDbConnection dbConn) => throw null;
            public static void Migrate<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static void Revert<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static bool TableExists(this System.Data.IDbConnection dbConn, string tableName, string schema = default(string)) => throw null;
            public static bool TableExists<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static System.Threading.Tasks.Task<bool> TableExistsAsync(this System.Data.IDbConnection dbConn, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> TableExistsAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public static class OrmLiteSchemaModifyApi
        {
            public static void AddColumn<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public static void AddColumn(this System.Data.IDbConnection dbConn, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AddColumn(this System.Data.IDbConnection dbConn, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AddColumn(this System.Data.IDbConnection dbConn, string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AddForeignKey<T, TForeign>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, System.Linq.Expressions.Expression<System.Func<TForeign, object>> foreignField, ServiceStack.OrmLite.OnFkOption onUpdate, ServiceStack.OrmLite.OnFkOption onDelete, string foreignKeyName = default(string)) => throw null;
            public static void AlterColumn<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public static void AlterColumn(this System.Data.IDbConnection dbConn, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AlterColumn(this System.Data.IDbConnection dbConn, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AlterColumn(this System.Data.IDbConnection dbConn, string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public static void AlterTable<T>(this System.Data.IDbConnection dbConn, string command) => throw null;
            public static void AlterTable(this System.Data.IDbConnection dbConn, System.Type modelType, string command) => throw null;
            public static void ChangeColumnName<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, string oldColumn) => throw null;
            public static void ChangeColumnName(this System.Data.IDbConnection dbConn, System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumn) => throw null;
            public static void CreateIndex<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, string indexName = default(string), bool unique = default(bool)) => throw null;
            public static void DropColumn<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field) => throw null;
            public static void DropColumn<T>(this System.Data.IDbConnection dbConn, string column) => throw null;
            public static void DropColumn(this System.Data.IDbConnection dbConn, System.Type modelType, string column) => throw null;
            public static void DropColumn(this System.Data.IDbConnection dbConn, string table, string column) => throw null;
            public static void DropColumn(this System.Data.IDbConnection dbConn, string schema, string table, string column) => throw null;
            public static void DropForeignKey<T>(this System.Data.IDbConnection dbConn, string foreignKeyName) => throw null;
            public static void DropForeignKeys<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static void DropIndex<T>(this System.Data.IDbConnection dbConn, string indexName) => throw null;
            public static void Migrate(this System.Data.IDbConnection dbConn, System.Type modelType) => throw null;
            public static void RenameColumn<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, object>> field, string oldColumn) => throw null;
            public static void RenameColumn<T>(this System.Data.IDbConnection dbConn, string oldColumn, string newColumn) => throw null;
            public static void RenameColumn(this System.Data.IDbConnection dbConn, System.Type modelType, string oldColumn, string newColumn) => throw null;
            public static void RenameColumn(this System.Data.IDbConnection dbConn, string table, string oldColumn, string newColumn) => throw null;
            public static void RenameColumn(this System.Data.IDbConnection dbConn, string schema, string table, string oldColumn, string newColumn) => throw null;
            public static void Revert(this System.Data.IDbConnection dbConn, System.Type modelType) => throw null;
        }
        public class OrmLiteSPStatement : System.IDisposable
        {
            public System.Collections.Generic.List<T> ConvertFirstColumnToList<T>() => throw null;
            public System.Collections.Generic.HashSet<T> ConvertFirstColumnToListDistinct<T>() => throw null;
            public T ConvertTo<T>() => throw null;
            public System.Collections.Generic.List<T> ConvertToList<T>() => throw null;
            public T ConvertToScalar<T>() => throw null;
            public System.Collections.Generic.List<T> ConvertToScalarList<T>() => throw null;
            public OrmLiteSPStatement(System.Data.IDbCommand dbCmd) => throw null;
            public OrmLiteSPStatement(System.Data.IDbConnection db, System.Data.IDbCommand dbCmd) => throw null;
            public void Dispose() => throw null;
            public int ExecuteNonQuery() => throw null;
            public bool HasResult() => throw null;
            public int ReturnValue { get => throw null; }
            public bool TryGetParameterValue(string parameterName, out object value) => throw null;
        }
        public class OrmLiteState
        {
            public OrmLiteState() => throw null;
            public long Id;
            public ServiceStack.OrmLite.IOrmLiteResultsFilter ResultsFilter;
            public override string ToString() => throw null;
            public System.Data.IDbTransaction TSTransaction;
        }
        public class OrmLiteTransaction : System.Data.IDbTransaction, System.IDisposable, ServiceStack.Data.IHasDbTransaction
        {
            public void Commit() => throw null;
            public System.Data.IDbConnection Connection { get => throw null; }
            public static ServiceStack.OrmLite.OrmLiteTransaction Create(System.Data.IDbConnection db, System.Data.IsolationLevel? isolationLevel = default(System.Data.IsolationLevel?)) => throw null;
            public OrmLiteTransaction(System.Data.IDbConnection db, System.Data.IDbTransaction transaction) => throw null;
            public System.Data.IDbConnection Db { get => throw null; }
            public System.Data.IDbTransaction DbTransaction { get => throw null; }
            public void Dispose() => throw null;
            public System.Data.IsolationLevel IsolationLevel { get => throw null; }
            public void Rollback() => throw null;
            public System.Data.IDbTransaction Transaction { get => throw null; set { } }
        }
        public static class OrmLiteUtils
        {
            public static string AliasOrColumn(this string quotedExpr) => throw null;
            public static string[] AllAnonFields(this System.Type type) => throw null;
            public static void AssertNotAnonType<T>() => throw null;
            public static System.Text.StringBuilder CaptureSql() => throw null;
            public static void CaptureSql(System.Text.StringBuilder sb) => throw null;
            public static T ConvertTo<T>(this System.Data.IDataReader reader, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Collections.Generic.HashSet<string> onlyFields = default(System.Collections.Generic.HashSet<string>)) => throw null;
            public static object ConvertTo(this System.Data.IDataReader reader, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Type type) => throw null;
            public static System.Collections.Generic.Dictionary<string, object> ConvertToDictionaryObjects(this System.Data.IDataReader dataReader) => throw null;
            public static System.Collections.Generic.IDictionary<string, object> ConvertToExpandoObject(this System.Data.IDataReader dataReader) => throw null;
            public static System.Collections.Generic.List<T> ConvertToList<T>(this System.Data.IDataReader reader, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Collections.Generic.HashSet<string> onlyFields = default(System.Collections.Generic.HashSet<string>)) => throw null;
            public static System.Collections.IList ConvertToList(this System.Data.IDataReader reader, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Type type) => throw null;
            public static System.Collections.Generic.List<object> ConvertToListObjects(this System.Data.IDataReader dataReader) => throw null;
            public static ulong ConvertToULong(byte[] bytes) => throw null;
            public static T ConvertToValueTuple<T>(this System.Data.IDataReader reader, object[] values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public static T CreateInstance<T>() => throw null;
            public static void DebugCommand(this ServiceStack.Logging.ILog log, System.Data.IDbCommand cmd) => throw null;
            public static T EvalFactoryFn<T>(this System.Linq.Expressions.Expression<System.Func<T>> expr) => throw null;
            public static string GetColumnNames(this ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static string GetDebugString(this System.Data.IDbCommand cmd) => throw null;
            public static string[] GetFieldNames(this System.Data.IDataReader reader) => throw null;
            public static System.Tuple<ServiceStack.OrmLite.FieldDefinition, int, ServiceStack.OrmLite.IOrmLiteConverter>[] GetIndexFieldsCache(this System.Data.IDataReader reader, ServiceStack.OrmLite.ModelDefinition modelDefinition, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Collections.Generic.HashSet<string> onlyFields = default(System.Collections.Generic.HashSet<string>), int startPos = default(int), int? endPos = default(int?)) => throw null;
            public static ServiceStack.OrmLite.ModelDefinition GetModelDefinition(System.Type modelType) => throw null;
            public static System.Collections.Generic.List<string> GetNonDefaultValueInsertFields<T>(T obj) => throw null;
            public static System.Collections.Generic.List<string> GetNonDefaultValueInsertFields<T>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, object obj) => throw null;
            public static void HandleException(System.Exception ex, string message = default(string), params object[] args) => throw null;
            public static string[] IllegalSqlFragmentTokens;
            public static bool IsRefType(this System.Type fieldType) => throw null;
            public static bool IsScalar<T>() => throw null;
            public static bool isUnsafeSql(string sql, System.Text.RegularExpressions.Regex verifySql) => throw null;
            public static ServiceStack.OrmLite.JoinFormatDelegate JoinAlias(string alias) => throw null;
            public static string MaskPassword(string connectionString) => throw null;
            public static int MaxCachedIndexFields { get => throw null; set { } }
            public static System.Collections.Generic.List<Parent> Merge<Parent, Child>(this Parent parent, System.Collections.Generic.List<Child> children) => throw null;
            public static System.Collections.Generic.List<Parent> Merge<Parent, Child>(this System.Collections.Generic.List<Parent> parents, System.Collections.Generic.List<Child> children) => throw null;
            public static string OrderByFields(ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, string orderBy) => throw null;
            public static System.Collections.Generic.List<string> ParseTokens(this string expr) => throw null;
            public static void PrintSql() => throw null;
            public static string QuotedLiteral(string text) => throw null;
            public static System.Text.RegularExpressions.Regex RegexPassword;
            public static string SqlColumn(this string columnName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlColumnRaw(this string columnName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlFmt(this string sqlText, params object[] sqlParams) => throw null;
            public static string SqlFmt(this string sqlText, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, params object[] sqlParams) => throw null;
            public static string SqlInParams<T>(this T[] values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static ServiceStack.OrmLite.SqlInValues SqlInValues<T>(this T[] values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlJoin<T>(this System.Collections.Generic.List<T> values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlJoin(System.Collections.IEnumerable values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlParam(this string paramValue) => throw null;
            public static string SqlTable(this string tableName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlTableRaw(this string tableName, ServiceStack.OrmLite.IOrmLiteDialectProvider dialect = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public static string SqlValue(this object value) => throw null;
            public static string SqlVerifyFragment(this string sqlFragment) => throw null;
            public static string SqlVerifyFragment(this string sqlFragment, System.Collections.Generic.IEnumerable<string> illegalFragments) => throw null;
            public static System.Func<string, string> SqlVerifyFragmentFn { get => throw null; set { } }
            public static string StripDbQuotes(this string quotedExpr) => throw null;
            public static string StripQuotedStrings(this string text, char quote = default(char)) => throw null;
            public static string StripTablePrefixes(this string selectExpression) => throw null;
            public static string ToSelectString<TItem>(this System.Collections.Generic.IEnumerable<TItem> items) => throw null;
            public static void UnCaptureSql() => throw null;
            public static string UnCaptureSqlAndFree(System.Text.StringBuilder sb) => throw null;
            public static void UnPrintSql() => throw null;
            public static string UnquotedColumnName(string columnExpr) => throw null;
            public static System.Text.RegularExpressions.Regex VerifyFragmentRegEx;
            public static System.Text.RegularExpressions.Regex VerifySqlRegEx;
        }
        public static class OrmLiteVariables
        {
            public const string False = default;
            public const string MaxText = default;
            public const string MaxTextUnicode = default;
            public const string SystemUtc = default;
            public const string True = default;
        }
        public static class OrmLiteWriteApi
        {
            public static void BulkInsert<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, ServiceStack.OrmLite.BulkInsertConfig config = default(ServiceStack.OrmLite.BulkInsertConfig)) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, object anonFilter, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> filters) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, T allFieldsFilter, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, params T[] allFieldsFilters) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, string sqlFilter, object anonType) => throw null;
            public static int Delete(this System.Data.IDbConnection dbConn, System.Type tableType, string sqlFilter, object anonType) => throw null;
            public static int DeleteAll<T>(this System.Data.IDbConnection dbConn) => throw null;
            public static int DeleteAll<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> rows) => throw null;
            public static int DeleteAll(this System.Data.IDbConnection dbConn, System.Type tableType) => throw null;
            public static int DeleteById<T>(this System.Data.IDbConnection dbConn, object id, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static void DeleteById<T>(this System.Data.IDbConnection dbConn, object id, ulong rowVersion, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int DeleteByIds<T>(this System.Data.IDbConnection dbConn, System.Collections.IEnumerable idValues) => throw null;
            public static int DeleteNonDefaults<T>(this System.Data.IDbConnection dbConn, T nonDefaultsFilter) => throw null;
            public static int DeleteNonDefaults<T>(this System.Data.IDbConnection dbConn, params T[] nonDefaultsFilters) => throw null;
            public static void ExecuteProcedure<T>(this System.Data.IDbConnection dbConn, T obj) => throw null;
            public static int ExecuteSql(this System.Data.IDbConnection dbConn, string sql) => throw null;
            public static int ExecuteSql(this System.Data.IDbConnection dbConn, string sql, object dbParams) => throw null;
            public static int ExecuteSql(this System.Data.IDbConnection dbConn, string sql, System.Collections.Generic.Dictionary<string, object> dbParams) => throw null;
            public static string GetLastSql(this System.Data.IDbConnection dbConn) => throw null;
            public static string GetLastSqlAndParams(this System.Data.IDbCommand dbCmd) => throw null;
            public static object GetRowVersion<T>(this System.Data.IDbConnection dbConn, object id) => throw null;
            public static object GetRowVersion(this System.Data.IDbConnection dbConn, System.Type modelType, object id) => throw null;
            public static long Insert<T>(this System.Data.IDbConnection dbConn, T obj, bool selectIdentity = default(bool), bool enableIdentityInsert = default(bool)) => throw null;
            public static long Insert<T>(this System.Data.IDbConnection dbConn, T obj, System.Action<System.Data.IDbCommand> commandFilter, bool selectIdentity = default(bool)) => throw null;
            public static long Insert<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> obj, bool selectIdentity = default(bool)) => throw null;
            public static long Insert<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, System.Collections.Generic.Dictionary<string, object> obj, bool selectIdentity = default(bool)) => throw null;
            public static void Insert<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static void Insert<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, params T[] objs) => throw null;
            public static void InsertAll<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs) => throw null;
            public static void InsertAll<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Action<System.Data.IDbCommand> commandFilter) => throw null;
            public static long InsertIntoSelect<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query) => throw null;
            public static long InsertIntoSelect<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Action<System.Data.IDbCommand> commandFilter) => throw null;
            public static void InsertUsingDefaults<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static bool Save<T>(this System.Data.IDbConnection dbConn, T obj, bool references = default(bool)) => throw null;
            public static int Save<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static int SaveAll<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs) => throw null;
            public static void SaveAllReferences<T>(this System.Data.IDbConnection dbConn, T instance) => throw null;
            public static void SaveReferences<T, TRef>(this System.Data.IDbConnection dbConn, T instance, params TRef[] refs) => throw null;
            public static void SaveReferences<T, TRef>(this System.Data.IDbConnection dbConn, T instance, System.Collections.Generic.List<TRef> refs) => throw null;
            public static void SaveReferences<T, TRef>(this System.Data.IDbConnection dbConn, T instance, System.Collections.Generic.IEnumerable<TRef> refs) => throw null;
            public static string ToInsertStatement<T>(this System.Data.IDbConnection dbConn, T item, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public static string ToUpdateStatement<T>(this System.Data.IDbConnection dbConn, T item, System.Collections.Generic.ICollection<string> updateFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, T obj, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> obj, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, params T[] objs) => throw null;
            public static int UpdateAll<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
        }
        public static class OrmLiteWriteApiAsync
        {
            public static System.Threading.Tasks.Task<int> DeleteAllAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAllAsync(this System.Data.IDbConnection dbConn, System.Type tableType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, object anonFilter, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> filters, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, T allFieldsFilter, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken), params T[] allFieldsFilters) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), params T[] allFieldsFilters) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, string sqlFilter, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync(this System.Data.IDbConnection dbConn, System.Type tableType, string sqlFilter, object anonType, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteByIdAsync<T>(this System.Data.IDbConnection dbConn, object id, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task DeleteByIdAsync<T>(this System.Data.IDbConnection dbConn, object id, ulong rowVersion, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteByIdsAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.IEnumerable idValues, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, T nonDefaultsFilter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, params T[] nonDefaultsFilters) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, params T[] nonDefaultsFilters) => throw null;
            public static System.Threading.Tasks.Task ExecuteProcedureAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecuteSqlAsync(this System.Data.IDbConnection dbConn, string sql, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> ExecuteSqlAsync(this System.Data.IDbConnection dbConn, string sql, object dbParams, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<object> GetRowVersionAsync<T>(this System.Data.IDbConnection dbConn, object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<object> GetRowVersionAsync(this System.Data.IDbConnection dbConn, System.Type modelType, object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertAllAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertAllAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Action<System.Data.IDbCommand> commandFilter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> InsertAsync<T>(this System.Data.IDbConnection dbConn, T obj, bool selectIdentity = default(bool), bool enableIdentityInsert = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> InsertAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Action<System.Data.IDbCommand> commandFilter, bool selectIdentity = default(bool), bool enableIdentityInsert = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> InsertAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> obj, bool selectIdentity = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> InsertAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, System.Collections.Generic.Dictionary<string, object> obj, bool selectIdentity = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task InsertAsync<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task InsertAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, System.Threading.CancellationToken token, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task<long> InsertIntoSelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<long> InsertIntoSelectAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.ISqlExpression query, System.Action<System.Data.IDbCommand> commandFilter, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertUsingDefaultsAsync<T>(this System.Data.IDbConnection dbConn, T[] objs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> SaveAllAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task SaveAllReferencesAsync<T>(this System.Data.IDbConnection dbConn, T instance, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<bool> SaveAsync<T>(this System.Data.IDbConnection dbConn, T obj, bool references = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> SaveAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task<int> SaveAsync<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task SaveReferencesAsync<T, TRef>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, T instance, params TRef[] refs) => throw null;
            public static System.Threading.Tasks.Task SaveReferencesAsync<T, TRef>(this System.Data.IDbConnection dbConn, T instance, params TRef[] refs) => throw null;
            public static System.Threading.Tasks.Task SaveReferencesAsync<T, TRef>(this System.Data.IDbConnection dbConn, T instance, System.Collections.Generic.List<TRef> refs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task SaveReferencesAsync<T, TRef>(this System.Data.IDbConnection dbConn, T instance, System.Collections.Generic.IEnumerable<TRef> refs, System.Threading.CancellationToken token) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAllAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.IEnumerable<T> objs, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> obj, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, System.Threading.CancellationToken token, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, System.Threading.CancellationToken token, params T[] objs) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, System.Action<System.Data.IDbCommand> commandFilter, params T[] objs) => throw null;
        }
        public static partial class OrmLiteWriteCommandExtensions
        {
            public static int GetColumnIndex(this System.Data.IDataReader reader, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, string fieldName) => throw null;
            public static void PopulateObjectWithSqlReader<T>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, object objWithProperties, System.Data.IDataReader reader, System.Tuple<ServiceStack.OrmLite.FieldDefinition, int, ServiceStack.OrmLite.IOrmLiteConverter>[] indexCache, object[] values) => throw null;
            public static T PopulateWithSqlReader<T>(this T objWithProperties, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDataReader reader) => throw null;
            public static T PopulateWithSqlReader<T>(this T objWithProperties, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, System.Data.IDataReader reader, System.Tuple<ServiceStack.OrmLite.FieldDefinition, int, ServiceStack.OrmLite.IOrmLiteConverter>[] indexCache, object[] values) => throw null;
        }
        public static class OrmLiteWriteExpressionsApi
        {
            public static int Delete<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Delete<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int DeleteWhere<T>(this System.Data.IDbConnection dbConn, string whereFilter, object[] whereParams) => throw null;
            public static long InsertOnly<T>(this System.Data.IDbConnection dbConn, T obj, System.Linq.Expressions.Expression<System.Func<T, object>> onlyFields, bool selectIdentity = default(bool)) => throw null;
            public static long InsertOnly<T>(this System.Data.IDbConnection dbConn, T obj, string[] onlyFields, bool selectIdentity = default(bool)) => throw null;
            public static long InsertOnly<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> insertFields, bool selectIdentity = default(bool)) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, T item, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int Update<T>(this System.Data.IDbConnection dbConn, object updateOnly, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateAdd<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateAdd<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, ServiceStack.OrmLite.SqlExpression<T> q, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateNonDefaults<T>(this System.Data.IDbConnection dbConn, T item, System.Linq.Expressions.Expression<System.Func<T, bool>> obj) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, ServiceStack.OrmLite.SqlExpression<T> q, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, string whereExpression, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> obj) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnly<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, string whereExpression, object[] whereParams, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnlyFields<T>(this System.Data.IDbConnection dbConn, T model, ServiceStack.OrmLite.SqlExpression<T> onlyFields, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnlyFields<T>(this System.Data.IDbConnection dbConn, T obj, string[] onlyFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
            public static int UpdateOnlyFields<T>(this System.Data.IDbConnection dbConn, T obj, System.Linq.Expressions.Expression<System.Func<T, object>> onlyFields = default(System.Linq.Expressions.Expression<System.Func<T, object>>), System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>)) => throw null;
        }
        public static class OrmLiteWriteExpressionsApiAsync
        {
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteAsync<T>(this System.Data.IDbConnection dbConn, ServiceStack.OrmLite.SqlExpression<T> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> DeleteWhereAsync<T>(this System.Data.IDbConnection dbConn, string whereFilter, object[] whereParams, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertOnlyAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Linq.Expressions.Expression<System.Func<T, object>> onlyFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task InsertOnlyAsync<T>(this System.Data.IDbConnection dbConn, T obj, string[] onlyFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> InsertOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> insertFields, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAddAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAddAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, ServiceStack.OrmLite.SqlExpression<T> q, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, T item, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateAsync<T>(this System.Data.IDbConnection dbConn, object updateOnly, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateNonDefaultsAsync<T>(this System.Data.IDbConnection dbConn, T item, System.Linq.Expressions.Expression<System.Func<T, bool>> obj, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, ServiceStack.OrmLite.SqlExpression<T> q, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Linq.Expressions.Expression<System.Func<T>> updateFields, string whereExpression, System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter> sqlParams, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyAsync<T>(this System.Data.IDbConnection dbConn, System.Collections.Generic.Dictionary<string, object> updateFields, string whereExpression, object[] whereParams, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyFieldsAsync<T>(this System.Data.IDbConnection dbConn, T model, ServiceStack.OrmLite.SqlExpression<T> onlyFields, System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyFieldsAsync<T>(this System.Data.IDbConnection dbConn, T obj, string[] onlyFields, System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<int> UpdateOnlyFieldsAsync<T>(this System.Data.IDbConnection dbConn, T obj, System.Linq.Expressions.Expression<System.Func<T, object>> onlyFields = default(System.Linq.Expressions.Expression<System.Func<T, object>>), System.Linq.Expressions.Expression<System.Func<T, bool>> where = default(System.Linq.Expressions.Expression<System.Func<T, bool>>), System.Action<System.Data.IDbCommand> commandFilter = default(System.Action<System.Data.IDbCommand>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ParameterRebinder : ServiceStack.OrmLite.SqlExpressionVisitor
        {
            public ParameterRebinder(System.Collections.Generic.Dictionary<System.Linq.Expressions.ParameterExpression, System.Linq.Expressions.ParameterExpression> map) => throw null;
            public static System.Linq.Expressions.Expression ReplaceParameters(System.Collections.Generic.Dictionary<System.Linq.Expressions.ParameterExpression, System.Linq.Expressions.ParameterExpression> map, System.Linq.Expressions.Expression exp) => throw null;
            protected override System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression p) => throw null;
        }
        public class PartialSqlString
        {
            public PartialSqlString(string text) => throw null;
            public PartialSqlString(string text, ServiceStack.OrmLite.EnumMemberAccess enumMember) => throw null;
            public readonly ServiceStack.OrmLite.EnumMemberAccess EnumMember;
            protected bool Equals(ServiceStack.OrmLite.PartialSqlString other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static ServiceStack.OrmLite.PartialSqlString Null;
            public string Text { get => throw null; }
            public override string ToString() => throw null;
        }
        public static class PredicateBuilder
        {
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> And<T>(this System.Linq.Expressions.Expression<System.Func<T, bool>> first, System.Linq.Expressions.Expression<System.Func<T, bool>> second) => throw null;
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> Create<T>(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> False<T>() => throw null;
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> Not<T>(this System.Linq.Expressions.Expression<System.Func<T, bool>> expression) => throw null;
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> Or<T>(this System.Linq.Expressions.Expression<System.Func<T, bool>> first, System.Linq.Expressions.Expression<System.Func<T, bool>> second) => throw null;
            public static System.Linq.Expressions.Expression<System.Func<T, bool>> True<T>() => throw null;
        }
        public class PrefixNamingStrategy : ServiceStack.OrmLite.OrmLiteNamingStrategyBase
        {
            public string ColumnPrefix { get => throw null; set { } }
            public PrefixNamingStrategy() => throw null;
            public override string GetColumnName(string name) => throw null;
            public override string GetTableName(string name) => throw null;
            public string TablePrefix { get => throw null; set { } }
        }
        public enum QueryType
        {
            Select = 0,
            Single = 1,
            Scalar = 2,
        }
        public class SavePoint
        {
            public SavePoint(ServiceStack.OrmLite.OrmLiteTransaction transaction, string name) => throw null;
            public string Name { get => throw null; }
            public void Release() => throw null;
            public System.Threading.Tasks.Task ReleaseAsync() => throw null;
            public void Rollback() => throw null;
            public System.Threading.Tasks.Task RollbackAsync() => throw null;
            public void Save() => throw null;
            public System.Threading.Tasks.Task SaveAsync() => throw null;
        }
        public abstract class SelectItem
        {
            public string Alias { get => throw null; set { } }
            protected SelectItem(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, string alias) => throw null;
            protected ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public abstract override string ToString();
        }
        public class SelectItemColumn : ServiceStack.OrmLite.SelectItem
        {
            public string ColumnName { get => throw null; set { } }
            public SelectItemColumn(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, string columnName, string columnAlias = default(string), string quotedTableAlias = default(string)) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider), default(string)) => throw null;
            public string QuotedTableAlias { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public class SelectItemExpression : ServiceStack.OrmLite.SelectItem
        {
            public SelectItemExpression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider, string selectExpression, string alias) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider), default(string)) => throw null;
            public string SelectExpression { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public static class Sql
        {
            public static T AllFields<T>(T item) => throw null;
            public static string As<T>(T value, object asValue) => throw null;
            public static string Asc<T>(T value) => throw null;
            public static T Avg<T>(T value) => throw null;
            public static string Avg(string value) => throw null;
            public static string Cast(object value, string castAs) => throw null;
            public static T Count<T>(T value) => throw null;
            public static string Count(string value) => throw null;
            public static T CountDistinct<T>(T value) => throw null;
            public static string Custom(string customSql) => throw null;
            public static T Custom<T>(string customSql) => throw null;
            public static string Desc<T>(T value) => throw null;
            public const string EOT = default;
            public static System.Collections.Generic.List<object> Flatten(System.Collections.IEnumerable list) => throw null;
            public static bool In<T, TItem>(T value, params TItem[] list) => throw null;
            public static bool In<T, TItem>(T value, ServiceStack.OrmLite.SqlExpression<TItem> query) => throw null;
            public static bool? IsJson(string expression) => throw null;
            public static string JoinAlias(string property, string tableAlias) => throw null;
            public static T JoinAlias<T>(T property, string tableAlias) => throw null;
            public static string JsonQuery(string expression) => throw null;
            public static T JsonQuery<T>(string expression) => throw null;
            public static string JsonQuery(string expression, string path) => throw null;
            public static T JsonQuery<T>(string expression, string path) => throw null;
            public static T JsonValue<T>(string expression, string path) => throw null;
            public static string JsonValue(string expression, string path) => throw null;
            public static T Max<T>(T value) => throw null;
            public static string Max(string value) => throw null;
            public static T Min<T>(T value) => throw null;
            public static string Min(string value) => throw null;
            public static T Sum<T>(T value) => throw null;
            public static string Sum(string value) => throw null;
            public static string TableAlias(string property, string tableAlias) => throw null;
            public static T TableAlias<T>(T property, string tableAlias) => throw null;
            public static string VARCHAR;
        }
        public class SqlBuilder
        {
            public ServiceStack.OrmLite.SqlBuilder AddParameters(object parameters) => throw null;
            public ServiceStack.OrmLite.SqlBuilder.Template AddTemplate(string sql, object parameters = default(object)) => throw null;
            public SqlBuilder() => throw null;
            public ServiceStack.OrmLite.SqlBuilder Join(string sql, object parameters = default(object)) => throw null;
            public ServiceStack.OrmLite.SqlBuilder LeftJoin(string sql, object parameters = default(object)) => throw null;
            public ServiceStack.OrmLite.SqlBuilder OrderBy(string sql, object parameters = default(object)) => throw null;
            public ServiceStack.OrmLite.SqlBuilder Select(string sql, object parameters = default(object)) => throw null;
            public class Template : ServiceStack.OrmLite.ISqlExpression
            {
                public Template(ServiceStack.OrmLite.SqlBuilder builder, string sql, object parameters) => throw null;
                public object Parameters { get => throw null; }
                public System.Collections.Generic.List<System.Data.IDbDataParameter> Params { get => throw null; }
                public string RawSql { get => throw null; }
                public string SelectInto<T>() => throw null;
                public string SelectInto<T>(ServiceStack.OrmLite.QueryType queryType) => throw null;
                public string ToSelectStatement() => throw null;
                public string ToSelectStatement(ServiceStack.OrmLite.QueryType forType) => throw null;
            }
            public ServiceStack.OrmLite.SqlBuilder Where(string sql, object parameters = default(object)) => throw null;
        }
        public class SqlCommandDetails
        {
            public SqlCommandDetails(System.Data.IDbCommand command) => throw null;
            public System.Collections.Generic.Dictionary<string, object> Parameters { get => throw null; set { } }
            public string Sql { get => throw null; set { } }
        }
        public abstract class SqlExpression<T> : ServiceStack.OrmLite.IHasDialectProvider, ServiceStack.OrmLite.IHasUntypedSqlExpression, ServiceStack.OrmLite.ISqlExpression
        {
            public virtual ServiceStack.OrmLite.SqlExpression<T> AddCondition(string condition, string sqlFilter, params object[] filterParams) => throw null;
            public virtual System.Data.IDbDataParameter AddParam(object value) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> AddReferenceTableIfNotExists<Target>() => throw null;
            public virtual void AddTag(string tag) => throw null;
            public bool AllowEscapeWildcards { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> And(string sqlFilter, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> And<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool>> predicate) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> AppendHaving(System.Linq.Expressions.Expression predicate) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> AppendToEnsure(System.Linq.Expressions.Expression predicate) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> AppendToWhere(string condition, System.Linq.Expressions.Expression predicate, object[] filterParams) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> AppendToWhere(string condition, System.Linq.Expressions.Expression predicate) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> AppendToWhere(string condition, string sqlExpression) => throw null;
            protected virtual string BindOperant(System.Linq.Expressions.ExpressionType e) => throw null;
            public string BodyExpression { get => throw null; }
            protected bool CheckExpressionForTypes(System.Linq.Expressions.Expression e, System.Linq.Expressions.ExpressionType[] types) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ClearLimits() => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Clone() => throw null;
            public string ComputeHash(bool includeParams = default(bool)) => throw null;
            protected string ConvertInExpressionToSql(System.Linq.Expressions.MethodCallExpression m, object quotedColName) => throw null;
            public string ConvertToParam(object value) => throw null;
            protected virtual void ConvertToPlaceholderAndParameter(ref object right) => throw null;
            public virtual void CopyParamsTo(System.Data.IDbCommand dbCmd) => throw null;
            protected virtual ServiceStack.OrmLite.SqlExpression<T> CopyTo(ServiceStack.OrmLite.SqlExpression<T> to) => throw null;
            protected virtual string CreateInSubQuerySql(object quotedColName, string subSelect) => throw null;
            public System.Data.IDbDataParameter CreateParam(string name, object value = default(object), System.Data.ParameterDirection direction = default(System.Data.ParameterDirection), System.Data.DbType? dbType = default(System.Data.DbType?), System.Data.DataRowVersion sourceVersion = default(System.Data.DataRowVersion)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> CrossJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> CrossJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            protected SqlExpression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> CustomJoin<Target>(string joinString) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> CustomJoin(string joinString) => throw null;
            protected bool CustomSelect { get => throw null; set { } }
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public string Dump(bool includeParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure<T1, T2, T3>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure<T1, T2, T3, T4>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Ensure<T1, T2, T3, T4, T5>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Ensure(string sqlFilter, params object[] filterParams) => throw null;
            public const string FalseLiteral = default;
            public System.Tuple<ServiceStack.OrmLite.ModelDefinition, ServiceStack.OrmLite.FieldDefinition> FirstMatchingField(string fieldName) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> From(string tables) => throw null;
            public string FromExpression { get => throw null; set { } }
            public ServiceStack.OrmLite.SqlExpression<T> FullJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> FullJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> FullJoin<Source, Target, T3>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, bool>> joinExpr) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> FullJoin<Source, Target, T3, T4>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, T4, bool>> joinExpr) => throw null;
            public System.Collections.Generic.IList<string> GetAllFields() => throw null;
            public System.Collections.Generic.List<ServiceStack.OrmLite.ModelDefinition> GetAllTables() => throw null;
            protected string GetColumnName(string fieldName) => throw null;
            protected object GetFalseExpression() => throw null;
            protected virtual object GetMemberExpression(System.Linq.Expressions.MemberExpression m) => throw null;
            public ServiceStack.OrmLite.ModelDefinition GetModelDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            protected virtual string GetQuotedColumnName(ServiceStack.OrmLite.ModelDefinition tableDef, string memberName) => throw null;
            protected virtual string GetQuotedColumnName(ServiceStack.OrmLite.ModelDefinition tableDef, string tableAlias, string memberName) => throw null;
            protected object GetQuotedFalseValue() => throw null;
            protected object GetQuotedTrueValue() => throw null;
            public virtual string GetSubstringSql(object quotedColumn, int startIndex, int? length = default(int?)) => throw null;
            protected virtual string GetTableAlias(System.Linq.Expressions.MemberExpression m, ServiceStack.OrmLite.ModelDefinition tableDef) => throw null;
            protected object GetTrueExpression() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression GetUntyped() => throw null;
            public virtual object GetValue(object value, System.Type type) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy(string groupBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> GroupBy(System.Linq.Expressions.Expression<System.Func<T, object>> keySelector) => throw null;
            public string GroupByExpression { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having(string sqlFilter, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having<Table>(System.Linq.Expressions.Expression<System.Func<Table, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Having<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, bool>> predicate) => throw null;
            public string HavingExpression { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> IncludeTablePrefix() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Insert<TKey>(System.Linq.Expressions.Expression<System.Func<T, TKey>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Insert(System.Collections.Generic.List<string> insertFields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Insert() => throw null;
            public System.Collections.Generic.List<string> InsertFields { get => throw null; set { } }
            protected ServiceStack.OrmLite.SqlExpression<T> InternalJoin<Source, Target>(string joinType, System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> InternalJoin<Source, Target>(string joinType, System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options = default(ServiceStack.OrmLite.TableOptions)) => throw null;
            protected ServiceStack.OrmLite.SqlExpression<T> InternalJoin<Source, Target>(string joinType, System.Linq.Expressions.Expression joinExpr) => throw null;
            protected virtual ServiceStack.OrmLite.SqlExpression<T> InternalJoin(string joinType, System.Linq.Expressions.Expression joinExpr, ServiceStack.OrmLite.ModelDefinition sourceDef, ServiceStack.OrmLite.ModelDefinition targetDef, ServiceStack.OrmLite.TableOptions options = default(ServiceStack.OrmLite.TableOptions)) => throw null;
            protected virtual bool IsBooleanComparison(System.Linq.Expressions.Expression e) => throw null;
            protected virtual bool IsColumnAccess(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual bool IsConstantExpression(System.Linq.Expressions.Expression e) => throw null;
            protected virtual bool IsFieldName(object quotedExp) => throw null;
            public bool IsJoinedTable(System.Type type) => throw null;
            protected virtual bool IsParameterAccess(System.Linq.Expressions.Expression e) => throw null;
            protected virtual bool IsParameterOrConvertAccess(System.Linq.Expressions.Expression e) => throw null;
            protected bool isSelectExpression;
            public static bool IsSqlClass(object obj) => throw null;
            protected virtual bool IsStaticArrayMethod(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual bool IsStaticStringMethod(System.Linq.Expressions.MethodCallExpression m) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Source, Target, T3>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, bool>> joinExpr) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> Join<Source, Target, T3, T4>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, T4, bool>> joinExpr) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Source, Target, T3>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, bool>> joinExpr) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> LeftJoin<Source, Target, T3, T4>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, T4, bool>> joinExpr) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Limit(int skip, int rows) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Limit(int? skip, int? rows) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Limit(int rows) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Limit() => throw null;
            protected ServiceStack.OrmLite.ModelDefinition modelDef;
            public ServiceStack.OrmLite.ModelDefinition ModelDef { get => throw null; set { } }
            public int? Offset { get => throw null; set { } }
            public System.Collections.Generic.HashSet<string> OnlyFields { get => throw null; set { } }
            protected virtual void OnVisitMemberType(System.Type modelType) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or(string sqlFilter, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Or<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy(string orderBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy(long columnIndex) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy(System.Linq.Expressions.Expression<System.Func<T, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderBy<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending(System.Linq.Expressions.Expression<System.Func<T, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending(string orderBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByDescending(long columnIndex) => throw null;
            public string OrderByExpression { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByFields(params ServiceStack.OrmLite.FieldDefinition[] fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByFields(params string[] fieldNames) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByFieldsDescending(params ServiceStack.OrmLite.FieldDefinition[] fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByFieldsDescending(params string[] fieldNames) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> OrderByRandom() => throw null;
            public System.Collections.Generic.List<System.Data.IDbDataParameter> Params { get => throw null; set { } }
            public bool PrefixFieldWithTableName { get => throw null; set { } }
            public virtual void PrepareUpdateStatement(System.Data.IDbCommand dbCmd, T item, bool excludeDefaults = default(bool)) => throw null;
            public virtual void PrepareUpdateStatement(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> updateFields) => throw null;
            protected string RemoveQuoteFromAlias(string exp) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<T, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Target>(System.Linq.Expressions.Expression<System.Func<T, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.JoinFormatDelegate joinFormat) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression)) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr, ServiceStack.OrmLite.TableOptions options) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Source, Target, T3>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, bool>> joinExpr) => throw null;
            public ServiceStack.OrmLite.SqlExpression<T> RightJoin<Source, Target, T3, T4>(System.Linq.Expressions.Expression<System.Func<Source, Target, T3, T4, bool>> joinExpr) => throw null;
            public int? Rows { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select(string selectExpression) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select(string[] fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select(System.Linq.Expressions.Expression<System.Func<T, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1>(System.Linq.Expressions.Expression<System.Func<Table1, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Select<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, Table12>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, Table12, object>> fields) => throw null;
            protected bool selectDistinct;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct(string selectExpression) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct(string[] fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct(System.Linq.Expressions.Expression<System.Func<T, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1>(System.Linq.Expressions.Expression<System.Func<Table1, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, Table12>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, Table6, Table7, Table8, Table9, Table10, Table11, Table12, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> SelectDistinct() => throw null;
            public string SelectExpression { get => throw null; set { } }
            public static System.Action<ServiceStack.OrmLite.SqlExpression<T>> SelectFilter { get => throw null; set { } }
            public string SelectInto<TModel>() => throw null;
            public string SelectInto<TModel>(ServiceStack.OrmLite.QueryType queryType) => throw null;
            protected string Sep { get => throw null; }
            public virtual ServiceStack.OrmLite.SqlExpression<T> SetTableAlias(string tableAlias) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Skip(int? skip = default(int?)) => throw null;
            protected bool skipParameterizationForThisExpression;
            public string SqlColumn(string columnName) => throw null;
            public System.Func<string, string> SqlFilter { get => throw null; set { } }
            public string SqlTable(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public string TableAlias { get => throw null; set { } }
            protected System.Collections.Generic.List<ServiceStack.OrmLite.ModelDefinition> tableDefs;
            public System.Collections.Generic.ISet<string> Tags { get => throw null; }
            public virtual ServiceStack.OrmLite.SqlExpression<T> Take(int? take = default(int?)) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy(string orderBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy(System.Linq.Expressions.Expression<System.Func<T, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenBy<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending(string orderBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending(System.Linq.Expressions.Expression<System.Func<T, object>> keySelector) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending<Table1, Table2, Table3, Table4>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> ThenByDescending<Table1, Table2, Table3, Table4, Table5>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, Table4, Table5, object>> fields) => throw null;
            protected virtual string ToCast(string quotedColName) => throw null;
            protected virtual ServiceStack.OrmLite.PartialSqlString ToComparePartialString(System.Collections.Generic.List<object> args) => throw null;
            protected ServiceStack.OrmLite.PartialSqlString ToConcatPartialString(System.Collections.Generic.List<object> args) => throw null;
            public virtual string ToCountStatement() => throw null;
            public virtual string ToDeleteRowStatement() => throw null;
            protected virtual ServiceStack.OrmLite.PartialSqlString ToLengthPartialString(object arg) => throw null;
            public virtual string ToMergedParamsSelectStatement() => throw null;
            public virtual string ToSelectStatement() => throw null;
            public virtual string ToSelectStatement(ServiceStack.OrmLite.QueryType forType) => throw null;
            public const string TrueLiteral = default;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeAnd(string rawSql, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeFrom(string rawFrom) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeGroupBy(string groupBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeHaving(string sqlFilter, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeOr(string rawSql, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeOrderBy(string orderBy) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeSelect(string rawSelect) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeSelect(string rawSelect, bool distinct) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> UnsafeWhere(string rawSql, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Update(System.Collections.Generic.List<string> updateFields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Update(System.Collections.Generic.IEnumerable<string> updateFields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Update(System.Linq.Expressions.Expression<System.Func<T, object>> fields) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Update() => throw null;
            public System.Collections.Generic.List<string> UpdateFields { get => throw null; set { } }
            protected bool useFieldName;
            protected bool UseFieldName { get => throw null; set { } }
            public bool UseJoinTypeAsAliases { get => throw null; set { } }
            public bool UseSelectPropertiesAsAliases { get => throw null; set { } }
            public virtual object Visit(System.Linq.Expressions.Expression exp) => throw null;
            protected virtual object VisitBinary(System.Linq.Expressions.BinaryExpression b) => throw null;
            protected virtual object VisitColumnAccessMethod(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual object VisitConditional(System.Linq.Expressions.ConditionalExpression e) => throw null;
            protected virtual object VisitConstant(System.Linq.Expressions.ConstantExpression c) => throw null;
            protected bool visitedExpressionIsTableColumn;
            protected virtual object VisitEnumerableMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual System.Collections.Generic.List<object> VisitExpressionList(System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> original) => throw null;
            protected virtual void VisitFilter(string operand, object originalLeft, object originalRight, ref object left, ref object right) => throw null;
            protected virtual object VisitIndexExpression(System.Linq.Expressions.IndexExpression e) => throw null;
            protected virtual System.Collections.Generic.List<object> VisitInSqlExpressionList(System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> original) => throw null;
            protected virtual object VisitJoin(System.Linq.Expressions.Expression exp) => throw null;
            protected virtual object VisitLambda(System.Linq.Expressions.LambdaExpression lambda) => throw null;
            protected virtual object VisitMemberAccess(System.Linq.Expressions.MemberExpression m) => throw null;
            protected virtual object VisitMemberInit(System.Linq.Expressions.MemberInitExpression exp) => throw null;
            protected virtual object VisitMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual object VisitNew(System.Linq.Expressions.NewExpression nex) => throw null;
            protected virtual object VisitNewArray(System.Linq.Expressions.NewArrayExpression na) => throw null;
            protected virtual System.Collections.Generic.List<object> VisitNewArrayFromExpressionList(System.Linq.Expressions.NewArrayExpression na) => throw null;
            protected virtual object VisitParameter(System.Linq.Expressions.ParameterExpression p) => throw null;
            protected virtual object VisitSqlMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual object VisitStaticArrayMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual object VisitStaticStringMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual object VisitUnary(System.Linq.Expressions.UnaryExpression u) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where() => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where(string sqlFilter, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where(System.Linq.Expressions.Expression<System.Func<T, bool>> predicate, params object[] filterParams) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> Where<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(System.Linq.Expressions.Expression<System.Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, bool>> predicate) => throw null;
            public virtual ServiceStack.OrmLite.SqlExpression<T> WhereExists(ServiceStack.OrmLite.ISqlExpression subSelect) => throw null;
            public string WhereExpression { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> WhereNotExists(ServiceStack.OrmLite.ISqlExpression subSelect) => throw null;
            public bool WhereStatementWithoutWhereString { get => throw null; set { } }
            public virtual ServiceStack.OrmLite.SqlExpression<T> WithSqlFilter(System.Func<string, string> sqlFilter) => throw null;
        }
        public static partial class SqlExpressionExtensions
        {
            public static string Column<Table>(this ServiceStack.OrmLite.ISqlExpression sqlExpression, System.Linq.Expressions.Expression<System.Func<Table, object>> propertyExpression, bool prefixTable = default(bool)) => throw null;
            public static string Column<Table>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, System.Linq.Expressions.Expression<System.Func<Table, object>> propertyExpression, bool prefixTable = default(bool)) => throw null;
            public static string Column<Table>(this ServiceStack.OrmLite.ISqlExpression sqlExpression, string propertyName, bool prefixTable = default(bool)) => throw null;
            public static string Column<Table>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect, string propertyName, bool prefixTable = default(bool)) => throw null;
            public static ServiceStack.OrmLite.IUntypedSqlExpression GetUntypedSqlExpression(this ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static string Table<T>(this ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
            public static string Table<T>(this ServiceStack.OrmLite.IOrmLiteDialectProvider dialect) => throw null;
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider ToDialectProvider(this ServiceStack.OrmLite.ISqlExpression sqlExpression) => throw null;
        }
        public abstract class SqlExpressionVisitor
        {
            protected SqlExpressionVisitor() => throw null;
            protected virtual System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression exp) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitBinary(System.Linq.Expressions.BinaryExpression b) => throw null;
            protected virtual System.Linq.Expressions.MemberBinding VisitBinding(System.Linq.Expressions.MemberBinding binding) => throw null;
            protected virtual System.Collections.Generic.IEnumerable<System.Linq.Expressions.MemberBinding> VisitBindingList(System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.MemberBinding> original) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitConditional(System.Linq.Expressions.ConditionalExpression c) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitConstant(System.Linq.Expressions.ConstantExpression c) => throw null;
            protected virtual System.Linq.Expressions.ElementInit VisitElementInitializer(System.Linq.Expressions.ElementInit initializer) => throw null;
            protected virtual System.Collections.Generic.IEnumerable<System.Linq.Expressions.ElementInit> VisitElementInitializerList(System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.ElementInit> original) => throw null;
            protected virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> VisitExpressionList(System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> original) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitInvocation(System.Linq.Expressions.InvocationExpression iv) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitLambda(System.Linq.Expressions.LambdaExpression lambda) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitListInit(System.Linq.Expressions.ListInitExpression init) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitMemberAccess(System.Linq.Expressions.MemberExpression m) => throw null;
            protected virtual System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment assignment) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitMemberInit(System.Linq.Expressions.MemberInitExpression init) => throw null;
            protected virtual System.Linq.Expressions.MemberListBinding VisitMemberListBinding(System.Linq.Expressions.MemberListBinding binding) => throw null;
            protected virtual System.Linq.Expressions.MemberMemberBinding VisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding binding) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            protected virtual System.Linq.Expressions.NewExpression VisitNew(System.Linq.Expressions.NewExpression nex) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitNewArray(System.Linq.Expressions.NewArrayExpression na) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression p) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitTypeIs(System.Linq.Expressions.TypeBinaryExpression b) => throw null;
            protected virtual System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression u) => throw null;
        }
        public class SqlInValues
        {
            public int Count { get => throw null; }
            public SqlInValues(System.Collections.IEnumerable values, ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider = default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
            public const string EmptyIn = default;
            public System.Collections.IEnumerable GetValues() => throw null;
            public string ToSqlInString() => throw null;
        }
        public class TableOptions
        {
            public string Alias { get => throw null; set { } }
            public TableOptions() => throw null;
            public string Expression { get => throw null; set { } }
        }
        public class UntypedApi<T> : ServiceStack.OrmLite.IUntypedApi
        {
            public System.Collections.IEnumerable Cast(System.Collections.IEnumerable results) => throw null;
            public UntypedApi() => throw null;
            public System.Data.IDbConnection Db { get => throw null; set { } }
            public System.Data.IDbCommand DbCmd { get => throw null; set { } }
            public int Delete(object obj, object anonType) => throw null;
            public int DeleteAll() => throw null;
            public int DeleteById(object id) => throw null;
            public int DeleteByIds(System.Collections.IEnumerable idValues) => throw null;
            public int DeleteNonDefaults(object obj, object filter) => throw null;
            public TReturn Exec<TReturn>(System.Func<System.Data.IDbCommand, TReturn> filter) => throw null;
            public System.Threading.Tasks.Task<TReturn> Exec<TReturn>(System.Func<System.Data.IDbCommand, System.Threading.Tasks.Task<TReturn>> filter) => throw null;
            public void Exec(System.Action<System.Data.IDbCommand> filter) => throw null;
            public long Insert(object obj, bool selectIdentity = default(bool)) => throw null;
            public long Insert(object obj, System.Action<System.Data.IDbCommand> commandFilter, bool selectIdentity = default(bool)) => throw null;
            public void InsertAll(System.Collections.IEnumerable objs) => throw null;
            public void InsertAll(System.Collections.IEnumerable objs, System.Action<System.Data.IDbCommand> commandFilter) => throw null;
            public bool Save(object obj) => throw null;
            public int SaveAll(System.Collections.IEnumerable objs) => throw null;
            public System.Threading.Tasks.Task<int> SaveAllAsync(System.Collections.IEnumerable objs, System.Threading.CancellationToken token) => throw null;
            public System.Threading.Tasks.Task<bool> SaveAsync(object obj, System.Threading.CancellationToken token) => throw null;
            public int Update(object obj) => throw null;
            public int Update(object obj, System.Action<System.Data.IDbCommand> commandFilter) => throw null;
            public int UpdateAll(System.Collections.IEnumerable objs) => throw null;
            public int UpdateAll(System.Collections.IEnumerable objs, System.Action<System.Data.IDbCommand> commandFilter) => throw null;
            public System.Threading.Tasks.Task<int> UpdateAsync(object obj, System.Threading.CancellationToken token) => throw null;
        }
        public static partial class UntypedApiExtensions
        {
            public static ServiceStack.OrmLite.IUntypedApi CreateTypedApi(this System.Data.IDbConnection db, System.Type forType) => throw null;
            public static ServiceStack.OrmLite.IUntypedApi CreateTypedApi(this System.Data.IDbCommand dbCmd, System.Type forType) => throw null;
            public static ServiceStack.OrmLite.IUntypedApi CreateTypedApi(this System.Type forType) => throw null;
        }
        public class UntypedSqlExpressionProxy<T> : ServiceStack.OrmLite.ISqlExpression, ServiceStack.OrmLite.IUntypedSqlExpression
        {
            public ServiceStack.OrmLite.IUntypedSqlExpression AddCondition(string condition, string sqlFilter, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression And(string sqlFilter, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression And<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression And<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public string BodyExpression { get => throw null; }
            public ServiceStack.OrmLite.IUntypedSqlExpression ClearLimits() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Clone() => throw null;
            public System.Data.IDbDataParameter CreateParam(string name, object value = default(object), System.Data.ParameterDirection direction = default(System.Data.ParameterDirection), System.Data.DbType? dbType = default(System.Data.DbType?)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression CrossJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public UntypedSqlExpressionProxy(ServiceStack.OrmLite.SqlExpression<T> q) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression CustomJoin(string joinString) => throw null;
            public ServiceStack.OrmLite.IOrmLiteDialectProvider DialectProvider { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Ensure(string sqlFilter, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Ensure<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Ensure<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public System.Tuple<ServiceStack.OrmLite.ModelDefinition, ServiceStack.OrmLite.FieldDefinition> FirstMatchingField(string fieldName) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression From(string tables) => throw null;
            public string FromExpression { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression FullJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public System.Collections.Generic.IList<string> GetAllFields() => throw null;
            public ServiceStack.OrmLite.ModelDefinition GetModelDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression GroupBy() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression GroupBy(string groupBy) => throw null;
            public string GroupByExpression { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Having() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Having(string sqlFilter, params object[] filterParams) => throw null;
            public string HavingExpression { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Insert(System.Collections.Generic.List<string> insertFields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Insert() => throw null;
            public System.Collections.Generic.List<string> InsertFields { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Join<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Join(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression LeftJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression LeftJoin(System.Type sourceType, System.Type targetType, System.Linq.Expressions.Expression joinExpr = default(System.Linq.Expressions.Expression)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Limit(int skip, int rows) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Limit(int? skip, int? rows) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Limit(int rows) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Limit() => throw null;
            public ServiceStack.OrmLite.ModelDefinition ModelDef { get => throw null; }
            public int? Offset { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Or(string sqlFilter, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Or<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Or<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderBy() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderBy(string orderBy) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByDescending(string orderBy) => throw null;
            public string OrderByExpression { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByFields(params ServiceStack.OrmLite.FieldDefinition[] fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByFields(params string[] fieldNames) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByFieldsDescending(params ServiceStack.OrmLite.FieldDefinition[] fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression OrderByFieldsDescending(params string[] fieldNames) => throw null;
            public System.Collections.Generic.List<System.Data.IDbDataParameter> Params { get => throw null; set { } }
            public bool PrefixFieldWithTableName { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression RightJoin<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> joinExpr = default(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>>)) => throw null;
            public int? Rows { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Select() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Select(string selectExpression) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Select<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Select<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct<Table1, Table2>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, object>> fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct<Table1, Table2, Table3>(System.Linq.Expressions.Expression<System.Func<Table1, Table2, Table3, object>> fields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression SelectDistinct() => throw null;
            public string SelectExpression { get => throw null; set { } }
            public string SelectInto<TModel>() => throw null;
            public string SelectInto<TModel>(ServiceStack.OrmLite.QueryType queryType) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Skip(int? skip = default(int?)) => throw null;
            public string SqlColumn(string columnName) => throw null;
            public string SqlTable(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
            public string TableAlias { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Take(int? take = default(int?)) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression ThenBy(string orderBy) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression ThenBy<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression ThenByDescending(string orderBy) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression ThenByDescending<Table>(System.Linq.Expressions.Expression<System.Func<Table, object>> keySelector) => throw null;
            public string ToCountStatement() => throw null;
            public string ToDeleteRowStatement() => throw null;
            public string ToSelectStatement() => throw null;
            public string ToSelectStatement(ServiceStack.OrmLite.QueryType forType) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression UnsafeAnd(string rawSql, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression UnsafeFrom(string rawFrom) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression UnsafeOr(string rawSql, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression UnsafeSelect(string rawSelect) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression UnsafeWhere(string rawSql, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Update(System.Collections.Generic.List<string> updateFields) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Update() => throw null;
            public System.Collections.Generic.List<string> UpdateFields { get => throw null; set { } }
            public ServiceStack.OrmLite.IUntypedSqlExpression Where() => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Where(string sqlFilter, params object[] filterParams) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Where<Target>(System.Linq.Expressions.Expression<System.Func<Target, bool>> predicate) => throw null;
            public ServiceStack.OrmLite.IUntypedSqlExpression Where<Source, Target>(System.Linq.Expressions.Expression<System.Func<Source, Target, bool>> predicate) => throw null;
            public string WhereExpression { get => throw null; set { } }
            public bool WhereStatementWithoutWhereString { get => throw null; set { } }
        }
        public class UpperCaseNamingStrategy : ServiceStack.OrmLite.OrmLiteNamingStrategyBase
        {
            public UpperCaseNamingStrategy() => throw null;
            public override string GetColumnName(string name) => throw null;
            public override string GetTableName(string name) => throw null;
        }
        public struct XmlValue
        {
            public XmlValue(string xml) => throw null;
            public bool Equals(ServiceStack.OrmLite.XmlValue other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static implicit operator ServiceStack.OrmLite.XmlValue(string expandedName) => throw null;
            public override string ToString() => throw null;
            public string Xml { get => throw null; }
        }
    }
}
