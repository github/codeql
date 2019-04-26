import python

private import semmle.python.objects.TObject
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins
import semmle.python.objects.Modules
import semmle.python.objects.Classes
import semmle.python.objects.Instances
import semmle.python.objects.Callables
import semmle.python.objects.Constants
import semmle.python.objects.Sequences
import semmle.python.objects.Descriptors

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

    /** The string value of things that have string values.
     * That is, strings.
     */
    abstract string strValue();

    abstract predicate calleeAndOffset(Function scope, int paramOffset);

    final predicate isBuiltin() {
        exists(this.getBuiltin())
    }

    abstract predicate attribute(string name, ObjectInternal value, CfgOrigin origin);

    abstract predicate attributesUnknown();

    abstract predicate subscriptUnknown();

    /** For backwards compatibility shim -- Not all objects have a "source".
     * Objects (except unknown and undefined values) should attempt to return
     * exactly one result for this method.
     * */
    @py_object getSource() {
        result = this.getOrigin()
        or
        result = this.getBuiltin()
    }

    abstract boolean isDescriptor();

    pragma[nomagic]
    abstract predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin);

    pragma[nomagic]
    abstract predicate descriptorGetInstance(ObjectInternal instance, ObjectInternal value, CfgOrigin origin);

    /** Holds if attribute lookup on this object may "bind" `instance` to `descriptor`.
     * Here "bind" means that `instance` is passed to the `descriptor.__get__()` method
     * at runtime. The term "bind" is used as this most likely results in a bound-method.
     */
    abstract predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor);

    /** Gets the length of the sequence that this "object" represents.
     * Always returns a value for a sequence, will be -1 if object has no fixed length.
     */
    abstract int length();

    predicate functionAndOffset(CallableObjectInternal function, int offset) { none() }

    /** Holds if this 'object' represents an entity that is inferred to exist
     * but is missing from the database */
    predicate isMissing() {
        none()
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

    pragma [noinline] override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        value = ObjectInternal::fromBuiltin(this.getBuiltin().getMember(name)) and
        origin = CfgOrigin::unknown()
    }

    pragma [noinline] override predicate attributesUnknown() { none() }

    override predicate subscriptUnknown() {
        exists(this.getBuiltin().getItem(_))
    }

    override boolean isDescriptor() { result = false }

    pragma [noinline] override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate descriptorGetInstance(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

    override int length() { none() }

}


class UnknownInternal extends ObjectInternal, TUnknown {

    override string toString() {
        result = "Unknown value"
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
        result = Builtin::unknown()
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

    pragma [noinline] override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    pragma [noinline] override predicate attributesUnknown() { any() }

    override predicate subscriptUnknown() { any() }

    override boolean isDescriptor() { result = false }

    pragma [noinline] override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate descriptorGetInstance(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

    override int length() { result = -1 }

}

class UndefinedInternal extends ObjectInternal, TUndefined {

    override string toString() {
        result = "Undefined variable"
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

    pragma [noinline] override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
        none()
    }

    pragma [noinline] override predicate attributesUnknown() { none() }

    override predicate subscriptUnknown() { none() }

    override boolean isDescriptor() { none() }

    pragma [noinline] override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate descriptorGetInstance(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    pragma [noinline] override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }

    override int length() { none() }

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
        b = result.getBuiltin() and
        not b = Builtin::unknown() and
        not b = Builtin::unknownType() and
        not b = Builtin::special("sys").getMember("version_info")
        or
        b = Builtin::special("sys").getMember("version_info") and result = TSysVersionInfo()
    }

    ObjectInternal classMethod() {
        result = TBuiltinClassObject(Builtin::special("ClassMethod"))
    }

    ObjectInternal staticMethod() {
        result = TBuiltinClassObject(Builtin::special("StaticMethod"))
    }

    ObjectInternal boundMethod() {
        result = TBuiltinClassObject(Builtin::special("MethodType"))
    }

    ObjectInternal moduleType() {
        result = TBuiltinClassObject(Builtin::special("ModuleType"))
    }

    ObjectInternal noneType() {
        result = TBuiltinClassObject(Builtin::special("NoneType"))
    }

    ObjectInternal type() {
        result = TType()
    }

    ObjectInternal property() {
        result = TBuiltinClassObject(Builtin::special("property"))
    }

    ObjectInternal superType() {
        result = TBuiltinClassObject(Builtin::special("super"))
    }

    /** The old-style class type (Python 2 only) */
    ObjectInternal classType() {
        result = TBuiltinClassObject(Builtin::special("ClassType"))
    }

}

/** Helper for boolean predicates returning both `true` and `false` */
boolean maybe() {
    result = true or result = false
}

/** Helper for attributes */
pragma [nomagic]
predicate receiver_type(AttrNode attr, string name, ObjectInternal value, ClassObjectInternal cls) {
    PointsToInternal::pointsTo(attr.getObject(name), _, value, _) and value.getClass() = cls
}

