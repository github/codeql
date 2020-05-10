import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr specArg() {
    // URL(String spec)
    (
      this.getConstructor().getNumberOfParameters() = 1 and
      result = this.getArgument(0)
    ) or
    // URL(URL context, String spec)
    (
      this.getConstructor().getNumberOfParameters() = 2 and
      this.getArgument(0).getType() instanceof TypeUrl and
      this.getArgument(1).getType() instanceof TypeString and
      result = this.getArgument(1)
    )
  }

  Expr hostArg() {
    // URL(String protocol, String host, int port, String file)
    (
      this.getConstructor().getNumberOfParameters() = 4 and
      this.getArgument(0).getType() instanceof TypeString and
      this.getArgument(1).getType() instanceof TypeString and
      this.getArgument(2).getType() instanceof NumericType and
      this.getArgument(3).getType() instanceof TypeString and
      result = this.getArgument(1)
    ) or 
    // URL(String protocol, String host, String file)
    (
      this.getConstructor().getNumberOfParameters() = 3 and
      this.getArgument(0).getType() instanceof TypeString and
      this.getArgument(1).getType() instanceof TypeString and
      this.getArgument(2).getType() instanceof TypeString and
      result = this.getArgument(1)
    )
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
      (
        node1.asExpr() = u.specArg() or 
        node1.asExpr() = u.hostArg()
      ) and
      node2.asExpr() = u
    )
  }
}