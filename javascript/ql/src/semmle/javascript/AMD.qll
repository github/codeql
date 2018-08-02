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
 * define(['a', 'b'], function(a, b) {
 *   ...
 * });
 * ```
 *
 * The first argument is an (optional) array of dependencies,
 * the second a factory method or object.
 *
 * We also recognize the three-argument form `define('m', ['a', 'b'], ...)`
 * where the first argument is the module name, the second argument an
 * array of dependencies, and the third argument a factory method or object.
 */
class AMDModuleDefinition extends CallExpr {
  AMDModuleDefinition() {
    getParent() instanceof ExprStmt and
    getCallee().(GlobalVarAccess).getName() = "define" and
    exists (int n | n = getNumArgument() |
      n = 1 or
      n = 2 and getArgument(0) instanceof ArrayExpr or
      n = 3 and getArgument(0) instanceof ConstantString and getArgument(1) instanceof ArrayExpr
    )
  }

  /** Gets the array of module dependencies, if any. */
  ArrayExpr getDependencies() {
    result = getArgument(0) or
    result = getArgument(1)
  }

  /** Gets the `i`th dependency of this module definition. */
  PathExpr getDependency(int i) {
    result = getDependencies().getElement(i)
  }

  /** Gets a dependency of this module definition. */
  PathExpr getADependency() {
    result = getDependency(_) or
    result = getARequireCall().getAnArgument()
  }

  /**
   * DEPRECATED: Use `getFactoryNode` instead.
   *
   * Gets the factory expression of this module definition,
   * which may be a function or a literal.
   */
  deprecated
  Expr getFactoryExpr() {
    result = getFactoryNode().asExpr()
  }

  /**
   * Gets a data flow node containing the factory value of this module definition.
   */
  pragma[nomagic]
  DataFlow::SourceNode getFactoryNode() {
    result.flowsToExpr(getLastArgument()) and
    result instanceof DataFlow::ValueNode
  }

  /** Gets the expression defining this module. */
  Expr getModuleExpr() {
    exists (DataFlow::Node f | f = getFactoryNode() |
      if f instanceof DataFlow::FunctionNode then
        exists (ReturnStmt ret | ret.getContainer() = f.(DataFlow::FunctionNode).getAstNode() |
          result = ret.getExpr()
        )
      else
        result = f.asExpr()
    )
  }

  /**
   * Holds if `p` is the parameter corresponding to dependency `dep`.
   */
  predicate dependencyParameter(PathExpr dep, Parameter p) {
    exists (int i |
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
  private SimpleParameter getDependencyParameter(string name) {
    exists (PathExpr dep |
      dependencyParameter(dep, result) and
      dep.getValue() = name
    )
  }

  /**
   * Gets the `i`th parameter of the factory function of this module.
   */
  private SimpleParameter getFactoryParameter(int i) {
    getFactoryNode().(DataFlow::FunctionNode).getParameter(i) = DataFlow::parameterNode(result)
  }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `require`.
   */
  SimpleParameter getRequireParameter() {
    result = getDependencyParameter("require") or
    // if no dependencies are listed, the first parameter is assumed to be `require`
    not exists(getDependencies()) and result = getFactoryParameter(0)
  }

  pragma[noinline]
  private Variable getRequireVariable() {
    result = getRequireParameter().getVariable()
  }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `exports`.
   */
  SimpleParameter getExportsParameter() {
    result = getDependencyParameter("exports") or
    // if no dependencies are listed, the second parameter is assumed to be `exports`
    not exists(getDependencies()) and result = getFactoryParameter(1)
  }

  /**
   * Gets the parameter corresponding to the pseudo-dependency `module`.
   */
  SimpleParameter getModuleParameter() {
    result = getDependencyParameter("module") or
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
    exists (AbstractProperty moduleExports, AMDModule m |
      this = m.getDefine() and
      moduleExports.getBase().(AbstractModuleObject).getModule() = m and
      moduleExports.getPropertyName() = "exports" |
      result = moduleExports.getAValue()
    )
  }

  /**
   * Gets a call to `require` inside this module.
   */
  CallExpr getARequireCall() {
    result.getCallee().stripParens() = getRequireVariable().getAnAccess()
  }
}

/** A path expression appearing in the list of dependencies of an AMD module. */
private class AMDDependencyPath extends PathExprInModule, ConstantString {
  AMDDependencyPath() {
    exists (AMDModuleDefinition amd | this.getParentExpr*() = amd.getDependencies().getAnElement())
  }

  override string getValue() { result = this.(ConstantString).getStringValue() }
}

/** A path expression appearing in a `require` call in an AMD module. */
private class AMDRequirePath extends PathExprInModule, ConstantString {
  AMDRequirePath() {
    exists (AMDModuleDefinition amd | this.getParentExpr*() = amd.getARequireCall().getAnArgument())
  }

  override string getValue() { result = this.(ConstantString).getStringValue() }
}

/**
 * Holds if `def` is an AMD module definition in `tl` which is not
 * nested inside another module definition.
 */
private predicate amdModuleTopLevel(AMDModuleDefinition def, TopLevel tl) {
  def.getTopLevel() = tl and
  not def.getParent+() instanceof AMDModuleDefinition
}

/**
 * An AMD-style module.
 */
class AMDModule extends Module {
  AMDModule() {
    strictcount (AMDModuleDefinition def | amdModuleTopLevel(def, this)) = 1
  }

  /** Gets the definition of this module. */
  AMDModuleDefinition getDefine() {
    amdModuleTopLevel(result, this)
  }

  override Module getAnImportedModule() {
    result.getFile() = resolve(getDefine().getADependency())
  }

  override predicate exports(string name, ASTNode export) {
    exists (DataFlow::PropWrite pwn | export = pwn.getAstNode() |
      pwn.getBase().analyze().getAValue() = getDefine().getAModuleExportsValue() and
      name = pwn.getPropertyName()
    )
  }
}
