import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext2
private import semmle.python.types.Builtins

abstract class ModuleObjectInternal extends ObjectInternal {

    abstract string getName();

    abstract Module getSourceModule();

    override predicate callResult(PointsToContext2 callee, ObjectInternal obj, CfgOrigin origin) {
        // Modules aren't callable
        none()
    }

    override ControlFlowNode getOrigin() {
        result = this.getSourceModule().getEntryNode()
    }

    override boolean isClass() { result = false }

    override boolean isComparable() { result = true }

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

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
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

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
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

    override predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        this.getOrigin().getLocation().hasLocationInfo(fp, bl, bc, el, ec)
        or
        this.hasNoInitModule() and fp = this.getFolder().getAbsolutePath() and
        bl = 0 and bc = 0 and el = 0 and ec = 0
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

    override predicate introduced(ControlFlowNode node, PointsToContext2 context) {
        none()
    }

    override boolean booleanValue() {
        result = true
    }

    override predicate maybe() { none() }

    override ClassDecl getClassDeclaration() {
        none()
    }

    override ObjectInternal getClass() {
        result = TBuiltinClassObject(this.getBuiltin().getClass())
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

}

