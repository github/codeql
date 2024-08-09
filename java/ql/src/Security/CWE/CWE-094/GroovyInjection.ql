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
private import semmle.code.java.dataflow.DataFlowFiltering

module GroovyInjectionFlow = TaintTracking::Global<FilteredConfig<GroovyInjectionConfig>>;

import GroovyInjectionFlow::PathGraph

from GroovyInjectionFlow::PathNode source, GroovyInjectionFlow::PathNode sink
where GroovyInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Groovy script depends on a $@.", source.getNode(),
  "user-provided value"
