private import codeql_ruby.AST
private import AST
private import TreeSitter

class AssignmentImpl extends Operation, TAssignment {
  abstract AstNode getLeftOperandImpl();

  abstract AstNode getRightOperandImpl();
}

class AssignExprReal extends AssignmentImpl, AssignExpr, TAssignExprReal {
  private Generated::Assignment g;

  AssignExprReal() { this = TAssignExprReal(g) }

  final override AstNode getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override AstNode getRightOperandImpl() { toGenerated(result) = g.getRight() }
}

class AssignExprSynth extends AssignmentImpl, AssignExpr, TAssignExprSynth {
  final override AstNode getLeftOperandImpl() { synthChild(this, 0, result) }

  final override AstNode getRightOperandImpl() { synthChild(this, 1, result) }
}

class AssignOperationImpl extends AssignmentImpl, AssignOperation {
  final override AstNode getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override AstNode getRightOperandImpl() { toGenerated(result) = g.getRight() }
}
