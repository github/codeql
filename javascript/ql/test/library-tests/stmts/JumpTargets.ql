import javascript

from BreakOrContinueStmt boc, string label
where if boc.hasTargetLabel() then
        label = boc.getTargetLabel()
      else
        label = "(none)"
select boc, label, boc.getTarget()