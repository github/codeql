/**
 * Provides classes for working with NoSQL libraries.
 */

import javascript

/** Provides classes for modeling NoSql query sinks. */
module NoSql {
  /** An expression that is interpreted as a NoSQL query. */
  abstract class Query extends DataFlow::Node {
    /** Gets an expression that is interpreted as a code operator in this query. */
    DataFlow::Node getACodeOperator() { none() }
  }

  private class QueryFromModel extends Query {
    QueryFromModel() { this = ModelOutput::getASinkNode("nosql-injection").asSink() }
  }
}

/**
 * Provides classes modeling the `mongodb` and `mongoose` libraries.
 */
private module MongoDB {
  /**
   * An expression that is interpreted as a MongoDB query.
   */
  class Query extends NoSql::Query {
    private API::Node apiNode;

    Query() { apiNode = ModelOutput::getASinkNode("mongodb.sink") and this = apiNode.asSink() }

    override DataFlow::Node getACodeOperator() { result = apiNode.getMember("$where").asSink() }
  }

  /** A call to a MongoDB query method. */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    QueryCall() {
      this = ModelOutput::getATypeNode("mongodb.Collection").getAMember().getACall() and
      not this.getCalleeName() = ["toString", "valueOf", "getLogger"]
      or
      this =
        ModelOutput::getATypeNode(["mongodb.Db", "mongodb.MongoClient"])
            .getMember(["watch", "aggregate"])
            .getACall()
    }

    override DataFlow::Node getAQueryArgument() {
      result = [this.getAnArgument(), this.getOptionArgument(_, _)] and
      result = ModelOutput::getASinkNode("mongodb.sink").asSink()
    }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }
  }

  private class Insertion extends DatabaseAccess, API::CallNode {
    Insertion() {
      this = ModelOutput::getATypeNode("mongodb.Collection").getAMember().getACall() and
      this.getCalleeName().matches("insert%")
    }

    override DataFlow::Node getAQueryArgument() { none() }
  }

  private API::Node credentialsObject() {
    result = API::Node::ofType("mongodb", "Auth")
    or
    result = API::Node::ofType("mongoose", "ConnectOptions")
  }

  /**
   * An expression passed to `mongodb` or `mongoose` to supply credentials.
   */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop | this = credentialsObject().getMember(prop).asSink() |
        prop = "user" and kind = "user name"
        or
        prop = "pass" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}

private module Mongoose {
  /**
   * A call that submits a mongoose query object to the database.
   *
   * Much of the mongoose API is for constructing intermdiate query objects, which are ultimately submitted by a call
   * to `exec` or `then`. The inputs to such query constructors are treated as `mongodb.sink`s in the MaD model.
   * Here we just mark the final call as a `DatabaseAccess`.
   */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    QueryCall() {
      this =
        ModelOutput::getATypeNode("mongoose.Query").getMember(["exec", "then", "catch"]).getACall()
    }

    override DataFlow::Node getAQueryArgument() { result = this.getReceiver() }

    override DataFlow::Node getAResult() {
      this.getCalleeName() = ["then", "exec"] and
      result = this.getReturn().getPromised().asSource()
      or
      this.getCalleeName() = "then" and
      result = this.getParameter(0).getParameter(0).asSource()
      or
      this.getCalleeName() = "exec" and
      result = this.getLastParameter().getParameter(1).asSource()
    }
  }

  /**
   * A method call on `Document`, `Model` or `Query` returning a `Query` and taking a callback argument.
   *
   * This will execute the query immediately.
   */
  private class QueryWithCallback extends DatabaseAccess, API::CallNode {
    QueryWithCallback() {
      this =
        ModelOutput::getATypeNode(["mongoose.Document", "mongoose.Model", "mongoose.Query"])
            .getAMember()
            .getACall() and
      this.getReturn() = ModelOutput::getATypeNode("mongoose.Query") and
      exists(this.getLastArgument().getABoundFunctionValue(_))
    }

    override DataFlow::Node getAQueryArgument() { result = this } // the call returns the query whose execution has started

    override DataFlow::Node getAResult() {
      result = this.getLastParameter().getParameter(1).asSource()
    }
  }

  /** An `await`'ed mongoose query, similar to calling `then()`. */
  private class QueryAwait extends DatabaseAccess, DataFlow::ValueNode {
    override AwaitExpr astNode;

    QueryAwait() {
      astNode.getOperand().flow() =
        ModelOutput::getATypeNode("mongoose.Query").getAValueReachableFromSource()
    }

    override DataFlow::Node getAQueryArgument() { result = astNode.getOperand().flow() }

    override DataFlow::Node getAResult() { result = this }
  }

  class Insertion extends DatabaseAccess, API::CallNode {
    Insertion() {
      this = ModelOutput::getATypeNode("mongoose.Model").getAMember().getACall() and
      this.getCalleeName().matches("insert%")
    }

    override DataFlow::Node getAQueryArgument() { none() }
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
          "hdel", "pfadd", "rpush", "sadd", "sdiffstore", "srem"
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
        this = redis().getMember(method).getParameter(argIndex).asSink()
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
