import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins

abstract class CallableObjectInternal extends ObjectInternal {
  /** Gets the scope of this callable if it has one */
  abstract Function getScope();

  /** Gets a call to this callable from the given context */
  abstract CallNode getACall(PointsToContext ctx);

  /** Gets a call to this callable */
  CallNode getACall() { result = this.getACall(_) }

  override boolean isClass() { result = false }

  override boolean booleanValue() { result = true }

  override ClassDecl getClassDeclaration() { none() }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  /** Gets the `n`th parameter node of this callable. */
  abstract NameNode getParameter(int n);

  /** Gets the `name`d parameter node of this callable. */
  abstract NameNode getParameterByName(string name);

  abstract predicate neverReturns();

  override int length() { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override predicate subscriptUnknown() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  /* Callables aren't iterable */
  override ObjectInternal getIterNext() { none() }
}

/** Class representing Python functions */
class PythonFunctionObjectInternal extends CallableObjectInternal, TPythonFunctionObject {
  override Function getScope() {
    exists(CallableExpr expr |
      this = TPythonFunctionObject(expr.getAFlowNode()) and
      result = expr.getInnerScope()
    )
  }

  override string toString() { result = "Function " + this.getScope().getQualifiedName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    this = TPythonFunctionObject(node) and context.appliesTo(node)
  }

  override ObjectInternal getClass() {
    result = TBuiltinClassObject(Builtin::special("FunctionType"))
  }

  override predicate notTestableForEquality() { none() }

  override Builtin getBuiltin() { none() }

  override ControlFlowNode getOrigin() { this = TPythonFunctionObject(result) }

  pragma[nomagic]
  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    exists(Function func, ControlFlowNode rval, ControlFlowNode forigin |
      func = this.getScope() and
      callee.appliesToScope(func)
    |
      rval = func.getAReturnValueFlowNode() and
      PointsToInternal::pointsTo(rval, callee, obj, forigin) and
      origin = CfgOrigin::fromCfgNode(forigin)
    )
    or
    procedureReturnsNone(callee, obj, origin)
  }

  private predicate procedureReturnsNone(
    PointsToContext callee, ObjectInternal obj, CfgOrigin origin
  ) {
    exists(Function func |
      func = this.getScope() and
      callee.appliesToScope(func)
    |
      PointsToInternal::reachableBlock(blockReturningNone(func), callee) and
      obj = ObjectInternal::none_() and
      origin = CfgOrigin::unknown()
    )
  }

  pragma[noinline]
  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    this.getScope().isProcedure() and
    obj = ObjectInternal::none_() and
    origin = CfgOrigin::fromCfgNode(this.getScope().getEntryNode())
  }

  override predicate calleeAndOffset(Function scope, int paramOffset) {
    scope = this.getScope() and paramOffset = 0
  }

  override string getName() { result = this.getScope().getName() }

  override boolean isDescriptor() { result = true }

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
    value = TBoundMethod(instance, this) and origin = CfgOrigin::unknown()
  }

  override CallNode getACall(PointsToContext ctx) {
    PointsTo::pointsTo(result.getFunction(), ctx, this, _)
    or
    exists(BoundMethodObjectInternal bm | bm.getACall(ctx) = result and this = bm.getFunction())
  }

  override NameNode getParameter(int n) { result.getNode() = this.getScope().getArg(n) }

  override NameNode getParameterByName(string name) {
    result.getNode() = this.getScope().getArgByName(name)
  }

  override predicate neverReturns() { InterProceduralPointsTo::neverReturns(this.getScope()) }

  override predicate functionAndOffset(CallableObjectInternal function, int offset) {
    function = this and offset = 0
  }

  override predicate contextSensitiveCallee() { any() }

  override predicate useOriginAsLegacyObject() { none() }

  override predicate isNotSubscriptedType() { any() }
}

private BasicBlock blockReturningNone(Function func) {
  exists(Return ret |
    not exists(ret.getValue()) and
    ret.getScope() = func and
    result = ret.getAFlowNode().getBasicBlock()
  )
}

/** Class representing built-in functions such as `len` or `print`. */
class BuiltinFunctionObjectInternal extends CallableObjectInternal, TBuiltinFunctionObject {
  override Builtin getBuiltin() { this = TBuiltinFunctionObject(result) }

  override string toString() { result = "Builtin-function " + this.getBuiltin().getName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ObjectInternal getClass() { result = TBuiltinClassObject(this.getBuiltin().getClass()) }

  override predicate notTestableForEquality() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    exists(Builtin func, BuiltinClassObjectInternal cls |
      func = this.getBuiltin() and
      func != Builtin::builtin("isinstance") and
      func != Builtin::builtin("issubclass") and
      func != Builtin::builtin("callable") and
      cls = ObjectInternal::fromBuiltin(this.getReturnType())
    |
      obj = TUnknownInstance(cls)
      or
      cls = ObjectInternal::noneType() and obj = ObjectInternal::none_()
      or
      cls = ObjectInternal::builtin("bool") and obj = ObjectInternal::bool(_)
    ) and
    origin = CfgOrigin::unknown()
    or
    this.returnTypeUnknown() and
    obj = ObjectInternal::unknown() and
    origin = CfgOrigin::unknown()
  }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override string getName() { result = this.getBuiltin().getName() }

  Builtin getReturnType() {
    exists(Builtin func |
      func = this.getBuiltin() and
      result = getBuiltinFunctionReturnType(func)
    )
  }

  private predicate returnTypeUnknown() {
    exists(Builtin func |
      func = this.getBuiltin() and
      not exists(getBuiltinFunctionReturnType(func))
    )
  }

  override Function getScope() { none() }

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

  override CallNode getACall(PointsToContext ctx) {
    PointsTo::pointsTo(result.getFunction(), ctx, this, _)
  }

