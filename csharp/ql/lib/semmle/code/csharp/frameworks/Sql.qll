/** Provides definitions related to SQL frameworks. */

import csharp
private import semmle.code.csharp.frameworks.system.Data
private import semmle.code.csharp.frameworks.system.data.SqlClient
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.Dapper
private import semmle.code.csharp.dataflow.DataFlow4
private import semmle.code.csharp.dataflow.ExternalFlow

/** An expression containing a SQL command. */
abstract class SqlExpr extends Expr {
  /** Gets the SQL command. */
  abstract Expr getSql();
}

/** An assignment to a `CommandText` property. */
class CommandTextAssignmentSqlExpr extends SqlExpr, AssignExpr {
  CommandTextAssignmentSqlExpr() {
    exists(Property p, SystemDataIDbCommandInterface i, Property text |
      p = this.getLValue().(PropertyAccess).getTarget() and
      text = i.getCommandTextProperty()
    |
      p.overridesOrImplementsOrEquals(text)
    )
  }

  override Expr getSql() { result = this.getRValue() }
}

/** A construction of an unknown `IDbCommand` object. */
class IDbCommandConstructionSqlExpr extends SqlExpr, ObjectCreation {
  IDbCommandConstructionSqlExpr() {
    exists(InstanceConstructor ic | ic = this.getTarget() |
      ic.getDeclaringType().getABaseType*() instanceof SystemDataIDbCommandInterface and
      ic.getParameter(0).getType() instanceof StringType and
      not ic.getDeclaringType()
          .hasQualifiedName([
              // Known sealed classes:
              "System.Data.SqlClient.SqlCommand", "System.Data.Odbc.OdbcCommand",
              "System.Data.OleDb.OleDbCommand", "System.Data.EntityClient.EntityCommand",
              "System.Data.SQLite.SQLiteCommand"
            ])
    )
  }

  override Expr getSql() { result = this.getArgument(0) }
}

/** A construction of a known `IDbCommand` object. */
private class IDbCommandConstructionSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // SqlCommand
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String);;Argument[0];sql;manual",
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String,System.Data.SqlClient.SqlConnection);;Argument[0];sql;manual",
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String,System.Data.SqlClient.SqlConnection,System.Data.SqlClient.SqlTransaction);;Argument[0];sql;manual",
        // OdbcCommand
        "System.Data.Odbc;OdbcCommand;false;OdbcCommand;(System.String);;Argument[0];sql;manual",
        "System.Data.Odbc;OdbcCommand;false;OdbcCommand;(System.String,System.Data.Odbc.OdbcConnection);;Argument[0];sql;manual",
        "System.Data.Odbc;OdbcCommand;false;OdbcCommand;(System.String,System.Data.Odbc.OdbcConnection,System.Data.Odbc.OdbcTransaction);;Argument[0];sql;manual",
        // OleDbCommand
        "System.Data.OleDb;OleDbCommand;false;OleDbCommand;(System.String);;Argument[0];sql;manual",
        "System.Data.OleDb;OleDbCommand;false;OleDbCommand;(System.String,System.Data.OleDb.OleDbConnection);;Argument[0];sql;manual",
        "System.Data.OleDb;OleDbCommand;false;OleDbCommand;(System.String,System.Data.OleDb.OleDbConnection,System.Data.OleDb.OleDbTransaction);;Argument[0];sql;manual",
        // EntityCommand
        "System.Data.EntityClient;EntityCommand;false;EntityCommand;(System.String);;Argument[0];sql;manual",
        "System.Data.EntityClient;EntityCommand;false;EntityCommand;(System.String,System.Data.EntityClient.EntityConnection);;Argument[0];sql;manual",
        "System.Data.EntityClient;EntityCommand;false;EntityCommand;(System.String,System.Data.EntityClient.EntityConnection,System.Data.EntityClient.EntityTransaction);;Argument[0];sql;manual",
        // SQLiteCommand
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String);;Argument[0];sql;manual",
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String,System.Data.SQLite.SQLiteConnection);;Argument[0];sql;manual",
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String,System.Data.SQLite.SQLiteConnection,System.Data.SQLite.SQLiteTransaction);;Argument[0];sql;manual",
      ]
  }
}

