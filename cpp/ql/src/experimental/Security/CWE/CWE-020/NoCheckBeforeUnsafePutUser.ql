/**
 * @name Linux kernel no check before unsafe_put_user vulnerability detection
 * @description unsafe_put_user which is used to write data to user-mode
 *              memory is widely used in Linux kernel codebase,  but if
 *              there is no security check for user-mode pointer used as
 *              parameter of unsafe_put_user, attacker can exploit the issue
 *              to obtain root privilege. CVE-2017-5123 is quite a good
 *              example for your information.
 * @kind path-problem
 * @id cpp/linux-kernel-no-check-before-unsafe-put-user
 * @problem.severity warning
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-020
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

/*
 *  Linux SysCall is defiend by marco SYSCALL_DEFINE
 *  so I think this may be a generic way to model linux
 *  syscall
 */

class SysCallFunction extends Function {
  SysCallFunction() {
    exists(MacroInvocation m |
      m.getMacroName().regexpMatch("SYSCALL_DEFINE[0-9]+") and
      this = m.getStmt().getEnclosingFunction()
    )
  }
}

class SysCallParameter extends Parameter {
  SysCallParameter() { exists(SysCallFunction f | f.getAParameter() = this) }
}

class UserModePtrCheckMacro extends Macro {
  VariableAccess va;

  UserModePtrCheckMacro() {
    this.getName() = ["user_write_access_begin", "user_access_begin", "access_ok"] and
    va.getEnclosingElement() = this.getAnInvocation().getAnExpandedElement()
  }

  VariableAccess getArgument() { result = va }
}

/*
 *   It's really difficult to spot the second argument passed to
 *   unsafe_put_user and used as user-mode pointer. In previous
 *   version PointerDereferenceExpr is used to model user-mode
 *   pointer, but in some odd situation this may lead to false
 *   positive. For example:
 *
 *   ```
 *   void function foo(struct some_struct* __user pointer, long* dummy)
 *   {
 *       if(!access_ok(pointer))            //security check for pointer
 *           return;
 *       unsafe_put_user(*dummy, pointer);
 *   }
 *   ```
 *
 *   parameter dummy will be regared as user-mode pointer used
 *   in unsafe_put_user without security check using access_ok
 *   but in fact dummy is only used to read memory otherwise
 *   instead of writing user-mode memory.
 *
 *   Reading implementation of unsafe_put_user in Linux codebase,
 *   I found that there is a sizeof operation for user-mode pointer.
 *   So SizeofExprOperator is used instead to model user-mode pointer.
 */

class UnSafePutUserMacro extends Macro {
  SizeofExprOperator sizeOfOperator;

  UnSafePutUserMacro() {
    this.getName() = "unsafe_put_user" and
    sizeOfOperator.getEnclosingElement() = this.getAnInvocation().getAnExpandedElement()
  }

  Expr getExprOperand() {
    result =
      sizeOfOperator
          .getExprOperand()
          .getAChild()
          .(AddressOfExpr)
          .getOperand()
          .(FieldAccess)
          .getQualifier() or
    result = sizeOfOperator.getExprOperand().getAChild()
  }
}

/*
 *  Since there is no convenient way to identify user mode pointer,
 *  In this query syscall parameter or function return value will
 *  be regared source node that's used as user mode pointer
 */

class UserModePtrNode extends DataFlow::Node {
  UserModePtrNode() {
    exists(SysCallParameter p | this.asParameter() = p) or
    exists(FunctionCall va | this.asExpr() = va)
  }
}

/*
 *  Track all UsermodePtrNode that flow to UserModePtrCheckMacro
 */

class UserModePtrCheckConfig extends TaintTracking::Configuration {
  UserModePtrCheckConfig() { this = "UserModePtrCheckConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof UserModePtrNode }

  override predicate isSink(DataFlow::Node node) {
    exists(UserModePtrCheckMacro m | node.asExpr() = m.getArgument())
  }
}

/*
 *  Any UserModePtrNode doesn't flow to UserModePtrCheckMacro will
 *  be regared potential exploitable
 */

class ExploitableUserModePtr extends UserModePtrNode {
  ExploitableUserModePtr() {
    not exists(UserModePtrCheckConfig config, DataFlow::Node sink | config.hasFlow(this, sink))
  }
}

/*
 *  Track all UserModePtrNode that flow to UnSafePutUserMacro
 */

class UnsafePutUserConfig extends TaintTracking::Configuration {
  UnsafePutUserConfig() { this = "UnsafePutUserConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof UserModePtrNode }

  override predicate isSink(DataFlow::Node node) {
    exists(UnSafePutUserMacro m | node.asExpr() = m.getExprOperand())
  }
}

from
  UnsafePutUserConfig config, DataFlow::PathNode sink, DataFlow::PathNode src,
  ExploitableUserModePtr ptr
where
  config.hasFlowPath(src, sink) and
  src.getNode() = ptr
select sink, src, sink, "write user-mode pointer $@ without validation.", src, src.toString()
