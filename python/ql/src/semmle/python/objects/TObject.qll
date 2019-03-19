import python
private import semmle.python.types.Builtins
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2

newtype TObject =
    TBuiltinClassObject(Builtin bltn) {
        bltn.isClass() and not bltn = Builtin::unknownType()
    }
    or
    TBuiltinFunctionObject(Builtin bltn) { bltn.isFunction() }
    or
    TBuiltinMethodObject(Builtin bltn) { bltn.isMethod() }
    or
    TBuiltinModuleObject(Builtin bltn) { bltn.isModule() }
    or
    TBuiltinOpaqueObject(Builtin bltn) {
        not bltn.isClass() and not bltn.isFunction() and
        not bltn.isMethod() and not bltn.isModule() and
        not py_special_objects(bltn, _)
    }
    or
    TPythonFunctionObject(ControlFlowNode callable) {
        callable.getNode() instanceof CallableExpr
    }
    or
    TPythonClassObject(ControlFlowNode classdef) {
        classdef.getNode() instanceof ClassDef
    }
    or
    TPackageObject(Folder f)
    or
    TPythonModule(Module m) { not m.isPackage() }
    or
    TTrue()
    or
    TFalse()
    or
    TNone()
    or
    TUnknown()
    or
    TUnknownClass()
    or
    TUndefined()


library class ClassDecl extends @py_object {

    ClassDecl() {
        this.(Builtin).isClass() and not this = Builtin::unknownType()
        or
        this.(ControlFlowNode).getNode() instanceof ClassDef
    }

    string toString() {
        result = "ClassDecl"
    }

    predicate declaresAttribute(string name) {
        exists(this.(Builtin).getMember(name))
        or
        exists(Class cls |
            cls = this.(ControlFlowNode).getNode().(ClassDef).getDefinedClass() and
            exists(SsaVariable var | name = var.getId() and var.getAUse() = cls.getANormalExit())
        )
    }
}

abstract class ObjectInternal extends TObject {

    abstract string toString();

    /** The boolean value of this object, if it has one */
    abstract boolean booleanValue();

    /** Holds if this object may be true or false when evaluated as a bool */
    abstract predicate maybe();

    abstract predicate instantiated(ControlFlowNode node, PointsToContext2 context);

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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

}


abstract class ClassObjectInternal extends ObjectInternal {

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override predicate isClass() { any() }

    override predicate notClass() { none() }

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // TO DO .. Result should (in most cases) be an instance
        none()
    }

}

class PythonClassObjectInternal extends ClassObjectInternal, TPythonClassObject {

    Class getScope() {
        exists(ClassDef def |
            this = TPythonClassObject(def.getAFlowNode()) and
            result = def.getDefinedClass()
        )
    }

    override string toString() {
        result = this.getScope().toString()
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        exists(DefinitionNode def |
            this = TPythonClassObject(def) and 
            node = def.getValue() and
            context.appliesTo(node)
        )
    }

    override ClassDecl getClassDeclaration() {
        this = TPythonClassObject(result)
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("FunctionType"))
    }

    override Builtin getBuiltin() {
        none()
    }

    override ControlFlowNode getOrigin() {
        this = TPythonClassObject(result)
    }

}

class BuiltinClassObjectInternal extends ClassObjectInternal, TBuiltinClassObject {

    override Builtin getBuiltin() {
        this = TBuiltinClassObject(result)
    }

    override string toString() {
        result = "builtin class " + this.getBuiltin().getName()
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override ClassDecl getClassDeclaration() {
        this = TBuiltinClassObject(result)
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

abstract class ModuleObjectInternal extends ObjectInternal {

    abstract string getName();

    abstract Module getSourceModule();

    abstract predicate isBuiltin();

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // Modules aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        result = this.getSourceModule().getEntryNode()
    }

}

class BuiltinModuleObjectInternal extends ModuleObjectInternal, TBuiltinModuleObject {

    override Builtin getBuiltin() {
        this = TBuiltinModuleObject(result)
    }

    override string toString() {
        result = "builtin module " + this.getBuiltin().getName()
    }

    override string getName() {
        result = this.getBuiltin().getName()
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        none()
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

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Module getSourceModule() {
        none()
    }

    override predicate isBuiltin() {
        any()
    }

}

class PackageObjectInternal extends ModuleObjectInternal, TPackageObject {

    override Builtin getBuiltin() {
        none()
    }

    Folder getFolder() {
        this = TPackageObject(result)
    }

    override string toString() {
        result = "package " + this.getName()
    }

    override string getName() {
        result = moduleNameFromFile(this.getFolder())
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        none()
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

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Module getSourceModule() {
        result.getFile() = this.getFolder().getFile("__init__.py")
    }

    PythonModuleObjectInternal getInitModule() {
        result = TPythonModule(this.getSourceModule())
    }

    predicate hasNoInitModule() {
        exists(Folder f |
            f = this.getFolder() and
            not exists(f.getFile("__init__.py"))
        )
    }

    override predicate isBuiltin() {
        none()
    }

    ModuleObjectInternal submodule(string name) {
        result.getName() = this.getName() + "." + name
    }

    override predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        this.getOrigin().getLocation().hasLocationInfo(fp, bl, bc, el, ec)
        or
        this.hasNoInitModule() and fp = this.getFolder().getAbsolutePath() and
        bl = 0 and bc = 0 and el = 0 and ec = 0
    }

}

class PythonModuleObjectInternal extends ModuleObjectInternal, TPythonModule {

    override Builtin getBuiltin() {
        none()
    }

    override string toString() {
        result = "package " + this.getName()
    }

    override string getName() {
        result = this.getSourceModule().getName()
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        none()
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

    override predicate isComparable() {
        any()
    }

    override predicate notComparable() {
        none()
    }

    override Module getSourceModule() {
        this = TPythonModule(result)
    }

    PythonModuleObjectInternal getInitModule() {
        result = TPythonModule(this.getSourceModule())
    }

    override predicate isBuiltin() {
        none()
    }

}


class BuiltinFunctionObjectInternal extends ObjectInternal, TBuiltinFunctionObject {

    override Builtin getBuiltin() {
        this = TBuiltinFunctionObject(result)
    }

    override string toString() {
        result = "builtin function " + this.getBuiltin().getName()
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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


abstract class BooleanObjectInternal extends ObjectInternal {

    BooleanObjectInternal() {
        this = TTrue() or this = TFalse()
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("bool"))
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

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // Booleans aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        none()
    }

}

class TrueObjectInternal extends BooleanObjectInternal, TTrue {

    override string toString() {
        result = "True"
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "True" and context.appliesTo(node)
    }

}

class FalseObjectInternal extends BooleanObjectInternal, TFalse {

    override string toString() {
        result = "False"
    }

    override boolean booleanValue() {
        result = false
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "False" and context.appliesTo(node)
    }

}

class NoneObjectInternal extends ObjectInternal, TNone {

    override string toString() {
        result = "None"
    }

    override boolean booleanValue() {
        result = false
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override predicate isClass() { none() }

    override predicate notClass() { any() }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(Builtin::special("NoneType"))
    }

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
        node.(NameNode).getId() = "None" and context.appliesTo(node)
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

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // None isn't callable
        none()
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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

    override predicate instantiated(ControlFlowNode node, PointsToContext2 context) {
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

}

