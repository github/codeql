import cpp

from Variable x
where exists(x.getFile().getRelativePath())
select x, x.getType().(PointerType).getBaseType()