/** Data flow for SqlCommand and friends. */
private class SqlCommandSummaryModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // SqlCommand
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String);;Argument[0];Argument[this];taint;manual",
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String,System.Data.SqlClient.SqlConnection);;Argument[0];Argument[this];taint;manual",
        "System.Data.SqlClient;SqlCommand;false;SqlCommand;(System.String,System.Data.SqlClient.SqlConnection,System.Data.SqlClient.SqlTransaction);;Argument[0];Argument[this];taint;manual",
        // SQLiteCommand.
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String);;Argument[0];Argument[this];taint;manual",
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String,System.Data.SQLite.SQLiteConnection);;Argument[0];Argument[this];taint;manual",
        "System.Data.SQLite;SQLiteCommand;false;SQLiteCommand;(System.String,System.Data.SQLite.SQLiteConnection,System.Data.SQLite.SQLiteTransaction);;Argument[0];Argument[this];taint;manual",
      ]
  }
}

/** A construction of an `Adapter` object. */
private class SqlDataAdapterConstructionSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // SqlDataAdapter
        "System.Data.SqlClient;SqlDataAdapter;false;SqlDataAdapter;(System.Data.SqlClient.SqlCommand);;Argument[0];sql;manual",
        "System.Data.SqlClient;SqlDataAdapter;false;SqlDataAdapter;(System.String,System.String);;Argument[0];sql;manual",
        "System.Data.SqlClient;SqlDataAdapter;false;SqlDataAdapter;(System.String,System.Data.SqlClient.SqlConnection);;Argument[0];sql;manual",
        // SQLiteDataAdapter
        "System.Data.SQLite;SQLiteDataAdapter;false;SQLiteDataAdapter;(System.Data.SQLite.SQLiteCommand);;Argument[0];sql;manual",
        "System.Data.SQLite;SQLiteDataAdapter;false;SQLiteDataAdapter;(System.String,System.Data.SQLite.SQLiteConnection);;Argument[0];sql;manual",
        "System.Data.SQLite;SQLiteDataAdapter;false;SQLiteDataAdapter;(System.String,System.String);;Argument[0];sql;manual",
        "System.Data.SQLite;SQLiteDataAdapter;false;SQLiteDataAdapter;(System.String,System.String,System.Boolean);;Argument[0];sql;manual",
      ]
  }
}

