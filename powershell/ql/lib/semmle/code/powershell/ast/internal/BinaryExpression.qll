private import AstImport

/**
 * A binary expression. For example:
 * ```
 * $sum = $a + $b
 * $isEqual = $name -eq "John"
 * $isActive = $user.Status -and $user.IsEnabled
 * ```
 */
class BinaryExpr extends Expr, TBinaryExpr {
  /** INTERNAL: Do not use. */
  int getKind() { result = getRawAst(this).(Raw::BinaryExpr).getKind() }

  Expr getLeft() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, binaryExprLeft(), result)
      or
      not synthChild(r, binaryExprLeft(), _) and
      result = getResultAst(r.(Raw::BinaryExpr).getLeft())
    )
  }

  Expr getRight() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, binaryExprRight(), result)
      or
      not synthChild(r, binaryExprRight(), _) and
      result = getResultAst(r.(Raw::BinaryExpr).getRight())
    )
  }

  Expr getAnOperand() { result = this.getLeft() or result = this.getRight() }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = binaryExprLeft() and
    result = this.getLeft()
    or
    i = binaryExprRight() and
    result = this.getRight()
  }
}

abstract private class AbstractArithmeticExpr extends BinaryExpr { }

final class ArithmeticExpr = AbstractArithmeticExpr;

/**
 * An addition expression. For example:
 * ```
 * $sum = $a + $b
 * $concatenated = "Hello " + "World"
 * ```
 */
class AddExpr extends AbstractArithmeticExpr {
  AddExpr() { this.getKind() = 40 }

  final override string toString() { result = "...+..." }
}

/**
 * A subtraction expression. For example:
 * ```
 * $difference = $a - $b
 * $remaining = $total - $used
 * ```
 */
class SubExpr extends AbstractArithmeticExpr {
  SubExpr() { this.getKind() = 41 }

  final override string toString() { result = "...-..." }
}

/**
 * A multiplication expression. For example:
 * ```
 * $product = $a * $b
 * $repeated = "Hello" * 3
 * ```
 */
class MulExpr extends AbstractArithmeticExpr {
  MulExpr() { this.getKind() = 37 }

  final override string toString() { result = "...*..." }
}

/**
 * A division expression. For example:
 * ```
 * $quotient = $a / $b
 * $percentage = $part / $total
 * ```
 */
class DivExpr extends AbstractArithmeticExpr {
  DivExpr() { this.getKind() = 38 }

  final override string toString() { result = ".../..." }
}

/**
 * A remainder (modulo) expression. For example:
 * ```
 * $remainder = $a % $b
 * $isEven = ($number % 2) -eq 0
 * ```
 */
class RemExpr extends AbstractArithmeticExpr {
  RemExpr() { this.getKind() = 39 }

  final override string toString() { result = "...%..." }
}

abstract private class AbstractBitwiseExpr extends BinaryExpr { }

final class BitwiseExpr = AbstractBitwiseExpr;

/**
 * A bitwise AND expression. For example:
 * ```
 * $result = $flags1 -band $flags2
 * $masked = $value -band 0xFF
 * ```
 */
class BitwiseAndExpr extends AbstractBitwiseExpr {
  BitwiseAndExpr() { this.getKind() = 56 }

  final override string toString() { result = "...&..." }
}

/**
 * A bitwise OR expression. For example:
 * ```
 * $result = $flags1 -bor $flags2
 * $combined = $permissions -bor 0x04
 * ```
 */
class BitwiseOrExpr extends AbstractBitwiseExpr {
  BitwiseOrExpr() { this.getKind() = 57 }

  final override string toString() { result = "...|..." }
}

/**
 * A bitwise XOR expression. For example:
 * ```
 * $result = $flags1 -bxor $flags2
 * $toggled = $state -bxor 1
 * ```
 */
class BitwiseXorExpr extends AbstractBitwiseExpr {
  BitwiseXorExpr() { this.getKind() = 58 }

  final override string toString() { result = "...^..." }
}

/**
 * A bitwise left shift expression. For example:
 * ```
 * $result = $value -shl 2
 * $multiplied = $number -shl 1
 * ```
 */
class ShiftLeftExpr extends AbstractBitwiseExpr {
  ShiftLeftExpr() { this.getKind() = 97 }

  final override string toString() { result = "...<<..." }
}

/**
 * A bitwise right shift expression. For example:
 * ```
 * $result = $value -shr 2
 * $divided = $number -shr 1
 * ```
 */
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

/**
 * A case-insensitive equality expression. For example:
 * ```
 * $isEqual = $name -eq "John"
 * $isZero = $count -eq 0
 * ```
 */
class EqExpr extends AbstractCaseInsensitiveComparisonExpr {
  EqExpr() { this.getKind() = 60 }

  final override string toString() { result = "... -eq ..." }
}

/**
 * A case-insensitive inequality expression. For example:
 * ```
 * $isDifferent = $name -ne "John"
 * $isNonZero = $count -ne 0
 * ```
 */
class NeExpr extends AbstractCaseInsensitiveComparisonExpr {
  NeExpr() { this.getKind() = 61 }

  final override string toString() { result = "... -ne ..." }
}

/**
 * A case-sensitive equality expression. For example:
 * ```
 * $isEqual = $name -ceq "John"
 * $exactMatch = $password -ceq "SecretPass"
 * ```
 */
class CEqExpr extends AbstractCaseSensitiveComparisonExpr {
  CEqExpr() { this.getKind() = 76 }

  final override string toString() { result = "... -ceq ..." }
}

/**
 * A case-sensitive inequality expression. For example:
 * ```
 * $isDifferent = $name -cne "John"
 * $wrongPassword = $password -cne "SecretPass"
 * ```
 */
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

