class TupleType extends @tuple_type {
  predicate hasChild(int i) { type_child(_, this, i) }

  string toString() { result = "" }
}

from TupleType tuple, int index
where index = max(int i | tuple.hasChild(i))
select tuple, index
