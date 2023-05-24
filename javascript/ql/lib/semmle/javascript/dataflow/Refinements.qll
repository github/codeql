/**
 * INTERNAL: This is an internal library; its interface may change without notice.
 *
 * Provides classes for working with variable refinements.
 *
 * Variable refinements are expressions that appear in a guard node
 * (such as an `if` condition) and can be used to refine the information
 * derived about a variable by the flow analysis. Each refinement only
 * refines a single variable, and only certain simple constructs are
 * considered (primarily `typeof` expressions and comparisons).
 *
 * To perform the refinement, the expression is evaluated to a
 * `RefinementValue`, which is a more fine-grained version of `AbstractValue`
 * that distinguishes individual constants value. This evaluation takes place
 * in a context that restricts the value of the refined variable to a single
 * candidate value, which is one of the `AbstractValue`s that the flow analysis
 * infers for it.
 *
 * If the expression evaluates to a refinement value that represents `true`,
 * then the candidate value passes the refinement. Hence, it can be propagated
 * across a condition guard with outcome `true`.
 *
 * Conversely, if it evaluates to `false`, the candidate value can be propagated
 * across a condition guard with outcome `false`.
 *
 * Note that, like all abstract values, refinement values are overapproximations,
 * so the refinement can evaluate to both `true` and `false` for the same
 * candidate value.
 */

import javascript
private import AbstractValues
private import InferredTypes

/**
 * An expression that has the right syntactic structure to be used to
 * refine the abstract values inferred for a variable.
 */
abstract class RefinementCandidate extends Expr {
  /**
   * Gets a variable that is referenced somewhere in this expression.
   */
  abstract SsaSourceVariable getARefinedVar();

  /**
   * Gets a refinement value inferred for this expression in context `ctxt`.
   */
  pragma[nomagic]
  abstract RefinementValue eval(RefinementContext ctxt);
}

/**
 * A refinement candidate that references at most one variable, and hence
 * can be used to refine the abstract values inferred for that variable.
 */
class Refinement extends Expr instanceof RefinementCandidate {
  Refinement() { count(this.(RefinementCandidate).getARefinedVar()) <= 1 }

  /**
   * Gets the variable refined by this expression, if any.
   */
  SsaSourceVariable getRefinedVar() { result = super.getARefinedVar() }

  /**
   * Gets a refinement value inferred for this expression in context `ctxt`.
   */
  RefinementValue eval(RefinementContext ctxt) { result = super.eval(ctxt) }
}

/** A literal, viewed as a refinement expression. */
abstract private class LiteralRefinement extends RefinementCandidate, Literal {
  override SsaSourceVariable getARefinedVar() { none() }

  override RefinementValue eval(RefinementContext ctxt) {
    ctxt.appliesTo(this) and result = this.eval()
  }

  /**
   * Gets the refinement value that represents this literal.
   */
  RefinementValue eval() { result = TAny() }
}

/** A `null` literal, viewed as a refinement expression. */
private class NullLiteralRefinement extends LiteralRefinement, NullLiteral {
  override RefinementValue eval() { result = TValueWithType(TTNull()) }
}

/** A Boolean literal, viewed as a refinement expression. */
private class BoolRefinement extends LiteralRefinement, BooleanLiteral {
  override RefinementValue eval() {
    exists(boolean b | b.toString() = this.getValue() | result = TBoolConstant(b))
  }
}

/** A constant string, viewed as a refinement expression. */
private class StringRefinement extends LiteralRefinement, ConstantString {
  override RefinementValue eval() { result = TStringConstant(this.getStringValue()) }
}

/** A numeric literal, viewed as a refinement expression. */
abstract private class NumberRefinement extends LiteralRefinement, NumberLiteral {
  override RefinementValue eval() { result = TValueWithType(TTNumber()) }
}

/**
 * An integer literal, viewed as a refinement expression.
 *
 * At the moment, we only refine with the integer zero, not with any
 * other integer values.
 */
private class IntRefinement extends NumberRefinement, NumberLiteral {
  IntRefinement() { this.getValue().toInt() = 0 }

  override RefinementValue eval() { result = TIntConstant(this.getValue().toInt()) }
}

/**
 * A use of the global variable `undefined`, viewed as a refinement expression.
 */
private class UndefinedInRefinement extends RefinementCandidate,
  SyntacticConstants::UndefinedConstant
{
  override SsaSourceVariable getARefinedVar() { none() }

  override RefinementValue eval(RefinementContext ctxt) {
    ctxt.appliesTo(this) and
    result = TValueWithType(TTUndefined())
  }
}

