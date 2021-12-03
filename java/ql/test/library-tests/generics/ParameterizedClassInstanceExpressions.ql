import default

from ClassInstanceExpr cie, Expr typearg, int idx
where typearg = cie.getTypeArgument(idx)
select cie, idx, typearg
