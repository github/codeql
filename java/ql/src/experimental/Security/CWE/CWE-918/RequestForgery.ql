import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr stringArg() {
    // Query only in URL's that were constructed by calling the single parameter string constructor.
    this.getConstructor().getNumberOfParameters() = 1 and
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    result = this.getArgument(0)
  }
}

class URLOpenConnectionMethod extends Method {
  URLOpenConnectionMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

class RemoteURLToOpenConnectionFlowConfig extends TaintTracking::Configuration {
  RemoteURLToOpenConnectionFlowConfig() { this = "OpenConnection::RemoteURLToOpenConnectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      sink.asExpr() = m.getQualifier() and m.getMethod() instanceof URLOpenConnectionMethod
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
  any(RemoteURLToOpenConnectionFlowConfig c).hasFlowPath(source, sink)
select call, source, sink,
  "URL on which openConnection is called may have been constructed from remote source"
