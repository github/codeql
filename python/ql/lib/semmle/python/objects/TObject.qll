/** Contains the internal algebraic datatype backing the various values tracked by the points-to implementation. */

import python
private import semmle.python.types.Builtins
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.internal.CachedStages

/**
 * Internal type backing `ObjectInternal` and `Value`
 * See `ObjectInternal.qll` for an explanation of the API.
 */
cached
newtype TObject =
  /** Builtin class objects */
  TBuiltinClassObject(Builtin bltn) {
    bltn.isClass() and
    not bltn = Builtin::unknownType() and
    not bltn = Builtin::special("type")
  } or
  /** Builtin function objects (module members) */
  TBuiltinFunctionObject(Builtin bltn) { bltn.isFunction() } or
  /** Builtin method objects (class members) */
  TBuiltinMethodObject(Builtin bltn) { bltn.isMethod() } or
  /** Builtin module objects */
  TBuiltinModuleObject(Builtin bltn) { bltn.isModule() } or
  /** Other builtin objects from the interpreter */
  TBuiltinOpaqueObject(Builtin bltn) {
    not bltn.isClass() and
    not bltn.isFunction() and
    not bltn.isMethod() and
    not bltn.isModule() and
    not bltn.getClass() = Builtin::special("tuple") and
    not exists(bltn.intValue()) and
    not exists(bltn.floatValue()) and
    not exists(bltn.strValue()) and
    not py_special_objects(bltn, _)
  } or
  /** Python function objects (including lambdas) */
  TPythonFunctionObject(ControlFlowNode callable) { callable.getNode() instanceof CallableExpr } or
  /** Python class objects */
  TPythonClassObject(ControlFlowNode classexpr) { classexpr.getNode() instanceof ClassExpr } or
  /** Package objects */
  TPackageObject(Folder f) { isPreferredModuleForName(f, _) } or
  /** Python module objects */
  TPythonModule(Module m) {
    not m.isPackage() and
    isPreferredModuleForName(m.getFile(), _) and
    not exists(SyntaxError se | se.getFile() = m.getFile())
  } or
  /** `True` */
  TTrue() or
  /** `False` */
  TFalse() or
  /** `None` */
  TNone() or
  /** Represents any value about which nothing useful is known */
  TUnknown() or
  /** Represents any value known to be a class, but not known to be any specific class */
  TUnknownClass() or
  /** Represents the absence of a value. Used by points-to for tracking undefined variables */
  TUndefined() or
  /** The integer `n` */
  TInt(int n) {
    // Powers of 2 are used for flags
    is_power_2(n)
    or
    // And all combinations of flags up to 2^8
    n in [0 .. 511]
    or
    // Any number explicitly mentioned in the source code.
    exists(IntegerLiteral num |
      n = num.getValue()
      or
      exists(UnaryExpr neg | neg.getOp() instanceof USub and neg.getOperand() = num) and
      n = -num.getN().toInt()
    )
    or
    n = any(Builtin b).intValue()
  } or
  /** The float `f` */
  TFloat(float f) { f = any(FloatLiteral num).getValue() } or
  /** The unicode string `s` */
  TUnicode(string s) {
    // Any string explicitly mentioned in the source code.
    exists(StringLiteral str |
      s = str.getText() and
      str.isUnicode()
    )
    or
    // Any string from the library put in the DB by the extractor.
    exists(Builtin b |
      s = b.strValue() and
      b.getClass() = Builtin::special("unicode")
    )
    or
    s = "__main__"
  } or
  /** The byte string `s` */
  TBytes(string s) {
    // Any string explicitly mentioned in the source code.
    exists(StringLiteral str |
      s = str.getText() and
      not str.isUnicode()
    )
    or
    // Any string from the library put in the DB by the extractor.
    exists(Builtin b |
      s = b.strValue() and
      b.getClass() = Builtin::special("bytes")
    )
    or
    s = "__main__"
  } or
  /** An instance of `cls`, instantiated at `instantiation` given the `context`. */
  TSpecificInstance(ControlFlowNode instantiation, ClassObjectInternal cls, PointsToContext context) {
    PointsToInternal::pointsTo(instantiation.(CallNode).getFunction(), context, cls, _) and
    cls.isSpecial() = false
    or
    literal_instantiation(instantiation, cls, context)
  } or
  /** A non-specific instance `cls` which enters the scope at `def` given the callee `context`. */
  TSelfInstance(ParameterDefinition def, PointsToContext context, PythonClassObjectInternal cls) {
    self_parameter(def, context, cls)
  } or
  /** A bound method */
  TBoundMethod(ObjectInternal self, CallableObjectInternal function) {
    any(ObjectInternal obj).binds(self, _, function) and
    function.isDescriptor() = true
  } or
  /** Represents any value whose class is known, but nothing else */
  TUnknownInstance(BuiltinClassObjectInternal cls) {
    cls != ObjectInternal::superType() and
    cls != ObjectInternal::builtin("bool") and
    cls != ObjectInternal::noneType()
  } or
  /** Represents an instance of `super` */
  TSuperInstance(ObjectInternal self, ClassObjectInternal startclass) {
    super_instantiation(_, self, startclass, _)
  } or
  /** Represents an instance of `classmethod` */
  TClassMethod(CallNode instantiation, CallableObjectInternal function) {
    class_method(instantiation, function, _)
  } or
  /** Represents an instance of `staticmethod` */
  TStaticMethod(CallNode instantiation, CallableObjectInternal function) {
    static_method(instantiation, function, _)
  } or
  /** Represents a builtin tuple */
  TBuiltinTuple(Builtin bltn) { bltn.getClass() = Builtin::special("tuple") } or
  /** Represents a tuple in the Python source */
  TPythonTuple(TupleNode origin, PointsToContext context) {
    exists(Scope s |
      context.appliesToScope(s) and
      scope_loads_tuplenode(s, origin)
    )
  } or
  /** Varargs tuple */
  TVarargsTuple(CallNode call, PointsToContext context, int offset, int length) {
    InterProceduralPointsTo::varargs_tuple(call, context, _, _, offset, length)
  } or
  /** `type` */
  TType() or
  /** Represents an instance of `property` */
  TProperty(CallNode call, Context ctx, CallableObjectInternal getter) {
    PointsToInternal::pointsTo(call.getFunction(), ctx, ObjectInternal::property(), _) and
    PointsToInternal::pointsTo(call.getArg(0), ctx, getter, _)
  } or
  /** Represents the `setter` or `deleter` method of a property object. */
  TPropertySetterOrDeleter(PropertyInternal property, string method) {
    exists(AttrNode attr | PointsToInternal::pointsTo(attr.getObject(method), _, property, _)) and
    (method = "setter" or method = "deleter")
  } or
  /** Represents a dynamically created class */
  TDynamicClass(CallNode instantiation, ClassObjectInternal metacls, PointsToContext context) {
    PointsToInternal::pointsTo(instantiation.getFunction(), context, metacls, _) and
    not count(instantiation.getAnArg()) = 1 and
    Types::getMro(metacls).contains(TType())
  } or
  /** Represents `sys.version_info`. Acts like a tuple with a range of values depending on the version being analyzed. */
  TSysVersionInfo() or
  /** Represents a module that is inferred to perhaps exist, but is not present in the database. */
  TAbsentModule(string name) { missing_imported_module(_, _, name) } or
  /** Represents an attribute of a module that is inferred to perhaps exist, but is not present in the database. */
  TAbsentModuleAttribute(AbsentModuleObjectInternal mod, string attrname) {
    (
      PointsToInternal::pointsTo(any(AttrNode attr).getObject(attrname), _, mod, _)
      or
      PointsToInternal::pointsTo(any(ImportMemberNode imp).getModule(attrname), _, mod, _)
    ) and
    exists(string modname |
      modname = mod.getName() and
      not common_module_name(modname + "." + attrname)
    )
  } or
  /** Opaque object representing the result of calling a decorator on a function that we don't understand */
  TDecoratedFunction(CallNode call) { call.isFunctionDecoratorCall() } or
  /** Represents a subscript operation applied to a type. For type-hint analysis */
  TSubscriptedType(ObjectInternal generic, ObjectInternal index) {
    isType(generic) and
    generic.isNotSubscriptedType() and
    index.isNotSubscriptedType() and
    Expressions::subscriptPartsPointsTo(_, _, generic, index)
  }

