/**
 * @name Server-side request forgery
 * @description Making a network request with user-controlled data in the URL allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id rust/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

private import rust
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.security.RequestForgeryExtensions

/**
 * A taint-tracking configuration for detecting request forgery vulnerabilities.
 */
module RequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RequestForgery::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgery::Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof RequestForgery::Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module RequestForgeryFlow = TaintTracking::Global<RequestForgeryConfig>;

import RequestForgeryFlow::PathGraph

from RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink
where RequestForgeryFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "The URL of this request depends on a $@.", source.getNode(),
  "user-provided value"
