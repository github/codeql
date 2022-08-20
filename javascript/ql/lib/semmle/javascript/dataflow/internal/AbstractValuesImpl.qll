/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides a representation for abstract values.
 */

private import javascript
import semmle.javascript.dataflow.AbstractValues
private import semmle.javascript.dataflow.InferredTypes
import semmle.javascript.dataflow.CustomAbstractValueDefinitions

/** An abstract value inferred by the flow analysis. */
cached
newtype TAbstractValue =
  /** An abstract representation of `null`. */
  TAbstractNull() or
  /** An abstract representation of `undefined`. */
  TAbstractUndefined() or
  /** An abstract representation of Boolean value `b`. */
  TAbstractBoolean(boolean b) { b = true or b = false } or
  /** An abstract representation of the number (or bigint) zero. */
  TAbstractZero() or
  /** An abstract representation of a non-zero number (or bigint). */
  TAbstractNonZero() or
  /** An abstract representation of the empty string. */
  TAbstractEmpty() or
  /** An abstract representation of a string that coerces to a number (and not `NaN`). */
  TAbstractNumString() or
  /** An abstract representation of a non-empty string that does not coerce to a number. */
  TAbstractOtherString() or
  /** An abstract representation of a regular expression object. */
  TAbstractRegExp() or
  /** An abstract representation of a function object corresponding to function `f`. */
  TAbstractFunction(Function f) or
  /** An abstract representation of a class object corresponding to class `c`. */
  TAbstractClass(ClassDefinition c) or
  /** An abstract representation of a Date object. */
  TAbstractDate() or
  /**
   * An abstract representation of the arguments object of a function object
   * corresponding to function `f`.
   */
  TAbstractArguments(Function f) { exists(f.getArgumentsVariable().getAnAccess()) } or
  /** An abstract representation of the global object. */
  TAbstractGlobalObject() or
  /** An abstract representation of a `module` object. */
  TAbstractModuleObject(Module m) or
  /** An abstract representation of a `exports` object. */
  TAbstractExportsObject(Module m) or
  /** An abstract representation of all objects arising from an object literal expression. */
  TAbstractObjectLiteral(ObjectExpr oe) or
  /**
   * An abstract value representing all instances of a class or function `F`,
   * as well as the default prototype of `F` (that is, the initial value of
   * `F.prototype`).
   */
  TAbstractInstance(AbstractCallable ac) {
    ac instanceof AbstractClass
    or
    exists(Function f | ac = TAbstractFunction(f) |
      not f.isNonConstructible(_) and
      // constructors are covered by the first disjunct
      not f instanceof Constructor
    )
  } or
  /** An abstract representation of an object not covered by the other abstract values. */
  TAbstractOtherObject() or
  /**
   * An abstract representation of an indefinite value that represents a function or class,
   * where `cause` records the cause of the incompleteness.
   */
  TIndefiniteFunctionOrClass(DataFlow::Incompleteness cause) or
  /**
   * An abstract representation of an indefinite value that represents an object,
   * but not a function or class, with `cause` recording the cause of the incompleteness.
   */
  TIndefiniteObject(DataFlow::Incompleteness cause) or
  /**
   * Abstract representation of indefinite values that represent any value, with
   * `cause` recording the cause of the incompleteness.
   */
  TIndefiniteAbstractValue(DataFlow::Incompleteness cause) or
  /** A custom abstract value induced by `tag`. */
  TCustomAbstractValue(CustomAbstractValueTag tag) or
  /** A custom abstract value induced by `def`. */
  TCustomAbstractValueFromDefinition(CustomAbstractValueDefinition def)

/**
 * Gets a definite abstract value with the given type.
 */
DefiniteAbstractValue abstractValueOfType(TypeTag type) { result.getType() = type }
