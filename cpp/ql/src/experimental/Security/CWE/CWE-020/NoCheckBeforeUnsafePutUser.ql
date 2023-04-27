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
 *       experimental
 *       external/cwe/cwe-020
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * A Linux system call.
 */
class SystemCallFunction extends Function {
  SystemCallFunction() {
    exists(MacroInvocation m |
      m.getMacro().getName().matches("SYSCALL\\_DEFINE%") and
      this = m.getEnclosingFunction()
    )
  }
}

/**
 * A value that comes from a Linux system call (sources).
 */
class SystemCallSource extends DataFlow::Node {
  SystemCallSource() {
    exists(FunctionCall fc |
      fc.getTarget() instanceof SystemCallFunction and
      (
        this.asDefiningArgument() = fc.getAnArgument().getAChild*() or
        this.asExpr() = fc
      )
    )
  }
}

/**
 * Macros used to check the value (barriers).
 */
class WriteAccessCheckMacro extends Macro {
  VariableAccess va;

  WriteAccessCheckMacro() {
    this.getName() = ["user_write_access_begin", "user_access_begin", "access_ok"] and
    va.getEnclosingElement() = this.getAnInvocation().getAnExpandedElement()
  }

  VariableAccess getArgument() { result = va }
}

/**
 * The `unsafe_put_user` macro and its uses (sinks).
 */
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

class ExploitableUserModePtrParam extends SystemCallSource {
  ExploitableUserModePtrParam() {
    exists(UnSafePutUserMacro unsafePutUser |
      DataFlow::localFlow(this, DataFlow::exprNode(unsafePutUser.getUserModePtr()))
    ) and
    not exists(WriteAccessCheckMacro writeAccessCheck |
      DataFlow::localFlow(this, DataFlow::exprNode(writeAccessCheck.getArgument()))
    )
  }
}

from ExploitableUserModePtrParam p
select p, "This 'unsafe_put_user' writes a user-mode pointer without a security check."
