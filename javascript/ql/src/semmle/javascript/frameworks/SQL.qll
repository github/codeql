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
  API::Node mysql() { result = API::moduleImport(["mysql", "mysql2"]) }

  /** Gets a reference to `mysql.createConnection`. */
  API::Node createConnection() { result = mysql().getMember("createConnection") }

  /** Gets a reference to `mysql.createPool`. */
  API::Node createPool() { result = mysql().getMember("createPool") }

  /** Gets a node that contains a MySQL pool created using `mysql.createPool()`. */
  API::Node pool() { result = createPool().getReturn() }

  /** Gets a data flow node that contains a freshly created MySQL connection instance. */
  API::Node connection() {
    result = createConnection().getReturn()
    or
    result = pool().getMember("getConnection").getParameter(0).getParameter(1)
  }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      exists(API::Node recv | recv = pool() or recv = connection() |
        this = recv.getMember("query").getACall()
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
      this = [mysql(), pool(), connection()].getMember(["escape", "escapeId"]).getACall().asExpr() and
      input = this.getArgument(0) and
      output = this
    }
  }

  /** An expression that is passed as user name or password to `mysql.createConnection`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(API::Node callee, string prop |
        callee in [createConnection(), createPool()] and
        this = callee.getParameter(0).getMember(prop).getARhs().asExpr() and
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
 * Provides classes modelling the PostgreSQL packages, such as `pg` and `pg-promise`.
 */
private module Postgres {
  API::Node pg() {
    result = API::moduleImport("pg")
    or
    result = pgpMain().getMember("pg")
  }

  /** Gets a reference to the `Client` constructor in the `pg` package, for example `require('pg').Client`. */
  API::Node newClient() { result = pg().getMember("Client") }

  /** Gets a freshly created Postgres client instance. */
  API::Node client() {
    result = newClient().getInstance()
    or
    // pool.connect(function(err, client) { ... })
    result = pool().getMember("connect").getParameter(0).getParameter(1)
    or
    result = pgpConnection().getMember("client")
  }

  /** Gets a constructor that when invoked constructs a new connection pool. */
  API::Node newPool() {
    // new require('pg').Pool()
    result = pg().getMember("Pool")
    or
    // new require('pg-pool')
    result = API::moduleImport("pg-pool")
  }

  /** Gets an API node that refers to a connection pool. */
  API::Node pool() {
    result = newPool().getInstance()
    or
    result = pgpDatabase().getMember("$pool")
  }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [client(), pool()].getMember("query").getACall() }

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
      exists(string prop |
        this = [newClient(), newPool()].getParameter(0).getMember(prop).getARhs().asExpr()
        or
        this = pgPromise().getParameter(0).getMember(prop).getARhs().asExpr()
      |
        prop = "user" and kind = "user name"
        or
        prop = "password" and kind = prop
      )
    }

    override string getCredentialsKind() { result = kind }
  }

  /** Gets a node referring to the `pg-promise` library (which is not itself a Promise). */
  API::Node pgPromise() { result = API::moduleImport("pg-promise") }

  /** Gets an initialized `pg-promise` library. */
  API::Node pgpMain() {
    result = pgPromise().getReturn()
    or
    result = API::Node::ofType("pg-promise", "IMain")
  }

  /** Gets a database from `pg-promise`. */
  API::Node pgpDatabase() {
    result = pgpMain().getReturn()
    or
    result = API::Node::ofType("pg-promise", "IDatabase")
  }

  /** Gets a connection created from a `pg-promise` database. */
  API::Node pgpConnection() {
    result = pgpDatabase().getMember("connect").getReturn().getPromised()
    or
    result = API::Node::ofType("pg-promise", "IConnected")
  }

  /** Gets a `pg-promise` task object. */
  API::Node pgpTask() {
    exists(API::Node taskMethod |
      taskMethod = pgpObject().getMember(["task", "taskIf", "tx", "txIf"])
    |
      result = taskMethod.getParameter([0, 1]).getParameter(0)
      or
      result = taskMethod.getParameter(0).getMember("cnd").getParameter(0)
    )
    or
    result = API::Node::ofType("pg-promise", "ITask")
  }

  /** Gets a `pg-promise` object which supports querying (database, connection, or task). */
  API::Node pgpObject() {
    result = [pgpDatabase(), pgpConnection(), pgpTask()]
    or
    result = API::Node::ofType("pg-promise", "IBaseProtocol")
  }

  private string pgpQueryMethodName() {
    result =
      [
        "any", "each", "many", "manyOrNone", "map", "multi", "multiResult", "none", "one",
        "oneOrNone", "query", "result"
      ]
  }

  /** A call that executes a SQL query via `pg-promise`. */
  private class PgPromiseQueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    PgPromiseQueryCall() { this = pgpObject().getMember(pgpQueryMethodName()).getACall() }

    /** Gets an argument interpreted as a SQL string, not including raw interpolation variables. */
    private DataFlow::Node getADirectQueryArgument() {
      result = getArgument(0)
      or
      result = getOptionArgument(0, "text")
    }

    /**
     * Gets an interpolation parameter whose value is interpreted literally, or is not escaped appropriately for its context.
     *
     * For example, the following are raw placeholders: $1:raw, $1^, ${prop}:raw, $(prop)^
     */
    private string getARawParameterName() {
      exists(string sqlString, string placeholderRegexp, string regexp |
        placeholderRegexp = "\\$(\\d+|[{(\\[/]\\w+[})\\]/])" and // For example: $1 or ${prop}
        sqlString = getADirectQueryArgument().getStringValue()
      |
        // Match $1:raw or ${prop}:raw
        regexp = placeholderRegexp + "(:raw|\\^)" and
        result =
          sqlString
              .regexpFind(regexp, _, _)
              .regexpCapture(regexp, 1)
              .regexpReplaceAll("[^\\w\\d]", "")
        or
        // Match $1:value or ${prop}:value unless enclosed by single quotes (:value prevents breaking out of single quotes)
        regexp = placeholderRegexp + "(:value|\\#)" and
        result =
          sqlString
              .regexpReplaceAll("'[^']*'", "''")
              .regexpFind(regexp, _, _)
              .regexpCapture(regexp, 1)
              .regexpReplaceAll("[^\\w\\d]", "")
      )
    }

    /** Gets the argument holding the values to plug into placeholders. */
    private DataFlow::Node getValues() {
      result = getArgument(1)
      or
      result = getOptionArgument(0, "values")
    }

    /** Gets a value that is plugged into a raw placeholder variable, making it a sink for SQL injection. */
    private DataFlow::Node getARawValue() {
      result = getValues() and getARawParameterName() = "1" // Special case: if the argument is not an array or object, it's just plugged into $1
      or
      exists(DataFlow::SourceNode values | values = getValues().getALocalSource() |
        result = values.getAPropertyWrite(getARawParameterName()).getRhs()
        or
        // Array literals do not have PropWrites with property names so handle them separately,
        // and also translate to 0-based indexing.
        result = values.(DataFlow::ArrayCreationNode).getElement(getARawParameterName().toInt() - 1)
      )
    }

    override DataFlow::Node getAQueryArgument() {
      result = getADirectQueryArgument()
      or
      result = getARawValue()
    }
  }

  /** An expression that is interpreted as SQL by `pg-promise`. */
  class PgPromiseQueryString extends SQL::SqlString {
    PgPromiseQueryString() { this = any(PgPromiseQueryCall qc).getAQueryArgument().asExpr() }
  }
}

