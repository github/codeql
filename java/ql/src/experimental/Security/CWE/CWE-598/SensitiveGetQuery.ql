/**
 * @name Sensitive GET Query
 * @description Use of GET request method with sensitive query strings.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/sensitive-query-with-get
 * @tags security
 *       experimental
 *       external/cwe/cwe-598
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import SensitiveGetQueryFlow::PathGraph

/** A variable that holds sensitive information judging by its name. */
class SensitiveInfoExpr extends Expr {
  SensitiveInfoExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch(getCommonSensitiveInfoRegex()) and
      not v.getName().matches("token%") // exclude ^token.* since sensitive tokens are usually in the form of accessToken, authToken, ...
    )
  }
}

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private predicate isGetServletMethod(Method m) {
  isServletRequestMethod(m) and m.getName() = "doGet"
}

/** The `doGet` method of `HttpServlet`. */
class DoGetServletMethod extends Method {
  DoGetServletMethod() { isGetServletMethod(this) }
}

/** Holds if `ma` is (perhaps indirectly) called from the `doGet` method of `HttpServlet`. */
predicate isReachableFromServletDoGet(MethodCall ma) {
  ma.getEnclosingCallable() instanceof DoGetServletMethod
  or
  exists(Method pm, MethodCall pma |
    ma.getEnclosingCallable() = pm and
    pma.getMethod() = pm and
    isReachableFromServletDoGet(pma)
  )
}

/** Source of GET servlet requests. */
class RequestGetParamSource extends DataFlow::ExprNode {
  RequestGetParamSource() {
    exists(MethodCall ma |
      isRequestGetParamMethod(ma) and
      ma = this.asExpr() and
      isReachableFromServletDoGet(ma)
    )
  }
}

/** A taint configuration tracking flow from the `ServletRequest` of a GET request handler to an expression whose name suggests it holds security-sensitive data. */
module SensitiveGetQueryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RequestGetParamSource }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SensitiveInfoExpr }

  /** Holds if the node is in a servlet method other than `doGet`. */
  predicate isBarrier(DataFlow::Node node) {
    isServletRequestMethod(node.getEnclosingCallable()) and
    not isGetServletMethod(node.getEnclosingCallable())
  }
}

module SensitiveGetQueryFlow = TaintTracking::Global<SensitiveGetQueryConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, SensitiveGetQueryFlow::PathNode source,
  SensitiveGetQueryFlow::PathNode sink, string message1, DataFlow::Node sourceNode, string message2
) {
  SensitiveGetQueryFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "$@ uses the GET request method to transmit sensitive information." and
  sourceNode = source.getNode() and
  message2 = "This request"
}
