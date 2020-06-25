/**
 * Provides classes for working with SQL connectors.
 */

import javascript

module SQL {
  /** A string-valued expression that is interpreted as a SQL command. */
  abstract class SqlString extends Expr { }

  /**
   * An expression that sanitizes a string to make it safe to embed into
   * a SQL command.
   */
  abstract class SqlSanitizer extends Expr {
    Expr input;
    Expr output;

    /** Gets the input expression being sanitized. */
    Expr getInput() { result = input }

    /** Gets the output expression containing the sanitized value. */
    Expr getOutput() { result = output }
  }
}

/**
 * Provides classes modelling the (API compatible) `mysql` and `mysql2` packages.
 */
module MySql {
  private DataFlow::SourceNode mysql() { result = DataFlow::moduleImport(["mysql", "mysql2"]) }

  private DataFlow::CallNode createPool() { result = mysql().getAMemberCall("createPool") }

  /** Gets a reference to a MySQL pool. */
  private DataFlow::SourceNode pool(DataFlow::TypeTracker t) {
    t.start() and
    result = createPool()
    or
    exists(DataFlow::TypeTracker t2 | result = pool(t2).track(t2, t))
  }

  /** Gets a reference to a MySQL pool. */
  DataFlow::SourceNode pool() { result = pool(DataFlow::TypeTracker::end()) }

  /** Gets a call to `mysql.createConnection`. */
  DataFlow::CallNode createConnection() { result = mysql().getAMemberCall("createConnection") }

  /** Gets a reference to a MySQL connection instance. */
  private DataFlow::SourceNode connection(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = createConnection()
      or
      result = pool().getAMethodCall("getConnection").getABoundCallbackParameter(0, 1)
      or
      // byteball/ocore model
      result.(DataFlow::MethodCallNode).getMethodName() = ["takeConnectionFromPool"]
    )
    or
    exists(DataFlow::TypeTracker t2 | result = connection(t2).track(t2, t))
  }

  /** Gets a reference to a MySQL connection instance. */
  DataFlow::SourceNode connection() { result = connection(DataFlow::TypeTracker::end()) }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [pool(), connection()].getAMethodCall("query") }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

  // class ParameterizedQueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
  //   // byteball/ocore model
  //   DataFlow::Node query;

  //   ParameterizedQueryCall() {
  //     this.getMethodName() = ["addQuery", "query"] and
  //     query = this.getAnArgument() and
  //     exists(string s, DataFlow::Node part |
  //       part.mayHaveStringValue(s) and s.regexpMatch(".*[(=, ]\\?.*")
  //     |
  //       // part = query
  //       // or
  //       query.asExpr().(AddExpr).getAnOperand+() = part.asExpr()
  //     )
  //   }

  //   override DataFlow::Node getAQueryArgument() { result = query }
  // }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /** A call to the `escape` or `escapeId` method that performs SQL sanitization. */
  class EscapingSanitizer extends SQL::SqlSanitizer, MethodCallExpr {
    EscapingSanitizer() {
      this = [mysql(), pool(), connection()].getAMethodCall(["escape", "escapeId"]).asExpr() and
      input = this.getArgument(0) and
      output = this
    }
  }

  /** An expression that is passed as user name or password to `mysql.createConnection`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop |
        this = [createConnection(), createPool()].getOptionArgument(0, prop).asExpr() and
        (
          prop = "user" and kind = "user name"
          or
          prop = "password" and kind = prop
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}

/**
 * Provides classes modelling the `pg` package.
 */
private module Postgres {
  /** Gets an expression that constructs a new connection pool. */
  DataFlow::InvokeNode newPool() {
    // new require('pg').Pool()
    result = DataFlow::moduleImport("pg").getAConstructorInvocation("Pool")
    or
    // new require('pg-pool')
    result = DataFlow::moduleImport("pg-pool").getAnInstantiation()
  }

