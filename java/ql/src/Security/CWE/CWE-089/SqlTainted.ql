/**
 * @name Query built from user-controlled sources
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjectionLib
import DataFlow::PathGraph

from QueryInjectionSink query, DataFlow::PathNode source, DataFlow::PathNode sink
where queryTaintedBy(query, source, sink)
select query, source, sink, "Query might include code from $@.", source.getNode(), "this user input"
