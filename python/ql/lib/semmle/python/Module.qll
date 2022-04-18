import python
private import semmle.python.objects.ObjectAPI
private import semmle.python.objects.Modules
private import semmle.python.internal.CachedStages

/**
 * A module. This is the top level element in an AST, corresponding to a source file.
 * It is also a Scope; the scope of global variables.
 */
class Module extends Module_, Scope, AstNode {
  override string toString() {
    result = this.getKind() + " " + this.getName()
    or
    /* No name is defined, which means that this module is not on an import path. So it must be a script */
    not exists(this.getName()) and
    not this.isPackage() and
    result = "Script " + this.getFile().getShortName()
    or
    /* Package missing name, so just use the path instead */
    not exists(this.getName()) and
    this.isPackage() and
    result = "Package at " + this.getPath().getAbsolutePath()
  }

  /**
   * Gets the enclosing scope of this module (always none).
   *
   * This method will be deprecated in the next release. Please use `getEnclosingScope()` instead.
   */
  override Scope getScope() { none() }

  /** Gets the enclosing scope of this module (always none) */
  override Scope getEnclosingScope() { none() }

  /** Gets the statements forming the body of this module */
  override StmtList getBody() { result = Module_.super.getBody() }

  /** Gets the nth statement of this module */
  override Stmt getStmt(int n) { result = Module_.super.getStmt(n) }

  /** Gets a top-level statement in this module */
  override Stmt getAStmt() { result = Module_.super.getAStmt() }

  /** Gets the name of this module */
  override string getName() {
    result = Module_.super.getName() and legalDottedName(result)
    or
    not exists(Module_.super.getName()) and
    result = moduleNameFromFile(this.getPath())
  }

  /** Gets the short name of the module. For example the short name of module x.y.z is 'z' */
  string getShortName() {
    result = this.getName().suffix(this.getPackage().getName().length() + 1)
    or
    result = this.getName() and not exists(this.getPackage())
  }

  /** Gets this module */
  override Module getEnclosingModule() { result = this }

  /** Gets the __init__ module of this module if the module is a package and it has an __init__ module */
  Module getInitModule() {
    /* this.isPackage() and */ result.getName() = this.getName() + ".__init__"
  }

  /** Whether this module is a package initializer */
  predicate isPackageInit() { this.getName().matches("%\\_\\_init\\_\\_") and not this.isPackage() }

  /** Gets a name exported by this module, that is the names that will be added to a namespace by 'from this-module import *' */
  string getAnExport() {
    py_exports(this, result)
    or
    exists(ModuleObjectInternal mod | mod.getSource() = this.getEntryNode() |
      mod.(ModuleValue).exports(result)
    )
  }

  /** Gets the source file for this module */
  File getFile() { py_module_path(this, result) }

  /** Gets the source file or folder for this module or package */
  Container getPath() { py_module_path(this, result) }

  /** Whether this is a package */
  predicate isPackage() { this.getPath() instanceof Folder }

  /** Gets the package containing this module (or parent package if this is a package) */
  Module getPackage() {
    this.getName().matches("%.%") and
    result.getName() = this.getName().regexpReplaceAll("\\.[^.]*$", "")
  }

  /** Gets the name of the package containing this module */
  string getPackageName() {
    this.getName().matches("%.%") and
    result = this.getName().regexpReplaceAll("\\.[^.]*$", "")
  }

  /** Gets the metrics for this module */
  ModuleMetrics getMetrics() { result = this }

  string getAnImportedModuleName() {
    exists(Import i | i.getEnclosingModule() = this | result = i.getAnImportedModuleName())
    or
    exists(ImportStar i | i.getEnclosingModule() = this | result = i.getImportedModuleName())
  }

  override Location getLocation() {
    py_scope_location(result, this)
    or
    not py_scope_location(_, this) and
    locations_ast(result, this, 0, 0, 0, 0)
  }

  /** Gets a child module or package of this package */
  Module getSubModule(string name) {
    result.getPackage() = this and
    name = result.getName().regexpReplaceAll(".*\\.", "")
  }

  /** Whether name is declared in the __all__ list of this module */
  predicate declaredInAll(string name) {
    exists(AssignStmt a, GlobalVariable all |
      a.defines(all) and
      a.getScope() = this and
      all.getId() = "__all__" and
      (
        a.getValue().(List).getAnElt().(StrConst).getText() = name
        or
        a.getValue().(Tuple).getAnElt().(StrConst).getText() = name
      )
    )
  }

  override AstNode getAChildNode() { result = this.getAStmt() }

