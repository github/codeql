import javascript

query predicate test_QualifiedTypeAccess(
  QualifiedTypeAccess type, NamespaceAccess res0, Identifier res1
) {
  res0 = type.getQualifier() and res1 = type.getIdentifier()
}
