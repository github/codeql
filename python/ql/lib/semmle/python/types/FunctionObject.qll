import python
import semmle.python.types.Exceptions
private import semmle.python.pointsto.PointsTo
private import semmle.python.objects.Callables
private import semmle.python.libraries.Zope
private import semmle.python.pointsto.Base
private import semmle.python.objects.ObjectInternal
private import semmle.python.types.Builtins

/** A function object, whether written in Python or builtin */
abstract class FunctionObject extends Object {
  CallableValue theCallable() { result.(ObjectInternal).getSource() = this }

  predicate isOverridingMethod() { exists(Object f | this.overrides(f)) }

  predicate isOverriddenMethod() { exists(Object f | f.overrides(this)) }

  Function getFunction() { result = this.getOrigin().(CallableExpr).getInnerScope() }

  /** This function always returns None, meaning that its return value should be disregarded */
  abstract predicate isProcedure();

  /** Gets the name of this function */
  abstract string getName();

  /** Gets a class that may be raised by this function */
  abstract ClassObject getARaisedType();

  /** Whether this function raises an exception, the class of which cannot be inferred */
  abstract predicate raisesUnknownType();

  /** Gets a longer, more descriptive version of toString() */
  abstract string descriptiveString();

  /** Gets a call-site from where this function is called as a function */
  CallNode getAFunctionCall() { result.getFunction().inferredValue() = this.theCallable() }

  /** Gets a call-site from where this function is called as a method */
  CallNode getAMethodCall() {
    exists(BoundMethodObjectInternal bm |
      result.getFunction().inferredValue() = bm and
      bm.getFunction() = this.theCallable()
    )
  }

  /** Gets a call-site from where this function is called */
  ControlFlowNode getACall() { result = this.theCallable().getACall() }

  /** Gets a call-site from where this function is called, given the `context` */
  ControlFlowNode getACall(Context caller_context) {
    result = this.theCallable().getACall(caller_context)
  }

  /**
   * Gets the `ControlFlowNode` that will be passed as the nth argument to `this` when called at `call`.
   * This predicate will correctly handle `x.y()`, treating `x` as the zeroth argument.
   */
  ControlFlowNode getArgumentForCall(CallNode call, int n) {
    result = this.theCallable().getArgumentForCall(call, n)
  }

  /**
   * Gets the `ControlFlowNode` that will be passed as the named argument to `this` when called at `call`.
   * This predicate will correctly handle `x.y()`, treating `x` as the self argument.
   */
  ControlFlowNode getNamedArgumentForCall(CallNode call, string name) {
    result = this.theCallable().getNamedArgumentForCall(call, name)
  }

  /** Whether this function never returns. This is an approximation. */
  predicate neverReturns() { this.theCallable().neverReturns() }

  /**
   * Whether this is a "normal" method, that is, it is exists as a class attribute
   * which is not wrapped and not the __new__ method.
   */
  predicate isNormalMethod() {
    exists(ClassObject cls, string name |
      cls.declaredAttribute(name) = this and
      name != "__new__" and
      not this.getOrigin() instanceof Lambda
    )
  }

  /** Gets the minimum number of parameters that can be correctly passed to this function */
  abstract int minParameters();

  /** Gets the maximum number of parameters that can be correctly passed to this function */
  abstract int maxParameters();

  /** Gets a function that this function (directly) calls */
  FunctionObject getACallee() {
    exists(ControlFlowNode node |
      node.getScope() = this.getFunction() and
      result.getACall() = node
    )
  }

  /**
   * Gets the qualified name for this function object.
   * Should return the same name as the `__qualname__` attribute on functions in Python 3.
   */
  abstract string getQualifiedName();

  /** Whether `name` is a legal argument name for this function */
  bindingset[name]
  predicate isLegalArgumentName(string name) {
    this.getFunction().getAnArg().asName().getId() = name
    or
    this.getFunction().getAKeywordOnlyArg().getId() = name
    or
    this.getFunction().hasKwArg()
  }

  /** Gets a class that this function may return */
  ClassObject getAnInferredReturnType() { result = this.(BuiltinCallable).getAReturnType() }

  predicate isAbstract() { this.getARaisedType() = theNotImplementedErrorType() }
}

class PyFunctionObject extends FunctionObject {
  PyFunctionObject() { any(PythonFunctionObjectInternal f).getOrigin() = this }

  override string toString() { result = "Function " + this.getName() }

  override string getName() {
    result = this.getOrigin().(FunctionExpr).getName()
    or
    this.getOrigin() instanceof Lambda and result = "lambda"
  }

  /** Whether this function is a procedure, that is, it has no explicit return statement and is not a generator function */
  override predicate isProcedure() { this.getFunction().isProcedure() }

  override ClassObject getARaisedType() { scope_raises_objectapi(result, this.getFunction()) }

  override predicate raisesUnknownType() { scope_raises_unknown(this.getFunction()) }

  /** Gets a control flow node corresponding to the value of a return statement */
  ControlFlowNode getAReturnedNode() { result = this.getFunction().getAReturnValueFlowNode() }

