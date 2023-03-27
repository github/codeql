/**
 * @name Timing attack against Hash
 * @description When checking a Hash over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid Hash for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure.
 *              A successful attack can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision low
 * @id py/possible-timing-attack-against-hash
 * @tags security
 *       external/cwe/cwe-208
 *       experimental
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.security.TimingAttack
import DataFlow::PathGraph

/**
 * A configuration that tracks data flow from cryptographic operations
 * to equality test
 */
class PossibleTimingAttackAgainstHash extends TaintTracking::Configuration {
  PossibleTimingAttackAgainstHash() { this = "PossibleTimingAttackAgainstHash" }

  override predicate isSource(DataFlow::Node source) { source instanceof ProduceCryptoCall }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from PossibleTimingAttackAgainstHash config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible Timing attack against $@ validation.",
  source.getNode().(ProduceCryptoCall).getResultType(), "message"
