/**
 * @name Authorization bypass due to incorrect usage of PAM
 * @description Using only the `pam_authenticate` call to check the validity of a login can lead to a authorization bypass.
 * @kind problem
 * @problem.severity warning
 * @id py/pam-auth-bypass
 * @tags security
 *       external/cwe/cwe-285
 */

import python
import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.TaintTracking

private class LibPam extends API::Node {
  LibPam() {
    exists(
      API::Node cdll, API::Node find_library, API::Node libpam, API::CallNode cdll_call,
      API::CallNode find_lib_call, StrConst str
    |
      API::moduleImport("ctypes").getMember("CDLL") = cdll and
      find_library = API::moduleImport("ctypes.util").getMember("find_library") and
      cdll_call = cdll.getACall() and
      find_lib_call = find_library.getACall() and
      DataFlow::localFlow(DataFlow::exprNode(str), find_lib_call.getArg(0)) and
      str.getText() = "pam" and
      cdll_call.getArg(0) = find_lib_call and
      libpam = cdll_call.getReturn()
    |
      libpam = this
    )
  }

  override string toString() { result = "libpam" }
}

class PamAuthCall extends API::Node {
  PamAuthCall() { exists(LibPam pam | pam.getMember("pam_authenticate") = this) }

  override string toString() { result = "pam_authenticate" }
}

class PamActMgt extends API::Node {
  PamActMgt() { exists(LibPam pam | pam.getMember("pam_acct_mgmt") = this) }

  override string toString() { result = "pam_acct_mgmt" }
}

from PamAuthCall p, API::CallNode u, Expr handle
where
  u = p.getACall() and
  handle = u.asExpr().(Call).getArg(0) and
  not exists(PamActMgt pam |
    DataFlow::localFlow(DataFlow::exprNode(handle),
      DataFlow::exprNode(pam.getACall().asExpr().(Call).getArg(0)))
  )
select u, "This PAM authentication call may be lead to an authorization bypass."
