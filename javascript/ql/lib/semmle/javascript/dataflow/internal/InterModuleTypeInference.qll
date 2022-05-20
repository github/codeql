/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides classes implementing type inference across imports.
 */

private import javascript
private import AbstractValuesImpl
private import semmle.javascript.dataflow.InferredTypes
private import AbstractPropertiesImpl

/**
 * Flow analysis for ECMAScript 2015 imports as variable definitions.
 */
private class AnalyzedImportSpecifier extends AnalyzedVarDef, @import_specifier {
  ImportDeclaration id;

  AnalyzedImportSpecifier() {
    this = id.getASpecifier() and
    exists(id.resolveImportedPath()) and
    not this.(ImportSpecifier).isTypeOnly()
  }

  override DataFlow::AnalyzedNode getRhs() { result.(AnalyzedImport).getImportSpecifier() = this }

  override predicate isIncomplete(DataFlow::Incompleteness cause) {
    // mark as incomplete if the import could rely on the lookup path
    mayDependOnLookupPath(id.getImportedPath().getValue()) and
    cause = "import"
    or
    // mark as incomplete if we cannot fully analyze this import
    exists(Module m | m = id.resolveImportedPath() |
      mayDynamicallyComputeExports(m)
      or
      incompleteExport(m, this.(ImportSpecifier).getImportedName())
    ) and
    cause = "import"
  }
}

/**
 * Holds if resolving `path` may depend on the lookup path, that is,
 * it does not start with `.` or `/`.
 */
bindingset[path]
private predicate mayDependOnLookupPath(string path) {
  exists(string firstChar | firstChar = path.charAt(0) | firstChar != "." and firstChar != "/")
}

/**
 * Holds if `m` may dynamically compute its exports.
 */
private predicate mayDynamicallyComputeExports(Module m) {
  // if `m` accesses its `module` or `exports` variable, we conservatively assume the worst;
  // in particular, this makes all imports from CommonJS modules indefinite
  exists(Variable v, VarAccess va | v.getName() = "module" or v.getName() = "exports" |
    va = v.getAnAccess() and
    (
      v = m.getScope().getAVariable()
      or
      // be conservative in case our heuristics for detecting Node.js modules fail
      v instanceof GlobalVariable and va.getTopLevel() = m
    )
  )
  or
  // AMD modules can export arbitrary objects, so an import is essentially a property read
  // and hence must be considered indefinite
  m instanceof AmdModule
  or
  // `m` re-exports all exports of some other module that dynamically computes its exports
  exists(BulkReExportDeclaration rexp | rexp = m.(ES2015Module).getAnExport() |
    mayDynamicallyComputeExports(rexp.getReExportedModule())
  )
}

/**
 * Holds if `x` is imported from `m`, possibly through a chain of re-exports.
 */
private predicate relevantExport(ES2015Module m, string x) {
  exists(ImportDeclaration id |
    id.getImportedModule() = m and
    x = id.getASpecifier().getImportedName()
  )
  or
  exists(ReExportDeclaration rexp, string y |
    rexp.getReExportedModule() = m and
    reExportsAs(rexp, x, y)
  )
}

/**
 * Holds if `rexp` re-exports `x` as `y`.
 */
private predicate reExportsAs(ReExportDeclaration rexp, string x, string y) {
  relevantExport(rexp.getEnclosingModule(), y) and
  (
    exists(ExportSpecifier spec | spec = rexp.(SelectiveReExportDeclaration).getASpecifier() |
      x = spec.getLocalName() and
      y = spec.getExportedName()
    )
    or
    rexp instanceof BulkReExportDeclaration and
    x = y
  )
}

/**
 * Holds if `m` re-exports `y`, but we cannot fully analyze this export.
 */
private predicate incompleteExport(ES2015Module m, string y) {
  exists(ReExportDeclaration rexp | rexp = m.getAnExport() |
    exists(string x | reExportsAs(rexp, x, y) |
      // path resolution could rely on lookup path
      mayDependOnLookupPath(rexp.getImportedPath().getStringValue())
      or
      // unresolvable path
      not exists(rexp.getReExportedModule())
      or
      exists(Module n | n = rexp.getReExportedModule() |
        // re-export from CommonJS/AMD
        mayDynamicallyComputeExports(n)
        or
        // recursively incomplete
        incompleteExport(n, x)
      )
    )
    or
    // namespace re-export
    exists(ExportNamespaceSpecifier ns |
      ns.getExportDeclaration() = rexp and
      ns.getExportedName() = y
    )
  )
}

