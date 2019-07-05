import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ arithmetic operation.
 */
abstract class UnaryArithmeticOperation extends UnaryOperation {
}

/**
 * A C/C++ unary minus expression.
 */
class UnaryMinusExpr extends UnaryArithmeticOperation, @arithnegexpr {
  override string getOperator() { result = "-" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "UnaryMinusExpr" }
  
  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ unary plus expression.
 */
class UnaryPlusExpr extends UnaryArithmeticOperation, @unaryplusexpr {
  override string getOperator() { result = "+" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "UnaryPlusExpr" }
  
  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ GNU conjugation expression.
 */
class ConjugationExpr extends UnaryArithmeticOperation, @conjugation {
  override string getOperator() { result = "~" }
}

/**
 * A C/C++ `++` or `--` expression (either prefix or postfix).
 *
 * Note that this doesn't include calls to user-defined `operator++`
 * or `operator--`.
 */
abstract class CrementOperation extends UnaryArithmeticOperation {
  override predicate mayBeImpure() {
    any()
  }
  override predicate mayBeGloballyImpure() {
    not exists(VariableAccess va, LocalScopeVariable v |
               va = this.getOperand()
               and v = va.getTarget()
               and not va.getConversion+() instanceof ReferenceDereferenceExpr
               and not v.isStatic())
  }
}

/**
 * A C/C++ `++` expression (either prefix or postfix).
 *
 * Note that this doesn't include calls to user-defined `operator++`.
 */
abstract class IncrementOperation extends CrementOperation {
}

/**
 * A C/C++ `--` expression (either prefix or postfix).
 *
 * Note that this doesn't include calls to user-defined `operator--`.
 */
abstract class DecrementOperation extends CrementOperation {
}

/**
 * A C/C++ `++` or `--` prefix expression.
 *
 * Note that this doesn't include calls to user-defined operators.
 */
abstract class PrefixCrementOperation extends CrementOperation {
}

/**
 * A C/C++ `++` or `--` postfix expression.
 *
 * Note that this doesn't include calls to user-defined operators.
 */
abstract class PostfixCrementOperation extends CrementOperation {
}

/**
 * A C/C++ prefix increment expression, as in `++x`.
 *
 * Note that this doesn't include calls to user-defined `operator++`.
 */
class PrefixIncrExpr extends IncrementOperation, PrefixCrementOperation, @preincrexpr {
  override string getOperator() { result = "++" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PrefixIncrExpr" }
  
  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ prefix decrement expression, as in `--x`.
 *
 * Note that this doesn't include calls to user-defined `operator--`.
 */
class PrefixDecrExpr extends DecrementOperation, PrefixCrementOperation, @predecrexpr {
  override string getOperator() { result = "--" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PrefixDecrExpr" }
  
  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ postfix increment expression, as in `x++`.
 *
 * Note that this doesn't include calls to user-defined `operator++`.
 */
class PostfixIncrExpr extends IncrementOperation, PostfixCrementOperation, @postincrexpr {
  override string getOperator() { result = "++" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PostfixIncrExpr" }
  
  override int getPrecedence() { result = 16 }

  override string toString() { result = "... " + getOperator() }
}

/**
 * A C/C++ postfix decrement expression, as in `x--`.
 *
 * Note that this doesn't include calls to user-defined `operator--`.
 */
class PostfixDecrExpr extends DecrementOperation, PostfixCrementOperation, @postdecrexpr {
  override string getOperator() { result = "--" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PostfixDecrExpr" }
  
  override int getPrecedence() { result = 16 }

  override string toString() { result = "... " + getOperator() }
}

/**
 * A C/C++ GNU real part expression.
 */
class RealPartExpr extends UnaryArithmeticOperation, @realpartexpr {
  override string getOperator() { result = "__real" }
}

/**
 * A C/C++ GNU imaginary part expression.
 */
class ImaginaryPartExpr extends UnaryArithmeticOperation, @imagpartexpr {
  override string getOperator() { result = "__imag" }
}

/**
 * A C/C++ binary arithmetic operation.
 */
abstract class BinaryArithmeticOperation extends BinaryOperation {
}

/**
 * A C/C++ add expression.
 */
class AddExpr extends BinaryArithmeticOperation, @addexpr {
  override string getOperator() { result = "+" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "AddExpr" }
  
  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression.
 */
class SubExpr extends BinaryArithmeticOperation, @subexpr {
  override string getOperator() { result = "-" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "SubExpr" }
  
  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ multiply expression.
 */
class MulExpr extends BinaryArithmeticOperation, @mulexpr {
  override string getOperator() { result = "*" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "MulExpr" }
  
  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ divide expression.
 */
class DivExpr extends BinaryArithmeticOperation, @divexpr {
  override string getOperator() { result = "/" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "DivExpr" }
  
  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ remainder expression.
 */
class RemExpr extends BinaryArithmeticOperation, @remexpr {
  override string getOperator() { result = "%" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "RemExpr" }
  
  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ multiply expression with an imaginary number.
 */
class ImaginaryMulExpr extends BinaryArithmeticOperation, @jmulexpr {
  override string getOperator() { result = "*" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ divide expression with an imaginary number.
 */
class ImaginaryDivExpr extends BinaryArithmeticOperation, @jdivexpr {
  override string getOperator() { result = "/" }

  override int getPrecedence() { result = 13 }
}

/**
 * A C/C++ add expression with a real term and an imaginary term.
 */
class RealImaginaryAddExpr extends BinaryArithmeticOperation, @fjaddexpr {
  override string getOperator() { result = "+" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ add expression with an imaginary term and a real term.
 */
class ImaginaryRealAddExpr extends BinaryArithmeticOperation, @jfaddexpr {
  override string getOperator() { result = "+" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression with a real term and an imaginary term.
 */
class RealImaginarySubExpr extends BinaryArithmeticOperation, @fjsubexpr {
  override string getOperator() { result = "-" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ subtract expression with an imaginary term and a real term.
 */
class ImaginaryRealSubExpr extends BinaryArithmeticOperation, @jfsubexpr {
  override string getOperator() { result = "-" }

  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ GNU min expression.
 */
class MinExpr extends BinaryArithmeticOperation, @minexpr {
  override string getOperator() { result = "<?" }
}

/**
 * A C/C++ GNU max expression.
 */
class MaxExpr extends BinaryArithmeticOperation, @maxexpr {
  override string getOperator() { result = ">?" }
}

/**
 * A C/C++ pointer arithmetic operation.
 */
abstract class PointerArithmeticOperation extends BinaryArithmeticOperation {
}

/**
 * A C/C++ pointer add expression.
 */
class PointerAddExpr extends PointerArithmeticOperation, @paddexpr {
  override string getOperator() { result = "+" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PointerAddExpr" }
  
  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ pointer subtract expression.
 */
class PointerSubExpr extends PointerArithmeticOperation, @psubexpr {
  override string getOperator() { result = "-" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PointerSubExpr" }
  
  override int getPrecedence() { result = 12 }
}

/**
 * A C/C++ pointer difference expression.
 */
class PointerDiffExpr extends PointerArithmeticOperation, @pdiffexpr {
  override string getOperator() { result = "-" }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "PointerDiffExpr" }
  
  override int getPrecedence() { result = 12 }
}
