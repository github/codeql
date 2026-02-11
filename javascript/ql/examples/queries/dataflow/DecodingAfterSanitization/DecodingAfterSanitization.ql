/**
 * @name Decoding after sanitization
 * @description Tracks the return value of 'escapeHtml' into 'decodeURI', indicating
 *              an ineffective sanitization attempt.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/decoding-after-sanitization
 */

import javascript

module DecodingAfterSanitizationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallNode).getCalleeName() = "escapeHtml"
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode call |
      call.getCalleeName().matches("decodeURI%") and
      node = call.getArgument(0)
    )
  }
}

module DecodingAfterSanitizationFlow = TaintTracking::Global<DecodingAfterSanitizationConfig>;

import DecodingAfterSanitizationFlow::PathGraph

from DecodingAfterSanitizationFlow::PathNode source, DecodingAfterSanitizationFlow::PathNode sink
where DecodingAfterSanitizationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "URI decoding invalidates the HTML sanitization performed $@.",
  source.getNode(), "here"
