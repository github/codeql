import cpp

from ParameterDeclarationEntry pde
where pde.getFunctionDeclarationEntry().getFunction().hasName("x")
select pde.getLocation().getStartLine(), pde.getType().toString()
