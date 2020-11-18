import csharp

query predicate types(Class t, string i) {
  t.getFile().getStem() = "Record" and
  t.getABaseInterface().toStringWithTypes() = i
}

private string getMemberName(Member m) {
  result = m.getDeclaringType().getQualifiedName() + "." + m.toStringWithTypes()
}

query predicate members(Class t, string ms, string l) {
  t.getFile().getStem() = "Record" and
  exists(Member m | t.hasMember(m) |
    ms = getMemberName(m) and
    if m.fromSource() then l = m.getLocation().toString() else l = "no location"
  )
}
