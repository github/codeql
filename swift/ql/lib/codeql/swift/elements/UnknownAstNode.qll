private import codeql.swift.generated.UnknownAstNode

class UnknownAstNode extends UnknownAstNodeBase {
  override string toString() { result = getName() }
}
