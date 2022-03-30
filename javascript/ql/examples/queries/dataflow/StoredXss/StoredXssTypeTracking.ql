/**
 * @name Extension of standard query: Stored XSS (with TrackedNode)
 * @description Extends the standard Stored XSS query with an additional source,
 *              using TrackedNode to track MySQL connections globally.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/stored-xss-trackednode
 */

import javascript
import semmle.javascript.security.dataflow.StoredXssQuery
import DataFlow::PathGraph

/**
 * Gets an instance of `mysql.createConnection()`, tracked globally.
 */
DataFlow::SourceNode mysqlConnection(DataFlow::TypeTracker t) {
  t.start() and
  result = DataFlow::moduleImport("mysql").getAMemberCall("createConnection")
  or
  exists(DataFlow::TypeTracker t2 | result = mysqlConnection(t2).track(t2, t))
}

/**
 * Gets an instance of `mysql.createConnection()`, tracked globally.
 */
DataFlow::SourceNode mysqlConnection() { result = mysqlConnection(DataFlow::TypeTracker::end()) }

/**
 * The data returned from a MySQL query.
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
class MysqlSource extends Source {
  MysqlSource() { this = mysqlConnection().getAMethodCall("query").getCallback(1).getParameter(1) }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Stored XSS from $@.", source.getNode(), "database value."
