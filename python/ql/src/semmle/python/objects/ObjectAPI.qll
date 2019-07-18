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

/* Use the term `ObjectSource` to refer to DB entity. Either a CFG node
 * for Python objects, or `@py_cobject` entity for built-in objects.
 */
class ObjectSource = Object;

/* Aliases for scopes */
class FunctionScope = Function;
class ClassScope = Class;
class ModuleScope = Module;

/** Class representing values in the Python program
 * Each `Value` is a static approximation to a set of one or more real objects.
 */
class Value extends TObject {

    Value() {
        this != ObjectInternal::unknown() and
        this != ObjectInternal::unknownClass() and
        this != ObjectInternal::undefined()
    }

    string toString() {
        result = this.(ObjectInternal).toString()
    }

    /** Gets a `ControlFlowNode` that refers to this object. */
    ControlFlowNode getAReference() {
        PointsToInternal::pointsTo(result, _, this, _)
    }

    /** Gets the class of this object.
     * Strictly, the `Value` representing the class of the objects
     * represented by this Value.
     */
    ClassValue getClass() {
        result = this.(ObjectInternal).getClass()
    }

    /** Gets a call to this object */
    CallNode getACall() {
        result = this.getACall(_)
    }

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
    Value attr(string name) {
        this.(ObjectInternal).attribute(name, result, _)
    }

    /** Holds if this value is builtin. Applies to built-in functions and methods,
     * but also integers and strings.
     */
    predicate isBuiltin() {
        this.(ObjectInternal).isBuiltin()
    }

    predicate hasLocationInfo(string filepath, int bl, int bc, int el, int ec) {
        this.(ObjectInternal).getOrigin().getLocation().hasLocationInfo(filepath, bl, bc, el, ec)
        or
        not exists(this.(ObjectInternal).getOrigin()) and
        filepath = "" and bl = 0 and bc = 0 and el = 0 and ec = 0
    }

    /** Gets the name of this value, if it has one. 
     * Note this is the innate name of the
     * object, not necessarily all the names by which it can be called.
     */
    final string getName() {
        result = this.(ObjectInternal).getName()
    }

}

/** Class representing modules in the Python program
 * Each `ModuleValue` represents a module object in the Python program.
 */
class ModuleValue extends Value {

    ModuleValue() {
        this instanceof ModuleObjectInternal
    }

    /** Holds if this module "exports" name.
     * That is, does it define `name` in `__all__` or is
     * `__all__` not defined and `name` a global variable that does not start with "_"
     * This is the set of names imported by `from ... import *`.
     */
    predicate exports(string name) {
        not this.(ModuleObjectInternal).attribute("__all__", _, _) and exists(this.attr(name))
        and not name.charAt(0) = "_"
        or
        py_exports(this.getScope(), name)
    }

    /** Gets the scope for this module, provided that it is a Python module. */
    ModuleScope getScope() {
        result = this.(ModuleObjectInternal).getSourceModule()
    }

    /** Gets the container path for this module. Will be the file for a Python module,
     * the folder for a package and no result for a builtin module.
     */
    Container getPath() {
        result = this.(PackageObjectInternal).getFolder()
        or
        result = this.(PythonModuleObjectInternal).getSourceModule().getFile()
    }

}

module Module {

    /** Gets the `ModuleValue` named `name`.
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
        dots = 0 and not name.charAt(_) = "." and
        result.getName() = name
        or
        dots <= 3 and
        exists(string modname, string attrname |
            name = modname + "." + attrname |
            result = named(modname, dots-1).attr(attrname)
        )
    }

}

module Value {

    /** Gets the `Value` named `name`.
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
        exists(string modname, string attrname |
            name = modname + "." + attrname |
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

}

/** Class representing callables in the Python program
 * Callables include Python functions, built-in functions and bound-methods,
 * but not classes.
 */
class CallableValue extends Value {

    CallableValue() {
        this instanceof CallableObjectInternal
    }

    /** Holds if this callable never returns once called.
     * For example, `sys.exit`
     */
    predicate neverReturns() {
        this.(CallableObjectInternal).neverReturns()
    }

