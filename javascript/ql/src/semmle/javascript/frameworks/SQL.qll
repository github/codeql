/**
 * Provides classes for working with SQL connectors.
 */

import javascript
private import ApiGraphs

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
  API::Feature mysql() { result = API::moduleImport(["mysql", "mysql2"]) }

  /** Gets a call to `mysql.createConnection`. */
  API::Feature createConnection() { result = mysql().getMember("createConnection").getReturn() }

  /** Gets a call to `mysql.createPool`. */
  API::Feature createPool() { result = mysql().getMember("createPool").getReturn() }

  /** Gets a data flow node that contains a freshly created MySQL connection instance. */
  API::Feature connection() {
    result = createConnection()
    or
    result = createPool().getMember("getConnection").getParameter(0).getParameter(1)
  }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      exists(API::Feature recv | recv = createPool() or recv = connection() |
        this = recv.getMember("query").getReturn().getAUse()
      )
    }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }

  /** A call to the `escape` or `escapeId` method that performs SQL sanitization. */
  class EscapingSanitizer extends SQL::SqlSanitizer, MethodCallExpr {
    EscapingSanitizer() {
      this =
        [mysql(), createPool(), connection()]
            .getMember(["escape", "escapeId"])
            .getReturn()
            .getAUse()
            .asExpr() and
      input = this.getArgument(0) and
      output = this
    }
  }

  /** An expression that is passed as user name or password to `mysql.createConnection`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(API::Feature call, string prop |
        (call = createConnection() or call = createPool()) and
        call.getAUse().asExpr().(CallExpr).hasOptionArgument(0, prop, this) and
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
  API::Feature newClient() { result = API::moduleImport("pg").getMember("Client").getInstance() }

  /** Gets a data flow node that holds a freshly created Postgres client instance. */
  API::Feature client() {
    result = newClient()
    or
    // pool.connect(function(err, client) { ... })
    result = newPool().getMember("connect").getParameter(0).getParameter(1)
  }

  /** Gets an expression that constructs a new connection pool. */
  API::Feature newPool() {
    // new require('pg').Pool()
    result = API::moduleImport("pg").getMember("Pool").getInstance()
    or
    // new require('pg-pool')
    result = API::moduleImport("pg-pool").getInstance()
  }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [client(), newPool()].getMember("query").getReturn().getAUse() }

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
      exists(DataFlow::InvokeNode call, string prop |
        call = [client(), newPool()].getAUse() and
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
  API::Feature sqlite() {
    result = API::moduleImport("sqlite3")
    or
    result = sqlite().getMember("verbose").getReturn()
  }

  /** Gets an expression that constructs a Sqlite database instance. */
  API::Feature newDb() {
    // new require('sqlite3').Database()
    result = sqlite().getMember("Database").getInstance()
  }

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
        this = newDb().getMember(meth).getReturn().getAUse()
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
  API::Feature mssql() { result = API::moduleImport("mssql") }

  /** Gets an expression that creates a request object. */
  API::Feature request() {
    // new require('mssql').Request()
    result = mssql().getMember("Request").getInstance()
    or
    // request.input(...)
    result = request().getMember("input").getReturn()
  }

  /** A tagged template evaluated as a query. */
  private class QueryTemplateExpr extends DatabaseAccess, DataFlow::ValueNode {
    override TaggedTemplateExpr astNode;

    QueryTemplateExpr() {
      mssql().getMember("query").getAUse().(DataFlow::SourceNode).flowsToExpr(astNode.getTag())
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getTemplate().getAnElement())
    }
  }

  /** A call to a MsSql query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = request().getMember(["query", "batch"]).getReturn().getAUse() }

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
          call = mssql().getMember("connect").getReturn().getAUse()
          or
          call = mssql().getMember("ConnectionPool").getInstance().getAUse()
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
  API::Feature sequelize() { result = API::moduleImport("sequelize") }

  /** Gets an expression that creates an instance of the `Sequelize` class. */
  API::Feature newSequelize() { result = sequelize().getInstance() }

  /** A call to `Sequelize.query`. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = newSequelize().getMember("query").getReturn().getAUse() }

    override DataFlow::Node getAQueryArgument() { result = getArgument(0) }
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
        ne = newSequelize().getAUse().asExpr() and
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
  API::Feature spanner() {
    // older versions
    result = API::moduleImport("@google-cloud/spanner")
    or
    // newer versions
    result = API::moduleImport("@google-cloud/spanner").getMember("Spanner")
  }

  /**
   * Gets a node that refers to an instance of the `Database` class.
   */
  API::Feature database() {
    result =
      spanner().getReturn().getMember("instance").getReturn().getMember("database").getReturn()
  }

  /**
   * Gets a node that refers to an instance of the `v1.SpannerClient` class.
   */
  API::Feature v1SpannerClient() {
    result = spanner().getMember("v1").getMember("SpannerClient").getInstance()
  }

  /**
   * Gets a node that refers to a transaction object.
   */
  API::Feature transaction() {
    result = database().getMember("runTransaction").getParameter(0).getParameter(1)
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
      this =
        database().getMember(["run", "runPartitionedUpdate", "runStream"]).getReturn().getAUse()
    }
  }

  /**
   * A call to `Transaction.run`, `Transaction.runStream` or `Transaction.runUpdate`.
   */
  class TransactionRunCall extends SqlExecution {
    TransactionRunCall() {
      this = transaction().getMember(["run", "runStream", "runUpdate"]).getReturn().getAUse()
    }
  }

  /**
   * A call to `v1.SpannerClient.executeSql` or `v1.SpannerClient.executeStreamingSql`.
   */
  class ExecuteSqlCall extends SqlExecution {
    ExecuteSqlCall() {
      this =
        v1SpannerClient().getMember(["executeSql", "executeStreamingSql"]).getReturn().getAUse()
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
