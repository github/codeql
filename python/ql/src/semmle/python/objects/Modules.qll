import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.MRO2
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

    override ControlFlowNode getOrigin() {
        result = this.getSourceModule().getEntryNode()
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
        // TO DO, dollar variable...
        //exists(Module init |
        //    init = this.getSourceModule() and
        //    not exists(EssaVariable var | var.getAUse() = init.getANormalExit() and var.getSourceVariable().getName() = name) and
        //    exists(EssaVariable var, Context context |
        //        isModuleStateVariable(var) and var.getAUse() = init.getANormalExit() and
        //        context.isImport() and
        //        SSA::ssa_variable_named_attribute_pointsTo(var, context, name, undefinedVariable(), _, origin) and
        //        value = this.submodule(name)
        //    )
        //)
        //or
        this.hasNoInitModule() and
        exists(ModuleObjectInternal mod |
            mod = this.submodule(name) and
            value = mod |
            origin = CfgOrigin::fromModule(mod)
        )
    }

    override predicate attributesUnknown() { none() }

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
            PointsTo2::ssa_variable_pointsTo(var, imp, value, origin) and
            imp.isImport() and
            value != ObjectInternal::undefined()
        )
        // TO DO, dollar variable...
        //or
        //not exists(EssaVariable var | var.getAUse() = m.getANormalExit() and var.getSourceVariable().getName() = name) and
        //exists(EssaVariable var, PointsToContext imp |
        //    var.getAUse() = m.getANormalExit() and isModuleStateVariable(var) |
        //    PointsTo2::ssa_variable_named_attribute_pointsTo(var, imp, name, obj, origin) and
        //    imp.isImport() and obj != ObjectInternal::undefined()
        //)
    }

    override predicate attributesUnknown() { none() }

}

