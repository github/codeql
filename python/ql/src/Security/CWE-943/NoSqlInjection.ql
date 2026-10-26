/**
 * @name NoSQL Injection
 * @description Building a NoSQL query from user-controlled sources is vulnerable to insertion of
 *              malicious NoSQL code by the user.
 * @kind path-problem
 * @precision high
 * @problem.severity error
 * @security-severity 8.8
 * @id py/nosql-injection
 * @tags security
 *       external/cwe/cwe-943
 */

import python
import semmle.python.security.dataflow.NoSqlInjectionQuery
import NoSqlInjectionFlow::PathGraph

from NoSqlInjectionFlow::PathNode source, NoSqlInjectionFlow::PathNode sink
where NoSqlInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This NoSQL query contains an unsanitized $@.", source,
  "user-provided value"
