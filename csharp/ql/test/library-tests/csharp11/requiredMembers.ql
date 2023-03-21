import csharp

query predicate requiredmembers(Member m, string type, string qlclass) {
  m.getFile().getStem() = "RequiredMembers" and
  m.isRequired() and
  type = m.getDeclaringType().getName() and
  qlclass = m.getAPrimaryQlClass()
}
