import cpp

from FunctionDeclarationEntry fde, string imp
where if fde.isImplicit() then imp = "isImplicit" else imp = ""
select fde, imp, count(fde.getASpecifier()), concat(fde.getASpecifier().toString(), ", ")
