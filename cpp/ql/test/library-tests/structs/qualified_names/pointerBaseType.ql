import cpp

from Variable x
where x.getName() = "x"
select x, x.getType().(PointerType).getBaseType()
