import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.MRO
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins

/** A class representing modules */
abstract class ModuleObjectInternal extends ObjectInternal {
  /** Gets the source scope of this module, if it has one. */
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

  override predicate notTestableForEquality() { none() }

  override boolean booleanValue() { result = true }

  override ObjectInternal getClass() { result = ObjectInternal::moduleType() }

  override boolean isDescriptor() { result = false }

  pragma[noinline]
  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  pragma[noinline]
  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  pragma[noinline]
  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override predicate subscriptUnknown() { any() }

  /** Holds if this module is a `__init__.py` module. */
  predicate isInitModule() { any(PackageObjectInternal package).getInitModule() = this }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Modules aren't iterable */
  override ObjectInternal getIterNext() { none() }

  /**
   * Holds if this module "exports" name.
   * That is, does it define `name` in `__all__` or is
   * `__all__` not defined and `name` a global variable that does not start with "_"
   * This is the set of names imported by `from ... import *`.
   */
  predicate exports(string name) {
    not this.(ModuleObjectInternal).attribute("__all__", _, _) and
    this.hasAttribute(name) and
    not name.charAt(0) = "_"
    or
    py_exports(this.getSourceModule(), name)
  }

  /** Whether the complete set of names "exported" by this module can be accurately determined */
  abstract predicate hasCompleteExportInfo();

  override predicate isNotSubscriptedType() { any() }
}

/** A class representing built-in modules */
class BuiltinModuleObjectInternal extends ModuleObjectInternal, TBuiltinModuleObject {
  override Builtin getBuiltin() { this = TBuiltinModuleObject(result) }

  override string toString() { result = "Module " + this.getBuiltin().getName() }

  override string getName() { result = this.getBuiltin().getName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ClassDecl getClassDeclaration() { none() }

  override Module getSourceModule() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    value = ObjectInternal::fromBuiltin(this.getBuiltin().getMember(name)) and
    origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate hasCompleteExportInfo() { any() }
}

/** A class representing packages */
class PackageObjectInternal extends ModuleObjectInternal, TPackageObject {
  override Builtin getBuiltin() { none() }

  override string toString() { result = "Package " + this.getName() }

  /** Gets the folder for this package */
  Folder getFolder() { this = TPackageObject(result) }

  override string getName() { result = moduleNameFromFile(this.getFolder()) }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ClassDecl getClassDeclaration() { none() }

  override Module getSourceModule() { result.getFile() = this.getFolder().getFile("__init__.py") }

  /** Gets the init module of this package */
  PythonModuleObjectInternal getInitModule() { result = TPythonModule(this.getSourceModule()) }

  predicate hasNoInitModule() {
    exists(Folder f |
      f = this.getFolder() and
      not exists(f.getFile("__init__.py"))
    )
  }

  /** Gets the submodule `name` of this package */
  ModuleObjectInternal submodule(string name) {
    exists(string fullName, int lastDotIndex |
      fullName = result.getName() and
      lastDotIndex = max(fullName.indexOf(".")) and
      name = fullName.substring(lastDotIndex + 1, fullName.length()) and
      this.getName() = fullName.substring(0, lastDotIndex)
    )
  }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    this.getInitModule().attribute(name, value, origin)
    or
    exists(Module init |
      init = this.getSourceModule() and
      /* The variable shadowing the name of the child module is undefined at exit */
      ModuleAttributes::pointsToAtExit(init, name, ObjectInternal::undefined(), _) and
      not name = "__init__" and
      value = this.submodule(name) and
      origin = CfgOrigin::fromObject(value)
    )
    or
    this.hasNoInitModule() and
    exists(ModuleObjectInternal mod |
      mod = this.submodule(name) and
      value = mod
    |
      origin = CfgOrigin::fromObject(mod)
    )
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override ControlFlowNode getOrigin() {
    exists(Module package |
      package.isPackage() and
      package.getPath() = this.getFolder() and
      result = package.getEntryNode()
    )
  }

  /** Holds if this value has the attribute `name` */
  override predicate hasAttribute(string name) {
    this.getInitModule().hasAttribute(name)
    or
    exists(this.submodule(name))
  }

  override predicate hasCompleteExportInfo() {
    not exists(this.getInitModule())
    or
    this.getInitModule().hasCompleteExportInfo()
  }
}

/** A class representing Python modules */
class PythonModuleObjectInternal extends ModuleObjectInternal, TPythonModule {
  override Builtin getBuiltin() { none() }

  override string toString() { result = this.getSourceModule().toString() }

  override string getName() { result = this.getSourceModule().getName() }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) { none() }

  override ClassDecl getClassDeclaration() { none() }

