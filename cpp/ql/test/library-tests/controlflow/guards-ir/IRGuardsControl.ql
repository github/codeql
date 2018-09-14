/**
 * @name Guards control test
 * @description List which guards control which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.IRGuards

from IRGuardCondition guard, boolean sense, int start, int end
where 
exists(IRBlock block |
       guard.controls(block, sense) and
       block.getLocation().hasLocationInfo(_, start, _, end, _)
)
select guard.getAST(), sense, start, end
