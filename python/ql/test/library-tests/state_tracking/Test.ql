import python
import Lib
private import LegacyPointsTo

from ControlFlowNode f, TrackableState state, Context ctx, boolean sense
where
  f.getLocation().getStartLine() >= 20 and
  (
    state.appliesTo(f, ctx) and sense = true
    or
    state.mayNotApplyTo(f, ctx) and sense = false
  )
select f.getLocation().toString(), f, ctx, state, sense
