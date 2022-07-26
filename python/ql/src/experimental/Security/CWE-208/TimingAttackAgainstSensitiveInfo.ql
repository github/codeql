/**
 * @name Timing attack against secret
 * @description Use of a non-constant-time verification routine to check the value of an secret,
 *              possibly allowing a timing attack to retrieve sensitive information.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/timing-attack-sensitive-info
 * @tags security
 *       external/cwe/cwe-208
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TimingAttack
import DataFlow::PathGraph

/**
 * A configuration tracing flow from obtaining a client Secret to a unsafe Comparison.
 */
class ClientSuppliedSecretConfig extends TaintTracking::Configuration {
  ClientSuppliedSecretConfig() { this = "ClientSuppliedSecretConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonOfSecretSink }
}

from ClientSuppliedSecretConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source.getNode(),
  "client-supplied token"
