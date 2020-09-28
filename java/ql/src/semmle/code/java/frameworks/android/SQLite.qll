import java

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
    this.getName() = "execSql"
  }

  override int sqlIndex() { result = 0 }
}

class QueryMethod extends SQLiteRunner {
  QueryMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    this.getName().matches("rawQuery%")
  }

  override int sqlIndex() {
    this.getName() = "query" and
    (if this.getParameter(0).getType() instanceof TypeString then result = 2 else result = 3)
    or
    this.getName() = "queryWithFactory" and result = 4
  }
}

class RawQueryMethod extends SQLiteRunner {
  RawQueryMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    this.getName().matches("rawQuery%")
  }

  override int sqlIndex() {
    this.getName() = "rawQuery" and result = 0
    or
    this.getName() = "rawQueryWithFactory" and result = 1
  }
}
