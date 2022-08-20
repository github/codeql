/**
 * @name Linux kernel double-fetch vulnerability detection
 * @description Double-fetch is a very common vulnerability pattern
 *              in linux kernel, attacker can exploit double-fetch
 *              issues to obatain root privilege.
 *              Double-fetch is caused by fetching data from user
 *              mode by calling copy_from_user twice, CVE-2016-6480
 *              is quite a good example for your information.
 * @kind problem
 * @id cpp/linux-kernel-double-fetch-vulnerability
 * @problem.severity warning
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-362
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

class CopyFromUserFunctionCall extends FunctionCall {
  CopyFromUserFunctionCall() {
    this.getTarget().getName() = "copy_from_user" and
    not this.getArgument(1) instanceof AddressOfExpr
  }

  //root cause of double-fetech issue is read from
  //the same user mode memory twice, so it makes
  //sense that only check user mode pointer
  predicate readFromSameUserModePointer(CopyFromUserFunctionCall another) {
    globalValueNumber(this.getArgument(1)) = globalValueNumber(another.getArgument(1))
  }
}

from CopyFromUserFunctionCall p1, CopyFromUserFunctionCall p2
where
  not p1 = p2 and
  p1.readFromSameUserModePointer(p2) and
  exists(IfStmt ifStmt |
    p1.getBasicBlock().getAFalseSuccessor*() = ifStmt.getBasicBlock() and
    ifStmt.getBasicBlock().getAFalseSuccessor*() = p2.getBasicBlock()
  ) and
  not exists(AssignPointerAddExpr assignPtrAdd |
    globalValueNumber(p1.getArgument(1)) = globalValueNumber(assignPtrAdd.getLValue()) and
    p1.getBasicBlock().getAFalseSuccessor*() = assignPtrAdd.getBasicBlock()
  )
select p2, "Double fetch vulnerability. First fetch was $@.", p1, p1.toString()
