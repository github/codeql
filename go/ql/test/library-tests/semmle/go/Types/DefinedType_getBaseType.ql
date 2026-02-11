import go

from DefinedType dt, Type tp
where tp = dt.getBaseType()
select dt, tp.pp()
