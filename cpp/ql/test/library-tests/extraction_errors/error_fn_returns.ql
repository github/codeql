import cpp

from Function fn
where fn.getType() instanceof ErroneousType or not exists(fn.getType())
select fn
