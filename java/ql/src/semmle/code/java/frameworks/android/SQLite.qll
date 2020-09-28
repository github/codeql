import java
import Android

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

abstract class SQLiteRunner extends Method {
  abstract int sqlIndex();
}

class ExecSqlMethod extends SQLiteRunner {
  ExecSqlMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    // execPerConnectionSQL(String sql, Object[] bindArgs)
    // execSQL(String sql)
    // execSQL(String sql, Object[] bindArgs)
    this.hasName(["execPerConnectionSQL", "execSQL"])
  }

  override int sqlIndex() { result = 0 }
}

class QueryMethod extends SQLiteRunner {
  QueryMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    this.hasName(["query", "queryWithFactory"])
  }

  override int sqlIndex() {
    // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
    // query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
    // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
    // query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy)
    this.getName() = "query" and
    (
      if this.getParameter(0).getType() instanceof TypeString
      then result = [2, 4, 5, 6, 7]
      else result = [3, 5, 6, 7, 8]
    )
    or
    // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal)
    // queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table, String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy, String limit)
    this.getName() = "queryWithFactory" and result = [4, 6, 7, 8, 9]
  }
}

class RawQueryMethod extends SQLiteRunner {
  RawQueryMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    this.hasName(["rawQuery", "rawQueryWithFactory"])
  }

  override int sqlIndex() {
    // rawQuery(String sql, String[] selectionArgs, CancellationSignal cancellationSignal)
    // rawQuery(String sql, String[] selectionArgs)
    this.getName() = "rawQuery" and result = 0
    or
    // rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs, String editTable, CancellationSignal cancellationSignal)
    // rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs, String editTable)
    this.getName() = "rawQueryWithFactory" and result = 1
  }
}

class CompileStatementMethod extends SQLiteRunner {
  CompileStatementMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    // compileStatement(String sql)
    this.hasName("compileStatement")
  }

  override int sqlIndex() { result = 0 }
}

class DeleteMethod extends SQLiteRunner {
  DeleteMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    // delete(String table, String whereClause, String[] whereArgs)
    this.hasName("delete")
  }

  override int sqlIndex() { result = 1 }
}

class UpdateMethod extends SQLiteRunner {
  UpdateMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    // update(String table, ContentValues values, String whereClause, String[] whereArgs)
    // updateWithOnConflict(String table, ContentValues values, String whereClause, String[] whereArgs, int conflictAlgorithm)
    this.hasName(["update", "updateWithOnConflict"])
  }

  override int sqlIndex() { result = 2 }
}

class ForQueryMethod extends SQLiteRunner {
  ForQueryMethod() {
    // (blobFileDescriptor|long|string)ForQuery(SQLiteDatabase db, String query, String[] selectionArgs)
    this.getDeclaringType() instanceof TypeDatabaseUtils and
    this.hasName(["blobFileDescriptorForQuery", "longForQuery", "stringForQuery"]) and
    this.getNumberOfParameters() = 3
  }

  override int sqlIndex() { result = 1 }
}

class CreateDbFromSqlStatementsMethod extends SQLiteRunner {
  CreateDbFromSqlStatementsMethod() {
    // createDbFromSqlStatements(Context context, String dbName, int dbVersion, String sqlStatements)
    this.getDeclaringType() instanceof TypeDatabaseUtils and
    this.hasName("createDbFromSqlStatements")
  }

  override int sqlIndex() { result = 3 }
}

class QueryNumEntriesMethod extends SQLiteRunner {
  QueryNumEntriesMethod() {
    // queryNumEntries(SQLiteDatabase db, String table, String selection)
    // queryNumEntries(SQLiteDatabase db, String table, String selection, String[] selectionArgs)
    this.getDeclaringType() instanceof TypeDatabaseUtils and
    this.hasName("queryNumEntries")
  }

  override int sqlIndex() { result = 2 }
}

class QueryBuilderDeleteMethod extends SQLiteRunner {
  QueryBuilderDeleteMethod() {
    // delete(SQLiteDatabase db, String selection, String[] selectionArgs)
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    this.hasName("delete")
  }

  override int sqlIndex() { result = [-1, 1] }
}

class QueryBuilderInsertMethod extends SQLiteRunner {
  QueryBuilderInsertMethod() {
    // insert(SQLiteDatabase db, ContentValues values)
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    this.hasName("insert")
  }

  override int sqlIndex() { result = -1 }
}

class QueryBuilderQueryMethod extends SQLiteRunner {
  QueryBuilderQueryMethod() {
    // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder)
    // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit)
    // query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs, String groupBy, String having, String sortOrder, String limit, CancellationSignal cancellationSignal)
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    this.hasName("query")
  }

  override int sqlIndex() { result = [-1, 3, 5, 6, 7, 8] }
}

class QueryBuilderUpdateMethod extends SQLiteRunner {
  QueryBuilderUpdateMethod() {
    // update(SQLiteDatabase db, ContentValues values, String selection, String[] selectionArgs)
    this.getDeclaringType().getASourceSupertype*() instanceof TypeSQLiteQueryBuilder and
    this.hasName("update")
  }

  override int sqlIndex() { result = [-1, 2] }
}

class ContentProviderDeleteMethod extends SQLiteRunner {
  ContentProviderDeleteMethod() {
    // delete(Uri uri, String selection, String[] selectionArgs)
    this.getDeclaringType() instanceof AndroidContentProvider and
    this.hasName("delete") and
    this.getNumberOfParameters() = 3
  }

  override int sqlIndex() { result = 1 }
}

class ContentProviderQueryMethod extends SQLiteRunner {
  ContentProviderQueryMethod() {
    // query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder, CancellationSignal cancellationSignal)
    // query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder)
    this.getDeclaringType() instanceof AndroidContentProvider and
    this.hasName("query") and
    this.getNumberOfParameters() = [5, 6]
  }

  override int sqlIndex() { result = 2 }
}

class ContentProviderUpdateMethod extends SQLiteRunner {
  ContentProviderUpdateMethod() {
    // update(Uri uri, ContentValues values, String selection, String[] selectionArgs)
    this.getDeclaringType() instanceof AndroidContentProvider and
    this.hasName("update") and
    this.getNumberOfParameters() = 4
  }

  override int sqlIndex() { result = 2 }
}
