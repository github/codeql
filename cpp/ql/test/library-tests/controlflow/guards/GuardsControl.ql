/**
 * @name Guards control test
 * @description List which guards control which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.Guards

from GuardCondition guard, GuardValue value, BasicBlock block
where guard.valueControls(block, value)
select guard, value, block
