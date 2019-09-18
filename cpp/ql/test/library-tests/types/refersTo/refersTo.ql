import cpp

from Type a, Type b, string str
where
  a.refersTo(b) and
  (if a.refersToDirectly(b) then str = "direct" else str = "") and
  b.getFile().toString() != ""
select a.getLocation().getStartLine(), a, b, str
