import csharp

query predicate member_locations(Type t, Member m, SourceLocation l) {
  t = m.getDeclaringType() and
  l = m.getLocation() and
  not l instanceof EmptyLocation and
  not m instanceof Constructor
}

query predicate accessor_location(Type t, Accessor a, SourceLocation l) {
  t = a.getDeclaringType() and
  l = a.getLocation() and
  not l instanceof EmptyLocation
}

query predicate type_location(Type t, SourceLocation l) {
  l = t.getLocation() and not l instanceof EmptyLocation
}
