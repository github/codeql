import java

query Member onlyInherited(RefType t) {
  t.fromSource() and
  t.inherits(result) and
  not result.getDeclaringType() instanceof TypeObject and
  // Ignore declared members; query predicate below verifies that they are a subset
  not result.getDeclaringType() = t
}

/** Verify that declared members are a subset of inherited members */
query Member bugDeclaredButNotInherited(RefType t) {
  t.fromSource() and
  result.getDeclaringType() = t and
  not t.inherits(result)
}
