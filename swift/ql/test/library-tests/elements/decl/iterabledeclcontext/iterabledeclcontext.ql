import swift
import codeql.swift.elements.decl.DeclWithMembers

predicate isInTestModule(Decl decl) { decl.getModule().getName() = "iterabledeclcontext" }

query predicate declHasMemberAtIndex(
  DeclWithMembers decl, int index, Decl member, string memberClass
) {
  isInTestModule(decl) and
  member = decl.getMember(index) and
  memberClass = member.getPrimaryQlClasses()
}

query predicate methodDecl(
  DeclWithMembers decl, MethodDecl member, string memberClass, string memberQName
) {
  isInTestModule(member) and
  memberClass = member.getPrimaryQlClasses() and
  decl.getAMember() = member and
  exists(string memberModule, string memberType, string memberName |
    member.hasQualifiedName(memberModule, memberType, memberName) and
    memberQName = memberModule + "." + memberType + "." + memberName
  )
}
