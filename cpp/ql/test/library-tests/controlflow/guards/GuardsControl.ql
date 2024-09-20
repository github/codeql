/**
 * @name Guards control test
 * @description List which guards control which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.Guards

from GuardCondition guard, AbstractValue value, int start, int end
where
  exists(BasicBlock block |
    guard.valueControls(block, value) and
    block.hasLocationInfo(_, start, _, end, _)
  )
select guard, value, start, end
