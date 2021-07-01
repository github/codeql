import java
import Android
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.dataflow.ExternalFlow

/**
 * The class `android.database.sqlite.SQLiteDatabase`.
 */
class TypeSQLiteDatabase extends Class {
  TypeSQLiteDatabase() { hasQualifiedName("android.database.sqlite", "SQLiteDatabase") }
}

/**
 * The class `android.database.sqlite.SQLiteQueryBuilder`.
 */
class TypeSQLiteQueryBuilder extends Class {
  TypeSQLiteQueryBuilder() { hasQualifiedName("android.database.sqlite", "SQLiteQueryBuilder") }
}

/**
 * The class `android.database.DatabaseUtils`.
 */
class TypeDatabaseUtils extends Class {
  TypeDatabaseUtils() { hasQualifiedName("android.database", "DatabaseUtils") }
}

private class SQLiteSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "android.database.sqlite;SQLiteDatabase;false;compileStatement;(String);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;execSQL;(String);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;execSQL;(String,Object[]);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;execPerConnectionSQL;(String,Object[]);;Argument[0];sql",
        // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
        // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy)
        // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
        // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        // Each String / String[] arg except for selectionArgs is a sink
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String,String);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String,String);;Argument[1];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String,String);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String,String);;Argument[4..7];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String);;Argument[0..2];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(String,String[],String,String[],String,String,String);;Argument[4..6];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String);;Argument[1];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String);;Argument[3];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String);;Argument[5..8];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[1];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[3];sql",
        "android.database.sqlite;SQLiteDatabase;false;query;(boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[5..8];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String);;Argument[3];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String);;Argument[4];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String);;Argument[6..9];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[3];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[4];sql",
        "android.database.sqlite;SQLiteDatabase;false;queryWithFactory;(CursorFactory,boolean,String,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[6..9];sql",
        "android.database.sqlite;SQLiteDatabase;false;rawQuery;(String,String[]);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;rawQuery;(String,String[],CancellationSignal);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;rawQueryWithFactory;(CursorFactory,String,String[],String);;Argument[1];sql",
        "android.database.sqlite;SQLiteDatabase;false;rawQueryWithFactory;(CursorFactory,String,String[],String,CancellationSignal);;Argument[1];sql",
        "android.database.sqlite;SQLiteDatabase;false;delete;(String,String,String[]);;Argument[0..1];sql",
        "android.database.sqlite;SQLiteDatabase;false;update;(String,ContentValues,String,String[]);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;update;(String,ContentValues,String,String[]);;Argument[2];sql",
        "android.database.sqlite;SQLiteDatabase;false;updateWithOnConflict;(String,ContentValues,String,String[],int);;Argument[0];sql",
        "android.database.sqlite;SQLiteDatabase;false;updateWithOnConflict;(String,ContentValues,String,String[],int);;Argument[2];sql",
        "android.database;DatabaseUtils;false;longForQuery;(SQLiteDatabase,String,String[]);;Argument[1];sql",
        "android.database;DatabaseUtils;false;stringForQuery;(SQLiteDatabase,String,String[]);;Argument[1];sql",
        "android.database;DatabaseUtils;false;blobFileDescriptorForQuery;(SQLiteDatabase,String,String[]);;Argument[1];sql",
        "android.database;DatabaseUtils;false;createDbFromSqlStatements;(Context,String,int,String);;Argument[3];sql",
        "android.database;DatabaseUtils;false;queryNumEntries;(SQLiteDatabase,String);;Argument[1];sql",
        "android.database;DatabaseUtils;false;queryNumEntries;(SQLiteDatabase,String,String);;Argument[1..2];sql",
        "android.database;DatabaseUtils;false;queryNumEntries;(SQLiteDatabase,String,String,String[]);;Argument[1..2];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;delete;(SQLiteDatabase,String,String[]);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;delete;(SQLiteDatabase,String,String[]);;Argument[1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;insert;(SQLiteDatabase,ContentValues);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;update;(SQLiteDatabase,ContentValues,String,String[]);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;update;(SQLiteDatabase,ContentValues,String,String[]);;Argument[2];sql",
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder)
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit)
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit, CancellationSignal cancellationSignal)
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String);;Argument[1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String);;Argument[2];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String);;Argument[4..6];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String);;Argument[1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String);;Argument[2];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String);;Argument[4..7];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[-1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[1];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[2];sql",
        "android.database.sqlite;SQLiteQueryBuilder;true;query;(SQLiteDatabase,String[],String,String[],String,String,String,String,CancellationSignal);;Argument[4..7];sql",
        "android.content;ContentProvider;true;delete;(Uri,String,String[]);;Argument[1];sql",
        "android.content;ContentProvider;true;update;(Uri,ContentValues,String,String[]);;Argument[2];sql",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String,CancellationSignal);;Argument[2];sql",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String);;Argument[2];sql",
        "android.content;ContentResolver;true;delete;(Uri,String,String[]);;Argument[1];sql",
        "android.content;ContentResolver;true;update;(Uri,ContentValues,String,String[]);;Argument[2];sql",
        "android.content;ContentResolver;true;query;(Uri,String[],String,String[],String,CancellationSignal);;Argument[2];sql",
        "android.content;ContentResolver;true;query;(Uri,String[],String,String[],String);;Argument[2];sql"
      ]
  }
}

