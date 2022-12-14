/**
 * Provides classes for working with SQL-related concepts such as queries.
 */

import go

/** Provides classes for working with SQL-related APIs. */
module SQL {
  /**
   * A data-flow node that represents a SQL query.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `SQL::Query::Range` instead.
   */
  class Query extends DataFlow::Node instanceof Query::Range {
    /** Gets a result of this query execution. */
    DataFlow::Node getAResult() { result = super.getAResult() }

    /**
     * Gets a query string that is used as (part of) this SQL query.
     *
     * Note that this may not resolve all `QueryString`s that should be associated with this
     * query due to data flow.
     */
    QueryString getAQueryString() { result = super.getAQueryString() }
  }

  /**
   * A data-flow node that represents a SQL query.
   */
  module Query {
    /**
     * A data-flow node that represents a SQL query.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `SQL::Query` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets a result of this query execution. */
      abstract DataFlow::Node getAResult();

      /**
       * Gets a query string that is used as (part of) this SQL query.
       *
       * Note that this does not have to resolve all `QueryString`s that should be associated with this
       * query due to data flow.
       */
      abstract QueryString getAQueryString();
    }
  }

  /**
   * A data-flow node whose string value is interpreted as (part of) a SQL query.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `SQL::QueryString::Range` instead.
   */
  class QueryString extends DataFlow::Node instanceof QueryString::Range { }

  /** Provides classes for working with SQL query strings. */
  module QueryString {
    /**
     * A data-flow node whose string value is interpreted as (part of) a SQL query.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `SQL::QueryString` instead.
     */
    abstract class Range extends DataFlow::Node { }

    /**
     * An argument to an API of the squirrel library that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class SquirrelQueryString extends Range {
      SquirrelQueryString() {
        exists(Function fn |
          exists(string sq |
            sq =
              package([
                  "github.com/Masterminds/squirrel", "gopkg.in/Masterminds/squirrel",
                  "github.com/lann/squirrel"
                ], "")
          |
            // first argument to `squirrel.Expr`
            fn.hasQualifiedName(sq, "Expr")
            or
            // first argument to the `Prefix`, `Suffix` or `Where` method of one of the `*Builder` classes
            exists(string builder | builder.matches("%Builder") |
              fn.(Method).hasQualifiedName(sq, builder, "Prefix") or
              fn.(Method).hasQualifiedName(sq, builder, "Suffix") or
              fn.(Method).hasQualifiedName(sq, builder, "Where")
            )
          ) and
          this = fn.getACall().getArgument(0) and
          this.getType().getUnderlyingType() instanceof StringType
        )
      }
    }

    /** A string that might identify package `go-pg/pg` or a specific version of it. */
    private string gopg() { result = package("github.com/go-pg/pg", "") }

    /** A string that might identify package `go-pg/pg/orm` or a specific version of it. */
    private string gopgorm() { result = package("github.com/go-pg/pg", "orm") }

    /** A string that might identify package `github.com/rqlite/gorqlite` or `github.com/raindog308/gorqlite` or a specific version of it. */
    private string gorqlite() {
      result = package(["github.com/rqlite/gorqlite", "github.com/raindog308/gorqlite"], "")
    }

    /** A string that might identify package `github.com/gogf/gf/database/gdb` or a specific version of it. */
    private string gogf() { result = package("github.com/gogf/gf", "database/gdb") }

    /**
     * A string argument to an API of `go-pg/pg` that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class PgQueryString extends Range {
      PgQueryString() {
        exists(Function f, int arg |
          f.hasQualifiedName(gopg(), "Q") and
          arg = 0
          or
          exists(string tp, string m | f.(Method).hasQualifiedName(gopg(), tp, m) |
            (tp = "Conn" or tp = "DB" or tp = "Tx") and
            (
              m = "FormatQuery" and arg = 1
              or
              m = "Prepare" and arg = 0
            )
          )
        |
          this = f.getACall().getArgument(arg)
        )
      }
    }

    /**
     * A string argument to an API of `go-pg/pg/orm` that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class PgOrmQueryString extends Range {
      PgOrmQueryString() {
        exists(Function f, int arg |
          f.hasQualifiedName(gopgorm(), "Q") and
          arg = 0
          or
          exists(string tp, string m | f.(Method).hasQualifiedName(gopgorm(), tp, m) |
            tp = "Query" and
            m = ["ColumnExpr", "For", "Having", "Where", "WhereIn", "WhereInMulti", "WhereOr"] and
            arg = 0
            or
            tp = "Query" and
            m = "FormatQuery" and
            arg = 1
          )
        |
          this = f.getACall().getArgument(arg)
        )
      }
    }

    /**
     * A string argument to an API of `github.com/rqlite/gorqlite`, or a specific version of it, that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class GorqliteQueryString extends Range {
      GorqliteQueryString() {
        // func (conn *Connection) Query(sqlStatements []string) (results []QueryResult, err error)
        // func (conn *Connection) QueryOne(sqlStatement string) (qr QueryResult, err error)
        // func (conn *Connection) Queue(sqlStatements []string) (seq int64, err error)
        // func (conn *Connection) QueueOne(sqlStatement string) (seq int64, err error)
        // func (conn *Connection) Write(sqlStatements []string) (results []WriteResult, err error)
        // func (conn *Connection) WriteOne(sqlStatement string) (wr WriteResult, err error)
        exists(Method m, string name | m.hasQualifiedName(gorqlite(), "Connection", name) |
          name = ["Query", "QueryOne", "Queue", "QueueOne", "Write", "WriteOne"] and
          this = m.getACall().getArgument(0)
        )
      }
    }

    /**
     * A string argument to an API of `github.com/gogf/gf/database/gdb`, or a specific version of it, that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class GogfQueryString extends Range {
      GogfQueryString() {
        exists(Method m, string name | m.implements(gogf(), ["DB", "Core", "TX"], name) |
          // func (c *Core) Exec(sql string, args ...interface{}) (result sql.Result, err error)
          // func (c *Core) GetAll(sql string, args ...interface{}) (Result, error)
          // func (c *Core) GetArray(sql string, args ...interface{}) ([]Value, error)
          // func (c *Core) GetCount(sql string, args ...interface{}) (int, error)
          // func (c *Core) GetOne(sql string, args ...interface{}) (Record, error)
          // func (c *Core) GetValue(sql string, args ...interface{}) (Value, error)
          // func (c *Core) Prepare(sql string, execOnMaster ...bool) (*Stmt, error)
          // func (c *Core) Query(sql string, args ...interface{}) (rows *sql.Rows, err error)
          // func (c *Core) Raw(rawSql string, args ...interface{}) *Model
          name =
            [
              "Query", "Exec", "Prepare", "GetAll", "GetOne", "GetValue", "GetArray", "GetCount",
              "Raw"
            ] and
          this = m.getACall().getArgument(0)
          or
          // func (c *Core) GetScan(pointer interface{}, sql string, args ...interface{}) error
          // func (c *Core) GetStruct(pointer interface{}, sql string, args ...interface{}) error
          // func (c *Core) GetStructs(pointer interface{}, sql string, args ...interface{}) error
          name = ["GetScan", "GetStruct", "GetStructs"] and
          this = m.getACall().getArgument(1)
          or
          // func (c *Core) DoCommit(ctx context.Context, link Link, sql string, args []interface{}) (newSql string, newArgs []interface{}, err error)
          // func (c *Core) DoExec(ctx context.Context, link Link, sql string, args ...interface{}) (result sql.Result, err error)
          // func (c *Core) DoGetAll(ctx context.Context, link Link, sql string, args ...interface{}) (result Result, err error)
          // func (c *Core) DoPrepare(ctx context.Context, link Link, sql string) (*Stmt, error)
          // func (c *Core) DoQuery(ctx context.Context, link Link, sql string, args ...interface{}) (rows *sql.Rows, err error)
          name = ["DoGetAll", "DoQuery", "DoExec", "DoCommit", "DoPrepare"] and
          this = m.getACall().getArgument(2)
        )
      }
    }

    /** A taint model for various methods on the struct `Formatter` of `go-pg/pg/orm`. */
    private class PgOrmFormatterFunction extends TaintTracking::FunctionModel, Method {
      FunctionInput i;
      FunctionOutput o;

      PgOrmFormatterFunction() {
        exists(string m | this.hasQualifiedName(gopgorm(), "Formatter", m) |
          // func (f Formatter) Append(dst []byte, src string, params ...interface{}) []byte
          // func (f Formatter) AppendBytes(dst, src []byte, params ...interface{}) []byte
          // func (f Formatter) FormatQuery(dst []byte, query string, params ...interface{}) []byte
          (m = "Append" or m = "AppendBytes" or m = "FormatQuery") and
          i.isParameter(1) and
          (o.isParameter(0) or o.isResult())
        )
      }

      override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
        inp = i and outp = o
      }
    }
  }

  /** A model for sinks of GORM. */
  private class GormSink extends SQL::QueryString::Range {
    GormSink() {
      exists(Method meth, string package, string name |
        meth.hasQualifiedName(package, "DB", name) and
        this = meth.getACall().getArgument(0) and
        package = Gorm::packagePath() and
        name in [
            "Where", "Raw", "Order", "Not", "Or", "Select", "Table", "Group", "Having", "Joins",
            "Exec", "Distinct", "Pluck"
          ]
      )
    }
  }

  /** A model for sinks of github.com/jmoiron/sqlx. */
  private class SqlxSink extends SQL::QueryString::Range {
    SqlxSink() {
      exists(Method meth, string name, int n |
        meth.hasQualifiedName(package("github.com/jmoiron/sqlx", ""), ["DB", "Tx"], name) and
        this = meth.getACall().getArgument(n)
      |
        name = ["Select", "Get"] and n = 1
        or
        name = ["MustExec", "Queryx", "NamedExec", "NamedQuery"] and n = 0
      )
    }
  }
}

