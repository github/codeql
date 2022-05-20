/**
 * Provides the .Net `Element` class.
 */

private import DotNet
import semmle.code.csharp.Location

/**
 * A .Net program element.
 */
class Element extends @dotnet_element {
  /** Gets a textual representation of this element. */
  cached
  string toString() { none() }

  /** Gets the location of this element. */
  pragma[nomagic]
  Location getLocation() { none() }

  /**
   * Gets a location of this element, which can include locations in
   * both DLLs and source files.
   */
  Location getALocation() { none() }

  /** Gets the file containing this element. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Holds if this element is from source code. */
  predicate fromSource() { this.getFile().fromSource() }

  /** Holds if this element is from an assembly. */
  predicate fromLibrary() { this.getFile().fromLibrary() }

  /**
   * Gets the "language" of this program element, as defined by the extension of the filename.
   * For example, C# has language "cs", and Visual Basic has language "vb".
   */
  final string getLanguage() { result = this.getLocation().getFile().getExtension() }

  /** Gets the full textual representation of this element, including type information. */
  string toStringWithTypes() { result = this.toString() }

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
}

/** An element that has a name. */
class NamedElement extends Element, @dotnet_named_element {
  /** Gets the name of this element. */
  cached
  string getName() { none() }

  /** Holds if this element has name 'name'. */
  final predicate hasName(string name) { name = this.getName() }

  /**
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
   */
  cached
  final string getQualifiedName() {
    exists(string qualifier, string name | this.hasQualifiedName(qualifier, name) |
      if qualifier = "" then result = name else result = qualifier + "." + name
    )
  }

  /**
   * Holds if this element has qualified name `qualifiedName`, for example
   * `System.Console.WriteLine`.
   */
  final predicate hasQualifiedName(string qualifiedName) { qualifiedName = this.getQualifiedName() }

  /** Holds if this element has the qualified name `qualifier`.`name`. */
  cached
  predicate hasQualifiedName(string qualifier, string name) {
    qualifier = "" and name = this.getName()
  }

  /** Gets a unique string label for this element. */
  cached
  string getLabel() { none() }

  /** Holds if `other` has the same metadata handle in the same assembly. */
  predicate matchesHandle(NamedElement other) {
    exists(Assembly asm, int handle |
      metadata_handle(this, asm, handle) and
      metadata_handle(other, asm, handle)
    )
  }

  /**
   * Holds if this element was compiled from source code that is also present in the
   * database. That is, this element corresponds to another element from source.
   */
  predicate compiledFromSource() {
    not this.fromSource() and
    exists(NamedElement other | other != this |
      this.matchesHandle(other) and
      other.fromSource()
    )
  }

  override string toString() { result = this.getName() }
}
