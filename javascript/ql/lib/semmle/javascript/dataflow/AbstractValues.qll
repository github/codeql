/**
 * Provides classes for working with abstract values.
 *
 * Abstract values are a finite representation of the potentially
 * infinite set of concrete values observed at runtime.
 *
 * Some abstract values directly correspond to concrete values:
 * for example, there is an abstract `null` value that represents
 * the concrete `null` value.
 *
 * Most abstract values, however, represent a set of concrete
 * values: for example, there is an abstract value `nonzero`
 * representing the set of all non-zero numbers.
 *
 * The flow analysis uses abstract values of the latter kind to
 * finitely overapproximate the infinite set of potential program
 * executions. This entails imprecision of two kinds:
 *
 *   - sometimes we deliberately forget information about a
 *     concrete value because we are not interested in it: for
 *     example, the concrete value `42` is mapped to the abstract
 *     value `nonzero`;
 *
 *   - at other times, the analysis does not have enough information
 *     to precisely model the behavior of certain program elements:
 *     for example, the current flow analysis is intra-procedural,
 *     so it does not model parameter passing or return values, and
 *     hence has to make worst-case assumptions about the possible
 *     values of parameters or function calls.
 *
 * We use two categories of abstract values to represent these
 * different sources of imprecision: _definite_ abstract values
 * are deliberate overapproximations, while _indefinite_ abstract
 * values are overapproximations arising from incompleteness.
 *
 * Both kinds of abstract values keep track of which concrete objects
 * they represent; additionally, indefinite abstract values record
 * the source of imprecision that caused them to arise.
 */

private import javascript
private import semmle.javascript.dataflow.internal.AbstractValuesImpl
private import InferredTypes

/**
 * An abstract value inferred by the flow analysis, representing
 * a set of concrete values.
 */
class AbstractValue extends TAbstractValue {
  /**
   * Gets the type of some concrete value represented by this
   * abstract value.
   */
  abstract InferredType getType();

  /**
   * Gets the Boolean value some concrete value represented by this
   * abstract value coerces to.
   */
  abstract boolean getBooleanValue();

  /**
   * Gets an abstract primitive value this abstract value coerces to.
   *
   * This abstractly models the `ToPrimitive` coercion described in the
   * ECMAScript language specification.
   */
  abstract PrimitiveAbstractValue toPrimitive();

  /**
   * Holds if this abstract value is coercible to a number, that is, it
   * represents at least one concrete value for which the `ToNumber`
   * conversion does not yield `NaN`.
   */
  abstract predicate isCoercibleToNumber();

  /**
   * Holds if this abstract value is an indefinite value arising from the
   * incompleteness `cause`.
   */
  predicate isIndefinite(DataFlow::Incompleteness cause) { none() }

  /**
   * Gets an abstract value that represents a prototype object of this value.
   *
   * We currently model three sources of prototypes:
   *
   *   - direct assignments to `o.__proto__` are tracked;
   *
   *   - for an instance `o` of a function `f`, any value that can be shown to flow into
   *     `f.prototype` is considered a prototype object of `o`;
   *
   *   - for an instance of a class `C`, any instance of a function or class that can be
   *     shown to flow into the `extends` clause of `C` is considered a prototype object
   *     of `o`.
   *
   * In all cases, purely local flow tracking is used to find prototype objects, so
   * this predicate cannot be relied on to compute all possible prototype objects.
   */
  DefiniteAbstractValue getAPrototype() {
    exists(AbstractProtoProperty proto |
      proto.getBase() = this and
      result = proto.getAValue()
    )
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `f`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string f, int startline, int startcolumn, int endline, int endcolumn) {
    f = "" and startline = 0 and startcolumn = 0 and endline = 0 and endcolumn = 0
  }

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * A definite abstract value, that is, an abstract value that is not
 * affected by analysis incompleteness.
 */
abstract class DefiniteAbstractValue extends AbstractValue { }

/**
 * A definite abstract value that represents only primitive concrete values.
 */
abstract class PrimitiveAbstractValue extends DefiniteAbstractValue {
  override PrimitiveAbstractValue toPrimitive() { result = this }

