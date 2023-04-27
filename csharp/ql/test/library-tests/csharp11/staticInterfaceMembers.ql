import csharp

query predicate interfacemembers(string interface, Member m, string modifier) {
  exists(Interface i |
    i.isUnboundDeclaration() and
    i.getFile().getStem() = "StaticInterfaceMembers" and
    i.getName() = interface and
    m = i.getAMember() and
    modifier = m.getAModifier().getName()
  )
}

query predicate implements(Overridable o, Virtualizable v) {
  v.getFile().getStem() = "StaticInterfaceMembers" and
  (v.isVirtual() or v.isAbstract()) and
  v.isStatic() and
  v.getAnImplementor() = o
}

query predicate publicmembers(Member m) {
  m.getFile().getStem() = "StaticInterfaceMembers" and
  m.getDeclaringType().getName() = "Complex" and
  m.isPublic()
}
