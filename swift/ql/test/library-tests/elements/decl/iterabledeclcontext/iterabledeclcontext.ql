import swift

predicate isInTestModule(Decl decl) { decl.getModule().getName() = "iterabledeclcontext" }

query predicate declHasMemberAtIndex(
  IterableDeclContext decl, int index, Decl member, string memberClass
) {
  isInTestModule(decl) and
  member = decl.getMember(index) and
  memberClass = member.getPrimaryQlClasses()
}

query predicate methodDecl(IterableDeclContext d, MethodDecl m, string mClass) {
  isInTestModule(m) and
  mClass = m.getPrimaryQlClasses() and
  d.getAMember() = m
}
