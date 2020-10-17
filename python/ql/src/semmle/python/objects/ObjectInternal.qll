/**
 * Internal object API.
 * For use by points-to and testing only.
 */

private import semmle.python.objects.TObject
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins
import semmle.python.objects.Modules
import semmle.python.objects.Classes
import semmle.python.objects.Instances
import semmle.python.objects.Callables
import semmle.python.objects.Constants
import semmle.python.objects.Sequences
import semmle.python.objects.Descriptors

class ObjectInternal extends TObject {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * The boolean value of this object, this may be both
   * true and false if the "object" represents a set of possible objects.
   */
  abstract boolean booleanValue();

  /**
   * Holds if this object is introduced into the code base at `node` given the `context`
   * This means that `node`, in `context`, points-to this object, but the object has not flowed
   * there from anywhere else.
   * Examples:
   *  * The object `None` is "introduced" by the keyword "None".
   *  * A bound method would be "introduced" when relevant attribute on an instance
   * is accessed. In `x = X(); x.m` `x.m` introduces the bound method.
   */
  abstract predicate introducedAt(ControlFlowNode node, PointsToContext context);

  /** Gets the class declaration for this object, if it is a class with a declaration. */
  abstract ClassDecl getClassDeclaration();

  /** True if this "object" is a class. That is, its class inherits from `type` */
  abstract boolean isClass();

  /** Gets the class of this object. */
  abstract ObjectInternal getClass();

  /**
   * True if this "object" can be meaningfully analysed to determine the boolean value of
   * equality tests on it.
   * For example, `None` or `int` can be, but `int()` or an unknown string cannot.
   */
  abstract predicate notTestableForEquality();

  /**
   * Gets the `Builtin` for this object, if any.
   * Objects (except unknown and undefined values) should attempt to return
   * exactly one result for either this method or `getOrigin()`.
   */
  abstract Builtin getBuiltin();

  /**
   * Gets a control flow node that represents the source origin of this
   * object, if it has a meaningful location in the source code.
   * This method exists primarily for providing backwards compatibility and
   * locations for source objects.
   * Source code objects should attempt to return exactly one result for this method.
   */
  abstract ControlFlowNode getOrigin();

  /**
   * Holds if `obj` is the result of calling `this` and `origin` is
   * the origin of `obj`.
   *
   * This is the context-insensitive version.
   * Generally, if this holds for any object `obj` then `callResult/3` should never hold for that object.
   */
  abstract predicate callResult(ObjectInternal obj, CfgOrigin origin);

