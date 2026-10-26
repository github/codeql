import go

from Field fld, string tp, string f
where exists(fld.getDeclaration()) and fld.hasQualifiedName(tp, f)
select fld, tp, f
