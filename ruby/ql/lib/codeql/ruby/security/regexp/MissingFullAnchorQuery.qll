/**
 * Provides a taint tracking configuration for reasoning about
 * missing full-anchored regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `MissingFullAnchorFlow` is needed, otherwise
 * `MissingFullAnchorCustomizations` should be imported instead.
 */

import ruby
import codeql.ruby.TaintTracking
import MissingFullAnchorCustomizations::MissingFullAnchor

private module MissingFullAnchorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 7 selects sink.getCallNode (/Users/d10c/src/semmle-code/ql/ruby/ql/src/queries/security/cwe-020/MissingFullAnchor.ql@20:41:20:62), Column 9 selects sink.getRegex (/Users/d10c/src/semmle-code/ql/ruby/ql/src/queries/security/cwe-020/MissingFullAnchor.ql@20:76:20:94)
  }
}

/**
 * Taint-tracking for reasoning about missing full-anchored regular expressions.
 */
module MissingFullAnchorFlow = TaintTracking::Global<MissingFullAnchorConfig>;
