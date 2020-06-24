import go

from Function f
where not f.mayReturnNormally()
select f, f.getPackage()
