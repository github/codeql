import csharp
import semmle.code.csharp.commons.QualifiedName

query predicate records(RecordClass t, string i, RecordCloneMethod clone) {
  t.getABaseInterface().toStringWithTypes() = i and
  clone = t.getCloneMethod() and
  t.fromSource()
}

private string getMemberName(Member m) {
  exists(string qualifier, string name | m.getDeclaringType().hasQualifiedName(qualifier, name) |
    result = getQualifiedName(qualifier, name) + "." + m.toStringWithTypes()
  )
}

query predicate members(RecordClass t, string ms, string l) {
  t.fromSource() and
  exists(Member m | t.hasMember(m) |
    ms = getMemberName(m) and
    if m.fromSource() then l = m.getLocation().toString() else l = "no location"
  )
}
