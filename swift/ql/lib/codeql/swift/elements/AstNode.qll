private import codeql.swift.generated.AstNode

class AstNode extends AstNodeBase {
  AstNode getParent() {
    result = unique(AstNode x | this = x.getAChild() and not exists(x.getResolveStep()) | x)
  }
}