  /** Gets a data flow node referring to a connection pool. */
  private DataFlow::SourceNode pool(DataFlow::TypeTracker t) {
    t.start() and
    result = newPool()
    or
    exists(DataFlow::TypeTracker t2 | result = pool(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a connection pool. */
  DataFlow::SourceNode pool() { result = pool(DataFlow::TypeTracker::end()) }

  /** Gets a creation of a Postgres client. */
  DataFlow::InvokeNode newClient() {
    result = DataFlow::moduleImport("pg").getAConstructorInvocation("Client")
  }

  /** Gets a data flow node referring to a Postgres client. */
  private DataFlow::SourceNode client(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = newClient()
      or
      result = pool().getAMethodCall("connect").getABoundCallbackParameter(0, 1)
    )
    or
    exists(DataFlow::TypeTracker t2 | result = client(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a Postgres client. */
  DataFlow::SourceNode client() { result = client(DataFlow::TypeTracker::end()) }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [client(), pool()].getAMethodCall("query") }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /** An expression that is passed as user name or password when creating a client or a pool. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop | this = [newClient(), newPool()].getOptionArgument(0, prop).asExpr() |
        prop = "user" and kind = "user name"
        or
        prop = "password" and kind = prop
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}

/**
 * Provides classes modelling the `sqlite3` package.
 */
private module Sqlite {
  /** Gets a reference to the `sqlite3` module. */
  DataFlow::SourceNode sqlite() {
    result = DataFlow::moduleImport("sqlite3")
    or
    result = sqlite().getAMemberCall("verbose")
  }

  /** Gets an expression that constructs a Sqlite database instance. */
  DataFlow::SourceNode newDb() {
    // new require('sqlite3').Database()
    result = sqlite().getAConstructorInvocation("Database")
  }

  /** Gets a data flow node referring to a Sqlite database instance. */
  private DataFlow::SourceNode db(DataFlow::TypeTracker t) {
    t.start() and
    result = newDb()
    or
    exists(DataFlow::TypeTracker t2 | result = db(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a Sqlite database instance. */
  DataFlow::SourceNode db() { result = db(DataFlow::TypeTracker::end()) }

  /** A call to a Sqlite query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      exists(string meth |
        meth = "all" or
        meth = "each" or
        meth = "exec" or
        meth = "get" or
        meth = "prepare" or
        meth = "run"
      |
        this = db().getAMethodCall(meth)
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }
}

/**
 * Provides classes modelling the `mssql` package.
 */
private module MsSql {
  /** Gets a reference to the `mssql` module. */
  DataFlow::SourceNode mssql() { result = DataFlow::moduleImport("mssql") }

  /** Gets a data flow node referring to a request object. */
  private DataFlow::SourceNode request(DataFlow::TypeTracker t) {
    t.start() and
    (
      // new require('mssql').Request()
      result = mssql().getAConstructorInvocation("Request")
      or
      // request.input(...)
      result = request().getAMethodCall("input")
    )
    or
    exists(DataFlow::TypeTracker t2 | result = request(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a request object. */
  DataFlow::SourceNode request() { result = request(DataFlow::TypeTracker::end()) }

  /** A tagged template evaluated as a query. */
  private class QueryTemplateExpr extends DatabaseAccess, DataFlow::ValueNode {
    override TaggedTemplateExpr astNode;

    QueryTemplateExpr() { mssql().getAPropertyRead("query").flowsToExpr(astNode.getTag()) }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getTemplate().getAnElement())
    }
  }

  /** A call to a MsSql query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = request().getAMethodCall(["query", "batch"]) }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

  /** An expression that is passed to a method that interprets it as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() {
      exists(DatabaseAccess dba | dba instanceof QueryTemplateExpr or dba instanceof QueryCall |
        this = dba.getAQueryArgument().asExpr()
      )
    }
  }

  /** An element of a query template, which is automatically sanitized. */
  class QueryTemplateSanitizer extends SQL::SqlSanitizer {
    QueryTemplateSanitizer() {
      this = any(QueryTemplateExpr qte).getAQueryArgument().asExpr() and
      input = this and
      output = this
    }
  }

  /** An expression that is passed as user name or password when creating a client or a pool. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(DataFlow::InvokeNode call, string prop |
        (
          call = mssql().getAMemberCall("connect")
          or
          call = mssql().getAConstructorInvocation("ConnectionPool")
        ) and
        this = call.getOptionArgument(0, prop).asExpr() and
        (
          prop = "user" and kind = "user name"
          or
          prop = "password" and kind = prop
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}

/**
 * Provides classes modelling the `sequelize` package.
 */
private module Sequelize {
  /** Gets a node referring to an instance of the `Sequelize` class. */
  private DataFlow::SourceNode sequelize(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::moduleImport("sequelize").getAnInstantiation()
    or
    exists(DataFlow::TypeTracker t2 | result = sequelize(t2).track(t2, t))
  }

  /** Gets a node referring to an instance of the `Sequelize` class. */
  DataFlow::SourceNode sequelize() { result = sequelize(DataFlow::TypeTracker::end()) }

  /** A call to `Sequelize.query`. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() { this = sequelize().getAMethodCall("query") }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(0))
    }
  }

  /** An expression that is passed to `Sequelize.query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /**
   * An expression that is passed as user name or password when creating an instance of the
   * `Sequelize` class.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(NewExpr ne, string prop |
        ne = sequelize().asExpr() and
        (
          this = ne.getArgument(1) and prop = "username"
          or
          this = ne.getArgument(2) and prop = "password"
          or
          ne.hasOptionArgument(ne.getNumArgument() - 1, prop, this)
        ) and
        (
          prop = "username" and kind = "user name"
          or
          prop = "password" and kind = prop
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}

/**
 * Provides classes modelling the Google Cloud Spanner library.
 */
private module Spanner {
  /**
   * Gets a node that refers to the `Spanner` class
   */
  DataFlow::SourceNode spanner() {
    // older versions
    result = DataFlow::moduleImport("@google-cloud/spanner")
    or
    // newer versions
    result = DataFlow::moduleMember("@google-cloud/spanner", "Spanner")
  }

  /** Gets a data flow node referring to the result of `Spanner()` or `new Spanner()`. */
  private DataFlow::SourceNode spannerNew(DataFlow::TypeTracker t) {
    t.start() and
    result = spanner().getAnInvocation()
    or
    exists(DataFlow::TypeTracker t2 | result = spannerNew(t2).track(t2, t))
  }

  /** Gets a data flow node referring to the result of `Spanner()` or `new Spanner()`. */
  DataFlow::SourceNode spannerNew() { result = spannerNew(DataFlow::TypeTracker::end()) }

  /** Gets a data flow node referring to the result of `.instance()`. */
  private DataFlow::SourceNode instance(DataFlow::TypeTracker t) {
    t.start() and
    result = spannerNew().getAMethodCall("instance")
    or
    exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
  }

  /** Gets a data flow node referring to the result of `.instance()`. */
  DataFlow::SourceNode instance() { result = instance(DataFlow::TypeTracker::end()) }

  /** Gets a node that refers to an instance of the `Database` class. */
  private DataFlow::SourceNode database(DataFlow::TypeTracker t) {
    t.start() and
    result = instance().getAMethodCall("database")
    or
    exists(DataFlow::TypeTracker t2 | result = database(t2).track(t2, t))
  }

  /** Gets a node that refers to an instance of the `Database` class. */
  DataFlow::SourceNode database() { result = database(DataFlow::TypeTracker::end()) }

  /** Gets a node that refers to an instance of the `v1.SpannerClient` class. */
  private DataFlow::SourceNode v1SpannerClient(DataFlow::TypeTracker t) {
    t.start() and
    result = spanner().getAPropertyRead("v1").getAPropertyRead("SpannerClient").getAnInstantiation()
    or
    exists(DataFlow::TypeTracker t2 | result = v1SpannerClient(t2).track(t2, t))
  }

  /** Gets a node that refers to an instance of the `v1.SpannerClient` class. */
  DataFlow::SourceNode v1SpannerClient() { result = v1SpannerClient(DataFlow::TypeTracker::end()) }

  /** Gets a node that refers to a transaction object. */
  private DataFlow::SourceNode transaction(DataFlow::TypeTracker t) {
    t.start() and
    result = database().getAMethodCall("runTransaction").getABoundCallbackParameter(0, 1)
    or
    exists(DataFlow::TypeTracker t2 | result = transaction(t2).track(t2, t))
  }

  /** Gets a node that refers to a transaction object. */
  DataFlow::SourceNode transaction() { result = transaction(DataFlow::TypeTracker::end()) }

  /**
   * A call to a Spanner method that executes a SQL query.
   */
  abstract class SqlExecution extends DatabaseAccess, DataFlow::InvokeNode {
    /**
     * Gets the position of the query argument; default is zero, which can be overridden
     * by subclasses.
     */
    int getQueryArgumentPosition() { result = 0 }

    override DataFlow::Node getAQueryArgument() {
      result = getArgument(getQueryArgumentPosition()) or
      result = getOptionArgument(getQueryArgumentPosition(), "sql")
    }
  }

  /**
   * A call to `Database.run`, `Database.runPartitionedUpdate` or `Database.runStream`.
   */
  class DatabaseRunCall extends SqlExecution {
    DatabaseRunCall() {
      this = database().getAMethodCall(["run", "runPartitionedUpdate", "runStream"])
    }
  }

  /**
   * A call to `Transaction.run`, `Transaction.runStream` or `Transaction.runUpdate`.
   */
  class TransactionRunCall extends SqlExecution {
    TransactionRunCall() { this = transaction().getAMethodCall(["run", "runStream", "runUpdate"]) }
  }

  /**
   * A call to `v1.SpannerClient.executeSql` or `v1.SpannerClient.executeStreamingSql`.
   */
  class ExecuteSqlCall extends SqlExecution {
    ExecuteSqlCall() {
      this = v1SpannerClient().getAMethodCall(["executeSql", "executeStreamingSql"])
    }

    override DataFlow::Node getAQueryArgument() {
      // `executeSql` and `executeStreamingSql` do not accept query strings directly
      result = getOptionArgument(0, "sql")
    }
  }

  /**
   * An expression that is interpreted as a SQL string.
   */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(SqlExecution se).getAQueryArgument().asExpr() }
  }
}
