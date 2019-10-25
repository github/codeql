/**
 * Provides classes for working with analysis-specific abstract values.
 *
 * Implement a subclass of `CustomAbstractValueDefinition` when the builtin
 * abstract values of `AbstractValues.qll` are not expressive enough.
 *
 * For performance reasons, all subclasses of `CustomAbstractValueDefinition`
 * should be part of the standard library.
 */

private import javascript
private import internal.AbstractValuesImpl
private import InferredTypes

/**
 * An abstract representation of an analysis-specific value.
 *
 * Wraps a `CustomAbstractValueDefinition`.
 */
class CustomAbstractValueFromDefinition extends AbstractValue, TCustomAbstractValueFromDefinition {
  CustomAbstractValueDefinition def;

  CustomAbstractValueFromDefinition() { this = TCustomAbstractValueFromDefinition(def) }

  override InferredType getType() { result = def.getType() }

  override boolean getBooleanValue() { result = def.getBooleanValue() }

  override PrimitiveAbstractValue toPrimitive() { result = def.toPrimitive() }

  override predicate isCoercibleToNumber() { def.isCoercibleToNumber() }

  override predicate isIndefinite(DataFlow::Incompleteness cause) { def.isIndefinite(cause) }

  override DefiniteAbstractValue getAPrototype() { result = def.getAPrototype() }

  override predicate hasLocationInfo(
    string f, int startline, int startcolumn, int endline, int endcolumn
  ) {
    def.getLocation().hasLocationInfo(f, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = def.toString() }

  /**
   * Gets the definition that induces this value.
   */
  CustomAbstractValueDefinition getDefinition() { result = def }

  /** Holds if this is a value whose properties the type inference tracks. */
  predicate shouldTrackProperties() { def.shouldTrackProperties() }
}

/**
 * A data-flow node that induces an analysis-specific abstract value.
 *
 * Enables modular extensions of `AbstractValue`.
 *
 * For performance reasons, all subclasses of this class  should be part
 * of the standard library.
 */
abstract class CustomAbstractValueDefinition extends Locatable {
  /**
   * Gets the type of some concrete value represented by the induced
   * abstract value.
   */
  abstract InferredType getType();

  /**
   * Gets the Boolean value that some concrete value represented by the
   * induced abstract value coerces to.
   */
  abstract boolean getBooleanValue();

  /**
   * Gets an abstract primitive value the induced abstract value coerces
   * to.
   *
   * This abstractly models the `ToPrimitive` coercion described in the
   * ECMAScript language specification.
   */
  abstract PrimitiveAbstractValue toPrimitive();

  /**
   * Holds if the induced abstract value is coercible to a number, that
   * is, it represents at least one concrete value for which the
   * `ToNumber` conversion does not yield `NaN`.
   */
  abstract predicate isCoercibleToNumber();

  /**
   * Holds if the induced abstract value is an indefinite value arising
   * from the incompleteness `cause`.
   */
  predicate isIndefinite(DataFlow::Incompleteness cause) { none() }

  /**
   * Gets an abstract value that represents a prototype object of the
   * induced abstract value.
   */
  AbstractValue getAPrototype() {
    exists(AbstractProtoProperty proto |
      proto.getBase() = getAbstractValue() and
      result = proto.getAValue()
    )
  }

  /**
   * Gets the induced abstract value.
   */
  AbstractValue getAbstractValue() {
    result.(CustomAbstractValueFromDefinition).getDefinition() = this
  }

  /** Holds if this is a value whose properties the type inference tracks. */
  abstract predicate shouldTrackProperties();
}

/**
 * Flow analysis for custom abstract values.
 */
class CustomAbstractValueFromDefinitionNode extends DataFlow::AnalyzedNode, DataFlow::ValueNode {
  CustomAbstractValueFromDefinition val;

  CustomAbstractValueFromDefinitionNode() {
    val = TCustomAbstractValueFromDefinition(this.getAstNode())
  }

  override AbstractValue getALocalValue() { result = val }
}
