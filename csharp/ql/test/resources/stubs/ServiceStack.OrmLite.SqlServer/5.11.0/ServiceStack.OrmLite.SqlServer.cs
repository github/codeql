// This file contains auto-generated code.

namespace ServiceStack
{
    namespace OrmLite
    {
        // Generated from `ServiceStack.OrmLite.SqlServer2008Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2008Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2008OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServer2012Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2012Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServer2014Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2014Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServer2016Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2016Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServer2017Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2017Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServer2019Dialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServer2019Dialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        // Generated from `ServiceStack.OrmLite.SqlServerDialect` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SqlServerDialect
        {
            public static ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider Instance { get => throw null; }
            public static ServiceStack.OrmLite.IOrmLiteDialectProvider Provider { get => throw null; }
        }

        namespace SqlServer
        {
            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2008OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2008OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider
            {
                public static ServiceStack.OrmLite.SqlServer.SqlServer2008OrmLiteDialectProvider Instance;
                public override string SqlConcat(System.Collections.Generic.IEnumerable<object> args) => throw null;
                public SqlServer2008OrmLiteDialectProvider() => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2012OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider
            {
                public override void AppendFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef, System.Data.IDbCommand cmd) => throw null;
                public override void AppendNullFieldCondition(System.Text.StringBuilder sqlFilter, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override bool DoesSequenceExist(System.Data.IDbCommand dbCmd, string sequenceName) => throw null;
                public override System.Threading.Tasks.Task<bool> DoesSequenceExistAsync(System.Data.IDbCommand dbCmd, string sequenceName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                protected override string GetAutoIncrementDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider Instance;
                public override System.Collections.Generic.List<string> SequenceList(System.Type tableType) => throw null;
                protected override bool ShouldSkipInsert(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public SqlServer2012OrmLiteDialectProvider() => throw null;
                protected override bool SupportsSequences(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToCreateSequenceStatement(System.Type tableType, string sequenceName) => throw null;
                public override System.Collections.Generic.List<string> ToCreateSequenceStatements(System.Type tableType) => throw null;
                public override string ToCreateTableStatement(System.Type tableType) => throw null;
                public override string ToSelectStatement(ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?)) => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2014OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2012OrmLiteDialectProvider
            {
                public override string GetColumnDefinition(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public static ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider Instance;
                public SqlServer2014OrmLiteDialectProvider() => throw null;
                public override string ToCreateTableStatement(System.Type tableType) => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2016Expression<>` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2016Expression<T> : ServiceStack.OrmLite.SqlServer.SqlServerExpression<T>
            {
                public SqlServer2016Expression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
                protected override object VisitSqlMethodCall(System.Linq.Expressions.MethodCallExpression m) => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2016OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2014OrmLiteDialectProvider
            {
                public static ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider Instance;
                public override ServiceStack.OrmLite.SqlExpression<T> SqlExpression<T>() => throw null;
                public SqlServer2016OrmLiteDialectProvider() => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2017OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2016OrmLiteDialectProvider
            {
                public static ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider Instance;
                public SqlServer2017OrmLiteDialectProvider() => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServer2019OrmLiteDialectProvider : ServiceStack.OrmLite.SqlServer.SqlServer2017OrmLiteDialectProvider
            {
                public static ServiceStack.OrmLite.SqlServer.SqlServer2019OrmLiteDialectProvider Instance;
                public SqlServer2019OrmLiteDialectProvider() => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServerExpression<>` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServerExpression<T> : ServiceStack.OrmLite.SqlExpression<T>
            {
                protected override void ConvertToPlaceholderAndParameter(ref object right) => throw null;
                public override string GetSubstringSql(object quotedColumn, int startIndex, int? length = default(int?)) => throw null;
                public override void PrepareUpdateStatement(System.Data.IDbCommand dbCmd, T item, bool excludeDefaults = default(bool)) => throw null;
                public SqlServerExpression(ServiceStack.OrmLite.IOrmLiteDialectProvider dialectProvider) : base(default(ServiceStack.OrmLite.IOrmLiteDialectProvider)) => throw null;
                public override string ToDeleteRowStatement() => throw null;
                protected override ServiceStack.OrmLite.PartialSqlString ToLengthPartialString(object arg) => throw null;
                protected override void VisitFilter(string operand, object originalLeft, object originalRight, ref object left, ref object right) => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServerOrmLiteDialectProvider : ServiceStack.OrmLite.OrmLiteDialectProviderBase<ServiceStack.OrmLite.SqlServer.SqlServerOrmLiteDialectProvider>
            {
                public override System.Data.IDbConnection CreateConnection(string connectionString, System.Collections.Generic.Dictionary<string, string> options) => throw null;
                public override System.Data.IDbDataParameter CreateParam() => throw null;
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
                public override bool HasInsertReturnValues(ServiceStack.OrmLite.ModelDefinition modelDef) => throw null;
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
                public SqlServerOrmLiteDialectProvider() => throw null;
                protected virtual bool SupportsSequences(ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToAddColumnStatement(System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToAlterColumnStatement(System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef) => throw null;
                public override string ToChangeColumnNameStatement(System.Type modelType, ServiceStack.OrmLite.FieldDefinition fieldDef, string oldColumnName) => throw null;
                public override string ToCreateSchemaStatement(string schemaName) => throw null;
                public override string ToInsertRowStatement(System.Data.IDbCommand cmd, object objWithProperties, System.Collections.Generic.ICollection<string> insertFields = default(System.Collections.Generic.ICollection<string>)) => throw null;
                public override string ToSelectStatement(ServiceStack.OrmLite.ModelDefinition modelDef, string selectExpression, string bodyExpression, string orderByExpression = default(string), int? offset = default(int?), int? rows = default(int?)) => throw null;
                public override string ToTableNamesStatement(string schema) => throw null;
                public override string ToTableNamesWithRowCountsStatement(bool live, string schema) => throw null;
                protected System.Data.SqlClient.SqlDataReader Unwrap(System.Data.IDataReader reader) => throw null;
                protected System.Data.SqlClient.SqlConnection Unwrap(System.Data.IDbConnection db) => throw null;
                protected System.Data.SqlClient.SqlCommand Unwrap(System.Data.IDbCommand cmd) => throw null;
                public static string UseAliasesOrStripTablePrefixes(string selectExpression) => throw null;
            }

            // Generated from `ServiceStack.OrmLite.SqlServer.SqlServerTableHint` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class SqlServerTableHint
            {
                public static ServiceStack.OrmLite.JoinFormatDelegate NoLock;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadCommitted;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadPast;
                public static ServiceStack.OrmLite.JoinFormatDelegate ReadUncommitted;
                public static ServiceStack.OrmLite.JoinFormatDelegate RepeatableRead;
                public static ServiceStack.OrmLite.JoinFormatDelegate Serializable;
                public SqlServerTableHint() => throw null;
            }

            namespace Converters
            {
                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlJsonAttribute` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlJsonAttribute : System.Attribute
                {
                    public SqlJsonAttribute() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerBoolConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerBoolConverter : ServiceStack.OrmLite.Converters.BoolConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public override System.Data.DbType DbType { get => throw null; }
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public SqlServerBoolConverter() => throw null;
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerByteArrayConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerByteArrayConverter : ServiceStack.OrmLite.Converters.ByteArrayConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerByteArrayConverter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerDateTime2Converter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerDateTime2Converter : ServiceStack.OrmLite.SqlServer.Converters.SqlServerDateTimeConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public override System.Data.DbType DbType { get => throw null; }
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public SqlServerDateTime2Converter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerDateTimeConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerDateTimeConverter : ServiceStack.OrmLite.Converters.DateTimeConverter
                {
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public SqlServerDateTimeConverter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerDecimalConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerDecimalConverter : ServiceStack.OrmLite.Converters.DecimalConverter
                {
                    public SqlServerDecimalConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerDoubleConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerDoubleConverter : ServiceStack.OrmLite.Converters.DoubleConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerDoubleConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerFloatConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerFloatConverter : ServiceStack.OrmLite.Converters.FloatConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerFloatConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerGuidConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerGuidConverter : ServiceStack.OrmLite.Converters.GuidConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerGuidConverter() => throw null;
                    public override string ToQuotedString(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerJsonStringConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerJsonStringConverter : ServiceStack.OrmLite.SqlServer.Converters.SqlServerStringConverter
                {
                    public override object FromDbValue(System.Type fieldType, object value) => throw null;
                    public SqlServerJsonStringConverter() => throw null;
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerRowVersionConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerRowVersionConverter : ServiceStack.OrmLite.Converters.RowVersionConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public SqlServerRowVersionConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerSByteConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerSByteConverter : ServiceStack.OrmLite.Converters.SByteConverter
                {
                    public override System.Data.DbType DbType { get => throw null; }
                    public SqlServerSByteConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerStringConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerStringConverter : ServiceStack.OrmLite.Converters.StringConverter
                {
                    public override string GetColumnDefinition(int? stringLength) => throw null;
                    public override void InitDbParam(System.Data.IDbDataParameter p, System.Type fieldType) => throw null;
                    public override string MaxColumnDefinition { get => throw null; }
                    public override int MaxVarCharLength { get => throw null; }
                    public SqlServerStringConverter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerTimeConverter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerTimeConverter : ServiceStack.OrmLite.OrmLiteConverter
                {
                    public override string ColumnDefinition { get => throw null; }
                    public override System.Data.DbType DbType { get => throw null; }
                    public int? Precision { get => throw null; set => throw null; }
                    public SqlServerTimeConverter() => throw null;
                    public override object ToDbValue(System.Type fieldType, object value) => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerUInt16Converter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerUInt16Converter : ServiceStack.OrmLite.Converters.UInt16Converter
                {
                    public override System.Data.DbType DbType { get => throw null; }
                    public SqlServerUInt16Converter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerUInt32Converter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerUInt32Converter : ServiceStack.OrmLite.Converters.UInt32Converter
                {
                    public override System.Data.DbType DbType { get => throw null; }
                    public SqlServerUInt32Converter() => throw null;
                }

                // Generated from `ServiceStack.OrmLite.SqlServer.Converters.SqlServerUInt64Converter` in `ServiceStack.OrmLite.SqlServer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public class SqlServerUInt64Converter : ServiceStack.OrmLite.Converters.UInt64Converter
                {
                    public override System.Data.DbType DbType { get => throw null; }
                    public SqlServerUInt64Converter() => throw null;
                }

            }
        }
    }
}
