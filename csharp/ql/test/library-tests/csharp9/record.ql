import csharp
import semmle.code.csharp.commons.QualifiedName

query predicate records(RecordClass t, string i, RecordCloneMethod clone) {
  t.getABaseInterface().toStringWithTypes() = i and
  clone = t.getCloneMethod() and
  t.fromSource()
}

query predicate members(RecordClass t, string ms, string l) {
  t.fromSource() and
  exists(Member m | t.hasMember(m) |
    ms = getFullyQualifiedNameWithTypes(m) and
    if m.fromSource() then l = m.getLocation().toString() else l = "no location"
  )
}
