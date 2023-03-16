/**
 * Provides classes and predicates for reasoning about cleartext database
 * storage vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

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
private class CoreDataStore extends CleartextStorageDatabaseSink {
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
    exists(NominalType t, Expr e |
      t.getABaseType*().getName() = "NSManagedObject" and
      this.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = t and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

/**
 * A `DataFlow::Node` that is an expression stored with the Realm database
 * library.
 */
private class RealmStore extends CleartextStorageDatabaseSink instanceof DataFlow::PostUpdateNode {
  RealmStore() {
    // any write into a class derived from `RealmSwiftObject` is a sink. For
    // example in `realmObj.data = sensitive` the post-update node corresponding
    // with `realmObj.data` is a sink.
    exists(NominalType t, Expr e |
      t.getABaseType*().getName() = "RealmSwiftObject" and
      this.getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = t and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

private class CleartextStorageDatabaseSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // GRDB sinks
        ";Database;true;allStatements(sql:arguments:);;;Argument[1];database-store",
        ";Database;true;execute(sql:arguments:);;;Argument[1];database-store",
        ";SQLRequest;true;init(sql:arguments:adapter:cached:);;;Argument[1];database-store",
        ";SQL;true;init(sql:arguments:);;;Argument[1];database-store",
        ";SQL;true;append(sql:arguments:);;;Argument[1];database-store",
        ";SQLStatementCursor;true;init(database:sql:arguments:prepFlags:);;;Argument[2];database-store",
        ";TableRecord;true;select(sql:arguments:);;;Argument[1];database-store",
        ";TableRecord;true;select(sql:arguments:as:);;;Argument[1];database-store",
        ";TableRecord;true;filter(sql:arguments:);;;Argument[1];database-store",
        ";TableRecord;true;order(sql:arguments:);;;Argument[1];database-store",
        ";Row;true;fetchCursor(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";Row;true;fetchAll(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";Row;true;fetchSet(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";Row;true;fetchOne(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";DatabaseValueConvertible;true;fetchCursor(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";DatabaseValueConvertible;true;fetchAll(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";DatabaseValueConvertible;true;fetchSet(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";DatabaseValueConvertible;true;fetchOne(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";FetchableRecord;true;fetchCursor(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";FetchableRecord;true;fetchAll(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";FetchableRecord;true;fetchSet(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";FetchableRecord;true;fetchOne(_:sql:arguments:adapter:);;;Argument[2];database-store",
        ";FetchableRecord;true;fetchCursor(_:arguments:adapter:);;;Argument[1];database-store",
        ";FetchableRecord;true;fetchAll(_:arguments:adapter:);;;Argument[1];database-store",
        ";FetchableRecord;true;fetchSet(_:arguments:adapter:);;;Argument[1];database-store",
        ";FetchableRecord;true;fetchOne(_:arguments:adapter:);;;Argument[1];database-store",
        ";Statement;true;execute(arguments:);;;Argument[0];database-store",
        ";CommonTableExpression;true;init(recursive:named:columns:sql:arguments:);;;Argument[4];database-store",
        ";Statement;true;setArguments(_:);;;Argument[0];database-store"
      ]
  }
}

/**
 * An encryption sanitizer for cleartext database storage vulnerabilities.
 */
private class CleartextStorageDatabaseEncryptionSanitizer extends CleartextStorageDatabaseSanitizer {
  CleartextStorageDatabaseEncryptionSanitizer() { this.asExpr() instanceof EncryptedExpr }
}

/**
 * An additional taint step for cleartext database storage vulnerabilities.
 */
private class CleartextStorageDatabaseArrayAdditionalTaintStep extends CleartextStorageDatabaseAdditionalTaintStep
{
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // needed until we have proper content flow through arrays.
    exists(ArrayExpr arr |
      nodeFrom.asExpr() = arr.getAnElement() and
      nodeTo.asExpr() = arr
    )
    or
    // if an object is sensitive, its fields are always sensitive
    // (this is needed because the sensitive data sources are in a sense
    //  approximate; for example we might identify `passwordBox` as a source,
    //  whereas it is more accurate to say that `passwordBox.textField` is the
    //  true source).
    nodeTo.asExpr().(MemberRefExpr).getBase() = nodeFrom.asExpr()
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextStorageDatabaseSink extends CleartextStorageDatabaseSink {
  DefaultCleartextStorageDatabaseSink() { sinkNode(this, "database-store") }
}
