import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow
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

abstract class UnsafeURLFlowConfiguration extends DataFlow::Configuration {
  bindingset[this]
  UnsafeURLFlowConfiguration() { any() }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess m |
      node.asExpr() = m.getQualifier() and m.getMethod() instanceof URLOpenConnectionMethod
    )
  }

  override predicate isBarrier(DataFlow::Node node) {
    TaintTracking::defaultTaintBarrier(node)
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    this.isAdditionalTaintStep(node1, node2) or
    TaintTracking::defaultAdditionalTaintStep(node1, node2) and
    not this.blockAdditionalTaintStep(node1, node2)
  }

  abstract predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2);

  predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    none()
  }
}

class UnsafeURLSpecFlowConfiguration extends UnsafeURLFlowConfiguration {
  UnsafeURLSpecFlowConfiguration() { this = "RequestForgery::UnsafeURLSpecFlowConfiguration" }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.specArg() and 
      node2.asExpr() = u
    )
  }

  override predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr().(AddExpr).getRightOperand() = node1.asExpr()
  }
}

class UnsafeURLHostFlowConfiguration extends UnsafeURLFlowConfiguration {
  UnsafeURLHostFlowConfiguration() { this = "RequestForgery::UnsafeURLHostFlowConfiguration" }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.hostArg() and
      node2.asExpr() = u
    )
  }

  override predicate blockAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr().(AddExpr).getLeftOperand() = node1.asExpr()
  }
}