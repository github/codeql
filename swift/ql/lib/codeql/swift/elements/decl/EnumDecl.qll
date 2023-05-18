private import codeql.swift.generated.decl.EnumDecl
private import codeql.swift.elements.decl.EnumCaseDecl
private import codeql.swift.elements.decl.EnumElementDecl
private import codeql.swift.elements.decl.Decl

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
   * Gets the number of `EnumElementDecl`s in this enumeration before the `memberIndex`th member. Some
   * of the members of an `EnumDecl` are `EnumCaseDecls` (representing the `case` lines), each of
   * which holds one or more `EnumElementDecl`s.
   */
  private int countEnumElementsTo(int memberIndex) {
    memberIndex = 0 and result = 0
    or
    exists(Decl prev | prev = this.getMember(memberIndex - 1) |
      result = this.countEnumElementsTo(memberIndex - 1) + prev.(EnumCaseDecl).getNumberOfElements()
      or
      not prev instanceof EnumCaseDecl and
      result = this.countEnumElementsTo(memberIndex - 1)
    )
  }

  /**
   * Gets the `index`th enumeration element of this enumeration (0-based).
   */
  final EnumElementDecl getEnumElement(int index) {
    exists(int memberIndex |
      result =
        this.getMember(memberIndex)
            .(EnumCaseDecl)
            .getElement(index - this.countEnumElementsTo(memberIndex))
    )
  }

  /**
   * Gets an enumeration element of this enumeration.
   */
  final EnumElementDecl getAnEnumElement() {
    result = this.getMember(_).(EnumCaseDecl).getElement(_)
  }
}
