/**
 * @name Sensitive GET Query
 * @description Use of GET request method with sensitive query strings.
 * @kind path-problem
 * @id java/sensitive-query-with-get
 * @tags security
 *       external/cwe-598
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import DataFlow::PathGraph

/** Finds variables that hold sensitive information judging by their names. */
class SensitiveInfoExpr extends Expr {
  SensitiveInfoExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch(getCommonSensitiveInfoRegex())
    )
  }
}

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private predicate isGetServletMethod(Method m) { isServletMethod(m) and m.getName() = "doGet" }

/** Source of GET servlet requests. */
class GetHttpRequestSource extends DataFlow::ExprNode {
  GetHttpRequestSource() {
    exists(Method m |
      isGetServletMethod(m) and
      m.getParameter(0).getAnAccess() = this.asExpr()
    )
  }
}

/** Taint configuration of using GET requests with sensitive query strings. */
class SensitiveGetQueryConfiguration extends TaintTracking::Configuration {
  SensitiveGetQueryConfiguration() { this = "SensitiveGetQueryConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof GetHttpRequestSource }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SensitiveInfoExpr }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      isRequestGetParamMethod(ma) and pred.asExpr() = ma.getQualifier() and succ.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SensitiveGetQueryConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ uses GET request method with sensitive information.",
  source.getNode(), "sensitive query string"
