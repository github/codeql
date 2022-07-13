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

private module NoSql {
  // API Nodes returning `Mongo` instances.
  /** Gets a reference to `pymongo.MongoClient` */
  private API::Node pyMongo() {
    result = API::moduleImport("pymongo").getMember("MongoClient").getReturn()
    or
    // see https://pymongo.readthedocs.io/en/stable/api/pymongo/mongo_client.html#pymongo.mongo_client.MongoClient
    result =
      API::moduleImport("pymongo").getMember("mongo_client").getMember("MongoClient").getReturn()
  }

  /** Gets a reference to `flask_pymongo.PyMongo` */
  private API::Node flask_PyMongo() {
    result = API::moduleImport("flask_pymongo").getMember("PyMongo").getReturn()
  }

  /** Gets a reference to `mongoengine` */
  private API::Node mongoEngine() { result = API::moduleImport("mongoengine") }

  /** Gets a reference to `flask_mongoengine.MongoEngine` */
  private API::Node flask_MongoEngine() {
    result = API::moduleImport("flask_mongoengine").getMember("MongoEngine").getReturn()
  }

  /**
   * Gets a reference to an initialized `Mongo` instance.
   * See `pyMongo()`, `flask_PyMongo()`
   */
  private API::Node mongoClientInstance() {
    result = pyMongo() or
    result = flask_PyMongo()
  }

  /**
   * Gets a reference to a `Mongo` DB instance.
   */
  private DataFlow::LocalSourceNode mongoDBInstance(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript |
        subscript.getObject() = mongoClientInstance().getAValueReachableFromSource().asCfgNode() and
        result.asCfgNode() = subscript
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoClientInstance().getAValueReachableFromSource()
      or
      result = mongoEngine().getMember(["get_db", "connect"]).getACall()
      or
      result = mongoEngine().getMember("connection").getMember(["get_db", "connect"]).getACall()
      or
      result = flask_MongoEngine().getMember("get_db").getACall()
      or
      // see https://pymongo.readthedocs.io/en/stable/api/pymongo/mongo_client.html#pymongo.mongo_client.MongoClient.get_default_database
      // see https://pymongo.readthedocs.io/en/stable/api/pymongo/mongo_client.html#pymongo.mongo_client.MongoClient.get_database
      result = mongoClientInstance().getMember(["get_default_database", "get_database"]).getACall()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoDBInstance(t2).track(t2, t))
  }

  /**
   * Gets a reference to a `Mongo` DB use.
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db` would be a use of a `Mongo` instance, and so the result.
   */
  private DataFlow::Node mongoDBInstance() {
    mongoDBInstance(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /**
   * Gets a reference to a `Mongo` collection use.
   */
  private DataFlow::LocalSourceNode mongoCollection(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript | result.asCfgNode() = subscript |
        subscript.getObject() = mongoDBInstance().asCfgNode()
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoDBInstance()
      or
      // see https://pymongo.readthedocs.io/en/stable/api/pymongo/database.html#pymongo.database.Database.get_collection
      // see https://pymongo.readthedocs.io/en/stable/api/pymongo/database.html#pymongo.database.Database.create_collection
      result
          .(DataFlow::MethodCallNode)
          .calls(mongoDBInstance(), ["get_collection", "create_collection"])
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoCollection(t2).track(t2, t))
  }

  /**
   * Gets a reference to a `Mongo` collection use.
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db.user` would be a use of a `Mongo` collection, and so the result.
   */
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

  /**
   * Gets a reference to a `Mongo` collection method.
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db.user.find` would be a collection method, and so the result.
   */
  private DataFlow::Node mongoCollectionMethod() {
    mongoCollection() = result.(DataFlow::AttrRead).getObject() and
    result.(DataFlow::AttrRead).getAttributeName() instanceof MongoCollectionMethodNames
  }

  /**
   * Gets a reference to a `Mongo` collection method call
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db.user.find({'name': safe_search})` would be a collection method call, and so the result.
   */
  private class MongoCollectionCall extends DataFlow::CallCfgNode, NoSqlQuery::Range {
    MongoCollectionCall() { this.getFunction() = mongoCollectionMethod() }

    override DataFlow::Node getQuery() { result = this.getArg(0) }
  }

  /**
   * Gets a reference to a call from a class whose base is a reference to `mongoEngine()` or `flask_MongoEngine()`'s
   * `Document` or `EmbeddedDocument` objects and its attribute is `objects`.
   *
   * ```py
   * from flask_mongoengine import MongoEngine
   * db = MongoEngine(app)
   * class Movie(db.Document):
   *     title = db.StringField(required=True)
   *
   * Movie.objects(__raw__=json_search)
   * ```
   *
   * `Movie.objects(__raw__=json_search)` would be the result.
   */
  private class MongoEngineObjectsCall extends DataFlow::CallCfgNode, NoSqlQuery::Range {
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

  /** Gets a reference to `mongosanitizer.sanitizer.sanitize` */
  private class MongoSanitizerCall extends DataFlow::CallCfgNode, NoSqlSanitizer::Range {
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
  private class BsonObjectIdCall extends DataFlow::CallCfgNode, NoSqlSanitizer::Range {
    BsonObjectIdCall() {
      exists(API::Node mod |
        mod = API::moduleImport("bson")
        or
        mod = API::moduleImport("bson").getMember(["objectid", "json_util"])
      |
        this = mod.getMember("ObjectId").getACall()
      )
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
}
