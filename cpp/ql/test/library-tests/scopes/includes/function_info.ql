import cpp

from Function f, boolean cLinkage
where if f.hasCLinkage() then cLinkage = true else cLinkage = false
select f, f.getNamespace(), cLinkage
