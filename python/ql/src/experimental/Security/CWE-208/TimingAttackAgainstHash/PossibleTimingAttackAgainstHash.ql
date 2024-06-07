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

/**
 * A configuration that tracks data flow from cryptographic operations
 * to equality test
 */
private module PossibleTimingAttackAgainstHashConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ProduceCryptoCall }

  predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

module PossibleTimingAttackAgainstHashFlow =
  TaintTracking::Global<PossibleTimingAttackAgainstHashConfig>;

import PossibleTimingAttackAgainstHashFlow::PathGraph

from
  PossibleTimingAttackAgainstHashFlow::PathNode source,
  PossibleTimingAttackAgainstHashFlow::PathNode sink
where PossibleTimingAttackAgainstHashFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Possible Timing attack against $@ validation.",
  source.getNode().(ProduceCryptoCall).getResultType(), "message"
