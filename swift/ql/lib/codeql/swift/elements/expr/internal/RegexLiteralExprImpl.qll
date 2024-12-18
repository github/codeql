private import codeql.swift.generated.expr.RegexLiteralExpr

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A regular expression literal which is checked at compile time, for example `/a(a|b)*b/`.
   */
  class RegexLiteralExpr extends Generated::RegexLiteralExpr {
    override string toString() { result = this.getPattern() }
  }
}
