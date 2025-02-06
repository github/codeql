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
deprecated import experimental.semmle.code.java.security.SpringUrlRedirect
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
deprecated import SpringUrlRedirectFlow::PathGraph

private predicate startsWithSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodCall).getMethod().hasName("startsWith") and
  g.(MethodCall).getMethod().getDeclaringType() instanceof TypeString and
  g.(MethodCall).getMethod().getNumberOfParameters() = 1 and
  e = g.(MethodCall).getQualifier() and
  branch = true
}

deprecated module SpringUrlRedirectFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

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
    exists(MethodCall ma, int index |
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

deprecated module SpringUrlRedirectFlow = TaintTracking::Global<SpringUrlRedirectFlowConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, SpringUrlRedirectFlow::PathNode source,
  SpringUrlRedirectFlow::PathNode sink, string message1, DataFlow::Node sourceNode, string message2
) {
  SpringUrlRedirectFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Potentially untrusted URL redirection due to $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
