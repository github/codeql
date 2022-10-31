private import codeql.swift.generated.decl.IterableDeclContext
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.decl.VarDecl
private import codeql.swift.elements.decl.SubscriptDecl

class IterableDeclContext extends Generated::IterableDeclContext {
  /**
   * Gets the `index`th member of this iterable declaration context (0-based),
   * including `AccessorDecl`s of immediate members.
   */
  override Decl getImmediateMember(int index) {
    result =
      rank[1 + index](Decl member, Decl immMember, int immIndex, int accIndex |
        immMember = super.getImmediateMember(immIndex) and
        (
          member = immMember and accIndex = -1
          or
          member = immMember.(VarDecl).getImmediateAccessorDecl(accIndex)
          or
          member = immMember.(SubscriptDecl).getImmediateAccessorDecl(accIndex)
        )
      |
        member order by immIndex, accIndex
      )
  }
}
