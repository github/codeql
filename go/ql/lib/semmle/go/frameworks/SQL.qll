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

    private class DefaultQueryString extends Range {
      DefaultQueryString() {
        exists(DataFlow::ArgumentNode arg | sinkNode(arg, "sql-injection") |
          not arg instanceof DataFlow::ImplicitVarargsSlice and
          this = arg
          or
          arg instanceof DataFlow::ImplicitVarargsSlice and
          this = arg.getCall().getAnImplicitVarargsArgument()
        )
      }
    }

    /** A string that might identify package `go-pg/pg` or a specific version of it. */
    private string gopg() { result = package("github.com/go-pg/pg", "") }

    /** A string that might identify package `go-pg/pg/orm` or a specific version of it. */
    private string gopgorm() { result = package("github.com/go-pg/pg", "orm") }

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
          exists(string tp, string m | f.(Method).hasQualifiedName([gopgorm(), gopg()], tp, m) |
            tp = ["DB", "Conn"] and
            m = ["QueryContext", "QueryOneContext"] and
            arg = 2
            or
            tp = ["DB", "Conn"] and
            m = ["ExecContext", "ExecOneContext", "Query", "QueryOne"] and
            arg = 1
            or
            tp = ["DB", "Conn"] and
            m = ["Exec", "ExecOne", "Prepare"] and
            arg = 0
            or
            tp = "Query" and
            m =
              [
                "ColumnExpr", "For", "GroupExpr", "Having", "Join", "OrderExpr", "TableExpr",
                "Where", "WhereIn", "WhereInMulti", "WhereOr"
              ] and
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
        this = meth.getACall().getSyntacticArgument(n) and
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

/**
 * Provides classes for working with the [Bun](https://bun.uptrace.dev/) package.
 */
module Bun {
  /** Gets the package name for Bun package. */
  private string packagePath() { result = package("github.com/uptrace/bun", "") }

  /** A model for sinks of Bun. */
  private class BunSink extends SQL::QueryString::Range {
    BunSink() {
      exists(Function f, string m, int arg | this = f.getACall().getArgument(arg) |
        f.hasQualifiedName(packagePath(), m) and
        m = "NewRawQuery" and
        arg = 1
      )
      or
      exists(Method f, string tp, string m, int arg | this = f.getACall().getArgument(arg) |
        f.hasQualifiedName(packagePath(), tp, m) and
        (
          tp = ["DB", "Conn"] and
          m = ["ExecContext", "PrepareContext", "QueryContext", "QueryRowContext"] and
          arg = 1
          or
          tp = ["DB", "Conn"] and
          m = ["Exec", "NewRaw", "Prepare", "Query", "QueryRow", "Raw"] and
          arg = 0
          or
          tp.matches("%Query") and
          m =
            [
              "ColumnExpr", "DistinctOn", "For", "GroupExpr", "Having", "ModelTableExpr",
              "OrderExpr", "TableExpr", "Where", "WhereOr"
            ] and
          arg = 0
          or
          tp = "RawQuery" and
          m = "NewRaw" and
          arg = 0
        )
      )
    }
  }
}
