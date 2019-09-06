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
  DataFlow::SourceNode getAMongoClient() { result = mongodb().getAPropertyRead("MongoClient") }

  /**
   * Gets an expression that may refer to a MongoDB database connection.
   */
  DataFlow::SourceNode getAMongoDb() {
    result = getAMongoClient().getAMemberCall("connect").getCallback(1).getParameter(1)
  }

  /**
   * An expression that may hold a MongoDB collection.
   */
  abstract class Collection extends Expr { }

  /**
   * A collection resulting from calling `Db.collection(...)`.
   */
  private class CollectionFromDb extends Collection {
    CollectionFromDb() {
      exists(DataFlow::CallNode collection |
        collection = getAMongoDb().getAMethodCall("collection")
      |
        collection.flowsToExpr(this)
        or
        collection.getCallback(1).getParameter(0).flowsToExpr(this)
      )
    }
  }

  /** A call to a MongoDB query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;
    int queryArgIdx;

    QueryCall() {
      exists(string m | asExpr().(MethodCallExpr).calls(any(Collection c), m) |
        m = "aggregate" and queryArgIdx = 0
        or
        m = "count" and queryArgIdx = 0
        or
        m = "deleteMany" and queryArgIdx = 0
        or
        m = "deleteOne" and queryArgIdx = 0
        or
        m = "distinct" and queryArgIdx = 1
        or
        m = "find" and queryArgIdx = 0
        or
        m = "findOne" and queryArgIdx = 0
        or
        m = "findOneAndDelete" and queryArgIdx = 0
        or
        m = "findOneAndRemove" and queryArgIdx = 0
        or
        m = "findOneAndDelete" and queryArgIdx = 0
        or
        m = "findOneAndUpdate" and queryArgIdx = 0
        or
        m = "remove" and queryArgIdx = 0
        or
        m = "replaceOne" and queryArgIdx = 0
        or
        m = "update" and queryArgIdx = 0
        or
        m = "updateMany" and queryArgIdx = 0
        or
        m = "updateOne" and queryArgIdx = 0
      )
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(queryArgIdx))
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
  MethodCallExpr createConnection() {
    result = getAMongooseInstance().getAMemberCall("createConnection").asExpr()
  }

  /**
   * A Mongoose collection object.
   */
  class Model extends MongoDB::Collection {
    Model() { getAMongooseInstance().getAMemberCall("model").flowsToExpr(this) }
  }

  /**
   * An expression passed to `mongoose.createConnection` to supply credentials.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop | createConnection().hasOptionArgument(3, prop, this) |
        prop = "user" and kind = "user name"
        or
        prop = "pass" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
