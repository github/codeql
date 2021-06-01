private import codeql_ruby.AST
private import AST
private import TreeSitter

class AssignmentImpl extends Operation, TAssignment {
  abstract Pattern getLeftOperandImpl();

  abstract Expr getRightOperandImpl();
}

class AssignExprReal extends AssignmentImpl, AssignExpr, TAssignExprReal {
  private Generated::Assignment g;

  AssignExprReal() { this = TAssignExprReal(g) }

  final override Pattern getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override Expr getRightOperandImpl() { toGenerated(result) = g.getRight() }
}

class AssignExprSynth extends AssignmentImpl, AssignExpr, TAssignExprSynth {
  final override Pattern getLeftOperandImpl() { synthChild(this, 0, result) }

  final override Expr getRightOperandImpl() { synthChild(this, 1, result) }
}

class AssignOperationImpl extends AssignmentImpl, AssignOperation {
  final override LhsExpr getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override Expr getRightOperandImpl() { toGenerated(result) = g.getRight() }
}
