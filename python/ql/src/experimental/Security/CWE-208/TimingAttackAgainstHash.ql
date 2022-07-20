/**
 * @name Timing attack against Hash
 * @description When checking a Hash over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid Hash for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure.
 *              A successful attack can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/timing-attack-against-hash
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
class TimingAttackAgainsthash extends TaintTracking::Configuration {
  TimingAttackAgainsthash() { this = "TimingAttackAgainsthash" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInputMsgConfig }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UserInputInComparisonConfig }
}

from TimingAttackAgainsthash config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source,
  source.getNode()
