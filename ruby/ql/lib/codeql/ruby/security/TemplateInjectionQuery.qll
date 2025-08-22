/**
 * Provides default sources, sinks and sanitizers for detecting
 * Server Side Template Injections, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import TemplateInjectionCustomizations::TemplateInjection

private module TemplateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting Server Side Template Injections vulnerabilities.
 */
module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionConfig>;
