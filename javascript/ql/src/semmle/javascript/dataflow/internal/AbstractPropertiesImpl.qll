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
  exists (Module m |
    baseVal = TAbstractModuleObject(m) and
    propertyName = "exports" and
    result = TAbstractExportsObject(m)
  )
  or
  // class members
  exists (ClassDefinition c, DataFlow::AnalyzedNode init, MemberDefinition m |
    m = c.getMember(propertyName) and
    not m instanceof AccessorMethodDefinition and
    init = m.getInit().analyze() and
    result = init.getALocalValue() |
    if m.isStatic() then
      baseVal = TAbstractClass(c)
    else
      baseVal = AbstractInstance::of(c)
  )
  or
  // object properties
  exists (ValueProperty p |
    baseVal.(AbstractObjectLiteral).getObjectExpr() = p.getObjectExpr() and
    propertyName = p.getName() and
    result = p.getInit().analyze().getALocalValue()
  )
  or
  // `f.prototype` for functions `f` that are instantiated
  propertyName = "prototype" and
  baseVal = any(NewExpr ne).getCallee().analyze().getALocalValue() and
  result = TAbstractInstance(baseVal)
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
  baseVal instanceof AbstractInstance
}
