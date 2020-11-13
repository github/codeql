/**
 * @name Implicit operand conversion
 * @description Relying on implicit conversion of operands is error-prone and makes code
 *              hard to read.
 * @kind problem
 * @problem.severity warning
 * @id js/implicit-operand-conversion
 * @tags reliability
 *       readability
 *       external/cwe/cwe-704
 * @precision very-high
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * An expression that appears in a syntactic position where its value may be
 * implicitly converted.
 */
abstract class ImplicitConversion extends DataFlow::AnalyzedNode {
  Expr parent;

  ImplicitConversion() { this.asExpr() = parent.getAChildExpr() }

  /**
   * Gets a description of the type(s) to which the value `v`, which is
   * a possible runtime value of this expression, is converted.
   *
   * This predicate only considers conversions that are likely to be
   * unintentional or have unexpected results, for example `null` being
   * converted to a string as part of a string concatenation.
   */
  abstract string getAnImplicitConversionTarget(AbstractValue v);
}

/**
 * An implicit conversion with a whitelist of types for which the implicit conversion
 * is harmless.
 */
abstract class ImplicitConversionWithWhitelist extends ImplicitConversion {
  /** Gets a type for which this implicit conversion is harmless. */
  abstract InferredType getAWhitelistedType();

  /**
   * Gets a description of the type(s) to which any value of this expression
   * is converted.
   */
  abstract string getConversionTarget();

  override string getAnImplicitConversionTarget(AbstractValue v) {
    v = getAValue() and
    not v.getType() = getAWhitelistedType() and
    result = getConversionTarget()
  }
}

/**
 * Property names in `in` expressions are converted to strings,
 * so they should be strings or numbers.
 */
class PropertyNameConversion extends ImplicitConversionWithWhitelist {
  PropertyNameConversion() { this.asExpr() = parent.(InExpr).getLeftOperand() }

  override InferredType getAWhitelistedType() { result = TTString() or result = TTNumber() }

  override string getConversionTarget() { result = "string" }
}

/**
 * Property names in index expressions are converted to strings,
 * so they should be Booleans, strings or numbers.
 */
class IndexExprConversion extends ImplicitConversionWithWhitelist {
  IndexExprConversion() { this.asExpr() = parent.(IndexExpr).getIndex() }

  override InferredType getAWhitelistedType() {
    result = TTBoolean() or result = TTString() or result = TTNumber()
  }

  override string getConversionTarget() { result = "string" }
}

/**
 * Expressions that are interpreted as objects shouldn't be primitive values.
 */
class ObjectConversion extends ImplicitConversionWithWhitelist {
  ObjectConversion() {
    this.asExpr() = parent.(InExpr).getRightOperand() or
    this.asExpr() = parent.(InstanceofExpr).getLeftOperand()
  }

  override InferredType getAWhitelistedType() { result instanceof NonPrimitiveType }

  override string getConversionTarget() { result = "object" }
}

/**
 * The right-hand operand of `instanceof` should be a function or class.
 */
class ConstructorConversion extends ImplicitConversionWithWhitelist {
  ConstructorConversion() { this.asExpr() = parent.(InstanceofExpr).getRightOperand() }

  override InferredType getAWhitelistedType() { result = TTFunction() or result = TTClass() }

  override string getConversionTarget() { result = "function" }
}

/**
 * Operands of relational operators are converted to strings or numbers,
 * and hence should be strings, numbers or Dates.
 */
class RelationalOperandConversion extends ImplicitConversionWithWhitelist {
  RelationalOperandConversion() { parent instanceof RelationalComparison }

  override InferredType getAWhitelistedType() {
    result = TTString() or result = TTNumber() or result = TTDate()
  }

  override string getConversionTarget() { result = "number or string" }
}

/**
 * Operands of arithmetic and bitwise operations are converted to numbers,
 * so they should be Booleans, numbers or Dates.
 */
class NumericConversion extends ImplicitConversion {
  NumericConversion() {
    parent instanceof BitwiseExpr
    or
    parent instanceof ArithmeticExpr and not parent instanceof AddExpr
    or
    parent instanceof CompoundAssignExpr and
    not (
      parent instanceof AssignAddExpr or
      parent instanceof AssignLogOrExpr or
      parent instanceof AssignLogAndExpr or
      parent instanceof AssignNullishCoalescingExpr
    )
    or
    parent instanceof UpdateExpr
  }

  override string getAnImplicitConversionTarget(AbstractValue v) {
    v = getAValue() and
    not v.isCoercibleToNumber() and
    result = "number"
  }
}

/**
 * An expression whose value should not be `null` or `undefined`.
 */
abstract class NullOrUndefinedConversion extends ImplicitConversion {
  abstract string getConversionTarget();

  override string getAnImplicitConversionTarget(AbstractValue v) {
    v = getAValue() and
    (v instanceof AbstractNull or v instanceof AbstractUndefined) and
    result = getConversionTarget()
  }
}

/**
 * Operands of `+` or `+=` are converted to strings or numbers, and hence
 * should not be `null` or `undefined`.
 */
class PlusConversion extends NullOrUndefinedConversion {
  PlusConversion() { parent instanceof AddExpr or parent instanceof AssignAddExpr }

  override string getConversionTarget() {
    result = getDefiniteSiblingType()
    or
    not exists(getDefiniteSiblingType()) and
    result = "number or string"
  }

  /**
   * Gets the sibling of this implicit conversion.
   * E.g. if this is `a` in the expression `a + b`, then the sibling is `b`.
   */
  private Expr getSibling() { result = parent.getAChild() and not result = this.getEnclosingExpr() }

  /**
   * Gets the unique type of the sibling expression, if that type is `string` or `number`.
   */
  private string getDefiniteSiblingType() {
    result = unique(InferredType t | t = getSibling().flow().analyze().getAType()).getTypeofTag() and
    result = ["string", "number"]
  }
}

/**
 * Template literal elements are converted to strings, and hence should not
 * be `null` or `undefined`.
 */
class TemplateElementConversion extends NullOrUndefinedConversion {
  TemplateElementConversion() { parent instanceof TemplateLiteral }

  override string getConversionTarget() { result = "string" }
}

from ImplicitConversion e, string convType
where
  convType = e.getAnImplicitConversionTarget(_) and
  forall(AbstractValue v | v = e.getAValue() | exists(e.getAnImplicitConversionTarget(v)))
select e,
  "This expression will be implicitly converted from " + e.ppTypes() + " to " + convType + "."
