/**
 * Provides classes and predicates for reasoning about cleartext database
 * storage vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow

/**
 * A dataflow sink for cleartext database storage vulnerabilities. That is,
 * a `DataFlow::Node` that is something stored in a local database.
 */
abstract class CleartextStorageDatabaseSink extends DataFlow::Node { }

/**
 * A sanitizer for cleartext database storage vulnerabilities.
 */
abstract class CleartextStorageDatabaseSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class CleartextStorageDatabaseAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to cleartext database storage vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A `DataFlow::Node` that is an expression stored with the Core Data library.
 */
class CoreDataStore extends CleartextStorageDatabaseSink {
  CoreDataStore() {
    // values written into Core Data objects through `set*Value` methods are a sink.
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NSManagedObject",
            ["setValue(_:forKey:)", "setPrimitiveValue(_:forKey:)"]) and
      call.getArgument(0).getExpr() = this.asExpr()
    )
    or
    // any write into a class derived from `NSManagedObject` is a sink. For
    // example in `coreDataObj.data = sensitive` the post-update node corresponding
    // with `coreDataObj.data` is a sink.
    // (ideally this would be only members with the `@NSManaged` attribute)
    exists(ClassOrStructDecl cd, Expr e |
      cd.getABaseTypeDecl*().getName() = "NSManagedObject" and
      this.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = cd.getType() and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

/**
 * A `DataFlow::Node` that is an expression stored with the Realm database
 * library.
 */
class RealmStore extends CleartextStorageDatabaseSink instanceof DataFlow::PostUpdateNode {
  RealmStore() {
    // any write into a class derived from `RealmSwiftObject` is a sink. For
    // example in `realmObj.data = sensitive` the post-update node corresponding
    // with `realmObj.data` is a sink.
    exists(ClassOrStructDecl cd, Expr e |
      cd.getABaseTypeDecl*().getName() = "RealmSwiftObject" and
      this.getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = cd.getType() and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

/**
 * A `DataFlow::Node` that is an expression stored with the GRDB library.
 */
class GrdbStore extends CleartextStorageDatabaseSink {
  GrdbStore() {
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgumentWithLabel("arguments").getExpr() = this.asExpr()
    |
      method
          .hasQualifiedName("Database",
            ["allStatements(sql:arguments:)", "execute(sql:arguments:)",])
      or
      method.hasQualifiedName("SQLRequest", "init(sql:arguments:adapter:cached:)")
      or
      method.hasQualifiedName("SQL", ["init(sql:arguments:)", "append(sql:arguments:)"])
      or
      method.hasQualifiedName("SQLStatementCursor", "init(database:sql:arguments:prepFlags:)")
      or
      method
          .hasQualifiedName("TableRecord",
            [
              "select(sql:arguments:)", "select(sql:arguments:as:)", "filter(sql:arguments:)",
              "order(sql:arguments:)"
            ])
      or
      method
          .hasQualifiedName(["Row", "DatabaseValueConvertible", "FetchableRecord"],
            [
              "fetchCursor(_:sql:arguments:adapter:)", "fetchAll(_:sql:arguments:adapter:)",
              "fetchSet(_:sql:arguments:adapter:)", "fetchOne(_:sql:arguments:adapter:)"
            ])
      or
      method
          .hasQualifiedName("FetchableRecord",
            [
              "fetchCursor(_:arguments:adapter:)", "fetchAll(_:arguments:adapter:)",
              "fetchSet(_:arguments:adapter:)", "fetchOne(_:arguments:adapter:)",
            ])
      or
      method.hasQualifiedName("Statement", ["execute(arguments:)"])
      or
      method
          .hasQualifiedName("CommonTableExpression", "init(recursive:named:columns:sql:arguments:)")
    )
    or
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgument(0).getExpr() = this.asExpr()
    |
      method.hasQualifiedName("Statement", "setArguments(_:)")
    )
  }
}

/**
 * An encryption sanitizer for cleartext database storage vulnerabilities.
 */
class CleartextStorageDatabaseEncryptionSanitizer extends CleartextStorageDatabaseSanitizer {
  CleartextStorageDatabaseEncryptionSanitizer() {
    this.asExpr() instanceof EncryptedExpr
  }
}

/**
 * An additional taint step for cleartext database storage vulnerabilities.
 * Needed until we have proper content flow through arrays.
 */
class CleartextStorageDatabaseArrayAdditionalTaintStep extends CleartextStorageDatabaseAdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(ArrayExpr arr |
      nodeFrom.asExpr() = arr.getAnElement() and
      nodeTo.asExpr() = arr
    )
  }
}
