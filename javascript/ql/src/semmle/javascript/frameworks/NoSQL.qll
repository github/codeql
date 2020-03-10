/**
 * Provides classes for working with NoSQL libraries.
 */

import javascript

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
    (
      result = mongodb().getAPropertyRead("MongoClient")
      or
      exists(DataFlow::ParameterNode p |
        p = result and
        p = getAMongoDbCallback().getParameter(1) and
        not p.getName().toLowerCase() = "db" // mongodb v2 provides a `Db` here
      )
    )
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
    result = getAMongoClient().getAMemberCall("connect").getLastArgument().getALocalSource()
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
    (
      exists(DataFlow::ParameterNode p |
        p = result and
        p = getAMongoDbCallback().getParameter(1) and
        not p.getName().toLowerCase() = "client" // mongodb v3 provides a `Mongoclient` here
      )
      or
      result = getAMongoClient().getAMethodCall("db")
    )
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
        CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(queryArgIdx) }
  }

  /**
   * Provides signatures for the Collection methods.
   */
  module CollectionMethodSignatures {
    /**
     * Holds if Collection method `name` interprets parameter `n` as a query.
     */
    predicate interpretsArgumentAsQuery(string name, int n) {
      // FilterQuery
      (
        name = "aggregate" and n = 0
        or
        name = "count" and n = 0
        or
        name = "countDocuments" and n = 0
        or
        name = "deleteMany" and n = 0
        or
        name = "deleteOne" and n = 0
        or
        name = "distinct" and n = 1
        or
        name = "find" and n = 0
        or
        name = "findOne" and n = 0
        or
        name = "findOneAndDelete" and n = 0
        or
        name = "findOneAndRemove" and n = 0
        or
        name = "findOneAndReplace" and n = 0
        or
        name = "findOneAndUpdate" and n = 0
        or
        name = "remove" and n = 0
        or
        name = "replaceOne" and n = 0
        or
        name = "update" and n = 0
        or
        name = "updateMany" and n = 0
        or
        name = "updateOne" and n = 0
      )
      or
      // UpdateQuery
      (
        name = "findOneAndUpdate" and n = 1
        or
        name = "update" and n = 1
        or
        name = "updateMany" and n = 1
        or
        name = "updateOne" and n = 1
      )
    }
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
   * Gets a data flow node referring to a Mongoose model object.
   */
  private DataFlow::SourceNode getAModel(DataFlow::TypeTracker t) {
    (
      result = getAMongooseInstance().getAMemberCall("model") or
      result.hasUnderlyingType("mongoose", "Model")
    ) and
    t.start()
    or
    exists(DataFlow::TypeTracker t2 | result = getAModel(t2).track(t2, t))
  }

  /**
   * Gets a data flow node referring to a Mongoose model object.
   */
  DataFlow::SourceNode getAModel() { result = getAModel(DataFlow::TypeTracker::end()) }

  /**
   * Provides signatures for the Model methods.
   */
  module ModelMethodSignatures {
    /**
     * Holds if Model method `name` interprets parameter `n` as a query.
     */
    predicate interpretsArgumentAsQuery(string name, int n) {
      // implement lots of the MongoDB collection interface
      MongoDB::CollectionMethodSignatures::interpretsArgumentAsQuery(name, n)
      or
      name = "findByIdAndUpdate" and n = 1
    }

    /**
     * Holds if Model method `name` returns a Query.
     */
    predicate returnsQuery(string name) {
      name = "$where" or
      name = "count" or
      name = "countDocuments" or
      name = "deleteMany" or
      name = "deleteOne" or
      name = "find" or
      name = "findById" or
      name = "findByIdAndDelete" or
      name = "findByIdAndRemove" or
      name = "findByIdAndUpdate" or
      name = "findOne" or
      name = "findOneAndDelete" or
      name = "findOneAndRemove" or
      name = "findOneAndReplace" or
      name = "findOneAndUpdate" or
      name = "geosearch" or
      name = "replaceOne" or
      name = "update" or
      name = "updateMany" or
      name = "updateOne" or
      name = "where"
    }
  }

  /**
   * Provides signatures for the Query methods.
   */
  module QueryMethodSignatures {
    /**
     * Holds if Query method `name` interprets parameter `n` as a query.
     */
    predicate interpretsArgumentAsQuery(string name, int n) {
      n = 0 and
      (
        name = "and" or
        name = "count" or
        name = "countDocuments" or
        name = "deleteMany" or
        name = "deleteOne" or
        name = "elemMatch" or
        name = "find" or
        name = "findOne" or
        name = "findOneAndDelete" or
        name = "findOneAndRemove" or
        name = "findOneAndReplace" or
        name = "findOneAndUpdate" or
        name = "merge" or
        name = "nor" or
        name = "or" or
        name = "remove" or
        name = "replaceOne" or
        name = "setQuery" or
        name = "setUpdate" or
        name = "update" or
        name = "updateMany" or
        name = "updateOne" or
        name = "where"
      )
      or
      n = 1 and
      (
        name = "distinct" or
        name = "findOneAndUpdate" or
        name = "update" or
        name = "updateMany" or
        name = "updateOne"
      )
    }

    /**
     * Holds if Query method `name` returns a Query.
     */
    predicate returnsQuery(string name) {
      name = "$where" or
      name = "J" or
      name = "all" or
      name = "and" or
      name = "batchsize" or
      name = "box" or
      name = "center" or
      name = "centerSphere" or
      name = "circle" or
      name = "collation" or
      name = "comment" or
      name = "count" or
      name = "countDocuments" or
      name = "distinct" or
      name = "elemMatch" or
      name = "equals" or
      name = "error" or
      name = "estimatedDocumentCount" or
      name = "exists" or
      name = "explain" or
      name = "find" or
      name = "findById" or
      name = "findOne" or
      name = "findOneAndRemove" or
      name = "findOneAndUpdate" or
      name = "geometry" or
      name = "get" or
      name = "gt" or
      name = "gte" or
      name = "hint" or
      name = "in" or
      name = "intersects" or
      name = "lean" or
      name = "limit" or
      name = "lt" or
      name = "lte" or
      name = "map" or
      name = "map" or
      name = "maxDistance" or
      name = "maxTimeMS" or
      name = "maxscan" or
      name = "mod" or
      name = "ne" or
      name = "near" or
      name = "nearSphere" or
      name = "nin" or
      name = "or" or
      name = "orFail" or
      name = "polygon" or
      name = "populate" or
      name = "read" or
      name = "readConcern" or
      name = "regexp" or
      name = "remove" or
      name = "select" or
      name = "session" or
      name = "set" or
      name = "setOptions" or
      name = "setQuery" or
      name = "setUpdate" or
      name = "size" or
      name = "skip" or
      name = "slaveOk" or
      name = "slice" or
      name = "snapshot" or
      name = "sort" or
      name = "update" or
      name = "w" or
      name = "where" or
      name = "within" or
      name = "wtimeout"
    }
  }

  /**
   * A Mongoose query object as a result of a Model method call.
   */
  private class QueryFromModel extends DataFlow::MethodCallNode {
    QueryFromModel() {
      exists(string name |
        ModelMethodSignatures::returnsQuery(name) and
        getAModel().getAMethodCall(name) = this
      )
    }
  }

  /**
   * A Mongoose query object as a result of a Query constructor invocation.
   */
  private class QueryFromConstructor extends DataFlow::NewNode {
    QueryFromConstructor() {
      this = getAMongooseInstance().getAPropertyRead("Query").getAnInstantiation()
    }
  }

  /**
   * Gets a data flow node referring to a Mongoose query object.
   */
  private DataFlow::SourceNode getAQuery(DataFlow::TypeTracker t) {
    (
      result instanceof QueryFromConstructor or
      result instanceof QueryFromModel or
      result.hasUnderlyingType("mongoose", "Query")
    ) and
    t.start()
    or
    exists(DataFlow::TypeTracker t2, DataFlow::SourceNode succ | succ = getAQuery(t2) |
      result = succ.track(t2, t)
      or
      result = succ.getAMethodCall(any(string name | QueryMethodSignatures::returnsQuery(name))) and
      t = t2.continue()
    )
  }

  /**
   * Gets a data flow node referring to a Mongoose query object.
   */
  private DataFlow::SourceNode getAQuery() { result = getAQuery(DataFlow::TypeTracker::end()) }

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

  /**
   * An expression that is interpreted as a (part of a) MongoDB query.
   */
  class MongoDBQueryPart extends NoSQL::Query {
    MongoDBQueryPart() {
      exists(DataFlow::MethodCallNode mcn, string method, int n |
        ModelMethodSignatures::interpretsArgumentAsQuery(method, n) and
        mcn = getAModel().getAMethodCall(method) and
        this = mcn.getArgument(n).asExpr()
      )
      or
      this = any(QueryFromConstructor c).getArgument(2).asExpr()
      or
      exists(string method, int n | QueryMethodSignatures::interpretsArgumentAsQuery(method, n) |
        this = getAQuery().getAMethodCall(method).getArgument(n).asExpr()
      )
    }
  }

  /**
   * An evaluation of a MongoDB query.
   */
  class MongoDBQueryEvaluation extends DatabaseAccess {
    DataFlow::MethodCallNode mcn;

    MongoDBQueryEvaluation() {
      this = mcn and
      (
        exists(string method |
          ModelMethodSignatures::returnsQuery(method) and
          mcn = getAModel().getAMethodCall(method) and
          // callback provided to a Model method call
          exists(mcn.getCallback(mcn.getNumArgument() - 1))
        )
        or
        getAQuery().getAMethodCall() = mcn and
        (
          // explicit execution using a Query method call
          exists(string executor | executor = "exec" or executor = "then" or executor = "catch" |
            mcn.getMethodName() = executor
          )
          or
          // callback provided to a Query method call
          exists(mcn.getCallback(mcn.getNumArgument() - 1))
        )
      )
    }

    override DataFlow::Node getAQueryArgument() {
      // NB: this does not account for all of the chained calls leading to this execution
      mcn.getAnArgument().asExpr().(MongoDBQueryPart).flow() = result
    }
  }
}
