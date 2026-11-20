private import unified
private import codeql.unified.internal.StaticNameBinding as N
private import codeql.unified.internal.mad.LegacyMaD as MaD

query predicate staticMember(AstNode ref, string member) {
  exists(MaD::MemberSelector selector |
    N::trackMemberSelector(selector) = N::getNodeFromRef(ref) and
    exists(ref.getFile().getRelativePath()) and
    member = selector.getTypeString() + "." + selector.getName()
  )
}
