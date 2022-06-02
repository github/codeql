import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins

/** A class representing instances */
abstract class InstanceObject extends ObjectInternal {
  pragma[nomagic]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    exists(ObjectInternal cls_attr | this.classAttribute(name, cls_attr) |
      /*
       * If class attribute is not a descriptor, that usually means it is some sort of
       * default value and likely overridden by an instance attribute. In that case
       * use `unknown` to signal that an attribute exists but to avoid false positives
       * f using the default value.
       */

      cls_attr.isDescriptor() = false and
      value = ObjectInternal::unknown() and
      origin = CfgOrigin::unknown()
      or
      cls_attr.isDescriptor() = true and cls_attr.descriptorGetInstance(this, value, origin)
    )
    or
    this.selfAttribute(name, value, origin)
  }

  pragma[noinline]
  private predicate classAttribute(string name, ObjectInternal cls_attr) {
    PointsToInternal::attributeRequired(this, pragma[only_bind_into](name)) and
    this.getClass().(ClassObjectInternal).lookup(pragma[only_bind_into](name), cls_attr, _)
  }

  pragma[noinline]
  private predicate selfAttribute(string name, ObjectInternal value, CfgOrigin origin) {
    PointsToInternal::attributeRequired(this, pragma[only_bind_into](name)) and
    exists(EssaVariable self, PythonFunctionObjectInternal init, Context callee |
      this.initializer(init, callee) and
      self_variable_reaching_init_exit(self) and
      self.getScope() = init.getScope() and
      AttributePointsTo::variableAttributePointsTo(self, callee, pragma[only_bind_into](name),
        value, origin)
    )
  }

  /** Holds if `init` in the context `callee` is the initializer of this instance */
  abstract predicate initializer(PythonFunctionObjectInternal init, Context callee);

  override string getName() { none() }

  override predicate contextSensitiveCallee() { none() }

  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { any() }
}

private predicate self_variable_reaching_init_exit(EssaVariable self) {
  BaseFlow::reaches_exit(self) and
  self.getSourceVariable().(Variable).isSelf() and
  self.getScope().getName() = "__init__"
}

/**
 * A class representing instances instantiated at a specific point in the program (statically)
 * For example the code `C()` would be a specific instance of `C`.
 */
class SpecificInstanceInternal extends TSpecificInstance, InstanceObject {
  override string toString() { result = this.getOrigin().getNode().toString() }

  override boolean booleanValue() {
    //result = this.getClass().instancesBooleanValue()
    result = maybe()
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    this = TSpecificInstance(node, _, context)
  }

  /** Gets the class declaration for this object, if it is a declared class. */
  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override predicate notTestableForEquality() { none() }

  override ObjectInternal getClass() {
    exists(ClassObjectInternal cls, ClassDecl decl |
      this = TSpecificInstance(_, cls, _) and
      decl = cls.getClassDeclaration()
    |
      if decl.callReturnsInstance() then result = cls else result = TUnknownClass()
    )
  }

  /**
   * Gets the `Builtin` for this object, if any.
   * All objects (except unknown and undefined values) should return
   * exactly one result for either this method or `getOrigin()`.
   */
  override Builtin getBuiltin() { none() }

  /**
   * Gets a control flow node that represents the source origin of this
   * objects.
   * All objects (except unknown and undefined values) should return
   * exactly one result for either this method or `getBuiltin()`.
   */
  override ControlFlowNode getOrigin() { this = TSpecificInstance(result, _, _) }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // TO DO -- Handle cases where class overrides __call__ in more detail, like normal calls.
    this.getClass().(ClassObjectInternal).lookup("__call__", _, _) and
    obj = ObjectInternal::unknown() and
    origin = CfgOrigin::unknown()
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

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
    exists(ClassObjectInternal cls |
      receiver_type(_, name, this, cls) and
      cls.lookup(name, descriptor, _) and
      descriptor.isDescriptor() = true
    ) and
    this = instance
  }

  override int length() { result = lengthFromClass(this.getClass()) }

  override predicate initializer(PythonFunctionObjectInternal init, Context callee) {
    exists(CallNode call, Context caller, ClassObjectInternal cls |
      this = TSpecificInstance(call, cls, caller) and
      callee.fromCall(this.getOrigin(), caller) and
      cls.lookup("__init__", init, _)
    )
  }

  override predicate useOriginAsLegacyObject() { none() }
}

/**
 * A class representing context-free instances represented by `self` in the source code
 */
class SelfInstanceInternal extends TSelfInstance, InstanceObject {
  override string toString() {
    result = "self instance of " + this.getClass().(ClassObjectInternal).getName()
  }

