/**
 * @name Query built from local-user-controlled sources
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/sql-injection-local
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import java
import semmle.code.java.security.SqlTaintedLocalQuery
import LocalUserInputToQueryInjectionFlow::PathGraph

from
  LocalUserInputToQueryInjectionFlow::PathNode source,
  LocalUserInputToQueryInjectionFlow::PathNode sink
where LocalUserInputToQueryInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on a $@.", source.getNode(),
  "user-provided value"
