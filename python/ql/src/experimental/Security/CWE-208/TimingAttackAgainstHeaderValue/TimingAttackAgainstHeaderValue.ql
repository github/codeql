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
import DataFlow::PathGraph

/**
 * A configuration tracing flow from  a client Secret obtained by an HTTP header to a unsafe Comparison.
 */
class ClientSuppliedSecretConfig extends TaintTracking::Configuration {
  ClientSuppliedSecretConfig() { this = "ClientSuppliedSecretConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedSecret }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CompareSink }
}

from ClientSuppliedSecretConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink) and not sink.getNode().(CompareSink).flowtolen()
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source.getNode(),
  "client-supplied token"