/** A variable use, viewed as a refinement expression. */
private class VariableRefinement extends RefinementCandidate, VarUse {
  VariableRefinement() { this.getVariable() instanceof SsaSourceVariable }

  override SsaSourceVariable getARefinedVar() { result = this.getVariable() }

  override RefinementValue eval(RefinementContext ctxt) {
    ctxt.appliesTo(this) and
    result = ctxt.(VarRefinementContext).getAValue()
  }
}

/** A parenthesized refinement expression. */
private class ParRefinement extends RefinementCandidate, ParExpr {
  ParRefinement() { this.getExpression() instanceof RefinementCandidate }

  override SsaSourceVariable getARefinedVar() {
    result = this.getExpression().(RefinementCandidate).getARefinedVar()
  }

  override RefinementValue eval(RefinementContext ctxt) {
    result = this.getExpression().(RefinementCandidate).eval(ctxt)
  }
}

/** A `typeof` refinement expression. */
private class TypeofRefinement extends RefinementCandidate, TypeofExpr {
  TypeofRefinement() { this.getOperand() instanceof RefinementCandidate }

  override SsaSourceVariable getARefinedVar() {
    result = this.getOperand().(RefinementCandidate).getARefinedVar()
  }

  override RefinementValue eval(RefinementContext ctxt) {
    exists(RefinementValue opVal |
      opVal = this.getOperand().(RefinementCandidate).eval(ctxt) and
      result = TStringConstant(opVal.typeof())
    )
  }
}

/** An equality test that can be used as a refinement expression. */
private class EqRefinement extends RefinementCandidate, EqualityTest {
  EqRefinement() {
    this.getLeftOperand() instanceof RefinementCandidate and
    this.getRightOperand() instanceof RefinementCandidate
  }

  override SsaSourceVariable getARefinedVar() {
    result = this.getLeftOperand().(RefinementCandidate).getARefinedVar() or
    result = this.getRightOperand().(RefinementCandidate).getARefinedVar()
  }

  override RefinementValue eval(RefinementContext ctxt) {
    exists(RefinementCandidate l, RefinementValue lv, RefinementCandidate r, RefinementValue rv |
      l = this.getLeftOperand() and
      r = this.getRightOperand() and
      lv = l.eval(ctxt) and
      rv = r.eval(ctxt)
    |
      // if both sides evaluate to a constant, compare them
      if lv instanceof SingletonRefinementValue and rv instanceof SingletonRefinementValue
      then
        exists(boolean s, boolean p | s = this.getStrictness() and p = this.getPolarity() |
          if lv.(SingletonRefinementValue).equals(rv, s)
          then result = TBoolConstant(p)
          else result = TBoolConstant(p.booleanNot())
        )
      else
        // otherwise give up
        result = TValueWithType(TTBoolean())
    )
  }

  private boolean getStrictness() {
    if this instanceof StrictEqualityTest then result = true else result = false
  }
}

/** An index expression that can be used as a refinement expression. */
private class IndexRefinement extends RefinementCandidate, IndexExpr {
  IndexRefinement() {
    this.getBase() instanceof RefinementCandidate and
    this.getIndex() instanceof RefinementCandidate
  }

  override SsaSourceVariable getARefinedVar() {
    result = this.getBase().(RefinementCandidate).getARefinedVar() or
    result = this.getIndex().(RefinementCandidate).getARefinedVar()
  }

  override RefinementValue eval(RefinementContext ctxt) {
    exists(
      RefinementCandidate base, RefinementValue baseVal, RefinementCandidate index,
      RefinementValue indexVal
    |
      base = this.getBase() and
      index = this.getIndex() and
      baseVal = base.eval(ctxt) and
      indexVal = index.eval(ctxt)
    |
      if exists(evalIndex(baseVal, indexVal))
      then result = evalIndex(baseVal, indexVal)
      else result = TAny()
    )
  }
}

/**
 * Gets the abstract value representing the `i`th character of `s`,
 * if any.
 */
bindingset[s, i]
private RefinementValue evalIndex(StringConstant s, IntConstant i) {
  result = TStringConstant(s.getValue().charAt(i.getValue()))
}

/**
 * A context in which a refinement expression is analyzed.
 */
newtype TRefinementContext =
  /**
   * A refinement context associated with refinement `ref`, specifying that variable `var`
   * is assumed to have abstract value `val`.
   *
   * Each context keeps track of its associated `AnalyzedRefinement` node so that we can
   * restrict the `RefinementCandidate` expressions that it applies to: it should only
   * apply to those expressions that are syntactically nested inside the `AnalyzedRefinement`.
   */
  TVarRefinementContext(AnalyzedRefinement ref, SsaSourceVariable var, AbstractValue val) {
    var = ref.getSourceVariable() and
    val = ref.getAnInputRhsValue()
  }