/**
 * A like pattern matching expression. For example:
 * ```
 * $matches = $filename -like "*.txt"
 * $isValidEmail = $email -like "*@*.com"
 * ```
 */
class LikeExpr extends AbstractCaseInsensitiveComparisonExpr {
  LikeExpr() { this.getKind() = 66 }

  final override string toString() { result = "... -like ..." }
}

class NotLikeExpr extends AbstractCaseInsensitiveComparisonExpr {
  NotLikeExpr() { this.getKind() = 67 }

  final override string toString() { result = "... -notlike ..." }
}

/**
 * A regex pattern matching expression. For example:
 * ```
 * $matches = $text -match "\d{3}-\d{2}-\d{4}"
 * $isEmail = $input -match "^[^@]+@[^@]+\.[^@]+$"
 * ```
 */
class MatchExpr extends AbstractCaseInsensitiveComparisonExpr {
  MatchExpr() { this.getKind() = 68 }

  final override string toString() { result = "... -match ..." }
}

class NotMatchExpr extends AbstractCaseInsensitiveComparisonExpr {
  NotMatchExpr() { this.getKind() = 69 }

  final override string toString() { result = "... -notmatch ..." }
}

/**
 * A string replacement expression. For example:
 * ```
 * $cleaned = $text -replace "\s+", " "
 * $updated = $path -replace "\\", "/"
 * ```
 */
class ReplaceExpr extends AbstractCaseInsensitiveComparisonExpr {
  ReplaceExpr() { this.getKind() = 70 }

  final override string toString() { result = "... -replace ..." }
}

abstract class AbstractTypeExpr extends BinaryExpr { }

final class TypeExpr = AbstractTypeExpr;

abstract class AbstractTypeComparisonExpr extends AbstractTypeExpr { }

final class TypeComparisonExpr = AbstractTypeComparisonExpr;

/**
 * A type checking expression. For example:
 * ```
 * $isString = $value -is [string]
 * $isArray = $data -is [array]
 * ```
 */
class IsExpr extends AbstractTypeComparisonExpr {
  IsExpr() { this.getKind() = 92 }

  final override string toString() { result = "... -is ..." }
}

class IsNotExpr extends AbstractTypeComparisonExpr {
  IsNotExpr() { this.getKind() = 93 }

  final override string toString() { result = "... -isnot ..." }
}

/**
 * A type conversion expression. For example:
 * ```
 * $number = $stringValue -as [int]
 * $date = $text -as [datetime]
 * ```
 */
class AsExpr extends AbstractTypeExpr {
  AsExpr() { this.getKind() = 94 }

  final override string toString() { result = "... -as ..." }
}

abstract private class AbstractContainmentExpr extends BinaryExpr { }

final class ContainmentExpr = AbstractContainmentExpr;

abstract private class AbstractCaseInsensitiveContainmentExpr extends AbstractContainmentExpr { }

final class CaseInsensitiveContainmentExpr = AbstractCaseInsensitiveContainmentExpr;

/**
 * A containment check expression. For example:
 * ```
 * $hasItem = $list -contains $item
 * $isValidOption = @("Yes", "No", "Maybe") -contains $choice
 * ```
 */
class ContainsExpr extends AbstractCaseInsensitiveContainmentExpr {
  ContainsExpr() { this.getKind() = 71 }

  final override string toString() { result = "... -contains ..." }
}

class NotContainsExpr extends AbstractCaseInsensitiveContainmentExpr {
  NotContainsExpr() { this.getKind() = 72 }

  final override string toString() { result = "... -notcontains ..." }
}

/**
 * A membership check expression. For example:
 * ```
 * $isValidChoice = $choice -in @("Yes", "No", "Maybe")
 * $isWeekend = $dayOfWeek -in @("Saturday", "Sunday")
 * ```
 */
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

/**
 * A logical AND expression. For example:
 * ```
 * $isValid = $isActive -and $hasPermission
 * $canProceed = ($count -gt 0) -and ($status -eq "Ready")
 * ```
 */
class LogicalAndExpr extends AbstractLogicalBinaryExpr {
  LogicalAndExpr() { this.getKind() = 53 }

  final override string toString() { result = "... -and ..." }
}

/**
 * A logical OR expression. For example:
 * ```
 * $shouldProcess = $isUrgent -or $isHighPriority
 * $hasAccess = ($isAdmin -or $isOwner) -and $isActive
 * ```
 */
class LogicalOrExpr extends AbstractLogicalBinaryExpr {
  LogicalOrExpr() { this.getKind() = 54 }

  final override string toString() { result = "... -or ..." }
}

/**
 * A logical XOR expression. For example:
 * ```
 * $exclusiveChoice = $option1 -xor $option2
 * $toggle = $currentState -xor $true
 * ```
 */
class LogicalXorExpr extends AbstractLogicalBinaryExpr {
  LogicalXorExpr() { this.getKind() = 55 }

  final override string toString() { result = "... -xor ..." }
}

/**
 * A string join expression. For example:
 * ```
 * $result = $array -join ","
 * $path = $pathParts -join "\"
 * ```
 */
class JoinExpr extends BinaryExpr {
  JoinExpr() { this.getKind() = 59 }

  final override string toString() { result = "... -join ..." }
}

class SequenceExpr extends BinaryExpr {
  SequenceExpr() { this.getKind() = 33 }

  final override string toString() { result = "[..]" }
}

/**
 * A format string expression. For example:
 * ```
 * $formatted = "Hello {0}, you have {1} messages" -f $name, $count
 * $output = "Value: {0:N2}" -f $number
 * ```
 */
class FormatExpr extends BinaryExpr {
  FormatExpr() { this.getKind() = 50 }

  final override string toString() { result = "... -f ..." }
}
