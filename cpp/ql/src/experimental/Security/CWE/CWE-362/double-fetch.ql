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

class CopyFromUserFunctionCall extends FunctionCall{
    CopyFromUserFunctionCall(){
        this.getTarget().getName() = "copy_from_user"
        and not this.getArgument(1) instanceof AddressOfExpr
    }

    predicate hasSameArguments(CopyFromUserFunctionCall another){
        this.getArgument(0).toString() = another.getArgument(0).toString()
        and this.getArgument(1).toString() = another.getArgument(1).toString()
    }

}

from CopyFromUserFunctionCall p1, CopyFromUserFunctionCall p2
where
    not p1 = p2
    and p1.hasSameArguments(p2)
    and exists(IfStmt ifStmt| 
        p1.getBasicBlock().getAFalseSuccessor*() = ifStmt.getBasicBlock()
        and ifStmt.getBasicBlock().getAFalseSuccessor*() = p2.getBasicBlock()
    )
    and not exists(AssignPointerAddExpr assignPtrAdd |
        p1.getArgument(1).toString() = assignPtrAdd.getLValue().toString()
        and p1.getBasicBlock().getAFalseSuccessor*() = assignPtrAdd.getBasicBlock()
    )
select
    "first fetch", p1, "double fetch", p2



