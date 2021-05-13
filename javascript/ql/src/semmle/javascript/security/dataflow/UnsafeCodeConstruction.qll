/**
 * Provides a taint-tracking configuration for reasoning about code
 * constructed from libary input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeCodeConstruction::Configuration` is needed, otherwise
 * `UnsafeCodeConstructionCustomizations` should be imported instead.
 */

import javascript

/**
 * Classes and predicates for the code constructed from library input query.
 */
module UnsafeCodeConstruction {
  private import semmle.javascript.security.dataflow.CodeInjectionCustomizations::CodeInjection as CodeInjection
  import UnsafeCodeConstructionCustomizations::UnsafeCodeConstruction

  /**
   * A taint-tracking configuration for reasoning about unsafe code constructed from library input.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "UnsafeCodeConstruction" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof CodeInjection::Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
      // HTML sanitizers are insufficient protection against code injection
      src = trg.(HtmlSanitizerCall).getInput()
      or
      DataFlow::localFieldStep(src, trg)
    }

    // override to require that there is a path without unmatched return steps
    override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
      super.hasFlowPath(source, sink) and
      DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
    }
  }
}
