/**
 * Provides classes for working with SQL-related concepts such as queries.
 */

import go

module ThirdPartSQL {

  /** Sinks of github.com/jinzhu/gorm */
  class GormSink extends DataFlow::Node, SQL::QueryString::Range {
    GormSink() {
      exists(
        Method meth, string name | 
        meth.hasQualifiedName("github.com/jinzhu/gorm", "DB", name) and
	asExpr() = meth.getACall().getArgument(0).asExpr() and
	(
          name = "Where" or name = "Raw" or name = "Order" or name = "Not" or name = "Or" or
	  name = "Select" or name = "Table" or name = "Group" or name = "Having" or name = "Joins"
	)
      )
    }
  }
    
  /** Sinks of github.com/jmoiron/sqlx */
  class SqlxSink extends DataFlow::Node, SQL::QueryString::Range {
    SqlxSink() {
      exists(
	Method meth, string name, int n |
	(
	  meth.hasQualifiedName("github.com/jmoiron/sqlx", "DB", name) or 
	  meth.hasQualifiedName("github.com/jmoiron/sqlx", "Tx", name) 
	) and this = meth.getACall().getArgument(n) |
	(
	  (name = "Select" or name = "Get") and n = 1
	)
	or
	(
	  (
	    name = "MustExec" or name = "Queryx" or
	    name = "NamedExec" or name = "NamedQuery" 
	  )
	  and n = 0
        )
      )
    }
  }

}
