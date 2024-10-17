import powershell

class BinaryExpr extends @binary_expression, Expr {
  override SourceLocation getLocation() { binary_expression_location(this, result) }

  int getKind() { binary_expression(this, result, _, _) }

  /** Gets an operand of this binary expression. */
  Expr getAnOperand() {
    result = this.getLeft()
    or
    result = this.getRight()
  }

  /** Holds if this binary expression has the operands `e1` and `e2`. */
  predicate hasOperands(Expr e1, Expr e2) {
    e1 = this.getLeft() and
    e2 = this.getRight()
    or
    e1 = this.getRight() and
    e2 = this.getLeft()
  }

  Expr getLeft() { binary_expression(this, _, result, _) }

  Expr getRight() { binary_expression(this, _, _, result) }
}

abstract private class AbstractArithmeticExpr extends BinaryExpr { }

final class ArithmeticExpr = AbstractArithmeticExpr;

class AddExpr extends AbstractArithmeticExpr {
  AddExpr() { this.getKind() = 40 }

  final override string toString() { result = "...+..." }
}

class SubExpr extends AbstractArithmeticExpr {
  SubExpr() { this.getKind() = 41 }

  final override string toString() { result = "...-..." }
}

class MulExpr extends AbstractArithmeticExpr {
  MulExpr() { this.getKind() = 37 }

  final override string toString() { result = "...*..." }
}

class DivExpr extends AbstractArithmeticExpr {
  DivExpr() { this.getKind() = 38 }

  final override string toString() { result = ".../..." }
}

class RemExpr extends AbstractArithmeticExpr {
  RemExpr() { this.getKind() = 39 }

  final override string toString() { result = "...%..." }
}

abstract private class AbstractBitwiseExpr extends BinaryExpr { }

final class BitwiseExpr = AbstractBitwiseExpr;

class BitwiseAndExpr extends AbstractBitwiseExpr {
  BitwiseAndExpr() { this.getKind() = 56 }

  final override string toString() { result = "...&..." }
}

class BitwiseOrExpr extends AbstractBitwiseExpr {
  BitwiseOrExpr() { this.getKind() = 57 }

  final override string toString() { result = "...|..." }
}

class BitwiseXorExpr extends AbstractBitwiseExpr {
  BitwiseXorExpr() { this.getKind() = 58 }

  final override string toString() { result = "...^..." }
}

class ShiftLeftExpr extends AbstractBitwiseExpr {
  ShiftLeftExpr() { this.getKind() = 97 }

  final override string toString() { result = "...<<..." }
}

class ShiftRightExpr extends AbstractBitwiseExpr {
  ShiftRightExpr() { this.getKind() = 98 }

  final override string toString() { result = "...>>..." }
}

abstract private class AbstractComparisonExpr extends BinaryExpr { }

final class ComparisonExpr = AbstractComparisonExpr;

abstract private class AbstractCaseInsensitiveComparisonExpr extends AbstractComparisonExpr { }

final class CaseInsensitiveComparisonExpr = AbstractCaseInsensitiveComparisonExpr;

abstract private class AbstractCaseSensitiveComparisonExpr extends AbstractComparisonExpr { }

final class CaseSensitiveComparisonExpr = AbstractCaseSensitiveComparisonExpr;

class EqExpr extends AbstractCaseInsensitiveComparisonExpr {
  EqExpr() { this.getKind() = 60 }

  final override string toString() { result = "... -eq ..." }
}

class NeExpr extends AbstractCaseInsensitiveComparisonExpr {
  NeExpr() { this.getKind() = 61 }

  final override string toString() { result = "... -ne ..." }
}

class CEqExpr extends AbstractCaseSensitiveComparisonExpr {
  CEqExpr() { this.getKind() = 76 }

  final override string toString() { result = "... -ceq ..." }
}

class CNeExpr extends AbstractCaseSensitiveComparisonExpr {
  CNeExpr() { this.getKind() = 77 }

  final override string toString() { result = "... -cne ..." }
}

abstract private class AbstractRelationalExpr extends AbstractComparisonExpr { }

final class RelationalExpr = AbstractRelationalExpr;

abstract private class AbstractCaseInsensitiveRelationalExpr extends AbstractRelationalExpr { }

final class CaseInsensitiveRelationalExpr = AbstractCaseInsensitiveRelationalExpr;

abstract private class AbstractCaseSensitiveRelationalExpr extends AbstractRelationalExpr { }

final class CaseSensitiveRelationalExpr = AbstractCaseSensitiveRelationalExpr;

class GeExpr extends AbstractCaseInsensitiveRelationalExpr {
  GeExpr() { this.getKind() = 62 }

  final override string toString() { result = "... -ge ..." }
}

class GtExpr extends AbstractCaseInsensitiveRelationalExpr {
  GtExpr() { this.getKind() = 63 }

  final override string toString() { result = "... -gt ..." }
}

class LtExpr extends AbstractCaseInsensitiveRelationalExpr {
  LtExpr() { this.getKind() = 64 }