  predicate hasFromFuture(string attr) {
    exists(Import i, ImportMember im, ImportExpr ie, Alias a, Name name |
      im.getModule() = ie and
      ie.getName() = "__future__" and
      a.getAsname() = name and
      name.getId() = attr and
      i.getASubExpression() = im and
      i.getAName() = a and
      i.getEnclosingModule() = this
    )
  }

  /** Gets the path element from which this module was loaded. */
  Container getLoadPath() { result = this.getPath().getImportRoot() }

  /** Holds if this module is in the standard library for version `major.minor` */
  predicate inStdLib(int major, int minor) { this.getLoadPath().isStdLibRoot(major, minor) }

  /** Holds if this module is in the standard library */
  predicate inStdLib() { this.getLoadPath().isStdLibRoot() }

  override predicate containsInScope(AstNode inner) { Scope.super.containsInScope(inner) }

  override predicate contains(AstNode inner) { Scope.super.contains(inner) }

  /** Gets the kind of this module. */
  override string getKind() {
    if this.isPackage()
    then result = "Package"
    else (
      not exists(Module_.super.getKind()) and result = "Module"
      or
      result = Module_.super.getKind()
    )
  }
}

bindingset[name]
private predicate legalDottedName(string name) {
  name.regexpMatch("(\\p{L}|_)(\\p{L}|\\d|_)*(\\.(\\p{L}|_)(\\p{L}|\\d|_)*)*")
}

bindingset[name]
private predicate legalShortName(string name) { name.regexpMatch("(\\p{L}|_)(\\p{L}|\\d|_)*") }

/**
 * Holds if `f` is potentially a source package.
 * Does it have an __init__.py file (or --respect-init=False for Python 2) and is it within the source archive?
 */
private predicate isPotentialSourcePackage(Folder f) {
  f.getRelativePath() != "" and
  isPotentialPackage(f)
}

private predicate isPotentialPackage(Folder f) {
  exists(f.getFile("__init__.py"))
  or
  py_flags_versioned("options.respect_init", "False", _) and major_version() = 2 and exists(f)
}

private string moduleNameFromBase(Container file) {
  isPotentialPackage(file) and result = file.getBaseName()
  or
  file instanceof File and result = file.getStem()
}

/**
 * Holds if `file` may be transitively imported from a file that may serve as the entry point of
 * the execution.
 */
private predicate transitively_imported_from_entry_point(File file) {
  file.getExtension().matches("%py%") and
  exists(File importer |
    // Only consider files that are in the source archive
    exists(importer.getRelativePath()) and
    importer.getParent() = file.getParent() and
    exists(ImportExpr i |
      i.getLocation().getFile() = importer and
      i.getName() = file.getStem() and
      // Disregard relative imports
      i.getLevel() = 0
    )
  |
    importer.isPossibleEntryPoint() or transitively_imported_from_entry_point(importer)
  )
}

cached
string moduleNameFromFile(Container file) {
  Stages::AST::ref() and
  exists(string basename |
    basename = moduleNameFromBase(file) and
    legalShortName(basename)
  |
    result = moduleNameFromFile(file.getParent()) + "." + basename
    or
    // If `file` is a transitive import of a file that's executed directly, we allow references
    // to it by its `basename`.
    transitively_imported_from_entry_point(file) and
    result = basename
  )
  or
  isPotentialSourcePackage(file) and
  result = file.getStem() and
  (
    not isPotentialSourcePackage(file.getParent()) or
    not legalShortName(file.getParent().getBaseName())
  )
  or
  result = file.getStem() and file.getParent() = file.getImportRoot()
  or
  result = file.getStem() and isStubRoot(file.getParent())
}

private predicate isStubRoot(Folder f) {
  not f.getParent*().isImportRoot() and
  f.getAbsolutePath().matches("%/data/python/stubs")
}

/**
 * Holds if the Container `c` should be the preferred file or folder for
 * the given name when performing imports.
 * Trivially true for any container if it is the only one with its name.
 * However, if there are several modules with the same name, then
 * this is the module most likely to be imported under that name.
 */
predicate isPreferredModuleForName(Container c, string name) {
  exists(int p |
    p = min(int x | x = priorityForName(_, name)) and
    p = priorityForName(c, name)
  )
}

private int priorityForName(Container c, string name) {
  name = moduleNameFromFile(c) and
  (
    // In the source
    exists(c.getRelativePath()) and result = -1
    or
    // On an import path
    exists(c.getImportRoot(result))
    or
    // Otherwise
    result = 10000
  )
}
