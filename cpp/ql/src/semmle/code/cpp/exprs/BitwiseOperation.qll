import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ unary bitwise operation.
 */
abstract class UnaryBitwiseOperation extends UnaryOperation {
}

/**
 * A C/C++ complement expression.
 */
class ComplementExpr extends UnaryBitwiseOperation, @complementexpr {
  override string getOperator() { result = "~" }

  override int getPrecedence() { result = 15 }

  override string getCanonicalQLClass() { result = "ComplementExpr" }
}

/**
 * A C/C++ binary bitwise operation.
 */
abstract class BinaryBitwiseOperation extends BinaryOperation {
}


/**
 * A C/C++ left shift expression.
 */
class LShiftExpr extends BinaryBitwiseOperation, @lshiftexpr {
  override string getOperator() { result = "<<" }

  override int getPrecedence() { result = 11 }

  override string getCanonicalQLClass() { result = "LShiftExpr" }
}

/**
 * A C/C++ right shift expression.
 */
class RShiftExpr extends BinaryBitwiseOperation, @rshiftexpr {
  override string getOperator() { result = ">>" }

  override int getPrecedence() { result = 11 }

  override string getCanonicalQLClass() { result = "RShiftExpr" }
}

/**
 * A C/C++ bitwise and expression.
 */
class BitwiseAndExpr extends BinaryBitwiseOperation, @andexpr {
  override string getOperator() { result = "&" }

  override int getPrecedence() { result = 8 }

  override string getCanonicalQLClass() { result = "BitwiseAndExpr" }
}

/**
 * A C/C++ bitwise or expression.
 */
class BitwiseOrExpr extends BinaryBitwiseOperation, @orexpr {
  override string getOperator() { result = "|" }

  override int getPrecedence() { result = 6 }

  override string getCanonicalQLClass() { result = "BitwiseOrExpr" }
}

/**
 * A C/C++ bitwise xor expression.
 */
class BitwiseXorExpr extends BinaryBitwiseOperation, @xorexpr {
  override string getOperator() { result = "^" }

  override int getPrecedence() { result = 7 }
  
  override string getCanonicalQLClass() { result = "BitwiseXorExpr" }
}
