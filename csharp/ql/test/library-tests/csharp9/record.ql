import csharp

query predicate records(RecordClass t, string i, RecordCloneMethod clone) {
  t.getABaseInterface().toStringWithTypes() = i and
  clone = t.getCloneMethod() and
  t.fromSource()
}

private string getMemberName(Member m) {
  result = m.getDeclaringType().getQualifiedName() + "." + m.toStringWithTypes()
}

query predicate members(RecordClass t, string ms, string l) {
  t.fromSource() and
  exists(Member m | t.hasMember(m) |
    ms = getMemberName(m) and
    if m.fromSource() then l = m.getLocation().toString() else l = "no location"
  )
}
