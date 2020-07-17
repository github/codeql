/**
 * Public API for "objects"
 * A `Value` is a static approximation to a set of runtime objects.
 */

import python
private import TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins

/*
 * Use the term `ObjectSource` to refer to DB entity. Either a CFG node
 * for Python objects, or `@py_cobject` entity for built-in objects.
 */

class ObjectSource = Object;

/* Aliases for scopes */
class FunctionScope = Function;

class ClassScope = Class;

class ModuleScope = Module;

/**
 * Class representing values in the Python program
 * Each `Value` is a static approximation to a set of one or more real objects.
 */
class Value extends TObject {
  Value() {
    this != ObjectInternal::unknown() and
    this != ObjectInternal::unknownClass() and
    this != ObjectInternal::undefined()
  }

  /** Gets a textual representation of this element. */
  string toString() { result = this.(ObjectInternal).toString() }

  /** Gets a `ControlFlowNode` that refers to this object. */
  ControlFlowNode getAReference() { PointsToInternal::pointsTo(result, _, this, _) }

  /** Gets the origin CFG node for this value. */
  ControlFlowNode getOrigin() { result = this.(ObjectInternal).getOrigin() }

  /**
   * Gets the class of this object.
   * Strictly, the `Value` representing the class of the objects
   * represented by this Value.
   */
  ClassValue getClass() { result = this.(ObjectInternal).getClass() }

  /** Gets a call to this object */
  CallNode getACall() { result = this.getACall(_) }

  /** Gets a call to this object with the given `caller` context. */
  CallNode getACall(PointsToContext caller) {
    PointsToInternal::pointsTo(result.getFunction(), caller, this, _)
    or
    exists(BoundMethodObjectInternal bm |
      PointsToInternal::pointsTo(result.getFunction(), caller, bm, _) and
      bm.getFunction() = this
    )
  }

  /** Gets a `Value` that represents the attribute `name` of this object. */
  Value attr(string name) { this.(ObjectInternal).attribute(name, result, _) }

  /**
   * Holds if this value is builtin. Applies to built-in functions and methods,
   * but also integers and strings.
   */
  predicate isBuiltin() { this.(ObjectInternal).isBuiltin() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this
        .(ObjectInternal)
        .getOrigin()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    not exists(this.(ObjectInternal).getOrigin()) and
    filepath = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /**
   * Gets the name of this value, if it has one.
   * Note this is the innate name of the
   * object, not necessarily all the names by which it can be called.
   */
  final string getName() { result = this.(ObjectInternal).getName() }

  /** Holds if this value has the attribute `name` */
  predicate hasAttribute(string name) { this.(ObjectInternal).hasAttribute(name) }

  /** Whether this value is absent from the database, but has been inferred to likely exist */
  predicate isAbsent() {
    this instanceof AbsentModuleObjectInternal
    or
    this instanceof AbsentModuleAttributeObjectInternal
  }

  /**
   * Whether this overrides v. In this context, "overrides" means that this object
   * is a named attribute of a some class C and `v` is a named attribute of another
   * class S, both attributes having the same name, and S is a super class of C.
   */
  predicate overrides(Value v) {
    exists(ClassValue my_class, ClassValue other_class, string name |
      my_class.declaredAttribute(name) = this and
      other_class.declaredAttribute(name) = v and
      my_class.getABaseType+() = other_class
    )
  }

  /**
   * Gets the boolean interpretation of this value.
   * Could be both `true` and `false`, if we can't determine the result more precisely.
   */
  boolean getABooleanValue() { result = this.(ObjectInternal).booleanValue() }

  /**
   * Gets the boolean interpretation of this value, only if we can determine the result precisely.
   * The result can be `none()`, but never both `true` and `false`.
   */
  boolean getDefiniteBooleanValue() {
    result = getABooleanValue() and
    not (getABooleanValue() = true and getABooleanValue() = false)
  }
}

/**
 * Class representing modules in the Python program
 * Each `ModuleValue` represents a module object in the Python program.
 */
class ModuleValue extends Value {
  ModuleValue() { this instanceof ModuleObjectInternal }

  /**
   * Holds if this module "exports" name.
   * That is, does it define `name` in `__all__` or is
   * `__all__` not defined and `name` a global variable that does not start with "_"
   * This is the set of names imported by `from ... import *`.
   */
  predicate exports(string name) { PointsTo::moduleExports(this, name) }

  /** Gets the scope for this module, provided that it is a Python module. */
  ModuleScope getScope() { result = this.(ModuleObjectInternal).getSourceModule() }

