/**
 * @name HTTP response splitting
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/http-response-splitting
 * @tags security
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting
import DataFlow::PathGraph

class ResponseSplittingConfig extends TaintTracking::Configuration {
  ResponseSplittingConfig() { this = "ResponseSplittingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not source instanceof SafeHeaderSplittingSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    exists(MethodAccess ma, string methodName, CompileTimeConstantExpr target |
      node.asExpr() = ma and
      ma.getMethod().hasQualifiedName("java.lang", "String", methodName) and
      target = ma.getArgument(0) and
      (
        methodName = "replace" and target.getIntValue() = [10, 13] // 10 == "\n", 13 == "\r"
        or
        methodName = "replaceAll" and
        target.getStringValue().regexpMatch(".*([\n\r]|\\[\\^[^\\]\r\n]*\\]).*")
      )
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ResponseSplittingConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This header depends on a $@, which may cause a response-splitting vulnerability.",
  source.getNode(), "user-provided value"
