/**
 * Provides classes for working with NoSQL libraries.
 */

import javascript

module NoSQL {
  /** An expression that is interpreted as a NoSQL query. */
  abstract class Query extends Expr {
    /** Gets an expression that is interpreted as a code operator in this query. */
    DataFlow::Node getACodeOperator() { none() }
  }
}

/**
 * Gets the value of a `$where` property of an object that flows to `n`.
 */
private DataFlow::Node getADollarWherePropertyValue(DataFlow::Node n) {
  result = n.getALocalSource().getAPropertyWrite("$where").getRhs()
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

    override DataFlow::Node getACodeOperator() {
      result = getADollarWherePropertyValue(this.flow())
    }
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
   * A Mongoose function invocation.
   */
  private class InvokeNode extends DataFlow::InvokeNode {
    /**
     * Holds if this invocation returns an object of type `Query`.
     */
    abstract predicate returnsQuery();

    /**
     * Holds if this invocation returns a `Query` that evaluates to one or
     * more Documents (`asArray` is false if it evaluates to a single
     * Document).
     */
    abstract predicate returnsDocumentQuery(boolean asArray);

    /**
     * Holds if this invocation interprets `arg` as a query.
     */
    abstract predicate interpretsArgumentAsQuery(DataFlow::Node arg);
  }

  /**
   * Provides classes modeling the Mongoose Model class
   */
  module Model {
    private class ModelInvokeNode extends InvokeNode, DataFlow::MethodCallNode {
      ModelInvokeNode() { this = ref().getAMethodCall() }

      override predicate returnsQuery() { MethodSignatures::returnsQuery(getMethodName()) }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(getMethodName(), asArray)
      }

      override predicate interpretsArgumentAsQuery(DataFlow::Node arg) {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(this.getMethodName(), n) and
          arg = this.getArgument(n)
        )
      }
    }

    /**
     * Gets a data flow node referring to a Mongoose Model object.
     */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      (
        result = getAMongooseInstance().getAMemberCall("model")
        or
        exists(DataFlow::SourceNode conn | conn = createConnection() |
          result = conn.getAMemberCall("model") or
          result = conn.getAPropertyRead("models").getAPropertyRead()
        )
        or
        result.hasUnderlyingType("mongoose", "Model")
      ) and
      t.start()
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    /**
     * Gets a data flow node referring to a Mongoose model object.
     */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }

    /**
     * Provides signatures for the Model methods.
     */
    module MethodSignatures {
      /**
       * Holds if Model method `name` interprets parameter `n` as a query.
       */
      predicate interpretsArgumentAsQuery(string name, int n) {
        // implement lots of the MongoDB collection interface
        MongoDB::CollectionMethodSignatures::interpretsArgumentAsQuery(name, n)
        or
        name = "findByIdAndUpdate" and n = 1
        or
        name = "where" and n = 0
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

      /**
       * Holds if Document method `name` returns a query that results in
       * one or more documents, the documents are wrapped in an array
       * if `asArray` is true.
       */
      predicate returnsDocumentQuery(string name, boolean asArray) {
        asArray = false and name = "findOne"
        or
        asArray = true and name = "find"
      }
    }
  }

  /**
   * Provides classes modeling the Mongoose Query class
   */
  module Query {
    private class QueryInvokeNode extends InvokeNode, DataFlow::MethodCallNode {
      QueryInvokeNode() { this = ref().getAMethodCall() }

      override predicate returnsQuery() { MethodSignatures::returnsQuery(getMethodName()) }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(getMethodName(), asArray)
      }

      override predicate interpretsArgumentAsQuery(DataFlow::Node arg) {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(this.getMethodName(), n) and
          arg = this.getArgument(n)
        )
      }
    }

    private class NewQueryInvokeNode extends InvokeNode {
      NewQueryInvokeNode() {
        this = getAMongooseInstance().getAPropertyRead("Query").getAnInstantiation()
      }

      override predicate returnsQuery() { any() }

      override predicate returnsDocumentQuery(boolean asArray) { none() }

      override predicate interpretsArgumentAsQuery(DataFlow::Node arg) { arg = this.getArgument(2) }
    }

    /**
     * Gets a data flow node referring to a Mongoose query object.
     */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      (
        result.(InvokeNode).returnsQuery() or
        result.hasUnderlyingType("mongoose", "Query")
      ) and
      t.start()
      or
      exists(DataFlow::TypeTracker t2, DataFlow::SourceNode succ | succ = ref(t2) |
        result = succ.track(t2, t)
        or
        result = succ.getAMethodCall(any(string name | MethodSignatures::returnsQuery(name))) and
        t = t2.continue()
      )
    }

    /**
     * Gets a data flow node referring to a Mongoose query object.
     */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }

    /**
     * Provides signatures for the Query methods.
     */
    module MethodSignatures {
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

      /**
       * Holds if Query method `name` returns a query that results in
       * one or more documents, the documents are wrapped in an array
       * if `asArray` is true.
       */
      predicate returnsDocumentQuery(string name, boolean asArray) {
        asArray = false and name = "findOne"
        or
        asArray = true and name = "find"
      }
    }
  }

  /**
   * Provides classes modeling the Mongoose Document class
   */
  module Document {
    private class DocumentInvokeNode extends InvokeNode, DataFlow::MethodCallNode {
      DocumentInvokeNode() { this = ref().getAMethodCall() }

      override predicate returnsQuery() { MethodSignatures::returnsQuery(getMethodName()) }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(getMethodName(), asArray)
      }

      override predicate interpretsArgumentAsQuery(DataFlow::Node arg) {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(this.getMethodName(), n) and
          arg = this.getArgument(n)
        )
      }
    }

    /**
     * A Mongoose Document that is retrieved from the backing database.
     */
    class RetrievedDocument extends DataFlow::SourceNode {
      RetrievedDocument() {
        exists(boolean asArray, DataFlow::ParameterNode param |
          exists(InvokeNode call |
            call.returnsDocumentQuery(asArray) and
            param = call.getCallback(call.getNumArgument() - 1).getParameter(1)
          )
          or
          exists(
            DataFlow::SourceNode base, DataFlow::MethodCallNode call, string executor,
            int paramIndex
          |
            executor = "then" and paramIndex = 0
            or
            executor = "exec" and paramIndex = 1
          |
            base = Query::ref() and
            call = base.getAMethodCall(executor) and
            param = call.getCallback(0).getParameter(paramIndex) and
            exists(DataFlow::MethodCallNode pred |
              // limitation: look at the previous method call
              Query::MethodSignatures::returnsDocumentQuery(pred.getMethodName(), asArray) and
              pred.getAMethodCall() = call
            )
          )
        |
          asArray = false and this = param
          or
          asArray = true and
          exists(DataFlow::PropRead access |
            // limitation: look for direct accesses
            access = param.getAPropertyRead() and
            not exists(access.getPropertyName()) and
            this = access
          )
        )
      }
    }

    /**
     * Gets a data flow node referring to a Mongoose Document object.
     */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      (
        result instanceof RetrievedDocument or
        result.hasUnderlyingType("mongoose", "Document")
      ) and
      t.start()
      or
      exists(DataFlow::TypeTracker t2, DataFlow::SourceNode succ | succ = ref(t2) |
        result = succ.track(t2, t)
        or
        result = succ.getAMethodCall(any(string name | MethodSignatures::returnsDocument(name))) and
        t = t2.continue()
      )
    }

    /**
     * Gets a data flow node referring to a Mongoose Document object.
     */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }

    private module MethodSignatures {
      /**
       * Holds if Document method `name` returns a Query.
       */
      predicate returnsQuery(string name) {
        // Documents are subtypes of Models
        Model::MethodSignatures::returnsQuery(name) or
        name = "replaceOne" or
        name = "update" or
        name = "updateOne"
      }

      /**
       * Holds if Document method `name` interprets parameter `n` as a query.
       */
      predicate interpretsArgumentAsQuery(string name, int n) {
        // Documents are subtypes of Models
        Model::MethodSignatures::interpretsArgumentAsQuery(name, n)
        or
        n = 0 and
        (
          name = "replaceOne" or
          name = "update" or
          name = "updateOne"
        )
      }

      /**
       * Holds if Document method `name` returns a query that results in
       * one or more documents, the documents are wrapped in an array
       * if `asArray` is true.
       */
      predicate returnsDocumentQuery(string name, boolean asArray) {
        // Documents are subtypes of Models
        Model::MethodSignatures::returnsDocumentQuery(name, asArray)
      }

      /**
       * Holds if Document method `name` returns a Document.
       */
      predicate returnsDocument(string name) {
        name = "depopulate" or
        name = "init" or
        name = "populate" or
        name = "overwrite"
      }
    }
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

  /**
   * An expression that is interpreted as a (part of a) MongoDB query.
   */
  class MongoDBQueryPart extends NoSQL::Query {
    MongoDBQueryPart() { any(InvokeNode call).interpretsArgumentAsQuery(this.flow()) }

    override DataFlow::Node getACodeOperator() {
      result = getADollarWherePropertyValue(this.flow())
    }
  }

  /**
   * An evaluation of a MongoDB query.
   */
  class ShorthandQueryEvaluation extends DatabaseAccess {
    InvokeNode invk;

    ShorthandQueryEvaluation() {
      this = invk and
      // shorthand for execution: provide a callback
      invk.returnsQuery() and
      exists(invk.getCallback(invk.getNumArgument() - 1))
    }

    override DataFlow::Node getAQueryArgument() {
      // NB: the complete information is not easily accessible for deeply chained calls
      invk.interpretsArgumentAsQuery(result)
    }
  }

  class ExplicitQueryEvaluation extends DatabaseAccess {
    ExplicitQueryEvaluation() {
      // explicit execution using a Query method call
      exists(string executor | executor = "exec" or executor = "then" or executor = "catch" |
        Query::ref().getAMethodCall(executor) = this
      )
    }

    override DataFlow::Node getAQueryArgument() {
      // NB: the complete information is not easily accessible for deeply chained calls
      none()
    }
  }
}

