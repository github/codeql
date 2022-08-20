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
import semmle.code.cpp.dataflow.DataFlow

/**
 * A call to `SSL_get_verify_result`.
 */
class SSLGetVerifyResultCall extends FunctionCall {
  SSLGetVerifyResultCall() { getTarget().getName() = "SSL_get_verify_result" }
}

/**
 * Data flow from a call to `SSL_get_verify_result` to a guard condition
 * that references the result.
 */
class VerifyResultConfig extends DataFlow::Configuration {
  VerifyResultConfig() { this = "VerifyResultConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SSLGetVerifyResultCall
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(GuardCondition guard | guard.getAChild*() = sink.asExpr())
  }
}

from
  VerifyResultConfig config, DataFlow::Node source, DataFlow::Node sink1, DataFlow::Node sink2,
  GuardCondition guard, Expr c1, Expr c2, boolean testIsTrue
where
  config.hasFlow(source, sink1) and
  config.hasFlow(source, sink2) and
  guard.comparesEq(sink1.asExpr(), c1, 0, false, testIsTrue) and // (value != c1) => testIsTrue
  guard.comparesEq(sink2.asExpr(), c2, 0, false, testIsTrue) and // (value != c2) => testIsTrue
  c1.getValue().toInt() = 0 and
  c2.getValue().toInt() != 0
select guard, "This expression conflates OK and non-OK results from $@.", source, source.toString()
