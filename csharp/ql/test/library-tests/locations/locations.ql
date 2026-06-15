import csharp

query predicate member_locations(Type t, Member m, SourceLocation l) {
  t = m.getDeclaringType() and
  l = m.getLocation() and
  not l instanceof EmptyLocation and
  t.fromSource()
}

query predicate accessor_location(Type t, Accessor a, SourceLocation l) {
  t = a.getDeclaringType() and
  l = a.getLocation() and
  not l instanceof EmptyLocation
}

query predicate type_location(Type t, SourceLocation l) {
  l = t.getLocation() and not l instanceof EmptyLocation
}

query predicate calltype_location(Call call, Type t, SourceLocation l) {
  t = call.getType() and
  l = t.getALocation()
}

query predicate typeparameter_location(TypeParameter tp, SourceLocation l) { tp.getALocation() = l }

query predicate tupletype_location(TupleType tt, SourceLocation l) { tt.getALocation() = l }

query predicate parameter_locations(Callable c, Parameter p, SourceLocation l) {
  p.getCallable() = c and p.getALocation() = l
}