  /**
   * Gets the container path for this module. Will be the file for a Python module,
   * the folder for a package and no result for a builtin module.
   */
  Container getPath() {
    result = this.(PackageObjectInternal).getFolder()
    or
    result = this.(PythonModuleObjectInternal).getSourceModule().getFile()
  }

  /**
   * Whether this module is imported by 'import name'. For example on a linux system,
   * the module 'posixpath' is imported as 'os.path' or as 'posixpath'
   */
  predicate importedAs(string name) { PointsToInternal::module_imported_as(this, name) }

  /** Whether this module is a package. */
  predicate isPackage() { this instanceof PackageObjectInternal }

  /** Whether the complete set of names "exported" by this module can be accurately determined */
  predicate hasCompleteExportInfo() { this.(ModuleObjectInternal).hasCompleteExportInfo() }

  /** Get a module that this module imports */
  ModuleValue getAnImportedModule() { result.importedAs(this.getScope().getAnImportedModuleName()) }

  /** When used as a normal module (for example, imported and used by other modules) */
  predicate isUsedAsModule() {
    this.isBuiltin()
    or
    this.isPackage()
    or
    exists(ImportingStmt i | this.importedAs(i.getAnImportedModuleName()))
    or
    this.getPath().getBaseName() = "__init__.py"
  }

  /** When used (exclusively) as a script (will not include normal modules that can also be run as a script) */
  predicate isUsedAsScript() {
    not isUsedAsModule() and
    (
      not this.getPath().getExtension() = "py"
      or
      exists(If i, Name name, StrConst main, Cmpop op |
        i.getScope() = this.getScope() and
        op instanceof Eq and
        i.getTest().(Compare).compares(name, op, main) and
        name.getId() = "__name__" and
        main.getText() = "__main__"
      )
      or
      exists(Comment c |
        c.getLocation().getFile() = this.getPath() and
        c.getLocation().getStartLine() = 1 and
        c.getText().regexpMatch("^#!/.*python(2|3)?[ \\\\t]*$")
      )
    )
  }
}

module Module {
  /**
   * Gets the `ModuleValue` named `name`.
   *
   * Note that the name used to refer to a module is not
   * necessarily its name. For example,
   * there are modules referred to by the name `os.path`,
   * but that are not named `os.path`, for example the module `posixpath`.
   * Such that the following is true:
   * `Module::named("os.path").getName() = "posixpath"
   */
  ModuleValue named(string name) {
    result.getName() = name
    or
    result = named(name, _)
  }

  /* Prevent runaway recursion when a module has itself as an attribute. */
  private ModuleValue named(string name, int dots) {
    dots = 0 and
    not name.charAt(_) = "." and
    result.getName() = name
    or
    dots <= 3 and
    exists(string modname, string attrname | name = modname + "." + attrname |
      result = named(modname, dots - 1).attr(attrname)
    )
  }

  /** Get the `ModuleValue` for the `builtin` module. */
  ModuleValue builtinModule() { result = TBuiltinModuleObject(Builtin::builtinModule()) }
}

module Value {
  /**
   * Gets the `Value` named `name`.
   * If there is at least one '.' in `name`, then the part of
   * the name to the left of the rightmost '.' is interpreted as a module name
   * and the part after the rightmost '.' as an attribute of that module.
   * For example, `Value::named("os.path.join")` is the `Value` representing the
   * `join` function of the `os.path` module.
   * If there is no '.' in `name`, then the `Value` returned is the builtin
   * object of that name.
   * For example `Value::named("len")` is the `Value` representing the `len` built-in function.
   */
  Value named(string name) {
    exists(string modname, string attrname | name = modname + "." + attrname |
      result = Module::named(modname).attr(attrname)
    )
    or
    result = ObjectInternal::builtin(name)
    or
    name = "None" and result = ObjectInternal::none_()
    or
    name = "True" and result = TTrue()
    or
    name = "False" and result = TFalse()
  }

  /**
   * Gets the `NumericValue` for the integer constant `i`, if it exists.
   * There will be no `NumericValue` for most integers, but the following are
   * guaranteed to exist:
   * * From zero to 511 inclusive.
   * * All powers of 2 (up to 2**30)
   * * Any integer explicitly mentioned in the source program.
   */
  NumericValue forInt(int i) { result.(IntObjectInternal).intValue() = i }

  /**
   * Gets the `Value` for the bytes constant `bytes`, if it exists.
   * There will be no `Value` for most byte strings, unless it is explicitly
   * declared in the source program.
   */
  StringValue forBytes(string bytes) { result.(BytesObjectInternal).strValue() = bytes }

