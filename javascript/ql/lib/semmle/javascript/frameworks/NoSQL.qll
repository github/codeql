/**
 * Provides classes for working with NoSQL libraries.
 */

import javascript
import semmle.javascript.Promises

/** Provices classes for modelling NoSQL query sinks. */
module NoSql {
  /** An expression that is interpreted as a NoSQL query. */
  abstract class Query extends Expr {
    /** Gets an expression that is interpreted as a code operator in this query. */
    DataFlow::Node getACodeOperator() { none() }
  }
}

/** DEPRECATED: Alias for NoSql */
deprecated module NoSQL = NoSql;

/**
 * Gets a value that has been assigned to the "$where" property of an object that flows to `queryArg`.
 */
private DataFlow::Node getADollarWhereProperty(API::Node queryArg) {
  result = queryArg.getMember("$where").getARhs()
}

/**
 * Provides classes modeling the MongoDB library.
 */
private module MongoDB {
  /**
   * Gets an access to `mongodb.MongoClient` or a database.
   *
   * In Mongo version 2.x, a client and a database handle were the same concept, but in 3.x
   * they were separated. To handle everything with a single model, we treat them as the same here.
   */
  private API::Node getAMongoClientOrDatabase() {
    result = API::moduleImport("mongodb").getMember("MongoClient")
    or
    result = getAMongoClientOrDatabase().getMember("db").getReturn()
    or
    result = getAMongoClientOrDatabase().getMember("connect").getLastParameter().getParameter(1)
  }

  /** Gets a data flow node referring to a MongoDB collection. */
  private API::Node getACollection() {
    // A collection resulting from calling `Db.collection(...)`.
    exists(API::Node collection |
      collection = getAMongoClientOrDatabase().getMember("collection").getReturn()
    |
      result = collection
      or
      result = collection.getParameter(1).getParameter(0)
    )
    or
    // note that this also covers `mongoose` models since they are subtypes of `mongodb.Collection`
    result = API::Node::ofType("mongodb", "Collection")
  }

  /** A call to a MongoDB query method. */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string method |
        CollectionMethodSignatures::interpretsArgumentAsQuery(method, queryArgIdx) and
        this = getACollection().getMember(method).getACall()
      )
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(queryArgIdx) }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    DataFlow::Node getACodeOperator() {
      result = getADollarWhereProperty(this.getParameter(queryArgIdx))
    }
  }

  /**
   * An expression that is interpreted as a MongoDB query.
   */
  class Query extends NoSql::Query {
    QueryCall qc;

    Query() { this = qc.getAQueryArgument().asExpr() }

    override DataFlow::Node getACodeOperator() { result = qc.getACodeOperator() }
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
}

/**
 * Provides classes modeling the Mongoose library.
 */
private module Mongoose {
  /**
   * Gets an import of Mongoose.
   */
  API::Node getAMongooseInstance() { result = API::moduleImport("mongoose") }

  /**
   * Gets a reference to `mongoose.createConnection`.
   */
  API::Node createConnection() { result = getAMongooseInstance().getMember("createConnection") }

  /**
   * A Mongoose function.
   */
  abstract private class MongooseFunction extends API::Node {
    /**
     * Gets the API-graph node for the result from this function (if the function returns a `Query`).
     */
    abstract API::Node getQueryReturn();

    /**
     * Holds if this function returns a `Query` that evaluates to one or
     * more Documents (`asArray` is false if it evaluates to a single
     * Document).
     */
    abstract predicate returnsDocumentQuery(boolean asArray);

    /**
     * Gets an argument that this function interprets as a query.
     */
    abstract API::Node getQueryArgument();
  }

  /**
   * Provides classes modeling the Mongoose Model class
   */
  module Model {
    private class ModelFunction extends MongooseFunction {
      string methodName;

      ModelFunction() { this = getModelObject().getMember(methodName) }

      override API::Node getQueryReturn() {
        MethodSignatures::returnsQuery(methodName) and result = this.getReturn()
      }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(methodName, asArray)
      }

