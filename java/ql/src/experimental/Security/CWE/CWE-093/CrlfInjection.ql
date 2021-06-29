/**
 * @name Crlf Injection
 * @description Through CRLF injection, attackers can maliciously exploit CRLF vulnerabilities
 *              to manipulate the functionality of web applications.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/crlf-injection
 * @tags security
 *       external/cwe/cwe-093
 */

import java
import CrlfInjectionLib
import DataFlow::PathGraph
import semmle.code.java.dataflow.FlowSources

private class ContainsSanitizer extends DataFlow::BarrierGuard {
  ContainsSanitizer() {
    this.(MethodAccess).getMethod().hasName("contains") and
    this.(MethodAccess).getMethod().getNumberOfParameters() = 1 and
    this.(MethodAccess).getMethod().getDeclaringType() instanceof TypeString and
    this.(MethodAccess).getAnArgument().(CompileTimeConstantExpr).getStringValue() = ["\r\n", "\n"]
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and branch = false
  }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used in emails or logs.
 */
class CrlfInjectionConfiguration extends TaintTracking::Configuration {
  CrlfInjectionConfiguration() { this = "Crlf Injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CrlfInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m instanceof ReplaceMethod and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ContainsSanitizer
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m instanceof ReplaceMethod and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = ["\r\n", "\n"] and
      ma.getQualifier() = node.asExpr()
    )
    or
    node.getType() instanceof BoxedType
    or
    node.getType() instanceof PrimitiveType
  }
}

from CrlfInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "CRLF injection from $@.", source.getNode(), "this user input"