  override NameNode getParameter(int n) { none() }

  override NameNode getParameterByName(string name) { none() }

  override predicate neverReturns() {
    exists(ModuleObjectInternal sys |
      sys.getName() = "sys" and
      sys.attribute("exit", this, _)
    )
  }

  override predicate functionAndOffset(CallableObjectInternal function, int offset) {
    function = this and offset = 0
  }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  override predicate isNotSubscriptedType() { any() }
}

private Builtin getBuiltinFunctionReturnType(Builtin func) {
  /* Enumerate the types of a few builtin functions, that the CPython analysis misses. */
  func = Builtin::builtin("hex") and result = Builtin::special("str")
  or
  func = Builtin::builtin("oct") and result = Builtin::special("str")
  or
  func = Builtin::builtin("intern") and result = Builtin::special("str")
  or
  func = Builtin::builtin("__import__") and result = Builtin::special("ModuleType")
  or
  /* Fix a few minor inaccuracies in the CPython analysis */
  ext_rettype(func, result) and
  not (
    func = Builtin::builtin("__import__")
    or
    func = Builtin::builtin("compile") and result = Builtin::special("NoneType")
    or
    func = Builtin::builtin("sum")
    or
    func = Builtin::builtin("filter")
  )
}

/** Class representing methods of built-in classes (otherwise known as method-descriptors) such as `list.append`. */
class BuiltinMethodObjectInternal extends CallableObjectInternal, TBuiltinMethodObject {
  override Builtin getBuiltin() { this = TBuiltinMethodObject(result) }

  override string toString() { result = "builtin method " + this.getBuiltin().getName() }

  override ObjectInternal getClass() { result = TBuiltinClassObject(this.getBuiltin().getClass()) }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { none() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    exists(Builtin func, BuiltinClassObjectInternal cls |
      func = this.getBuiltin() and
      cls = ObjectInternal::fromBuiltin(this.getReturnType())
    |
      obj = TUnknownInstance(cls)
      or
      cls = ObjectInternal::noneType() and obj = ObjectInternal::none_()
      or
      cls = ObjectInternal::builtin("bool") and obj = ObjectInternal::bool(_)
    ) and
    origin = CfgOrigin::unknown()
    or
    this.returnTypeUnknown() and
    obj = ObjectInternal::unknown() and
    origin = CfgOrigin::unknown()
  }

  Builtin getReturnType() {
    /* If we have a record of the return type in our stubs, use that. */
    exists(Builtin func | func = this.getBuiltin() | ext_rettype(func, result))
  }

  private predicate returnTypeUnknown() {
    exists(Builtin func | func = this.getBuiltin() | not ext_rettype(func, _))
  }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  override string getName() { result = this.getBuiltin().getName() }

  override Function getScope() { none() }

  override boolean isDescriptor() { result = true }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    any(ObjectInternal obj).binds(cls, _, this) and
    value = this and
    origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    value = TBoundMethod(instance, this) and origin = CfgOrigin::unknown()
  }

  override CallNode getACall(PointsToContext ctx) {
    PointsTo::pointsTo(result.getFunction(), ctx, this, _)
  }

  override NameNode getParameter(int n) { none() }

  override NameNode getParameterByName(string name) { none() }

  override predicate neverReturns() { none() }

  override predicate functionAndOffset(CallableObjectInternal function, int offset) {
    function = this and offset = 0
  }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  override predicate isNotSubscriptedType() { any() }
}

/**
 * Class representing bound-methods.
 * Note that built-in methods, such as `[].append` are also represented as bound-methods.
 * Although built-in methods and bound-methods are distinct classes in CPython, their behaviour
 * is the same and we treat them identically.
 */
class BoundMethodObjectInternal extends CallableObjectInternal, TBoundMethod {
  override Builtin getBuiltin() { none() }

  CallableObjectInternal getFunction() { this = TBoundMethod(_, result) }

  ObjectInternal getSelf() { this = TBoundMethod(result, _) }

  override string toString() {
    result = "Method(" + this.getFunction() + ", " + this.getSelf() + ")"
  }

  override ObjectInternal getClass() {
    result = TBuiltinClassObject(Builtin::special("MethodType"))
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override predicate notTestableForEquality() { any() }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    this.getFunction().callResult(callee, obj, origin)
  }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    this.getFunction().callResult(obj, origin)
  }

  override ControlFlowNode getOrigin() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) {
    this.getFunction().calleeAndOffset(scope, paramOffset - 1)
  }

  override string getName() { result = this.getFunction().getName() }

  override Function getScope() { result = this.getFunction().getScope() }

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

  override CallNode getACall(PointsToContext ctx) {
    PointsTo::pointsTo(result.getFunction(), ctx, this, _)
  }

  /** Gets the parameter node that will be used for `self`. */
  NameNode getSelfParameter() { result = this.getFunction().getParameter(0) }

  override NameNode getParameter(int n) {
    result = this.getFunction().getParameter(n + 1) and
    // don't return the parameter for `self` at `n = -1`
    n >= 0
  }

  /**
   * Gets the `name`d parameter node of this callable.
   * Will not return the parameter node for `self`, instead use `getSelfParameter`.
   */
  override NameNode getParameterByName(string name) {
    result = this.getFunction().getParameterByName(name) and
    not result = this.getSelfParameter()
  }

  override predicate neverReturns() { this.getFunction().neverReturns() }

  override predicate functionAndOffset(CallableObjectInternal function, int offset) {
    function = this.getFunction() and offset = 1
    or
    function = this and offset = 0
  }

  override predicate useOriginAsLegacyObject() { any() }

  override predicate contextSensitiveCallee() { this.getFunction().contextSensitiveCallee() }

  override predicate isNotSubscriptedType() { any() }
}
