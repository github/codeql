/**
 * Provides classes for working with SQL connectors.
 */

import javascript
import semmle.javascript.Promises

module SQL {
  /** A string-valued expression that is interpreted as a SQL command. */
  abstract class SqlString extends Expr { }

  private class SqlStringFromModel extends SqlString {
    SqlStringFromModel() { this = ModelOutput::getASinkNode("sql-injection").getARhs().asExpr() }
  }

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
 * Provides classes modeling the (API compatible) `mysql` and `mysql2` packages.
 */
private module MySql {
  private string moduleName() { result = ["mysql", "mysql2", "mysql2/promise"] }

  /** Gets the package name `mysql` or `mysql2`. */
  API::Node mysql() { result = API::moduleImport(moduleName()) }

  /** Gets a reference to `mysql.createConnection`. */
  API::Node createConnection() {
    result = mysql().getMember(["createConnection", "createConnectionPromise"])
  }

  /** Gets a reference to `mysql.createPool`. */
  API::Node createPool() { result = mysql().getMember(["createPool", "createPoolCluster"]) }

  /** Gets a node that contains a MySQL pool created using `mysql.createPool()`. */
  API::Node pool() {
    result = createPool().getReturn()
    or
    result = pool().getMember("on").getReturn()
    or
    result = API::Node::ofType(moduleName(), ["Pool", "PoolCluster"])
  }

  /** Gets a data flow node that contains a freshly created MySQL connection instance. */
  API::Node connection() {
    result = createConnection().getReturn()
    or
    result = createConnection().getReturn().getPromised()
    or
    result = pool().getMember("getConnection").getParameter(0).getParameter(1)
    or
    result = pool().getMember("getConnection").getPromised()
    or
    exists(API::CallNode call |
      call = pool().getMember("on").getACall() and
      call.getArgument(0).getStringValue() = ["connection", "acquire", "release"] and
      result = call.getParameter(1).getParameter(0)
    )
    or
    result = API::Node::ofType(moduleName(), ["Connection", "PoolConnection"])
  }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      exists(API::Node recv | recv = pool() or recv = connection() |
        this = recv.getMember(["query", "execute"]).getACall()
      )
    }

    override DataFlow::Node getAResult() { result = this.getCallback(_).getParameter(1) }

    override DataFlow::Node getAQueryArgument() {
      result = this.getArgument(0) or result = this.getOptionArgument(0, "sql")
    }
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
 * Provides classes modeling the PostgreSQL packages, such as `pg` and `pg-promise`.
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
    // await pool.connect()
    result = pool().getMember("connect").getReturn().getPromised()
    or
    result = pgpConnection().getMember("client")
    or
    exists(API::CallNode call |
      call = pool().getMember("on").getACall() and
      call.getArgument(0).getStringValue() = ["connect", "acquire"] and
      result = call.getParameter(1).getParameter(0)
    )
    or
    result = client().getMember("on").getReturn()
    or
    result = API::Node::ofType("pg", ["Client", "PoolClient"])
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
    or
    result = pool().getMember("on").getReturn()
    or
    result = API::Node::ofType("pg", "Pool")
  }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [client(), pool()].getMember("query").getACall() }

    override DataFlow::Node getAResult() {
      this.getNumArgument() = 2 and
      result = this.getCallback(1).getParameter(1)
      or
      this.getNumArgument() = 1 and
      result = this.getAMethodCall("then").getCallback(0).getParameter(0)
      or
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() {
      this = any(QueryCall qc).getAQueryArgument().asExpr()
      or
      this = API::moduleImport("pg-cursor").getParameter(0).getARhs().asExpr()
    }
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
      result = this.getArgument(0)
      or
      result = this.getOptionArgument(0, "text")
    }

    /**
     * Gets an interpolation parameter whose value is interpreted literally, or is not escaped appropriately for its context.
     *
     * For example, the following are raw placeholders: $1:raw, $1^, ${prop}:raw, $(prop)^
     */
    private string getARawParameterName() {
      exists(string sqlString, string placeholderRegexp, string regexp |
        placeholderRegexp = "\\$(\\d+|[{(\\[/]\\w+[})\\]/])" and // For example: $1 or ${prop}
        sqlString = this.getADirectQueryArgument().getStringValue()
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
      result = this.getArgument(1)
      or
      result = this.getOptionArgument(0, "values")
    }

    /** Gets a value that is plugged into a raw placeholder variable, making it a sink for SQL injection. */
    private DataFlow::Node getARawValue() {
      result = this.getValues() and this.getARawParameterName() = "1" // Special case: if the argument is not an array or object, it's just plugged into $1
      or
      exists(DataFlow::SourceNode values | values = this.getValues().getALocalSource() |
        result = values.getAPropertyWrite(this.getARawParameterName()).getRhs()
        or
        // Array literals do not have PropWrites with property names so handle them separately,
        // and also translate to 0-based indexing.
        result =
          values.(DataFlow::ArrayCreationNode).getElement(this.getARawParameterName().toInt() - 1)
      )
    }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() {
      result = this.getADirectQueryArgument()
      or
      result = this.getARawValue()
    }
  }

  /** An expression that is interpreted as SQL by `pg-promise`. */
  class PgPromiseQueryString extends SQL::SqlString {
    PgPromiseQueryString() { this = any(PgPromiseQueryCall qc).getAQueryArgument().asExpr() }
  }
}