/** Join-order helper for TPythonTuple */
pragma[nomagic]
private predicate scope_loads_tuplenode(Scope s, TupleNode origin) {
  origin.isLoad() and
  origin.getScope() = s
}

/** Holds if the object `t` is a type. */
predicate isType(ObjectInternal t) {
  t.isClass() = true
  or
  t.getOrigin().getEnclosingModule().getName().matches("%typing")
}

private predicate is_power_2(int n) {
  n = 1
  or
  exists(int half | is_power_2(half) and n = half * 2)
}

predicate static_method(
  CallNode instantiation, CallableObjectInternal function, PointsToContext context
) {
  PointsToInternal::pointsTo(instantiation.getFunction(), context,
    ObjectInternal::builtin("staticmethod"), _) and
  PointsToInternal::pointsTo(instantiation.getArg(0), context, function, _)
}

predicate class_method(
  CallNode instantiation, CallableObjectInternal function, PointsToContext context
) {
  PointsToInternal::pointsTo(instantiation.getFunction(), context, ObjectInternal::classMethod(), _) and
  PointsToInternal::pointsTo(instantiation.getArg(0), context, function, _)
}

/**
 * Holds if the literal corresponding to the control flow node `n` has class `cls`.
 *
 * Helper predicate for `literal_instantiation`. Prevents a bad join with
 * `PointsToContext::appliesTo` from occurring.
 */