      override API::Node getQueryArgument() {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(methodName, n) and
          result = this.getParameter(n)
        )
      }
    }

    /**
     * Gets a API-graph node referring to a Mongoose Model object.
     */
    private API::Node getModelObject() {
      result = getAMongooseInstance().getMember("model").getReturn()
      or
      exists(API::Node conn | conn = createConnection().getReturn() |
        result = conn.getMember("model").getReturn() or
        result = conn.getMember("models").getAMember()
      )
      or
      result = API::Node::ofType("mongoose", "Model")
    }

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
        name = "find" + ["ById", "One"] + "AndUpdate" and n = 1
        or
        name in ["delete" + ["Many", "One"], "geoSearch", "remove", "replaceOne", "where"] and
        n = 0
        or
        name in [
            "find" + ["", "ById", "One"],
            "find" + ["ById", "One"] + "And" + ["Delete", "Remove", "Update"],
            "update" + ["", "Many", "One"]
          ] and
        n = 0
      }

      /**
       * Holds if Model method `name` returns a Query.
       */
      predicate returnsQuery(string name) {
        name =
          [
            "$where", "count", "findOne", "findOneAndDelete", "findOneAndRemove",
            "findOneAndReplace", "findOneAndUpdate", "geosearch", "remove", "replaceOne", "update",
            "updateMany", "countDocuments", "updateOne", "where", "deleteMany", "deleteOne", "find",
            "findById", "findByIdAndDelete", "findByIdAndRemove", "findByIdAndUpdate"
          ]
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
    private class QueryFunction extends MongooseFunction {
      string methodName;

      QueryFunction() { this = getAMongooseQuery().getMember(methodName) }

      override API::Node getQueryReturn() {
        MethodSignatures::returnsQuery(methodName) and result = this.getReturn()
      }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(methodName, asArray)
      }

      override API::Node getQueryArgument() {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(methodName, n) and
          result = this.getParameter(n)
        )
      }
    }

    private class NewQueryFunction extends MongooseFunction {
      NewQueryFunction() { this = getAMongooseInstance().getMember("Query") }

      override API::Node getQueryReturn() { result = this.getInstance() }

      override predicate returnsDocumentQuery(boolean asArray) { none() }

      override API::Node getQueryArgument() { result = this.getParameter(2) }
    }

    /**
     * Gets a data flow node referring to a Mongoose query object.
     */
    API::Node getAMongooseQuery() {
      result = any(MongooseFunction f).getQueryReturn()
      or
      result = API::Node::ofType("mongoose", "Query")
      or
      result =
        getAMongooseQuery()
            .getMember(any(string name | MethodSignatures::returnsQuery(name)))
            .getReturn()
    }

    /**
     * Provides signatures for the Query methods.
     */
    module MethodSignatures {
      /**
       * Holds if Query method `name` interprets parameter `n` as a query.
       */
      predicate interpretsArgumentAsQuery(string name, int n) {
        n = 0 and
        name =
          [
            "and", "count", "findOneAndReplace", "findOneAndUpdate", "merge", "nor", "or", "remove",
            "replaceOne", "setQuery", "setUpdate", "update", "countDocuments", "updateMany",
            "updateOne", "where", "deleteMany", "deleteOne", "elemMatch", "find", "findOne",
            "findOneAndDelete", "findOneAndRemove"
          ]
        or
        n = 1 and
        name = ["distinct", "findOneAndUpdate", "update", "updateMany", "updateOne"]
      }

      /**
       * Holds if Query method `name` returns a Query.
       */
      predicate returnsQuery(string name) {
        name =
          [
            "$where", "J", "comment", "count", "countDocuments", "distinct", "elemMatch", "equals",
            "error", "estimatedDocumentCount", "exists", "explain", "all", "find", "findById",
            "findOne", "findOneAndRemove", "findOneAndUpdate", "geometry", "get", "gt", "gte",
            "hint", "and", "in", "intersects", "lean", "limit", "lt", "lte", "map", "map",
            "maxDistance", "maxTimeMS", "batchsize", "maxscan", "mod", "ne", "near", "nearSphere",
            "nin", "or", "orFail", "polygon", "populate", "box", "read", "readConcern", "regexp",
            "remove", "select", "session", "set", "setOptions", "setQuery", "setUpdate", "center",
            "size", "skip", "slaveOk", "slice", "snapshot", "sort", "update", "w", "where",
            "within", "centerSphere", "wtimeout", "circle", "collation"
          ]
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
    private class DocumentFunction extends MongooseFunction {
      string methodName;

      DocumentFunction() { this = getAMongooseDocument().getMember(methodName) }

      override API::Node getQueryReturn() {
        MethodSignatures::returnsQuery(methodName) and result = this.getReturn()
      }

      override predicate returnsDocumentQuery(boolean asArray) {
        MethodSignatures::returnsDocumentQuery(methodName, asArray)
      }

      override API::Node getQueryArgument() {
        exists(int n |
          MethodSignatures::interpretsArgumentAsQuery(methodName, n) and
          result = this.getParameter(n)
        )
      }
    }

    /**
     * A Mongoose Document that is retrieved from the backing database.
     */
    class RetrievedDocument extends API::Node {
      RetrievedDocument() {
        exists(boolean asArray, API::Node param |
          exists(MongooseFunction func |
            func.returnsDocumentQuery(asArray) and
            param = func.getLastParameter().getParameter(1)
          )
          or
          exists(API::Node f |
            f = Query::getAMongooseQuery().getMember("then") and
            param = f.getParameter(0).getParameter(0)
            or
            f = Query::getAMongooseQuery().getMember("exec") and
            param = f.getParameter(0).getParameter(1)
          |
            exists(DataFlow::MethodCallNode pred |
              // limitation: look at the previous method call	
              Query::MethodSignatures::returnsDocumentQuery(pred.getMethodName(), asArray) and
              pred.getAMethodCall() = f.getACall()
            )
          )
        |
          asArray = false and this = param
          or
          asArray = true and
          // limitation: look for direct accesses
          this = param.getUnknownMember()
        )
      }
    }

    /**
     * Gets a data flow node referring to a Mongoose Document object.
     */
    private API::Node getAMongooseDocument() {
      result instanceof RetrievedDocument
      or
      result = API::Node::ofType("mongoose", "Document")
      or
      result =
        getAMongooseDocument()
            .getMember(any(string name | MethodSignatures::returnsDocument(name)))
            .getReturn()
    }

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
        name = ["depopulate", "init", "populate", "overwrite"]
      }
    }
  }

  /**
   * An expression passed to `mongoose.createConnection` to supply credentials.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop |
        this = createConnection().getParameter(3).getMember(prop).getARhs().asExpr()
      |
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
  class MongoDBQueryPart extends NoSql::Query {
    MongooseFunction f;

    MongoDBQueryPart() { this = f.getQueryArgument().getARhs().asExpr() }

    override DataFlow::Node getACodeOperator() {
      result = getADollarWhereProperty(f.getQueryArgument())
    }
  }

  /**
   * An evaluation of a MongoDB query.
   */
  class ShorthandQueryEvaluation extends DatabaseAccess, DataFlow::InvokeNode {
    MongooseFunction f;

    ShorthandQueryEvaluation() {
      this = f.getACall() and
      // shorthand for execution: provide a callback
      exists(f.getQueryReturn()) and
      exists(this.getCallback(this.getNumArgument() - 1))
    }

    override DataFlow::Node getAQueryArgument() {
      // NB: the complete information is not easily accessible for deeply chained calls
      f.getQueryArgument().getARhs() = result
    }

    override DataFlow::Node getAResult() {
      result = this.getCallback(this.getNumArgument() - 1).getParameter(1)
    }
  }

  class ExplicitQueryEvaluation extends DatabaseAccess, DataFlow::CallNode {
    string member;

    ExplicitQueryEvaluation() {
      // explicit execution using a Query method call
      member = ["exec", "then", "catch"] and
      Query::getAMongooseQuery().getMember(member).getACall() = this
    }

    private int resultParamIndex() {
      member = "then" and result = 0
      or
      member = "exec" and result = 1
    }

    override DataFlow::Node getAResult() {
      result = this.getCallback(_).getParameter(this.resultParamIndex())
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
  private class QueryCall extends DatabaseAccess, API::CallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string m |
        this =
          API::moduleImport("minimongo")
              .getAMember()
              .getReturn()
              .getAMember()
              .getMember(m)
              .getACall() and
        CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
      )
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(queryArgIdx) }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    DataFlow::Node getACodeOperator() {
      result = getADollarWhereProperty(this.getParameter(queryArgIdx))
    }
  }

  /**
   * An expression that is interpreted as a Minimongo query.
   */
  class Query extends NoSql::Query {
    QueryCall qc;

    Query() { this = qc.getAQueryArgument().asExpr() }

    override DataFlow::Node getACodeOperator() { result = qc.getACodeOperator() }
  }
}

