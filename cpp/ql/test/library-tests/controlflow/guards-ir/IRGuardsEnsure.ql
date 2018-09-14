/**
 * @name Guards control test
 * @description List which guards ensure which inequalities apply to which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.IRGuards


from IRGuardCondition guard, Instruction left, Instruction right, int k, int start, int end, string op
where 
exists(IRBlock block |
       guard.ensuresLt(left, right, k, block, true) and op = "<"
       or
       guard.ensuresLt(left, right, k, block, false) and op = ">=" 
        or
       guard.ensuresEq(left, right, k, block, true) and op = "=="
       or
       guard.ensuresEq(left, right, k, block, false) and op = "!=" |
       block.getLocation().hasLocationInfo(_, start, _, end, _)
)
select guard.getAST(), left.getAST(), op, right.getAST(), k, start, end
