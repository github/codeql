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
import semmle.code.java.frameworks.Servlets
import DataFlow::PathGraph

private class StartsWithSanitizer extends DataFlow::BarrierGuard {
  StartsWithSanitizer() {
    this.(MethodAccess).getMethod().hasName("startsWith") and
    this.(MethodAccess).getMethod().getDeclaringType() instanceof TypeString and
    this.(MethodAccess).getMethod().getNumberOfParameters() = 1
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and branch = true
  }
}

class UnsafeUrlForwardFlowConfig extends TaintTracking::Configuration {
  UnsafeUrlForwardFlowConfig() { this = "UnsafeUrlForwardFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not exists(MethodAccess ma, Method m | ma.getMethod() = m |
      (
        m instanceof HttpServletRequestGetRequestURIMethod or
        m instanceof HttpServletRequestGetRequestURLMethod or
        m instanceof HttpServletRequestGetPathMethod
      ) and
      ma = source.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeUrlForwardSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StartsWithSanitizer
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof UnsafeUrlForwardSanitizer }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