  /**
   * Gets the `Value` for the unicode constant `text`, if it exists.
   * There will be no `Value` for most text strings, unless it is explicitly
   * declared in the source program.
   */
  StringValue forUnicode(string text) { result.(UnicodeObjectInternal).strValue() = text }

  /**
   * Gets a `Value` for the string `text`. May be a bytes or unicode string for Python 2.
   * There will be no `Value` for most strings, unless it is explicitly
   * declared in the source program.
   */
  StringValue forString(string text) {
    result.(UnicodeObjectInternal).strValue() = text
    or
    major_version() = 2 and
    result.(BytesObjectInternal).strValue() = text
  }

  /** Gets the `Value` for the bool constant `b`. */
  Value forBool(boolean b) {
    b = true and result = TTrue()
    or
    b = false and result = TFalse()
  }

  /** Gets the `Value` for `None`. */
  Value none_() { result = ObjectInternal::none_() }

  /**
   * Shorcuts added by the `site` module to exit your interactive session.
   *
   * see https://docs.python.org/3/library/constants.html#constants-added-by-the-site-module
   */
  Value siteQuitter(string name) {
    (
      name = "exit"
      or
      name = "quit"
    ) and
    result = Value::named(name)
  }
}

/**
 * Class representing callables in the Python program
 * Callables include Python functions, built-in functions and bound-methods,
 * but not classes.
 */
class CallableValue extends Value {
  CallableValue() { this instanceof CallableObjectInternal }

  /**
   * Holds if this callable never returns once called.
   * For example, `sys.exit`
   */
  predicate neverReturns() { this.(CallableObjectInternal).neverReturns() }

  /** Gets the scope for this function, provided that it is a Python function. */
  FunctionScope getScope() { result = this.(PythonFunctionObjectInternal).getScope() }

  /** Gets the `n`th parameter node of this callable. */
  NameNode getParameter(int n) { result = this.(CallableObjectInternal).getParameter(n) }

  /** Gets the `name`d parameter node of this callable. */
  NameNode getParameterByName(string name) {
    result = this.(CallableObjectInternal).getParameterByName(name)
  }

  /**
   * Gets the argument in `call` corresponding to the `n`'th positional parameter of this callable.
   *
   * Use this method instead of `call.getArg(n)` to handle the fact that this function might be used as
   * a bound-method, such that argument `n` of the call corresponds to the `n+1` parameter of the callable.
   *
   * This method also gives results when the argument is passed as a keyword argument in `call`, as long
   * as `this` is not a builtin function or a builtin method.
   *
   * Examples:
   *
   * - if `this` represents the `PythonFunctionValue` for `def func(a, b):`, and `call` represents
   *   `func(10, 20)`, then `getArgumentForCall(call, 0)` will give the `ControlFlowNode` for `10`.
   *
   * - with `call` representing `func(b=20, a=10)`, `getArgumentForCall(call, 0)` will give
   *   the `ControlFlowNode` for `10`.
   *
   * - if `this` represents the `PythonFunctionValue` for `def func(self, a, b):`, and `call`
   *   represents `foo.func(10, 20)`, then `getArgumentForCall(call, 1)` will give the
   *   `ControlFlowNode` for `10`.
   *   Note: There will also exist a `BoundMethodValue bm` where `bm.getArgumentForCall(call, 0)`
   *   will give the `ControlFlowNode` for `10` (notice the shift in index used).
   */
  cached
  ControlFlowNode getArgumentForCall(CallNode call, int n) {
    exists(ObjectInternal called, int offset |
      PointsToInternal::pointsTo(call.getFunction(), _, called, _) and
      called.functionAndOffset(this, offset)
    |
      call.getArg(n - offset) = result
      or
      exists(string name |
        call.getArgByName(name) = result and
        this.getParameter(n).getId() = name
      )
      or
      called instanceof BoundMethodObjectInternal and
      offset = 1 and
      n = 0 and
      result = call.getFunction().(AttrNode).getObject()
    )
  }

