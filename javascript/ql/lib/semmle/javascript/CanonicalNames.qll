/**
 * Provides classes for working with name resolution of namespaces and types.
 */

import javascript

/**
 * A fully qualified name relative to a specific root,
 * usually referring to a TypeScript namespace or type.
 *
 * Canonical names are organized in a prefix tree, that is, the "parent"
 * of a canonical name is the name corresponding to its prefix.
 *
 * It is possible for two different canonical names to have the same
 * qualified name, namely if they are rooted in different scopes. The `hasQualifiedName`
 * predicates deal specifically with canonical names that are rooted in
 * the global scope or in the scope of a named module.
 *
 * This class is only populated when full TypeScript extraction is enabled.
 */
class CanonicalName extends @symbol {
  /**
   * Gets the parent of this canonical name, that is, the prefix of its qualified name.
   */
  CanonicalName getParent() { symbol_parent(this, result) }

  /**
   * Gets a child of this canonical name, that is, an extension of its qualified name.
   */
  CanonicalName getAChild() { result.getParent() = this }

  /**
   * Gets the child of this canonical name that has the given `name`, if any.
   */
  CanonicalName getChild(string name) {
    result = this.getAChild() and
    result.getName() = name
  }

  /**
   * Gets the name without prefix.
   */
  string getName() { symbols(this, _, result) }

  /**
   * Gets the name of the external module represented by this canonical name, if any.
   */
  string getExternalModuleName() {
    symbol_module(this, result)
    or
    exists(PackageJson pkg |
      this.getModule() = pkg.getMainModule() and
      result = pkg.getPackageName()
    )
  }

  /**
   * Gets the name of the global variable represented by this canonical name, if any.
   */
  string getGlobalName() { symbol_global(this, result) }

  /**
   * Gets the module represented by this canonical name, if such a module exists
   * and was extracted.
   */
  Module getModule() { ast_node_symbol(result, this) }

  /**
   * Holds if this canonical name has a child, i.e. an extension of its qualified name.
   */
  predicate hasChild() { exists(this.getAChild()) }

  /**
   * True if this has no parent.
   */
  predicate isRoot() { not exists(this.getParent()) }

  /**
   * Holds if this is the export namespace of a module.
   */
  predicate isModuleRoot() {
    exists(this.getModule()) or
    exists(this.getExternalModuleName())
  }

  /**
   * Holds if this is the export namespace of the given module.
   */
  predicate isModuleRoot(StmtContainer mod) { ast_node_symbol(mod, this) }

  /**
   * Holds if this canonical name is exported by its parent.
   *
   * Some entities, such as type parameters, have canonical names that are not
   * available through qualified name access.
   */
  predicate isExportedMember() { this instanceof @member_symbol }

  /** Holds if this has the given qualified name, rooted in the global scope. */
  predicate hasQualifiedName(string globalName) {
    globalName = this.getGlobalName()
    or
    exists(string prefix |
      this.getParent().hasQualifiedName(prefix) and
      globalName = prefix + "." + this.getName()
    )
  }

  /** Holds if this has the given qualified name, rooted in the given external module. */
  predicate hasQualifiedName(string moduleName, string exportedName) {
    moduleName = this.getParent().getExternalModuleName() and
    exportedName = this.getName()
    or
    exists(string prefix |
      this.getParent().hasQualifiedName(moduleName, prefix) and
      exportedName = prefix + "." + this.getName()
    )
  }

  /**
   * Gets the qualified name without the root.
   */
  string getRelativeName() {
    if this.getParent().isModuleRoot()
    then result = this.getName()
    else
      if exists(this.getGlobalName())
      then result = min(this.getGlobalName())
      else
        if exists(this.getParent())
        then result = this.getParent().getRelativeName() + "." + this.getName()
        else (
          not this.isModuleRoot() and result = this.getName()
        )
  }

  /**
   * Gets the outermost scope from which this type can be accessed by a qualified name (without using an `import`).
   *
   * This is typically the top-level of a module, but for locally declared types (e.g. types declared inside a function),
   * this is the container where the type is declared.
   */
  Scope getRootScope() {
    exists(CanonicalName root | root = this.getRootName() |
      if exists(root.getModule())
      then result = root.getModule().getScope()
      else
        if exists(root.getGlobalName())
        then result instanceof GlobalScope
        else result = this.getADefinition().getContainer().getScope()
    )
  }

  private CanonicalName getRootName() {
    if exists(this.getGlobalName()) or this.isModuleRoot() or not exists(this.getParent())
    then result = this
    else result = this.getParent().getRootName()
  }

  /**
   * Gets a definition of the entity with this canonical name.
   */
  AstNode getADefinition() { none() }

  /**
   * Gets a use that refers to the entity with this canonical name.
   */
  ExprOrType getAnAccess() { none() }

