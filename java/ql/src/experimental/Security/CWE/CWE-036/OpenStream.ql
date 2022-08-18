/**
 * @name openStream called on URLs created from remote source
 * @description Calling openStream on URLs created from remote source
 *              can lead to local file disclosure.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/openstream-called-on-tainted-url
 * @tags security
 *       external/cwe/cwe-036
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
import DataFlow::PathGraph

class UrlConstructor extends ClassInstanceExpr {
  UrlConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr stringArg() {
    // Query only in URL's that were constructed by calling the single parameter string constructor.
    this.getConstructor().getNumberOfParameters() = 1 and
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    result = this.getArgument(0)
  }
}

class RemoteUrlToOpenStreamFlowConfig extends TaintTracking::Configuration {
  RemoteUrlToOpenStreamFlowConfig() { this = "OpenStream::RemoteURLToOpenStreamFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      sink.asExpr() = m.getQualifier() and m.getMethod() instanceof UrlOpenStreamMethod
    )
    or
    sinkNode(sink, "url-open-stream")
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(UrlConstructor u |
      node1.asExpr() = u.stringArg() and
      node2.asExpr() = u
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess call
where
  sink.getNode().asExpr() = call.getQualifier() and
  any(RemoteUrlToOpenStreamFlowConfig c).hasFlowPath(source, sink)
select call, source, sink,
  "URL on which openStream is called may have been constructed from remote source"
