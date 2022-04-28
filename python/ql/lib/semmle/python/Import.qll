import python
private import semmle.python.types.Builtins
private import semmle.python.internal.CachedStages

/**
 * An alias in an import statement, the `mod as name` part of `import mod as name`. May be artificial;
 * `import x` is transformed into `import x as x`
 */
class Alias extends Alias_ {
  Location getLocation() { result = this.getValue().getLocation() }
}

private predicate valid_module_name(string name) {
  exists(Module m | m.getName() = name)
  or
  exists(Builtin cmod | cmod.getClass() = Builtin::special("ModuleType") and cmod.getName() = name)
}

/** An artificial expression representing an import */
class ImportExpr extends ImportExpr_ {
  private string basePackageName(int n) {
    n = 1 and result = this.getEnclosingModule().getPackageName()
    or
    exists(string bpnm1 |
      bpnm1 = this.basePackageName(n - 1) and
      bpnm1.matches("%.%") and
      result = bpnm1.regexpReplaceAll("\\.[^.]*$", "")
    )
  }

  private predicate implicitRelativeImportsAllowed() {
    // relative imports are no longer allowed in Python 3
    major_version() < 3 and
    // and can be explicitly turned off in later versions of Python 2
    not this.getEnclosingModule().hasFromFuture("absolute_import")
  }

  /**
   * Gets the level of this import.
   *
   * The language specifies level as -1 if relative imports are to be tried first, 0 for absolute imports,
   * and level > 0 for explicit relative imports.
   */
  override int getLevel() {
    exists(int l | l = super.getLevel() |
      l > 0 and result = l
      or
      /* The extractor may set level to 0 even though relative imports apply */
      l = 0 and
      (if this.implicitRelativeImportsAllowed() then result = -1 else result = 0)
    )
  }

  /**
   * If this import is relative, and relative imports are allowed, compute
   * the name of the topmost module that will be imported.
   */
  private string relativeTopName() {
    this.getLevel() = -1 and
    result = this.basePackageName(1) + "." + this.getTopName() and
    valid_module_name(result)
  }

  private string qualifiedTopName() {
    if this.getLevel() <= 0
    then result = this.getTopName()
    else (
      result = this.basePackageName(this.getLevel()) and
      valid_module_name(result)
    )
  }

  /**
   * Gets the name by which the lowest level module or package is imported.
   * NOTE: This is the name that used to import the module,
   * which may not be the name of the module.
   */
  string bottomModuleName() {
    result = this.relativeTopName() + this.remainderOfName()
    or
    not exists(this.relativeTopName()) and
    result = this.qualifiedTopName() + this.remainderOfName()
  }

  /** Gets the name of topmost module or package being imported */
  string topModuleName() {
    result = this.relativeTopName()
    or
    not exists(this.relativeTopName()) and
    result = this.qualifiedTopName()
  }

  /**
   * Gets the full name of the module resulting from evaluating this import.
   * NOTE: This is the name that used to import the module,
   * which may not be the name of the module.
   */
  string getImportedModuleName() {
    exists(string bottomName | bottomName = this.bottomModuleName() |
      if this.isTop() then result = this.topModuleName() else result = bottomName
    )
  }

  /**
   * Gets the names of the modules that may be imported by this import.
   * For example this predicate would return 'x' and 'x.y' for `import x.y`
   */
  string getAnImportedModuleName() {
    result = this.bottomModuleName()
    or
    result = this.getAnImportedModuleName().regexpReplaceAll("\\.[^.]*$", "")
  }

  override Expr getASubExpression() { none() }

  override predicate hasSideEffects() { any() }

  private string getTopName() { result = this.getName().regexpReplaceAll("\\..*", "") }

  private string remainderOfName() {
    not exists(this.getName()) and result = ""
    or
    this.getLevel() <= 0 and result = this.getName().regexpReplaceAll("^[^\\.]*", "")
    or
    this.getLevel() > 0 and result = "." + this.getName()
  }

  /**
   * Whether this import is relative, that is not absolute.
   * See https://www.python.org/dev/peps/pep-0328/
   */
  predicate isRelative() {
    /* Implicit */
    exists(this.relativeTopName())
    or
    /* Explicit */
    this.getLevel() > 0
  }
}

/** A `from ... import ...` expression */
class ImportMember extends ImportMember_ {
  override Expr getASubExpression() { result = this.getModule() }

  override predicate hasSideEffects() {
    /* Strictly this only has side-effects if the module is a package */
    any()
  }

  /**
   * Gets the full name of the module resulting from evaluating this import.
   * NOTE: This is the name that used to import the module,
   * which may not be the name of the module.
   */
  string getImportedModuleName() {
    result = this.getModule().(ImportExpr).getImportedModuleName() + "." + this.getName()
  }

  override ImportMemberNode getAFlowNode() { result = super.getAFlowNode() }
}

/** An import statement */
class Import extends Import_ {
  /* syntax: import modname */
  private ImportExpr getAModuleExpr() {
    result = this.getAName().getValue()
    or
    result = this.getAName().getValue().(ImportMember).getModule()
  }

  /** Whether this a `from ... import ...` statement */
  predicate isFromImport() { this.getAName().getValue() instanceof ImportMember }

  override Expr getASubExpression() {
    result = this.getAModuleExpr() or
    result = this.getAName().getAsname() or
    result = this.getAName().getValue()
  }

  override Stmt getASubStatement() { none() }

  /**
   * Gets the name of an imported module.
   * For example, for the import statement `import bar` which
   * is a relative import in package "foo", this would return
   * "foo.bar".
   * The import statment `from foo import bar` would return
   * `foo` and `foo.bar`
   */
  string getAnImportedModuleName() {
    result = this.getAModuleExpr().getAnImportedModuleName()
    or
    exists(ImportMember m, string modname |
      m = this.getAName().getValue() and
      modname = m.getModule().(ImportExpr).getImportedModuleName()
    |
      result = modname
      or
      result = modname + "." + m.getName()
    )
  }
}

/** An import * statement */
class ImportStar extends ImportStar_ {
  /* syntax: from modname import * */
  cached
  ImportExpr getModuleExpr() {
    Stages::AST::ref() and
    result = this.getModule()
    or
    result = this.getModule().(ImportMember).getModule()
  }

  override string toString() { result = "from " + this.getModuleExpr().getName() + " import *" }

  override Expr getASubExpression() { result = this.getModule() }

  override Stmt getASubStatement() { none() }

  /** Gets the name of the imported module. */
  string getImportedModuleName() { result = this.getModuleExpr().getImportedModuleName() }
}

/**
 * A statement that imports a module. This can be any statement that includes the `import` keyword,
 * such as `import sys`, `from sys import version` or `from sys import *`.
 */
class ImportingStmt extends Stmt {
  ImportingStmt() {
    this instanceof Import
    or
    this instanceof ImportStar
  }

  /** Gets the name of an imported module. */
  string getAnImportedModuleName() {
    result = this.(Import).getAnImportedModuleName()
    or
    result = this.(ImportStar).getImportedModuleName()
  }
}
