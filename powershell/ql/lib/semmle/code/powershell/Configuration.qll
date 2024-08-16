import powershell

class Configuration extends @configuration_definition, Stmt {
  override SourceLocation getLocation() { configuration_definition_location(this, result) }

  override string toString() { result = "Configuration" }

  Expr getName() { configuration_definition(this, _, _, result) } // TODO: Change @ast to @expression in dbscheme

  ScriptBlockExpr getBody() { configuration_definition(this, result, _, _) } // TODO: Change @ast to @script_block in dbscheme

  predicate isMeta() { configuration_definition(this, _, 1, _) }

  predicate isResource() { configuration_definition(this, _, 0, _) }
}
