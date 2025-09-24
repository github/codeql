private import AstImport

/**
 * A property member of a class. For example:
 * ```
 * class MyClass {
 *  [string]$MyProperty
 * }
 * ```
 */
class PropertyMember extends Member, TPropertyMember {
  final override string getLowerCaseName() { result = getRawAst(this).(Raw::PropertyMember).getName().toLowerCase() }

  final override string toString() { result = this.getLowerCaseName() }
}
