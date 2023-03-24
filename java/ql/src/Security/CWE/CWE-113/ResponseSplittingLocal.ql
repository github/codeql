/**
 * @name HTTP response splitting from local source
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 6.1
 * @precision medium
 * @id java/http-response-splitting-local
 * @tags security
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting

module ResponseSplittingLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType
  }
}

module ResponseSplitting = TaintTracking::Global<ResponseSplittingLocalConfig>;

import ResponseSplitting::PathGraph

from ResponseSplitting::PathNode source, ResponseSplitting::PathNode sink
where ResponseSplitting::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This header depends on a $@, which may cause a response-splitting vulnerability.",
  source.getNode(), "user-provided value"
