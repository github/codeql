/**
 * @name Timing attack against digest validation
 * @description When checking a signature over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid digest for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure
 *              both the message and the signature.
 *              A successful attack can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/timing-attack-against-signature
 * @tags security
 *       external/cwe/cwe-208
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TimingAttack
import DataFlow::PathGraph

/**
 * A configuration that tracks data flow from cryptographic operations
 * to Equality test.
 */
class TimingAttackAgainstsignature extends TaintTracking::Configuration {
  TimingAttackAgainstsignature() { this = "TimingAttackAgainstsignature" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInputMsgConfig }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UserInputInComparisonConfig }
}

from TimingAttackAgainstsignature config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source,
  source.getNode()

