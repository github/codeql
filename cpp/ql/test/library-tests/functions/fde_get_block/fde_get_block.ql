import cpp

from FunctionDeclarationEntry fde
select fde.getLocation().getStartLine(), fde.getBlock().getLocation().getStartLine()
