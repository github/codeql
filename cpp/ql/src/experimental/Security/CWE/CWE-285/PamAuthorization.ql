/**
 * @name PAM Authorization bypass
 * @description Only using `pam_authenticate` call to authenticate users can lead to authorization vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @id cpp/pam-auth-bypass
 * @tags security
 *       experimental
 *       external/cwe/cwe-285
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

private class PamAuthCall extends FunctionCall {
  PamAuthCall() {
    exists(Function f | f.hasName("pam_authenticate") | f.getACallToThisFunction() = this)
  }
}

private class PamActMgmtCall extends FunctionCall {
  PamActMgmtCall() {
    exists(Function f | f.hasName("pam_acct_mgmt") | f.getACallToThisFunction() = this)
  }
}

from PamAuthCall pa, Expr handle
where
  pa.getArgument(0) = handle and
  not exists(PamActMgmtCall pac |
    globalValueNumber(handle) = globalValueNumber(pac.getArgument(0)) or
    DataFlow::localExprFlow(handle, pac.getArgument(0))
  )
select pa, "This PAM authentication call may be lead to an authorization bypass."
