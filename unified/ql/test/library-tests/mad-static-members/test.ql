private import unified
private import codeql.unified.internal.StaticNameBinding as N
private import codeql.unified.internal.mad.LegacyMaD as MaD
private import codeql.unified.internal.typeinference.TypeInference as T
private import codeql.unified.internal.typeinference.Type as Types

query predicate staticMember(AstNode ref, string member) {
  exists(MaD::MemberSelector selector |
    N::trackMemberSelector(selector) = N::getNodeFromRef(ref) and
    exists(ref.getFile().getRelativePath()) and
    member = selector.getTypeString() + "." + selector.getName()
  )
}

query predicate instanceMember(string type, string member) {
  exists(N::NamespaceNode namespace, MaD::TypeSelector typeSelector, N::NameBindingNode node |
    namespace.isTypeSelector(typeSelector) and
    not typeSelector.isMetaType() and
    node = namespace.getMember(member) and
    node.isMemberSelector(_) and
    type = typeSelector and
    type.matches("StaticTest%")
  )
  or
  exists(N::NamespaceNode namespace, ClassLikeDeclaration cls, N::NameBindingNode node |
    namespace.isInstanceMemberNamespace(cls) and
    node = namespace.getMember(member) and
    node.isMemberSelector(_) and
    type = cls.getName()
  )
}

query predicate unqualified(UnqualifiedMemberAccess access, string member) {
  exists(MaD::MemberSelector selector |
    access.getTargetNode().isMemberSelector(selector) and
    member = selector.getTypeString() + "." + selector.getName()
  )
}

query predicate baseMetaType(MemberAccess access, string type) {
  type = T::inferBaseType(access).(Types::MetaType).toString() and
  exists(access.getFile().getRelativePath())
}