/**
 * Provides classes modeling the `sqlite3` package.
 */
private module Sqlite {
  /** Gets a reference to the `sqlite3` module. */
  API::Node sqlite() {
    result = API::moduleImport("sqlite3")
    or
    result = sqlite().getMember("verbose").getReturn()
  }

  /** Gets an expression that constructs or returns a Sqlite database instance. */
  API::Node database() {
    // new require('sqlite3').Database()
    result = sqlite().getMember("Database").getInstance()
    or
    // chained call
    result = getAChainingQueryCall()
    or
    result = API::Node::ofType("sqlite3", "Database")
  }

  /** Gets a call to a query method on a Sqlite database instance that returns the same instance. */
  private API::Node getAChainingQueryCall() {
    result = database().getMember(["all", "each", "exec", "get", "run"]).getReturn()
  }

  /** A call to a Sqlite query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      this = getAChainingQueryCall().getAnImmediateUse()
      or
      this = database().getMember("prepare").getACall()
    }

    override DataFlow::Node getAResult() {
      result = this.getCallback(1).getParameter(1) or
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument().asExpr() }
  }
}

/**
 * Provides classes modeling the `mssql` package.
 */
private module MsSql {
  /** Gets a reference to the `mssql` module. */
  API::Node mssql() { result = API::moduleImport("mssql") }

  /** Gets a node referring to an instance of the given class. */
  API::Node mssqlClass(string name) {
    result = mssql().getMember(name).getInstance()
    or
    result = API::Node::ofType("mssql", name)
  }

  /** Gets an API node referring to a Request object. */
  API::Node request() {
    result = mssqlClass("Request")
    or
    result = request().getMember(["input", "replaceInput", "output", "replaceOutput"]).getReturn()
    or
    result = [transaction(), pool()].getMember("request").getReturn()
  }

  /** Gets an API node referring to a Transaction object. */
  API::Node transaction() {
    result = mssqlClass("Transaction")
    or
    result = pool().getMember("transaction").getReturn()
  }

  /** Gets a API node referring to a ConnectionPool object. */
  API::Node pool() { result = mssqlClass("ConnectionPool") }

  /** A tagged template evaluated as a query. */
  private class QueryTemplateExpr extends DatabaseAccess, DataFlow::ValueNode, DataFlow::SourceNode {
    override TaggedTemplateExpr astNode;

    QueryTemplateExpr() {
      mssql().getMember("query").getAUse() = DataFlow::valueNode(astNode.getTag())
    }

    override DataFlow::Node getAResult() {
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() {
      result = DataFlow::valueNode(astNode.getTemplate().getAnElement())
    }
  }

  /** A call to a MsSql query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = [mssql(), request()].getMember(["query", "batch"]).getACall() }

    override DataFlow::Node getAResult() {
      result = this.getCallback(1).getParameter(1)
      or
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
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
 * Provides classes modeling the `sequelize` package.
 */
private module Sequelize {
  class SequelizeModel extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // package1;type1;package2;type2;path
      row =
        [
          "sequelize;;sequelize-typescript;;", //
          "sequelize;Sequelize;sequelize;default;", //
          "sequelize;Sequelize;sequelize;;Instance",
          "sequelize;Sequelize;sequelize;;Member[Sequelize].Instance",
        ]
    }
  }

