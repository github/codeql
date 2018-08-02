import cpp

from Variable v
select v, count(v.getInitializer()), count(v.getInitializer().getExpr())
