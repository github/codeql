/**
 * Provides all `using` directive classes.
 *
 * All `using` directives have the common base class `UsingDirective`.
 */

import Element
private import TypeRef

/**
 * A `using` directive. Either a namespace `using` directive
 * (`UsingNamespaceDirective`) or a type `using` directive
 * (`UsingStaticDirective`).
 */
class UsingDirective extends Element, @using_directive {
  /**
   * Gets the namespace in which this `using` directive appears, if any.
   *
   * Example:
   *
   * ```csharp
   * using System;
   *
   * namespace N {
   *   using System.Web;
   *   using static System.Console;
   * }
   * ```
   *
   * The first `using` directive on line 1 does not appear in a namespace,
   * the second and third `using` directives on lines 4 and 5 appear in the
   * namespace `N`.
   */
  NamespaceDeclaration getParentNamespaceDeclaration() {
    parent_namespace_declaration(this, result)
  }

  override Location getALocation() { using_directive_location(this, result) }

  /** Holds if this directive is `global`. */
  predicate isGlobal() { using_global(this) }
}

/**
 * A namespace `using` directive, for example `using System`.
 */
class UsingNamespaceDirective extends UsingDirective, @using_namespace_directive {
  /**
   * Gets the target of this namespace `using` directive, for example `System`
   * in `using System`.
   */
  Namespace getImportedNamespace() { using_namespace_directives(this, result) }

  override string toString() { result = "using ...;" }

  override string getAPrimaryQlClass() { result = "UsingNamespaceDirective" }
}

/**
 * A type `using` directive, for example `using static System.Console`.
 */
class UsingStaticDirective extends UsingDirective, @using_static_directive {
  /**
   * Gets the target of this type `using` directive, for example
   * `System.Console` in `using static System.Console`.
   */
  ValueOrRefType getTarget() { using_static_directives(this, getTypeRef(result)) }

  override string toString() { result = "using static ...;" }

  override string getAPrimaryQlClass() { result = "UsingStaticDirective" }
}
