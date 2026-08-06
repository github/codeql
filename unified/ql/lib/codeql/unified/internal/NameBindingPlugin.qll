private import unified
private import codeql.util.Unit
private import codeql.unified.internal.NameBindingPluginSwift // ensure overrides are seen

/** Extension point for language-specific inputs to name binding. */
class NameBindingPlugin extends Unit {
  /**
   * Holds if `member` is an instance member.
   *
   * The caller has already restricted `member` to be a member of `cls`, and
   * ensured that `member` is a `VariableDeclaration` or `FunctionDeclaration`.
   */
  bindingset[cls, member]
  predicate isInstanceMember(ClassLikeDeclaration cls, Member member) { none() }

  /**
   * Holds if `member` is only visible in its local scope, and can thus be entirely resolved
   * by local name-binding, suppressing any store-steps that would otherwise be induced from the member.
   *
   * Need only be implemented for members that occur in the context of class or top-level, as other
   * contexts are considered local already.
   */
  predicate isPrivateToLocalScope(Member member) { none() }
}

/** Holds if `member` is an instance member. */
predicate isInstanceMember(Member member) {
  (member instanceof VariableDeclaration or member instanceof FunctionDeclaration) and
  exists(ClassLikeDeclaration cls | cls.getAMember() = member |
    any(NameBindingPlugin p).isInstanceMember(cls, member)
  )
}

/** Holds if `member` is only visible in its local scope. */
predicate isPrivateToLocalScope(Member member) {
  any(NameBindingPlugin p).isPrivateToLocalScope(member)
}
