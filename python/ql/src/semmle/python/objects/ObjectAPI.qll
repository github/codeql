import python
private import TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext

class ObjectSource = Object;

class Value extends TObject {

    Value() {
        not this = ObjectInternal::unknown() and
        not this = ObjectInternal::unknownClass() and
        not this = ObjectInternal::undefined()
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

}

class ModuleValue extends Value {

    ModuleValue() {
        this instanceof ModuleObjectInternal
    }

    predicate exports(string name) {
        not this.(ModuleObjectInternal).attribute("__all__", _, _) and this.(ModuleObjectInternal).attribute(name, _, _)
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
        // TO DO..
        none()
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

    ControlFlowNode getArgumentForCall(CallNode call, NameNode param) {
        this.getACall() = call and
        (
            exists(int n | call.getArg(n) = result and param = this.getParameter(n))
            or
            exists(string name | call.getArgByName(name) = result and param = this.getParameterByName(name))
        )
        or
        exists(BoundMethodObjectInternal bm |
            result = getArgumentForCall(call, param) and
            this = bm.getFunction()
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

