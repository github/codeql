/**
 * For internal use only.
 *
 * Defines shared code used by the SQL injection boosted query.
 */

import semmle.javascript.heuristics.SyntacticHeuristics
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge
import StandardEndpointFilters as StandardEndpointFilters

/**
 * This module provides logic to filter candidate sinks to those which are likely SQL injection
 * sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import SQL

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
    or
    exists(DataFlow::CallNode call | sinkCandidate = call.getAnArgument() |
      // prepared statements for SQL
      any(DataFlow::CallNode cn | cn.getCalleeName() = "prepare")
          .getAMethodCall("run")
          .getAnArgument() = sinkCandidate and
      result = "prepared SQL statement"
      or
      sinkCandidate instanceof DataFlow::ArrayCreationNode and
      result = "array creation"
      or
      // UI is unrelated to SQL
      call.getCalleeName().regexpMatch("(?i).*(render|html).*") and
      result = "HTML / rendering"
    )
    or
    // Require SQL injection sink candidates to be (a) arguments to external library calls
    // (possibly indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are copied from the `HeuristicSqlInjectionSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(sinkCandidate) and
    not (
      isAssignedToOrConcatenatedWith(sinkCandidate, "(?i)(sql|query)") or
      isArgTo(sinkCandidate, "(?i)(query)") or
      isConcatenatedWithString(sinkCandidate,
        "(?s).*(ALTER|COUNT|CREATE|DATABASE|DELETE|DISTINCT|DROP|FROM|GROUP|INSERT|INTO|LIMIT|ORDER|SELECT|TABLE|UPDATE|WHERE).*")
    ) and
    result = "not an argument to a likely external library call or a heuristic sink"
  }
}

class SqlInjectionAtmConfig extends AtmConfig {
  SqlInjectionAtmConfig() { this = "SqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof SqlInjection::Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof SqlInjection::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

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