pragma[nomagic]
private predicate literal_node_class(ControlFlowNode n, ClassObjectInternal cls) {
  n instanceof ListNode and cls = ObjectInternal::builtin("list")
  or
  n instanceof DictNode and cls = ObjectInternal::builtin("dict")
  or
  n instanceof SetNode and cls = ObjectInternal::builtin("set")
  or
  n.getNode() instanceof ImaginaryLiteral and cls = ObjectInternal::builtin("complex")
  or
  n.getNode() instanceof ListComp and cls = ObjectInternal::builtin("list")
  or
  n.getNode() instanceof SetComp and cls = ObjectInternal::builtin("set")
  or
  n.getNode() instanceof DictComp and cls = ObjectInternal::builtin("dict")
}

predicate literal_instantiation(ControlFlowNode n, ClassObjectInternal cls, PointsToContext context) {
  context.appliesTo(n) and
  literal_node_class(n, cls)
}

predicate super_instantiation(
  CallNode instantiation, ObjectInternal self, ClassObjectInternal startclass,
  PointsToContext context
) {
  super_2args(instantiation, self, startclass, context)
  or
  super_noargs(instantiation, self, startclass, context)
}

pragma[noinline]
private predicate super_2args(
  CallNode instantiation, ObjectInternal self, ClassObjectInternal startclass,
  PointsToContext context
) {
  exists(ControlFlowNode arg0, ControlFlowNode arg1 |
    super_call2(instantiation, arg0, arg1, context) and
    PointsToInternal::pointsTo(arg0, context, startclass, _) and
    PointsToInternal::pointsTo(arg1, context, self, _)
  )
}

pragma[noinline]
private predicate super_call2(
  CallNode call, ControlFlowNode arg0, ControlFlowNode arg1, PointsToContext context
) {
  exists(ControlFlowNode func |
    call2(call, func, arg0, arg1) and
    PointsToInternal::pointsTo(func, context, ObjectInternal::superType(), _)
  )
}

pragma[noinline]
private predicate super_noargs(
  CallNode instantiation, ObjectInternal self, ClassObjectInternal startclass,
  PointsToContext context
) {
  PointsToInternal::pointsTo(instantiation.getFunction(), context, ObjectInternal::builtin("super"),
    _) and
  not exists(instantiation.getArg(0)) and
  exists(Function func |
    instantiation.getScope() = func and
    /* Implicit class argument is lexically enclosing scope */
    func.getScope() = startclass.(PythonClassObjectInternal).getScope() and
    /* Implicit 'self' is the `self` parameter of the enclosing function */
    self.(SelfInstanceInternal).getParameter().getParameter() = func.getArg(0)
  )
}

predicate call2(CallNode call, ControlFlowNode func, ControlFlowNode arg0, ControlFlowNode arg1) {
  not exists(call.getArg(2)) and
  func = call.getFunction() and
  arg0 = call.getArg(0) and
  arg1 = call.getArg(1)
}

predicate call3(
  CallNode call, ControlFlowNode func, ControlFlowNode arg0, ControlFlowNode arg1,
  ControlFlowNode arg2
) {
  not exists(call.getArg(3)) and
  func = call.getFunction() and
  arg0 = call.getArg(0) and
  arg1 = call.getArg(1) and
  arg2 = call.getArg(2)
}

/** Helper self parameters: `def meth(self, ...): ...`. */
pragma[noinline]
private predicate self_parameter(
  ParameterDefinition def, PointsToContext context, PythonClassObjectInternal cls
) {
  def.isSelf() and
  /* Exclude the special parameter name `.0` which is used for unfolded comprehensions. */
  def.getName() != ".0" and
  exists(Function scope |
    def.getScope() = scope and
    context.isRuntime() and
    context.appliesToScope(scope) and
    scope.getScope() = cls.getScope() and
    concrete_class(cls) and
    /*
     * We want to allow decorated functions, otherwise we lose a lot of useful information.
     * However, we want to exclude any function whose arguments are permuted by the decorator.
     * In general we can't do that, but we can special case the most common ones.
     */

    neither_class_nor_static_method(scope)
  )
}