  /**
   * Gets the argument in `call` corresponding to the `name`d keyword parameter of this callable.
   *
   * This method also gives results when the argument is passed as a positional argument in `call`, as long
   * as `this` is not a builtin function or a builtin method.
   *
   * Examples:
   *
   * - if `this` represents the `PythonFunctionValue` for `def func(a, b):`, and `call` represents
   *   `func(10, 20)`, then `getNamedArgumentForCall(call, "a")` will give the `ControlFlowNode` for `10`.
   *
   * - with `call` representing `func(b=20, a=10)`, `getNamedArgumentForCall(call, "a")` will give
   *   the `ControlFlowNode` for `10`.
   *
   * - if `this` represents the `PythonFunctionValue` for `def func(self, a, b):`, and `call`
   *   represents `foo.func(10, 20)`, then `getNamedArgumentForCall(call, "a")` will give the
   *   `ControlFlowNode` for `10`.
   */
  cached
  ControlFlowNode getNamedArgumentForCall(CallNode call, string name) {
    exists(CallableObjectInternal called, int offset |
      PointsToInternal::pointsTo(call.getFunction(), _, called, _) and
      called.functionAndOffset(this, offset)
    |
      call.getArgByName(name) = result
      or
      exists(int n |
        call.getArg(n) = result and
        this.getParameter(n + offset).getId() = name
        // TODO: and not positional only argument (Python 3.8+)
      )
      or
      called instanceof BoundMethodObjectInternal and
      offset = 1 and
      name = "self" and
      result = call.getFunction().(AttrNode).getObject()
    )
  }
}

/**
 * Class representing bound-methods, such as `o.func`, where `o` is an instance
 * of a class that has a callable attribute `func`.
 */
class BoundMethodValue extends CallableValue {
  BoundMethodValue() { this instanceof BoundMethodObjectInternal }

  /**
   * Gets the callable that will be used when `this` is called.
   * The actual callable for `func` in `o.func`.
   */
  CallableValue getFunction() { result = this.(BoundMethodObjectInternal).getFunction() }

  /**
   * Gets the value that will be used for the `self` parameter when `this` is called.
   * The value for `o` in `o.func`.
   */
  Value getSelf() { result = this.(BoundMethodObjectInternal).getSelf() }

  /** Gets the parameter node that will be used for `self`. */
  NameNode getSelfParameter() { result = this.(BoundMethodObjectInternal).getSelfParameter() }
}

/**
 * Class representing classes in the Python program, both Python and built-in.
 */
class ClassValue extends Value {
  ClassValue() { this.(ObjectInternal).isClass() = true }

  /** Gets an improper super type of this class. */
  ClassValue getASuperType() { result = this.getABaseType*() }

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
   * `this.attr("f")` is equivalent to `C.f`, which is a bound-method.
   */
  Value lookup(string name) { this.(ClassObjectInternal).lookup(name, result, _) }

  predicate isCallable() { this.(ClassObjectInternal).lookup("__call__", _, _) }

  /** Holds if this class is an iterable. */
  predicate isIterable() {
    this.hasAttribute("__iter__")
    or
    this.hasAttribute("__aiter__")
    or
    this.hasAttribute("__getitem__")
  }

  /** Holds if this class is an iterator. */
  predicate isIterator() {
    this.hasAttribute("__iter__") and
    (
      major_version() = 3 and this.hasAttribute("__next__")
      or
      /*
       * Because 'next' is a common method name we need to check that an __iter__
       * method actually returns this class. This is not needed for Py3 as the
       * '__next__' method exists to define a class as an iterator.
       */

      major_version() = 2 and
      this.hasAttribute("next") and
      exists(ClassValue other, FunctionValue iter | other.declaredAttribute("__iter__") = iter |
        iter.getAnInferredReturnType() = this
      )
    )
    or
    /* This will be redundant when we have C class information */
    this = ClassValue::generator()
  }

  /** Holds if this class is a container(). That is, does it have a __getitem__ method. */
  predicate isContainer() { exists(this.lookup("__getitem__")) }

  /**
   * Holds if this class is a sequence. Mutually exclusive with `isMapping()`.
   *
   * Following the definition from
   * https://docs.python.org/3/glossary.html#term-sequence.
   * We don't look at the keys accepted by `__getitem__, but default to treating a class
   * as a sequence (so might treat some mappings as sequences).
   */
  predicate isSequence() {
    /*
     * To determine whether something is a sequence or a mapping is not entirely clear,
     * so we need to guess a bit.
     */

    this.getASuperType() = ClassValue::tuple()
    or
    this.getASuperType() = ClassValue::list()
    or
    this.getASuperType() = ClassValue::range()
    or
    this.getASuperType() = ClassValue::bytes()
    or
    this.getASuperType() = ClassValue::unicode()
    or
    major_version() = 2 and this.getASuperType() = Value::named("collections.Sequence")
    or
    major_version() = 3 and this.getASuperType() = Value::named("collections.abc.Sequence")
    or
    this.hasAttribute("__getitem__") and
    this.hasAttribute("__len__") and
    not this.getASuperType() = ClassValue::dict() and
    not this.getASuperType() = Value::named("collections.Mapping") and
    not this.getASuperType() = Value::named("collections.abc.Mapping")
  }

