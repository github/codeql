/**
 * @name Timing attack against sensitive info
 * @description Use of a non-constant-time verification routine to check the value of an sensitive info,
 *              possibly allowing a timing attack to infer the info's expected value.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-sensitive-info
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph
import experimental.semmle.code.java.security.TimingAttack

/**
 * A configuration that tracks data flow from variable that may hold sensitive data
 * to methods that compare data using a non-constant-time algorithm.
 */
class NonConstantTimeComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeComparisonConfig() { this = "NonConstantTimeComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SecretSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeComparisonConfig conf
where
  conf.hasFlowPath(source, sink) and
  (
    source.getNode().(SecretSource).includesUserInput() or
    sink.getNode().(NonConstantTimeComparisonSink).includesUserInput()
  ) and
  not sink.getNode().(NonConstantTimeComparisonSink).includesIs()
select sink.getNode(), source, sink, "timing attack against $@ validation.",
  source.getNode(), "time constant"
