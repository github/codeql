import cpp

from Variable v, Expr first, Expr second
where definitionUsePair(v, first, second)
select v, first, second
