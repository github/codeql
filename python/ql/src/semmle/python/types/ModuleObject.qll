import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.Base
private import semmle.python.types.ModuleKind

abstract class ModuleObject extends Object {

    ModuleObject () {
        exists(Module m | m.getEntryNode() = this)
        or
        this.asBuiltin().getClass() = theModuleType().asBuiltin()
    }

    /** Gets the scope corresponding to this module, if this is a Python module */
    Module getModule() {
        none()
    }

    /** Gets the source scope corresponding to this module, if this is a Python module */
    Module getSourceModule() {
        none()
    }

    Container getPath() {
        none()
    }

    /** Gets the name of this scope */
    abstract string getName();

    override string toString() {
        result = "Module " + this.getName()
    }

    /** Gets the named attribute of this module. Using attributeRefersTo() instead
     * may provide better results for presentation.
     * */
    pragma [noinline]
    abstract Object getAttribute(string name);

    /** Gets the named attribute of this module.
     * Synonym for `getAttribute(name)` */
    pragma [inline]
    final Object attr(string name) {
        result = this.getAttribute(name)
    }

    /** Whether the named attribute of this module "refers-to" value, with a known origin.
     */
    abstract predicate attributeRefersTo(string name, Object value, ControlFlowNode origin);

    /** Whether the named attribute of this module "refers-to" value, with known class and a known origin.
     */
    abstract predicate attributeRefersTo(string name, Object value, ClassObject cls, ControlFlowNode origin);

    /** Gets the package for this module. */
    PackageObject getPackage() {
        this.getName().matches("%.%") and
        result.getName() = this.getName().regexpReplaceAll("\\.[^.]*$", "")
    }

    /** Whether this module "exports" `name`. That is, whether using `import *` on this module
     will result in `name` being added to the namespace. */
    predicate exports(string name) {
        PointsTo::module_exports(this, name)
    }
 
    /** Whether the complete set of names "exported" by this module can be accurately determined */
    abstract predicate exportsComplete();

    /** Gets the short name of the module. For example the short name of module x.y.z is 'z' */
    string getShortName() {
        result = this.getName().suffix(this.getPackage().getName().length()+1)
        or
        result = this.getName() and not exists(this.getPackage())
    }

    /** Whether this module is imported by 'import name'. For example on a linux system,
      * the module 'posixpath' is imported as 'os.path' or as 'posixpath' */
    predicate importedAs(string name) {
        PointsTo::module_imported_as(this, name)
    }

    abstract predicate hasAttribute(string name);

    ModuleObject getAnImportedModule() {
        result.importedAs(this.getModule().getAnImportedModuleName())
    }

    /** Gets the kind for this module. Will be one of
     * "module", "script" or "plugin".
     */
    string getKind() {
        result = getKindForModule(this)
    }

    override boolean booleanValue() {
        result = true
    }

}

class BuiltinModuleObject extends ModuleObject {

    BuiltinModuleObject () {
        this.asBuiltin().getClass() = theModuleType().asBuiltin()
    }

    override string getName() {
        result = this.asBuiltin().getName()
    }

    override Object getAttribute(string name) {
        result.asBuiltin() = this.asBuiltin().getMember(name)
    }

    override predicate hasAttribute(string name) {
        exists(this.asBuiltin().getMember(name))
    }

    override predicate attributeRefersTo(string name, Object value, ControlFlowNode origin) {
        none() 
    }

    override predicate attributeRefersTo(string name, Object value, ClassObject cls, ControlFlowNode origin) {
        none() 
    }

    override predicate exportsComplete() {
        any()
    }


}

class PythonModuleObject extends ModuleObject {

    PythonModuleObject() {
        exists(Module m | m.getEntryNode() = this |
            not m.isPackage()
        )
    }

    override string getName() {
        result = this.getModule().getName()
    }

    override Module getModule() {
        result = this.getOrigin()
    }

    override Module getSourceModule() {
        result = this.getOrigin()
    }

