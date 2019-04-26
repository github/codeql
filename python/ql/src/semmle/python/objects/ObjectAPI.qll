import python
private import TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext

class ObjectSource = Object;

class Value extends TObject {

    Value() {
        this != ObjectInternal::unknown() and
        this != ObjectInternal::unknownClass() and
        this != ObjectInternal::undefined()
    }

    string toString() {
        result = this.(ObjectInternal).toString()
    }

    ControlFlowNode getAReference() {
        PointsToInternal::pointsTo(result, _, this, _)
    }

    Value getClass() {
        result = this.(ObjectInternal).getClass()
    }

    CallNode getACall() {
        PointsToInternal::pointsTo(result.getFunction(), _, this, _)
        or
        exists(BoundMethodObjectInternal bm |
            PointsToInternal::pointsTo(result.getFunction(), _, bm, _) and
            bm.getFunction() = this
        )
    }

    CallNode getACall(PointsToContext caller) {
        PointsToInternal::pointsTo(result.getFunction(), caller, this, _)
        or
        exists(BoundMethodObjectInternal bm |
            PointsToInternal::pointsTo(result.getFunction(), caller, bm, _) and
            bm.getFunction() = this
        )
    }

    Value attr(string name) {
        this.(ObjectInternal).attribute(name, result, _)
    }

    /* For backwards compatibility with old API */
    deprecated ObjectSource getSource() {
        result = this.(ObjectInternal).getSource()
    }

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

class ModuleValue extends Value {

    ModuleValue() {
        this instanceof ModuleObjectInternal
    }

    predicate exports(string name) {
        not this.(ModuleObjectInternal).attribute("__all__", _, _) and exists(this.attr(name))
        and not name.charAt(0) = "_"
        or
        py_exports(this.getScope(), name)
    }

    string getName() {
        result = this.(ModuleObjectInternal).getName()
    }

    Module getScope() {
        result = this.(ModuleObjectInternal).getSourceModule()
    }

}

module Module {

    ModuleValue named(string name) {
        result.getName() = name
    }

}

module Value {

    Value named(string name) {
        exists(string modname, string attrname |
            name = modname + "." + attrname |
            result = Module::named(modname).attr(attrname)
        )
        or
        result = ObjectInternal::builtin(name)
    }

}

class CallableValue extends Value {

    CallableValue() {
        this instanceof CallableObjectInternal
    }

    predicate neverReturns() {
        this.(CallableObjectInternal).neverReturns()
    }

    Function getScope() {
        result = this.(PythonFunctionObjectInternal).getScope()
    }

    NameNode getParameter(int n) {
        result = this.(CallableObjectInternal).getParameter(n)
    }

    NameNode getParameterByName(string name) {
        result = this.(CallableObjectInternal).getParameterByName(name)
    }

    ControlFlowNode getArgumentForCall(CallNode call, int n) {
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

    ControlFlowNode getNamedArgumentForCall(CallNode call, string name) {
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

class ClassValue extends Value {

    ClassValue() {
        this.(ObjectInternal).isClass() = true
    }

    /** Gets an improper super type of this class. */
    ClassValue getASuperType() {
        result = Types::getMro(this).getAnItem()
    }

    Value lookup(string name) {
        this.(ClassObjectInternal).lookup(name, result, _)
    }

}

