/**
 * @name Groovy Language injection
 * @description Evaluation of a user-controlled Groovy script
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/groovy-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.GroovyInjection
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to evaluate a Groovy expression.
 */
class GroovyInjectionConfig extends TaintTracking::Configuration {
  GroovyInjectionConfig() { this = "GroovyInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GroovyInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(GroovyInjectionAdditionalTaintStep c).step(fromNode, toNode)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, GroovyInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Groovy Injection from $@.", source.getNode(),
  "this user input"
