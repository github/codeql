/**
 * @name NoSQL Injection
 * @description Building a NoSQL query from user-controlled sources is vulnerable to insertion of
 *              malicious NoSQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id py/nosql-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-943
 */

import python
import experimental.semmle.python.security.injection.NoSQLInjection
import DataFlow::PathGraph

from NoSqlInjection::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "This NoSQL query contains an unsanitized $@.", source,
  "user-provided value"
