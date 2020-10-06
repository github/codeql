/**
 * Provides classes for working with
 * [Asynchronous Module Definitions](https://github.com/amdjs/amdjs-api/wiki/AMD).
 */

import javascript

/**
 * An AMD `define` call.
 *
 * Example:
 *
 * ```
 * define(['fs', 'express'], function(fs, express) {
 *   ...
 * });
 * ```
 *
 * The first argument is an (optional) array of dependencies,
 * the second a factory method or object.
 *
 * We also recognize the three-argument form `define('m', ['fs', 'express'], ...)`
 * where the first argument is the module name, the second argument an
 * array of dependencies, and the third argument a factory method or object.
 */
class AmdModuleDefinition extends CallExpr {
  AmdModuleDefinition() {
    getParent() instanceof ExprStmt and
    getCallee().(GlobalVarAccess).getName() = "define" and
    exists(int n | n = getNumArgument() |
      n = 1
      or
      n = 2 and getArgument(0) instanceof ArrayExpr
      or
      n = 3 and getArgument(0) instanceof ConstantString and getArgument(1) instanceof ArrayExpr
    )
  }

  /** Gets the array of module dependencies, if any. */
  ArrayExpr getDependencies() {
    result = getArgument(0) or
    result = getArgument(1)
  }

  /** Gets the `i`th dependency of this module definition. */
  PathExpr getDependency(int i) { result = getDependencies().getElement(i) }

  /** Gets a dependency of this module definition. */
  PathExpr getADependency() {
    result = getDependency(_) or
    result = getARequireCall().getAnArgument()
  }

  /**
   * Gets a data flow node containing the factory value of this module definition.
   */
  pragma[nomagic]
  DataFlow::SourceNode getFactoryNode() {
    result = getFactoryNodeInternal() and
    result instanceof DataFlow::ValueNode
  }

  private DataFlow::Node getFactoryNodeInternal() {
    // To avoid recursion, this should not depend on `SourceNode`.
    result = DataFlow::valueNode(getLastArgument()) or
    result = getFactoryNodeInternal().getAPredecessor()
  }

  /** Gets the expression defining this module. */
  Expr getModuleExpr() {
    exists(DataFlow::Node f | f = getFactoryNode() |
      if f instanceof DataFlow::FunctionNode
      then
        exists(ReturnStmt ret | ret.getContainer() = f.(DataFlow::FunctionNode).getAstNode() |
          result = ret.getExpr()
        )
      else result = f.asExpr()
    )
  }

  /** Gets a source node whose value becomes the definition of this module. */
  DataFlow::SourceNode getAModuleSource() { result.flowsToExpr(getModuleExpr()) }

  /**
   * Holds if `p` is the parameter corresponding to dependency `dep`.
   */
  predicate dependencyParameter(PathExpr dep, Parameter p) {
    exists(int i |
      dep = getDependency(i) and
      p = getFactoryParameter(i)
    )
  }

  /**
   * Gets the parameter corresponding to dependency `name`.
   *
   * For instance, in the module definition
   *
   * ```
   * define(['dep1', 'dep2'], function(pdep1, pdep2) { ... })
   * ```
   *
   * parameters `pdep1` and `pdep2` correspond to dependencies
   * `dep1` and `dep2`.
   */
  Parameter getDependencyParameter(string name) {
    exists(PathExpr dep |
      dependencyParameter(dep, result) and
      dep.getValue() = name
    )
  }

  /**
   * Gets the `i`th parameter of the factory function of this module.
   */
  private Parameter getFactoryParameter(int i) {
    getFactoryNodeInternal().asExpr().(Function).getParameter(i) = result
  }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `require`.
   */
  Parameter getRequireParameter() {
    result = getDependencyParameter("require")
    or
    // if no dependencies are listed, the first parameter is assumed to be `require`
    not exists(getDependencies()) and result = getFactoryParameter(0)
  }

  pragma[noinline]
  private Variable getRequireVariable() { result = getRequireParameter().getVariable() }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `exports`.
   */
  Parameter getExportsParameter() {
    result = getDependencyParameter("exports")
    or
    // if no dependencies are listed, the second parameter is assumed to be `exports`
    not exists(getDependencies()) and result = getFactoryParameter(1)
  }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `module`.
   */
  Parameter getModuleParameter() {
    result = getDependencyParameter("module")
    or
    // if no dependencies are listed, the third parameter is assumed to be `module`
    not exists(getDependencies()) and result = getFactoryParameter(2)
  }

