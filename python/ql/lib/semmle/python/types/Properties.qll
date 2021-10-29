import python

/**
 * A Python property:
 *
 * @property def f():
 *         ....
 *
 *  Also any instances of types.GetSetDescriptorType (which are equivalent, but implemented in C)
 */
abstract class PropertyObject extends Object {
  PropertyObject() {
    property_getter(this, _)
    or
    this.asBuiltin().getClass() = theBuiltinPropertyType().asBuiltin()
  }

  /** Gets the name of this property */
  abstract string getName();

  /** Gets the getter of this property */
  abstract Object getGetter();

  /** Gets the setter of this property */
  abstract Object getSetter();

  /** Gets the deleter of this property */
  abstract Object getDeleter();

  override string toString() { result = "Property " + this.getName() }

  /** Whether this property is read-only. */
  predicate isReadOnly() { not exists(this.getSetter()) }

  /**
   * Gets an inferred type of this property.
   * That is the type returned by its getter function,
   * not the type of the property object which is types.PropertyType.
   */
  abstract ClassObject getInferredPropertyType();
}

class PythonPropertyObject extends PropertyObject {
  PythonPropertyObject() { property_getter(this, _) }

  override string getName() { result = this.getGetter().getName() }

  /** Gets the getter function of this property */
  override FunctionObject getGetter() { property_getter(this, result) }

  override ClassObject getInferredPropertyType() {
    result = this.getGetter().getAnInferredReturnType()
  }

  /** Gets the setter function of this property */
  override FunctionObject getSetter() { property_setter(this, result) }

  /** Gets the deleter function of this property */
  override FunctionObject getDeleter() { property_deleter(this, result) }
}

class BuiltinPropertyObject extends PropertyObject {
  BuiltinPropertyObject() { this.asBuiltin().getClass() = theBuiltinPropertyType().asBuiltin() }

  override string getName() { result = this.asBuiltin().getName() }

  /** Gets the getter method wrapper of this property */
  override Object getGetter() { result.asBuiltin() = this.asBuiltin().getMember("__get__") }

  override ClassObject getInferredPropertyType() { none() }

  /** Gets the setter method wrapper of this property */
  override Object getSetter() { result.asBuiltin() = this.asBuiltin().getMember("__set__") }

  /** Gets the deleter method wrapper of this property */
  override Object getDeleter() { result.asBuiltin() = this.asBuiltin().getMember("__delete__") }
}

private predicate property_getter(CallNode decorated, FunctionObject getter) {
  decorated.getFunction().refersTo(thePropertyType()) and
  decorated.getArg(0).refersTo(getter)
}

private predicate property_setter(CallNode decorated, FunctionObject setter) {
  property_getter(decorated, _) and
  exists(CallNode setter_call, AttrNode prop_setter |
    prop_setter.getObject("setter").refersTo(decorated)
  |
    setter_call.getArg(0).refersTo(setter) and
    setter_call.getFunction() = prop_setter
  )
  or
  decorated.getFunction().refersTo(thePropertyType()) and
  decorated.getArg(1).refersTo(setter)
}

private predicate property_deleter(CallNode decorated, FunctionObject deleter) {
  property_getter(decorated, _) and
  exists(CallNode deleter_call, AttrNode prop_deleter |
    prop_deleter.getObject("deleter").refersTo(decorated)
  |
    deleter_call.getArg(0).refersTo(deleter) and
    deleter_call.getFunction() = prop_deleter
  )
  or
  decorated.getFunction().refersTo(thePropertyType()) and
  decorated.getArg(2).refersTo(deleter)
}
