private import codeql.swift.generated.AstNode
private import codeql.swift.generated.Children

class AstNode extends AstNodeBase {
  AstNode getParent() { result = unique(AstNode x | this = getAChild(x) | x) }
}
