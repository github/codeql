private import AstImport

/**
 * A non-member function declaration. For example:
 * ```
 * function My-Function {
 *   param($param1, $param2)
 *   Write-Host "Hello, World!"
 * }
 * ```
 */
class Function extends FunctionBase, TFunction {
  final override string getLowerCaseName() { any(Synthesis s).functionName(this, result) }

  final override ScriptBlock getBody() { any(Synthesis s).functionScriptBlock(this, result) }

  final override Parameter getParameter(int i) { result = this.getBody().getParameter(i) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = functionBody() and result = this.getBody()
  }
}
