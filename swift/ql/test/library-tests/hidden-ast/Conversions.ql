import swift

from Expr e, Expr subexpr
where subexpr = [e.(IdentityExpr).getSubExpr(), e.(ImplicitConversionExpr).getSubExpr()]
select e, e.getPrimaryQlClasses(), subexpr, subexpr.getPrimaryQlClasses()