/**
 * A context in which a refinement expression is analyzed.
 */
class RefinementContext extends TRefinementContext {
  /**
   * Holds if refinement expression `cand` might be analyzed in this context.
   */
  abstract predicate appliesTo(RefinementCandidate cand);

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * A refinement context specifying that some variable is assumed to have one particular
 * abstract value.
 */
class VarRefinementContext extends RefinementContext, TVarRefinementContext {
  override predicate appliesTo(RefinementCandidate cand) {
    exists(AnalyzedRefinement ref, SsaSourceVariable var |
      this = TVarRefinementContext(ref, var, _)
    |
      cand = ref.getRefinement().getAChildExpr*() and
      not cand.getARefinedVar() != var
    )
  }

  /**
   * Gets the abstract refinement value the variable is assumed to have.
   */
  RefinementValue getAValue() {
    exists(AbstractValue av | this = TVarRefinementContext(_, _, av) |
      if av instanceof AbstractBoolean
      then result.(BoolConstant).getValue() = av.(AbstractBoolean).getBooleanValue()
      else
        if av instanceof AbstractZero
        then result.(IntConstant).getValue() = 0
        else
          if av instanceof AbstractEmpty
          then result.(StringConstant).getValue() = ""
          else
            if av instanceof AbstractNumString
            then result instanceof NumString
            else
              if av instanceof AbstractOtherString
              then result instanceof NonEmptyNonNumString
              else
                if av instanceof AbstractNonZero
                then result instanceof NonZeroNumber
                else result.(ValueWithType).getType() = av.getType()
    )
  }

  override string toString() {
    exists(Variable var, AbstractValue val | this = TVarRefinementContext(_, var, val) |
      result = "[" + var + " = " + val + "]"
    )
  }
}

/** Holds if `e` is nested inside a guard node. */
pragma[nomagic]
private predicate inGuard(Expr e) {
  e = any(GuardControlFlowNode g).getTest()
  or
  inGuard(e.getParentExpr())
}

/**
 * An abstract value of a refinement expression.
 */
private newtype TRefinementValue =
  /** An abstract value indicating that no refinement information is available. */
  TAny() or
  /** An abstract value representing all concrete values of type `tp`. */
  TValueWithType(InferredType tp) or
  /** An abstract value representing the Boolean value `b`. */
  TBoolConstant(boolean b) { b = true or b = false } or
  /**
   * An abstract value representing the string `s`.
   *
   * There are abstract values for every string literal appearing anywhere
   * in a guard node, as well as for the empty string, all `typeof` tags and
   * their characters.
   */
  TStringConstant(string s) {
    s = ""
    or
    s instanceof TypeofTag
    or
    s = any(StringRefinement sr | inGuard(sr)).getValue()
    or
    s = any(TypeofTag t).charAt(_)
  } or
  /**
   * An abstract value representing the integer `i`.
   *
   * There are abstract values for zero and for every integer literal appearing
   * in a guard node.
   */
  TIntConstant(int i) {
    i = 0 or
    i = any(IntRefinement ir | inGuard(ir)).getValue().toInt()
  } or
  /**
   * An abstract value representing a non-empty string that coerces to a number
   * (and not `NaN`).
   */
  TNumString() or
  /**
   * An abstract value representing a string `s` such that `Number(s)` is `NaN`.
   */
  TNonEmptyNonNumString() or
  /**
   * An abstract value representing a non-zero number.
   */
  TNonZeroNumber()

/**
 * An abstract value of a refinement expression.
 */
class RefinementValue extends TRefinementValue {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Gets the `typeof` tag of a concrete value represented by this abstract value.
   */
  abstract string typeof();

  /**
   * Gets the Boolean value of a concrete value represented by this abstract value.
   */
  abstract boolean getABooleanValue();
}

/**
 * A refinement value that represents exactly one concrete value.
 */
abstract class SingletonRefinementValue extends RefinementValue {
  /**
   * Holds if `this` equals `that` under strict or non-strict equality, depending
   * on the value of `isStrict`.
   */
  predicate equals(SingletonRefinementValue that, boolean isStrict) {
    this = that and
    (isStrict = true or isStrict = false)
  }
}

/** An abstract value indicating that no refinement information is available. */
private class AnyValue extends RefinementValue, TAny {
  override string toString() { result = "any value" }

