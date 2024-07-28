/**
 * Provides classes modeling security-relevant aspects of the PyMongo bindings.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

private module PyMongo {
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
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db` would be a `Mongo` instance.
   */
  private API::Node mongoDBInstance() {
    result = mongoClientInstance().getASubscript()
    or
    result = mongoClientInstance().getAMember()
    or
    result = mongoEngine().getMember(["get_db", "connect"]).getReturn()
    or
    result = mongoEngine().getMember("connection").getMember(["get_db", "connect"]).getReturn()
    or
    result = flask_MongoEngine().getMember("get_db").getReturn()
    or
    // see https://pymongo.readthedocs.io/en/stable/api/pymongo/mongo_client.html#pymongo.mongo_client.MongoClient.get_default_database
    // see https://pymongo.readthedocs.io/en/stable/api/pymongo/mongo_client.html#pymongo.mongo_client.MongoClient.get_database
    result = mongoClientInstance().getMember(["get_default_database", "get_database"]).getReturn()
  }

  /**
   * Gets a reference to a `Mongo` collection.
   *
   * ```py
   * from flask_pymongo import PyMongo
   * mongo = PyMongo(app)
   * mongo.db.user.find({'name': safe_search})
   * ```
   *
   * `mongo.db.user` would be a `Mongo` collection.
   */
  private API::Node mongoCollection() {
    result = mongoDBInstance().getASubscript()
    or
    result = mongoDBInstance().getAMember()
    or
    // see https://pymongo.readthedocs.io/en/stable/api/pymongo/database.html#pymongo.database.Database.get_collection
    // see https://pymongo.readthedocs.io/en/stable/api/pymongo/database.html#pymongo.database.Database.create_collection
    result = mongoDBInstance().getMember(["get_collection", "create_collection"]).getReturn()
  }

  /** Gets the name of a find_* relevant `Mongo` collection-level operation method. */
  private string mongoCollectionMethodName() {
    result in [
        "find", "find_raw_batches", "find_one", "find_one_and_delete", "find_and_modify",
        "find_one_and_replace", "find_one_and_update", "find_one_or_404"
      ]
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
   * `mongo.db.user.find({'name': safe_search})` would be a collection method call.
   */
  private class MongoCollectionCall extends API::CallNode, NoSqlExecution::Range {
    MongoCollectionCall() {
      this = mongoCollection().getMember(mongoCollectionMethodName()).getACall()
    }

    /** Gets the argument that specifies the NoSQL query to be executed, as an API::node */
    pragma[inline]
    API::Node getQueryAsApiNode() {
      // 'filter' is allowed keyword in pymongo, see https://pymongo.readthedocs.io/en/stable/api/pymongo/collection.html#pymongo.collection.Collection.find
      result = this.getParameter(0, "filter")
    }

    override DataFlow::Node getQuery() { result = this.getQueryAsApiNode().asSink() }

    override predicate interpretsDict() { any() }

    override predicate vulnerableToStrings() { none() }
  }

  /**
   * See https://pymongo.readthedocs.io/en/stable/api/pymongo/collection.html#pymongo.collection.Collection.aggregate
   */
  private class MongoCollectionAggregation extends API::CallNode, NoSqlExecution::Range {
    MongoCollectionAggregation() { this = mongoCollection().getMember("aggregate").getACall() }

    override DataFlow::Node getQuery() {
      result = this.getParameter(0, "pipeline").getASubscript().asSink()
    }

    override predicate interpretsDict() { any() }

    override predicate vulnerableToStrings() { none() }
  }

  private class MongoMapReduce extends API::CallNode, NoSqlExecution::Range {
    MongoMapReduce() { this = mongoCollection().getMember("map_reduce").getACall() }

    override DataFlow::Node getQuery() { result in [this.getArg(0), this.getArg(1)] }

    override predicate interpretsDict() { none() }

    override predicate vulnerableToStrings() { any() }
  }

  private class MongoMapReduceQuery extends API::CallNode, NoSqlExecution::Range {
    MongoMapReduceQuery() { this = mongoCollection().getMember("map_reduce").getACall() }

    override DataFlow::Node getQuery() { result = this.getArgByName("query") }

    override predicate interpretsDict() { any() }

    override predicate vulnerableToStrings() { none() }
  }

  /** The `$where` query operator executes a string as JavaScript. */
  private class WhereQueryOperator extends DataFlow::Node, Decoding::Range {
    DataFlow::Node query;

    WhereQueryOperator() {
      exists(API::Node dictionary |
        dictionary = any(MongoCollectionCall c).getQueryAsApiNode() and
        query = dictionary.getSubscript("$where").asSink() and
        this = dictionary.getAValueReachingSink()
      )
    }

    override DataFlow::Node getAnInput() { result = query }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "NoSQL" }

    override predicate mayExecuteInput() { none() }
  }

  /**
   * The `$function` query operator executes its `body` string as JavaScript.
   *
   * See https://www.mongodb.com/docs/manual/reference/operator/aggregation/function/#mongodb-expression-exp.-function
   */
  private class FunctionQueryOperator extends DataFlow::Node, Decoding::Range {
    DataFlow::Node query;

    FunctionQueryOperator() {
      exists(API::Node dictionary |
        dictionary =
          any(MongoCollectionCall c).getQueryAsApiNode().getASubscript*().getSubscript("$function") and
        query = dictionary.getSubscript("body").asSink() and
        this = dictionary.getAValueReachingSink()
      )
    }

    override DataFlow::Node getAnInput() { result = query }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "NoSQL" }

    override predicate mayExecuteInput() { none() }
  }

  /**
   * The `$accumulator` query operator executes strings in some of its fields as JavaScript.
   *
   * See https://www.mongodb.com/docs/manual/reference/operator/aggregation/accumulator/#mongodb-group-grp.-accumulator
   */
  private class AccumulatorQueryOperator extends DataFlow::Node, Decoding::Range {
    DataFlow::Node query;

    AccumulatorQueryOperator() {
      exists(API::Node dictionary |
        dictionary =
          mongoCollection()
              .getMember("aggregate")
              .getACall()
              .getParameter(0)
              .getASubscript*()
              .getSubscript("$accumulator") and
        query = dictionary.getSubscript(["init", "accumulate", "merge", "finalize"]).asSink() and
        this = dictionary.getAValueReachingSink()
      )
    }

    override DataFlow::Node getAnInput() { result = query }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "NoSQL" }

    override predicate mayExecuteInput() { any() }
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
  private class MongoEngineObjectsCall extends DataFlow::CallCfgNode, NoSqlExecution::Range {
    MongoEngineObjectsCall() {
      this =
        [mongoEngine(), flask_MongoEngine()]
            .getMember(["Document", "EmbeddedDocument"])
            .getASubclass()
            .getMember("objects")
            .getACall()
    }

    override DataFlow::Node getQuery() { result = this.getArgByName(_) }

    override predicate interpretsDict() { any() }

    override predicate vulnerableToStrings() { none() }
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
   * An equality operator can protect against dictionary interpretation.
   * For instance, in `{'password': {"$eq": password} }`, if a dictionary is injected into
   * `password`, it will not match.
   */
  private class EqualityOperator extends DataFlow::Node, NoSqlSanitizer::Range {
    EqualityOperator() {
      this =
        any(MongoCollectionCall c).getQueryAsApiNode().getASubscript*().getSubscript("$eq").asSink()
    }

    override DataFlow::Node getAnInput() { result = this }
  }
}
