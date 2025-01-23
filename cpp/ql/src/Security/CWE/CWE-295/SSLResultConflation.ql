/**
 * @name Certificate result conflation
 * @description Only accept SSL certificates that pass certificate verification.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @id cpp/certificate-result-conflation
 * @tags security
 *       external/cwe/cwe-295
 */

import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * A call to `SSL_get_verify_result`.
 */
class SslGetVerifyResultCall extends FunctionCall {
  SslGetVerifyResultCall() { this.getTarget().getName() = "SSL_get_verify_result" }
}

/**
 * Data flow from a call to `SSL_get_verify_result` to a guard condition
 * that references the result.
 */
module VerifyResultConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SslGetVerifyResultCall }

  predicate isSink(DataFlow::Node sink) {
    exists(GuardCondition guard | guard.getAChild*() = sink.asExpr())
  }

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/Security/CWE/CWE-295/SSLResultConflation.ql:48: Column 1 does not select a source or sink originating from the flow call on line 42
    // ql/src/Security/CWE/CWE-295/SSLResultConflation.ql:48: Column 1 does not select a source or sink originating from the flow call on line 43
    none()
  }
}

module VerifyResult = DataFlow::Global<VerifyResultConfig>;

from
  DataFlow::Node source, DataFlow::Node sink1, DataFlow::Node sink2, GuardCondition guard, Expr c1,
  Expr c2, boolean testIsTrue
where
  VerifyResult::flow(source, sink1) and
  VerifyResult::flow(source, sink2) and
  guard.comparesEq(sink1.asExpr(), c1, 0, false, testIsTrue) and // (value != c1) => testIsTrue
  guard.comparesEq(sink2.asExpr(), c2, 0, false, testIsTrue) and // (value != c2) => testIsTrue
  c1.getValue().toInt() = 0 and
  c2.getValue().toInt() != 0
select guard, "This expression conflates OK and non-OK results from $@.", source, source.toString()