  /**
   * Holds if `obj` is the result of calling `this` and `origin` is
   * the origin of `obj` with callee context `callee`.
   *
   * This is the context-sensitive version.
   * Generally, if this holds for any object `obj` then `callResult/2` should never hold for that object.
   */
  abstract predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin);

  /**
   * The integer value of things that have integer values and whose integer value is
   * tracked.
   * That is, some ints, mainly small numbers, and bools.
   */
  abstract int intValue();

  /**
   * The string value of things that have string values.
   * That is, strings.
   */
  abstract string strValue();

  /**
   * Holds if the function `scope` is called when this object is called and `paramOffset`
   * is the difference from the parameter position and the argument position.
   * For a normal function `paramOffset` is 0. For classes and bound-methods it is 1.
   * Used by points-to to help determine flow from arguments to parameters.
   */
  abstract predicate calleeAndOffset(Function scope, int paramOffset);

  final predicate isBuiltin() { exists(this.getBuiltin()) }

  /**
   * Holds if the result of getting the attribute `name` is `value` and that `value` comes
   * from `origin`. Note this is *not* the same as class lookup. For example
   * for an object `x` the attribute `name` (`x.name`) may refer to a bound-method, an attribute of the
   * instance, or an attribute of the class.
   */
  pragma[nomagic]
  abstract predicate attribute(string name, ObjectInternal value, CfgOrigin origin);

  /** Holds if the attributes of this object are wholly or partly unknowable */
  abstract predicate attributesUnknown();

  /** Holds if the result of subscripting this object are wholly or partly unknowable */
  abstract predicate subscriptUnknown();

  /**
   * For backwards compatibility shim -- Not all objects have a "source".
   * Objects (except unknown and undefined values) should attempt to return
   * exactly one result for this method.
   */
  @py_object getSource() {
    result = this.getOrigin()
    or
    result = this.getBuiltin()
  }

  /**
   * Holds if this object is a descriptor.
   * Holds, for example, for functions and properties and not for integers.
   */
  abstract boolean isDescriptor();

  /**
   * Holds if the result of attribute access on the class holding this descriptor is `value`, originating at `origin`
   * For example, although `T.__dict__['name'] = classmethod(f)`, `T.name` is a bound-method, binding `f` and `T`
   */
  pragma[nomagic]
  abstract predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin);

  /**
   * Holds if the result of attribute access on an instance of a class holding this descriptor is `value`, originating at `origin`
   * For example, with `T.__dict__['name'] = classmethod(f)`, `T().name` is a bound-method, binding `f` and `T`
   */
  pragma[nomagic]
  abstract predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  );

  /**
   * Holds if attribute lookup on this object may "bind" `instance` to `descriptor`.
   * Here "bind" means that `instance` is passed to the `descriptor.__get__()` method
   * at runtime. The term "bind" is used as this most likely results in a bound-method.
   */
  abstract predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor);

  /**
   * Gets the length of the sequence that this "object" represents.
   * Always returns a value for a sequence, will be -1 if the object has no fixed length.
   */
  abstract int length();

  /**
   * Holds if the object `function` is called when this object is called and `paramOffset`
   * is the difference from the parameter position and the argument position.
   * For a normal function `paramOffset` is 0. For classes and bound-methods it is 1.
   * This is used to implement the `CallableValue` public API.
   */
  predicate functionAndOffset(CallableObjectInternal function, int offset) { none() }

  /**
   * Holds if this 'object' represents an entity that should be exposed to the legacy points_to API
   * This should hold for almost all objects that do not have an underlying DB object representing their source,
   * for example `super` objects and bound-method. This should not hold for objects that are inferred to exists by
   * an import statements or the like, but which aren't in the database.
   */
  /* This predicate can be removed when the legacy points_to API is removed. */
  abstract predicate useOriginAsLegacyObject();

  /**
   * Gets the name of this of this object if it has a meaningful name.
   * Note that the name of an object is not necessarily the name by which it is called
   * For example the function named `posixpath.join` will be called `os.path.join`.
   */
  abstract string getName();

  abstract predicate contextSensitiveCallee();

  /**
   * Gets the 'object' resulting from iterating over this object.
   * Used in the context `for i in this:`. The result is the 'object'
   * assigned to `i`.
   */
  abstract ObjectInternal getIterNext();

  /** Holds if this value has the attribute `name` */
  predicate hasAttribute(string name) { this.(ObjectInternal).attribute(name, _, _) }

  abstract predicate isNotSubscriptedType();
}

class BuiltinOpaqueObjectInternal extends ObjectInternal, TBuiltinOpaqueObject {
  override Builtin getBuiltin() { this = TBuiltinOpaqueObject(result) }

  override string toString() { result = this.getBuiltin().getClass().getName() + " object" }

