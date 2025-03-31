private import Raw

class FunctionDefinitionStmt extends @function_definition, Stmt {
  override Location getLocation() { function_definition_location(this, result) }

  ScriptBlock getBody() { function_definition(this, result, _, _, _) }

  string getName() { function_definition(this, _, result, _, _) }

  Parameter getParameter(int i) { function_definition_parameter(this, i, result) }

  Parameter getAParameter() { result = this.getParameter(_) }

  int getNumParameters() { result = count(this.getParameter(_)) }

  override Ast getChild(ChildIndex i) {
    i = FunDefStmtBody() and result = this.getBody()
    or
    exists(int index |
      i = FunDefStmtParam(index) and
      result = this.getParameter(index)
    )
  }
}
