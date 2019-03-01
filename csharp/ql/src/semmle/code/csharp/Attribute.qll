/**
 * Provides the `Attribute` class.
 */

import Type
private import semmle.code.csharp.ExprOrStmtParent

/**
 * An element that can have attributes. Either a field (`Field`), a parameter
 * (`Parameter`), an operator (`Operator`), a method (`Method`), a constructor
 * (`Constructor`), a destructor (`Destructor`), a callable accessor
 * (`CallableAccessor`), a value or reference type (`ValueOrRefType`), or a
 * declaration with accessors (`DeclarationWithAccessors`).
 */
class Attributable extends Element, @attributable {
  /** Gets an attribute attached to this element, if any. */
  final Attribute getAnAttribute() { result.getTarget() = this }
}

/**
 * An attribute, for example `[...]` on line 1 in
 *
 * ```
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

  /** Gets the `i`th argument of this attribute. */
  Expr getArgument(int i) { result = this.getChildExpr(i) }

  override Location getALocation() { attribute_location(this, result) }

  override string toString() {
    exists(string type, string name | type = getType().toString() |
      (if type.matches("%Attribute") then name = type.prefix(type.length() - 9) else name = type) and
      result = "[" + name + "(...)]"
    )
  }
}
