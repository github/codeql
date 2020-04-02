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
  /** Gets the package name `mysql` or `mysql2`. */
  string mysql() { result = "mysql" or result = "mysql2" }

  /** Gets a call to `mysql.createConnection`. */
  DataFlow::SourceNode createConnection() {
    result = DataFlow::moduleMember(mysql(), "createConnection").getACall()
  }

  /** Gets a call to `mysql.createPool`. */
  DataFlow::SourceNode createPool() {
    result = DataFlow::moduleMember(mysql(), "createPool").getACall()
  }

  /** Gets a data flow node that contains a freshly created MySQL connection instance. */
  DataFlow::SourceNode connection() {
    result = createConnection()
    or
    result = createPool().getAMethodCall("getConnection").getCallback(0).getParameter(1)
  }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() {
      exists(DataFlow::SourceNode recv | recv = createPool() or recv = connection() |
        this = recv.getAMethodCall("query")
      )
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(0))
    }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /** A call to the `escape` or `escapeId` method that performs SQL sanitization. */
  class EscapingSanitizer extends SQL::SqlSanitizer, @callexpr {
    EscapingSanitizer() {
      exists(string esc | esc = "escape" or esc = "escapeId" |
        exists(DataFlow::SourceNode escape, MethodCallExpr mce |
          escape = DataFlow::moduleMember(mysql(), esc) or
          escape = connection().getAPropertyRead(esc) or
          escape = createPool().getAPropertyRead(esc)
        |
          this = mce and
          mce = escape.getACall().asExpr() and
          input = mce.getArgument(0) and
          output = mce
        )
      )
    }
  }

  /** An expression that is passed as user name or password to `mysql.createConnection`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(DataFlow::SourceNode call, string prop |
        (call = createConnection() or call = createPool()) and
        call.asExpr().(CallExpr).hasOptionArgument(0, prop, this) and
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
  /** Gets an expression of the form `new require('pg').Client()`. */
  DataFlow::SourceNode newClient() {
    result = DataFlow::moduleImport("pg").getAConstructorInvocation("Client")
  }

  /** Gets a data flow node that holds a freshly created Postgres client instance. */
  DataFlow::SourceNode client() {
    result = newClient()
    or
    // pool.connect(function(err, client) { ... })
    result = newPool().getAMethodCall("connect").getCallback(0).getParameter(1)
  }

  /** Gets an expression that constructs a new connection pool. */
  DataFlow::SourceNode newPool() {
    // new require('pg').Pool()
    result = DataFlow::moduleImport("pg").getAConstructorInvocation("Pool")
    or
    // new require('pg-pool')
    result = DataFlow::moduleImport("pg-pool").getAnInstantiation()
  }

  private DataFlow::SourceNode clientOrPool(DataFlow::TypeTracker t) {
    t.start() and
    (result = client() or result = newPool())
    or
    exists(DataFlow::TypeTracker t2 | result = clientOrPool(t2).track(t2, t))
  }

  private DataFlow::SourceNode clientOrPool() {
    result = clientOrPool(DataFlow::TypeTracker::end())
  }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() { this = clientOrPool().getAMethodCall("query") }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(0))
    }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /** An expression that is passed as user name or password when creating a client or a pool. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(DataFlow::InvokeNode call, string prop |
        (call = newClient() or call = newPool()) and
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

  /** A call to a Sqlite query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() {
      exists(string meth |
        meth = "all" or
        meth = "each" or
        meth = "exec" or
        meth = "get" or
        meth = "prepare" or
        meth = "run"
      |
        this = newDb().getAMethodCall(meth)
      )
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(0))
    }
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
  DataFlow::ModuleImportNode mssql() { result.getPath() = "mssql" }

  /** Gets an expression that creates a request object. */
  DataFlow::SourceNode request() {
    // new require('mssql').Request()
    result = mssql().getAConstructorInvocation("Request")
    or
    // request.input(...)
    result = request().getAMethodCall("input")
  }

  /** A tagged template evaluated as a query. */
  private class QueryTemplateExpr extends DatabaseAccess, DataFlow::ValueNode {
    override TaggedTemplateExpr astNode;

    QueryTemplateExpr() { mssql().getAPropertyRead("query").flowsToExpr(astNode.getTag()) }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getTemplate().getAnElement())
    }
  }

  /** A call to a MsSql query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() {
      exists(string meth | this = request().getAMethodCall(meth) | meth = "query" or meth = "batch")
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getArgument(0))
    }
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
  /** Gets an import of the `sequelize` module. */
  DataFlow::ModuleImportNode sequelize() { result.getPath() = "sequelize" }

  /** Gets an expression that creates an instance of the `Sequelize` class. */
  DataFlow::SourceNode newSequelize() { result = sequelize().getAnInstantiation() }

  /** A call to `Sequelize.query`. */
  private class QueryCall extends DatabaseAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    QueryCall() { this = newSequelize().getAMethodCall("query") }

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
        ne = newSequelize().asExpr() and
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

  /**
   * Gets a node that refers to an instance of the `Database` class.
   */
  DataFlow::SourceNode database() {
    result = spanner().getAnInvocation().getAMethodCall("instance").getAMethodCall("database")
  }

  /**
   * Gets a node that refers to an instance of the `v1.SpannerClient` class.
   */
  DataFlow::SourceNode v1SpannerClient() {
    result = spanner().getAPropertyRead("v1").getAPropertyRead("SpannerClient").getAnInstantiation()
  }

  /**
   * Gets a node that refers to a transaction object.
   */
  DataFlow::SourceNode transaction() {
    result = database().getAMethodCall("runTransaction").getCallback(0).getParameter(1)
  }

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
      exists(string run | run = "run" or run = "runPartitionedUpdate" or run = "runStream" |
        this = database().getAMethodCall(run)
      )
    }
  }

  /**
   * A call to `Transaction.run`, `Transaction.runStream` or `Transaction.runUpdate`.
   */
  class TransactionRunCall extends SqlExecution {
    TransactionRunCall() {
      exists(string run | run = "run" or run = "runStream" or run = "runUpdate" |
        this = transaction().getAMethodCall(run)
      )
    }
  }

  /**
   * A call to `v1.SpannerClient.executeSql` or `v1.SpannerClient.executeStreamingSql`.
   */
  class ExecuteSqlCall extends SqlExecution {
    ExecuteSqlCall() {
      exists(string exec | exec = "executeSql" or exec = "executeStreamingSql" |
        this = v1SpannerClient().getAMethodCall(exec)
      )
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