  abstract override PrimitiveType getType();
}

/**
 * An abstract value representing `null`.
 */
class AbstractNull extends PrimitiveAbstractValue, TAbstractNull {
  override boolean getBooleanValue() { result = false }

  override PrimitiveType getType() { result = TTNull() }

  override predicate isCoercibleToNumber() { none() }

  override string toString() { result = "null" }
}

/**
 * An abstract value representing `undefined`.
 */
class AbstractUndefined extends PrimitiveAbstractValue, TAbstractUndefined {
  override boolean getBooleanValue() { result = false }

  override PrimitiveType getType() { result = TTUndefined() }

  override predicate isCoercibleToNumber() { none() }

  override string toString() { result = "undefined" }
}

/**
 * An abstract value representing a Boolean value.
 */
class AbstractBoolean extends PrimitiveAbstractValue, TAbstractBoolean {
  override boolean getBooleanValue() { this = TAbstractBoolean(result) }

  override PrimitiveType getType() { result = TTBoolean() }

  override predicate isCoercibleToNumber() { any() }

  override string toString() { result = getBooleanValue().toString() }
}

/**
 * An abstract value representing the number zero.
 */
class AbstractZero extends PrimitiveAbstractValue, TAbstractZero {
  override boolean getBooleanValue() { result = false }

  override PrimitiveType getType() { result = TTNumber() }

  override predicate isCoercibleToNumber() { any() }

  override string toString() { result = "0" }
}

/**
 * An abstract value representing a non-zero number.
 */
class AbstractNonZero extends PrimitiveAbstractValue, TAbstractNonZero {
  override boolean getBooleanValue() { result = true }

  override PrimitiveType getType() { result = TTNumber() }

  override predicate isCoercibleToNumber() { any() }

  override string toString() { result = "non-zero value" }
}

/**
 * An abstract value representing the empty string.
 */
class AbstractEmpty extends PrimitiveAbstractValue, TAbstractEmpty {
  override boolean getBooleanValue() { result = false }

  override PrimitiveType getType() { result = TTString() }

  override predicate isCoercibleToNumber() { any() }

  override string toString() { result = "\"\"" }
}

/**
 * An abstract value representing a numeric string, that is, a string `s`
 * such that `+s` is not `NaN`.
 */
class AbstractNumString extends PrimitiveAbstractValue, TAbstractNumString {
  override boolean getBooleanValue() { result = true }

  override PrimitiveType getType() { result = TTString() }

  override predicate isCoercibleToNumber() { any() }

  override string toString() { result = "numeric string" }
}

/**
 * An abstract value representing a non-empty, non-numeric string.
 */
class AbstractOtherString extends PrimitiveAbstractValue, TAbstractOtherString {
  override boolean getBooleanValue() { result = true }

  override PrimitiveType getType() { result = TTString() }

  override predicate isCoercibleToNumber() { none() }

  override string toString() { result = "non-empty, non-numeric string" }
}

/**
 * An abstract value representing a regular expression.
 */
class AbstractRegExp extends DefiniteAbstractValue, TAbstractRegExp {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTRegExp() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override string toString() { result = "regular expression" }
}

/**
 * An abstract value representing a function or class.
 */
abstract class AbstractCallable extends DefiniteAbstractValue {
  /**
   * Gets the function represented by this abstract value.
   *
   * For abstract class values, this is the constructor method of the class.
   */
  abstract Function getFunction();

  /**
   * Gets the definition of the function or class represented by this abstract value.
   *
   * For abstract class values, this is the definition of the class itself (and not
   * its constructor).
   */
  abstract AST::ValueNode getDefinition();
}

/**
 * An abstract value representing an individual function.
 */
class AbstractFunction extends AbstractCallable, TAbstractFunction {
  override Function getFunction() { this = TAbstractFunction(result) }

  override AST::ValueNode getDefinition() { result = getFunction() }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTFunction() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getFunction().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = getFunction().describe() }
}

