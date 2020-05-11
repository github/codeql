import python

from SsaVariable v, string kind, ControlFlowNode use, int line
where
  use = v.getAUse() and
  (
    kind = "delete" and v.getDefinition().isDelete()
    or
    kind = "other " and not v.getDefinition().isDelete()
  ) and
  line = use.getLocation().getStartLine() and
  line != 0
select line, use.toString(), v.getId(), kind
