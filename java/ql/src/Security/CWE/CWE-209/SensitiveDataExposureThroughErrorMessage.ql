/**
 * @name Information exposure through an error message
 * @description Information from an error message propagates to an external user.
 *              Error messages can unintentionally reveal implementation details
 *              that are useful to an attacker for developing a subsequent exploit.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id java/error-message-exposure
 * @tags security
 *       external/cwe/cwe-209
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.SensitiveDataExposureThroughErrorMessageQuery

from Expr externalExpr, Expr errorInformation
where
  getMessageFlowsExternally(DataFlow::exprNode(externalExpr), DataFlow::exprNode(errorInformation))
select externalExpr, "$@ can be exposed to an external user.", errorInformation, "Error information"
