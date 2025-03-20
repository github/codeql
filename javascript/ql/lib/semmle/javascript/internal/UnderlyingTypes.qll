/**
 * Provides name resolution and propagates type information.
 */

private import javascript
private import semmle.javascript.internal.NameResolution::NameResolution

/**
 * Provides name resolution and propagates type information.
 */
module UnderlyingTypes {
  /**
   * Holds if `moduleName` appears to start with a package name, as opposed to a relative file import.
   */
  bindingset[moduleName]
  private predicate isExternalModuleName(string moduleName) {
    not moduleName.regexpMatch("^(\\.|/).*")
  }

  bindingset[name]
  private string normalizeModuleName(string name) {
    result =
      name.regexpReplaceAll("^node:", "")
          .regexpReplaceAll("\\.[jt]sx?$", "")
          .regexpReplaceAll("/(index)?$", "")
  }

  /**
   * Holds if `node` is a reference to the given module, or a qualified name rooted in that module.
   *
   * If `qualifiedName` is empty, `node` refers to the module itself.
   *
   * If `mod` is the string `"global"`, `node` refers to a global access path.
   */
  predicate nodeRefersToModule(Node node, string mod, string qualifiedName) {
    exists(PathExpr path |
      path = any(Import imprt).getImportedPath() or
      path = any(ReExportDeclaration e).getImportedPath()
    |
      node = path and
      mod = normalizeModuleName(path.getValue()) and
      isExternalModuleName(mod) and
      qualifiedName = ""
    )
    or
    mod = "global" and
    exists(LocalNamespaceAccess access |
      node = access and
      not exists(access.getLocalNamespaceName()) and
      access.getName() = qualifiedName
    )
    or
    // Additionally track through bulk re-exports (`export * from 'mod`).
    // These are normally handled by 'exportAs' which supports various shadowing rules,
    // but has no effect when the ultimate re-exported module is not resolved to a Module.
    // We propagate external module refs through bulk re-exports and ignore shadowing rules.
    exists(BulkReExportDeclaration reExport |
      nodeRefersToModule(reExport.getImportedPath(), mod, qualifiedName) and
      node = reExport.getContainer()
    )
    or
    exists(Node mid |
      nodeRefersToModule(mid, mod, qualifiedName) and
      ValueFlow::step(mid, node)
    )
    or
    exists(Node mid, string prefix, string step |
      nodeRefersToModule(mid, mod, prefix) and
      readStep(mid, step, node) and
      qualifiedName = append(prefix, step)
    )
  }

  private predicate subtypeStep(Node node1, Node node2) {
    exists(ClassOrInterface cls |
      (
        node1 = cls.getSuperClass() or
        node1 = cls.getASuperInterface()
      ) and
      node2 = cls
    )
  }

  private predicate underlyingTypeStep(Node node1, Node node2) {
    exists(UnionOrIntersectionTypeExpr type |
      node1 = type.getAnElementType() and
      node2 = type
    )
    or
    exists(ReadonlyTypeExpr type |
      node1 = type.getElementType() and
      node2 = type
    )
    or
    exists(OptionalTypeExpr type |
      node1 = type.getElementType() and
      node2 = type
    )
    or
    exists(GenericTypeExpr type |
      node1 = type.getTypeAccess() and
      node2 = type
    )
    or
    exists(ExpressionWithTypeArguments e |
      node1 = e.getExpression() and
      node2 = e
    )
    or
    exists(JSDocUnionTypeExpr type |
      node1 = type.getAnAlternative() and
      node2 = type
    )
    or
    exists(JSDocNonNullableTypeExpr type |
      node1 = type.getTypeExpr() and
      node2 = type
    )
    or
    exists(JSDocNullableTypeExpr type |
      node1 = type.getTypeExpr() and
      node2 = type
    )
    or
    exists(JSDocAppliedTypeExpr type |
      node1 = type.getHead() and
      node2 = type
    )
    or
    exists(JSDocOptionalParameterTypeExpr type |
      node1 = type.getUnderlyingType() and
      node2 = type
    )
  }

  bindingset[a, b]
  private string append(string a, string b) {
    if b = "default"
    then result = a
    else (
      (if a = "" or b = "" then result = a + b else result = a + "." + b) and
      result.length() < 100
    )
  }

  predicate nodeHasUnderlyingType(Node node, string mod, string name) {
    nodeRefersToModule(node, mod, name)
    or
    exists(JSDocNamedTypeExpr type |
      node = type and
      type.hasQualifiedName(name) and
      mod = "global"
    )
    or
    exists(Node mid | nodeHasUnderlyingType(mid, mod, name) |
      TypeFlow::step(mid, node)
      or
      underlyingTypeStep(mid, node)
      or
      subtypeStep(mid, node)
    )
  }

  predicate nodeHasUnderlyingClassType(Node node, ClassDefinition cls) {
    node = cls
    or
    exists(Node mid | nodeHasUnderlyingClassType(mid, cls) |
      TypeFlow::step(mid, node)
      or
      underlyingTypeStep(mid, node)
      // Note: unlike for external types, we do not use subtype steps here.
      // The caller is responsible for handling the class hierarchy.
    )
  }
}
