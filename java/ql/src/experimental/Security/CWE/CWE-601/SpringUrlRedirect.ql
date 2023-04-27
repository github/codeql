/**
 * @name Spring url redirection from remote source
 * @description Spring url redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/spring-unvalidated-url-redirection
 * @tags security
 *       experimental
 *       external/cwe/cwe-601
 */

import java
import experimental.semmle.code.java.security.SpringUrlRedirect
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
import SpringUrlRedirectFlow::PathGraph

private predicate startsWithSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodAccess).getMethod().hasName("startsWith") and
  g.(MethodAccess).getMethod().getDeclaringType() instanceof TypeString and
  g.(MethodAccess).getMethod().getNumberOfParameters() = 1 and
  e = g.(MethodAccess).getQualifier() and
  branch = true
}

module SpringUrlRedirectFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SpringUrlRedirectSink }

  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    springUrlRedirectTaintStep(fromNode, toNode)
  }

  predicate isBarrier(DataFlow::Node node) {
    // Exclude the case where the left side of the concatenated string is not `redirect:`.
    // E.g: `String url = "/path?token=" + request.getParameter("token");`
    // Note this is quite a broad sanitizer (it will also sanitize the right-hand side of `url = "http://" + request.getParameter("token")`);
    // Consider making this stricter in future.
    exists(AddExpr ae |
      ae.getRightOperand() = node.asExpr() and
      not ae instanceof RedirectBuilderExpr
    )
    or
    exists(MethodAccess ma, int index |
      ma.getMethod().hasName("format") and
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getArgument(index) = node.asExpr() and
      (
        index != 0 and
        not ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().regexpMatch("^%s.*")
      )
    )
    or
    nonLocationHeaderSanitizer(node)
    or
    node = DataFlow::BarrierGuard<startsWithSanitizer/3>::getABarrierNode()
  }
}

module SpringUrlRedirectFlow = TaintTracking::Global<SpringUrlRedirectFlowConfig>;

from SpringUrlRedirectFlow::PathNode source, SpringUrlRedirectFlow::PathNode sink
where SpringUrlRedirectFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL redirection due to $@.",
  source.getNode(), "user-provided value"
