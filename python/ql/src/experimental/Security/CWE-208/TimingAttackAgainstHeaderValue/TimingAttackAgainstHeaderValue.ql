/**
 * @name Timing attack against header value
 * @description Use of a non-constant-time verification routine to check the value of an HTTP header,
 *              possibly allowing a timing attack to infer the header's expected value.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/timing-attack-against-header-value
 * @tags security
 *       external/cwe/cwe-208
 *       experimental
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.security.TimingAttack

/**
 * A configuration tracing flow from  a client Secret obtained by an HTTP header to a unsafe Comparison.
 */
private module TimingAttackAgainstHeaderValueConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedSecret }

  predicate isSink(DataFlow::Node sink) { sink instanceof CompareSink }
}

module TimingAttackAgainstHeaderValueFlow =
  TaintTracking::Global<TimingAttackAgainstHeaderValueConfig>;

import TimingAttackAgainstHeaderValueFlow::PathGraph

from
  TimingAttackAgainstHeaderValueFlow::PathNode source,
  TimingAttackAgainstHeaderValueFlow::PathNode sink
where
  TimingAttackAgainstHeaderValueFlow::flowPath(source, sink) and
  not sink.getNode().(CompareSink).flowtolen()
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source.getNode(),
  "client-supplied token"
