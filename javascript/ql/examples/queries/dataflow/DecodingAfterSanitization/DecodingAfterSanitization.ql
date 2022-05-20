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
import DataFlow
import DataFlow::PathGraph

class DecodingAfterSanitization extends TaintTracking::Configuration {
  DecodingAfterSanitization() { this = "DecodingAfterSanitization" }

  override predicate isSource(Node node) { node.(CallNode).getCalleeName() = "escapeHtml" }

  override predicate isSink(Node node) {
    exists(CallNode call |
      call.getCalleeName().matches("decodeURI%") and
      node = call.getArgument(0)
    )
  }
}

from DecodingAfterSanitization cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "URI decoding invalidates the HTML sanitization performed $@.",
  source.getNode(), "here"
