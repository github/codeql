import cpp

// It should be the case that "f.isDefined()" is equivalent to "exists(f.getBlock())".
from Function f, string isdef, string hasblock
where
  (if f.hasDefinition() then isdef = "defined" else isdef = "not defined") and
  (if exists(f.getBlock()) then hasblock = "has block" else hasblock = "no block")
select f.getName(), isdef, hasblock
