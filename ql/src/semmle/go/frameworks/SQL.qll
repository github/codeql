/**
 * Provides classes for working with SQL-related concepts such as queries.
 */

import go

module SQL {
  /**
   * A data-flow node whose string value is interpreted as (part of) a SQL query.
   *
   * Extends this class to refine existing API models. If you want to model new APIs,
   * extend `SQL::QueryString::Range` instead.
   */
  class QueryString extends DataFlow::Node {
    QueryString::Range self;

    QueryString() { this = self }
  }

  module QueryString {
    /**
     * A data-flow node whose string value is interpreted as (part of) a SQL query.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `SQL::QueryString` instead.
     */
    abstract class Range extends DataFlow::Node { }

    /** A query string used in an API function of the standard `database/sql` package. */
    private class StandardQueryString extends Range {
      StandardQueryString() {
        exists(Method meth, string base, string m, int n |
          meth.hasQualifiedName("database/sql", "DB", m) and
          this = meth.getACall().getArgument(n)
        |
          (base = "Exec" or base = "Prepare" or base = "Query" or base = "QueryRow") and
          (
            m = base and n = 0
            or
            m = base + "Context" and n = 1
          )
        )
      }
    }

    /**
     * An argument to an API of the squirrel library that is directly interpreted as SQL without
     * taking syntactic structure into account.
     */
    private class SquirrelQueryString extends Range {
      SquirrelQueryString() {
        exists(Function fn |
          exists(string sq |
            sq = "github.com/Masterminds/squirrel" or
            sq = "github.com/lann/squirrel" |
            // first argument to `squirrel.Expr`
            fn.hasQualifiedName(sq, "Expr")
            or
            // first argument to the `Prefix` or `Suffix` method of one of the `*Builder` classes
            exists(string builder | builder.matches("%Builder") |
              fn.(Method).hasQualifiedName(sq, builder, "Prefix") or
              fn.(Method).hasQualifiedName(sq, builder, "Suffix")
            )
          ) and
          this = fn.getACall().getArgument(0) and
          this.getType().getUnderlyingType() instanceof StringType
        )
      }
    }
  }
}
