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
    (
      this.(MethodAccess).getAnArgument().(CompileTimeConstantExpr).getStringValue() = "\r\n"
      or
      this.(MethodAccess).getAnArgument().(CompileTimeConstantExpr).getStringValue() = "\n"
    )
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

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ContainsSanitizer
  }
}

from CrlfInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "CRLF injection from $@.", source.getNode(), "this user input"