  final override string toString() { result = "... -lt ..." }
}

class LeExpr extends AbstractCaseInsensitiveRelationalExpr {
  LeExpr() { this.getKind() = 65 }

  final override string toString() { result = "... -le ..." }
}

class CGeExpr extends AbstractCaseSensitiveRelationalExpr {
  CGeExpr() { this.getKind() = 78 }

  final override string toString() { result = "... -cge ..." }
}

class CGtExpr extends AbstractCaseSensitiveRelationalExpr {
  CGtExpr() { this.getKind() = 79 }

  final override string toString() { result = "... -cgt ..." }
}

class CLtExpr extends AbstractCaseSensitiveRelationalExpr {
  CLtExpr() { this.getKind() = 80 }

  final override string toString() { result = "... -clt ..." }
}

class CLeExpr extends AbstractCaseSensitiveRelationalExpr {
  CLeExpr() { this.getKind() = 81 }

  final override string toString() { result = "... -cle ..." }
}

class LikeExpr extends AbstractCaseInsensitiveComparisonExpr {
  LikeExpr() { this.getKind() = 66 }

  final override string toString() { result = "... -like ..." }
}

class NotLikeExpr extends AbstractCaseInsensitiveComparisonExpr {
  NotLikeExpr() { this.getKind() = 67 }

  final override string toString() { result = "... -notlike ..." }
}

class MatchExpr extends AbstractCaseInsensitiveComparisonExpr {
  MatchExpr() { this.getKind() = 68 }

  final override string toString() { result = "... -match ..." }
}

class NotMatchExpr extends AbstractCaseInsensitiveComparisonExpr {
  NotMatchExpr() { this.getKind() = 69 }

  final override string toString() { result = "... -notmatch ..." }
}

class ReplaceExpr extends AbstractCaseInsensitiveComparisonExpr {
  ReplaceExpr() { this.getKind() = 70 }

  final override string toString() { result = "... -replace ..." }
}

abstract class AbstractTypeExpr extends BinaryExpr { }

final class TypeExpr = AbstractTypeExpr;

abstract class AbstractTypeComparisonExpr extends AbstractTypeExpr { }

final class TypeComparisonExpr = AbstractTypeComparisonExpr;

class IsExpr extends AbstractTypeComparisonExpr {
  IsExpr() { this.getKind() = 92 }

  final override string toString() { result = "... -is ..." }
}

class IsNotExpr extends AbstractTypeComparisonExpr {
  IsNotExpr() { this.getKind() = 93 }

  final override string toString() { result = "... -isnot ..." }
}

class AsExpr extends AbstractTypeExpr {
  AsExpr() { this.getKind() = 94 }

  final override string toString() { result = "... -as ..." }
}

abstract private class AbstractContainmentExpr extends BinaryExpr { }

final class ContainmentExpr = AbstractContainmentExpr;

abstract private class AbstractCaseInsensitiveContainmentExpr extends AbstractContainmentExpr { }

final class CaseInsensitiveContainmentExpr = AbstractCaseInsensitiveContainmentExpr;

class ContainsExpr extends AbstractCaseInsensitiveContainmentExpr {
  ContainsExpr() { this.getKind() = 71 }

  final override string toString() { result = "... -contains ..." }
}

class NotContainsExpr extends AbstractCaseInsensitiveContainmentExpr {
  NotContainsExpr() { this.getKind() = 72 }

  final override string toString() { result = "... -notcontains ..." }
}

class InExpr extends AbstractCaseInsensitiveContainmentExpr {
  InExpr() { this.getKind() = 73 }

  final override string toString() { result = "... -in ..." }
}

class NotInExpr extends AbstractCaseInsensitiveContainmentExpr {
  NotInExpr() { this.getKind() = 74 }

  final override string toString() { result = "... -notin ..." }
}

abstract private class AbstractLogicalBinaryExpr extends BinaryExpr { }

final class LogicalBinaryExpr = AbstractLogicalBinaryExpr;

class LogicalAndExpr extends AbstractLogicalBinaryExpr {
  LogicalAndExpr() { this.getKind() = 53 }

  final override string toString() { result = "... -and ..." }
}

class LogicalOrExpr extends AbstractLogicalBinaryExpr {
  LogicalOrExpr() { this.getKind() = 54 }

  final override string toString() { result = "... -or ..." }
}

class LogicalXorExpr extends AbstractLogicalBinaryExpr {
  LogicalXorExpr() { this.getKind() = 55 }

  final override string toString() { result = "... -xor ..." }
}

class JoinExpr extends BinaryExpr {
  JoinExpr() { this.getKind() = 59 }

  final override string toString() { result = "... -join ..." }
}

class SequenceExpr extends BinaryExpr {
  SequenceExpr() { this.getKind() = 33 }

  final override string toString() { result = "[..]" }
}

class FormatExpr extends BinaryExpr {
  FormatExpr() { this.getKind() = 50 }

  final override string toString() { result = "... -f ..." }
}
