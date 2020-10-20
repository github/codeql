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
private module MySql {
  private DataFlow::SourceNode mysql() { result = DataFlow::moduleImport(["mysql", "mysql2"]) }

  private DataFlow::CallNode createPool() { result = mysql().getAMemberCall("createPool") }

  /** Gets a reference to a MySQL pool. */
  private DataFlow::SourceNode pool(DataFlow::TypeTracker t) {
    t.start() and
    result = createPool()
  }

  /** Gets a reference to a MySQL pool. */
  private DataFlow::SourceNode pool() { result = pool(DataFlow::TypeTracker::end()) }

  /** Gets a call to `mysql.createConnection`. */
  DataFlow::CallNode createConnection() { result = mysql().getAMemberCall("createConnection") }

  /** Gets a reference to a MySQL connection instance. */
  private DataFlow::SourceNode connection(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = createConnection()
      or
      result = pool().getAMethodCall("getConnection").getABoundCallbackParameter(0, 1)
    )
  }

  /** Gets a reference to a MySQL connection instance. */
  DataFlow::SourceNode connection() { result = connection(DataFlow::TypeTracker::end()) }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [pool(), connection()].getAMethodCall("query") }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

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

  /** Gets a creation of a Postgres client. */
  DataFlow::InvokeNode newClient() {
    result = DataFlow::moduleImport("pg").getAConstructorInvocation("Client")
  }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [newClient(), newPool()].getAMethodCall("query") }

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
