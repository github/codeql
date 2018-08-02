import cpp

from Block b, MacroAccess m
where affectedbymacroexpansion(b, m)
select b, m

