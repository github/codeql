/**
 * Provides classes for working with expressions that evaluate to constant values.
 */

import javascript
private import semmle.javascript.internal.CachedStages

/**
 * An expression that evaluates to a constant primitive value.
 */
cached
abstract class ConstantExpr extends Expr { }

/**
 * Provides classes for expressions that evaluate to constant values according to a bottom-up syntactic analysis.
 */
module SyntacticConstants {
  /**
   * An expression that evaluates to a constant value according to a bottom-up syntactic analysis.
   */
  cached
  abstract class SyntacticConstant extends ConstantExpr { }

  /**
   * A literal primitive expression.
   *
   * Note that `undefined`, `NaN` and `Infinity` are global variables, and are not covered by this class.
   */
  cached
  class PrimitiveLiteralConstant extends SyntacticConstant {
    cached
    PrimitiveLiteralConstant() {
      Stages::Ast::ref() and
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
  cached
  class NullConstant extends SyntacticConstant, NullLiteral {
    cached
    NullConstant() { Stages::Ast::ref() and this = this }
  }

  /**
   * A unary operation on a syntactic constant.
   */
  cached
  class UnaryConstant extends SyntacticConstant, UnaryExpr {
    cached
    UnaryConstant() { getOperand() instanceof SyntacticConstant }
  }

  /**
   * A binary operation on syntactic constants.
   */
  cached
  class BinaryConstant extends SyntacticConstant, BinaryExpr {
    cached
    BinaryConstant() {
      getLeftOperand() instanceof SyntacticConstant and
      getRightOperand() instanceof SyntacticConstant
    }
  }

  /**
   * A conditional expression on syntactic constants.
   */
  cached
  class ConditionalConstant extends SyntacticConstant, ConditionalExpr {
    cached
    ConditionalConstant() {
      getCondition() instanceof SyntacticConstant and
      getConsequent() instanceof SyntacticConstant and
      getAlternate() instanceof SyntacticConstant
    }
  }

  /**
   * A use of the global variable `undefined` or `void e`.
   */
  cached
  class UndefinedConstant extends SyntacticConstant {
    cached
    UndefinedConstant() {
      this.(GlobalVarAccess).getName() = "undefined" or
      this instanceof VoidExpr
    }
  }

  /**
   * A use of the global variable `NaN`.
   */
  cached
  class NaNConstant extends SyntacticConstant {
    cached
    NaNConstant() { this.(GlobalVarAccess).getName() = "NaN" }
  }

  /**
   * A use of the global variable `Infinity`.
   */
  cached
  class InfinityConstant extends SyntacticConstant {
    cached
    InfinityConstant() { this.(GlobalVarAccess).getName() = "Infinity" }
  }

  /**
   * An expression that wraps the syntactic constant it evaluates to.
   */
  cached
  class WrappedConstant extends SyntacticConstant {
    cached
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
cached
class ConstantString extends ConstantExpr {
  cached
  ConstantString() { exists(getStringValue()) }
}