  override boolean booleanValue() {
    //result = this.getClass().instancesBooleanValue()
    result = maybe()
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  predicate parameterAndContext(ParameterDefinition def, PointsToContext context) {
    this = TSelfInstance(def, context, _)
  }

  /** Gets the class declaration for this object, if it is a declared class. */
  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override predicate notTestableForEquality() { any() }

  override ObjectInternal getClass() { this = TSelfInstance(_, _, result) }

  ParameterDefinition getParameter() { this = TSelfInstance(result, _, _) }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() {
    exists(ParameterDefinition def |
      this = TSelfInstance(def, _, _) and
      result = def.getDefiningNode()
    )
  }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // In general instances aren't callable, but some are...
    // TO DO -- Handle cases where class overrides __call__
    none()
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

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
    exists(AttrNode attr, ClassObjectInternal cls |
      receiver_type(attr, name, this, cls) and
      cls_descriptor(cls, name, descriptor)
    ) and
    instance = this
  }

  override int length() { result = lengthFromClass(this.getClass()) }

  override predicate initializer(PythonFunctionObjectInternal init, Context callee) {
    callee.isRuntime() and
    init.getScope() != this.getParameter().getScope() and
    this.getClass().attribute("__init__", init, _)
  }

  override predicate useOriginAsLegacyObject() { none() }
}

/** A class representing a value that has a known class, but no other information */
class UnknownInstanceInternal extends TUnknownInstance, ObjectInternal {
  override string toString() {
    result = "instance of " + this.getClass().(ClassObjectInternal).getName()
  }

  override boolean booleanValue() { result = maybe() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  /** Gets the class declaration for this object, if it is a declared class. */
  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override predicate notTestableForEquality() { any() }

  override ObjectInternal getClass() { this = TUnknownInstance(result) }

  /**
   * Gets the `Builtin` for this object, if any.
   * All objects (except unknown and undefined values) should return
   * exactly one result for either this method or `getOrigin()`.
   */
  override Builtin getBuiltin() { none() }

  /**
   * Gets a control flow node that represents the source origin of this
   * objects.
   * All objects (except unknown and undefined values) should return
   * exactly one result for either this method or `getBuiltin()`.
   */
  override ControlFlowNode getOrigin() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // In general instances aren't callable, but some are...
    // TO DO -- Handle cases where class overrides __call__
    none()
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    PointsToInternal::attributeRequired(this, pragma[only_bind_into](name)) and
    exists(ObjectInternal cls_attr, CfgOrigin attr_orig |
      this.getClass()
          .(ClassObjectInternal)
          .lookup(pragma[only_bind_into](name), cls_attr, attr_orig)
    |
      cls_attr.isDescriptor() = false and value = cls_attr and origin = attr_orig
      or
      cls_attr.isDescriptor() = true and cls_attr.descriptorGetInstance(this, value, origin)
    )
  }

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
    exists(AttrNode attr, ClassObjectInternal cls |
      receiver_type(attr, name, this, cls) and
      cls_descriptor(cls, name, descriptor)
    ) and
    instance = this
  }

  override int length() { result = lengthFromClass(this.getClass()) }

  override string getName() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { any() }

  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { any() }
}

private int lengthFromClass(ClassObjectInternal cls) {
  Types::getMro(cls).declares("__len__") and result = -1
}

private predicate cls_descriptor(ClassObjectInternal cls, string name, ObjectInternal descriptor) {
  cls.lookup(name, descriptor, _) and
  descriptor.isDescriptor() = true
}

/** A class representing an instance of the `super` class */
class SuperInstance extends TSuperInstance, ObjectInternal {
  override string toString() {
    result =
      "super(" + this.getStartClass().toString() + ", " + bounded_toString(this.getSelf()) + ")"
  }

  override boolean booleanValue() { result = true }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    exists(ObjectInternal self, ClassObjectInternal startclass |
      super_instantiation(node, self, startclass, context) and
      this = TSuperInstance(self, startclass)
    )
  }

  /** Gets the class declared as the starting point for MRO lookup. */
  ClassObjectInternal getStartClass() { this = TSuperInstance(_, result) }

  /** Gets 'self' object */
  ObjectInternal getSelf() { this = TSuperInstance(result, _) }

  override ClassDecl getClassDeclaration() { none() }

  override boolean isClass() { result = false }

  override ObjectInternal getClass() { result = ObjectInternal::superType() }

  override predicate notTestableForEquality() { any() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

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
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    exists(ObjectInternal cls_attr, CfgOrigin attr_orig |
      this.attribute_descriptor(name, cls_attr, attr_orig)
    |
      cls_attr.isDescriptor() = false and value = cls_attr and origin = attr_orig
      or
      cls_attr.isDescriptor() = true and
      cls_attr.descriptorGetInstance(this.getSelf(), value, origin)
    )
  }

  /* Helper for `attribute` */
  pragma[noinline]
  private predicate attribute_descriptor(string name, ObjectInternal cls_attr, CfgOrigin attr_orig) {
    PointsToInternal::attributeRequired(this, pragma[only_bind_into](name)) and
    this.lookup(pragma[only_bind_into](name), cls_attr, attr_orig)
  }

  private predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    Types::getMro(this.getSelf().getClass())
        .startingAt(this.getStartClass())
        .getTail()
        .lookup(name, value, origin)
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    descriptor.isDescriptor() = true and
    this.lookup(name, descriptor, _) and
    instance = this.getSelf() and
    receiver_type(_, name, this, _)
  }

  override int length() { none() }

  override string getName() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { any() }

  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { any() }
}
