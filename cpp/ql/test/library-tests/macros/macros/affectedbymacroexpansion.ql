import cpp

from Block b, MacroAccess m
where affectedbymacroexpansion(unresolveElement(b), unresolveElement(m))
select b, m