  /**
   * Gets a string describing the root scope of this canonical name.
   */
  string describeRoot() {
    exists(CanonicalName root | root = this.getRootName() |
      if exists(root.getExternalModuleName())
      then result = "module '" + min(root.getExternalModuleName()) + "'"
      else
        if exists(root.getModule().getFile().getRelativePath())
        then result = root.getModule().getFile().getRelativePath()
        else
          if exists(root.getGlobalName())
          then result = "global scope"
          else
            if exists(root.getADefinition())
            then
              exists(StmtContainer container | container = root.getADefinition().getContainer() |
                result = container.(TopLevel).getFile().getRelativePath()
                or
                not container instanceof TopLevel and
                result = container.getLocation().toString()
              )
            else result = "unknown scope"
    )
  }

  /**
   * Gets the fully qualified name, followed by the name of its enclosing module or file.
   *
   * For example, the class `Server` from the `http` module has `toString` value: `Server in module 'http'`.
   *
   * In the file `foo.ts` below, the class `C` has `toString` value `C in foo.ts:2` because it is
   * defined in a lexical scope starting on line 2:
   * ```
   * namespace X {
   *   function doWork() {
   *     class C {}
   *   }
   * }
   * ```
   */
  string toString() {
    if this.isModuleRoot()
    then result = this.describeRoot()
    else result = this.getRelativeName() + " in " + this.describeRoot()
  }
}

/**
 * The canonical name for a type.
 */
class TypeName extends CanonicalName {
  TypeName() {
    exists(TypeReference ref | type_symbol(ref, this)) or
    exists(TypeDefinition def | ast_node_symbol(def, this)) or
    base_type_names(_, this) or
    base_type_names(this, _)
  }

  /**
   * Gets a definition of the type with this canonical name, if any.
   */
  override TypeDefinition getADefinition() { ast_node_symbol(result, this) }

  /**
   * Gets a type annotation that refers to this type name.
   */
  override TypeAccess getAnAccess() { result.getTypeName() = this }

  /**
   * Gets a type that refers to this canonical name.
   */
  TypeReference getATypeReference() { result.getTypeName() = this }

  /**
   * Gets a type named in the `extends` or `implements` clause of this type.
   */
  TypeName getABaseTypeName() { base_type_names(this, result) }

  /**
   * Gets the "self type" that refers to this canonical name.
   *
   * For a generic class or interface, the type arguments on the self type
   * all refer to the corresponding type parameters declared on that class or interface.
   *
   * For example, the "self type" of `Array` is `Array<T>`, where `T` refers to the
   * type parameter declared on the `Array` type.
   */
  TypeReference getType() { self_types(this, result) }
}

/**
 * The canonical name for a namespace.
 */
class Namespace extends CanonicalName {
  Namespace() {
    this.getAChild().isExportedMember() or
    exists(NamespaceDefinition def | ast_node_symbol(def, this)) or
    exists(NamespaceAccess ref | ast_node_symbol(ref, this))
  }

  /**
   * Gets a definition of the namespace with this canonical name, if any.
   */
  override NamespaceDefinition getADefinition() { ast_node_symbol(result, this) }

  /**
   * Gets a part of a type annotation that refers to this namespace.
   */
  override NamespaceAccess getAnAccess() { result.getNamespace() = this }

  /** Gets a namespace nested in this one. */
  Namespace getNamespaceMember(string name) {
    result.getParent() = this and
    result.getName() = name and
    result.isExportedMember()
  }

  /** Gets the type of the given name in this namespace, if any. */
  TypeName getTypeMember(string name) {
    result.getParent() = this and
    result.getName() = name and
    result.isExportedMember()
  }

  /**
   * Gets a namespace declaration or top-level whose exports contribute directly to this namespace.
   *
   * This includes containers that don't actually contain any `export` statements, but whose
   * exports would contribute to this namespace, if there were any.
   *
   * Does not include containers whose exports only contribute indirectly, through re-exports.
   * That is, there is at most one namespace associated with a given container.
   *
   * Namespaces defined by enum declarations have no exporting containers.
   */
  StmtContainer getAnExportingContainer() { ast_node_symbol(result, this) }
}

/**
 * The canonical name for a function.
 */
class CanonicalFunctionName extends CanonicalName {
  CanonicalFunctionName() {
    exists(Function fun | ast_node_symbol(fun, this)) or
    exists(InvokeExpr invoke | ast_node_symbol(invoke, this))
  }

  /**
   * Gets a function with this canonical name.
   */
  override Function getADefinition() { ast_node_symbol(result, this) }

  /**
   * Gets an expression (such as a callee expression in a function call or `new` expression)
   * that refers to a function with this canonical name.
   */
  override Expr getAnAccess() {
    exists(InvokeExpr invk | ast_node_symbol(invk, this) | result = invk.getCallee())
    or
    ast_node_symbol(result, this) and
    not result instanceof InvokeExpr
  }

  /**
   * Gets the implementation of this function, if it exists.
   */
  Function getImplementation() { result = this.getADefinition() and result.hasBody() }
}
