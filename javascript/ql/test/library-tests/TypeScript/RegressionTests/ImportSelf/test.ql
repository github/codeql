import javascript

// We're mainly testing extraction succeeds, so just test that some types are extracted.
from Expr e
select e, e.getType()
