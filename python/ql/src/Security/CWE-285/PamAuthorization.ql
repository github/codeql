/**
 * @name PAM authorization bypass due to incorrect usage
 * @description Not using `pam_acct_mgmt` after `pam_authenticate` to check the validity of a login can lead to authorization bypass.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id py/pam-auth-bypass
 * @tags security
 *       external/cwe/cwe-285
 */

import python
import semmle.python.ApiGraphs
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.TaintTracking

API::Node libPam() {
  exists(API::CallNode findLibCall, API::CallNode cdllCall |
    findLibCall = API::moduleImport("ctypes").getMember("util").getMember("find_library").getACall() and
    findLibCall.getParameter(0).getAValueReachingSink().asExpr().(StrConst).getText() = "pam" and
    cdllCall = API::moduleImport("ctypes").getMember("CDLL").getACall() and
    cdllCall.getParameter(0).getAValueReachingSink() = findLibCall
  |
    result = cdllCall.getReturn()
  )
}

from API::CallNode authenticateCall, DataFlow::Node handle
where
  authenticateCall = libPam().getMember("pam_authenticate").getACall() and
  handle = authenticateCall.getArg(0) and
  not exists(API::CallNode acctMgmtCall |
    acctMgmtCall = libPam().getMember("pam_acct_mgmt").getACall() and
    DataFlow::localFlow(handle, acctMgmtCall.getArg(0))
  )
select authenticateCall,
  "This PAM authentication call may lead to an authorization bypass, since 'pam_acct_mgmt' is not called afterwards."
