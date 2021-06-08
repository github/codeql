import python
import Lib

from ControlFlowNode f, TrackableState state
where
  (
    callTo(f, "exacerbate") and state = "frobnicated"
    or
    callTo(f, "frobnicate") and state = "initialized"
  ) and
  state.mayNotApplyTo(f)
select f.getLocation().toString(), f.toString(), state.toString()
