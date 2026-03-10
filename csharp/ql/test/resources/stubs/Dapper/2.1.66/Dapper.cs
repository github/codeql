// This file contains auto-generated code.
// Generated from `Dapper, Version=2.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace Dapper
{
    public struct CommandDefinition
    {
        public bool Buffered { get => throw null; }
        public System.Threading.CancellationToken CancellationToken { get => throw null; }
        public string CommandText { get => throw null; }
        public int? CommandTimeout { get => throw null; }
        public System.Data.CommandType? CommandType { get => throw null; }
        public CommandDefinition(string commandText, object parameters = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?), Dapper.CommandFlags flags = default(Dapper.CommandFlags), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public Dapper.CommandFlags Flags { get => throw null; }
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
    public sealed class CustomPropertyTypeMap : Dapper.SqlMapper.ITypeMap
    {
        public CustomPropertyTypeMap(System.Type type, System.Func<System.Type, string, System.Reflection.PropertyInfo> propertySelector) => throw null;
        public System.Reflection.ConstructorInfo FindConstructor(string[] names, System.Type[] types) => throw null;
        public System.Reflection.ConstructorInfo FindExplicitConstructor() => throw null;
        public Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName) => throw null;
        public Dapper.SqlMapper.IMemberMap GetMember(string columnName) => throw null;
    }
    public sealed class DbString : Dapper.SqlMapper.ICustomQueryParameter
    {
        public void AddParameter(System.Data.IDbCommand command, string name) => throw null;
        public DbString() => throw null;
        public DbString(string value, int length = default(int)) => throw null;
        public const int DefaultLength = 4000;
        public bool IsAnsi { get => throw null; set { } }
        public static bool IsAnsiDefault { get => throw null; set { } }
        public bool IsFixedLength { get => throw null; set { } }
        public int Length { get => throw null; set { } }
        public override string ToString() => throw null;
        public string Value { get => throw null; set { } }
    }
    public sealed class DefaultTypeMap : Dapper.SqlMapper.ITypeMap
    {
        public DefaultTypeMap(System.Type type) => throw null;
        public System.Reflection.ConstructorInfo FindConstructor(string[] names, System.Type[] types) => throw null;
        public System.Reflection.ConstructorInfo FindExplicitConstructor() => throw null;
        public Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName) => throw null;
        public Dapper.SqlMapper.IMemberMap GetMember(string columnName) => throw null;
        public static bool MatchNamesWithUnderscores { get => throw null; set { } }
        public System.Collections.Generic.List<System.Reflection.PropertyInfo> Properties { get => throw null; }
    }
    public class DynamicParameters : Dapper.SqlMapper.IDynamicParameters, Dapper.SqlMapper.IParameterCallbacks, Dapper.SqlMapper.IParameterLookup
    {
        public void Add(string name, object value, System.Data.DbType? dbType, System.Data.ParameterDirection? direction, int? size) => throw null;
        public void Add(string name, object value = default(object), System.Data.DbType? dbType = default(System.Data.DbType?), System.Data.ParameterDirection? direction = default(System.Data.ParameterDirection?), int? size = default(int?), byte? precision = default(byte?), byte? scale = default(byte?)) => throw null;
        public void AddDynamicParams(object param) => throw null;
        void Dapper.SqlMapper.IDynamicParameters.AddParameters(System.Data.IDbCommand command, Dapper.SqlMapper.Identity identity) => throw null;
        protected void AddParameters(System.Data.IDbCommand command, Dapper.SqlMapper.Identity identity) => throw null;
        public DynamicParameters() => throw null;
        public DynamicParameters(object template) => throw null;
        public T Get<T>(string name) => throw null;
        object Dapper.SqlMapper.IParameterLookup.this[string name] { get => throw null; }
        void Dapper.SqlMapper.IParameterCallbacks.OnCompleted() => throw null;
        public Dapper.DynamicParameters Output<T>(T target, System.Linq.Expressions.Expression<System.Func<T, object>> expression, System.Data.DbType? dbType = default(System.Data.DbType?), int? size = default(int?)) => throw null;
        public System.Collections.Generic.IEnumerable<string> ParameterNames { get => throw null; }
        public bool RemoveUnused { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)96, AllowMultiple = false)]
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
        public static void AddTypeHandler(System.Type type, Dapper.SqlMapper.ITypeHandler handler) => throw null;
        public static void AddTypeHandler<T>(Dapper.SqlMapper.TypeHandler<T> handler) => throw null;
        public static void AddTypeHandlerImpl(System.Type type, Dapper.SqlMapper.ITypeHandler handler, bool clone) => throw null;
        public static void AddTypeMap(System.Type type, System.Data.DbType dbType) => throw null;
        public static void AddTypeMap(System.Type type, System.Data.DbType dbType, bool useGetFieldValue) => throw null;
        public static System.Collections.Generic.List<T> AsList<T>(this System.Collections.Generic.IEnumerable<T> source) => throw null;
        public static Dapper.SqlMapper.ICustomQueryParameter AsTableValuedParameter(this System.Data.DataTable table, string typeName = default(string)) => throw null;
        public static Dapper.SqlMapper.ICustomQueryParameter AsTableValuedParameter<T>(this System.Collections.Generic.IEnumerable<T> list, string typeName = default(string)) where T : System.Data.IDataRecord => throw null;
        public static System.Collections.Generic.IEqualityComparer<string> ConnectionStringComparer { get => throw null; set { } }
        public static System.Action<System.Data.IDbCommand, object> CreateParamInfoGenerator(Dapper.SqlMapper.Identity identity, bool checkForDuplicates, bool removeUnused) => throw null;
        public static int Execute(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static int Execute(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<int> ExecuteAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<int> ExecuteAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
        public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
        public static System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteReaderAsync(this System.Data.Common.DbConnection cnn, Dapper.CommandDefinition command, System.Data.CommandBehavior commandBehavior) => throw null;
        public static object ExecuteScalar(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T ExecuteScalar<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static object ExecuteScalar(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static T ExecuteScalar<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<object> ExecuteScalarAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<T> ExecuteScalarAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> ExecuteScalarAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> ExecuteScalarAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Data.IDbDataParameter FindOrAddParameter(System.Data.IDataParameterCollection parameters, System.Data.IDbCommand command, string name) => throw null;
        public static string Format(object value) => throw null;
        public static System.Collections.Generic.IEnumerable<System.Tuple<string, string, int>> GetCachedSQL(int ignoreHitCountAbove = default(int)) => throw null;
        public static int GetCachedSQLCount() => throw null;
        public static System.Collections.Generic.IEnumerable<System.Tuple<int, int>> GetHashCollissions() => throw null;
        public static System.Func<System.Data.IDataReader, object> GetRowParser(this System.Data.IDataReader reader, System.Type type, int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static System.Func<System.Data.Common.DbDataReader, object> GetRowParser(this System.Data.Common.DbDataReader reader, System.Type type, int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static System.Func<System.Data.IDataReader, T> GetRowParser<T>(this System.Data.IDataReader reader, System.Type concreteType = default(System.Type), int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static System.Func<System.Data.Common.DbDataReader, T> GetRowParser<T>(this System.Data.Common.DbDataReader reader, System.Type concreteType = default(System.Type), int startIndex = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static System.Func<System.Data.IDataReader, object> GetTypeDeserializer(System.Type type, System.Data.IDataReader reader, int startBound = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static System.Func<System.Data.Common.DbDataReader, object> GetTypeDeserializer(System.Type type, System.Data.Common.DbDataReader reader, int startBound = default(int), int length = default(int), bool returnNullIfFirstMissing = default(bool)) => throw null;
        public static Dapper.SqlMapper.ITypeMap GetTypeMap(System.Type type) => throw null;
        public static string GetTypeName(this System.Data.DataTable table) => throw null;
        public class GridReader : System.IAsyncDisposable, System.IDisposable
        {
            protected System.Threading.CancellationToken CancellationToken { get => throw null; }
            public System.Data.IDbCommand Command { get => throw null; set { } }
            protected GridReader(System.Data.IDbCommand command, System.Data.Common.DbDataReader reader, Dapper.SqlMapper.Identity identity, System.Action<object> onCompleted = default(System.Action<object>), object state = default(object), bool addToCache = default(bool), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public void Dispose() => throw null;
            public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
            public bool IsConsumed { get => throw null; }
            protected void OnAfterGrid(int index) => throw null;
            protected System.Threading.Tasks.Task OnAfterGridAsync(int index) => throw null;
            protected int OnBeforeGrid() => throw null;
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
            protected System.Data.Common.DbDataReader Reader { get => throw null; }
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
            public System.Collections.Generic.IAsyncEnumerable<T> ReadUnbufferedAsync<T>() => throw null;
            public System.Collections.Generic.IAsyncEnumerable<dynamic> ReadUnbufferedAsync() => throw null;
            protected int ResultIndex { get => throw null; }
        }
        public static bool HasTypeHandler(System.Type type) => throw null;
        public interface ICustomQueryParameter
        {
            void AddParameter(System.Data.IDbCommand command, string name);
        }
        public class Identity : System.IEquatable<Dapper.SqlMapper.Identity>
        {
            public readonly System.Data.CommandType? commandType;
            public System.Data.CommandType? CommandType { get => throw null; }
            public readonly string connectionString;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Dapper.SqlMapper.Identity other) => throw null;
            public Dapper.SqlMapper.Identity ForDynamicParameters(System.Type type) => throw null;
            public override int GetHashCode() => throw null;
            public readonly int gridIndex;
            public int GridIndex { get => throw null; }
            public readonly int hashCode;
            public readonly System.Type parametersType;
            public System.Type ParametersType { get => throw null; }
            public readonly string sql;
            public string Sql { get => throw null; }
            public override string ToString() => throw null;
            public readonly System.Type type;
            public System.Type Type { get => throw null; }
        }
        public interface IDynamicParameters
        {
            void AddParameters(System.Data.IDbCommand command, Dapper.SqlMapper.Identity identity);
        }
        public interface IMemberMap
        {
            string ColumnName { get; }
            System.Reflection.FieldInfo Field { get; }
            System.Type MemberType { get; }
            System.Reflection.ParameterInfo Parameter { get; }
            System.Reflection.PropertyInfo Property { get; }
        }
        public interface IParameterCallbacks : Dapper.SqlMapper.IDynamicParameters
        {
            void OnCompleted();
        }
        public interface IParameterLookup : Dapper.SqlMapper.IDynamicParameters
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
            Dapper.SqlMapper.IMemberMap GetConstructorParameter(System.Reflection.ConstructorInfo constructor, string columnName);
            Dapper.SqlMapper.IMemberMap GetMember(string columnName);
        }
        public static System.Data.DbType? LookupDbType(System.Type type, string name, bool demand, out Dapper.SqlMapper.ITypeHandler handler) => throw null;
        public static void PackListParameters(System.Data.IDbCommand command, string namePrefix, object value) => throw null;
        public static System.Collections.Generic.IEnumerable<T> Parse<T>(this System.Data.IDataReader reader) => throw null;
        public static System.Collections.Generic.IEnumerable<object> Parse(this System.Data.IDataReader reader, System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<dynamic> Parse(this System.Data.IDataReader reader) => throw null;
        public static void PurgeQueryCache() => throw null;
        public static System.Collections.Generic.IEnumerable<dynamic> Query(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<T> Query<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<object> Query(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<T> Query<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IEnumerable<TReturn> Query<TReturn>(this System.Data.IDbConnection cnn, string sql, System.Type[] types, System.Func<object[], TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<dynamic>> QueryAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<dynamic>> QueryAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> QueryAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<object>> QueryAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> QueryAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<object>> QueryAsync(this System.Data.IDbConnection cnn, System.Type type, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, string sql, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command, System.Func<TFirst, TSecond, TThird, TFourth, TFifth, TSixth, TSeventh, TReturn> map, string splitOn = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TReturn>> QueryAsync<TReturn>(this System.Data.IDbConnection cnn, string sql, System.Type[] types, System.Func<object[], TReturn> map, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), bool buffered = default(bool), string splitOn = default(string), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static event System.EventHandler QueryCachePurged;
        public static dynamic QueryFirst(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QueryFirst<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static object QueryFirst(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QueryFirst<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QueryFirstAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QueryFirstAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QueryFirstAsync(this System.Data.IDbConnection cnn, System.Type type, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QueryFirstAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static dynamic QueryFirstOrDefault(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QueryFirstOrDefault<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static object QueryFirstOrDefault(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QueryFirstOrDefault<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QueryFirstOrDefaultAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QueryFirstOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QueryFirstOrDefaultAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static Dapper.SqlMapper.GridReader QueryMultiple(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static Dapper.SqlMapper.GridReader QueryMultiple(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<Dapper.SqlMapper.GridReader> QueryMultipleAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<Dapper.SqlMapper.GridReader> QueryMultipleAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static dynamic QuerySingle(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QuerySingle<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static object QuerySingle(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QuerySingle<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QuerySingleAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QuerySingleAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QuerySingleAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QuerySingleAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QuerySingleAsync(this System.Data.IDbConnection cnn, System.Type type, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QuerySingleAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static dynamic QuerySingleOrDefault(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QuerySingleOrDefault<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static object QuerySingleOrDefault(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static T QuerySingleOrDefault<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QuerySingleOrDefaultAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, string sql, object param = default(object), System.Data.IDbTransaction transaction = default(System.Data.IDbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Threading.Tasks.Task<object> QuerySingleOrDefaultAsync(this System.Data.IDbConnection cnn, System.Type type, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<T> QuerySingleOrDefaultAsync<T>(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Collections.Generic.IAsyncEnumerable<dynamic> QueryUnbufferedAsync(this System.Data.Common.DbConnection cnn, string sql, object param = default(object), System.Data.Common.DbTransaction transaction = default(System.Data.Common.DbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static System.Collections.Generic.IAsyncEnumerable<T> QueryUnbufferedAsync<T>(this System.Data.Common.DbConnection cnn, string sql, object param = default(object), System.Data.Common.DbTransaction transaction = default(System.Data.Common.DbTransaction), int? commandTimeout = default(int?), System.Data.CommandType? commandType = default(System.Data.CommandType?)) => throw null;
        public static char ReadChar(object value) => throw null;
        public static char? ReadNullableChar(object value) => throw null;
        public static void RemoveTypeMap(System.Type type) => throw null;
        public static void ReplaceLiterals(this Dapper.SqlMapper.IParameterLookup parameters, System.Data.IDbCommand command) => throw null;
        public static void ResetTypeHandlers() => throw null;
        public static object SanitizeParameterValue(object value) => throw null;
        public static void SetDbType(System.Data.IDataParameter parameter, object value) => throw null;
        public static class Settings
        {
            public static bool ApplyNullValues { get => throw null; set { } }
            public static int? CommandTimeout { get => throw null; set { } }
            public static long FetchSize { get => throw null; set { } }
            public static int InListStringSplitCount { get => throw null; set { } }
            public static bool PadListExpansions { get => throw null; set { } }
            public static void SetDefaults() => throw null;
            public static bool SupportLegacyParameterTokens { get => throw null; set { } }
            public static bool UseIncrementalPseudoPositionalParameterNames { get => throw null; set { } }
            public static bool UseSingleResultOptimization { get => throw null; set { } }
            public static bool UseSingleRowOptimization { get => throw null; set { } }
        }
        public static void SetTypeMap(System.Type type, Dapper.SqlMapper.ITypeMap map) => throw null;
        public static void SetTypeName(this System.Data.DataTable table, string typeName) => throw null;
        public abstract class StringTypeHandler<T> : Dapper.SqlMapper.TypeHandler<T>
        {
            protected StringTypeHandler() => throw null;
            protected abstract string Format(T xml);
            protected abstract T Parse(string xml);
            public override T Parse(object value) => throw null;
            public override void SetValue(System.Data.IDbDataParameter parameter, T value) => throw null;
        }
        public static void ThrowDataException(System.Exception ex, int index, System.Data.IDataReader reader, object value) => throw null;
        public static void ThrowNullCustomQueryParameter(string name) => throw null;
        public abstract class TypeHandler<T> : Dapper.SqlMapper.ITypeHandler
        {
            protected TypeHandler() => throw null;
            public abstract T Parse(object value);
            object Dapper.SqlMapper.ITypeHandler.Parse(System.Type destinationType, object value) => throw null;
            public abstract void SetValue(System.Data.IDbDataParameter parameter, T value);
            void Dapper.SqlMapper.ITypeHandler.SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
        }
        public static class TypeHandlerCache<T>
        {
            public static T Parse(object value) => throw null;
            public static void SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
        }
        public static System.Func<System.Type, Dapper.SqlMapper.ITypeMap> TypeMapProvider;
        public class UdtTypeHandler : Dapper.SqlMapper.ITypeHandler
        {
            public UdtTypeHandler(string udtTypeName) => throw null;
            object Dapper.SqlMapper.ITypeHandler.Parse(System.Type destinationType, object value) => throw null;
            void Dapper.SqlMapper.ITypeHandler.SetValue(System.Data.IDbDataParameter parameter, object value) => throw null;
        }
    }
}
