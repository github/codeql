/** Provides classes for working with Node.js modules. */

import javascript
private import NodeModuleResolutionImpl
private import semmle.javascript.DynamicPropertyAccess as DynamicPropertyAccess
private import semmle.javascript.internal.CachedStages
private import semmle.javascript.dataflow.internal.DataFlowNode

/**
 * A Node.js module.
 *
 * Example:
 *
 * ```
 * const fs = require('fs');
 * for (var i=2;i<process.argv.length; ++i)
 *   process.stdout.write(fs.readFileSync(process.argv[i], 'utf8'));
 * ```
 */
class NodeModule extends Module {
  NodeModule() {
    is_module(this) and
    is_nodejs(this)
  }

  /** Gets the `module` variable of this module. */
  Variable getModuleVariable() { result = this.getScope().getVariable("module") }

  /** Gets the `exports` variable of this module. */
  Variable getExportsVariable() { result = this.getScope().getVariable("exports") }

  /** Gets the scope induced by this module. */
  override ModuleScope getScope() { result.getScopeElement() = this }

  /**
   * Gets an abstract value representing one or more values that may flow
   * into this module's `module.exports` property.
   */
  pragma[noinline]
  deprecated DefiniteAbstractValue getAModuleExportsValue() { none() }

  /**
   * Gets the `SourceNode` corresponding to the value of `module`.
   */
  private DataFlow::SourceNode getModuleSourceNode() {
    result = DataFlow::ssaDefinitionNode(Ssa::implicitInit(this.getModuleVariable()))
  }

  /**
   * Gets a `SourceNode` corresponding to the initial value of `module.exports` or
   * anything assigned to `module.exports`.
   */
  private DataFlow::SourceNode getExportsSourceNode() {
    result = DataFlow::ssaDefinitionNode(Ssa::implicitInit(this.getExportsVariable()))
    or
    result = this.getModuleSourceNode().getAPropertyWrite("exports").getRhs().getALocalSource()
    or
    result = this.getModuleSourceNode().getAPropertyRead("exports")
  }

  /**
   * Gets an expression that is an alias for `module.exports`.
   * For performance this predicate only computes relevant expressions (in `getAModuleExportsCandidate`).
   * So if using this predicate - consider expanding the list of relevant expressions.
   */
  deprecated DataFlow::AnalyzedNode getAModuleExportsNode() {
    result = this.getExportsSourceNode().getALocalUse()
  }

  /** Gets a symbol exported by this module. */
  override string getAnExportedSymbol() {
    result = super.getAnExportedSymbol()
    or
    result = this.getAnImplicitlyExportedSymbol()
    or
    // getters and the like.
    result = this.getExportsSourceNode().getAPropertyWrite().getPropertyName()
  }

  override DataFlow::Node getAnExportedValue(string name) {
    // a property write whose base is `exports` or `module.exports`
    result = this.getExportsSourceNode().getAPropertyWrite(name).getRhs()
    or
    // a re-export using spread-operator. E.g. `const foo = require("./foo"); module.exports = {bar: bar, ...foo};`
    exists(ObjectExpr obj | obj = this.getExportsSourceNode().asExpr() |
      result =
        obj.getAProperty()
            .(SpreadProperty)
            .getInit()
            .(SpreadElement)
            .getOperand()
            .flow()
            .getALocalSource()
            .asExpr()
            .(Import)
            .getImportedModule()
            .getAnExportedValue(name)
    )
    or
    // var imp = require('./imp');
    // for (var name in imp){
    //   module.exports[name] = imp[name];
    // }
    exists(DynamicPropertyAccess::EnumeratedPropName read, Import imp, DataFlow::PropWrite write |
      read.getSourceObject().getALocalSource().asExpr() = imp and
      write = this.getExportsSourceNode().getAPropertyWrite() and
      getASourceProp(read) = write.getRhs() and
      write.getPropertyNameExpr().flow().getImmediatePredecessor*() = read and
      result = imp.getImportedModule().getAnExportedValue(name)
    )
    or
    // an externs definition (where appropriate)
    exists(PropAccess pacc | result = DataFlow::valueNode(pacc) |
      pacc = this.getExportsSourceNode().getAPropertyRead(name).asExpr() and
      this.isExterns() and
      exists(pacc.getDocumentation())
    )
  }

  override DataFlow::Node getABulkExportedNode() {
    Stages::Imports::ref() and
    exists(DataFlow::PropWrite write |
      write.getBase().asExpr() = this.getModuleVariable().getAnAccess() and
      write.getPropertyName() = "exports" and
      result = write.getRhs()
    )
  }

  /** Gets a symbol that the module object inherits from its prototypes. */
  private string getAnImplicitlyExportedSymbol() {
    exists(ExternalConstructor ec | ec = this.getPrototypeOfExportedExpr() |
      result = ec.getAMember().getName()
      or
      ec instanceof FunctionExternal and result = "prototype"
      or
      ec instanceof ArrayExternal and
      exists(NumberLiteral nl | result = nl.getValue() and exists(result.toInt()))
    )
  }

