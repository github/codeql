
import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.pointsto.MRO2
private import semmle.python.types.Builtins


abstract class CallableObjectInternal extends ObjectInternal {

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

    override boolean isClass() { result = false }

    /** The boolean value of this object, if it has one */
    override boolean booleanValue() {
        result = true
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    abstract string getName();

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { none() }

}


class PythonFunctionObjectInternal extends CallableObjectInternal, TPythonFunctionObject {

    Function getScope() {
        exists(CallableExpr expr |
            this = TPythonFunctionObject(expr.getAFlowNode()) and
            result = expr.getInnerScope()
        )
    }

    override string toString() {
        result = this.getScope().toString()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        this = TPythonFunctionObject(node) and context.appliesTo(node)
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("FunctionType"))
    }

    override boolean isComparable() { result = true }

    override Builtin getBuiltin() {
        none()
    }

    override ControlFlowNode getOrigin() {
        this = TPythonFunctionObject(result)
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        exists(Function func, ControlFlowNode rval |
            func = this.getScope() and
            callee.appliesToScope(func) and
            rval = func.getAReturnValueFlowNode() and
            PointsTo2::points_to(rval, callee, obj, origin)
        )
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        scope = this.getScope() and paramOffset = 0
    }

    override string getName() {
        result = this.getScope().getName()
    }

}

class BuiltinFunctionObjectInternal extends CallableObjectInternal, TBuiltinFunctionObject {

    override Builtin getBuiltin() {
        this = TBuiltinFunctionObject(result)
    }

    override string toString() {
        result = "Builtin-function " + this.getBuiltin().getName()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override boolean isComparable() { result = true }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        exists(Builtin func, ClassObjectInternal cls |
            func = this.getBuiltin() and
            func != Builtin::builtin("isinstance") and
            func != Builtin::builtin("issubclass") and
            func != Builtin::builtin("callable")
            |
            cls = ObjectInternal::fromBuiltin(this.getReturnType()) and
            obj = TUnknownInstance(cls)
        ) and
        origin = CfgOrigin::unknown()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override string getName() {
        result = this.getBuiltin().getName()
    }

    Builtin getReturnType() {
        exists(Builtin func |
            func = this.getBuiltin() |
            /* Enumerate the types of a few builtin functions, that the CPython analysis misses.
            */
            func = Builtin::builtin("hex") and result = Builtin::special("str")
            or
            func = Builtin::builtin("oct") and result = Builtin::special("str")
            or
            func = Builtin::builtin("intern") and result = Builtin::special("str")
            or
            /* Fix a few minor inaccuracies in the CPython analysis */ 
            ext_rettype(func, result) and not (
                func = Builtin::builtin("__import__") and result = Builtin::special("NoneType")
                or
                func = Builtin::builtin("compile") and result = Builtin::special("NoneType")
                or
                func = Builtin::builtin("sum")
                or
                func = Builtin::builtin("filter")
            )
        )
    }

}


class BuiltinMethodObjectInternal extends CallableObjectInternal, TBuiltinMethodObject {

    override Builtin getBuiltin() {
        this = TBuiltinMethodObject(result)
    }

    override string toString() {
        result = "builtin method " + this.getBuiltin().getName()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override boolean isComparable() { result = true }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // TO DO .. Result should be be a unknown value of a known class if the return type is known or just an unknown.
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override string getName() {
        result = this.getBuiltin().getName()
    }

}

class BoundMethodObjectInternal extends CallableObjectInternal, TBoundMethod {

    override Builtin getBuiltin() {
        none()
    }

    CallableObjectInternal getFunction() {
        this = TBoundMethod(_, _, result, _)
    }

    ObjectInternal getSelf() {
        this = TBoundMethod(_, result, _, _)
    }

    override string toString() {
        result = "bound method '" + this.getFunction().getName() + "' of " + this.getSelf().toString()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("MethodType"))
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        this = TBoundMethod(node, _, _, context)
    }

    override boolean isComparable() { result = false }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        this.getFunction().callResult(callee, obj, origin)
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        this.getFunction().callResult(obj, origin)
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        this.getFunction().calleeAndOffset(scope, paramOffset-1)
    }

    override string getName() {
        result = this.getFunction().getName()
    }

}




