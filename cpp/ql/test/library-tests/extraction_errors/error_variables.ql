import cpp

from Variable v
where v.getType() instanceof ErroneousType or not exists(v.getType())
select v, "This variable does not have a type."
