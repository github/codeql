import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins

/** Class representing classes */
abstract class ClassObjectInternal extends ObjectInternal {
  override string getName() { result = this.getClassDeclaration().getName() }

  /**
   * Holds if this is a class whose instances we treat specially, rather than as a generic instance.
   * For example, `type` or `int`.
   */
  boolean isSpecial() { result = Types::getMro(this).containsSpecial() }

  /**
   * Looks up the attribute `name` on this class.
   * Note that this may be different from `this.attr(name)`.
   * For example given the class:
   * ```class C:
   *        @classmethod
   *        def f(cls): pass
   * ```
   * `this.lookup("f")` is equivalent to `C.__dict__['f']`, which is the class-method
   *  whereas
   * `this.attr("f") is equivalent to `C.f`, which is a bound-method.
   */
  abstract predicate lookup(string name, ObjectInternal value, CfgOrigin origin);

  /** Holds if this is a subclass of the `Iterable` abstract base class. */
  boolean isIterableSubclass() {
    this = ObjectInternal::builtin("list") and result = true
    or
    this = ObjectInternal::builtin("set") and result = true
    or
    this = ObjectInternal::builtin("dict") and result = true
    or
    this != ObjectInternal::builtin("list") and
    this != ObjectInternal::builtin("set") and
    this != ObjectInternal::builtin("dict") and
    result = false
  }

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
    instance = this and
    PointsToInternal::attributeRequired(this, name) and
    this.lookup(name, descriptor, _) and
    descriptor.isDescriptor() = true
  }

  /** Approximation to descriptor protocol, skipping meta-descriptor protocol */
  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    exists(ObjectInternal descriptor, CfgOrigin desc_origin |
      this.lookup(name, descriptor, desc_origin)
    |
      descriptor.isDescriptor() = false and
      value = descriptor and
      origin = desc_origin
      or
      descriptor.isDescriptor() = true and
      descriptor.descriptorGetClass(this, value, origin)
    )
  }

  override int length() { none() }

  override boolean booleanValue() { result = true }

  override boolean isClass() { result = true }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate subscriptUnknown() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Classes aren't usually iterable, but can e.g. Enums */
  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate hasAttribute(string name) {
    this.getClassDeclaration().declaresAttribute(name)
    or
    Types::getBase(this, _).hasAttribute(name)
  }

  override predicate isNotSubscriptedType() { any() }
}

/** Class representing Python source classes */
class PythonClassObjectInternal extends ClassObjectInternal, TPythonClassObject {
  /** Gets the scope for this Python class */
  Class getScope() {
    exists(ClassExpr expr |
      this = TPythonClassObject(expr.getAFlowNode()) and
      result = expr.getInnerScope()
    )
  }

  override string toString() { result = "class " + this.getScope().getName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    this = TPythonClassObject(node) and context.appliesTo(node)
  }

  override ClassDecl getClassDeclaration() { this = TPythonClassObject(result) }

  override ObjectInternal getClass() { result = Types::getMetaClass(this) }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TPythonClassObject(result) }

  override predicate calleeAndOffset(Function scope, int paramOffset) {
    exists(PythonFunctionObjectInternal init |
      this.lookup("__init__", init, _) and
      init.calleeAndOffset(scope, paramOffset - 1)
    )
  }

  override predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    Types::getMro(this).lookup(name, value, origin)
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // Handled by Instance classes.
    none()
  }

  override predicate notTestableForEquality() { none() }

  override predicate functionAndOffset(CallableObjectInternal function, int offset) {
    this.lookup("__init__", function, _) and offset = 1
  }
}

/** Class representing built-in classes, except `type` */
class BuiltinClassObjectInternal extends ClassObjectInternal, TBuiltinClassObject {
  override Builtin getBuiltin() { this = TBuiltinClassObject(result) }

  override string toString() { result = "builtin-class " + this.getBuiltin().getName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ClassDecl getClassDeclaration() { this = TBuiltinClassObject(result) }

  override ObjectInternal getClass() {
    result = TBuiltinClassObject(this.getBuiltin().getClass())
    or
    this.getBuiltin().getClass() = Builtin::special("type") and
    result = TType()
  }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    Types::getMro(this).lookup(name, value, origin)
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    // Handled by Instance classes.
    none()
  }

  override predicate notTestableForEquality() { none() }
}

/** A class representing an unknown class */
class UnknownClassInternal extends ClassObjectInternal, TUnknownClass {
  override string toString() { result = "Unknown class" }

  override ClassDecl getClassDeclaration() { result = Builtin::unknownType() }

  override ObjectInternal getClass() { result = this }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { any() }

  override Builtin getBuiltin() { result = Builtin::unknownType() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate lookup(string name, ObjectInternal value, CfgOrigin origin) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { any() }
}

/** A class representing the built-in class `type`. */
class TypeInternal extends ClassObjectInternal, TType {
  override string toString() { result = "builtin-class type" }

  override ClassDecl getClassDeclaration() { result = Builtin::special("type") }

  override ObjectInternal getClass() { result = this }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { result = Builtin::special("type") }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    Types::getMro(this).lookup(name, value, origin)
  }

  pragma[noinline]
  override predicate attributesUnknown() { any() }
}

/** A class representing a dynamically created class `type(name, *args, **kwargs)`. */
class DynamicallyCreatedClass extends ClassObjectInternal, TDynamicClass {
  override string toString() { result = this.getOrigin().getNode().toString() }

  override ObjectInternal getClass() { this = TDynamicClass(_, result, _) }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    exists(ClassObjectInternal decl | decl = Types::getMro(this).findDeclaringClass(name) |
      Types::declaredAttribute(decl, name, value, origin)
    )
  }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TDynamicClass(result, _, _) }

  pragma[noinline]
  override predicate attributesUnknown() { any() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    this = TDynamicClass(node, _, context)
  }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate notTestableForEquality() { none() }

  override ClassDecl getClassDeclaration() { none() }
}

class SubscriptedTypeInternal extends ObjectInternal, TSubscriptedType {
  ObjectInternal getGeneric() { this = TSubscriptedType(result, _) }

  ObjectInternal getSpecializer() { this = TSubscriptedType(_, result) }

  override string getName() { result = this.getGeneric().getName() }

  override string toString() {
    result =
      bounded_toString(this.getGeneric()) + "[" + bounded_toString(this.getSpecializer()) + "]"
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    exists(ObjectInternal generic, ObjectInternal index |
      this = TSubscriptedType(generic, index) and
      Expressions::subscriptPartsPointsTo(node, context, generic, index)
    )
  }

  /** Gets the class declaration for this object, if it is a class with a declaration. */
  override ClassDecl getClassDeclaration() { result = this.getGeneric().getClassDeclaration() }

  /** True if this "object" is a class. That is, its class inherits from `type` */
  override boolean isClass() { result = true }

  override ObjectInternal getClass() { result = this.getGeneric().getClass() }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  override predicate attributesUnknown() { none() }

  override boolean isDescriptor() { result = false }

  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override boolean booleanValue() { result = true }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate subscriptUnknown() { none() }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Classes aren't usually iterable, but can e.g. Enums */
  override ObjectInternal getIterNext() { result = ObjectInternal::unknown() }

  override predicate isNotSubscriptedType() { none() }
}
