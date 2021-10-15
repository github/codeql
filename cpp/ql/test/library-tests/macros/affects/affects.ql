import cpp

from Element e, MacroAccess ma
where affectedbymacroexpansion(unresolveElement(e), unresolveElement(ma))
select e.getLocation(), e, ma.getLocation(), ma
