/**
 * @name Calling openStream on URLs created from remote source can lead to file disclosure
 * @description If openStream is called on a java.net.URL, that was created from a remote source
 *              an attacker can try to pass absolute URLs starting with file:// or jar:// to access
 *              local resources in addition to remote ones.
 * @kind path-problem
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URL" }

  Expr stringArg() {
    // Query only in URL's that were constructed by calling the single parameter string constructor.
    if
      this.getConstructor().getNumberOfParameters() = 1 and
      this.getConstructor().getParameter(0).getType().getName() = "String"
    then result = this.getArgument(0)
    else none()
  }
}

class URLOpenStreamMethod extends Method {
  URLOpenStreamMethod() {
    this.getDeclaringType().getQualifiedName() = "java.net.URL" and
    this.getName() = "openStream"
  }
}

class RemoteURLToOpenStreamFlowConfig extends TaintTracking::Configuration {
  RemoteURLToOpenStreamFlowConfig() { this = "OpenStream::RemoteURLToOpenStreamFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      sink.asExpr() = m.getQualifier() and m.getMethod() instanceof URLOpenStreamMethod
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.stringArg() and
      node2.asExpr() = u
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess call
where
  sink.getNode().asExpr() = call.getQualifier() and
  any(RemoteURLToOpenStreamFlowConfig c).hasFlowPath(source, sink)
select call, source, sink,
  "URL on which openStream is called may have been constructed from remote source"