/**
 * Provides classes modeling the Minimongo library.
 */
private module Minimongo {
  /**
   * Gets an expression that may refer to a Minimongo database.
   */
  private DataFlow::SourceNode getADb(DataFlow::TypeTracker t) {
    t.start() and
    // new (require('minimongo')[DBKINDNAME])()
    result = DataFlow::moduleImport("minimongo").getAPropertyRead().getAnInvocation()
    or
    exists(DataFlow::TypeTracker t2 | result = getADb(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a Minimongo collection. */
  private DataFlow::SourceNode getACollection(DataFlow::TypeTracker t) {
    t.start() and
    // db[COLLECTIONNAME]
    result = getADb(DataFlow::TypeTracker::end()).getAPropertyRead()
    or
    exists(DataFlow::TypeTracker t2 | result = getACollection(t2).track(t2, t))
  }

  /**
   * Provides signatures for the Collection methods.
   */
  module CollectionMethodSignatures {
    /**
     * Holds if Collection method `name` interprets parameter `n` as a query.
     */
    predicate interpretsArgumentAsQuery(string m, int queryArgIdx) {
      // implements most of the MongoDB interface
      MongoDB::CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
    }
  }

  /** A call to a Minimongo query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string m | this = getACollection(DataFlow::TypeTracker::end()).getAMethodCall(m) |
        CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(queryArgIdx) }
  }

  /**
   * An expression that is interpreted as a Minimongo query.
   */
  class Query extends NoSQL::Query {
    Query() { this = any(QueryCall qc).getAQueryArgument().asExpr() }

    override DataFlow::Node getACodeOperator() {
      result = getADollarWherePropertyValue(this.flow())
    }
  }
}

/**
 * Provides classes modeling the MarsDB library.
 */
private module MarsDB {
  /**
   * Gets an expression that may refer to a MarsDB database.
   */
  private DataFlow::SourceNode getADb(DataFlow::TypeTracker t) {
    t.start() and
    // Collection = require('marsdb')
    result = DataFlow::moduleImport("marsdb")
    or
    exists(DataFlow::TypeTracker t2 | result = getADb(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a MarsDB collection. */
  private DataFlow::SourceNode getACollection(DataFlow::TypeTracker t) {
    t.start() and
    // new Collection(...)
    result =
      getADb(DataFlow::TypeTracker::end()).getAPropertyRead("Collection").getAnInstantiation()
    or
    exists(DataFlow::TypeTracker t2 | result = getACollection(t2).track(t2, t))
  }

  /** A call to a MarsDB query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string m | this = getACollection(DataFlow::TypeTracker::end()).getAMethodCall(m) |
        // implements parts of the Minimongo interface
        Minimongo::CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(queryArgIdx) }
  }

  /**
   * An expression that is interpreted as a MarsDB query.
   */
  class Query extends NoSQL::Query {
    Query() { this = any(QueryCall qc).getAQueryArgument().asExpr() }

    override DataFlow::Node getACodeOperator() {
      result = getADollarWherePropertyValue(this.flow())
    }
  }
}
