/**
 * Checks that every live (non-dead) annotation in the test function's
 * own scope is reachable from the function entry in the CFG.
 * Annotations in nested scopes (generators, async, lambdas, comprehensions)
 * have separate CFGs and are excluded from this check.
 */

import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TestFunction f
where allLiveReachable(a, f)
select a, "Unreachable live annotation; entry of $@ does not reach this node", f, f.getName()