  override boolean booleanValue() {
    // TO DO ... Depends on class. `result = this.getClass().instancesBooleanValue()`
    result = maybe()
  }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = TBuiltinClassObject(this.getBuiltin().getClass()) }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { any() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override ControlFlowNode getOrigin() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    value = ObjectInternal::fromBuiltin(this.getBuiltin().getMember(name)) and
    origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { exists(this.getBuiltin().getItem(_)) }

  override boolean isDescriptor() { result = false }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override string getName() { result = this.getBuiltin().getName() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { any() }
}

class UnknownInternal extends ObjectInternal, TUnknown {
  override string toString() { result = "Unknown value" }

  override boolean booleanValue() { result = maybe() }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = TUnknownClass() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { any() }

  override Builtin getBuiltin() { result = Builtin::unknown() }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override ControlFlowNode getOrigin() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { any() }

  override predicate subscriptUnknown() { any() }

  override boolean isDescriptor() { result = false }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { result = -1 }

  override string getName() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { any() }
}

class UndefinedInternal extends ObjectInternal, TUndefined {
  override string toString() { result = "Undefined variable" }

  override boolean booleanValue() { none() }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override predicate notTestableForEquality() { any() }

  override ObjectInternal getClass() { none() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override Builtin getBuiltin() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // Accessing an undefined value raises a NameError, but if during import it probably
    // means that we missed an import.
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override ControlFlowNode getOrigin() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { none() }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override string getName() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /**
   * Holds if this object requires context to determine the object resulting from a call to it.
   * True for most callables.
   */
  override predicate contextSensitiveCallee() { none() }

  override ObjectInternal getIterNext() { none() }

  override predicate isNotSubscriptedType() { any() }
}

module ObjectInternal {
  ObjectInternal bool(boolean b) {
    b = true and result = TTrue()
    or
    b = false and result = TFalse()
  }

  ObjectInternal none_() { result = TNone() }

  ObjectInternal unknown() { result = TUnknown() }

  ClassObjectInternal unknownClass() { result = TUnknownClass() }

  ObjectInternal undefined() { result = TUndefined() }

  ObjectInternal builtin(string name) {
    result = TBuiltinClassObject(Builtin::builtin(name))
    or
    result = TBuiltinFunctionObject(Builtin::builtin(name))
    or
    result = TBuiltinOpaqueObject(Builtin::builtin(name))
    or
    name = "type" and result = TType()
  }

  ObjectInternal sysModules() {
    result = TBuiltinOpaqueObject(Builtin::special("sys").getMember("modules"))
  }

  ObjectInternal fromInt(int n) { result = TInt(n) }

  ObjectInternal fromBuiltin(Builtin b) {
    b = result.getBuiltin() and
    not b = Builtin::unknown() and
    not b = Builtin::unknownType() and
    not b = Builtin::special("sys").getMember("version_info")
    or
    b = Builtin::special("sys").getMember("version_info") and result = TSysVersionInfo()
  }

  ObjectInternal classMethod() { result = TBuiltinClassObject(Builtin::special("ClassMethod")) }

  ObjectInternal staticMethod() { result = TBuiltinClassObject(Builtin::special("StaticMethod")) }

  ObjectInternal boundMethod() { result = TBuiltinClassObject(Builtin::special("MethodType")) }

  ObjectInternal moduleType() { result = TBuiltinClassObject(Builtin::special("ModuleType")) }

  ObjectInternal noneType() { result = TBuiltinClassObject(Builtin::special("NoneType")) }

  ObjectInternal type() { result = TType() }

  ObjectInternal property() { result = TBuiltinClassObject(Builtin::special("property")) }

  ObjectInternal superType() { result = TBuiltinClassObject(Builtin::special("super")) }

  /** The old-style class type (Python 2 only) */
  ObjectInternal classType() { result = TBuiltinClassObject(Builtin::special("ClassType")) }

  ObjectInternal emptyTuple() { result.(BuiltinTupleObjectInternal).length() = 0 }
}

class DecoratedFunction extends ObjectInternal, TDecoratedFunction {
  CallNode getDecoratorCall() { this = TDecoratedFunction(result) }

  override Builtin getBuiltin() { none() }

  private ObjectInternal decoratedObject() {
    PointsTo::pointsTo(this.getDecoratorCall().getArg(0), _, result, _)
  }

  override string getName() { result = this.decoratedObject().getName() }

  override string toString() {
    result = "Decorated " + bounded_toString(this.decoratedObject())
    or
    not exists(this.decoratedObject()) and result = "Decorated function"
  }

  override boolean booleanValue() { result = true }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = TUnknownClass() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override ControlFlowNode getOrigin() { result = this.getDecoratorCall() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { result = false }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override ObjectInternal getIterNext() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  override predicate isNotSubscriptedType() { any() }
}

/** Helper for boolean predicates returning both `true` and `false` */
boolean maybe() { result = true or result = false }

/** Helper for attributes */
pragma[nomagic]
predicate receiver_type(AttrNode attr, string name, ObjectInternal value, ClassObjectInternal cls) {
  PointsToInternal::pointsTo(attr.getObject(name), _, value, _) and value.getClass() = cls
}

/**
 * Returns a string representation of `obj`. Because some classes have (mutually) recursive
 * `toString` implementations, this predicate acts as a stop for these classes, preventing an
 * unbounded `toString` from being materialized.
 */
string bounded_toString(ObjectInternal obj) {
  if
    obj instanceof DecoratedFunction or
    obj instanceof TupleObjectInternal or
    obj instanceof SubscriptedTypeInternal or
    obj instanceof SuperInstance
  then result = "(...)"
  else result = obj.toString()
}
