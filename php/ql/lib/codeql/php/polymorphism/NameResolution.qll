/**
 * @name Name Resolution
 * @description Handles namespace and name resolution
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A namespace definition.
 */
class NamespaceDef extends TS::PHP::NamespaceDefinition {
  /** Gets the namespace name */
  string getNamespaceName() {
    result = this.getName().(TS::PHP::NamespaceName).toString()
  }

  /** Gets the body of this namespace */
  TS::PHP::CompoundStatement getNamespaceBody() {
    result = this.getBody()
  }
}

/**
 * A use declaration (import).
 */
class UseDecl extends TS::PHP::NamespaceUseDeclaration {
  /** Gets an imported class/function/const clause */
  TS::PHP::NamespaceUseClause getAUseClause() {
    result = this.getChild(_)
  }
}

/**
 * A use clause (single import).
 */
class UseClauseDecl extends TS::PHP::NamespaceUseClause {
  /** Gets the imported name */
  string getImportedName() {
    result = this.getChild().(TS::PHP::NamespaceName).toString() or
    result = this.getChild().(TS::PHP::QualifiedName).toString()
  }

  /** Gets the alias if present */
  string getAliasName() {
    result = this.getAlias().(TS::PHP::Name).getValue()
  }

  /** Gets the simple name (last component) */
  string getSimpleName() {
    exists(string full | full = this.getImportedName() |
      full.matches("%\\%") and result = full.regexpCapture(".*\\\\([^\\\\]+)$", 1) or
      not full.matches("%\\%") and result = full
    )
  }
}

/**
 * A qualified name (namespaced reference).
 */
class QualifiedNameReference extends TS::PHP::QualifiedName {
  /** Gets the full qualified name */
  string getFullName() {
    result = this.toString()
  }

  /** Gets the last component (simple name) */
  string getSimpleName() {
    exists(string full | full = this.toString() |
      full.matches("%\\%") and result = full.regexpCapture(".*\\\\([^\\\\]+)$", 1) or
      not full.matches("%\\%") and result = full
    )
  }

  /** Checks if this is a fully qualified name (starts with \) */
  predicate isFullyQualified() {
    this.toString().matches("\\%")
  }
}

/**
 * Gets classes in the global namespace.
 */
TS::PHP::ClassDeclaration getGlobalClass() {
  not exists(TS::PHP::NamespaceDefinition ns |
    result.getParent+() = ns
  )
}

/**
 * Gets classes in a specific namespace.
 */
TS::PHP::ClassDeclaration getClassInNamespace(string namespaceName) {
  exists(NamespaceDef ns |
    ns.getNamespaceName() = namespaceName and
    result.getParent+() = ns
  )
}
