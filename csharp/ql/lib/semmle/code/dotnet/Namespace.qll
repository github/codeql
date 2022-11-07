/**
 * Provides the `Namespace` class to represent .Net namespaces.
 */

private import Declaration
private import semmle.code.csharp.Printing

/** A namespace. */
class Namespace extends Declaration, @namespace {
  /**
   * Gets the parent namespace, if any. For example the parent namespace of `System.IO`
   * is `System`. The parent namespace of `System` is the global namespace.
   */
  Namespace getParentNamespace() { none() }

  /**
   * Gets a child namespace, if any. For example `System.IO` is a child in
   * the namespace `System`.
   */
  Namespace getAChildNamespace() { result.getParentNamespace() = this }

  /**
   * Holds if this namespace has the qualified name `qualifier`.`name`.
   *
   * For example if the qualified name is `System.Collections.Generic`, then
   * `qualifier`=`System.Collections` and `name`=`Generic`.
   */
  override predicate hasQualifiedName(string qualifier, string name) {
    exists(string pqualifier, string pname |
      this.getParentNamespace().hasQualifiedName(pqualifier, pname) and
      qualifier = printQualifiedName(pqualifier, pname)
    ) and
    name = this.getName()
  }

  /** Gets a textual representation of this namespace. */
  override string toString() { result = this.getQualifiedName() }

  /** Holds if this is the global namespace. */
  final predicate isGlobalNamespace() { this.getName() = "" }

  /** Gets the simple name of this namespace, for example `IO` in `System.IO`. */
  final override string getName() { namespaces(this, result) }

  final override string getUndecoratedName() { namespaces(this, result) }

  override string getAPrimaryQlClass() { result = "Namespace" }

  /**
   * Get the fully qualified name of this namespace.
   */
  string getFullName() {
    exists(string qualifier, string name |
      this.hasQualifiedName(qualifier, name) and
      result = printQualifiedName(qualifier, name)
    )
  }
}

/** The global namespace. */
class GlobalNamespace extends Namespace {
  GlobalNamespace() { this.getName() = "" }

  override predicate hasQualifiedName(string qualifier, string name) {
    qualifier = "" and name = ""
  }
}