  /**
   * Holds if this class is a mapping. Mutually exclusive with `isSequence()`.
   *
   * Although a class will satisfy the requirement by the definition in
   * https://docs.python.org/3.8/glossary.html#term-mapping, we don't look at the keys
   * accepted by `__getitem__, but default to treating a class as a sequence (so might
   * treat some mappings as sequences).
   */
  predicate isMapping() {
    major_version() = 2 and this.getASuperType() = Value::named("collections.Mapping")
    or
    major_version() = 3 and this.getASuperType() = Value::named("collections.abc.Mapping")
    or
    this.hasAttribute("__getitem__") and
    not this.isSequence()
  }

  /** Holds if this class is a descriptor. */
  predicate isDescriptorType() { this.hasAttribute("__get__") }

  /** Holds if this class is a context manager. */
  predicate isContextManager() {
    this.hasAttribute("__enter__") and
    this.hasAttribute("__exit__")
  }

  /**
   * Gets the qualified name for this class.
   * Should return the same name as the `__qualname__` attribute on classes in Python 3.
   */
  string getQualifiedName() {
    result = this.(ClassObjectInternal).getBuiltin().getName()
    or
    result = this.(PythonClassObjectInternal).getScope().getQualifiedName()
  }

  /** Gets the MRO for this class */
  MRO getMro() { result = Types::getMro(this) }

  predicate failedInference(string reason) { Types::failedInference(this, reason) }

  /** Gets the nth immediate base type of this class. */
  ClassValue getBaseType(int n) { result = Types::getBase(this, n) }

  /** Gets an immediate base type of this class. */
  ClassValue getABaseType() { result = Types::getBase(this, _) }

  /**
   * Holds if this class is a new style class.
   * A new style class is one that implicitly or explicitly inherits from `object`.
   */
  predicate isNewStyle() { Types::isNewStyle(this) }

  /**
   * Holds if this class is an old style class.
   * An old style class is one that does not inherit from `object`.
   */
  predicate isOldStyle() { Types::isOldStyle(this) }

  /** Gets the scope associated with this class, if it is not a builtin class */
  ClassScope getScope() { result = this.(PythonClassObjectInternal).getScope() }

  /** Gets the attribute declared in this class */
  Value declaredAttribute(string name) { Types::declaredAttribute(this, name, result, _) }

  /**
   * Holds if this class has the attribute `name`, including attributes
   * declared by super classes.
   */
  override predicate hasAttribute(string name) { this.getMro().declares(name) }

  /**
   * Holds if this class declares the attribute `name`,
   * *not* including attributes declared by super classes.
   */
  predicate declaresAttribute(string name) {
    this.(ClassObjectInternal).getClassDeclaration().declaresAttribute(name)
  }

  /**
   * Whether this class is a legal exception class.
   * What constitutes a legal exception class differs between major versions
   */
  predicate isLegalExceptionType() {
    not this.isNewStyle()
    or
    this.getASuperType() = ClassValue::baseException()
    or
    major_version() = 2 and this = ClassValue::tuple()
  }
}

/**
 * Class representing functions in the Python program, both Python and built-in.
 * Note that this does not include other callables such as bound-methods.
 */
abstract class FunctionValue extends CallableValue {
  /**
   * Gets the qualified name for this function.
   * Should return the same name as the `__qualname__` attribute on functions in Python 3.
   */
  abstract string getQualifiedName();

  /** Gets a longer, more descriptive version of toString() */
  abstract string descriptiveString();

  /** Gets the minimum number of parameters that can be correctly passed to this function */
  abstract int minParameters();

  /** Gets the maximum number of parameters that can be correctly passed to this function */
  abstract int maxParameters();

  predicate isOverridingMethod() { exists(Value f | this.overrides(f)) }

  predicate isOverriddenMethod() { exists(Value f | f.overrides(this)) }

  /** Whether `name` is a legal argument name for this function */
  bindingset[name]
  predicate isLegalArgumentName(string name) {
    this.getScope().getAnArg().asName().getId() = name
    or
    this.getScope().getAKeywordOnlyArg().getId() = name
    or
    this.getScope().hasKwArg()
  }

  /**
   * Whether this is a "normal" method, that is, it is exists as a class attribute
   * which is not a lambda and not the __new__ method.
   */
  predicate isNormalMethod() {
    exists(ClassValue cls, string name |
      cls.declaredAttribute(name) = this and
      name != "__new__" and
      exists(Expr expr, AstNode origin | expr.pointsTo(this, origin) | not origin instanceof Lambda)
    )
  }

  /** Gets a class that may be raised by this function */
  abstract ClassValue getARaisedType();

  /** Gets a call-site from where this function is called as a function */
  CallNode getAFunctionCall() { result.getFunction().pointsTo() = this }

