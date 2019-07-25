/**
 * @name Extension of standard query: Stored XSS (with TrackedNode)
 * @description Extends the standard Stored XSS query with an additional source,
 *              using TrackedNode to track MySQL connections globally.
 * @kind path-problem
 * @tags security
 * @id js/examples/stored-xss-trackednode
 */

import javascript
import DataFlow
import semmle.javascript.security.dataflow.StoredXss
import DataFlow::PathGraph

/**
 * An instance of `mysql.createConnection()`, tracked globally.
 */
class MysqlConnection extends TrackedNode {
  MysqlConnection() { this = moduleImport("mysql").getAMemberCall("createConnection") }

  /**
   * Gets a call to the `query` method on this connection object.
   */
  MethodCallNode getAQueryCall() {
    this.flowsTo(result.getReceiver()) and
    result.getMethodName() = "query"
  }
}

/**
 * Data returned from a MySQL query.
 *
 * For example:
 * ```
 * let mysql = require('mysql');
 *
 * getData(mysql.createConnection());
 *
 * function getData(c) {
 *   c.query(..., (e, data) => { ... });
 * }
 * ```
 */
class MysqlSource extends StoredXss::Source {
  MysqlSource() { this = any(MysqlConnection con).getAQueryCall().getCallback(1).getParameter(1) }
}

from StoredXss::Configuration cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Stored XSS from $@.", source.getNode(), "database value."
