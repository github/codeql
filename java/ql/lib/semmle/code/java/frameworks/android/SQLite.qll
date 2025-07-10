/** Provides classes and predicates for working with SQLite databases. */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.frameworks.android.Android

/**
 * The class `android.database.sqlite.SQLiteDatabase`.
 */
class TypeSQLiteDatabase extends Class {
  TypeSQLiteDatabase() { this.hasQualifiedName("android.database.sqlite", "SQLiteDatabase") }
}

/**
 * The class `android.database.sqlite.SQLiteQueryBuilder`.
 */
class TypeSQLiteQueryBuilder extends Class {
  TypeSQLiteQueryBuilder() {
    this.hasQualifiedName("android.database.sqlite", "SQLiteQueryBuilder")
  }
}

/**
 * The class `android.database.DatabaseUtils`.
 */
class TypeDatabaseUtils extends Class {
  TypeDatabaseUtils() { this.hasQualifiedName("android.database", "DatabaseUtils") }
}

/**
 * The class `android.database.sqlite.SQLiteOpenHelper`.
 */
class TypeSQLiteOpenHelper extends Class {
  TypeSQLiteOpenHelper() { this.hasQualifiedName("android.database.sqlite", "SQLiteOpenHelper") }
}

/**
 * The class `android.database.sqlite.SQLiteStatement`.
 */
class TypeSQLiteStatement extends Class {
  TypeSQLiteStatement() { this.hasQualifiedName("android.database.sqlite", "SQLiteStatement") }
}