    /** Gets the scope for this function, provided that it is a Python function. */
    FunctionScope getScope() {
        result = this.(PythonFunctionObjectInternal).getScope()
    }

    /** Gets the `n`th parameter node of this callable. */
    NameNode getParameter(int n) {
        result = this.(CallableObjectInternal).getParameter(n)
    }

    /** Gets the `name`d parameter node of this callable. */
    NameNode getParameterByName(string name) {
        result = this.(CallableObjectInternal).getParameterByName(name)
    }

    /** Gets the argument corresponding to the `n'th parameter node of this callable. */
    cached ControlFlowNode getArgumentForCall(CallNode call, int n) {
        exists(ObjectInternal called, int offset |
            PointsToInternal::pointsTo(call.getFunction(), _, called, _) and
            called.functionAndOffset(this, offset) 
            |
            call.getArg(n-offset) = result
            or
            exists(string name | call.getArgByName(name) = result and this.(PythonFunctionObjectInternal).getScope().getArg(n+offset).getName() = name)
            or
            called instanceof BoundMethodObjectInternal and
            offset = 1 and n = 0 and result = call.getFunction().(AttrNode).getObject()
        )
    }


    /** Gets the argument corresponding to the `name`d parameter node of this callable. */
    cached ControlFlowNode getNamedArgumentForCall(CallNode call, string name) {
        exists(CallableObjectInternal called, int offset |
            PointsToInternal::pointsTo(call.getFunction(), _, called, _) and
            called.functionAndOffset(this, offset)
            |
            exists(int n |
                call.getArg(n) = result and
                this.(PythonFunctionObjectInternal).getScope().getArg(n+offset).getName() = name
            )
            or
            call.getArgByName(name) = result and
            exists(this.(PythonFunctionObjectInternal).getScope().getArgByName(name))
            or
            called instanceof BoundMethodObjectInternal and
            offset = 1 and name = "self" and result = call.getFunction().(AttrNode).getObject()
        )
    }

}

/** Class representing classes in the Python program, both Python and built-in.
 */
class ClassValue extends Value {

    ClassValue() {
        this.(ObjectInternal).isClass() = true
    }

    /** Gets an improper super type of this class. */
    ClassValue getASuperType() {
        result = Types::getMro(this).getAnItem()
    }

    /** Looks up the attribute `name` on this class.
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
    Value lookup(string name) {
        this.(ClassObjectInternal).lookup(name, result, _)
    }

    predicate isCallable() {
        this.(ClassObjectInternal).lookup("__call__", _, _)
    }

    /** Gets the qualified name for this class.
     * Should return the same name as the `__qualname__` attribute on classes in Python 3.
     */
    string getQualifiedName() {
        result = this.(ClassObjectInternal).getBuiltin().getName()
        or
        result = this.(PythonClassObjectInternal).getScope().getQualifiedName()
    }

    /** Gets the MRO for this class */
    MRO getMro() {
        result = Types::getMro(this)
    }

    predicate failedInference(string reason) {
        Types::failedInference(this, reason)
    }

    /** Gets the nth base class of this class */
    ClassValue getBaseType(int n) {
        result = Types::getBase(this, n)
    }

    /** Holds if this class is a new style class. 
        A new style class is one that implicitly or explicitly inherits from `object`. */
    predicate isNewStyle() {
        Types::isNewStyle(this)
    }

    /** Holds if this class is an old style class. 
        An old style class is one that does not inherit from `object`. */
    predicate isOldStyle() {
        Types::isOldStyle(this)
    }

    /** Gets the scope associated with this class, if it is not a builtin class */
    ClassScope getScope() {
        result = this.(PythonClassObjectInternal).getScope()
    }

}

/** A method-resolution-order sequence of classes */
class MRO extends TClassList {

    string toString() {
        result = this.(ClassList).toString()
    }

    /** Gets the `n`th class in this MRO */
    ClassValue getItem(int n) {
        result = this.(ClassList).getItem(n)
    }

}

