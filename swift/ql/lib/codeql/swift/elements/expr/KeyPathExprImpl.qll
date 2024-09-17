private import codeql.swift.generated.expr.KeyPathExpr

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A key-path expression.
   */
  class KeyPathExpr extends Generated::KeyPathExpr {
    override string toString() { result = "#keyPath(...)" }
  }
}
