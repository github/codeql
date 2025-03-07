/**
 * Provides a taint-tracking configuration for detecting regular expression
 * injection vulnerabilities.
 */

private import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.Concepts
private import codeql.rust.security.regex.RegexInjectionExtensions

/**
 * A taint configuration for detecting regular expression injection vulnerabilities.
 */
module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof RegexInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(RegexInjectionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a regular expression sink.
 */
module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;
