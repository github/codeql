/** Provides classes and predicates to reason about cleartext storage in Android databases. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.ContentProviders
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.security.CleartextStorageQuery

private class LocalDatabaseCleartextStorageSink extends CleartextStorageSink {
  LocalDatabaseCleartextStorageSink() { localDatabaseInput(_, this.asExpr()) }
}

private class LocalDatabaseCleartextStorageStep extends CleartextStorageAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    // EditText.getText() return type is parsed as `Object`, so we need to
    // add a taint step for `Object.toString` to model `editText.getText().toString()`
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeObject and
      m.hasName("toString")
    |
      n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma
    )
  }
}

/** The creation of an object that can be used to store data in a local database. */
class LocalDatabaseOpenMethodAccess extends Storable, Call {
  LocalDatabaseOpenMethodAccess() {
    exists(Method m | this.(MethodAccess).getMethod() = m |
      m.getDeclaringType().getASupertype*() instanceof TypeSQLiteOpenHelper and
      m.hasName("getWritableDatabase")
      or
      m.getDeclaringType() instanceof TypeSQLiteDatabase and
      m.hasName(["create", "openDatabase", "openOrCreateDatabase", "compileStatement"])
      or
      m.getDeclaringType().getASupertype*() instanceof TypeContext and
      m.hasName("openOrCreateDatabase")
    )
    or
    this.(ClassInstanceExpr).getConstructedType() instanceof ContentValues
  }

  override Expr getAnInput() {
    exists(LocalDatabaseFlowConfig config, DataFlow::Node database |
      localDatabaseInput(database, result) and
      config.hasFlow(DataFlow::exprNode(this), database)
    )
  }

  override Expr getAStore() {
    exists(LocalDatabaseFlowConfig config, DataFlow::Node database |
      localDatabaseStore(database, result) and
      config.hasFlow(DataFlow::exprNode(this), database)
    )
  }
}

/** A method that is both a database input and a database store. */
private class LocalDatabaseInputStoreMethod extends Method {
  LocalDatabaseInputStoreMethod() {
    this.getDeclaringType() instanceof TypeSQLiteDatabase and
    this.getName().matches("exec%SQL")
  }
}

/**
 * Holds if `input` is a value being prepared for being stored into the SQLite dataabse `database`.
 * This can be done using prepared statements, using the class `ContentValues`, or directly
 * appending `input` to a SQL query.
 */
private predicate localDatabaseInput(DataFlow::Node database, Argument input) {
  exists(Method m | input.getCall().getCallee() = m |
    m instanceof LocalDatabaseInputStoreMethod and
    database.asExpr() = input.getCall().getQualifier()
    or
    m.getDeclaringType() instanceof TypeSQLiteDatabase and
    m.hasName("compileStatement") and
    database.asExpr() = input.getCall()
    or
    m.getDeclaringType() instanceof ContentValues and
    m.hasName("put") and
    input.getPosition() = 1 and
    database.asExpr() = input.getCall().getQualifier()
  )
}

/**
 * Holds if `store` is a method call for storing a previously appended input value,
 * either through the use of prepared statements, via the `ContentValues` class, or
 * directly executing a raw SQL query.
 */
private predicate localDatabaseStore(DataFlow::Node database, MethodAccess store) {
  exists(Method m | store.getMethod() = m |
    m instanceof LocalDatabaseInputStoreMethod and
    database.asExpr() = store.getQualifier()
    or
    m.getDeclaringType() instanceof TypeSQLiteDatabase and
    m.getName().matches(["insert%", "replace%", "update%"]) and
    database.asExpr() = store.getAnArgument() and
    database.getType() instanceof ContentValues
    or
    m.getDeclaringType() instanceof TypeSQLiteStatement and
    m.hasName(["executeInsert", "executeUpdateDelete"]) and
    database.asExpr() = store.getQualifier()
  )
}

private class LocalDatabaseFlowConfig extends DataFlow::Configuration {
  LocalDatabaseFlowConfig() { this = "LocalDatabaseFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof LocalDatabaseOpenMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) {
    localDatabaseInput(sink, _) or
    localDatabaseStore(sink, _)
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    // Adds a step for tracking databases through field flow, that is, a database is opened and
    // assigned to a field, and then an input or store method is called on that field elsewhere.
    exists(Field f |
      f.getType() instanceof TypeSQLiteDatabase and
      f.getAnAssignedValue() = n1.asExpr() and
      f = n2.asExpr().(FieldRead).getField()
    )
  }
}