  /** Gets a call-site from where this function is called as a method */
  CallNode getAMethodCall() {
    exists(BoundMethodObjectInternal bm |
      result.getFunction().pointsTo() = bm and
      bm.getFunction() = this
    )
  }

  /** Gets a class that this function may return */
  abstract ClassValue getAnInferredReturnType();
}

/** Class representing Python functions */
class PythonFunctionValue extends FunctionValue {
  PythonFunctionValue() { this instanceof PythonFunctionObjectInternal }

  override string getQualifiedName() {
    result = this.(PythonFunctionObjectInternal).getScope().getQualifiedName()
  }

  override string descriptiveString() {
    if this.getScope().isMethod()
    then
      exists(Class cls | this.getScope().getScope() = cls |
        result = "method " + this.getQualifiedName()
      )
    else result = "function " + this.getQualifiedName()
  }

  override int minParameters() {
    exists(Function f |
      f = this.getScope() and
      result = count(f.getAnArg()) - count(f.getDefinition().getArgs().getADefault())
    )
  }

  override int maxParameters() {
    exists(Function f |
      f = this.getScope() and
      if exists(f.getVararg())
      then result = 2147483647 // INT_MAX
      else result = count(f.getAnArg())
    )
  }

  /** Gets a control flow node corresponding to a return statement in this function */
  ControlFlowNode getAReturnedNode() { result = this.getScope().getAReturnValueFlowNode() }

  override ClassValue getARaisedType() { scope_raises(result, this.getScope()) }

  override ClassValue getAnInferredReturnType() {
    /*
     * We have to do a special version of this because builtin functions have no
     * explicit return nodes that we can query and get the class of.
     */

    result = this.getAReturnedNode().pointsTo().getClass()
  }
}

/** Class representing builtin functions, such as `len` or `print` */
class BuiltinFunctionValue extends FunctionValue {
  BuiltinFunctionValue() { this instanceof BuiltinFunctionObjectInternal }

  override string getQualifiedName() { result = this.(BuiltinFunctionObjectInternal).getName() }

  override string descriptiveString() { result = "builtin-function " + this.getName() }

  override int minParameters() { none() }

  override int maxParameters() { none() }

  override ClassValue getARaisedType() {
    /* Information is unavailable for C code in general */
    none()
  }

  override ClassValue getAnInferredReturnType() {
    /*
     * We have to do a special version of this because builtin functions have no
     * explicit return nodes that we can query and get the class of.
     */

    result = TBuiltinClassObject(this.(BuiltinFunctionObjectInternal).getReturnType())
  }
}

/** Class representing builtin methods, such as `list.append` or `set.add` */
class BuiltinMethodValue extends FunctionValue {
  BuiltinMethodValue() { this instanceof BuiltinMethodObjectInternal }

  override string getQualifiedName() {
    exists(Builtin cls |
      cls.isClass() and
      cls.getMember(_) = this.(BuiltinMethodObjectInternal).getBuiltin() and
      result = cls.getName() + "." + this.getName()
    )
  }

  override string descriptiveString() { result = "builtin-method " + this.getQualifiedName() }

  override int minParameters() { none() }

  override int maxParameters() { none() }

  override ClassValue getARaisedType() {
    /* Information is unavailable for C code in general */
    none()
  }

  override ClassValue getAnInferredReturnType() {
    result = TBuiltinClassObject(this.(BuiltinMethodObjectInternal).getReturnType())
  }
}

/**
 * A class representing sequence objects with a length and tracked items.
 */
class SequenceValue extends Value {
  SequenceValue() { this instanceof SequenceObjectInternal }

  Value getItem(int n) { result = this.(SequenceObjectInternal).getItem(n) }

  int length() { result = this.(SequenceObjectInternal).length() }
}

/** A class representing tuple objects */
class TupleValue extends SequenceValue {
  TupleValue() { this instanceof TupleObjectInternal }
}

/**
 * A class representing strings, either present in the source as a literal, or
 * in a builtin as a value.
 */
class StringValue extends Value {
  StringValue() {
    this instanceof BytesObjectInternal or
    this instanceof UnicodeObjectInternal
  }

  string getText() {
    result = this.(BytesObjectInternal).strValue()
    or
    result = this.(UnicodeObjectInternal).strValue()
  }
}

/**
 * A class representing numbers (ints and floats), either present in the source as a literal,
 * or in a builtin as a value.
 */
class NumericValue extends Value {
  NumericValue() {
    this instanceof IntObjectInternal or
    this instanceof FloatObjectInternal
  }