  override string typeof() { result instanceof TypeofTag }

  override boolean getABooleanValue() { result = true or result = false }
}

/** An abstract value representing all concrete values of some `InferredType`. */
private class ValueWithType extends RefinementValue, TValueWithType {
  InferredType getType() { this = TValueWithType(result) }

  override string toString() { result = "any " + this.getType() }

  override string typeof() { result = this.getType().getTypeofTag() }

  override boolean getABooleanValue() {
    result = true
    or
    // only primitive types can be falsy
    this.getType() instanceof PrimitiveType and result = false
  }
}

/** An abstract value representing `null` or `undefined`. */
private class NullOrUndefined extends ValueWithType, SingletonRefinementValue {
  NullOrUndefined() { this.getType() instanceof TTNull or this.getType() instanceof TTUndefined }

  override boolean getABooleanValue() { result = false }

  override predicate equals(SingletonRefinementValue that, boolean isStrict) {
    SingletonRefinementValue.super.equals(that, isStrict)
    or
    isStrict = false and that instanceof NullOrUndefined
  }
}

/** An abstract value representing a Boolean constant. */
private class BoolConstant extends SingletonRefinementValue, TBoolConstant {
  boolean value;

  BoolConstant() { this = TBoolConstant(value) }

  /** Gets the Boolean value represented by this abstract value. */
  boolean getValue() { this = TBoolConstant(result) }

  override string toString() { result = value.toString() }

  override string typeof() { result = "boolean" }

  override boolean getABooleanValue() { result = value }

  override predicate equals(SingletonRefinementValue that, boolean isStrict) {
    SingletonRefinementValue.super.equals(that, isStrict)
    or
    isStrict = false and
    (
      value = false and
      (that.(StringConstant).isEmptyOrZero() or that = TIntConstant(0))
      or
      value = true and
      (that = TStringConstant("1") or that = TIntConstant(1))
    )
  }
}

/** An abstract value representing a string constant. */
private class StringConstant extends SingletonRefinementValue, TStringConstant {
  string value;

  StringConstant() { this = TStringConstant(value) }

  /** Gets the string represented by this abstract value. */
  string getValue() { this = TStringConstant(result) }

  /** Holds if this is the empty string or the string `"0"`. */
  predicate isEmptyOrZero() { value = "" or value = "0" }

  override string toString() { result = "'" + value + "'" }

  override string typeof() { result = "string" }

  override boolean getABooleanValue() { if value = "" then result = false else result = true }

  override predicate equals(SingletonRefinementValue that, boolean isStrict) {
    SingletonRefinementValue.super.equals(that, isStrict)
    or
    isStrict = false and
    (
      this.isEmptyOrZero() and that = TBoolConstant(false)
      or
      value = "1" and that = TBoolConstant(true)
      or
      that = TIntConstant(value.toInt())
    )
  }
}

/** An abstract value representing an integer value. */
private class IntConstant extends SingletonRefinementValue, TIntConstant {
  int value;

  IntConstant() { this = TIntConstant(value) }

  /** Gets the integer value represented by this abstract value. */
  int getValue() { this = TIntConstant(result) }

  override string toString() { result = value.toString() }

  override string typeof() { result = "number" }

  override boolean getABooleanValue() { if value = 0 then result = false else result = true }

  override predicate equals(SingletonRefinementValue that, boolean isStrict) {
    SingletonRefinementValue.super.equals(that, isStrict)
    or
    isStrict = false and
    (
      value = 0 and that = TBoolConstant(false)
      or
      value = 1 and that = TBoolConstant(true)
      or
      value = that.(StringConstant).getValue().toInt()
    )
  }
}

/**
 * An abstract value representing a non-empty string `s` such that
 * `Number(s)` is not `NaN`.
 */
private class NumString extends RefinementValue, TNumString {
  override string toString() { result = "numeric string" }

  override string typeof() { result = "string" }

  override boolean getABooleanValue() { result = true }
}

/**
 * An abstract value representing a string `s` such that `Number(s)`
 * is `NaN`.
 */
private class NonEmptyNonNumString extends RefinementValue, TNonEmptyNonNumString {
  override string toString() { result = "non-empty, non-numeric string" }

  override string typeof() { result = "string" }

  override boolean getABooleanValue() { result = true }
}

/**
 * An abstract value representing a non-zero number.
 */
private class NonZeroNumber extends RefinementValue, TNonZeroNumber {
  override string toString() { result = "non-zero number" }

  override string typeof() { result = "number" }

  override boolean getABooleanValue() { result = true }
}
