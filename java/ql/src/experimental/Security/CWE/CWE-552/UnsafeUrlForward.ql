/**
 * @name Unsafe url forward from remote source
 * @description URL forward based on unvalidated user-input
 *              may cause file information disclosure.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-url-forward
 * @tags security
 *       external/cwe-552
 */

import java
import UnsafeUrlForward
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class UnsafeUrlForwardFlowConfig extends TaintTracking::Configuration {
  UnsafeUrlForwardFlowConfig() { this = "UnsafeUrlForwardFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not exists(MethodAccess ma |
      ma.getMethod().getName() in ["getRequestURI", "getRequestURL", "getPathInfo"] and
      ma.getMethod()
          .getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("javax.servlet.http", "HttpServletRequest")
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeUrlForwardSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof BoxedType
    or
    node.getType() instanceof PrimitiveType
    or
    exists(AddExpr ae |
      ae.getRightOperand() = node.asExpr() and
      (
        not ae.getLeftOperand().(CompileTimeConstantExpr).getStringValue().matches("/WEB-INF/%") and
        not ae.getLeftOperand().(CompileTimeConstantExpr).getStringValue() = "forward:"
      )
    )
    or
    exists(MethodAccess ma, int i |
      ma.getMethod().hasName("format") and
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "redirect:" and
      ma.getArgument(i) = node.asExpr() and
      i != 0
    )
    or
    exists(StringBuilderAppendCall ma1, StringBuilderAppendCall ma2 |
      DataFlow2::localExprFlow(ma1.getQualifier(), ma2.getQualifier()) and
      ma1.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "redirect:" and
      ma2.getArgument(0) = node.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
