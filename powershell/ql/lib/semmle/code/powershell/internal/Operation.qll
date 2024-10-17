import powershell

module Private {
  abstract private class AbstractOperation extends Expr {
    abstract Expr getAnOperand();

    abstract int getKind();
  }

  class BinaryOperation extends BinaryExpr, AbstractOperation {
    final override Expr getAnOperand() { result = BinaryExpr.super.getAnOperand() }

    final override int getKind() { result = BinaryExpr.super.getKind() }
  }

  class UnaryOperation extends UnaryExpr, AbstractOperation {
    final override Expr getAnOperand() { result = UnaryExpr.super.getOperand() }

    final override int getKind() { result = UnaryExpr.super.getKind() }
  }

  final class Operation = AbstractOperation;
}

module Public {
  class Operation = Private::Operation;

  class BinaryOperation = Private::BinaryOperation;

  class UnaryOperation = Private::UnaryOperation;
}
