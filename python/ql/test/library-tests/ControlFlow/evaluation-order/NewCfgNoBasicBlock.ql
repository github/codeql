/**
 * New-CFG version of NoBasicBlock.
 *
 * Checks that every annotated CFG node belongs to a basic block.
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from CfgNode n, TestFunction f
where noBasicBlock(n, f)
select n, "CFG node in $@ does not belong to any basic block", f, f.getName()
