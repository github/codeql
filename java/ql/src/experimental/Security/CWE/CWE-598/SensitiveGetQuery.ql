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
import semmle.code.java.frameworks.Servlets
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

/** GET servlet method of `javax.servlet.http.Servlet` and subtypes. */
private predicate isGetServletMethod(Callable c) {
  c.getDeclaringType() instanceof ServletClass and
  c.getNumberOfParameters() = 2 and
  c.getParameter(1).getType() instanceof ServletResponse and
  c.getName() = "doGet"
}

/** Sink of GET servlet requests. */
class GetServletMethodSink extends DataFlow::ExprNode {
  GetServletMethodSink() {
    exists(Method m, MethodAccess ma | ma.getMethod() = m |
      isGetServletMethod(ma.getEnclosingCallable()) and
      ma.getAnArgument() = this.getExpr()
    )
  }
}

/** Taint configuration of using GET requests with sensitive query strings. */
class SensitiveGetQueryConfiguration extends TaintTracking::Configuration {
  SensitiveGetQueryConfiguration() { this = "SensitiveGetQueryConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SensitiveInfoExpr
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GetServletMethodSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SensitiveGetQueryConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ uses GET request method with sensitive information.",
  source.getNode(), "sensitive query string"
