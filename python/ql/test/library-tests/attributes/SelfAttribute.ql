import python
import semmle.python.SelfAttribute

from SelfAttributeRead sa, int line, string g, string l
where
  line = sa.getLocation().getStartLine() and
  (if sa.guardedByHasattr() then g = "guarded" else g = "") and
  if sa.locallyDefined() then l = "defined" else l = ""
select line, sa.getName(), g + l
