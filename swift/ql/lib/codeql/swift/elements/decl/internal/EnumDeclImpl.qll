private import codeql.swift.generated.decl.EnumDecl
private import codeql.swift.elements.decl.EnumCaseDecl
private import codeql.swift.elements.decl.EnumElementDecl
private import codeql.swift.elements.decl.Decl

module Impl {
  /**
   * An enumeration declaration, for example:
   * ```
   * enum MyColours {
   *   case red
   *   case green
   *   case blue
   * }
   * ```
   */
  class EnumDecl extends Generated::EnumDecl {
    /**
     * Gets the `index`th enumeration element of this enumeration (0-based).
     */
    final EnumElementDecl getEnumElement(int index) {
      result =
        rank[index + 1](int memberIndex, Decl d |
          d = this.getMember(memberIndex) and
          d instanceof EnumElementDecl
        |
          d order by memberIndex
        )
    }

    /**
     * Gets an enumeration element of this enumeration.
     */
    final EnumElementDecl getAnEnumElement() {
      result = this.getMember(_).(EnumCaseDecl).getElement(_)
    }
  }
}