/**
 * Flow analysis for import specifiers, interpreted as implicit reads of
 * properties of the `module.exports` object of the imported module.
 */
private class AnalyzedImport extends AnalyzedPropertyRead, DataFlow::ValueNode {
  Module imported;
  override ImportSpecifier astNode;

  AnalyzedImport() {
    exists(ImportDeclaration id |
      astNode = id.getASpecifier() and
      not astNode.isTypeOnly() and
      imported = id.getImportedModule()
    )
  }

  /** Gets the import specifier being analyzed. */
  ImportSpecifier getImportSpecifier() { result = astNode }

  override predicate reads(AbstractValue base, string propName) {
    exists(AbstractProperty exports |
      exports = MkAbstractProperty(TAbstractModuleObject(imported), "exports")
    |
      base = exports.getALocalValue() and
      propName = astNode.getImportedName()
    )
    or
    // when importing CommonJS/AMD modules from ES2015, `module.exports` appears
    // as the default export
    (
      not imported instanceof ES2015Module
      or
      // CommonJS/AMD module generated by TypeScript compiler
      imported.getAStmt() instanceof ExportAssignDeclaration
    ) and
    astNode.getImportedName() = "default" and
    base = TAbstractModuleObject(imported) and
    propName = "exports"
  }
}

/**
 * Flow analysis for namespace imports.
 */
private class AnalyzedNamespaceImport extends AnalyzedImport {
  override ImportNamespaceSpecifier astNode;

  override predicate reads(AbstractValue base, string propName) {
    base = TAbstractModuleObject(imported) and
    propName = "exports"
  }
}

/**
 * Flow analysis for namespace imports.
 */
private class AnalyzedDestructuredImport extends AnalyzedPropertyRead {
  Module imported;

  AnalyzedDestructuredImport() {
    exists(ImportDeclaration id |
      this = DataFlow::destructuredModuleImportNode(id) and
      imported = id.getImportedModule()
    )
  }

  override predicate reads(AbstractValue base, string propName) {
    base = TAbstractModuleObject(imported) and
    propName = "exports"
  }
}

/**
 * A call to `require`, interpreted as an implicit read of
 * the `module.exports` property of the imported module.
 */
class AnalyzedRequireCall extends AnalyzedPropertyRead, DataFlow::ValueNode {
  Module required;

  AnalyzedRequireCall() { required = astNode.(Require).getImportedModule() }

  override predicate reads(AbstractValue base, string propName) {
    base = TAbstractModuleObject(required) and
    propName = "exports"
  }
}

/**
 * A special TypeScript `require` call in an import-assignment,
 * interpreted as an implicit of the `module.exports` property of the imported module.
 */
class AnalyzedExternalModuleReference extends AnalyzedPropertyRead, DataFlow::ValueNode {
  Module required;

  AnalyzedExternalModuleReference() {
    required = astNode.(ExternalModuleReference).getImportedModule()
  }

  override predicate reads(AbstractValue base, string propName) {
    base = TAbstractModuleObject(required) and
    propName = "exports"
  }
}

/**
 * Flow analysis for AMD exports.
 */
private class AnalyzedAmdExport extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  AmdModule amd;

  AnalyzedAmdExport() { astNode = amd.getDefine().getModuleExpr() }

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    baseVal = TAbstractModuleObject(amd) and
    propName = "exports" and
    source = this
  }
}

/**
 * Flow analysis for AMD imports, interpreted as an implicit read of
 * the `module.exports` property of the imported module.
 */
private class AnalyzedAmdImport extends AnalyzedPropertyRead, DataFlow::Node {
  Module required;

  AnalyzedAmdImport() {
    exists(AmdModule amd, PathExpr dep |
      exists(Parameter p |
        amd.getDefine().dependencyParameter(dep, p) and
        this = DataFlow::parameterNode(p)
      )
      or
      exists(CallExpr requireCall |
        requireCall = amd.getDefine().getARequireCall() and
        dep = requireCall.getAnArgument() and
        this = requireCall.flow()
      )
    |
      required = dep.(Import).getImportedModule()
    )
  }

  override predicate reads(AbstractValue base, string propName) {
    base = TAbstractModuleObject(required) and
    propName = "exports"
  }
}