/** A `MySql.Data.MySqlClient.MySqlHelper` method. */
private class MySqlHelperMethodCallSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // ExecuteDataRow/Async
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataRow;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataRowAsync;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataRowAsync;(System.String,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteDataset
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataset;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataset;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataset;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDataset;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteDatasetAsync
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(System.String,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(System.String,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteDatasetAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteNonQuery
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQuery;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQuery;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteNonQueryAsync
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQueryAsync;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQueryAsync;(System.String,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQueryAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteNonQueryAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteReader
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReader;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReader;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReader;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReader;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteReaderAsync
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(System.String,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(System.String,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteReaderAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteScalar
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalar;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalar;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalar;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalar;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // ExecuteScalarAsync
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(System.String,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(System.String,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(System.String,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(System.String,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;ExecuteScalarAsync;(MySql.Data.MySqlClient.MySqlConnection,System.String,System.Threading.CancellationToken,MySql.Data.MySqlClient.MySqlParameter[]);;Argument[1];sql;manual",
        // UpdateDataset/Async
        "MySql.Data.MySqlClient;MySqlHelper;false;UpdateDataset;(System.String,System.String,System.Data.DataSet,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;UpdateDatasetAsync;(System.String,System.String,System.Data.DataSet,System.String);;Argument[1];sql;manual",
        "MySql.Data.MySqlClient;MySqlHelper;false;UpdateDatasetAsync;(System.String,System.String,System.Data.DataSet,System.String,System.Threading.CancellationToken);;Argument[1];sql;manual"
      ]
  }
}

/** A `Microsoft.ApplicationBlocks.Data.SqlHelper` method. */
private class MicrosoftSqlHelperSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // ExecuteNonQuery
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.String,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.String,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteNonQuery;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        // ExecuteDataset
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.String,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.String,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteDataset;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        // ExecuteReader
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.String,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.String,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteReader;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        // ExecuteScalar
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.String,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.String,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteScalar;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        // ExecuteXmlReader
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteXmlReader;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteXmlReader;(System.Data.SqlClient.SqlConnection,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteXmlReader;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String);;Argument[2];sql;manual",
        "Microsoft.ApplicationBlocks.Data;SqlHelper;false;ExecuteXmlReader;(System.Data.SqlClient.SqlTransaction,System.Data.CommandType,System.String,System.Data.SqlClient.SqlParameter[]);;Argument[2];sql;manual"
      ]
  }
}

/** A `Dapper.SqlMapper` method that is taking a SQL string argument. */
private class DapperSqlMapperSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Execute*
        "Dapper;SqlMapper;false;Execute;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteScalar;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteScalarAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteScalar<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteScalarAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteReader;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteReaderAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;ExecuteReaderAsync;(System.Data.DbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        // Query*
        "Dapper;SqlMapper;false;Query;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Boolean,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Boolean,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryMultiple;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryMultipleAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirst;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirst<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefault;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefaultAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefault<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefaultAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingle;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingle<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefault;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefaultAsync;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefault<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefaultAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        // Query* with System.Type parameter
        "Dapper;SqlMapper;false;Query;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Boolean,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Boolean,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QueryFirst;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstAsync;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefault;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QueryFirstOrDefaultAsync;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QuerySingle;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleAsync;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefault;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        "Dapper;SqlMapper;false;QuerySingleOrDefaultAsync;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Data.IDbTransaction,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[2];sql;manual",
        // Query with multiple type parameters
        "Dapper;SqlMapper;false;Query<,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<,,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TSixth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TSixth,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;Query<,,,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TSixth,TSeventh,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<,,,,,,,>;(System.Data.IDbConnection,System.String,System.Func<TFirst,TSecond,TThird,TFourth,TFifth,TSixth,TSeventh,TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        // Query with System.Type[] parameter
        "Dapper;SqlMapper;false;Query<>;(System.Data.IDbConnection,System.String,System.Type[],System.Func<System.Object[],TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual",
        "Dapper;SqlMapper;false;QueryAsync<>;(System.Data.IDbConnection,System.String,System.Type[],System.Func<System.Object[],TReturn>,System.Object,System.Data.IDbTransaction,System.Boolean,System.String,System.Nullable<System.Int32>,System.Nullable<System.Data.CommandType>);;Argument[1];sql;manual"
      ]
  }
}

/** A `Dapper.CommandDefinition` creation that is taking a SQL string argument and is passed to a `Dapper.SqlMapper` method. */
class DapperCommandDefinitionMethodCallSqlExpr extends SqlExpr, ObjectCreation {
  DapperCommandDefinitionMethodCallSqlExpr() {
    this.getObjectType() instanceof Dapper::CommandDefinitionStruct and
    exists(Conf c | c.hasFlow(DataFlow::exprNode(this), _))
  }

  override Expr getSql() { result = this.getArgumentForName("commandText") }
}

private class Conf extends DataFlow4::Configuration {
  Conf() { this = "DapperCommandDefinitionFlowConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(ObjectCreation).getObjectType() instanceof Dapper::CommandDefinitionStruct
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodCall mc |
      mc.getTarget() = any(Dapper::SqlMapperClass c).getAQueryMethod() and
      node.asExpr() = mc.getArgumentForName("command")
    )
  }
}
