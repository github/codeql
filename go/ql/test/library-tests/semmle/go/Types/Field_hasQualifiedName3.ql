import go

from Field fld, string pkg, string tp, string f
where exists(fld.getDeclaration()) and fld.hasQualifiedName(pkg, tp, f)
select fld, pkg, tp, f