/**
 * Flow analysis for parameters corresponding to AMD imports.
 */
private class AnalyzedAmdParameter extends AnalyzedVarDef, @var_decl {
  AnalyzedAmdImport imp;

  AnalyzedAmdParameter() { imp = DataFlow::parameterNode(this) }

  override AbstractValue getAnRhsValue() { result = imp.getALocalValue() }
}

/**
 * Flow analysis for exports that export a single value.
 */
private class AnalyzedValueExport extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  ExportDeclaration export;
  string name;

  AnalyzedValueExport() { this = export.getSourceNode(name) }

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    baseVal = TAbstractExportsObject(export.getEnclosingModule()) and
    propName = name and
    source = export.getSourceNode(name).analyze()
  }
}

/**
 * Flow analysis for exports that export a binding.
 */
private class AnalyzedVariableExport extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  ExportDeclaration export;
  string name;
  AnalyzedVarDef varDef;

  AnalyzedVariableExport() {
    export.exportsAs(varDef.getAVariable(), name) and
    astNode = varDef.getTarget()
  }

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    baseVal = TAbstractExportsObject(export.getEnclosingModule()) and
    propName = name and
    (
      source = varDef.getSource().analyze()
      or
      varDef.getTarget() instanceof DestructuringPattern and
      source = export.getSourceNode(propName)
    )
  }

  override predicate writesValue(AbstractValue baseVal, string propName, AbstractValue val) {
    baseVal = TAbstractExportsObject(export.getEnclosingModule()) and
    propName = name and
    val = varDef.getAnAssignedValue()
  }
}

/**
 * Flow analysis for default exports.
 */
private class AnalyzedDefaultExportDeclaration extends AnalyzedValueExport {
  override ExportDefaultDeclaration export;

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    super.writes(baseVal, propName, source)
    or
    // some (presumably historic) transpilers treat `export default foo` as `module.exports = foo`,
    // so allow that semantics, too, but only if there isn't a named export in the same module.
    exists(Module m |
      super.writes(TAbstractExportsObject(m), "default", source) and
      baseVal = TAbstractModuleObject(m) and
      propName = "exports" and
      not m.(ES2015Module).getAnExport() instanceof ExportNamedDeclaration
    )
  }
}

/**
 * Flow analysis for TypeScript export assignments.
 */
private class AnalyzedExportAssign extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  ExportAssignDeclaration exportAssign;

  AnalyzedExportAssign() { astNode = exportAssign.getExpression() }

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    baseVal = TAbstractModuleObject(exportAssign.getTopLevel()) and
    propName = "exports" and
    source = this
  }
}

/**
 * Flow analysis for assignments to the `exports` variable in a Closure module.
 */
private class AnalyzedClosureExportAssign extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  override AssignExpr astNode;

  AnalyzedClosureExportAssign() {
    astNode.getLhs() = any(Closure::ClosureModule mod).getExportsVariable().getAReference()
  }

  override predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) {
    baseVal = TAbstractModuleObject(astNode.getTopLevel()) and
    propName = "exports" and
    source = astNode.getRhs().flow()
  }
}

/**
 * Read of a global access path exported by a Closure library.
 *
 * This adds a direct flow edge to the assigned value.
 */
private class AnalyzedClosureGlobalAccessPath extends AnalyzedNode, AnalyzedPropertyRead {
  string accessPath;

  AnalyzedClosureGlobalAccessPath() {
    accessPath = Closure::getClosureNamespaceFromSourceNode(this)
  }

  override predicate reads(AbstractValue base, string propName) {
    exists(Closure::ClosureModule mod |
      mod.getClosureNamespace() = accessPath and
      base = TAbstractModuleObject(mod) and
      propName = "exports"
    )
  }
}

/**
 * A namespace export declaration analyzed as a property write.
 */
private class AnalyzedExportNamespaceSpecifier extends AnalyzedPropertyWrite, DataFlow::ValueNode {
  override ExportNamespaceSpecifier astNode;
  ReExportDeclaration decl;

  AnalyzedExportNamespaceSpecifier() {
    decl = astNode.getExportDeclaration() and
    not decl.isTypeOnly()
  }

  override predicate writesValue(AbstractValue baseVal, string propName, AbstractValue value) {
    baseVal = TAbstractExportsObject(getTopLevel()) and
    propName = astNode.getExportedName() and
    value = TAbstractExportsObject(decl.getReExportedModule())
  }
}
