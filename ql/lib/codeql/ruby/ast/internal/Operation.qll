private import codeql.ruby.AST
private import AST
private import TreeSitter

class AssignmentImpl extends Operation, TAssignment {
  abstract AstNode getLeftOperandImpl();

  abstract AstNode getRightOperandImpl();
}

class AssignExprReal extends AssignmentImpl, AssignExpr, TAssignExprReal {
  private Ruby::Assignment g;

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

abstract class SplatExprImpl extends SplatExpr {
  abstract Expr getOperandImpl();
}

class SplatExprReal extends SplatExprImpl, TSplatExprReal {
  private Ruby::SplatArgument g;

  SplatExprReal() { this = TSplatExprReal(g) }

  final override Expr getOperandImpl() { toGenerated(result) = g.getChild() }
}

class SplatExprSynth extends SplatExprImpl, TSplatExprSynth {
  final override Expr getOperandImpl() { synthChild(this, 0, result) }
}
