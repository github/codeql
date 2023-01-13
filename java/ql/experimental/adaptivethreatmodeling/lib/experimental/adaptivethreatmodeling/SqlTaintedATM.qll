/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
 * Defines shared code used by the SQL injection boosted query.
 * Largely copied from semmle.code.java.security.SqlInjectionQuery.
 */

import ATMConfig
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection

class SqlTaintedAtmConfig extends AtmConfig {
  SqlTaintedAtmConfig() { this = "SqlTaintedAtmConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override EndpointType getASinkEndpointType() { result instanceof SqlTaintedSinkType }

  /*
   * This is largely a copy of the taint tracking configuration for the standard SQL injection
   * query, except additional sinks have been added using the sink endpoint filter.
   */

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}
