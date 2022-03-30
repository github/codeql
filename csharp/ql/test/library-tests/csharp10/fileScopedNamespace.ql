import csharp

query predicate fileScopedNamespace(Namespace n, Member m) {
  n.hasQualifiedName("MyFileScopedNamespace") and
  exists(Class c |
    c.getNamespace() = n and
    c.hasMember(m) and
    m.getLocation().toString().matches("%FileScopedNamespace.cs%")
  )
}

query predicate namespaceDeclaration(NamespaceDeclaration nd, Namespace n) { n = nd.getNamespace() }
