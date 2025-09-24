private import AstImport

/**
 * A type constraint on a parameter or variable. For example, the `[string]` in:
 * ```
 * param ([string]$name)
 * [string]$str = ""
 */
class TypeConstraint extends Ast, TTypeConstraint {
  string getName() { result = getRawAst(this).(Raw::TypeConstraint).getName() }

  override string toString() { result = this.getName() }
}
