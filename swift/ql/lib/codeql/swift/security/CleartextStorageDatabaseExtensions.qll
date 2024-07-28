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
 * A barrier for cleartext database storage vulnerabilities.
 */
abstract class CleartextStorageDatabaseBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CleartextStorageDatabaseAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
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
          .(Method)
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
      t.getUnderlyingType().getABaseType*().getName() = "NSManagedObject" and
      this.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = t and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

/**
 * The Realm database `RealmSwiftObject` type. Also matches the Realm `Object`
 * type, which may or may not be a type alias for `RealmSwiftObject`.
 */
class RealmSwiftObject extends Type {
  RealmSwiftObject() {
    this.getName() = "RealmSwiftObject"
    or
    this.getName() = "Object" and
    this.(NominalType).getDeclaration().getModule().getName() = "RealmSwift"
  }
}

/**
 * A class that inherits from `RealmSwiftObject`.
 */
class RealmSwiftObjectType extends Type {
  RealmSwiftObjectType() { this.getUnderlyingType().getABaseType*() instanceof RealmSwiftObject }
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
    exists(Expr e |
      this.getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() instanceof RealmSwiftObjectType and
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
        ";Statement;true;setArguments(_:);;;Argument[0];database-store",
        // sqlite3 sinks
        ";;false;sqlite3_exec(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare_v2(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare_v3(_:_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare16(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare16_v2(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_prepare16_v3(_:_:_:_:_:);;;Argument[1];database-store",
        ";;false;sqlite3_bind_blob(_:_:_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_blob64(_:_:_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_double(_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_int(_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_int64(_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_text(_:_:_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_text16(_:_:_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_text64(_:_:_:_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_value(_:_:_:);;;Argument[2];database-store",
        ";;false;sqlite3_bind_pointer(_:_:_:_:);;;Argument[2];database-store",
        // SQLite.swift
        ";Connection;true;execute(_:);;;Argument[0];database-store",
        ";Connection;true;prepare(_:_:);;;Argument[0];database-store",
        ";Connection;true;prepare(_:_:);;;Argument[1];database-store",
        ";Connection;true;run(_:_:);;;Argument[0];database-store",
        ";Connection;true;run(_:_:);;;Argument[1];database-store",
        ";Connection;true;scalar(_:_:);;;Argument[0];database-store",
        ";Connection;true;scalar(_:_:);;;Argument[1];database-store",
        ";Statement;true;init(_:_:);;;Argument[1];database-store",
        ";Statement;true;bind(_:);;;Argument[0];database-store",
        ";Statement;true;run(_:);;;Argument[0];database-store",
        ";Statement;true;scalar(_:);;;Argument[0];database-store",
        ";QueryType;true;insert(_:);;;Argument[0];database-store",
        ";QueryType;true;insert(_:_:);;;Argument[0..1];database-store",
        ";QueryType;true;insert(or:_:);;;Argument[1];database-store",
        ";QueryType;true;insertMany(_:);;;Argument[0];database-store",
        ";QueryType;true;insertMany(or:_:);;;Argument[1];database-store",
        ";QueryType;true;upsert(_:onConflictOf:);;;Argument[0];database-store",
        ";QueryType;true;upsert(_:onConflictOf:setValues:);;;Argument[0];database-store",
        ";QueryType;true;upsert(_:onConflictOf:setValues:);;;Argument[2];database-store",
        ";QueryType;true;update(_:);;;Argument[0];database-store",
        ";QueryType;true;update(_:_:);;;Argument[0..1];database-store",
        ";QueryType;true;update(or:_:);;;Argument[1];database-store",
      ]
  }
}

/**
 * A barrier for cleartext database storage vulnerabilities.
 *  - encryption; encrypted values are not cleartext.
 *  - booleans; these are more likely to be settings, rather than actual sensitive data.
 */
private class CleartextStorageDatabaseDefaultBarrier extends CleartextStorageDatabaseBarrier {
  CleartextStorageDatabaseDefaultBarrier() {
    this.asExpr() instanceof EncryptedExpr or
    this.asExpr().getType().getUnderlyingType() instanceof BoolType
  }
}

/**
 * An additional taint step for cleartext database storage vulnerabilities.
 */
private class CleartextStorageDatabaseFieldsAdditionalFlowStep extends CleartextStorageDatabaseAdditionalFlowStep
{
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
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
