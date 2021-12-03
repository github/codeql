import cpp

from BlockStmt b, MacroAccess m
where inmacroexpansion(unresolveElement(b), unresolveElement(m))
select b, m
