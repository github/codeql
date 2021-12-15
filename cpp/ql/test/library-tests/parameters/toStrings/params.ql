import cpp

from ParameterDeclarationEntry pde, string str
where if exists(pde.toString()) then str = pde.toString() else str = "<none>"
select pde.getLocation().toString(), str
