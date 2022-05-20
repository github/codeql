import go

from TypeParamDeclParent x, int i, TypeParamDecl tpd, int j
where tpd = x.getTypeParameterDecl(i)
select x, x.getPrimaryQlClasses(), i, tpd, j, tpd.getNameExpr(j), tpd.getTypeConstraintExpr(),
  tpd.getTypeConstraint().pp()