  /** Gets an externs declaration of the prototype object of a value exported by this module. */
  private ExternalConstructor getPrototypeOfExportedExpr() {
    exists(AbstractValue exported | exported = this.getAModuleExportsValue() |
      result instanceof ObjectExternal
      or
      exported instanceof AbstractFunction and result instanceof FunctionExternal
      or
      exported instanceof AbstractOtherObject and result instanceof ArrayExternal
    )
  }

  deprecated override predicate searchRoot(PathExpr path, Folder searchRoot, int priority) {
    path.getEnclosingModule() = this and
    exists(string pathval | pathval = path.getValue() |
      // paths starting with `./` or `../` are resolved relative to the importing
      // module's folder
      pathval.regexpMatch("\\.\\.?(/.*)?") and
      (searchRoot = this.getFile().getParentContainer() and priority = 0)
      or
      // paths starting with `/` are resolved relative to the file system root
      pathval.matches("/%") and
      (searchRoot.getBaseName() = "" and priority = 0)
      or
      // paths that do not start with `./`, `../` or `/` are resolved relative
      // to `node_modules` folders
      not pathval.regexpMatch("\\.\\.?(/.*)?|/.*") and
      findNodeModulesFolder(this.getFile().getParentContainer(), searchRoot, priority)
    )
  }
}

// An copy of `DynamicPropertyAccess::EnumeratedPropName::getASourceProp` that doesn't use the callgraph.
// This avoids making the module-imports recursive with the callgraph.
private DataFlow::SourceNode getASourceProp(DynamicPropertyAccess::EnumeratedPropName prop) {
  exists(DataFlow::Node base, DataFlow::Node key |
    exists(DynamicPropertyAccess::DynamicPropRead read |
      not read.hasDominatingAssignment() and
      base = read.getBase() and
      key = read.getPropertyNameNode() and
      result = read
    ) and
    prop.getASourceObjectRef().flowsTo(base) and
    key.getImmediatePredecessor*() = prop
  )
}

/**
 * Gets an expression that syntactically could be a alias for `module.exports`.
 * This predicate exists to reduce the size of `getAModuleExportsNode`,
 * while keeping all the tuples that could be relevant in later computations.
 */
pragma[noinline]
private DataFlow::Node getAModuleExportsCandidate() {
  // A bit of manual magic
  result = any(DataFlow::PropWrite w).getBase()
  or
  result = DataFlow::valueNode(any(PropAccess p | exists(p.getPropertyName())).getBase())
  or
  result = DataFlow::valueNode(any(ObjectExpr obj))
}

/**
 * Holds if `nodeModules` is a folder of the form `<prefix>/node_modules`, where
 * `<prefix>` is a (not necessarily proper) prefix of `f` and does not end in `/node_modules`,
 * and `distance` is the number of path elements of `f` that are missing from `<prefix>`.
 *
 * This predicate implements the `NODE_MODULES_PATHS` procedure from the
 * [specification of `require.resolve`](https://nodejs.org/api/modules.html#modules_all_together).
 *
 * For example, if `f` is `/a/node_modules/b`, we get the following results:
 *
 * <table border="1">
 * <tr><th><code>nodeModules</code></th><th><code>distance</code></th></tr>
 * <tr><td><code>/a/node_modules/b/node_modules</code></td><td>0</td></tr>
 * <tr><td><code>/a/node_modules</code></td><td>2</td></tr>
 * <tr><td><code>/node_modules</code></td><td>3</td></tr>
 * </table>
 */
predicate findNodeModulesFolder(Folder f, Folder nodeModules, int distance) {
  nodeModules = f.getFolder("node_modules") and
  not f.getBaseName() = "node_modules" and
  distance = 0
  or
  findNodeModulesFolder(f.getParentContainer(), nodeModules, distance - 1)
}

/**
 * A Node.js `require` variable.
 */
private class RequireVariable extends Variable {
  RequireVariable() {
    this = any(ModuleScope m).getVariable("require")
    or
    // cover cases where we failed to detect Node.js code
    this.(GlobalVariable).getName() = "require"
    or
    // track through assignments to other variables
    this.getAnAssignedExpr().(VarAccess).getVariable() instanceof RequireVariable
  }
}

private predicate isModuleModule(EarlyStageNode nd) {
  exists(ImportDeclaration imp | imp.getRawImportPath() = "module" |
    nd = TDestructuredModuleImportNode(imp)
    or
    nd = TValueNode(imp.getASpecifier().(ImportNamespaceSpecifier))
  )
  or
  exists(EarlyStageNode other |
    isModuleModule(other) and
    DataFlow::localFlowStep(other, nd)
  )
}

