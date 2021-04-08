import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins

/** Class representing property objects in Python */
class PropertyInternal extends ObjectInternal, TProperty {
  /** Gets the name of this property */
  override string getName() { result = this.getGetter().getName() }

  /** Gets the getter function of this property */
  CallableObjectInternal getGetter() { this = TProperty(_, _, result) }

  private CallNode getCallNode() { this = TProperty(result, _, _) }

  /** Gets the setter function of this property */
  CallableObjectInternal getSetter() {
    // @x.setter
    exists(CallNode call, AttrNode setter |
      call.getFunction() = setter and
      PointsToInternal::pointsTo(setter.getObject("setter"), this.getContext(), this, _) and
      PointsToInternal::pointsTo(call.getArg(0), this.getContext(), result, _)
    )
    or
    // x = property(getter, setter, deleter)
    exists(ControlFlowNode setter_arg |
      setter_arg = getCallNode().getArg(1) or setter_arg = getCallNode().getArgByName("fset")
    |
      PointsToInternal::pointsTo(setter_arg, this.getContext(), result, _)
    )
  }

  /** Gets the setter function of this property */
  CallableObjectInternal getDeleter() {
    exists(CallNode call, AttrNode setter |
      call.getFunction() = setter and
      PointsToInternal::pointsTo(setter.getObject("deleter"), this.getContext(), this, _) and
      PointsToInternal::pointsTo(call.getArg(0), this.getContext(), result, _)
    )
    or
    // x = property(getter, setter, deleter)
    exists(ControlFlowNode deleter_arg |
      deleter_arg = getCallNode().getArg(2) or deleter_arg = getCallNode().getArgByName("fdel")
    |
      PointsToInternal::pointsTo(deleter_arg, this.getContext(), result, _)
    )
  }

  private Context getContext() { this = TProperty(_, result, _) }

  override string toString() { result = "property " + this.getName() }

  override boolean booleanValue() { result = true }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    this = TProperty(node, context, _)
  }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = ObjectInternal::property() }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TProperty(result, _, _) }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    value = TPropertySetterOrDeleter(this, name) and origin = CfgOrigin::unknown()
  }

  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { result = true }

  override int length() { none() }

  override predicate binds(ObjectInternal cls, string name, ObjectInternal descriptor) { none() }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    any(ObjectInternal obj).binds(cls, _, this) and
    value = this and
    origin = CfgOrigin::fromCfgNode(this.getOrigin())
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    /*
     * Just give an unknown value for now. We could improve this, but it would mean
     * changing Contexts to account for property accesses.
     */

    exists(ClassObjectInternal cls, string name |
      name = this.getName() and
      receiver_type(_, name, instance, cls) and
      cls.lookup(name, this, _) and
      origin = CfgOrigin::unknown() and
      value = ObjectInternal::unknown()
    )
  }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Properties aren't iterable */
  override ObjectInternal getIterNext() { none() }

  override predicate isNotSubscriptedType() { any() }
}

private class PropertySetterOrDeleter extends ObjectInternal, TPropertySetterOrDeleter {
  override string toString() { result = this.getProperty().toString() + "." + this.getName() }

  override string getName() { this = TPropertySetterOrDeleter(_, result) }

  PropertyInternal getProperty() { this = TPropertySetterOrDeleter(result, _) }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    exists(ControlFlowNode call |
      obj = this.getProperty() and
      obj = TProperty(call, _, _) and
      origin = CfgOrigin::fromCfgNode(call)
    )
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() {
    result = TBuiltinClassObject(Builtin::special("MethodType"))
  }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override boolean booleanValue() { result = true }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { result = true }

  override int length() { none() }

  override predicate binds(ObjectInternal cls, string name, ObjectInternal descriptor) { none() }

  override predicate contextSensitiveCallee() { none() }

  override ObjectInternal getIterNext() { none() }

  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  override predicate useOriginAsLegacyObject() { none() }

  override predicate isNotSubscriptedType() { any() }
}

/** A class representing classmethods in Python */
class ClassMethodObjectInternal extends ObjectInternal, TClassMethod {
  override string toString() { result = "classmethod(" + this.getFunction() + ")" }

  override boolean booleanValue() { result = true }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    exists(CallableObjectInternal function |
      this = TClassMethod(node, function) and
      class_method(node, function, context)
    )
  }

  /** Gets the function wrapped by this classmethod object */
  CallableObjectInternal getFunction() { this = TClassMethod(_, result) }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = ObjectInternal::classMethod() }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TClassMethod(result, _) }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { result = true }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    value = TBoundMethod(cls, this.getFunction()) and
    origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    any(ObjectInternal obj).binds(instance, _, this) and
    value = TBoundMethod(instance.getClass(), this.getFunction()) and
    origin = CfgOrigin::unknown()
  }

  /**
   * Holds if attribute lookup on this object may "bind" `cls` to `descriptor`.
   * `cls` will always be a class as this is a classmethod.
   * Here "bind" means that `instance` is passed to the `classmethod.__get__()` method
   * at runtime. The term "bind" is used as this most likely results in a bound-method.
   */
  pragma[noinline]
  override predicate binds(ObjectInternal cls, string name, ObjectInternal descriptor) {
    descriptor = this.getFunction() and
    exists(ObjectInternal instance | any(ObjectInternal obj).binds(instance, name, this) |
      instance.isClass() = false and cls = instance.getClass()
      or
      instance.isClass() = true and cls = instance
    )
  }

  override int length() { none() }

  override string getName() { result = this.getFunction().getName() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Classmethods aren't iterable */
  override ObjectInternal getIterNext() { none() }

  override predicate isNotSubscriptedType() { any() }
}

class StaticMethodObjectInternal extends ObjectInternal, TStaticMethod {
  override string toString() { result = "staticmethod()" }

  override boolean booleanValue() { result = true }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    exists(CallableObjectInternal function |
      this = TStaticMethod(node, function) and
      static_method(node, function, context)
    )
  }

  CallableObjectInternal getFunction() { this = TStaticMethod(_, result) }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = ObjectInternal::builtin("staticmethod") }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TStaticMethod(result, _) }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) {
    this.getFunction().calleeAndOffset(scope, paramOffset)
  }

  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override boolean isDescriptor() { result = true }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    any(ObjectInternal obj).binds(cls, _, this) and
    value = this.getFunction() and
    origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    any(ObjectInternal obj).binds(instance, _, this) and
    value = this.getFunction() and
    origin = CfgOrigin::unknown()
  }

  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override string getName() { result = this.getFunction().getName() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Staticmethods aren't iterable */
  override ObjectInternal getIterNext() { none() }

  override predicate isNotSubscriptedType() { any() }
}
