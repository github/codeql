/**
 * @name Expression language injection (JEXL)
 * @description Evaluation of a user-controlled JEXL expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 10.0
 * @precision high
 * @id java/jexl-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.JexlInjection
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a JEXL expression.
 * It supports both JEXL 2 and 3.
 */
class JexlInjectionConfig extends TaintTracking::Configuration {
  JexlInjectionConfig() { this = "JexlInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JexlInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JexlInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "JEXL injection from $@.", source.getNode(), "this user input"
