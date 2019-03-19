import python

private import semmle.python.objects.TObject
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.types.Builtins
import semmle.python.objects.Modules
import semmle.python.objects.Classes
import semmle.python.objects.Constants

abstract class ObjectInternal extends TObject {

    abstract string toString();

    /** The boolean value of this object, if it has one */
    abstract boolean booleanValue();

    /** Holds if this object may be true or false when evaluated as a bool */
    abstract predicate maybe();

    abstract predicate introduced(ControlFlowNode node, PointsToContext2 context);

    /** Gets the class declaration for this object, if it is a declared class. */
    abstract ClassDecl getClassDeclaration();

    abstract predicate isClass();

    abstract predicate notClass();

    abstract ObjectInternal getClass();

    /** Holds if whatever this "object" represents can be meaningfully analysed for
     * truth or false in comparisons. For example, `None` or `int` can be, but `int()`
     * or an unknown string cannot.
     */
    abstract predicate isComparable();

    /** The negation of `isComparable()` */
    abstract predicate notComparable();

    /** Gets the `Builtin` for this object, if any.
     * All objects (except unknown and undefined values) should return 
     * exactly one result for either this method or `getOrigin()`.
     */
    abstract Builtin getBuiltin();

    /** Gets a control flow node that represents the source origin of this 
     * objects.
     * All objects (except unknown and undefined values) should return 
     * exactly one result for either this method or `getBuiltin()`.
     */
    abstract ControlFlowNode getOrigin();

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj`.
     */
    abstract predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin);

    predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        this.getOrigin().getLocation().hasLocationInfo(fp, bl, bc, el, ec)
    }

    /** The integer value of things that have integer values.
     * That is, ints and bools.
     */
    int intValue() {
        none()
    }

    /** The integer value of things that have integer values.
     * That is, strings.
     */
    string strValue() {
        none()
    }

    predicate calleeAndOffset(Function scope, int paramOffset) { none() }

}


class PythonFunctionObjectInternal extends ObjectInternal, TPythonFunctionObject {

    Function getScope() {
        exists(CallableExpr expr |
            this = TPythonFunctionObject(expr.getAFlowNode()) and
            result = expr.getInnerScope()
        )
    }

    override string toString() {
        result = this.getScope().toString()
    }

    /** The boolean value of this object, if it has one */
    override boolean booleanValue() {
        result = true
    }

    /** Holds if this object may be true or false when evaluated as a bool */
    override predicate maybe() { none() }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        this = TPythonFunctionObject(node) and context.appliesTo(node)
    }

    /** INTERNAL */
    override ClassDecl getClassDeclaration() { none() }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("FunctionType"))
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

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

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        scope = this.getScope() and paramOffset = 0
    }

}

/// BOUND METHODS
///
///
///

class BuiltinFunctionObjectInternal extends ObjectInternal, TBuiltinFunctionObject {

    override Builtin getBuiltin() {
        this = TBuiltinFunctionObject(result)
    }

    override string toString() {
        result = "builtin function " + this.getBuiltin().getName()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // TO DO .. Result should be be a unknown value of a known class if the return type is known or just an unknown.
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}


class BuiltinMethodObjectInternal extends ObjectInternal, TBuiltinMethodObject {

    override Builtin getBuiltin() {
        this = TBuiltinMethodObject(result)
    }

    override string toString() {
        result = "builtin method " + this.getBuiltin().getName()
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // TO DO .. Result should be be a unknown value of a known class if the return type is known or just an unknown.
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}


class BuiltinOpaqueObjectInternal extends ObjectInternal, TBuiltinOpaqueObject {

    override Builtin getBuiltin() {
        this = TBuiltinOpaqueObject(result)
    }

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        // TO DO ... Depends on class. `this.getClass().instancesAlways(result)`
        none()
    }

    override predicate maybe() {
        // TO DO ... Depends on class. `this.getClass().instancesMaybe()`
        any()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate isComparable() {
        none()
    }

    override predicate notComparable() {
        any()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown() and
        callee_for_object(callee, this)
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

private predicate callee_for_object(PointsToContext2 callee, ObjectInternal obj) {
    exists(CallNode call, PointsToContext2 caller |
        callee.fromCall(call, caller) and
        PointsTo2::points_to(call.getFunction(), caller, obj, _)
    )
}


class UnknownClassInternal extends ObjectInternal, TUnknownClass {

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        none()
    }

    override predicate maybe() { any() }

    override ClassDecl getClassDeclaration() {
        result = Builtin::unknownType()
    }

    override predicate isClass() { any() }

    override predicate notClass() { none() }

    override ObjectInternal getClass() {
        result = TUnknownClass()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate isComparable() {
        none()
    }

    override predicate notComparable() {
        any()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown() and
        callee_for_object(callee, this)
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

class UnknownInternal extends ObjectInternal, TUnknown {

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        none()
    }

    override predicate maybe() { any() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TUnknownClass()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate isComparable() {
        none()
    }

    override predicate notComparable() {
        any()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown() and
        callee_for_object(callee, this)
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

class UndefinedInternal extends ObjectInternal, TUndefined {

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        none()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        none()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override predicate isComparable() {
        none()
    }

    override predicate notComparable() {
        any()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // Accessing an undefined value raises a NameError, but if during import it probably
        // means that we missed an import.
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown() and
        callee.getOuter().isImport()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

module ObjectInternal {

    ObjectInternal bool(boolean b) {
        b = true and result = TTrue()
        or
        b = false and result = TFalse()
    }

    ObjectInternal none_() {
        result = TNone()
    }


    ObjectInternal unknown() {
        result = TUnknown()
    }

    ObjectInternal unknownClass() {
        result = TUnknownClass()
    }

    ObjectInternal undefined() {
        result = TUndefined()
    }

    ObjectInternal builtin(string name) {
        result = TBuiltinClassObject(Builtin::builtin(name))
        or
        result = TBuiltinFunctionObject(Builtin::builtin(name))
        or
        result = TBuiltinOpaqueObject(Builtin::builtin(name))
    }

    ObjectInternal sysModules() {
       result = TBuiltinOpaqueObject(Builtin::special("sys").getMember("modules"))
    }

    ObjectInternal fromInt(int n) {
        result = TInt(n)
    }

}

