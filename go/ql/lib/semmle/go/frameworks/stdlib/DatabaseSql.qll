/**
 * Provides classes modeling security-relevant aspects of the `database/sql` package.
 */

import go

/**
 * Provides classes modeling security-relevant aspects of the `database/sql` package.
 */
module DatabaseSql {
  /** A query from the `database/sql` package. */
  private class Query extends SQL::Query::Range, DataFlow::MethodCallNode {
    string t;

    Query() {
      exists(Method meth, string base, string m |
        meth.hasQualifiedName("database/sql", t, m) and
        this = meth.getACall()
      |
        t = ["DB", "Tx", "Conn", "Stmt"] and
        base = ["Exec", "Query", "QueryRow"] and
        (m = base or m = base + "Context")
      )
    }

    override DataFlow::Node getAResult() { result = this.getResult(0) }

    override SQL::QueryString getAQueryString() {
      result = this.getAnArgument()
      or
      // attempt to resolve a `QueryString` for `Stmt`s using local data flow.
      t = "Stmt" and
      result = this.getReceiver().getAPredecessor*().(DataFlow::MethodCallNode).getAnArgument()
    }
  }

  /** A query string used in an API function of the `database/sql` package. */
  private class QueryString extends SQL::QueryString::Range {
    QueryString() {
      exists(Method meth, string base, string t, string m, int n |
        t = ["DB", "Tx", "Conn"] and
        meth.hasQualifiedName("database/sql", t, m) and
        this = meth.getACall().getArgument(n)
      |
        base = ["Exec", "Prepare", "Query", "QueryRow"] and
        (
          m = base and n = 0
          or
          m = base + "Context" and n = 1
        )
      )
    }
  }

  /** A query in the standard `database/sql/driver` package. */
  private class DriverQuery extends SQL::Query::Range, DataFlow::MethodCallNode {
    DriverQuery() {
      exists(Method meth |
        (
          meth.hasQualifiedName("database/sql/driver", "Execer", "Exec")
          or
          meth.hasQualifiedName("database/sql/driver", "ExecerContext", "ExecContext")
          or
          meth.hasQualifiedName("database/sql/driver", "Queryer", "Query")
          or
          meth.hasQualifiedName("database/sql/driver", "QueryerContext", "QueryContext")
          or
          meth.hasQualifiedName("database/sql/driver", "Stmt", "Exec")
          or
          meth.hasQualifiedName("database/sql/driver", "Stmt", "Query")
          or
          meth.hasQualifiedName("database/sql/driver", "StmtQueryContext", "QueryContext")
        ) and
        this = meth.getACall()
      )
    }

    override DataFlow::Node getAResult() { result = this.getResult(0) }

    override SQL::QueryString getAQueryString() {
      result = this.getAnArgument()
      or
      this.getTarget().hasQualifiedName("database/sql/driver", "Stmt") and
      result = this.getReceiver().getAPredecessor*().(DataFlow::MethodCallNode).getAnArgument()
    }
  }

  /** A query string used in an API function of the standard `database/sql/driver` package. */
  private class DriverQueryString extends SQL::QueryString::Range {
    DriverQueryString() {
      exists(Method meth, int n |
        (
          meth.hasQualifiedName("database/sql/driver", "Execer", "Exec") and n = 0
          or
          meth.hasQualifiedName("database/sql/driver", "ExecerContext", "ExecContext") and n = 1
          or
          meth.hasQualifiedName("database/sql/driver", "Conn", "Prepare") and n = 0
          or
          meth.hasQualifiedName("database/sql/driver", "ConnPrepareContext", "PrepareContext") and
          n = 1
          or
          meth.hasQualifiedName("database/sql/driver", "Queryer", "Query") and n = 0
          or
          meth.hasQualifiedName("database/sql/driver", "QueryerContext", "QueryContext") and n = 1
        ) and
        this = meth.getACall().getArgument(n)
      )
    }
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  private class SqlMethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    SqlMethodModels() {
      // signature: func (*Row) Scan(dest ...interface{}) error
      this.hasQualifiedName("database/sql", "Row", "Scan") and
      (inp.isReceiver() and outp.isParameter(_))
      or
      // signature: func (*Rows) Scan(dest ...interface{}) error
      this.hasQualifiedName("database/sql", "Rows", "Scan") and
      (inp.isReceiver() and outp.isParameter(_))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
