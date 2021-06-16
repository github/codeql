/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module NoSQL {
  /** API Nodes returning `Mongo` instances. */
  private API::Node pyMongo() {
    result = API::moduleImport("pymongo").getMember("MongoClient").getReturn()
  }

  private API::Node flask_PyMongo() {
    result = API::moduleImport("flask_pymongo").getMember("PyMongo").getReturn()
  }

  private API::Node mongoEngine() { result = API::moduleImport("mongoengine") }

  private API::Node flask_MongoEngine() {
    result = API::moduleImport("flask_mongoengine").getMember("MongoEngine").getReturn()
  }

  /** Gets a reference to a initialized `Mongo` instance. */
  private API::Node mongoInstance() {
    result = pyMongo() or
    result = flask_PyMongo()
  }

  /** Gets a reference to a initialized `Mongo` DB instance. */
  private API::Node mongoDBInstance() {
    result = mongoEngine().getMember(["get_db", "connect"]).getReturn() or
    result = mongoEngine().getMember("connection").getMember(["get_db", "connect"]).getReturn() or
    result = flask_MongoEngine().getMember("get_db").getReturn()
  }

  /** Gets a reference to a `Mongo` DB use. */
  private DataFlow::LocalSourceNode mongoDB(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript |
        subscript.getObject() = mongoInstance().getAUse().asCfgNode() and
        result.asCfgNode() = subscript
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoInstance().getAUse()
      or
      result = mongoDBInstance().getAUse()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoDB(t2).track(t2, t))
  }

  /** Gets a reference to a `Mongo` DB use. */
  private DataFlow::Node mongoDB() { mongoDB(DataFlow::TypeTracker::end()).flowsTo(result) }

  /** Gets a reference to a `Mongo` collection use. */
  private DataFlow::LocalSourceNode mongoCollection(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript | result.asCfgNode() = subscript |
        subscript.getObject() = mongoDB().asCfgNode()
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoDB()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoCollection(t2).track(t2, t))
  }

  /** Gets a reference to a `Mongo` collection use. */
  private DataFlow::Node mongoCollection() {
    mongoCollection(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /** This class represents names of find_* relevant `Mongo` collection-level operation methods. */
  private class MongoCollectionMethodNames extends string {
    MongoCollectionMethodNames() {
      this in [
          "find", "find_raw_batches", "find_one", "find_one_and_delete", "find_and_modify",
          "find_one_and_replace", "find_one_and_update", "find_one_or_404"
        ]
    }
  }

  /** Gets a reference to a `Mongo` collection method. */
  private DataFlow::Node mongoCollectionMethod() {
    mongoCollection() in [result.(DataFlow::AttrRead), result.(DataFlow::AttrRead).getObject()] and
    result.(DataFlow::AttrRead).getAttributeName() instanceof MongoCollectionMethodNames
  }

  /** Gets a reference to a `Mongo` collection method call */
  private class MongoCollectionCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    MongoCollectionCall() { this.getFunction() = mongoCollectionMethod() }

    override DataFlow::Node getQuery() { result = this.getArg(0) }
  }

  private class MongoEngineObjectsCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    MongoEngineObjectsCall() {
      this =
        [mongoEngine(), flask_MongoEngine()]
            .getMember(["Document", "EmbeddedDocument"])
            .getASubclass()
            .getMember("objects")
            .getACall()
    }

    override DataFlow::Node getQuery() { result = this.getArgByName(_) }
  }

  private class MongoSanitizerCall extends DataFlow::CallCfgNode, NoSQLSanitizer::Range {
    MongoSanitizerCall() {
      this =
        API::moduleImport("mongosanitizer").getMember("sanitizer").getMember("sanitize").getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }

  /**
   * ObjectId returns a string representing an id.
   * If at any time ObjectId can't parse it's input (like when a tainted dict in passed in),
   * then ObjectId will throw an error preventing the query from running.
   */
  private class BsonObjectIdCall extends DataFlow::CallCfgNode, NoSQLSanitizer::Range {
    BsonObjectIdCall() {
      this =
        API::moduleImport(["bson", "bson.objectid", "bson.json_util"])
            .getMember("ObjectId")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
}
