/**
 * @id java/trust-boundary-violation
 * @name Trust boundary violation
 * @description A user-provided value is used to set a session attribute.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @tags security
 *      external/cwe/cwe-501
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.TrustBoundaryViolationQuery

/**
 * The `setAttribute` method of the `HttpSession` interface.
 */
abstract class SessionSetAttributeMethod extends Method {
  abstract int getArgumentIndex();
}

private class PlayMvcResultAddingToSessionMethod extends SessionSetAttributeMethod {
  PlayMvcResultAddingToSessionMethod() {
    this.getDeclaringType().hasQualifiedName("play.mvc", "Result") and
    this.hasName("addingToSession")
  }

  override int getArgumentIndex() { result = [1, 2] }
}

private class Struts2SessionMapPutMethod extends SessionSetAttributeMethod {
  Struts2SessionMapPutMethod() {
    this.getDeclaringType().hasQualifiedName("org.apache.struts2.dispatcher", "SessionMap") and
    this.hasName("put")
  }

  override int getArgumentIndex() { result = 1 }
}

private class Struts2SessionSetMethod extends SessionSetAttributeMethod {
  Struts2SessionSetMethod() {
    this.getDeclaringType().hasQualifiedName("org.apache.struts2.interceptor", "SessionAware") and
    this.hasName(["setSession", "withSession"])
  }

  override int getArgumentIndex() { result = 0 }
}

module TrustBoundaryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    source.asExpr().(MethodAccess).getQualifier().getType() instanceof HttpServletRequest
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, SessionSetAttributeMethod m | m = ma.getMethod() |
      sink.asExpr() = ma.getArgument(m.getArgumentIndex())
    )
    or
    sink instanceof TrustBoundaryViolationSink
  }
}

module TrustBoundaryFlow = TaintTracking::Global<TrustBoundaryConfig>;

import TrustBoundaryFlow::PathGraph

from TrustBoundaryFlow::PathNode source, TrustBoundaryFlow::PathNode sink
where TrustBoundaryFlow::flowPath(source, sink)
select sink.getNode(), sink, source,
  "This servlet reads data from a remote source and writes it to a $@.", sink.getNode(),
  "session variable"