/**
 * An abstract value representing an individual class.
 */
class AbstractClass extends AbstractCallable, TAbstractClass {
  /**
   * Gets the class represented by this abstract value.
   */
  ClassDefinition getClass() { this = TAbstractClass(result) }

  override Function getFunction() { result = getClass().getConstructor().getBody() }

  override AST::ValueNode getDefinition() { result = getClass() }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTClass() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getClass().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = getClass().describe() }
}

/**
 * An abstract value representing a `Date` object.
 */
class AbstractDate extends DefiniteAbstractValue, TAbstractDate {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTDate() }

  override predicate isCoercibleToNumber() { any() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTNumber() }

  override string toString() { result = "date" }
}

/**
 * An abstract value representing an `arguments` object.
 */
class AbstractArguments extends DefiniteAbstractValue, TAbstractArguments {
  /** Gets the function whose `arguments` object this is an abstraction of. */
  Function getFunction() { this = TAbstractArguments(result) }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getFunction().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = "arguments object of " + getFunction().describe() }
}

/**
 * An abstract value representing the global object.
 */
class AbstractGlobalObject extends DefiniteAbstractValue, TAbstractGlobalObject {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override string toString() { result = "global" }
}

/**
 * An abstract value representing a CommonJS `module` object.
 */
class AbstractModuleObject extends DefiniteAbstractValue, TAbstractModuleObject {
  /** Gets the module whose `module` object this abstract value represents. */
  Module getModule() { this = TAbstractModuleObject(result) }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getModule().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = "module object of module " + getModule().getName() }
}

/**
 * An abstract value representing a CommonJS `exports` object.
 */
class AbstractExportsObject extends DefiniteAbstractValue, TAbstractExportsObject {
  /** Gets the module whose `exports` object this abstract value represents. */
  Module getModule() { this = TAbstractExportsObject(result) }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getModule().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = "exports object of module " + getModule().getName() }
}

/**
 * An abstract value representing all objects arising from an object literal expression
 * (allocation site abstraction).
 */
class AbstractObjectLiteral extends DefiniteAbstractValue, TAbstractObjectLiteral {
  /** Gets the object expression this abstract value represents. */
  ObjectExpr getObjectExpr() { this = TAbstractObjectLiteral(result) }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getObjectExpr().getLocation().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = "object literal" }
}

/**
 * An abstract value representing all instances of a class or function `F`,
 * as well as the default prototype of `F` (that is, the initial value of
 * `F.prototype`).
 */
class AbstractInstance extends DefiniteAbstractValue, TAbstractInstance {
  /** Gets the constructor of this instance. */
  AbstractCallable getConstructor() { this = TAbstractInstance(result) }

  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTString() }

  override predicate hasLocationInfo(
    string path, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getConstructor().hasLocationInfo(path, startline, startcolumn, endline, endcolumn)
  }

  override string toString() { result = "instance of " + getConstructor() }
}

module AbstractInstance {
  /**
   * Gets the abstract value representing instances of `f`, which is a function
   * or a class.
   */
  AbstractInstance of(AST::ValueNode f) {
    result.getConstructor().getFunction() = f or
    result.getConstructor() = TAbstractClass(f)
  }
}

/**
 * An abstract value representing an object not covered by the other abstract
 * values.
 */
class AbstractOtherObject extends DefiniteAbstractValue, TAbstractOtherObject {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTObject() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result.getType() = TTString() }

  override string toString() { result = "object" }
}

/**
 * An indefinite abstract value representing an unknown function or class.
 */
class IndefiniteFunctionOrClass extends AbstractValue, TIndefiniteFunctionOrClass {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() { result = TTFunction() or result = TTClass() }

  override predicate isCoercibleToNumber() { none() }

  override PrimitiveAbstractValue toPrimitive() { result = TAbstractOtherString() }

  override predicate isIndefinite(DataFlow::Incompleteness cause) {
    this = TIndefiniteFunctionOrClass(cause)
  }

