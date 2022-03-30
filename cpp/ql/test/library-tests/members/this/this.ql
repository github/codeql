import cpp

query predicate thisExprType(ThisExpr e, Type t) { t = e.getType() }

from MemberFunction f
select f, f.getTypeOfThis()