/**
 * Provides classes for working with the [GORM](https://gorm.io/) package.
 */
module Gorm {
  /** Gets the package name for Gorm. */
  string packagePath() {
    result = package(["github.com/jinzhu/gorm", "github.com/go-gorm/gorm", "gorm.io/gorm"], "")
  }
}

/**
 * Provides classes for working with the [XORM](https://xorm.io/) package.
 */
module Xorm {
  /** Gets the package name for Xorm. */
  string packagePath() { result = package(["xorm.io/xorm", "github.com/go-xorm/xorm"], "") }

  /** A model for sinks of XORM. */
  private class XormSink extends SQL::QueryString::Range {
    XormSink() {
      exists(Method meth, string type, string name, int n |
        meth.hasQualifiedName(Xorm::packagePath(), type, name) and
        this = meth.getACall().getArgument(n) and
        type = ["Engine", "Session"]
      |
        name =
          [
            "Query", "Exec", "QueryString", "QueryInterface", "SQL", "Where", "And", "Or", "Alias",
            "NotIn", "In", "Select", "SetExpr", "OrderBy", "Having", "GroupBy"
          ] and
        n = 0
        or
        name = ["SumInt", "Sum", "Sums", "SumsInt"] and n = 1
        or
        name = "Join" and n = [0, 1, 2]
      )
    }
  }
}
