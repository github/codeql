/**
 * @name Extension of standard query: Stored XSS
 * @description Extends the standard Stored XSS query with an additional source.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/stored-xss
 */

import javascript
import semmle.javascript.security.dataflow.StoredXssQuery
import StoredXssFlow::PathGraph

/**
 * The data returned from a MySQL query, such as the `data` parameter in this example:
 * ```
 * let mysql = require('mysql');
 * let connection = mysql.createConnection();
 *
 * connection.query(..., (e, data) => { ... });
 * ```
 */
class MysqlSource extends Source {
  MysqlSource() {
    this =
      DataFlow::moduleImport("mysql")
          .getAMemberCall("createConnection")
          .getAMethodCall("query")
          .getCallback(1)
          .getParameter(1)
  }
}

from StoredXssFlow::PathNode source, StoredXssFlow::PathNode sink
where StoredXssFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Stored XSS from $@.", source.getNode(), "database value."