  override string toString() {
    exists(DataFlow::Incompleteness cause | isIndefinite(cause) |
      result = "indefinite function or class (" + cause + ")"
    )
  }
}

/**
 * An indefinite abstract value representing an unknown object.
 */
class IndefiniteObject extends AbstractValue, TIndefiniteObject {
  override boolean getBooleanValue() { result = true }

  override InferredType getType() {
    result = TTDate() or result = TTRegExp() or result = TTObject()
  }

  override predicate isCoercibleToNumber() { any() }

  override PrimitiveAbstractValue toPrimitive() {
    result.getType() = TTString() or result.getType() = TTNumber()
  }

  override predicate isIndefinite(DataFlow::Incompleteness cause) {
    this = TIndefiniteObject(cause)
  }

  override string toString() {
    exists(DataFlow::Incompleteness cause | isIndefinite(cause) |
      result = "indefinite object (" + cause + ")"
    )
  }
}

/**
 * An indefinite abstract value representing an unknown value.
 */
class IndefiniteAbstractValue extends AbstractValue, TIndefiniteAbstractValue {
  override boolean getBooleanValue() { result = true or result = false }

  override InferredType getType() { any() }

  override predicate isCoercibleToNumber() { any() }

  override PrimitiveAbstractValue toPrimitive() { any() }

  override predicate isIndefinite(DataFlow::Incompleteness cause) {
    this = TIndefiniteAbstractValue(cause)
  }

  override string toString() {
    exists(DataFlow::Incompleteness cause | isIndefinite(cause) |
      result = "indefinite value (" + cause + ")"
    )
  }

  /**
   * Gets an abstract value representing a subset of the concrete values represented by
   * this abstract value.
   *
   * Taken together, all results of this predicate taken together must cover the entire
   * set of concrete values represented by this abstract value.
   */
  AbstractValue split() {
    exists(string cause | isIndefinite(cause) |
      result = TIndefiniteFunctionOrClass(cause) or
      result = TIndefiniteObject(cause) or
      result = abstractValueOfType(any(PrimitiveType pt))
    )
  }
}

/**
 * A string tag corresponding to a custom abstract value.
 */
abstract class CustomAbstractValueTag extends string {
  bindingset[this]
  CustomAbstractValueTag() { any() }

  /**
   * Gets the type of some concrete value represented by this
   * abstract value.
   */
  abstract InferredType getType();

  /**
   * Gets the Boolean value some concrete value represented by this
   * abstract value coerces to.
   */
  abstract boolean getBooleanValue();

  /**
   * Gets an abstract primitive value this abstract value coerces to.
   *
   * This abstractly models the `ToPrimitive` coercion described in the
   * ECMAScript language specification.
   */
  abstract PrimitiveAbstractValue toPrimitive();

  /**
   * Holds if this abstract value is coercible to a number, that is, it
   * represents at least one concrete value for which the `ToNumber`
   * conversion does not yield `NaN`.
   */
  abstract predicate isCoercibleToNumber();

  /**
   * Holds if this abstract value is an indefinite value arising from the
   * incompleteness `cause`.
   */
  predicate isIndefinite(DataFlow::Incompleteness cause) { none() }

  /** Gets a textual representation of this abstract value. */
  abstract string describe();
}

/**
 * A custom abstract value corresponding to an abstract value tag.
 */
class CustomAbstractValue extends AbstractValue, TCustomAbstractValue {
  CustomAbstractValueTag tag;

  CustomAbstractValue() { this = TCustomAbstractValue(tag) }

  /** Gets the tag that this abstract value corresponds to. */
  CustomAbstractValueTag getTag() { result = tag }

  override boolean getBooleanValue() { result = tag.getBooleanValue() }

  override InferredType getType() { result = tag.getType() }

  override predicate isCoercibleToNumber() { tag.isCoercibleToNumber() }

  override PrimitiveAbstractValue toPrimitive() { result = tag.toPrimitive() }

  override predicate isIndefinite(DataFlow::Incompleteness cause) { tag.isIndefinite(cause) }

  override string toString() { result = tag.describe() }
}
