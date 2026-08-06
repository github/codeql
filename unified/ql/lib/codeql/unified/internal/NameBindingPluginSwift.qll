/**
 * Provides Swift-specific name binding rules.
 */

private import unified
private import codeql.unified.internal.NameBindingPlugin

class NameBindingPluginSwift extends NameBindingPlugin {
  // Note: For now we assume all code is Swift, but in the future we must restrict these rules to Swift-files
  bindingset[cls, member]
  override predicate isInstanceMember(ClassLikeDeclaration cls, Member member) {
    exists(cls) and
    not member.hasModifier(["static", "class", "enum_case"])
  }

  override predicate isPrivateToLocalScope(Member member) {
    // Private top-level members
    member = any(TopLevel top).getBody().getAStmt() and
    member.hasModifier(["private", "fileprivate"])
    //
    // Note: Private class members can be seen within type-extensions in the same file,
    // so we can't declare those private to their local scope.
  }
}
