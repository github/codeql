import csharp

query predicate types(Record t, string i) { t.getABaseInterface().toStringWithTypes() = i }

private string getMemberName(Member m) {
  result = m.getDeclaringType().getQualifiedName() + "." + m.toStringWithTypes()
}

query predicate members(Record t, string ms, string l) {
  exists(Member m | t.hasMember(m) |
    ms = getMemberName(m) and
    if m.fromSource() then l = m.getLocation().toString() else l = "no location"
  )
}