  /** Gets the integer-value if it is a constant integer, and it fits in a QL int */
  int getIntValue() { result = this.(IntObjectInternal).intValue() }

  /** Gets the float-value if it is a constant float */
  int getFloatValue() { result = this.(FloatObjectInternal).floatValue() }
}

/**
 * A Python property:
 *
 * @property def f():
 *         ....
 *
 * https://docs.python.org/3/howto/descriptor.html#properties
 * https://docs.python.org/3/library/functions.html#property
 */
class PropertyValue extends Value {
  PropertyValue() { this instanceof PropertyInternal }

  CallableValue getGetter() { result = this.(PropertyInternal).getGetter() }

  CallableValue getSetter() { result = this.(PropertyInternal).getSetter() }

  CallableValue getDeleter() { result = this.(PropertyInternal).getDeleter() }
}

/** A method-resolution-order sequence of classes */
class MRO extends TClassList {
  /** Gets a textual representation of this element. */
  string toString() { result = this.(ClassList).toString() }

  /** Gets the `n`th class in this MRO */
  ClassValue getItem(int n) { result = this.(ClassList).getItem(n) }

  /** Holds if any class in this MRO declares the attribute `name` */
  predicate declares(string name) { this.(ClassList).declares(name) }

  /** Gets the length of this MRO */
  int length() { result = this.(ClassList).length() }

  /** Holds if this MRO contains `cls` */
  predicate contains(ClassValue cls) { this.(ClassList).contains(cls) }

  /** Gets the value from scanning for the attribute `name` in this MRO. */
  Value lookup(string name) { this.(ClassList).lookup(name, result, _) }

  /**
   * Gets the MRO formed by removing all classes before `cls`
   * from this MRO.
   */
  MRO startingAt(ClassValue cls) { result = this.(ClassList).startingAt(cls) }
}

module ClassValue {
  /** Get the `ClassValue` for the `bool` class. */
  ClassValue bool() { result = TBuiltinClassObject(Builtin::special("bool")) }

  /** Get the `ClassValue` for the `tuple` class. */
  ClassValue tuple() { result = TBuiltinClassObject(Builtin::special("tuple")) }

  /** Get the `ClassValue` for the `list` class. */
  ClassValue list() { result = TBuiltinClassObject(Builtin::special("list")) }

  /** Get the `ClassValue` for `xrange` (Python 2), or `range` (only Python 3) */
  ClassValue range() {
    major_version() = 2 and result = TBuiltinClassObject(Builtin::special("xrange"))
    or
    major_version() = 3 and result = TBuiltinClassObject(Builtin::special("range"))
  }

  /** Get the `ClassValue` for the `dict` class. */
  ClassValue dict() { result = TBuiltinClassObject(Builtin::special("dict")) }

  /** Get the `ClassValue` for the `set` class. */
  ClassValue set() { result = TBuiltinClassObject(Builtin::special("set")) }

  /** Get the `ClassValue` for the `object` class. */
  ClassValue object() { result = TBuiltinClassObject(Builtin::special("object")) }

  /** Get the `ClassValue` for the `int` class. */
  ClassValue int_() { result = TBuiltinClassObject(Builtin::special("int")) }

  /** Get the `ClassValue` for the `long` class. */
  ClassValue long() { result = TBuiltinClassObject(Builtin::special("long")) }

  /** Get the `ClassValue` for the `float` class. */
  ClassValue float_() { result = TBuiltinClassObject(Builtin::special("float")) }

  /** Get the `ClassValue` for the `complex` class. */
  ClassValue complex() { result = TBuiltinClassObject(Builtin::special("complex")) }

  /** Get the `ClassValue` for the `bytes` class (also called `str` in Python 2). */
  ClassValue bytes() { result = TBuiltinClassObject(Builtin::special("bytes")) }

  /**
   * Get the `ClassValue` for the class of unicode strings.
   * `str` in Python 3 and `unicode` in Python 2.
   */
  ClassValue unicode() { result = TBuiltinClassObject(Builtin::special("unicode")) }

  /**
   * Get the `ClassValue` for the `str` class. This is `bytes` in Python 2,
   * and `str` in Python 3.
   */
  ClassValue str() { if major_version() = 2 then result = bytes() else result = unicode() }

  /** Get the `ClassValue` for the `property` class. */
  ClassValue property() { result = TBuiltinClassObject(Builtin::special("property")) }

  /** Get the `ClassValue` for the class of Python functions. */
  ClassValue functionType() { result = TBuiltinClassObject(Builtin::special("FunctionType")) }

  /** Get the `ClassValue` for the class of builtin functions. */
  ClassValue builtinFunction() { result = Value::named("len").getClass() }

