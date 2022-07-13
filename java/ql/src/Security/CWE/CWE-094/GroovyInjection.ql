/**
 * @name Groovy Language injection
 * @description Evaluation of a user-controlled Groovy script
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/groovy-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.GroovyInjectionQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, GroovyInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Groovy Injection from $@.", source.getNode(),
  "this user input"
