import cpp

from Element e, MacroAccess ma
where affectedbymacroexpansion(e, ma)
select e.getLocation(), e, ma.getLocation(), ma

