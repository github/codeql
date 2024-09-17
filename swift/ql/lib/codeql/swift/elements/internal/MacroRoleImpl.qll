/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroRole`.
 */

private import codeql.swift.generated.MacroRole

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The role of a macro, for example #freestanding(declaration) or @attached(member).
   */
  class MacroRole extends Generated::MacroRole {
    /**
     * String representation of the role kind.
     */
    string getKindName() {
      this.isExpressionKind() and result = "expression"
      or
      this.isDeclarationKind() and result = "declaration"
      or
      this.isAccessorKind() and result = "accessor"
      or
      this.isMemberAttributeKind() and result = "memberAttribute"
      or
      this.isMemberKind() and result = "member"
      or
      this.isPeerKind() and result = "peer"
      or
      this.isConformanceKind() and result = "conformance"
      or
      this.isCodeItemKind() and result = "codeItem"
      or
      this.isExtensionKind() and result = "extension"
    }

    /**
     * Holds for `expression` roles.
     */
    predicate isExpressionKind() { this.getKind() = 1 }

    /**
     * Holds for `declaration` roles.
     */
    predicate isDeclarationKind() { this.getKind() = 2 }

    /**
     * Holds for `accessor` roles.
     */
    predicate isAccessorKind() { this.getKind() = 4 }

    /**
     * Holds for `memberAttribute` roles.
     */
    predicate isMemberAttributeKind() { this.getKind() = 8 }

    /**
     * Holds for `member` roles.
     */
    predicate isMemberKind() { this.getKind() = 16 }

    /**
     * Holds for `peer` roles.
     */
    predicate isPeerKind() { this.getKind() = 32 }

    /**
     * Holds for `conformance` roles.
     */
    predicate isConformanceKind() { this.getKind() = 64 }

    /**
     * Holds for `codeItem` roles.
     */
    predicate isCodeItemKind() { this.getKind() = 128 }

    /**
     * Holds for `extension` roles.
     */
    predicate isExtensionKind() { this.getKind() = 256 }

    /**
     * String representation of the macro syntax.
     */
    string getMacroSyntaxName() {
      this.isFreestandingMacroSyntax() and result = "#freestanding"
      or
      this.isAttachedMacroSyntax() and result = "@attached"
    }

    /**
     * Holds for #freestanding macros.
     */
    predicate isFreestandingMacroSyntax() { this.getMacroSyntax() = 0 }

    /**
     * Holds for @attached macros.
     */
    predicate isAttachedMacroSyntax() { this.getMacroSyntax() = 1 }

    override string toString() {
      result = this.getMacroSyntaxName() + "(" + this.getKindName() + ")"
    }
  }
}
