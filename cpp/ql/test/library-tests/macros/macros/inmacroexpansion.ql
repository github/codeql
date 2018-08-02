import cpp

from Block b, MacroAccess m
where inmacroexpansion(b, m)
select b, m

