/**
 * @name Expression language injection (MVEL)
 * @description Evaluation of a user-controlled MVEL expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/mvel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.MvelInjection
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a MVEL expression.
 */
class MvelInjectionFlowConfig extends TaintTracking::Configuration {
  MvelInjectionFlowConfig() { this = "MvelInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MvelEvaluationSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof MvelInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(MvelInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MvelInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "MVEL injection from $@.", source.getNode(), "this user input"