  class SequelizeSink extends ModelInput::SinkModelCsv {
    override predicate row(string row) {
      row =
        [
          "sequelize;Sequelize;Member[query].Argument[0];sql-injection",
          "sequelize;Sequelize;Member[query].Argument[0].Member[query];sql-injection",
          "sequelize;;Member[literal,asIs].Argument[0];sql-injection",
          "sequelize;;Argument[1];credentials[user name]",
          "sequelize;;Argument[2];credentials[password]",
          "sequelize;;Argument[0..].Member[username];credentials[user name]",
          "sequelize;;Argument[0..].Member[password];credentials[password]"
        ]
    }
  }

  class SequelizeSource extends ModelInput::SourceModelCsv {
    override predicate row(string row) {
      row = "sequelize;Sequelize;Member[query].ReturnValue.Awaited;database-access-result"
    }
  }
}

private module SpannerCsv {
  class SpannerTypes extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // package1; type1; package2; type2; path
      row =
        [
          "@google-cloud/spanner;;@google-cloud/spanner;;Member[Spanner]",
          "@google-cloud/spanner;Database;@google-cloud/spanner;;ReturnValue.Member[instance].ReturnValue.Member[database].ReturnValue",
          "@google-cloud/spanner;v1.SpannerClient;@google-cloud/spanner;;Member[v1].Member[SpannerClient].Instance",
          "@google-cloud/spanner;Transaction;@google-cloud/spanner;Database;Member[runTransaction,runTransactionAsync,getTransaction].Argument[0..1].Parameter[1]",
          "@google-cloud/spanner;Transaction;@google-cloud/spanner;Database;Member[getTransaction].ReturnValue.Awaited",
          "@google-cloud/spanner;Snapshot;@google-cloud/spanner;Database;Member[getSnapshot].Argument[0..1].Parameter[1]",
          "@google-cloud/spanner;Snapshot;@google-cloud/spanner;Database;Member[getSnapshot].ReturnValue.Awaited",
          "@google-cloud/spanner;BatchTransaction;@google-cloud/spanner;Database;Member[batchTransaction].ReturnValue",
          "@google-cloud/spanner;BatchTransaction;@google-cloud/spanner;Database;Member[createBatchTransaction].ReturnValue.Awaited",
          "@google-cloud/spanner;~SqlExecutorDirect;@google-cloud/spanner;Database;Member[run,runPartitionedUpdate,runStream]",
          "@google-cloud/spanner;~SqlExecutorDirect;@google-cloud/spanner;Transaction;Member[run,runStream,runUpdate]",
          "@google-cloud/spanner;~SqlExecutorDirect;@google-cloud/spanner;BatchTransaction;Member[createQueryPartitions]",
          "@google-cloud/spanner;~SpannerObject;@google-cloud/spanner;v1.SpannerClient;",
          "@google-cloud/spanner;~SpannerObject;@google-cloud/spanner;Database;",
          "@google-cloud/spanner;~SpannerObject;@google-cloud/spanner;Transaction;",
          "@google-cloud/spanner;~SpannerObject;@google-cloud/spanner;Snapshot;",
        ]
    }
  }

  class SpannerSinks extends ModelInput::SinkModelCsv {
    override predicate row(string row) {
      // package; type; path; kind
      row =
        [
          "@google-cloud/spanner;~SqlExecutorDirect;Argument[0];sql-injection",
          "@google-cloud/spanner;~SqlExecutorDirect;Argument[0].Member[sql];sql-injection",
          "@google-cloud/spanner;Transaction;Member[batchUpdate].Argument[0];sql-injection",
          "@google-cloud/spanner;Transaction;Member[batchUpdate].Argument[0].ArrayElement.Member[sql];sql-injection",
          "@google-cloud/spanner;v1.SpannerClient;Member[executeSql,executeStreamingSql].Argument[0].Member[sql];sql-injection",
        ]
    }
  }

  class SpannerSources extends ModelInput::SourceModelCsv {
    override predicate row(string row) {
      row =
        [
          "@google-cloud/spanner;~SpannerObject;Member[executeSql].Argument[0..].Parameter[1];database-access-result",
          "@google-cloud/spanner;~SpannerObject;Member[executeSql].ReturnValue.Awaited.Member[0];database-access-result",
          "@google-cloud/spanner;~SpannerObject;Member[run].ReturnValue.Awaited;database-access-result",
          "@google-cloud/spanner;~SpannerObject;Member[run].Argument[0..].Parameter[1];database-access-result",
        ]
    }
  }
}