  /**
   * Gets an abstract value representing one or more values that may flow
   * into this module's `module.exports` property.
   */
  DefiniteAbstractValue getAModuleExportsValue() {
    // implicit exports: anything that is returned from the factory function
    result = getModuleExpr().analyze().getAValue()
    or
    // explicit exports: anything assigned to `module.exports`
    exists(AbstractProperty moduleExports, AmdModule m |
      this = m.getDefine() and
      moduleExports.getBase().(AbstractModuleObject).getModule() = m and
      moduleExports.getPropertyName() = "exports"
    |
      result = moduleExports.getAValue()
    )
  }

  /**
   * Gets a call to `require` inside this module.
   */
  CallExpr getARequireCall() {
    result.getCallee().getUnderlyingValue() = getRequireVariable().getAnAccess()
  }
}

/**
 * DEPRECATED: Use `AmdModuleDefinition` instead.
 */
deprecated class AMDModuleDefinition = AmdModuleDefinition;

/** An AMD dependency, considered as a path expression. */
private class AmdDependencyPath extends PathExprCandidate {
  AmdDependencyPath() {
    exists(AmdModuleDefinition amd |
      this = amd.getDependencies().getAnElement() or
      this = amd.getARequireCall().getAnArgument()
    )
  }
}

/** A constant path element appearing in an AMD dependency expression. */
private class ConstantAmdDependencyPathElement extends PathExpr, ConstantString {
  ConstantAmdDependencyPathElement() { this = any(AmdDependencyPath amd).getAPart() }

  override string getValue() { result = getStringValue() }
}

/**
 * Holds if `def` is an AMD module definition in `tl` which is not
 * nested inside another module definition.
 */
private predicate amdModuleTopLevel(AmdModuleDefinition def, TopLevel tl) {
  def.getTopLevel() = tl and
  not def.getParent+() instanceof AmdModuleDefinition
}

/**
 * An AMD dependency, viewed as an import.
 */
private class AmdDependencyImport extends Import {
  AmdDependencyImport() { this = any(AmdModuleDefinition def).getADependency() }

  override Module getEnclosingModule() { this = result.(AmdModule).getDefine().getADependency() }

  override PathExpr getImportedPath() { result = this }

  /**
   * Gets a file that looks like it might be the target of this import.
   *
   * Specifically, we look for files whose absolute path ends with the imported path, possibly
   * adding well-known JavaScript file extensions like `.js`.
   */
  private File guessTarget() {
    exists(PathString imported, string abspath, string dirname, string basename |
      targetCandidate(result, abspath, imported, dirname, basename)
    |
      abspath.regexpMatch(".*/\\Q" + imported + "\\E")
      or
      exists(Folder dir |
        // `dir` ends with the dirname of the imported path
        dir.getAbsolutePath().regexpMatch(".*/\\Q" + dirname + "\\E") or
        dirname = ""
      |
        result = dir.getJavaScriptFile(basename)
      )
    )
  }

  /**
   * Holds if `f` is a file whose stem (that is, basename without extension) matches the imported path.
   *
   * Additionally, `abspath` is bound to the absolute path of `f`, `imported` to the imported path, and
   * `dirname` and `basename` to the dirname and basename (respectively) of `imported`.
   */
  private predicate targetCandidate(
    File f, string abspath, PathString imported, string dirname, string basename
  ) {
    imported = getImportedPath().getValue() and
    f.getStem() = imported.getStem() and
    f.getAbsolutePath() = abspath and
    dirname = imported.getDirName() and
    basename = imported.getBaseName()
  }

  /**
   * Gets the module whose absolute path matches this import, if there is only a single such module.
   */
  private Module resolveByAbsolutePath() {
    result.getFile() = unique(File file | file = guessTarget())
  }

  override Module getImportedModule() {
    result = super.getImportedModule()
    or
    not exists(super.getImportedModule()) and
    result = resolveByAbsolutePath()
  }

  override DataFlow::Node getImportedModuleNode() {
    exists(Parameter param |
      any(AmdModuleDefinition def).dependencyParameter(this, param) and
      result = DataFlow::parameterNode(param)
    )
  }
}

/**
 * An AMD-style module.
 *
 * Example:
 *
 * ```
 * define(['fs', 'express'], function(fs, express) {
 *   ...
 * });
 * ```
 */
class AmdModule extends Module {
  cached
  AmdModule() { exists(unique(AmdModuleDefinition def | amdModuleTopLevel(def, this))) }

  /** Gets the definition of this module. */
  AmdModuleDefinition getDefine() { amdModuleTopLevel(result, this) }

  override DataFlow::Node getAnExportedValue(string name) {
    exists(DataFlow::PropWrite pwn | result = pwn.getRhs() |
      pwn.getBase().analyze().getAValue() = getDefine().getAModuleExportsValue() and
      name = pwn.getPropertyName()
    )
  }
}

/**
 * DEPRECATED: Use `AmdModule` instead.
 */
deprecated class AMDModule = AmdModule;
