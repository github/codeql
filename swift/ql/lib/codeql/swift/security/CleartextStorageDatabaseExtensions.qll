/**
 * Provides classes and predicates for reasoning about cleartext database
 * storage vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A `DataFlow::Node` that is something stored in a local database.
 */
abstract class Stored extends DataFlow::Node { }

/**
 * A `DataFlow::Node` that is an expression stored with the Core Data library.
 */
class CoreDataStore extends Stored {
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
class RealmStore extends Stored instanceof DataFlow::PostUpdateNode {
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
class GrdbStore extends Stored {
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
