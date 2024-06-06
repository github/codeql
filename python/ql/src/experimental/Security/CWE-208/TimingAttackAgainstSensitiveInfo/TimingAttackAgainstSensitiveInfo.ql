/**
 * @name Timing attack against secret
 * @description Use of a non-constant-time verification routine to check the value of an secret,
 *              possibly allowing a timing attack to retrieve sensitive information.
 * @kind path-problem
 * @problem.severity error
 * @precision low
 * @id py/timing-attack-sensitive-info
 * @tags security
 *       external/cwe/cwe-208
 *       experimental
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.security.TimingAttack
import TimingAttackAgainstSensitiveInfoFlow::PathGraph

/**
 * A configuration tracing flow from obtaining a client Secret to a unsafe Comparison.
 */
private module TimingAttackAgainstSensitiveInfoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SecretSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

module TimingAttackAgainstSensitiveInfoFlow =
  TaintTracking::Global<TimingAttackAgainstSensitiveInfoConfig>;

from
  TimingAttackAgainstSensitiveInfoFlow::PathNode source,
  TimingAttackAgainstSensitiveInfoFlow::PathNode sink
where
  TimingAttackAgainstSensitiveInfoFlow::flowPath(source, sink) and
  (
    source.getNode().(SecretSource).includesUserInput() or
    sink.getNode().(NonConstantTimeComparisonSink).includesUserInput()
  )
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source.getNode(),
  "client-supplied token"
