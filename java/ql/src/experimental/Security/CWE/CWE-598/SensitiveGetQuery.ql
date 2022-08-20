/**
 * @name Sensitive GET Query
 * @description Use of GET request method with sensitive query strings.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/sensitive-query-with-get
 * @tags security
 *       external/cwe/cwe-598
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import DataFlow::PathGraph

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
predicate isReachableFromServletDoGet(MethodAccess ma) {
  ma.getEnclosingCallable() instanceof DoGetServletMethod
  or
  exists(Method pm, MethodAccess pma |
    ma.getEnclosingCallable() = pm and
    pma.getMethod() = pm and
    isReachableFromServletDoGet(pma)
  )
}

/** Source of GET servlet requests. */
class RequestGetParamSource extends DataFlow::ExprNode {
  RequestGetParamSource() {
    exists(MethodAccess ma |
      isRequestGetParamMethod(ma) and
      ma = this.asExpr() and
      isReachableFromServletDoGet(ma)
    )
  }
}

/** A taint configuration tracking flow from the `ServletRequest` of a GET request handler to an expression whose name suggests it holds security-sensitive data. */
class SensitiveGetQueryConfiguration extends TaintTracking::Configuration {
  SensitiveGetQueryConfiguration() { this = "SensitiveGetQueryConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RequestGetParamSource }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SensitiveInfoExpr }

  /** Holds if the node is in a servlet method other than `doGet`. */
  override predicate isSanitizer(DataFlow::Node node) {
    isServletRequestMethod(node.getEnclosingCallable()) and
    not isGetServletMethod(node.getEnclosingCallable())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SensitiveGetQueryConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ uses the GET request method to transmit sensitive information.", source.getNode(),
  "This request"