/**
 * Provides classes modeling the MarsDB library.
 */
private module MarsDB {
  private class MarsDBAccess extends DatabaseAccess, DataFlow::CallNode {
    string method;

    MarsDBAccess() {
      this =
        API::moduleImport("marsdb")
            .getMember("Collection")
            .getInstance()
            .getMember(method)
            .getACall()
    }

    string getMethod() { result = method }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { none() }
  }

  /** A call to a MarsDB query method. */
  private class QueryCall extends MarsDBAccess, API::CallNode {
    int queryArgIdx;

    QueryCall() {
      exists(string m |
        this.getMethod() = m and
        // implements parts of the Minimongo interface
        Minimongo::CollectionMethodSignatures::interpretsArgumentAsQuery(m, queryArgIdx)
      )
    }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(queryArgIdx) }

    DataFlow::Node getACodeOperator() {
      result = getADollarWhereProperty(this.getParameter(queryArgIdx))
    }
  }

  /**
   * An expression that is interpreted as a MarsDB query.
   */
  class Query extends NoSql::Query {
    QueryCall qc;

    Query() { this = qc.getAQueryArgument().asExpr() }

    override DataFlow::Node getACodeOperator() { result = qc.getACodeOperator() }
  }
}

/**
 * Provides classes modeling the `Node Redis` library.
 *
 * Redis is an in-memory key-value store and not a database,
 * but `Node Redis` can be exploited similarly to a NoSQL database by giving a method an array as argument instead of a string.
 * As an example the below two invocations of `client.set` are equivalent:
 *
 * ```
 * const redis = require("redis");
 * const client = redis.createClient();
 * client.set("key", "value");
 * client.set(["key", "value"]);
 * ```
 *
 * ioredis is a very similar library. However, ioredis does not support array arguments in the same way, and is therefore not vulnerable to the same kind of type confusion.
 */
