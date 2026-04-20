/**
 * Checks that expressions annotated with `t.never` either have no CFG
 * node, or if they do, that the node is not reachable from its scope's
 * entry (including within the same basic block).
 */

import python
import TimerUtils
import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils::CfgTests

from NeverTimerAnnotation ann
where neverReachable(ann)
select ann, "Node annotated with t.never is reachable in $@", ann.getTestFunction(),
  ann.getTestFunction().getName()
