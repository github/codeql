private import AstImport

/**
 * A function definition statement. For example:
 * ```
 * function Get-Greeting {
 *   param($name)
 *   "Hello, $name!"
 * }
 * ```
 */
class FunctionDefinitionStmt extends Stmt, TFunctionDefinitionStmt {
  FunctionBase getFunction() { synthChild(getRawAst(this), funDefFun(), result) }

  string getName() { result = getRawAst(this).(Raw::FunctionDefinitionStmt).getName() }

  final override string toString() { result = "def of " + this.getName() }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = funDefFun() and result = this.getFunction()
  }
}