    override Container getPath() {
        result = this.getModule().getFile()
    }

    override Object getAttribute(string name) {
        this.attributeRefersTo(name, result, _, _)
    }

    override predicate exportsComplete() {
        exists(Module m |
            m = this.getModule() |
            not exists(Call modify, Attribute attr, GlobalVariable all | 
                modify.getScope() = m and modify.getFunc() = attr and 
                all.getId() = "__all__" |
                attr.getObject().(Name).uses(all)
            )
        )
    }

    override predicate hasAttribute(string name) {
        PointsTo::module_defines_name(this.getModule(), name)
        or
        this.attributeRefersTo(name, _, _, _)
        or
        /* The interpreter always adds the __name__ and __package__ attributes */
        name = "__name__" or name = "__package__"
    }

    override predicate attributeRefersTo(string name, Object value, ControlFlowNode origin) {
        exists(CfgOrigin orig |
            origin = orig.toCfgNode() and
            PointsTo::py_module_attributes(this.getModule(), name, value, _, orig)
        )
    }

    override predicate attributeRefersTo(string name, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(CfgOrigin orig |
            origin = orig.toCfgNode() and
            PointsTo::py_module_attributes(this.getModule(), name, value, cls, orig)
        )
    }

}

/**  Primarily for internal use.
 *
 * Gets the object for the string text. 
 * The extractor will have populated a str object 
 * for each module name, with the name b'text' or u'text' (including the quotes).
 */
Object object_for_string(string text) {
    result.asBuiltin().getClass() = theStrType().asBuiltin() and
    exists(string repr |
        repr = result.asBuiltin().getName() and
        repr.charAt(1) = "'" |
        /* Strip quotes off repr */
        text = repr.substring(2, repr.length()-1)
    )
}

class PackageObject extends ModuleObject {

    PackageObject() {
        exists(Module p | p.getEntryNode() = this |
            p.isPackage()
        )
    }

    override string getName() {
        result = this.getModule().getName()
    }

    override Module getModule() {
        result = this.getOrigin()
    }

    override Module getSourceModule() {
        result = this.getModule().getInitModule()
    }

    override Container getPath() {
        result = this.getModule().getPath()
    }

    ModuleObject submodule(string name) {
        result.getPackage() = this and
        name = result.getShortName()
    }

    override Object getAttribute(string name) {
        PointsTo::package_attribute_points_to(this, name, result, _, _)
    }

    PythonModuleObject getInitModule() {
        result.getModule() = this.getModule().getInitModule()
    }

    /** Holds if this package has no `__init__.py` file. */
    predicate hasNoInitModule() {
        not exists(Module m |
            m.isPackageInit() and
            m.getFile().getParent() = this.getPath()
        )
    }

    override predicate exportsComplete() {
        not exists(this.getInitModule())
        or
        this.getInitModule().exportsComplete()
    }

    override predicate hasAttribute(string name) {
        exists(this.submodule(name))
        or
        this.getInitModule().hasAttribute(name)
    }

    override predicate attributeRefersTo(string name, Object value, ControlFlowNode origin) {
        exists(CfgOrigin orig |
            origin = orig.toCfgNode() and
            PointsTo::package_attribute_points_to(this, name, value, _, orig)
        )
    }

    override predicate attributeRefersTo(string name, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(CfgOrigin orig |
            origin = orig.toCfgNode() and
            PointsTo::package_attribute_points_to(this, name, value, cls, orig)
        )
    }

    Location getLocation() {
        none()
    }

    override predicate hasLocationInfo(string path, int bl, int bc, int el, int ec) {
        path = this.getPath().getName() and
        bl = 0 and bc = 0 and el = 0 and ec = 0
    }

}

/** Utility module for predicates relevant to the `ModuleObject` class. */
module ModuleObject {

    /** Gets a `ModuleObject` called `name`, if it exists. */
    ModuleObject named(string name) {
        result.getName() = name
    }

}
