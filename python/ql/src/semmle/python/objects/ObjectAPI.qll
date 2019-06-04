/**
 * Public API for "objects"
 * A `Value` is a static approximation to a set of runtime objects.
 */




import python
private import TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext

/* Use the term `ObjectSource` to refer to DB entity. Either a CFG node
 * for Python objects, or `@py_cobject` entity for built-in objects.
 */
class ObjectSource = Object;

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
    Value getClass() {
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

    /** DEPRECATED: For backwards compatibility with old API
     * Use `Value` instead of `ObjectSource`.
     */
    deprecated ObjectSource getSource() {
        result = this.(ObjectInternal).getSource()
    }

    /** Holds if this value is builtin. Applies to built-in functions and methods,
     * but also integers and strings.
     */
    predicate isBuiltin() {
        this.(ObjectInternal).isBuiltin()
    }

    /** Holds if this value represents an entity that is inferred to exist,
     * but missing from the database.
     * Most commonly, this is a module that is imported, but wasn't present during extraction.
     */
    predicate isMissing() {
        this.(ObjectInternal).isMissing()
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

    /** Gets the name of this module */
    string getName() {
        result = this.(ModuleObjectInternal).getName()
    }

    /** Gets the scope for this module, provided that it is a Python module. */
    Module getScope() {
        result = this.(ModuleObjectInternal).getSourceModule()
    }

}

module Module {

    /** Gets the `ModuleValue` named `name` */
    ModuleValue named(string name) {
        result.getName() = name
    }

}

module Value {

    /** Gets the `Value` named `name`.
     * If has at least one '.' in `name`, then the part of
     * the name to the left of the rightmost '.' is interpreted as a module name
     * and the part after the rightmost '.' as an attribute of that module.
     * For example, `Value::named("os.path.join")` is the `Value` representing the function
     * `join` in the module `os.path`.
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
    Function getScope() {
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

}

