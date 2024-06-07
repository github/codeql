/**
 * Provides classes for working with SQL connectors.
 */

import javascript

module SQL {
  /** A string-valued dataflow node that is interpreted as a SQL command. */
  abstract class SqlString extends DataFlow::Node { }

  private class SqlStringFromModel extends SqlString {
    SqlStringFromModel() { this = ModelOutput::getASinkNode("sql-injection").asSink() }
  }

  /**
   * An dataflow node that sanitizes a string to make it safe to embed into
   * a SQL command.
   */
  abstract class SqlSanitizer extends DataFlow::Node {
    DataFlow::Node input;
    DataFlow::Node output;

    /** Gets the input expression being sanitized. */
    DataFlow::Node getInput() { result = input }

    /** Gets the output expression containing the sanitized value. */
    DataFlow::Node getOutput() { result = output }
  }
}

/**
 * Provides classes modeling the (API compatible) `mysql` and `mysql2` packages.
 */
private module MySql {
  private string moduleName() { result = ["mysql", "mysql2", "mysql2/promise"] }

  /** Gets the package name `mysql` or `mysql2`. */
  API::Node mysql() { result = API::moduleImport(moduleName()) }

  private API::Node connectionOrPool() {
    result = API::Node::ofType(moduleName(), ["Connection", "Pool"])
  }

  /** A call to the MySql `query` method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() { this = connectionOrPool().getMember(["query", "execute"]).getACall() }

    override DataFlow::Node getAResult() { result = this.getCallback(_).getParameter(1) }

    override DataFlow::Node getAQueryArgument() {
      result = this.getArgument(0) or result = this.getOptionArgument(0, "sql")
    }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument() }
  }

  /** A call to the `escape` or `escapeId` method that performs SQL sanitization. */
  class EscapingSanitizer extends SQL::SqlSanitizer instanceof API::CallNode {
    EscapingSanitizer() {
      this = [mysql(), connectionOrPool()].getMember(["escape", "escapeId"]).getACall() and
      input = this.getArgument(0) and
      output = this
    }
  }

  private API::Node connectionOptions() {
    result = API::Node::ofType(moduleName(), "ConnectionOptions")
  }

  /** An expression that is passed as user name or password to `mysql.createConnection`. */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop |
        this = connectionOptions().getMember(prop).asSink() and
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
  /** Gets a reference to the `Client` constructor in the `pg` package, for example `require('pg').Client`. */
  API::Node clientOrPoolConstructor() {
    result = API::Node::ofType("pg", ["ClientStatic", "PoolStatic"])
    or
    result = API::moduleImport("pg-pool")
  }

  /** Gets a freshly created Postgres client instance. */
  API::Node clientOrPool() { result = API::Node::ofType("pg", ["Client", "PoolClient", "Pool"]) }

  /** A call to the Postgres `query` method. */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    QueryCall() { this = clientOrPool().getMember(["execute", "query"]).getACall() }

    override DataFlow::Node getAResult() {
      this.getNumArgument() = 2 and
      result = this.getCallback(1).getParameter(1)
      or
      this.getNumArgument() = 1 and
      result = this.getAMethodCall("then").getCallback(0).getParameter(0)
      or
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() {
      result = this.getArgument(0) or result = this.getParameter(0).getMember("text").asSink()
    }
  }

  /**
   * Gets the Postgres Query class.
   * This class can be used to create reusable query objects (see https://node-postgres.com/apis/client).
   */
  API::Node query() { result = API::moduleImport("pg").getMember("Query") }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() {
      this = any(QueryCall qc).getAQueryArgument()
      or
      this = API::moduleImport("pg-cursor").getParameter(0).asSink()
      or
      this = query().getParameter(0).asSink()
    }
  }

  /** An expression that is passed as user name or password when creating a client or a pool. */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop |
        this = clientOrPoolConstructor().getParameter(0).getMember(prop).asSink()
        or
        this = pgPromise().getParameter(0).getMember(prop).asSink()
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

  /** Gets a `pg-promise` object which supports querying (database, connection, or task). */
  API::Node pgpObject() { result = API::Node::ofType("pg-promise", "IBaseProtocol") }

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
    PgPromiseQueryString() { this = any(PgPromiseQueryCall qc).getAQueryArgument() }
  }
}

/**
 * Provides classes modeling the `sqlite3` package.
 */
private module Sqlite3 {
  /** Gets an expression that constructs or returns a Sqlite database instance. */
  API::Node database() { result = API::Node::ofType("sqlite3", "Database") }

  /** A call to a Sqlite query method. */
  private class QueryCall extends DatabaseAccess, DataFlow::MethodCallNode {
    QueryCall() {
      this = database().getMember(["all", "each", "exec", "get", "prepare", "run"]).getACall()
    }

    override DataFlow::Node getAResult() {
      result = this.getCallback(1).getParameter(1) or
      PromiseFlow::loadStep(this.getALocalUse(), result, Promises::valueProp())
    }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument() }
  }
}

/**
 * Provides classes modeling the `sqlite` package.
 */
private module Sqlite {
  /** Gets an expression that constructs or returns a Sqlite database instance. */
  API::Node database() {
    result = API::moduleImport("sqlite").getMember("open").getReturn().getPromised()
  }

  /** A call to a Sqlite query method. */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    QueryCall() {
      this = database().getMember(["all", "each", "exec", "get", "prepare", "run"]).getACall()
    }

    override DataFlow::Node getAResult() { result = this }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument() }
  }
}

/**
 * Provides classes modeling the `better-sqlite3` package.
 */
private module BetterSqlite3 {
  /**
   * Gets a `better-sqlite3` database instance.
   */
  API::Node database() {
    result =
      [
        API::moduleImport("better-sqlite3").getInstance(),
        API::moduleImport("better-sqlite3").getReturn()
      ]
    or
    result = database().getMember("exec").getReturn()
  }

  /** A call to a better-sqlite3 query method. */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    QueryCall() { this = database().getMember(["exec", "prepare"]).getACall() }

    override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument() }
  }
}

/**
 * Provides classes modeling the `mssql` package.
 */
private module MsSql {
  /** Gets a reference to the `mssql` module. */
  API::Node mssql() { result = API::moduleImport("mssql") }

  /** Gets an API node corresponding to a type with a `query` or `batch` method. */
  API::Node queryable() {
    result = API::Node::ofType("mssql", ["Request", "ConnectionPool"]) or result = mssql()
  }

  /** Gets an API node referring to a configuration object. */
  API::Node config() { result = API::Node::ofType("mssql", "config") }

  /** A tagged template evaluated as a query. */
  private class QueryTemplateExpr extends DatabaseAccess, DataFlow::ValueNode, DataFlow::SourceNode {
    override TaggedTemplateExpr astNode;

    QueryTemplateExpr() {
      mssql().getMember("query").getAValueReachableFromSource() =
        DataFlow::valueNode(astNode.getTag())
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
    QueryCall() { this = queryable().getMember(["query", "batch"]).getACall() }

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
        this = dba.getAQueryArgument()
      )
    }
  }

  /** An element of a query template, which is automatically sanitized. */
  class QueryTemplateSanitizer extends SQL::SqlSanitizer {
    QueryTemplateSanitizer() {
      this = any(QueryTemplateExpr qte).getAQueryArgument() and
      input = this and
      output = this
    }
  }

  /** An expression that is passed as user name or password when creating a client or a pool. */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop |
        this = config().getMember(prop).asSink() and
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
