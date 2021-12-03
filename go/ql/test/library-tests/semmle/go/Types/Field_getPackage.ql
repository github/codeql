import go

from Field f
where exists(f.getDeclaration())
select f, f.getPackage()
