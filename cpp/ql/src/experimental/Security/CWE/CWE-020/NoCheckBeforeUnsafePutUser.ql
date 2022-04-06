/**
 * @name Linux kernel no check before unsafe_put_user vulnerability detection
 * @description unsafe_put_user which is used to write data to user-mode
 *              memory is widely used in Linux kernel codebase,  but if
 *              there is no security check for user-mode pointer used as
 *              parameter of unsafe_put_user, attacker can exploit the issue
 *              to obtain root privilege. CVE-2017-5123 is quite a good
 *              example for your information.
 * @kind problem
 * @id cpp/linux-kernel-no-check-before-unsafe-put-user
 * @problem.severity warning
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-020
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow

class WriteAccessCheckMacro extends Macro {
  VariableAccess va;

  WriteAccessCheckMacro() {
    this.getName() = ["user_write_access_begin", "user_access_begin", "access_ok"] and
    va.getEnclosingElement() = this.getAnInvocation().getAnExpandedElement()
  }

  VariableAccess getArgument() { result = va }
}

class UnSafePutUserMacro extends Macro {
  PointerDereferenceExpr writeUserPtr;

  UnSafePutUserMacro() {
    this.getName() = "unsafe_put_user" and
    writeUserPtr.getEnclosingElement() = this.getAnInvocation().getAnExpandedElement()
  }

  Expr getUserModePtr() {
    result = writeUserPtr.getOperand().(AddressOfExpr).getOperand().(FieldAccess).getQualifier() or
    result = writeUserPtr.getOperand()
  }
}

class ExploitableUserModePtrParam extends Parameter {
  ExploitableUserModePtrParam() {
    not exists(WriteAccessCheckMacro writeAccessCheck |
      DataFlow::localFlow(DataFlow::parameterNode(this),
        DataFlow::exprNode(writeAccessCheck.getArgument()))
    ) and
    exists(UnSafePutUserMacro unsafePutUser |
      DataFlow::localFlow(DataFlow::parameterNode(this),
        DataFlow::exprNode(unsafePutUser.getUserModePtr()))
    )
  }
}

from ExploitableUserModePtrParam p
select p, "unsafe_put_user write user-mode pointer $@ without check.", p, p.toString()
