import cpp

from Variable v
select v, v.getInitializer().getExpr().getValue()
