import javascript

string getRest(TupleType tuple) {
  if tuple.hasRestElement()
  then result = tuple.getRestElementType().toString()
  else result = "no-rest"
}

from Expr e, TupleType tuple, int n
where e.getType() = tuple
select e, tuple, n, tuple.getElementType(n), tuple.getMinimumLength(), getRest(tuple)
