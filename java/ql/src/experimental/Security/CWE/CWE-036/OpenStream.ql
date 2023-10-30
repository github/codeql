/**
 * @name openStream called on URLs created from remote source
 * @description Calling openStream on URLs created from remote source
 *              can lead to local file disclosure.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/openstream-called-on-tainted-url
 * @tags security
 *       experimental
 *       external/cwe/cwe-036
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
import RemoteUrlToOpenStreamFlow::PathGraph

private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "openstream-called-on-tainted-url" }
}

class UrlConstructor extends ClassInstanceExpr {
  UrlConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr stringArg() {
    // Query only in URL's that were constructed by calling the single parameter string constructor.
    this.getConstructor().getNumberOfParameters() = 1 and
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    result = this.getArgument(0)
  }
}

module RemoteUrlToOpenStreamFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall m |
      sink.asExpr() = m.getQualifier() and m.getMethod() instanceof UrlOpenStreamMethod
    )
    or
    sinkNode(sink, "url-open-stream")
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(UrlConstructor u |
      node1.asExpr() = u.stringArg() and
      node2.asExpr() = u
    )
  }
}

module RemoteUrlToOpenStreamFlow = TaintTracking::Global<RemoteUrlToOpenStreamFlowConfig>;

from
  RemoteUrlToOpenStreamFlow::PathNode source, RemoteUrlToOpenStreamFlow::PathNode sink,
  MethodCall call
where
  sink.getNode().asExpr() = call.getQualifier() and
  RemoteUrlToOpenStreamFlow::flowPath(source, sink)
select call, source, sink,
  "URL on which openStream is called may have been constructed from remote source."
