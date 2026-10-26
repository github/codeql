import csharp

query predicate members1(TupleType t, string m) {
  t.fromSource() and
  m = t.getAMember().toStringWithTypes()
}

query predicate members2(TupleType t, string s, string m) {
  t.fromSource() and
  s = t.getUnderlyingType().toStringWithTypes() and
  m = t.getUnderlyingType().getAMember().toStringWithTypes()
}
