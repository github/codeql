// This file contains auto-generated code.
// Generated from `ServiceStack.OrmLite.SqlServer, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace ServiceStack
{
    namespace OrmLite
    {
        namespace SqlServer
        {
            namespace Converters
            {
                [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
                public class SqlJsonAttribute : System.Attribute
                {
                    public SqlJsonAttribute() => throw null;
                }
                public class SqlServerBoolConverter : ServiceStack.OrmLite.Converters.BoolConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerBoolConverter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerByteArrayConverter : ServiceStack.OrmLite.Converters.ByteArrayConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerByteArrayConverter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerDateTime2Converter : ServiceStack.OrmLite.SqlServer.Converters.SqlServerDateTimeConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerDateTime2Converter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerDateTimeConverter : ServiceStack.OrmLite.Converters.DateTimeConverter
                {
                    public SqlServerDateTimeConverter() => throw null;
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerDecimalConverter : ServiceStack.OrmLite.Converters.DecimalConverter
                {
                    public SqlServerDecimalConverter() => throw null;
                }
                public class SqlServerDoubleConverter : ServiceStack.OrmLite.Converters.DoubleConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerDoubleConverter() => throw null;
                }
                public class SqlServerFloatConverter : ServiceStack.OrmLite.Converters.FloatConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerFloatConverter() => throw null;
                }
                public class SqlServerGuidConverter : ServiceStack.OrmLite.Converters.GuidConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerGuidConverter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerJsonStringConverter : ServiceStack.OrmLite.SqlServer.Converters.SqlServerStringConverter
                {
                    public SqlServerJsonStringConverter() => throw null;
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerRowVersionConverter : ServiceStack.OrmLite.Converters.RowVersionConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerRowVersionConverter() => throw null;
                }
                public class SqlServerSByteConverter : ServiceStack.OrmLite.Converters.SByteConverter
                {
                    public SqlServerSByteConverter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                }
                public class SqlServerStringConverter : ServiceStack.OrmLite.Converters.StringConverter
                {
                    public SqlServerStringConverter() => throw null;
                    public override string GetColumnDefinition(int? stringLength) => throw null;
                    public override void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType) => throw null;
                    public override string MaxColumnDefinition { get => throw null; }
                    public override int MaxVarCharLength { get => throw null; }
                }
                public class SqlServerTimeConverter : ServiceStack.OrmLite.OrmLiteConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerTimeConverter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                    public int? Precision { get => throw null; set { } }
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                }
                public class SqlServerUInt16Converter : ServiceStack.OrmLite.Converters.UInt16Converter
                {
                    public SqlServerUInt16Converter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                }
                public class SqlServerUInt32Converter : ServiceStack.OrmLite.Converters.UInt32Converter
                {
                    public SqlServerUInt32Converter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                }
                public class SqlServerUInt64Converter : ServiceStack.OrmLite.Converters.UInt64Converter
                {
                    public SqlServerUInt64Converter() => throw null;
                    public override System.Data.DbType DbType { get => throw null; }
                }
            }
            public class SqlServer2008OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider
            {
                public SqlServer2008OrmLiteDialectProvider() => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2008OrmLiteDialectProvider Instance;
                public override string SqlConcat(System.Collections.Generic.IEnumerable<object> args) => throw null;
            }
            public class SqlServer2012OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider
            {
                public override void AppendFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDbCommand cmd) => throw null;
                public override void AppendNullFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public SqlServer2012OrmLiteDialectProvider() => throw null;
                public override bool DoesSequenceExist(System.Data.IDbCommand dbCmd, string sequence) => throw null;
                public override System.Threading.Tasks.Task<bool> DoesSequenceExistAsync(System.Data.IDbCommand dbCmd, string sequenceName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                protected override string GetAutoIncrementDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider Instance;
                public override System.Collections.Generic.List<string> SequenceList(System.Type tableType) => throw null;
                protected override bool ShouldSkipInsert(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                protected override bool SupportsSequences(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToCreateSequenceStatement(System.Type tableType, string sequenceName) => throw null;
                public override System.Collections.Generic.List<string> ToCreateSequenceStatements(System.Type tableType) => throw null;
                public override string ToCreateTableStatement(System.Type tableType) => throw null;
                public override string ToSelectStatement(ServiceStack.OrmLite.QueryType queryType, ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?), System.Collections.Generic.ISet<string> tags = default(System.Collections.Generic.ISet<string>)) => throw null;
            }
            public class SqlServer2014OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider
            {
                public SqlServer2014OrmLiteDialectProvider() => throw null;
                public override string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider Instance;
                public override string ToCreateTableStatement(System.Type tableType) => throw null;
            }
            public class SqlServer2016Expression<T> : ServiceStack.OrmLite.SqlServer.SqlServerExpression<T>
            {
                public SqlServer2016Expression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
                protected override object VisitSqlMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            }
            public class SqlServer2016OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider
            {
                public SqlServer2016OrmLiteDialectProvider() => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider Instance;
                public override ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>() => throw null;
            }
            public class SqlServer2017OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider
            {
                public SqlServer2017OrmLiteDialectProvider() => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider Instance;
            }
            public class SqlServer2019OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider
            {
                public SqlServer2019OrmLiteDialectProvider() => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider Instance;
            }
            public class SqlServer2022OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider
            {
                public SqlServer2022OrmLiteDialectProvider() => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2022OrmLiteDialectProvider Instance;
            }
            public class SqlServerExpression<T> : ServiceStack.OrmLite.SqlExpression<T>
            {
                protected override void ConvertToPlaceholderAndParameter(ref object right) => throw null;
                public SqlServerExpression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
                public override string GetSubstringSql(object quotedColumn, int startIndex, int? length = default(int?)) => throw null;
                public override void PrepareUpdateStatement(System.Data.IDbCommand dbCmd, T item, bool excludeDefaults = default(bool)) => throw null;
                public override string ToDeleteRowStatement() => throw null;
                protected override ServiceStack.OrmLite.PartialSqlString ToLengthPartialString(object arg) => throw null;
                protected override void VisitFilter(string operand, object originalLeft, object originalRight, ref object left, ref object right) => throw null;
            }
            public class SqlServerOrmLiteDialectProvider : ServiceStack.OrmLite.OrmLiteDialectProviderBase<ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider>
            {
                public override void BulkInsert<T>(System.Data.IDbConnection db, System.Collections.Generic.IEnumerable<T> objs, ServiceStack.OrmLite.BulkInsertConfig config = default(ServiceStack.OrmLite.BulkInsertConfig)) => throw null;
                public override System.Data.IDbConnection CreateConnection(string connectionString, System.Collections.Generic.Dictionary<string, string> options) => throw null;
                public override System.Data.IDbDataParameter CreateParam() => throw null;
                public SqlServerOrmLiteDialectProvider() => throw null;
                public override void DisableForeignKeysCheck(System.Data.IDbCommand cmd) => throw null;
                public override System.Threading.Tasks.Task DisableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override void DisableIdentityInsert<T>(System.Data.IDbCommand cmd) => throw null;
                public override System.Threading.Tasks.Task DisableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override bool DoesColumnExist(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string)) => throw null;
                public override System.Threading.Tasks.Task<bool> DoesColumnExistAsync(System.Data.IDbConnection db, string columnName, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override bool DoesSchemaExist(System.Data.IDbCommand dbCmd, string schemaName) => throw null;
                public override System.Threading.Tasks.Task<bool> DoesSchemaExistAsync(System.Data.IDbCommand dbCmd, string schemaName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override bool DoesTableExist(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string)) => throw null;
                public override System.Threading.Tasks.Task<bool> DoesTableExistAsync(System.Data.IDbCommand dbCmd, string tableName, string schema = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override void EnableForeignKeysCheck(System.Data.IDbCommand cmd) => throw null;
                public override System.Threading.Tasks.Task EnableForeignKeysCheckAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override void EnableIdentityInsert<T>(System.Data.IDbCommand cmd) => throw null;
                public override System.Threading.Tasks.Task EnableIdentityInsertAsync<T>(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<System.Data.IDataReader> ExecuteReaderAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<object> ExecuteScalarAsync(System.Data.IDbCommand cmd, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override string GetAutoIdDefaultValue(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                protected virtual string GetAutoIncrementDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string GetDropForeignKeyConstraints(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
                public override string GetForeignKeyOnDeleteClause(ServiceStack.OrmLite.ForeignKeyConstraint foreignKey) => throw null;
                public override string GetForeignKeyOnUpdateClause(ServiceStack.OrmLite.ForeignKeyConstraint foreignKey) => throw null;
                public override string GetLoadChildrenSubSelect<From>(ServiceStack.OrmLite.SqlExpression<From> expr) => throw null;
                public override string GetQuotedValue(string paramValue) => throw null;
                public override System.Collections.Generic.List<string> GetSchemas(System.Data.IDbCommand dbCmd) => throw null;
                public override System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> GetSchemaTables(System.Data.IDbCommand dbCmd) => throw null;
                public override bool HasInsertReturnValues(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
                public override void InitConnection(System.Data.IDbConnection dbConn) => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider Instance;
                public override System.Threading.Tasks.Task OpenAsync(System.Data.IDbConnection db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override void PrepareInsertRowStatement<T>(System.Data.IDbCommand dbCmd, System.Collections.Generic.Dictionary<string, object> args) => throw null;
                public override void PrepareParameterizedInsertStatement<T>(System.Data.IDbCommand cmd, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>), System.Func<ServiceStack.OrmLite.FieldDefinition, bool> shouldInclude = default(System.Func<ServiceStack.OrmLite.FieldDefinition, bool>)) => throw null;
                public override System.Threading.Tasks.Task<bool> ReadAsync(System.Data.IDataReader reader, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<System.Collections.Generic.List<T>> ReaderEach<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<Return> ReaderEach<Return>(System.Data.IDataReader reader, System.Action fn, Return source, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.Task<T> ReaderRead<T>(System.Data.IDataReader reader, System.Func<T> fn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                protected string Sequence(string schema, string sequence) => throw null;
                protected virtual bool ShouldReturnOnInsert(ServiceStack.OrmLite.ModelDefinition modelDef, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                protected override bool ShouldSkipInsert(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string SqlBool(bool value) => throw null;
                public override string SqlCast(object fieldOrValue, string castAs) => throw null;
                public override string SqlCurrency(string fieldOrValue, string currencySymbol) => throw null;
                public override ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>() => throw null;
                public override string SqlLimit(int? offset = default(int?), int? rows = default(int?)) => throw null;
                public override string SqlRandom { get => throw null; }
                protected static string SqlTop(string sql, int take, string selectType = default(string)) => throw null;
                protected virtual bool SupportsSequences(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToAddColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToAlterColumnStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToChangeColumnNameStatement(string schema, string table, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumn) => throw null;
                public override string ToCreateSavePoint(string name) => throw null;
                public override string ToCreateSchemaStatement(string schemaName) => throw null;
                public override string ToInsertRowStatement(System.Data.IDbCommand cmd, object objWithProperties, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
                public override string ToReleaseSavePoint(string name) => throw null;
                public override string ToRenameColumnStatement(string schema, string table, string oldColumn, string newColumn) => throw null;
                public override string ToRollbackSavePoint(string name) => throw null;
                public override string ToSelectStatement(ServiceStack.OrmLite.QueryType queryType, ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?), System.Collections.Generic.ISet<string> tags = default(System.Collections.Generic.ISet<string>)) => throw null;
                public override string ToTableNamesStatement(string schema) => throw null;
                public override string ToTableNamesWithRowCountsStatement(bool live, string schema) => throw null;
                protected System.Data.Common.DbConnection Unwrap(System.Data.IDbConnection db) => throw null;
                protected System.Data.Common.DbCommand Unwrap(System.Data.IDbCommand cmd) => throw null;
                protected System.Data.Common.DbDataReader Unwrap(System.Data.IDataReader reader) => throw null;
                public static string UseAliasesOrStripTablePrefixes(string selectExpression) => throw null;
            }
            public class SqlServerTableHint
            {
                public SqlServerTableHint() => throw null;
                public static ServiceStack.OrmLite.JoinFormatDelegate NoLock;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadCommitted;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadPast;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadUncommitted;
                public static ServiceStack.OrmLite.JoinFormatDelegate RepeatableRead;
                public static ServiceStack.OrmLite.JoinFormatDelegate Serializable;
            }
        }
        public static class SqlServer2008Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2008OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2012Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2014Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2016Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2017Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2019Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServer2022Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2022OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
        public static class SqlServerDialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }
    }
}
