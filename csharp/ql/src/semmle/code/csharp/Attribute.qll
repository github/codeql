/**
 * Provides the `Attribute` class.
 */

import Type
private import semmle.code.csharp.ExprOrStmtParent
private import TypeRef

/**
 * An element that can have attributes. Either an assembly (`Assembly`), a field (`Field`),
 * a parameter (`Parameter`), an operator (`Operator`), a method (`Method`), a constructor (`Constructor`),
 * a destructor (`Destructor`), a callable accessor (`CallableAccessor`), a value or reference type
 * (`ValueOrRefType`), or a declaration with accessors (`DeclarationWithAccessors`).
 */
class Attributable extends @attributable {
  /** Gets an attribute attached to this element, if any. */
  final Attribute getAnAttribute() { result.getTarget() = this }

  /** Gets a textual representation of this element. */
  string toString() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this
        .(Element)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An attribute, for example `[...]` on line 1 in
 *
 * ```csharp
 * [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
 * public static extern int GetFinalPathNameByHandle(
 *   SafeHandle handle,
 *   [In, Out] StringBuilder path,
 *   int bufLen,
 *   int flags);
 * ```
 */
class Attribute extends TopLevelExprParent, @attribute {
  /** Gets the type of this attribute. */
  Class getType() { attributes(this, getTypeRef(result), _) }

  /** Gets the element that this attribute is attached to. */
  Attributable getTarget() { attributes(this, _, result) }

  /**
   * Gets the `i`th argument of this attribute. This includes both constructor
   * arguments and named arguments.
   */
  Expr getArgument(int i) { result = this.getChildExpr(i) }

  /**
   * Gets the `i`th constructor argument of this attribute. For example, only
   * `true` is a constructor argument in
   *
   * ```csharp
   * MyAttribute[true, Foo = 0]
   * ```
   */
  Expr getConstructorArgument(int i) {
    result = this.getArgument(i) and not exists(result.getExplicitArgumentName())
  }

  /**
   * Gets the named argument `name` of this attribute. For example, only
   * `0` is a named argument in
   *
   * ```csharp
   * MyAttribute[true, Foo = 0]
   * ```
   */
  Expr getNamedArgument(string name) {
    result = this.getArgument(_) and
    result.getExplicitArgumentName() = name
  }

  override Location getALocation() { attribute_location(this, result) }

  override string toString() {
    exists(string type, string name | type = getType().toString() |
      (if type.matches("%Attribute") then name = type.prefix(type.length() - 9) else name = type) and
      result = "[" + name + "(...)]"
    )
  }

  override string getAPrimaryQlClass() { result = "Attribute" }
}
