import python
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
        a.getValue().(List).getAnElt().(StringLiteral).getText() = name
        or
        a.getValue().(Tuple).getAnElt().(StringLiteral).getText() = name
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
predicate legalShortName(string name) { name.regexpMatch("(\\p{L}|_)(\\p{L}|\\d|_)*") }

private string moduleNameFromBase(Container file) {
  // We used to also require `isPotentialPackage(f)` to hold in this case,
  // but we saw modules not getting resolved because their folder did not
  // contain an `__init__.py` file.
  //
  // This makes the folder not be a package but a namespace package instead.
  // In most cases this is a mistake :| See following links for more details
  // - https://dev.to/methane/don-t-omit-init-py-3hga
  // - https://packaging.python.org/en/latest/guides/packaging-namespace-packages/
  // - https://discuss.python.org/t/init-py-pep-420-and-iter-modules-confusion/9642
  //
  // It is possible that we can keep the original requirement on
  // `isPotentialPackage(f)` here, but relax `isPotentialPackage` itself to allow
  // for this behavior of missing `__init__.py` files. However, doing so involves
  // cascading changes (for example to `moduleNameFromFile`), and was a more involved
  // task than we wanted to take on.
  result = file.getBaseName()
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

/**
 * Holds if the folder `f` is a regular Python package,
 * containing an `__init__.py` file.
 */
private predicate isRegularPackage(Folder f, string name) {
  legalShortName(name) and
  name = f.getStem() and
  exists(f.getFile("__init__.py"))
}

/** Gets the name of a module imported in package `c`. */
private string moduleImportedInPackage(Container c) {
  legalShortName(result) and
  // it has to be imported in this folder
  result =
    any(ImportExpr i | i.getLocation().getFile().getParent() = c)
        .getName()
        // strip everything after the first `.`
        .regexpReplaceAll("\\..*", "") and
  result != ""
}

/** Holds if the file `f` could be resolved to a module named `name`. */
private predicate isPotentialModuleFile(File file, string name) {
  legalShortName(name) and
  name = file.getStem() and
  file.getExtension() = ["py", "pyc", "so", "pyd"] and
  // it has to be imported in this folder
  name = moduleImportedInPackage(file.getParent())
}

/**
 * Holds if the folder `f` is a namespace package named `name`.
 *
 * See https://peps.python.org/pep-0420/#specification
 * for details on namespace packages.
 */
private predicate isNameSpacePackage(Folder f, string name) {
  legalShortName(name) and
  name = f.getStem() and
  not isRegularPackage(f, name) and
  // it has to be imported in a file
  // either in this folder or next to this folder
  name = moduleImportedInPackage([f, f.getParent()]) and
  // no sibling regular package
  // and no sibling module
  not exists(Folder sibling | sibling.getParent() = f.getParent() |
    isRegularPackage(sibling.getFolder(name), name)
    or
    isPotentialModuleFile(sibling.getAFile(), name)
  )
}

/**
 * Holds if the folder `f` is a package (either a regular package
 * or a namespace package) named `name`.
 */
private predicate isPackage(Folder f, string name) {
  isRegularPackage(f, name)
  or
  isNameSpacePackage(f, name)
}

/**
 * Holds if the file `f` is a module named `name`.
 */
private predicate isModuleFile(File file, string name) {
  isPotentialModuleFile(file, name) and
  not isPackage(file.getParent(), _)
}

/**
 * Holds if the folder `f` is a package named `name`
 * and does reside inside another package.
 */
private predicate isOutermostPackage(Folder f, string name) {
  isPackage(f, name) and
  not isPackage(f.getParent(), _)
}

/** Gets the name of the module that `c` resolves to, if any. */
cached
string moduleNameFromFile(Container c) {
  // package
  isOutermostPackage(c, result)
  or
  // module
  isModuleFile(c, result)
  or
  Stages::AST::ref() and
  exists(string basename |
    basename = moduleNameFromBase(c) and
    legalShortName(basename)
  |
    // recursive case
    result = moduleNameFromFile(c.getParent()) + "." + basename
    or
    // If `file` is a transitive import of a file that's executed directly, we allow references
    // to it by its `basename`.
    transitively_imported_from_entry_point(c) and
    result = basename
  )
  or
  //
  // standard library
  result = c.getStem() and c.getParent() = c.getImportRoot()
  or
  result = c.getStem() and isStubRoot(c.getParent())
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