cached
private predicate concrete_class(PythonClassObjectInternal cls) {
  cls.getClass() != abcMetaClassObject()
  or
  exists(Class c |
    c = cls.getScope() and
    not exists(c.getMetaClass())
  |
    forall(Function f | f.getScope() = c |
      not exists(Raise r, Name ex |
        r.getScope() = f and
        (r.getException() = ex or r.getException().(Call).getFunc() = ex) and
        ex.getId() = ["NotImplementedError", "NotImplemented"]
      )
    )
  )
}

private PythonClassObjectInternal abcMetaClassObject() {
  /* Avoid using points-to and thus negative recursion */
  exists(Class abcmeta | result.getScope() = abcmeta |
    abcmeta.getName() = "ABCMeta" and
    abcmeta.getScope().getName() = "abc"
  )
}

private predicate neither_class_nor_static_method(Function f) {
  not exists(f.getADecorator())
  or
  exists(ControlFlowNode deco | deco = f.getADecorator().getAFlowNode() |
    exists(ObjectInternal o | PointsToInternal::pointsTo(deco, _, o, _) |
      o != ObjectInternal::staticMethod() and
      o != ObjectInternal::classMethod()
    )
    or
    not deco instanceof NameNode
  )
}

predicate missing_imported_module(ControlFlowNode imp, Context ctx, string name) {
  ctx.isImport() and
  imp.(ImportExprNode).getNode().getAnImportedModuleName() = name and
  (
    not exists(Module m | m.getName() = name) and
    not exists(Builtin b | b.isModule() and b.getName() = name)
    or
    exists(Module m, SyntaxError se |
      m.getName() = name and
      se.getFile() = m.getFile()
    )
  )
  or
  exists(AbsentModuleObjectInternal mod |
    PointsToInternal::pointsTo(imp.(ImportMemberNode).getModule(name), ctx, mod, _) and
    common_module_name(mod.getName() + "." + name)
  )
}

/**
 * Helper for missing modules to determine if name `x.y` is a module `x.y` or
 * an attribute `y` of module `x`. This list should be added to as required.
 */
predicate common_module_name(string name) { name = ["zope.interface", "six.moves"] }

/**
 * A declaration of a class, either a built-in class or a source definition
 * This acts as a helper for ClassObjectInternal allowing some lookup without
 * recursion.
 */
class ClassDecl extends @py_object {
  ClassDecl() {
    this.(Builtin).isClass() and not this = Builtin::unknownType()
    or
    this.(ControlFlowNode).getNode() instanceof ClassExpr
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "ClassDecl" }

  /** Gets the class scope for Python class declarations */
  Class getClass() { result = this.(ControlFlowNode).getNode().(ClassExpr).getInnerScope() }

  /** Holds if this class declares the attribute `name` */
  predicate declaresAttribute(string name) {
    exists(this.(Builtin).getMember(name))
    or
    exists(SsaVariable var |
      name = var.getId() and var.getAUse() = this.getClass().getANormalExit()
    )
  }

  /** Gets the name of this class */
  string getName() {
    result = this.(Builtin).getName()
    or
    result = this.getClass().getName()
  }

  /**
   * Whether this is a class whose instances must be treated specially, rather than as generic instances.
   */
  predicate isSpecial() {
    exists(string name | this = Builtin::special(name) |
      name =
        [
          "type", "super", "bool", "NoneType", "tuple", "property", "ClassMethod", "StaticMethod",
          "MethodType", "ModuleType"
        ]
    )
  }

  /** Holds if for class `C`, `C()` returns an instance of `C` */
  predicate callReturnsInstance() {
    exists(Class pycls | pycls = this.getClass() |
      /* Django does this, so we need to account for it */
      not exists(Function init, LocalVariable self |
        /* `self.__class__ = ...` in the `__init__` method */
        pycls.getInitMethod() = init and
        self.isSelf() and
        self.getScope() = init and
        exists(AttrNode a | a.isStore() and a.getObject("__class__") = self.getAUse())
      ) and
      not exists(Function new | new.getName() = "__new__" and new.getScope() = pycls)
    )
    or
    this instanceof Builtin
  }

  /** Holds if this class is the abstract base class */
  predicate isAbstractBaseClass(string name) {
    exists(Module m | m.getName() = ["_abcoll", "_collections_abc"] |
      this.getClass().getScope() = m and
      this.getName() = name
    )
  }
}
