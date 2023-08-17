private import codeql.ruby.AST
private import AST
private import TreeSitter
private import Call

abstract class OperationImpl extends Expr, TOperation {
  abstract string getOperatorImpl();

  abstract Expr getAnOperandImpl();
}

abstract class UnaryOperationImpl extends OperationImpl, MethodCallImpl, TUnaryOperation {
  abstract Expr getOperandImpl();

  final override Expr getAnOperandImpl() { result = this.getOperandImpl() }

  final override string getMethodNameImpl() { result = this.getOperatorImpl() }

  final override AstNode getReceiverImpl() { result = this.getOperandImpl() }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }

  final override Block getBlockImpl() { none() }
}

class UnaryOperationGenerated extends UnaryOperationImpl {
  private Ruby::Unary g;

  UnaryOperationGenerated() { g = toGenerated(this) }

  final override Expr getOperandImpl() { toGenerated(result) = g.getOperand() }

  final override string getOperatorImpl() { result = g.getOperator() }
}

abstract class NotExprImpl extends UnaryOperationImpl, TNotExpr { }

class NotExprReal extends NotExprImpl, UnaryOperationGenerated, TNotExprReal { }

class NotExprSynth extends NotExprImpl, TNotExprSynth {
  final override string getOperatorImpl() { result = "!" }

  final override Expr getOperandImpl() { synthChild(this, 0, result) }
}

class SplatExprReal extends UnaryOperationImpl, TSplatExprReal {
  private Ruby::SplatArgument g;

  SplatExprReal() { this = TSplatExprReal(g) }

  final override string getOperatorImpl() { result = "*" }

  final override Expr getOperandImpl() {
    toGenerated(result) = g.getChild() or
    synthChild(this, 0, result)
  }
}

class SplatExprSynth extends UnaryOperationImpl, TSplatExprSynth {
  final override string getOperatorImpl() { result = "*" }

  final override Expr getOperandImpl() { synthChild(this, 0, result) }
}

class HashSplatExprImpl extends UnaryOperationImpl, THashSplatExpr {
  private Ruby::HashSplatArgument g;

  HashSplatExprImpl() { this = THashSplatExpr(g) }

  final override Expr getOperandImpl() {
    toGenerated(result) = g.getChild() or
    synthChild(this, 0, result)
  }

  final override string getOperatorImpl() { result = "**" }
}

abstract class DefinedExprImpl extends UnaryOperationImpl, TDefinedExpr { }

class DefinedExprReal extends DefinedExprImpl, UnaryOperationGenerated, TDefinedExprReal { }

class DefinedExprSynth extends DefinedExprImpl, TDefinedExprSynth {
  final override string getOperatorImpl() { result = "defined?" }

  final override Expr getOperandImpl() { synthChild(this, 0, result) }
}

abstract class BinaryOperationImpl extends OperationImpl, MethodCallImpl, TBinaryOperation {
  abstract Stmt getLeftOperandImpl();

  abstract Stmt getRightOperandImpl();

  final override Expr getAnOperandImpl() {
    result = this.getLeftOperandImpl()
    or
    result = this.getRightOperandImpl()
  }

  final override string getMethodNameImpl() { result = this.getOperatorImpl() }

  final override AstNode getReceiverImpl() { result = this.getLeftOperandImpl() }

  final override Expr getArgumentImpl(int n) { n = 0 and result = this.getRightOperandImpl() }

  final override int getNumberOfArgumentsImpl() { result = 1 }

  final override Block getBlockImpl() { none() }
}

class BinaryOperationReal extends BinaryOperationImpl {
  private Ruby::Binary g;

  BinaryOperationReal() { g = toGenerated(this) }

  final override string getOperatorImpl() { result = g.getOperator() }

  final override Stmt getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override Stmt getRightOperandImpl() { toGenerated(result) = g.getRight() }
}

abstract class BinaryOperationSynth extends BinaryOperationImpl {
  final override Stmt getLeftOperandImpl() { synthChild(this, 0, result) }

  final override Stmt getRightOperandImpl() { synthChild(this, 1, result) }
}

class AddExprSynth extends BinaryOperationSynth, TAddExprSynth {
  final override string getOperatorImpl() { result = "+" }
}

class SubExprSynth extends BinaryOperationSynth, TSubExprSynth {
  final override string getOperatorImpl() { result = "-" }
}

class MulExprSynth extends BinaryOperationSynth, TMulExprSynth {
  final override string getOperatorImpl() { result = "*" }
}

class DivExprSynth extends BinaryOperationSynth, TDivExprSynth {
  final override string getOperatorImpl() { result = "/" }
}

class ModuloExprSynth extends BinaryOperationSynth, TModuloExprSynth {
  final override string getOperatorImpl() { result = "%" }
}

class ExponentExprSynth extends BinaryOperationSynth, TExponentExprSynth {
  final override string getOperatorImpl() { result = "**" }
}

class LogicalAndExprSynth extends BinaryOperationSynth, TLogicalAndExprSynth {
  final override string getOperatorImpl() { result = "&&" }
}

class LogicalOrExprSynth extends BinaryOperationSynth, TLogicalOrExprSynth {
  final override string getOperatorImpl() { result = "||" }
}

class LShiftExprSynth extends BinaryOperationSynth, TLShiftExprSynth {
  final override string getOperatorImpl() { result = "<<" }
}

class RShiftExprSynth extends BinaryOperationSynth, TRShiftExprSynth {
  final override string getOperatorImpl() { result = ">>" }
}

class BitwiseAndSynthExpr extends BinaryOperationSynth, TBitwiseAndExprSynth {
  final override string getOperatorImpl() { result = "&" }
}

class BitwiseOrSynthExpr extends BinaryOperationSynth, TBitwiseOrExprSynth {
  final override string getOperatorImpl() { result = "|" }
}

class BitwiseXorSynthExpr extends BinaryOperationSynth, TBitwiseXorExprSynth {
  final override string getOperatorImpl() { result = "^" }
}

abstract class AssignmentImpl extends OperationImpl, TAssignment {
  abstract Expr getLeftOperandImpl();

  abstract Expr getRightOperandImpl();

  final override Expr getAnOperandImpl() {
    result = this.getLeftOperandImpl()
    or
    result = this.getRightOperandImpl()
  }
}

class AssignExprReal extends AssignmentImpl, TAssignExprReal {
  private Ruby::Assignment g;

  AssignExprReal() { this = TAssignExprReal(g) }

  final override string getOperatorImpl() { result = "=" }

  final override Expr getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override Expr getRightOperandImpl() { toGenerated(result) = g.getRight() }
}

class AssignExprSynth extends AssignmentImpl, TAssignExprSynth {
  final override string getOperatorImpl() { result = "=" }

  final override Expr getLeftOperandImpl() { synthChild(this, 0, result) }

  final override Expr getRightOperandImpl() { synthChild(this, 1, result) }
}

class AssignOperationImpl extends AssignmentImpl, TAssignOperation {
  Ruby::OperatorAssignment g;

  AssignOperationImpl() { g = toGenerated(this) }

  final override string getOperatorImpl() { result = g.getOperator() }

  final override Expr getLeftOperandImpl() { toGenerated(result) = g.getLeft() }

  final override Expr getRightOperandImpl() { toGenerated(result) = g.getRight() }
}
