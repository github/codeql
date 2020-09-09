import cpp

from BlockStmt b, MacroAccess m
where affectedbymacroexpansion(unresolveElement(b), unresolveElement(m))
select b, m