  /** Get the `ClassValue` for the `generatorType` class. */
  ClassValue generator() { result = TBuiltinClassObject(Builtin::special("generator")) }

  /** Get the `ClassValue` for the `type` class. */
  ClassValue type() { result = TType() }

  /** Get the `ClassValue` for `ClassType`. */
  ClassValue classType() { result = TBuiltinClassObject(Builtin::special("ClassType")) }

  /** Get the `ClassValue` for `InstanceType`. */
  ClassValue instanceType() { result = TBuiltinClassObject(Builtin::special("InstanceType")) }

  /** Get the `ClassValue` for `super`. */
  ClassValue super_() { result = TBuiltinClassObject(Builtin::special("super")) }

  /** Get the `ClassValue` for the `classmethod` class. */
  ClassValue classmethod() { result = TBuiltinClassObject(Builtin::special("ClassMethod")) }

  /** Get the `ClassValue` for the `staticmethod` class. */
  ClassValue staticmethod() { result = TBuiltinClassObject(Builtin::special("StaticMethod")) }

  /** Get the `ClassValue` for the `MethodType` class. */
  pragma[noinline]
  ClassValue methodType() { result = TBuiltinClassObject(Builtin::special("MethodType")) }

  /** Get the `ClassValue` for the `MethodDescriptorType` class. */
  ClassValue methodDescriptorType() {
    result = TBuiltinClassObject(Builtin::special("MethodDescriptorType"))
  }

  /** Get the `ClassValue` for the `GetSetDescriptorType` class. */
  ClassValue getSetDescriptorType() {
    result = TBuiltinClassObject(Builtin::special("GetSetDescriptorType"))
  }

  /** Get the `ClassValue` for the `StopIteration` class. */
  ClassValue stopIteration() { result = TBuiltinClassObject(Builtin::builtin("StopIteration")) }

  /** Get the `ClassValue` for the class of modules. */
  ClassValue module_() { result = TBuiltinClassObject(Builtin::special("ModuleType")) }

  /** Get the `ClassValue` for the `Exception` class. */
  ClassValue exception() { result = TBuiltinClassObject(Builtin::special("Exception")) }

  /** Get the `ClassValue` for the `BaseException` class. */
  ClassValue baseException() { result = TBuiltinClassObject(Builtin::special("BaseException")) }

  /** Get the `ClassValue` for the `NoneType` class. */
  ClassValue nonetype() { result = TBuiltinClassObject(Builtin::special("NoneType")) }

  /** Get the `ClassValue` for the `TypeError` class */
  ClassValue typeError() { result = TBuiltinClassObject(Builtin::special("TypeError")) }

  /** Get the `ClassValue` for the `NameError` class. */
  ClassValue nameError() { result = TBuiltinClassObject(Builtin::builtin("NameError")) }

  /** Get the `ClassValue` for the `AttributeError` class. */
  ClassValue attributeError() { result = TBuiltinClassObject(Builtin::builtin("AttributeError")) }

  /** Get the `ClassValue` for the `KeyError` class. */
  ClassValue keyError() { result = TBuiltinClassObject(Builtin::builtin("KeyError")) }

  /** Get the `ClassValue` for the `LookupError` class. */
  ClassValue lookupError() { result = TBuiltinClassObject(Builtin::builtin("LookupError")) }

  /** Get the `ClassValue` for the `IndexError` class. */
  ClassValue indexError() { result = TBuiltinClassObject(Builtin::builtin("IndexError")) }

  /** Get the `ClassValue` for the `IOError` class. */
  ClassValue ioError() { result = TBuiltinClassObject(Builtin::builtin("IOError")) }

  /** Get the `ClassValue` for the `NotImplementedError` class. */
  ClassValue notImplementedError() {
    result = TBuiltinClassObject(Builtin::builtin("NotImplementedError"))
  }

  /** Get the `ClassValue` for the `ImportError` class. */
  ClassValue importError() { result = TBuiltinClassObject(Builtin::builtin("ImportError")) }

  /** Get the `ClassValue` for the `UnicodeEncodeError` class. */
  ClassValue unicodeEncodeError() {
    result = TBuiltinClassObject(Builtin::builtin("UnicodeEncodeError"))
  }

  /** Get the `ClassValue` for the `UnicodeDecodeError` class. */
  ClassValue unicodeDecodeError() {
    result = TBuiltinClassObject(Builtin::builtin("UnicodeDecodeError"))
  }

  /** Get the `ClassValue` for the `SystemExit` class. */
  ClassValue systemExit() { result = TBuiltinClassObject(Builtin::builtin("SystemExit")) }
}
