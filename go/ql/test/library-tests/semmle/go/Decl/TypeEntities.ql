import go

from TypeEntity te
select te, te.getPackage(), te.getType().pp()
