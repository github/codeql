/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroRole`.
 */

private import codeql.swift.generated.MacroRole

class MacroRole extends Generated::MacroRole {
  string getKindName() {
    this.getKind() = 1 and result = "expression"
    or
    this.getKind() = 2 and result = "declaration"
    or
    this.getKind() = 4 and result = "accessor"
    or
    this.getKind() = 8 and result = "memberAttribute"
    or
    this.getKind() = 16 and result = "member"
    or
    this.getKind() = 32 and result = "peer"
    or
    this.getKind() = 64 and result = "conformance"
    or
    this.getKind() = 128 and result = "codeItem"
    or
    this.getKind() = 256 and result = "extension"
  }

  string getMacroSyntaxName() {
    this.getMacroSyntax() = 0 and result = "#freestanding"
    or
    this.getMacroSyntax() = 1 and result = "@attached"
  }

  override string toString() { result = this.getMacroSyntaxName() + "(" + this.getKindName() + ")" }
}