private module Redis {
  /**
   * Gets a `Node Redis` client.
   */
  private API::Node client() {
    result = API::moduleImport("redis").getMember("createClient").getReturn()
    or
    result = API::moduleImport("redis").getMember("RedisClient").getInstance()
    or
    result = client().getMember("duplicate").getReturn()
    or
    result = client().getMember("duplicate").getLastParameter().getParameter(1)
  }

  /**
   * Gets a (possibly chained) reference to a batch operation object.
   * These have the same API as a redis client, except the calls are chained, and the sequence is terminated with a `.exec` call.
   */
  private API::Node multi() {
    result = client().getMember(["multi", "batch"]).getReturn()
    or
    result = multi().getAMember().getReturn()
  }

  /**
   * Gets a `Node Redis` client instance. Either a client created using `createClient()`, or a batch operation object.
   */
  private API::Node redis() { result = [client(), multi()] }

  /**
   * Provides signatures for the query methods from Node Redis.
   */
  module QuerySignatures {
    /**
     * Holds if `method` interprets parameter `argIndex` as a key, and a later parameter determines a value/field.
     * Thereby the method is vulnerable if parameter `argIndex` is unexpectedly an array instead of a string, as an attacker can control arguments to Redis that the attacker was not supposed to control.
     *
     * Only setters and similar methods are included.
     * For getter-like methods it is not generally possible to gain access "outside" of where you are supposed to have access,
     * it is at most possible to get a Redis call to return more results than expected (e.g. by adding more members to [`geohash`](https://redis.io/commands/geohash)).
     */
    predicate argumentIsAmbiguousKey(string method, int argIndex) {
      method =
        [
          "set", "publish", "append", "bitfield", "decrby", "getset", "hincrby", "hincrbyfloat",
          "hset", "hsetnx", "incrby", "incrbyfloat", "linsert", "lpush", "lpushx", "lset", "ltrim",
          "rename", "renamenx", "rpushx", "setbit", "setex", "smove", "zincrby", "zinterstore",
          "hdel", "lpush", "pfadd", "rpush", "sadd", "sdiffstore", "srem"
        ] and
      argIndex = 0
      or
      method = ["bitop", "hmset", "mset", "msetnx", "geoadd"] and
      argIndex in [0 .. any(DataFlow::InvokeNode invk).getNumArgument() - 1]
    }
  }

  /**
   * An expression that is interpreted as a key in a Node Redis call.
   */
  class RedisKeyArgument extends NoSql::Query {
    RedisKeyArgument() {
      exists(string method, int argIndex |
        QuerySignatures::argumentIsAmbiguousKey(method, argIndex) and
        this = redis().getMember(method).getParameter(argIndex).getARhs().asExpr()
      )
    }
  }

  /**
   * An access to a database through redis
   */
  class RedisDatabaseAccess extends DatabaseAccess, DataFlow::CallNode {
    RedisDatabaseAccess() { this = redis().getMember(_).getACall() }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { none() }
  }
}

/**
 * Provides classes modeling the `ioredis` library.
 *
 * ```
 * import Redis from 'ioredis'
 * let client = new Redis(...)
 * ```
 */
private module IoRedis {
  /**
   * Gets an `ioredis` client.
   */
  API::Node ioredis() { result = API::moduleImport("ioredis").getInstance() }

  /**
   * An access to a database through ioredis
   */
  class IoRedisDatabaseAccess extends DatabaseAccess, DataFlow::CallNode {
    IoRedisDatabaseAccess() { this = ioredis().getMember(_).getACall() }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { none() }
  }
}