  override string descriptiveString() {
    if this.getFunction().isMethod()
    then
      exists(Class cls | this.getFunction().getScope() = cls |
        result = "method " + this.getQualifiedName()
      )
    else result = "function " + this.getQualifiedName()
  }

  override int minParameters() {
    exists(Function f |
      f = this.getFunction() and
      result = count(f.getAnArg()) - count(f.getDefinition().getArgs().getADefault())
    )
  }

  override int maxParameters() {
    exists(Function f |
      f = this.getFunction() and
      if exists(f.getVararg())
      then result = 2147483647 // INT_MAX
      else result = count(f.getAnArg())
    )
  }

  override string getQualifiedName() { result = this.getFunction().getQualifiedName() }

  predicate unconditionallyReturnsParameter(int n) {
    exists(SsaVariable pvar |
      exists(Parameter p | p = this.getFunction().getArg(n) |
        p.asName().getAFlowNode() = pvar.getDefinition()
      ) and
      exists(NameNode rval |
        rval = pvar.getAUse() and
        exists(Return r | r.getValue() = rval.getNode()) and
        rval.strictlyDominates(rval.getScope().getANormalExit())
      )
    )
  }

  /** Factored out to help join ordering */
  pragma[noinline]
  private predicate implicitlyReturns(Object none_, ClassObject noneType) {
    noneType = theNoneType() and
    not this.getFunction().isGenerator() and
    none_ = theNoneObject() and
    (
      not exists(this.getAReturnedNode()) and exists(this.getFunction().getANormalExit())
      or
      exists(Return ret | ret.getScope() = this.getFunction() and not exists(ret.getValue()))
    )
  }

  /** Gets a class that this function may return */
  override ClassObject getAnInferredReturnType() {
    this.getFunction().isGenerator() and result = theGeneratorType()
    or
    not this.neverReturns() and
    not this.getFunction().isGenerator() and
    (
      this.(PyFunctionObject).getAReturnedNode().refersTo(_, result, _)
      or
      this.implicitlyReturns(_, result)
    )
  }

  ParameterDefinition getParameter(int n) {
    result.getDefiningNode().getNode() = this.getFunction().getArg(n)
  }
}

abstract class BuiltinCallable extends FunctionObject {
  abstract ClassObject getAReturnType();

  override predicate isProcedure() {
    forex(ClassObject rt | rt = this.getAReturnType() | rt = theNoneType())
  }

  abstract override string getQualifiedName();

  override ControlFlowNode getArgumentForCall(CallNode call, int n) {
    call = this.getACall() and result = call.getArg(n)
  }
}

class BuiltinMethodObject extends BuiltinCallable {
  BuiltinMethodObject() { any(BuiltinMethodObjectInternal m).getBuiltin() = this }

  override string getQualifiedName() {
    exists(ClassObject cls | cls.asBuiltin().getMember(_) = this.asBuiltin() |
      result = cls.getName() + "." + this.getName()
    )
    or
    not exists(ClassObject cls | cls.asBuiltin().getMember(_) = this.asBuiltin()) and
    result = this.getName()
  }

  override string descriptiveString() { result = "builtin-method " + this.getQualifiedName() }

  override string getName() { result = this.asBuiltin().getName() }

  override string toString() { result = "Builtin-method " + this.getName() }

  override ClassObject getARaisedType() {
    /* Information is unavailable for C code in general */
    none()
  }

  override predicate raisesUnknownType() {
    /* Information is unavailable for C code in general */
    any()
  }

  override int minParameters() { none() }

  override int maxParameters() { none() }

  override ClassObject getAReturnType() { ext_rettype(this.asBuiltin(), result.asBuiltin()) }
}

class BuiltinFunctionObject extends BuiltinCallable {
  BuiltinFunctionObject() { any(BuiltinFunctionObjectInternal f).getBuiltin() = this }

  override string getName() { result = this.asBuiltin().getName() }

  override string getQualifiedName() { result = this.getName() }

  override string toString() { result = "Builtin-function " + this.getName() }

  override string descriptiveString() { result = "builtin-function " + this.getName() }

  override ClassObject getARaisedType() {
    /* Information is unavailable for C code in general */
    none()
  }

  override predicate raisesUnknownType() {
    /* Information is unavailable for C code in general */
    any()
  }

  override ClassObject getAReturnType() {
    /*
     * Enumerate the types of a few builtin functions, that the CPython analysis misses.
     */

    this = Object::builtin("hex") and result = theStrType()
    or
    this = Object::builtin("oct") and result = theStrType()
    or
    this = Object::builtin("intern") and result = theStrType()
    or
    /* Fix a few minor inaccuracies in the CPython analysis */
    ext_rettype(this.asBuiltin(), result.asBuiltin()) and
    not (
      this = Object::builtin("__import__") and result = theNoneType()
      or
      this = Object::builtin("compile") and result = theNoneType()
      or
      this = Object::builtin("sum")
      or
      this = Object::builtin("filter")
    )
  }

  override int minParameters() { none() }

  override int maxParameters() { none() }
}
