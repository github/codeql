import python
import Util
private import LegacyPointsTo

from ClassMethodObject cm, CallNode call
where call = cm.getACall()
select locate(call.getLocation(), "lp"), cm.getFunction().toString(),
  cm.(ControlFlowNode).getLocation().toString()
