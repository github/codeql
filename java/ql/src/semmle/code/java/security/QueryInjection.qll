/** Provides classes to reason about database query language injection vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Jdbc
import semmle.code.java.frameworks.jOOQ
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.frameworks.javaee.Persistence
import semmle.code.java.frameworks.SpringJdbc
import semmle.code.java.frameworks.MyBatis
import semmle.code.java.frameworks.Hibernate

/** A sink for database query language injection vulnerabilities. */
abstract class QueryInjectionSink extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the SQL
 * injection taint configuration.
 */
class AdditionalQueryInjectionTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for SQL injection taint configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A sink for SQL injection vulnerabilities. */
private class SqlInjectionSink extends QueryInjectionSink {
  SqlInjectionSink() {
    this.asExpr() instanceof SqlExpr
    or
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.asExpr()
    |
      index = m.(SQLiteRunner).sqlIndex()
      or
      m instanceof BatchUpdateVarargsMethod
      or
      index = 0 and jdbcSqlMethod(m)
      or
      index = 0 and mybatisSqlMethod(m)
      or
      index = 0 and hibernateSqlMethod(m)
      or
      index = 0 and jOOQSqlMethod(m)
    )
  }
}

/** A sink for Java Persistence Query Language injection vulnerabilities. */
private class PersistenceQueryInjectionSink extends QueryInjectionSink {
  PersistenceQueryInjectionSink() {
    // the query (first) argument to a `createQuery` or `createNativeQuery` method on `EntityManager`
    exists(MethodAccess call, TypeEntityManager em | call.getArgument(0) = this.asExpr() |
      call.getMethod() = em.getACreateQueryMethod() or
      call.getMethod() = em.getACreateNativeQueryMethod()
      // note: `createNamedQuery` is safe, as it takes only the query name,
      // and named queries can only be constructed using constants as the query text
    )
  }
}

/** A sink for MongoDB injection vulnerabilities. */
private class MongoDbInjectionSink extends QueryInjectionSink {
  MongoDbInjectionSink() {
    exists(MethodAccess call |
      call.getMethod().getDeclaringType().hasQualifiedName("com.mongodb", "BasicDBObject") and
      call.getMethod().hasName("parse") and
      this.asExpr() = call.getArgument(0)
    )
    or
    exists(CastExpr c |
      c.getExpr() = this.asExpr() and
      c.getTypeExpr().getType().(RefType).hasQualifiedName("com.mongodb", "DBObject")
    )
  }
}

private class MongoJsonStep extends AdditionalQueryInjectionTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("com.mongodb.util", "JSON") and
      ma.getMethod().hasName("parse") and
      ma.getArgument(0) = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

/** A sink for Android database injection vulnerabilities. */
private class AndroidDatabaseUtils extends QueryInjectionSink {
  AndroidDatabaseUtils() {
    exists(MethodAccess call, Method method |
      method = call.getMethod() and
      method.getDeclaringType().hasQualifiedName("android.database", "DatabaseUtils") and
      (
        // (blobFileDescriptor|long|string)ForQuery(SQLiteDatabase db, String query, String[] selectionArgs)
        method.hasName(["blobFileDescriptorForQuery", "longForQuery", "stringForQuery"]) and
        method.getNumberOfParameters() = 3 and
        this.asExpr() = call.getArgument(1)
        or
        // createDbFromSqlStatements(Context context, String dbName, int dbVersion, String sqlStatements)
        method.hasName("createDbFromSqlStatements") and
        this.asExpr() = call.getArgument(3)
        or
        // queryNumEntries(SQLiteDatabase db, String table, String selection)
        // queryNumEntries(SQLiteDatabase db, String table, String selection, String[] selectionArgs)
        method.hasName("queryNumEntries") and
        this.asExpr() = call.getArgument(2)
      )
      or
      method
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("android.database.sqlite", "SQLiteDatabase") and
      (
        // compileStatement(String sql)
        method.hasName("compileStatement") and
        this.asExpr() = call.getArgument(0)
        or
        // delete(String table, String whereClause, String[] whereArgs)
        method.hasName("delete") and
        this.asExpr() = call.getArgument(1)
        or
        // execPerConnectionSQL(String sql, Object[] bindArgs)
        // execSQL(String sql)
        // execSQL(String sql, Object[] bindArgs)
        method.hasName(["execPerConnectionSQL", "execSQL"]) and
        this.asExpr() = call.getArgument(0)
        or
        // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
        // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy)
        method.hasName("query") and
        (
          this.asExpr() = call.getArgument([3, 5, 6, 7, 8]) and
          method.getNumberOfParameters() = [9, 10]
          or
          this.asExpr() = call.getArgument([2, 4, 5, 6, 7]) and
          method.getNumberOfParameters() = [7, 8]
        )
        or
        // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
        // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
        method.hasName("queryWithFactory") and
        this.asExpr() = call.getArgument([4, 6, 7, 8, 9])
        or
        // rawQuery(String sql, String[] selectionArgs, CancellationSignal cancellationSignal)
        // rawQuery(String sql, String[] selectionArgs)
        method.hasName("rawQuery") and
        this.asExpr() = call.getArgument(0)
        or
        // rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs, String editTable, CancellationSignal cancellationSignal)
        // rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs, String editTable)
        method.hasName("rawQueryWithFactory") and
        this.asExpr() = call.getArgument(1)
        or
        // update(String table, ContentValues values, String whereClause, String[] whereArgs)
        // updateWithOnConflict(String table, ContentValues values, String whereClause, String[] whereArgs, int conflictAlgorithm)
        method.hasName(["update", "updateWithOnConflict"]) and
        this.asExpr() = call.getArgument(2)
      )
      or
      method
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("android.content", "ContentProvider") and
      (
        // delete(Uri uri, String selection, String[] selectionArgs)
        method.hasName("delete") and
        this.asExpr() = call.getArgument(1) and
        method.getNumberOfParameters() = 3
        or
        // query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder, CancellationSignal cancellationSignal)
        // query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder)
        method.hasName("query") and
        method.getNumberOfParameters() = [5, 6] and
        this.asExpr() = call.getArgument(2)
        or
        // update(Uri uri, ContentValues values, String selection, String[] selectionArgs)
        method.hasName("update") and
        this.asExpr() = call.getArgument(2) and
        method.getNumberOfParameters() = 4
      )
      or
      method
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("android.database.sqlite", "SQLiteQueryBuilder") and
      (
        // delete(SQLiteDatabase db, String selection, String[] selectionArgs)
        method.hasName("delete") and
        (this.asExpr() = call.getArgument(1) or this.asExpr() = call.getQualifier())
        or
        // insert(SQLiteDatabase db, ContentValues values)
        method.hasName("update") and
        this.asExpr() = call.getQualifier()
        or
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder)
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit)
        // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit, CancellationSignal cancellationSignal)
        method.hasName("query") and
        (this.asExpr() = call.getArgument([3, 5, 6, 7, 8]) or this.asExpr() = call.getQualifier())
        or
        // update(SQLiteDatabase db, ContentValues values, String selection, String[] selectionArgs)
        method.hasName("update") and
        (this.asExpr() = call.getArgument(2) or this.asExpr() = call.getQualifier())
      )
    )
  }
}
