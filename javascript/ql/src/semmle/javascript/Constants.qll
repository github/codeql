/**
 * Provides classes for working with expressions that evaluate to constant values.
 */

import javascript

/**
 * An expression that evaluates to a constant primitive value.
 */
abstract class ConstantExpr extends Expr { }

/**
 * Provides classes for expressions that evaluate to constant values according to a bottom-up syntactic analysis.
 */
module SyntacticConstants {
  /**
   * An expression that evaluates to a constant value according to a bottom-up syntactic analysis.
   */
  abstract class SyntacticConstant extends ConstantExpr { }

  /**
   * A literal primitive expression.
   *
   * Note that `undefined`, `NaN` and `Infinity` are global variables, and are not covered by this class.
   */
  class PrimitiveLiteralConstant extends SyntacticConstant {
    PrimitiveLiteralConstant() {
      this instanceof NumberLiteral
      or
      this instanceof StringLiteral
      or
      this instanceof BooleanLiteral
      or
      exists(TemplateLiteral lit | lit = this |
        lit.getNumChildExpr() = 0
        or
        lit.getNumChildExpr() = 1 and
        lit.getElement(0) instanceof TemplateElement
      )
    }
  }

  /**
   * A literal null expression.
   */
  class NullConstant extends SyntacticConstant, NullLiteral { }

  /**
   * A unary operation on a syntactic constant.
   */
  class UnaryConstant extends SyntacticConstant, UnaryExpr {
    UnaryConstant() { getOperand() instanceof SyntacticConstant }
  }

  /**
   * A binary operation on syntactic constants.
   */
  class BinaryConstant extends SyntacticConstant, BinaryExpr {
    BinaryConstant() {
      getLeftOperand() instanceof SyntacticConstant and
      getRightOperand() instanceof SyntacticConstant
    }
  }

  /**
   * A conditional expression on syntactic constants.
   */
  class ConditionalConstant extends SyntacticConstant, ConditionalExpr {
    ConditionalConstant() {
      getCondition() instanceof SyntacticConstant and
      getConsequent() instanceof SyntacticConstant and
      getAlternate() instanceof SyntacticConstant
    }
  }

  /**
   * A use of the global variable `undefined` or `void e`.
   */
  class UndefinedConstant extends SyntacticConstant {
    UndefinedConstant() {
      this.(GlobalVarAccess).getName() = "undefined" or
      this instanceof VoidExpr
    }
  }

  /**
   * A use of the global variable `NaN`.
   */
  class NaNConstant extends SyntacticConstant {
    NaNConstant() { this.(GlobalVarAccess).getName() = "NaN" }
  }

  /**
   * A use of the global variable `Infinity`.
   */
  class InfinityConstant extends SyntacticConstant {
    InfinityConstant() { this.(GlobalVarAccess).getName() = "Infinity" }
  }

  /**
   * An expression that wraps the syntactic constant it evaluates to.
   */
  class WrappedConstant extends SyntacticConstant {
    WrappedConstant() { getUnderlyingValue() instanceof SyntacticConstant }
  }

  /**
   * Holds if `c` evaluates to `undefined`.
   */
  predicate isUndefined(SyntacticConstant c) { c.getUnderlyingValue() instanceof UndefinedConstant }

  /**
   * Holds if `c` evaluates to `null`.
   */
  predicate isNull(SyntacticConstant c) { c.getUnderlyingValue() instanceof NullConstant }

  /**
   * Holds if `c` evaluates to `null` or `undefined`.
   */
  predicate isNullOrUndefined(SyntacticConstant c) { isUndefined(c) or isNull(c) }
}

/**
 * An expression that evaluates to a constant string.
 */
class ConstantString extends ConstantExpr {
  ConstantString() { exists(getStringValue()) }
}
