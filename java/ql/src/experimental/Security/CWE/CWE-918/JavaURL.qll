import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Networking

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr specArg() {
    // URL(String spec)
    this.getConstructor().getNumberOfParameters() = 1 and
    result = this.getArgument(0)
    or
    // URL(URL context, String spec)
    this.getConstructor().getNumberOfParameters() = 2 and
    this.getArgument(0).getType() instanceof TypeUrl and
    this.getArgument(1).getType() instanceof TypeString and
    result = this.getArgument(1)
  }

  Expr hostArg() {
    // URL(String protocol, String host, int port, String file)
    this.getConstructor().getNumberOfParameters() = 4 and
    this.getArgument(0).getType() instanceof TypeString and
    this.getArgument(1).getType() instanceof TypeString and
    this.getArgument(2).getType() instanceof NumericType and
    this.getArgument(3).getType() instanceof TypeString and
    result = this.getArgument(1)
    or
    // URL(String protocol, String host, String file)
    this.getConstructor().getNumberOfParameters() = 3 and
    this.getArgument(0).getType() instanceof TypeString and
    this.getArgument(1).getType() instanceof TypeString and
    this.getArgument(2).getType() instanceof TypeString and
    result = this.getArgument(1)
  }
}

class URLOpenConnectionMethod extends Method {
  URLOpenConnectionMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

predicate unsafeURLHostFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(URLConstructor u |
    node1.asExpr() = u.hostArg() and
    node2.asExpr() = u
  )
}

predicate unsafeURLSpecFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(URLConstructor u |
    node1.asExpr() = u.specArg() and
    node2.asExpr() = u
  )
}

predicate isUnsafeURLFlowSink(DataFlow::Node node) {
  exists(MethodAccess m |
    node.asExpr() = m.getQualifier() and m.getMethod() instanceof URLOpenConnectionMethod
  )
}
