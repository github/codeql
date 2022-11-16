/**
 * For internal use only.
 *
 * Defines shared code used by the SQL injection boosted query.
 */

import semmle.javascript.heuristics.SyntacticHeuristics
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge

class SqlInjectionAtmConfig extends AtmConfig {
  SqlInjectionAtmConfig() { this = "SqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof SqlInjection::Source }

  override EndpointType getASinkEndpointType() { result instanceof SqlInjectionSinkType }
}

/** DEPRECATED: Alias for SqlInjectionAtmConfig */
deprecated class SqlInjectionATMConfig = SqlInjectionAtmConfig;

/**
 * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
 *
 * This is largely a copy of the taint tracking configuration for the standard SQL injection
 * query, except additional sinks have been added using the sink endpoint filter.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SqlInjectionATM" }

  override predicate isSource(DataFlow::Node source) { source instanceof SqlInjection::Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof SqlInjection::Sink or any(SqlInjectionAtmConfig cfg).isEffectiveSink(sink)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof SqlInjection::Sanitizer
  }
}
