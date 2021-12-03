import javascript

query predicate test_InterfaceTypeExpr(InterfaceTypeExpr type, MemberDeclaration res) {
  res = type.getAMember()
}
