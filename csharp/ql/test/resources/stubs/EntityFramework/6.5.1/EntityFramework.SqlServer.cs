// This file contains auto-generated code.
// Generated from `EntityFramework.SqlServer, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`.
namespace System
{
    namespace Data
    {
        namespace Entity
        {
            namespace SqlServer
            {
                public class SqlAzureExecutionStrategy : System.Data.Entity.Infrastructure.DbExecutionStrategy
                {
                    public SqlAzureExecutionStrategy() => throw null;
                    public SqlAzureExecutionStrategy(int maxRetryCount, System.TimeSpan maxDelay) => throw null;
                    protected override bool ShouldRetryOn(System.Exception exception) => throw null;
                }
                public static class SqlFunctions
                {
                    public static double? Acos(double? arg1) => throw null;
                    public static double? Acos(decimal? arg1) => throw null;
                    public static int? Ascii(string arg) => throw null;
                    public static double? Asin(double? arg) => throw null;
                    public static double? Asin(decimal? arg) => throw null;
                    public static double? Atan(double? arg) => throw null;
                    public static double? Atan(decimal? arg) => throw null;
                    public static double? Atan2(double? arg1, double? arg2) => throw null;
                    public static double? Atan2(decimal? arg1, decimal? arg2) => throw null;
                    public static string Char(int? arg) => throw null;
                    public static int? CharIndex(string toFind, string toSearch) => throw null;
                    public static int? CharIndex(byte[] toFind, byte[] toSearch) => throw null;
                    public static int? CharIndex(string toFind, string toSearch, int? startLocation) => throw null;
                    public static int? CharIndex(byte[] toFind, byte[] toSearch, int? startLocation) => throw null;
                    public static long? CharIndex(string toFind, string toSearch, long? startLocation) => throw null;
                    public static long? CharIndex(byte[] toFind, byte[] toSearch, long? startLocation) => throw null;
                    public static int? Checksum(bool? arg1) => throw null;
                    public static int? Checksum(double? arg1) => throw null;
                    public static int? Checksum(decimal? arg1) => throw null;
                    public static int? Checksum(string arg1) => throw null;
                    public static int? Checksum(System.DateTime? arg1) => throw null;
                    public static int? Checksum(System.TimeSpan? arg1) => throw null;
                    public static int? Checksum(System.DateTimeOffset? arg1) => throw null;
                    public static int? Checksum(byte[] arg1) => throw null;
                    public static int? Checksum(System.Guid? arg1) => throw null;
                    public static int? Checksum(bool? arg1, bool? arg2) => throw null;
                    public static int? Checksum(double? arg1, double? arg2) => throw null;
                    public static int? Checksum(decimal? arg1, decimal? arg2) => throw null;
                    public static int? Checksum(string arg1, string arg2) => throw null;
                    public static int? Checksum(System.DateTime? arg1, System.DateTime? arg2) => throw null;
                    public static int? Checksum(System.TimeSpan? arg1, System.TimeSpan? arg2) => throw null;
                    public static int? Checksum(System.DateTimeOffset? arg1, System.DateTimeOffset? arg2) => throw null;
                    public static int? Checksum(byte[] arg1, byte[] arg2) => throw null;
                    public static int? Checksum(System.Guid? arg1, System.Guid? arg2) => throw null;
                    public static int? Checksum(bool? arg1, bool? arg2, bool? arg3) => throw null;
                    public static int? Checksum(double? arg1, double? arg2, double? arg3) => throw null;
                    public static int? Checksum(decimal? arg1, decimal? arg2, decimal? arg3) => throw null;
                    public static int? Checksum(string arg1, string arg2, string arg3) => throw null;
                    public static int? Checksum(System.DateTime? arg1, System.DateTime? arg2, System.DateTime? arg3) => throw null;
                    public static int? Checksum(System.DateTimeOffset? arg1, System.DateTimeOffset? arg2, System.DateTimeOffset? arg3) => throw null;
                    public static int? Checksum(System.TimeSpan? arg1, System.TimeSpan? arg2, System.TimeSpan? arg3) => throw null;
                    public static int? Checksum(byte[] arg1, byte[] arg2, byte[] arg3) => throw null;
                    public static int? Checksum(System.Guid? arg1, System.Guid? arg2, System.Guid? arg3) => throw null;
                    public static int? ChecksumAggregate(System.Collections.Generic.IEnumerable<int> arg) => throw null;
                    public static int? ChecksumAggregate(System.Collections.Generic.IEnumerable<int?> arg) => throw null;
                    public static double? Cos(double? arg) => throw null;
                    public static double? Cos(decimal? arg) => throw null;
                    public static double? Cot(double? arg) => throw null;
                    public static double? Cot(decimal? arg) => throw null;
                    public static System.DateTime? CurrentTimestamp() => throw null;
                    public static string CurrentUser() => throw null;
                    public static int? DataLength(bool? arg) => throw null;
                    public static int? DataLength(double? arg) => throw null;
                    public static int? DataLength(decimal? arg) => throw null;
                    public static int? DataLength(System.DateTime? arg) => throw null;
                    public static int? DataLength(System.TimeSpan? arg) => throw null;
                    public static int? DataLength(System.DateTimeOffset? arg) => throw null;
                    public static int? DataLength(string arg) => throw null;
                    public static int? DataLength(byte[] arg) => throw null;
                    public static int? DataLength(System.Guid? arg) => throw null;
                    public static System.DateTime? DateAdd(string datePartArg, double? number, System.DateTime? date) => throw null;
                    public static System.TimeSpan? DateAdd(string datePartArg, double? number, System.TimeSpan? time) => throw null;
                    public static System.DateTimeOffset? DateAdd(string datePartArg, double? number, System.DateTimeOffset? dateTimeOffsetArg) => throw null;
                    public static System.DateTime? DateAdd(string datePartArg, double? number, string date) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTime? startDate, System.DateTime? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTimeOffset? startDate, System.DateTimeOffset? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.TimeSpan? startDate, System.TimeSpan? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, string startDate, System.DateTime? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, string startDate, System.DateTimeOffset? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, string startDate, System.TimeSpan? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.TimeSpan? startDate, string endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTime? startDate, string endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTimeOffset? startDate, string endDate) => throw null;
                    public static int? DateDiff(string datePartArg, string startDate, string endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.TimeSpan? startDate, System.DateTime? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.TimeSpan? startDate, System.DateTimeOffset? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTime? startDate, System.TimeSpan? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTimeOffset? startDate, System.TimeSpan? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTime? startDate, System.DateTimeOffset? endDate) => throw null;
                    public static int? DateDiff(string datePartArg, System.DateTimeOffset? startDate, System.DateTime? endDate) => throw null;
                    public static string DateName(string datePartArg, System.DateTime? date) => throw null;
                    public static string DateName(string datePartArg, string date) => throw null;
                    public static string DateName(string datePartArg, System.TimeSpan? date) => throw null;
                    public static string DateName(string datePartArg, System.DateTimeOffset? date) => throw null;
                    public static int? DatePart(string datePartArg, System.DateTime? date) => throw null;
                    public static int? DatePart(string datePartArg, System.DateTimeOffset? date) => throw null;
                    public static int? DatePart(string datePartArg, string date) => throw null;
                    public static int? DatePart(string datePartArg, System.TimeSpan? date) => throw null;
                    public static int? Degrees(int? arg1) => throw null;
                    public static long? Degrees(long? arg1) => throw null;
                    public static decimal? Degrees(decimal? arg1) => throw null;
                    public static double? Degrees(double? arg1) => throw null;
                    public static int? Difference(string string1, string string2) => throw null;
                    public static double? Exp(double? arg) => throw null;
                    public static double? Exp(decimal? arg) => throw null;
                    public static System.DateTime? GetDate() => throw null;
                    public static System.DateTime? GetUtcDate() => throw null;
                    public static string HostName() => throw null;
                    public static int? IsDate(string arg) => throw null;
                    public static int? IsNumeric(string arg) => throw null;
                    public static double? Log(double? arg) => throw null;
                    public static double? Log(decimal? arg) => throw null;
                    public static double? Log10(double? arg) => throw null;
                    public static double? Log10(decimal? arg) => throw null;
                    public static string NChar(int? arg) => throw null;
                    public static int? PatIndex(string stringPattern, string target) => throw null;
                    public static double? Pi() => throw null;
                    public static string QuoteName(string stringArg) => throw null;
                    public static string QuoteName(string stringArg, string quoteCharacter) => throw null;
                    public static int? Radians(int? arg) => throw null;
                    public static long? Radians(long? arg) => throw null;
                    public static decimal? Radians(decimal? arg) => throw null;
                    public static double? Radians(double? arg) => throw null;
                    public static double? Rand() => throw null;
                    public static double? Rand(int? seed) => throw null;
                    public static string Replicate(string target, int? count) => throw null;
                    public static int? Sign(int? arg) => throw null;
                    public static long? Sign(long? arg) => throw null;
                    public static decimal? Sign(decimal? arg) => throw null;
                    public static double? Sign(double? arg) => throw null;
                    public static double? Sin(decimal? arg) => throw null;
                    public static double? Sin(double? arg) => throw null;
                    public static string SoundCode(string arg) => throw null;
                    public static string Space(int? arg1) => throw null;
                    public static double? Square(double? arg1) => throw null;
                    public static double? Square(decimal? arg1) => throw null;
                    public static double? SquareRoot(double? arg) => throw null;
                    public static double? SquareRoot(decimal? arg) => throw null;
                    public static string StringConvert(double? number) => throw null;
                    public static string StringConvert(decimal? number) => throw null;
                    public static string StringConvert(double? number, int? length) => throw null;
                    public static string StringConvert(decimal? number, int? length) => throw null;
                    public static string StringConvert(double? number, int? length, int? decimalArg) => throw null;
                    public static string StringConvert(decimal? number, int? length, int? decimalArg) => throw null;
                    public static string Stuff(string stringInput, int? start, int? length, string stringReplacement) => throw null;
                    public static double? Tan(double? arg) => throw null;
                    public static double? Tan(decimal? arg) => throw null;
                    public static int? Unicode(string arg) => throw null;
                    public static string UserName(int? arg) => throw null;
                    public static string UserName() => throw null;
                }
                public static class SqlHierarchyIdFunctions
                {
                    public static System.Data.Entity.Hierarchy.HierarchyId GetAncestor(System.Data.Entity.Hierarchy.HierarchyId hierarchyIdValue, int n) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId GetDescendant(System.Data.Entity.Hierarchy.HierarchyId hierarchyIdValue, System.Data.Entity.Hierarchy.HierarchyId child1, System.Data.Entity.Hierarchy.HierarchyId child2) => throw null;
                    public static short GetLevel(System.Data.Entity.Hierarchy.HierarchyId hierarchyIdValue) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId GetReparentedValue(System.Data.Entity.Hierarchy.HierarchyId hierarchyIdValue, System.Data.Entity.Hierarchy.HierarchyId oldRoot, System.Data.Entity.Hierarchy.HierarchyId newRoot) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId GetRoot() => throw null;
                    public static bool IsDescendantOf(System.Data.Entity.Hierarchy.HierarchyId hierarchyIdValue, System.Data.Entity.Hierarchy.HierarchyId parent) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId Parse(string input) => throw null;
                }
                public sealed class SqlProviderServices : System.Data.Entity.Core.Common.DbProviderServices
                {
                    protected override System.Data.Common.DbCommand CloneDbCommand(System.Data.Common.DbCommand fromDbCommand) => throw null;
                    public override System.Data.Common.DbConnection CloneDbConnection(System.Data.Common.DbConnection connection, System.Data.Common.DbProviderFactory factory) => throw null;
                    protected override System.Data.Entity.Core.Common.DbCommandDefinition CreateDbCommandDefinition(System.Data.Entity.Core.Common.DbProviderManifest providerManifest, System.Data.Entity.Core.Common.CommandTrees.DbCommandTree commandTree) => throw null;
                    protected override void DbCreateDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                    protected override string DbCreateDatabaseScript(string providerManifestToken, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                    protected override bool DbDatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                    protected override bool DbDatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Lazy<System.Data.Entity.Core.Metadata.Edm.StoreItemCollection> storeItemCollection) => throw null;
                    protected override void DbDeleteDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                    protected override System.Data.Entity.Spatial.DbSpatialServices DbGetSpatialServices(string versionHint) => throw null;
                    protected override System.Data.Entity.Core.Common.DbProviderManifest GetDbProviderManifest(string versionHint) => throw null;
                    protected override string GetDbProviderManifestToken(System.Data.Common.DbConnection connection) => throw null;
                    protected override System.Data.Entity.Spatial.DbSpatialDataReader GetDbSpatialDataReader(System.Data.Common.DbDataReader fromReader, string versionHint) => throw null;
                    public static System.Data.Entity.SqlServer.SqlProviderServices Instance { get => throw null; }
                    public const string ProviderInvariantName = default;
                    public override void RegisterInfoMessageHandler(System.Data.Common.DbConnection connection, System.Action<string> handler) => throw null;
                    protected override void SetDbParameterValue(System.Data.Common.DbParameter parameter, System.Data.Entity.Core.Metadata.Edm.TypeUsage parameterType, object value) => throw null;
                    public static string SqlServerTypesAssemblyName { get => throw null; set { } }
                    public static bool TruncateDecimalsToScale { get => throw null; set { } }
                    public static bool UseRowNumberOrderingInOffsetQueries { get => throw null; set { } }
                    public static bool UseScopeIdentity { get => throw null; set { } }
                }
                public class SqlServerMigrationSqlGenerator : System.Data.Entity.Migrations.Sql.MigrationSqlGenerator
                {
                    protected virtual string BuildColumnType(System.Data.Entity.Migrations.Model.ColumnModel columnModel) => throw null;
                    protected virtual System.Data.Common.DbConnection CreateConnection() => throw null;
                    public SqlServerMigrationSqlGenerator() => throw null;
                    protected virtual void DropDefaultConstraint(string table, string column, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    public override System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Sql.MigrationStatement> Generate(System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> migrationOperations, string providerManifestToken) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.UpdateDatabaseOperation updateDatabaseOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.MigrationOperation migrationOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateProcedureOperation createProcedureOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterProcedureOperation alterProcedureOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropProcedureOperation dropProcedureOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterTableOperation alterTableOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AddForeignKeyOperation addForeignKeyOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropForeignKeyOperation dropForeignKeyOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateIndexOperation createIndexOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropIndexOperation dropIndexOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation addPrimaryKeyOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropPrimaryKeyOperation dropPrimaryKeyOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AddColumnOperation addColumnOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropColumnOperation dropColumnOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterColumnOperation alterColumnOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.DropTableOperation dropTableOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.SqlOperation sqlOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameColumnOperation renameColumnOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameIndexOperation renameIndexOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameTableOperation renameTableOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameProcedureOperation renameProcedureOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveProcedureOperation moveProcedureOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveTableOperation moveTableOperation) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.ColumnModel column, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    protected virtual void Generate(System.Data.Entity.Migrations.Model.HistoryOperation historyOperation) => throw null;
                    protected virtual string Generate(byte[] defaultValue) => throw null;
                    protected virtual string Generate(bool defaultValue) => throw null;
                    protected virtual string Generate(System.DateTime defaultValue) => throw null;
                    protected virtual string Generate(System.DateTimeOffset defaultValue) => throw null;
                    protected virtual string Generate(System.Guid defaultValue) => throw null;
                    protected virtual string Generate(string defaultValue) => throw null;
                    protected virtual string Generate(System.TimeSpan defaultValue) => throw null;
                    protected virtual string Generate(System.Data.Entity.Hierarchy.HierarchyId defaultValue) => throw null;
                    protected virtual string Generate(System.Data.Entity.Spatial.DbGeography defaultValue) => throw null;
                    protected virtual string Generate(System.Data.Entity.Spatial.DbGeometry defaultValue) => throw null;
                    protected virtual string Generate(object defaultValue) => throw null;
                    protected virtual void GenerateCreateSchema(string schema) => throw null;
                    protected virtual void GenerateMakeSystemTable(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    public override string GenerateProcedureBody(System.Collections.Generic.ICollection<System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree> commandTrees, string rowsAffectedParameter, string providerManifestToken) => throw null;
                    protected virtual string GuidColumnDefault { get => throw null; }
                    public override bool IsPermissionDeniedError(System.Exception exception) => throw null;
                    protected virtual string Name(string name) => throw null;
                    protected virtual string Quote(string identifier) => throw null;
                    protected void Statement(string sql, bool suppressTransaction = default(bool), string batchTerminator = default(string)) => throw null;
                    protected void Statement(System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, string batchTerminator = default(string)) => throw null;
                    protected void StatementBatch(string sqlBatch, bool suppressTransaction = default(bool)) => throw null;
                    protected virtual void WriteCreateTable(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation) => throw null;
                    protected virtual void WriteCreateTable(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    protected static System.Data.Entity.Migrations.Utilities.IndentedTextWriter Writer() => throw null;
                }
                public static class SqlSpatialFunctions
                {
                    public static string AsTextZM(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public static string AsTextZM(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography BufferWithTolerance(System.Data.Entity.Spatial.DbGeography geographyValue, double? distance, double? tolerance, bool? relative) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry BufferWithTolerance(System.Data.Entity.Spatial.DbGeometry geometryValue, double? distance, double? tolerance, bool? relative) => throw null;
                    public static double? EnvelopeAngle(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography EnvelopeCenter(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public static bool? Filter(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography geographyOther) => throw null;
                    public static bool? Filter(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry geometryOther) => throw null;
                    public static bool? InstanceOf(System.Data.Entity.Spatial.DbGeography geographyValue, string geometryTypeName) => throw null;
                    public static bool? InstanceOf(System.Data.Entity.Spatial.DbGeometry geometryValue, string geometryTypeName) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MakeValid(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public static int? NumRings(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography PointGeography(double? latitude, double? longitude, int? spatialReferenceId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry PointGeometry(double? xCoordinate, double? yCoordinate, int? spatialReferenceId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography Reduce(System.Data.Entity.Spatial.DbGeography geographyValue, double? tolerance) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry Reduce(System.Data.Entity.Spatial.DbGeometry geometryValue, double? tolerance) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography RingN(System.Data.Entity.Spatial.DbGeography geographyValue, int? index) => throw null;
                }
                public class SqlSpatialServices : System.Data.Entity.Spatial.DbSpatialServices
                {
                    public override byte[] AsBinary(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override byte[] AsBinary(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override string AsGml(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override string AsGml(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override string AsText(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override string AsText(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override string AsTextIncludingElevationAndMeasure(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override string AsTextIncludingElevationAndMeasure(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography Buffer(System.Data.Entity.Spatial.DbGeography geographyValue, double distance) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry Buffer(System.Data.Entity.Spatial.DbGeometry geometryValue, double distance) => throw null;
                    public override bool Contains(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override object CreateProviderValue(System.Data.Entity.Spatial.DbGeographyWellKnownValue wellKnownValue) => throw null;
                    public override object CreateProviderValue(System.Data.Entity.Spatial.DbGeometryWellKnownValue wellKnownValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeographyWellKnownValue CreateWellKnownValue(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometryWellKnownValue CreateWellKnownValue(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool Crosses(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography Difference(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry Difference(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override bool Disjoint(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override bool Disjoint(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override double Distance(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override double Distance(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography ElementAt(System.Data.Entity.Spatial.DbGeography geographyValue, int index) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry ElementAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyCollectionFromBinary(byte[] geographyCollectionWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyCollectionFromText(string geographyCollectionWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromBinary(byte[] wellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromBinary(byte[] wellKnownBinary) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromGml(string geographyMarkup) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromGml(string geographyMarkup, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromProviderValue(object providerValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromText(string wellKnownText) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyFromText(string wellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyLineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyLineFromText(string lineWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiLineFromText(string multiLineWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiPointFromText(string multiPointWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyMultiPolygonFromText(string multiPolygonKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyPointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyPointFromText(string pointWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyPolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GeographyPolygonFromText(string polygonWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromBinary(byte[] geometryCollectionWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromText(string geometryCollectionWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromBinary(byte[] wellKnownBinary) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromBinary(byte[] wellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromGml(string geometryMarkup) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromGml(string geometryMarkup, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromProviderValue(object providerValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromText(string wellKnownText) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryFromText(string wellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryLineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryLineFromText(string lineWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiLineFromText(string multiLineWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiPointFromText(string multiPointWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryMultiPolygonFromText(string multiPolygonKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryPointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryPointFromText(string pointWellKnownText, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryPolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GeometryPolygonFromText(string polygonWellKnownText, int coordinateSystemId) => throw null;
                    public override double? GetArea(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetArea(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetBoundary(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetCentroid(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetConvexHull(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override int GetCoordinateSystemId(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override int GetCoordinateSystemId(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override int GetDimension(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override int GetDimension(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override int? GetElementCount(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override int? GetElementCount(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override double? GetElevation(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetElevation(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GetEndPoint(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetEndPoint(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetEnvelope(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetExteriorRing(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override int? GetInteriorRingCount(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool? GetIsClosed(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override bool? GetIsClosed(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool GetIsEmpty(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override bool GetIsEmpty(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool? GetIsRing(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool GetIsSimple(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override bool GetIsValid(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override double? GetLatitude(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetLength(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetLength(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override double? GetLongitude(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetMeasure(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override double? GetMeasure(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override int? GetPointCount(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override int? GetPointCount(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetPointOnSurface(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override string GetSpatialTypeName(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override string GetSpatialTypeName(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography GetStartPoint(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry GetStartPoint(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override double? GetXCoordinate(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override double? GetYCoordinate(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry InteriorRingAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography Intersection(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry Intersection(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override bool Intersects(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override bool Intersects(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override bool NativeTypesAvailable { get => throw null; }
                    public override bool Overlaps(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography PointAt(System.Data.Entity.Spatial.DbGeography geographyValue, int index) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry PointAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index) => throw null;
                    public override bool Relate(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry, string matrix) => throw null;
                    public override bool SpatialEquals(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override bool SpatialEquals(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography SymmetricDifference(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry SymmetricDifference(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override bool Touches(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override System.Data.Entity.Spatial.DbGeography Union(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography) => throw null;
                    public override System.Data.Entity.Spatial.DbGeometry Union(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                    public override bool Within(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry) => throw null;
                }
                namespace Utilities
                {
                    public static partial class TaskExtensions
                    {
                        public struct CultureAwaiter<T> : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                        {
                            public CultureAwaiter(System.Threading.Tasks.Task<T> task) => throw null;
                            public System.Data.Entity.SqlServer.Utilities.TaskExtensions.CultureAwaiter<T> GetAwaiter() => throw null;
                            public T GetResult() => throw null;
                            public bool IsCompleted { get => throw null; }
                            public void OnCompleted(System.Action continuation) => throw null;
                            public void UnsafeOnCompleted(System.Action continuation) => throw null;
                        }
                        public struct CultureAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                        {
                            public CultureAwaiter(System.Threading.Tasks.Task task) => throw null;
                            public System.Data.Entity.SqlServer.Utilities.TaskExtensions.CultureAwaiter GetAwaiter() => throw null;
                            public void GetResult() => throw null;
                            public bool IsCompleted { get => throw null; }
                            public void OnCompleted(System.Action continuation) => throw null;
                            public void UnsafeOnCompleted(System.Action continuation) => throw null;
                        }
                        public static System.Data.Entity.SqlServer.Utilities.TaskExtensions.CultureAwaiter<T> WithCurrentCulture<T>(this System.Threading.Tasks.Task<T> task) => throw null;
                        public static System.Data.Entity.SqlServer.Utilities.TaskExtensions.CultureAwaiter WithCurrentCulture(this System.Threading.Tasks.Task task) => throw null;
                    }
                }
            }
        }
    }
}
