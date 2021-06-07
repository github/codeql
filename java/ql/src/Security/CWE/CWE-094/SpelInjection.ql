/**
 * @name Expression language injection (Spring)
 * @description Evaluation of a user-controlled Spring Expression Language (SpEL) expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/spel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.SpelInjection
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a SpEL expression.
 */
class SpELInjectionConfig extends TaintTracking::Configuration {
  SpELInjectionConfig() { this = "SpELInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SpelExpressionEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(SpelExpressionInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SpELInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "SpEL injection from $@.", source.getNode(), "this user input"
