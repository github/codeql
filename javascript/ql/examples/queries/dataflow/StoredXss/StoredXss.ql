/**
 * @name Extension of standard query: Stored XSS
 * @description Extends the standard Stored XSS query with an additional source.
 * @kind path-problem
 * @tags security
 * @id js/examples/stored-xss
 */

import javascript
import DataFlow
import semmle.javascript.security.dataflow.StoredXss
import DataFlow::PathGraph

/**
 * Data returned from a MySQL query, such as the `data` parameter in this example:
 * ```
 * let mysql = require('mysql');
 * let connection = mysql.createConnection();
 *
 * connection.query(..., (e, data) => { ... });
 * ```
 */
class MysqlSource extends StoredXss::Source {
  MysqlSource() {
    this =
      moduleImport("mysql")
          .getAMemberCall("createConnection")
          .getAMethodCall("query")
          .getCallback(1)
          .getParameter(1)
  }
}

from StoredXss::Configuration cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Stored XSS from $@.", source.getNode(), "database value."