private predicate isCreateRequire(EarlyStageNode nd) {
  exists(PropAccess prop |
    isModuleModule(TValueNode(prop.getBase())) and
    prop.getPropertyName() = "createRequire" and
    nd = TValueNode(prop)
  )
  or
  exists(PropertyPattern prop |
    isModuleModule(TValueNode(prop.getObjectPattern())) and
    prop.getName() = "createRequire" and
    nd = TValueNode(prop.getValuePattern())
  )
  or
  exists(ImportDeclaration decl, NamedImportSpecifier spec |
    decl.getRawImportPath() = "module" and
    spec = decl.getASpecifier() and
    spec.getImportedName() = "createRequire" and
    nd = TValueNode(spec)
  )
  or
  exists(EarlyStageNode other |
    isCreateRequire(other) and
    DataFlow::localFlowStep(other, nd)
  )
}

/**
 * Holds if `nd` may refer to `require`, either directly or modulo local data flow.
 */
cached
private predicate isRequire(EarlyStageNode nd) {
  exists(VarAccess access |
    access = any(RequireVariable v).getAnAccess() and
    nd = TValueNode(access) and
    // `mjs` files explicitly disallow `require`
    not access.getFile().getExtension() = "mjs"
  )
  or
  exists(EarlyStageNode other |
    isRequire(other) and
    DataFlow::localFlowStep(other, nd)
  )
  or
  // `import { createRequire } from 'module';`.
  // specialized to ES2015 modules to avoid recursion in the `DataFlow::moduleImport()` predicate and to avoid
  // negative recursion between `Import.getImportedModuleNode()` and `Import.getImportedModule()`, and
  // to avoid depending on `SourceNode` as this would make `SourceNode::Range` recursive.
  exists(CallExpr call |
    isCreateRequire(TValueNode(call.getCallee())) and
    nd = TValueNode(call)
  )
  or
  // `$.require('underscore');`.
  // NPM as supported in [XSJS files](https://www.npmjs.com/package/@sap/async-xsjs#npm-packages-support).
  exists(MethodCallExpr require |
    require.getFile().getExtension() = ["xsjs", "xsjslib"] and
    require.getCalleeName() = "require" and
    require.getReceiver().(GlobalVarAccess).getName() = "$" and
    nd = TValueNode(require.getCallee())
  )
}

/**
 * A `require` import.
 *
 * Example:
 *
 * ```
 * require('fs')
 * ```
 */
class Require extends CallExpr, Import {
  Require() { isRequire(TValueNode(this.getCallee())) }

  override Expr getImportedPathExpr() { result = this.getArgument(0) }

  override Module getEnclosingModule() { this = result.getAnImport() }

  override DataFlow::Node getImportedModuleNode() { result = DataFlow::valueNode(this) }
}

/** An argument to `require` or `require.resolve`, considered as a path expression. */
deprecated private class RequirePath extends PathExprCandidate {
  RequirePath() {
    this = any(Require req).getArgument(0)
    or
    exists(MethodCallExpr reqres |
      isRequire(TValueNode(reqres.getReceiver())) and
      reqres.getMethodName() = "resolve" and
      this = reqres.getArgument(0)
    )
  }
}

/** A constant path element appearing in a call to `require` or `require.resolve`. */
deprecated private class ConstantRequirePathElement extends PathExpr, ConstantString {
  ConstantRequirePathElement() { this = any(RequirePath rp).getAPart() }

  override string getValue() { result = this.getStringValue() }
}

/** A `__dirname` path expression. */
deprecated private class DirNamePath extends PathExpr, VarAccess {
  DirNamePath() {
    this.getName() = "__dirname" and
    this.getVariable().getScope() instanceof ModuleScope
  }

  override string getValue() { result = this.getFile().getParentContainer().getAbsolutePath() }
}

/** A `__filename` path expression. */
deprecated private class FileNamePath extends PathExpr, VarAccess {
  FileNamePath() {
    this.getName() = "__filename" and
    this.getVariable().getScope() instanceof ModuleScope
  }

  override string getValue() { result = this.getFile().getAbsolutePath() }
}

/**
 * A path expression of the form `path.join(p, "...")` where
 * `p` is also a path expression.
 */
deprecated private class JoinedPath extends PathExpr, @call_expr {
  JoinedPath() {
    exists(MethodCallExpr call | call = this |
      call.getReceiver().(VarAccess).getName() = "path" and
      call.getMethodName() = "join" and
      call.getNumArgument() = 2 and
      call.getArgument(0) instanceof PathExpr and
      call.getArgument(1) instanceof ConstantString
    )
  }

  override string getValue() {
    exists(CallExpr call, PathExpr left, ConstantString right |
      call = this and
      left = call.getArgument(0) and
      right = call.getArgument(1)
    |
      result = left.getValue() + "/" + right.getStringValue()
    )
  }
}

/**
 * A reference to the special `module` variable.
 *
 * Example:
 *
 * ```
 * module
 * ```
 */
class ModuleAccess extends VarAccess {
  ModuleAccess() { exists(ModuleScope ms | this = ms.getVariable("module").getAnAccess()) }
}