/**
 * Provides classes modelling the `sqlite3` package.
 */
private module Sqlite {
  /** Gets a reference to the `sqlite3` module. */
  API::Node sqlite() {
    result = API::moduleImport("sqlite3")
    or
    result = sqlite().getMember("verbose").getReturn()
  }

  /** Gets an expression that constructs a Sqlite database instance. */
  API::Node newDb() {
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
        this = newDb().getMember(meth).getACall()
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
  API::Node mssql() { result = API::moduleImport("mssql") }

  /** Gets an expression that creates a request object. */
  API::Node request() {
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
      mssql().getMember("query").getAUse() = DataFlow::valueNode(astNode.getTag())
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getTemplate().getAnElement())
    }
  }

  /** A call to a MsSql query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = request().getMember(["query", "batch"]).getACall() }

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
      exists(API::Node callee, string prop |
        (
          callee = mssql().getMember("connect")
          or
          callee = mssql().getMember("ConnectionPool")
        ) and
        this = callee.getParameter(0).getMember(prop).getARhs().asExpr() and
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
  API::Node sequelize() { result = API::moduleImport("sequelize") }

  /** Gets an expression that creates an instance of the `Sequelize` class. */
  API::Node newSequelize() { result = sequelize().getInstance() }

  /** A call to `Sequelize.query`. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = newSequelize().getMember("query").getACall() }

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
        ne = sequelize().getAnInstantiation().asExpr() and
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
  API::Node spanner() {
    // older versions
    result = API::moduleImport("@google-cloud/spanner")
    or
    // newer versions
    result = API::moduleImport("@google-cloud/spanner").getMember("Spanner")
  }

  /**
   * Gets a node that refers to an instance of the `Database` class.
   */
  API::Node database() {
    result =
      spanner().getReturn().getMember("instance").getReturn().getMember("database").getReturn()
  }

  /**
   * Gets a node that refers to an instance of the `v1.SpannerClient` class.
   */
  API::Node v1SpannerClient() {
    result = spanner().getMember("v1").getMember("SpannerClient").getInstance()
  }

  /**
   * Gets a node that refers to a transaction object.
   */
  API::Node transaction() {
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
      this = database().getMember(["run", "runPartitionedUpdate", "runStream"]).getACall()
    }
  }

  /**
   * A call to `Transaction.run`, `Transaction.runStream` or `Transaction.runUpdate`.
   */
  class TransactionRunCall extends SqlExecution {
    TransactionRunCall() {
      this = transaction().getMember(["run", "runStream", "runUpdate"]).getACall()
    }
  }

  /**
   * A call to `v1.SpannerClient.executeSql` or `v1.SpannerClient.executeStreamingSql`.
   */
  class ExecuteSqlCall extends SqlExecution {
    ExecuteSqlCall() {
      this = v1SpannerClient().getMember(["executeSql", "executeStreamingSql"]).getACall()
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