  override Module getSourceModule() { this = TPythonModule(result) }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    value != ObjectInternal::undefined() and
    ModuleAttributes::pointsToAtExit(this.getSourceModule(), name, value, origin)
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override ControlFlowNode getOrigin() { result = this.getSourceModule().getEntryNode() }

  /** Holds if this value has the attribute `name` */
  override predicate hasAttribute(string name) {
    name = "__name__"
    or
    this.getSourceModule().(ImportTimeScope).definesName(name)
    or
    exists(ModuleObjectInternal mod, ImportStarNode imp |
      PointsToInternal::pointsTo(imp, _, mod, _) and
      imp.getScope() = this.getSourceModule() and
      mod.exports(name)
    )
    or
    exists(ObjectInternal defined |
      this.attribute(name, defined, _) and
      not defined instanceof UndefinedInternal
    )
  }

  override predicate hasCompleteExportInfo() {
    not exists(Call modify, Attribute attr, GlobalVariable all |
      modify.getScope() = this.getSourceModule() and
      modify.getFunc() = attr and
      all.getId() = "__all__"
    |
      attr.getObject().(Name).uses(all)
    )
  }
}

/** A class representing a module that is missing from the DB, but inferred to exists from imports. */
class AbsentModuleObjectInternal extends ModuleObjectInternal, TAbsentModule {
  override Builtin getBuiltin() { none() }

  override string toString() {
    if
      exists(Module m, SyntaxError se | se.getFile() = m.getFile() and m.getName() = this.getName())
    then result = "Unparsable module " + this.getName()
    else result = "Missing module " + this.getName()
  }

  override string getName() { this = TAbsentModule(result) }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    missing_imported_module(node, context, this.getName())
  }

  override ClassDecl getClassDeclaration() { none() }

  override Module getSourceModule() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) {
    value = TAbsentModuleAttribute(this, name) and origin = CfgOrigin::unknown()
  }

  pragma[noinline]
  override predicate attributesUnknown() { none() }

  override ControlFlowNode getOrigin() { none() }

  override predicate hasCompleteExportInfo() { none() }
}

/** A class representing an attribute of a missing module. */
class AbsentModuleAttributeObjectInternal extends ObjectInternal, TAbsentModuleAttribute {
  override Builtin getBuiltin() { none() }

  override string toString() {
    exists(ModuleObjectInternal mod, string name |
      this = TAbsentModuleAttribute(mod, name) and
      result = "Missing module attribute " + mod.getName() + "." + name
    )
  }

  override predicate introducedAt(ControlFlowNode node, PointsToContext context) {
    exists(ModuleObjectInternal mod, string name | this = TAbsentModuleAttribute(mod, name) |
      PointsToInternal::pointsTo(node.(AttrNode).getObject(name), context, mod, _)
      or
      PointsToInternal::pointsTo(node.(ImportMemberNode).getModule(name), context, mod, _)
    )
  }

  override ClassDecl getClassDeclaration() { none() }

  override int intValue() { none() }

  override string strValue() { none() }

  override predicate calleeAndOffset(Function scope, int paramOffset) { none() }

  pragma[noinline]
  override predicate attribute(string name, ObjectInternal value, CfgOrigin origin) { none() }

  pragma[noinline]
  override predicate attributesUnknown() { any() }

  override ControlFlowNode getOrigin() { none() }

  override predicate callResult(ObjectInternal obj, CfgOrigin origin) {
    obj = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
  }

  override predicate callResult(PointsToContext callee, ObjectInternal obj, CfgOrigin origin) {
    none()
  }

  override boolean isClass() { result = maybe() }

  override predicate notTestableForEquality() { any() }

  override boolean booleanValue() { result = maybe() }

  override ObjectInternal getClass() { result = ObjectInternal::unknownClass() }

  override boolean isDescriptor() { result = false }

  override predicate descriptorGetClass(ObjectInternal cls, ObjectInternal value, CfgOrigin origin) {
    none()
  }

  override predicate descriptorGetInstance(
    ObjectInternal instance, ObjectInternal value, CfgOrigin origin
  ) {
    none()
  }

  override predicate binds(ObjectInternal instance, string name, ObjectInternal descriptor) {
    none()
  }

  override int length() { none() }

  override predicate subscriptUnknown() { any() }

  /*
   * We know what this is called, but not its innate name.
   * However, if we are looking for things by name, this is a reasonable approximation
   */

  override string getName() { this = TAbsentModuleAttribute(_, result) }

  override predicate contextSensitiveCallee() { none() }

  override predicate useOriginAsLegacyObject() { none() }

  /* Modules aren't iterable */
  override ObjectInternal getIterNext() { none() }

  override predicate isNotSubscriptedType() { any() }
}
