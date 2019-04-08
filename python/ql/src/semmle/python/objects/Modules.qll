import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins

abstract class ModuleObjectInternal extends ObjectInternal {

    abstract string getName();

    abstract Module getSourceModule();

    override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
        // Modules aren't callable
        none()
    }

    override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
        // Modules aren't callable
        none()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }

    override boolean booleanValue() {
        result = true
    }

    override ObjectInternal getClass() {
        result = ObjectInternal::moduleType()
    }

    override boolean isDescriptor() { result = false }


    override predicate descriptorGet(ObjectInternal instance, ObjectInternal value, CfgOrigin origin) { none() }

    override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) { none() }
}

class BuiltinModuleObjectInternal extends ModuleObjectInternal, TBuiltinModuleObject {

    override Builtin getBuiltin() {
        this = TBuiltinModuleObject(result)
    }

    override string toString() {
        result = "Module " + this.getBuiltin().getName()
    }

    override string getName() {
        result = this.getBuiltin().getName()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override Module getSourceModule() {
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

    override ControlFlowNode getOrigin() {
        none()
    }

}

class PackageObjectInternal extends ModuleObjectInternal, TPackageObject {

    override Builtin getBuiltin() {
        none()
    }

    override string toString() {
        result = "Package " + this.getName()
    }

    Folder getFolder() {
        this = TPackageObject(result)
    }

    override string getName() {
        result = moduleNameFromFile(this.getFolder())
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override ClassDecl getClassDeclaration() {
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

    ModuleObjectInternal submodule(string name) {
        result.getName() = this.getName() + "." + name
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
        this.getInitModule().attribute(name, value, origin)
        or
        exists(Module init |
            init = this.getSourceModule() and
            (
                not exists(EssaVariable var | var.getAUse() = init.getANormalExit() and var.getSourceVariable().getName() = name)
                or
                ModuleAttributes::pointsToAtExit(init, name, ObjectInternal::undefined(), _)
            ) and
            value = this.submodule(name) and
            origin = CfgOrigin::fromObject(value)
        )
        or
        this.hasNoInitModule() and
        exists(ModuleObjectInternal mod |
            mod = this.submodule(name) and
            value = mod |
            origin = CfgOrigin::fromObject(mod)
        )
    }

    override predicate attributesUnknown() { none() }

    override ControlFlowNode getOrigin() {
        result = this.getSourceModule().getEntryNode()
    }

    override @py_object getSource() {
        exists(Module package |
            package.isPackage() and
            package.getPath() = this.getFolder() and
            result = package.getEntryNode()
        )
    }

}

/** Get the ESSA pseudo-variable used to retain module state
 * during module initialization. Module attributes are handled 
 * as attributes of this variable, allowing the SSA form to track 
 * mutations of the module during its creation.
 */
private predicate isModuleStateVariable(EssaVariable var) {
    var.getName() = "$" and var.getScope() instanceof Module
}

class PythonModuleObjectInternal extends ModuleObjectInternal, TPythonModule {

    override Builtin getBuiltin() {
        none()
    }

    override string toString() {
        result = this.getSourceModule().toString()
    }

    override string getName() {
        result = this.getSourceModule().getName()
    }

    override predicate introduced(ControlFlowNode node, PointsToContext context) {
        none()
    }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override Module getSourceModule() {
        this = TPythonModule(result)
    }

    PythonModuleObjectInternal getInitModule() {
        result = TPythonModule(this.getSourceModule())
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
        exists(EssaVariable var, ControlFlowNode exit, PointsToContext imp |
            exit = this.getSourceModule().getANormalExit() and var.getAUse() = exit and
            var.getSourceVariable().getName() = name and
            PointsTo::variablePointsTo(var, imp, value, origin) and
            imp.isImport() and
            value != ObjectInternal::undefined()
        )
        or
        ModuleAttributes::pointsToAtExit(this.getSourceModule(), name, value, origin)
    }

    override predicate attributesUnknown() { none() }

    override ControlFlowNode getOrigin() {
        result = this.getSourceModule().getEntryNode()
    }

}

