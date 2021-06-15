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
  /** Gets a reference to a `MongoClient` instance. */
  private API::Node mongoClientInstance() {
    result = API::moduleImport("pymongo").getMember("MongoClient").getReturn() or
    result =
      API::moduleImport("flask_mongoengine")
          .getMember("MongoEngine")
          .getReturn()
          .getMember("get_db")
          .getReturn() or
    result =
      API::moduleImport(["mongoengine", "mongoengine.connection"])
          .getMember(["get_db", "connect"])
          .getReturn() or
    result = API::moduleImport("flask_pymongo").getMember("PyMongo").getReturn()
  }

  /** Gets a reference to a `MongoClient` DB. */
  private DataFlow::LocalSourceNode mongoClientDB(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript | result.asCfgNode() = subscript |
        subscript.getObject() = mongoClientInstance().getAUse().asCfgNode()
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoClientInstance().getAUse()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoClientDB(t2).track(t2, t))
  }

  /** Gets a reference to a `MongoClient` DB. */
  private DataFlow::Node mongoClientDB() {
    mongoClientDB(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /** Gets a reference to a `MongoClient` collection. */
  private DataFlow::LocalSourceNode mongoClientCollection(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(SubscriptNode subscript | result.asCfgNode() = subscript |
        subscript.getObject() = mongoClientDB().asCfgNode()
      )
      or
      result.(DataFlow::AttrRead).getObject() = mongoClientDB()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = mongoClientCollection(t2).track(t2, t))
  }

  /** Gets a reference to a `MongoClient` collection. */
  private DataFlow::Node mongoClientCollection() {
    mongoClientCollection(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /** This class represents names of find_* relevant MongoClient collection level operation methods. */
  private class MongoClientMethodNames extends string {
    MongoClientMethodNames() {
      // the find_one_or_404 method is only found in the Pymongo Flask library.
      this in [
          "find", "find_raw_batches", "find_one", "find_one_and_delete", "find_and_modify",
          "find_one_and_replace", "find_one_and_update", "find_one_or_404"
        ]
    }
  }

  /** Gets a reference to a `MongoClient` Collection method. */
  private DataFlow::Node mongoClientMethod() {
    result.(DataFlow::AttrRead).getAttributeName() instanceof MongoClientMethodNames and
    (
      result.(DataFlow::AttrRead).getObject() = mongoClientCollection() or
      result.(DataFlow::AttrRead) = mongoClientCollection()
    )
  }

  /** Gets a reference to a `MongoClient` call */
  private class MongoClientCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    MongoClientCall() { this.getFunction() = mongoClientMethod() }

    override DataFlow::Node getQuery() { result = this.getArg(0) }
  }

  private class MongoEngineObjectsCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    MongoEngineObjectsCall() {
      this =
        API::moduleImport("mongoengine")
            .getMember(["Document", "EmbeddedDocument"])
            .getASubclass()
            .getMember("objects")
            .getACall()
    }

    override DataFlow::Node getQuery() { result = this.getArgByName(_) }
  }

  private class FlaskMongoEngineObjectsCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    FlaskMongoEngineObjectsCall() {
      this =
        API::moduleImport("flask_mongoengine")
            .getMember("MongoEngine")
            .getReturn()
            .getMember(["Document", "EmbeddedDocument"])
            .getASubclass()
            .getMember("objects")
            .getACall()
    }

    override DataFlow::Node getQuery() { result = this.getArgByName(_) }
  }

  private DataFlow::Node flaskMongoEngineInstance() {
    result = API::moduleImport("flask_mongoengine").getMember("MongoEngine").getReturn().getAUse()
  }

  /**
   * A MongoEngine.Document or MongoEngine.EmbeddedDocument subclass which represents a MongoDB document.
   */
  private class FlaskMongoEngineDocumentClass extends ClassValue {
    FlaskMongoEngineDocumentClass() {
      this.getASuperType().getName() in ["Document", "EmbeddedDocument"] and
      exists(AttrNode documentClass |
        documentClass.getName() in ["Document", "EmbeddedDocument"] and
        documentClass.getObject() = flaskMongoEngineInstance().asCfgNode() and
        // This is super hacky. It checks to see if the class is a subclass of a flaskMongoEngineInstance.Document
        this.getASuperType()
            .getAReference()
            .getNode()
            .(ClassExpr)
            .contains(documentClass.getNode().getObject())
      )
    }
  }

  private class FlaskMongoEngineDocumentSubclassInstanceCall extends DataFlow::CallCfgNode,
    NoSQLQuery::Range {
    FlaskMongoEngineDocumentSubclassInstanceCall() {
      exists(
        DataFlow::CallCfgNode objectsCall,
        FlaskMongoEngineDocumentClass flaskMongoEngineDocumentClass
      |
        objectsCall.getFunction().asExpr().(Attribute).getObject().getAFlowNode() =
          flaskMongoEngineDocumentClass.getAReference() and
        objectsCall.asCfgNode().(CallNode).getNode().getFunc().(Attribute).getName() = "objects" and
        this = objectsCall
      )
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
