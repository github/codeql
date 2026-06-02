/** New-CFG version of AllLiveReachable. */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TestFunction f
where allLiveReachable(a, f)
select a, "Unreachable live annotation; entry of $@ does not reach this node", f, f.getName()
