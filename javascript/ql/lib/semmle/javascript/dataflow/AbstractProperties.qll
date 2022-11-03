private import javascript
private import semmle.javascript.dataflow.internal.AbstractValuesImpl
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.AbstractPropertiesImpl

/**
 * An abstract representation of a set of concrete properties, characterized
 * by a base object (which is an abstract value for which properties are tracked)
 * and a property name.
 */
class AbstractProperty extends TAbstractProperty {
  // Implementation note: Binding `base` and `propertyName` to fields
  // would be slightly more elegant, but leads to worse performance on very big snapshots.
  /** Gets the base object of this abstract property. */
  AbstractValue getBase() { this = MkAbstractProperty(result, _) }

  /** Gets the property name of this abstract property. */
  string getPropertyName() { this = MkAbstractProperty(_, result) }

  /**
   * Gets an initial value that is implicitly assigned to this property.
   */
  AbstractValue getAnInitialValue() {
    result = getAnInitialPropertyValue(getBase(), getPropertyName())
  }

  /**
   * Gets a value of this property for the purposes of `AnalyzedNode.getALocalValue`.
   */
  AbstractValue getALocalValue() {
    result = getAnInitialPropertyValue(getBase(), getPropertyName())
    or
    shouldAlwaysTrackProperties(getBase()) and
    result = getAnAssignedValue(getBase(), getPropertyName())
  }

  /**
   * Gets a value of this property for the purposes of `AnalyzedNode.getAValue`.
   */
  AbstractValue getAValue() {
    result = getALocalValue() or
    result = getAnAssignedValue(getBase(), getPropertyName())
  }

  /**
   * Gets a textual representation of this element.
   */
  string toString() { result = "property " + getPropertyName() + " of " + getBase() }
}

/**
 * An abstract representation of the `__proto__` property of a function or
 * class instance.
 */
class AbstractProtoProperty extends AbstractProperty {
  AbstractProtoProperty() { getPropertyName() = "__proto__" }

  override AbstractValue getAValue() {
    result = super.getAValue() and
    (
      not result instanceof PrimitiveAbstractValue or
      result instanceof AbstractNull
    )
    or
    exists(AbstractCallable ctor | getBase() = TAbstractInstance(ctor) |
      // the value of `ctor.prototype`
      exists(AbstractProperty prototype |
        prototype = MkAbstractProperty(ctor.(AbstractFunction), "prototype") and
        result = prototype.getALocalValue()
      )
      or
      // instance of super class
      exists(ClassDefinition cd, AbstractCallable superCtor |
        cd = ctor.(AbstractClass).getClass() and
        superCtor = cd.getSuperClass().analyze().getALocalValue() and
        result = TAbstractInstance(superCtor)
      )
    )
  }
}

/**
 * Gets a value that is explicitly assigned to property `p` of abstract value `b`.
 *
 * This auxiliary predicate is necessary to enforce a better join order, and it
 * has to be toplevel predicate to avoid a spurious type join with `AbstractProperty`,
 * which in turn introduces a materialization.
 */
private AbstractValue getAnAssignedValue(AbstractValue b, string p) {
  exists(AnalyzedPropertyWrite apw | apw.writesValue(b, p, result))
}
