import python

private import semmle.python.objects.TObject
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins
import semmle.python.objects.Modules
import semmle.python.objects.Classes
import semmle.python.objects.Instances
import semmle.python.objects.Callables
import semmle.python.objects.Constants
import semmle.python.objects.Sequences

class ObjectInternal extends TObject {

    abstract string toString();

    /** The boolean value of this object, this may be both
     * true and false if the "object" represents a set of possible objects. */
    abstract boolean booleanValue();

    abstract predicate introduced(ControlFlowNode node, PointsToContext context);

    /** Gets the class declaration for this object, if it is a declared class. */
    abstract ClassDecl getClassDeclaration();

    /** True if this "object" is a class. */
    abstract boolean isClass();

    abstract ObjectInternal getClass();

    /** True if this "object" can be meaningfully analysed for
     * truth or false in comparisons. For example, `None` or `int` can be, but `int()`
     * or an unknown string cannot.
     */
    abstract boolean isComparable();

    /** Gets the `Builtin` for this object, if any.
     * Objects (except unknown and undefined values) should attempt to return
     * exactly one result for either this method or `getOrigin()`.
     */
    abstract Builtin getBuiltin();

    /** Gets a control flow node that represents the source origin of this
     * objects.
     */
    abstract ControlFlowNode getOrigin();

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj`.
     */
    abstract predicate callResult(ObjectInternal obj, CfgOrigin origin);

    /** Holds if `obj` is the result of calling `this` and `origin` is
     * the origin of `obj` with callee context `callee`.
     */
    abstract predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin);

    /** The integer value of things that have integer values.
     * That is, ints and bools.
     */
    abstract int intValue();

    /** The integer value of things that have integer values.
     * That is, strings.
     */
    abstract string strValue();

    abstract predicate calleeAndOffset(Function scope, int paramOffset);

    final predicate isBuiltin() {
        exists(this.getBuiltin())
    }

    abstract predicate attribute(string name, ObjectInternal value, CfgOrigin origin);

    abstract predicate attributesUnknown();

    /** For backwards compatibility shim -- Not all objects have a "source" 
     * Objects (except unknown and undefined values) should attempt to return
     * exactly one result for either this method`.
     * */
    @py_object getSource() {
        result = this.getOrigin()
        or
        result = this.getBuiltin()
    }

}


class BuiltinOpaqueObjectInternal extends ObjectInternal, TBuiltinOpaqueObject {

    override Builtin getBuiltin() {
        this = TBuiltinOpaqueObject(result)
    }

    override string toString() {
        result = this.getBuiltin().getClass().getName() + " object"
    }

    override boolean booleanValue() {
        // TO DO ... Depends on class. `result = this.getClass().instancesBooleanValue()`
        result = maybe()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override boolean isComparable() { result = false }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        value = ObjectInternal::fromBuiltin(this.getBuiltin().getMember(name)) and
        origin = CfgOrigin::unknown()
    }

    override predicate attributesUnknown() { none() }

}


class UnknownInternal extends ObjectInternal, TUnknown {

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        result = maybe()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override ObjectInternal getClass() {
        result = TUnknownClass()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override boolean isComparable() { result = false }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { any() }

}

class UndefinedInternal extends ObjectInternal, TUndefined {

    override string toString() {
        none()
    }

    override boolean booleanValue() {
        none()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = false }

    override ObjectInternal getClass() {
        none()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override Builtin getBuiltin() {
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        none()
    }

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // Accessing an undefined value raises a NameError, but if during import it probably
        // means that we missed an import.
        obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

    override int intValue() {
        none()
    }

    override string strValue() {
        none()
    }

    override predicate calleeAndOffset(Function scope, int paramOffset) {
        none()
    }

    override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    override predicate attributesUnknown() { none() }

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

    ClassObjectInternal unknownClass() {
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
        or
        name = "type" and result = TType()
    }

    ObjectInternal sysModules() {
       result = TBuiltinOpaqueObject(Builtin::special("sys").getMember("modules"))
    }

    ObjectInternal fromInt(int n) {
        result = TInt(n)
    }

    ObjectInternal fromBuiltin(Builtin b) {
        result = TInt(b.intValue())
        or
        result = TString(b.strValue())
        or
        result = TBuiltinClassObject(b)
        or
        result = TBuiltinFunctionObject(b)
        or
        result = TBuiltinOpaqueObject(b)
        or
        result = TBuiltinModuleObject(b)
    }

    ObjectInternal classMethod() {
        result = TBuiltinClassObject(Builtin::special("ClassMethod"))
    }

    ObjectInternal staticMethod() {
        result = TBuiltinClassObject(Builtin::special("StaticMethod"))
    }

    ObjectInternal moduleType() {
        result = TBuiltinClassObject(Builtin::special("ModuleType"))
    }
}

/** Helper for boolean predicates returning both `true` and `false` */
boolean maybe() {
    result = true or result = false
}
