/**
 * @name HTTP response splitting from local source
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/http-response-splitting-local
 * @tags security
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting
import DataFlow::PathGraph

class ResponseSplittingLocalConfig extends TaintTracking::Configuration {
  ResponseSplittingLocalConfig() { this = "ResponseSplittingLocalConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ResponseSplittingLocalConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Response-splitting vulnerability due to this $@.",
  source.getNode(), "user-provided value"
