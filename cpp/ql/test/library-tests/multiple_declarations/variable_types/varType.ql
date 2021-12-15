import cpp

from Variable var
where exists(var.getFile().getRelativePath())
select var, var.getType(), strictcount(var.getType())
