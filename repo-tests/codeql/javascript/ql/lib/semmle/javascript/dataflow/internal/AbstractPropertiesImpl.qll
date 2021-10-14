/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides the internal representation of abstract properties and related predicates.
 */

import javascript
private import AbstractValuesImpl

/**
 * An abstract representation of a set of concrete properties, characterized
 * by a base object (which is an abstract value for which properties are tracked)
 * and a property name.
 */
newtype TAbstractProperty =
  MkAbstractProperty(AbstractValue base, string prop) {
    any(AnalyzedPropertyRead apr).reads(base, prop) and shouldTrackProperties(base)
    or
    any(AnalyzedPropertyWrite apw).writes(base, prop, _)
    or
    exists(getAnInitialPropertyValue(base, prop))
    or
    // make sure `__proto__` properties exist for all instance values
    base instanceof AbstractInstance and
    prop = "__proto__"
  }

/**
 * Holds if the result is known to be an initial value of property `propertyName` of one
 * of the concrete objects represented by `baseVal`.
 */
AbstractValue getAnInitialPropertyValue(DefiniteAbstractValue baseVal, string propertyName) {
  // initially, `module.exports === exports`
  exists(Module m |
    baseVal = TAbstractModuleObject(m) and
    propertyName = "exports" and
    result = TAbstractExportsObject(m)
  )
  or
  // class members
  result = getAnInitialMemberValue(getMember(baseVal, propertyName))
  or
  // object properties
  exists(ValueProperty p |
    baseVal.(AbstractObjectLiteral).getObjectExpr() = p.getObjectExpr() and
    propertyName = p.getName() and
    result = p.getInit().analyze().getALocalValue()
  )
  or
  // `f.prototype` for functions `f`
  propertyName = "prototype" and
  result = TAbstractInstance(baseVal)
}

/**
 * Gets a class member definition that we abstractly represent as a property of `baseVal`
 * with the given `name`.
 */
private MemberDefinition getMember(DefiniteAbstractValue baseVal, string name) {
  exists(ClassDefinition c | result = c.getMember(name) |
    if result.isStatic() then baseVal = TAbstractClass(c) else baseVal = AbstractInstance::of(c)
  )
}

/**
 * Gets an abstract representation of the initial value of member definition `m`.
 *
 * For (non-accessor) methods, this is the abstract function corresponding to the
 * method. For fields, it is an abstract representation of their initial value(s).
 */
private AbstractValue getAnInitialMemberValue(MemberDefinition m) {
  not m instanceof AccessorMethodDefinition and
  result = m.getInit().analyze().getALocalValue()
}

/**
 * Holds if `baseVal` is an abstract value whose properties we track for the purposes
 * of `getALocalValue`.
 */
predicate shouldAlwaysTrackProperties(AbstractValue baseVal) {
  baseVal instanceof AbstractModuleObject or
  baseVal instanceof AbstractExportsObject or
  baseVal instanceof AbstractCallable
}

/** Holds if `baseVal` is an abstract value whose properties we track. */
predicate shouldTrackProperties(AbstractValue baseVal) {
  shouldAlwaysTrackProperties(baseVal) or
  baseVal instanceof AbstractObjectLiteral or
  baseVal instanceof AbstractInstance or
  baseVal.(CustomAbstractValueFromDefinition).shouldTrackProperties()
}
