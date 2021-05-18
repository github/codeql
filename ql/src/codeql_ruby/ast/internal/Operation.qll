private import codeql_ruby.AST
private import AST
private import TreeSitter

class AssignExprReal extends AssignExpr, TAssignExprReal {
  private Generated::Assignment g;

  AssignExprReal() { this = TAssignExprReal(g) }

  final override Pattern getLeftOperand() { toGenerated(result) = g.getLeft() }

  final override Expr getRightOperand() { toGenerated(result) = g.getRight() }
}

class AssignExprSynth extends AssignExpr, TAssignExprSynth {
  final override Pattern getLeftOperand() { synthChild(this, 0, result) }

  final override Expr getRightOperand() { synthChild(this, 1, result) }
}
