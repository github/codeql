/**
 * Provides classes for working with NoSQL libraries.
 */

import javascript
import semmle.javascript.Promises

module NoSQL {
  /** An expression that is interpreted as a NoSQL query. */
  abstract class Query extends Expr { }
}

/**
 * Provides classes modeling the MongoDB library.
 */
private module MongoDB {
  /**
   * Gets an import of MongoDB.
   */
  DataFlow::ModuleImportNode mongodb() { result.getPath() = "mongodb" }

  /**
   * Gets an access to `mongodb.MongoClient`.
   */
  private DataFlow::SourceNode getAMongoClient(DataFlow::TypeTracker t) {
    t.start() and
    result = mongodb().getAPropertyRead("MongoClient")
    or
    exists(DataFlow::TypeTracker t2 | result = getAMongoClient(t2).track(t2, t))
  }

  /**
   * Gets an access to `mongodb.MongoClient`.
   */
  DataFlow::SourceNode getAMongoClient() { result = getAMongoClient(DataFlow::TypeTracker::end()) }

  /** Gets a data flow node that leads to a `connect` callback. */
  private DataFlow::SourceNode getAMongoDbCallback(DataFlow::TypeBackTracker t) {
    t.start() and
    result = getAMongoClient().getAMemberCall("connect").getArgument(1).getALocalSource()
    or
    exists(DataFlow::TypeBackTracker t2 | result = getAMongoDbCallback(t2).backtrack(t2, t))
  }

  /** Gets a data flow node that leads to a `connect` callback. */
  private DataFlow::FunctionNode getAMongoDbCallback() {
    result = getAMongoDbCallback(DataFlow::TypeBackTracker::end())
  }

  /**
   * Gets an expression that may refer to a MongoDB database connection.
   */
  private DataFlow::SourceNode getAMongoDb(DataFlow::TypeTracker t) {
    t.start() and
    result = getAMongoDbCallback().getParameter(1)
    or
    exists(DataFlow::TypeTracker t2 | result = getAMongoDb(t2).track(t2, t))
  }

  /**
   * Gets an expression that may refer to a MongoDB database connection.
   */
  DataFlow::SourceNode getAMongoDb() { result = getAMongoDb(DataFlow::TypeTracker::end()) }

  /**
   * A data flow node that may hold a MongoDB collection.
   */
  abstract class Collection extends DataFlow::SourceNode { }

  /**
   * A collection resulting from calling `Db.collection(...)`.
   */
  private class CollectionFromDb extends Collection {
    CollectionFromDb() {
      this = getAMongoDb().getAMethodCall("collection")
      or
      this = getAMongoDb().getAMethodCall("collection").getCallback(1).getParameter(0)
    }
  }

  /**
   * A collection based on the type `mongodb.Collection`.
   *
   * Note that this also covers `mongoose` models since they are subtypes
   * of `mongodb.Collection`.
   */
  private class CollectionFromType extends Collection {
    CollectionFromType() { hasUnderlyingType("mongodb", "Collection") }
  }

  /** Gets a data flow node referring to a MongoDB collection. */
  private DataFlow::SourceNode getACollection(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof Collection
    or
    exists(DataFlow::TypeTracker t2 | result = getACollection(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a MongoDB collection. */
  DataFlow::SourceNode getACollection() { result = getACollection(DataFlow::TypeTracker::end()) }

  /** A call to a MongoDB query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string m | this = getACollection().getAMethodCall(m) |
        m = "count" and queryArgIdx = 0
        or
        m = "distinct" and queryArgIdx = 1
        or
        m = "find" and queryArgIdx = 0
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(queryArgIdx) }
  }

  /**
   * An expression that is interpreted as a MongoDB query.
   */
  class Query extends NoSQL::Query {
    Query() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }
}

/**
 * Provides classes modeling the Mongoose library.
 */
private module Mongoose {
  /**
   * Gets an import of Mongoose.
   */
  DataFlow::ModuleImportNode getAMongooseInstance() { result.getPath() = "mongoose" }

  /**
   * Gets a call to `mongoose.createConnection`.
   */
  DataFlow::CallNode createConnection() {
    result = getAMongooseInstance().getAMemberCall("createConnection")
  }

  /**
   * A Mongoose collection object.
   */
  class Model extends MongoDB::Collection {
    Model() { this = getAMongooseInstance().getAMemberCall("model") }
  }

  /**
   * An expression passed to `mongoose.createConnection` to supply credentials.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop | this = createConnection().getOptionArgument(3, prop).asExpr() |
        prop = "user" and kind = "user name"
        or
        prop = "pass" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
