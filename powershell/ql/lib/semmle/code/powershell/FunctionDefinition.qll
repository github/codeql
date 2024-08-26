import powershell

class Function extends @function_definition, Stmt {
  override string toString() { result = "FunctionDefinition at: " + this.getLocation().toString() }

  override SourceLocation getLocation() { function_definition_location(this, result) }

  string getName() { function_definition(this, _, result, _, _) }

  ScriptBlock getBody() { function_definition(this, result, _, _, _) }

  predicate isFilter() { function_definition(this, _, _, true, _) }

  predicate isWorkflow() { function_definition(this, _, _, _, true) }

  Parameter getParameter(int i) { function_definition_parameter(this, i, result) }

  Parameter getAParameter() { result = this.getParameter(_) }
}
