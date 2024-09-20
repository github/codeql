/**
 * Provides the `Element` class, the base class of all C# program elements.
 */

import Location
private import semmle.code.csharp.ExprOrStmtParent
private import commons.QualifiedName

/**
 * A program element. Either a control flow element (`ControlFlowElement`), an
 * attribute (`Attribute`), a declaration (`Declaration`), a modifier
 * (`Modifier`), a namespace (`Namespace`), a namespace declaration
 * (`NamespaceDeclaration`), a `using` directive (`UsingDirective`), or type
 * parameter constraints (`TypeParameterConstraints`).
 */
class Element extends @element {
  /** Gets a textual representation of this element. */
  cached
  string toString() { none() }

  /** Gets the file containing this element. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Holds if this element is from source code. */
  predicate fromSource() { this.getFile().fromSource() }

  /** Holds if this element is from an assembly. */
  predicate fromLibrary() { this.getFile().fromLibrary() }

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs.
   *
   * If no primary class can be determined, the result is `"???"`.
   */
  final string getPrimaryQlClasses() {
    result = strictconcat(this.getAPrimaryQlClass(), ",")
    or
    not exists(this.getAPrimaryQlClass()) and
    result = "???"
  }

  /**
   * Gets the name of a primary CodeQL class to which this element belongs.
   *
   * For most elements, this is simply the most precise syntactic category to
   * which they belong; for example, `AddExpr` is a primary class, but
   * `BinaryOperation` is not.
   *
   * If no primary classes match, this predicate has no result. If multiple
   * primary classes match, this predicate can have multiple results.
   *
   * See also `getPrimaryQlClasses`, which is better to use in most cases.
   */
  string getAPrimaryQlClass() { none() }

  /** Gets the full textual representation of this element, including type information. */
  string toStringWithTypes() { result = this.toString() }

  /**
   * Gets the location of this element. Where an element has locations in
   * source and assemblies, choose the source location. If there are multiple
   * assembly locations, choose only one.
   */
  final Location getLocation() { result = bestLocation(this) }

  /** Gets a location of this element, including sources and assemblies. */
  Location getALocation() { none() }

  /** Gets the parent of this element, if any. */
  Element getParent() { result.getAChild() = this }

  /** Gets a child of this element, if any. */
  Element getAChild() { result = this.getChild(_) }

  /** Gets the `i`th child of this element (zero-based). */
  Element getChild(int i) { none() }

  /** Gets the number of children of this element. */
  pragma[nomagic]
  int getNumberOfChildren() { result = count(int i | exists(this.getChild(i))) }

  /**
   * Gets the index of this element among its parent's
   * other children (zero-based).
   */
  int getIndex() { exists(Element parent | parent.getChild(result) = this) }
}

/** An element that has a name. */
class NamedElement extends Element, @named_element {
  /** Gets the name of this element. */
  cached
  string getName() { none() }

  /** Holds if this element has name 'name'. */
  final predicate hasName(string name) { name = this.getName() }

  /**
   * DEPRECATED: Use `hasFullyQualifiedName` instead.
   *
   * Gets the fully qualified name of this element, for example the
   * fully qualified name of `M` on line 3 is `N.C.M` in
   *
   * ```csharp
   * namespace N {
   *   class C {
   *     void M(int i, string s) { }
   *   }
   * }
   * ```
   *
   * Unbound generic types, such as `IList<T>`, are represented as
   * ``System.Collections.Generic.IList`1``.
   */
  deprecated final string getFullyQualifiedName() {
    exists(string qualifier, string name | this.hasFullyQualifiedName(qualifier, name) |
      if qualifier = "" then result = name else result = qualifier + "." + name
    )
  }

  /**
   * INTERNAL: Do not use.
   *
   * This is intended for DEBUG ONLY.
   * Constructing the fully qualified name for all elements in a large codebase
   * puts severe stress on the string pool.
   *
   * Gets the fully qualified name of this element, for example the
   * fully qualified name of `M` on line 3 is `N.C.M` in
   *
   * ```csharp
   * namespace N {
   *   class C {
   *     void M(int i, string s) { }
   *   }
   * }
   * ```
   *
   * Unbound generic types, such as `IList<T>`, are represented as
   * ``System.Collections.Generic.IList`1``.
   */
  bindingset[this]
  pragma[inline_late]
  final string getFullyQualifiedNameDebug() {
    exists(string qualifier, string name | this.hasFullyQualifiedName(qualifier, name) |
      if qualifier = "" then result = name else result = qualifier + "." + name
    )
  }

  /** Holds if this element has the fully qualified name `qualifier`.`name`. */
  cached
  predicate hasFullyQualifiedName(string qualifier, string name) {
    qualifier = "" and name = this.getName()
  }

  override string toString() { result = this.getName() }
}
