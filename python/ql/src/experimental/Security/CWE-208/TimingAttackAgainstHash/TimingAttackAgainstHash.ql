/**
 * @name Timing attack against Hash
 * @description When checking a Hash over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid Hash for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure.
 *              A successful attack can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision low
 * @id py/timing-attack-against-hash
 * @tags security
 *       external/cwe/cwe-208
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.security.TimingAttack

/**
 * A configuration that tracks data flow from cryptographic operations
 * to Equality test.
 */
private module TimingAttackAgainstHashConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ProduceCryptoCall }

  predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

module TimingAttackAgainstHashFlow = TaintTracking::Global<TimingAttackAgainstHashConfig>;

import TimingAttackAgainstHashFlow::PathGraph

from TimingAttackAgainstHashFlow::PathNode source, TimingAttackAgainstHashFlow::PathNode sink
where
  TimingAttackAgainstHashFlow::flowPath(source, sink) and
  sink.getNode().(NonConstantTimeComparisonSink).includesUserInput()
select sink.getNode(), source, sink, "Timing attack against $@ validation.",
  source.getNode().(ProduceCryptoCall).getResultType(), "message"