private class QueryBuilderBuildMethod extends TaintPreservingCallable {
  int argument;

  QueryBuilderBuildMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    (
      // buildQuery(String[] projectionIn, String selection, String groupBy, String having, String sortOrder, String limit)
      // buildQuery(String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit)
      // buildUnionQuery(String[] subQueries, String sortOrder, String limit)
      this.hasName(["buildQuery", "buildUnionQuery"]) and
      argument = [-1 .. getNumberOfParameters()]
      or
      // buildUnionSubQuery(String typeDiscriminatorColumn, String[] unionColumns, Set<String> columnsPresentInTable, int computedColumnsOffset, String typeDiscriminatorValue, String selection, String[] selectionArgs, String groupBy, String having)
      // buildUnionSubQuery(String typeDiscriminatorColumn, String[] unionColumns, Set<String> columnsPresentInTable, int computedColumnsOffset, String typeDiscriminatorValue, String selection, String groupBy, String having)
      this.hasName("buildUnionSubQuery") and
      argument = [-1 .. getNumberOfParameters()] and
      argument != 3
      or
      // static buildQueryString(boolean distinct, String tables, String[] columns, String where, String groupBy, String having, String orderBy, String limit)
      hasName("buildQueryString") and
      argument = [1 .. getNumberOfParameters()]
    )
  }

  override predicate returnsTaintFrom(int arg) { argument = arg }
}

private class QueryBuilderAppendMethod extends TaintPreservingCallable {
  QueryBuilderAppendMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    // setProjectionMap(Map<String, String> columnMap)
    // setTables(String inTables)
    // appendWhere(CharSequence inWhere)
    // appendWhereStandalone(CharSequence inWhere)
    // static appendColumns(StringBuilder s, String[] columns)
    this.hasName([
        "setProjectionMap", "setTables", "appendWhere", "appendWhereStandalone", "appendColumns"
      ])
  }

  override predicate transfersTaint(int src, int sink) {
    if hasName("appendColumns") then (src = 1 and sink = 0) else (src = 0 and sink = -1)
  }
}

private class UnsafeAppendUtilMethod extends TaintPreservingCallable {
  UnsafeAppendUtilMethod() {
    this.getDeclaringType() instanceof TypeDatabaseUtils and
    // String[] appendSelectionArgs(String[] originalValues, String[] newValues)
    // String concatenateWhere(String a, String b)
    this.hasName(["appendSelectionArgs", "concatenateWhere"])
  }

  override predicate returnsTaintFrom(int arg) { arg = [0 .. getNumberOfParameters()] }
}

private class TaintPreservingQueryMethod extends TaintPreservingCallable {
  TaintPreservingQueryMethod() {
    (
      this.getDeclaringType() instanceof AndroidContentProvider or
      this.getDeclaringType() instanceof AndroidContentResolver
    ) and
    // Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder, CancellationSignal cancellationSignal)
    // Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder)
    this.hasName("query")
  }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}
