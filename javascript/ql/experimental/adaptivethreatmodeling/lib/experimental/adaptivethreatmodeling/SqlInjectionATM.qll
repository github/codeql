/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
 * Defines shared code used by the SQL injection boosted query.
 */

import semmle.javascript.heuristics.SyntacticHeuristics
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import AdaptiveThreatModeling

class SqlInjectionAtmConfig extends AtmConfig {
  SqlInjectionAtmConfig() { this = "SqlInjectionAtmConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof SqlInjection::Source }

  override EndpointType getASinkEndpointType() { result instanceof SqlInjectionSinkType }

  /*
   * This is largely a copy of the taint tracking configuration for the standard SQL injection
   * query, except additional sinks have been added using the sink endpoint filter.
   */

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof SqlInjection::Sanitizer
  }
}
