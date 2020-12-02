/**
 * @name Guards control test
 * @description List which guards control which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.Guards

from GuardCondition guard, boolean sense, int start, int end
where
  exists(BasicBlock block |
    guard.controls(block, sense) and
    block.hasLocationInfo(_, start, _, end, _)
  )
select guard, sense, start, end
