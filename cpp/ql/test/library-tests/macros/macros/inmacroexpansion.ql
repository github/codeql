import cpp

from Block b, MacroAccess m
where inmacroexpansion(unresolveElement(b), unresolveElement(m))
select b, m
