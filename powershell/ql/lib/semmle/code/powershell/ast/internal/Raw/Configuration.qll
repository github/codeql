private import Raw

class Configuration extends @configuration_definition, Stmt {
  override SourceLocation getLocation() { configuration_definition_location(this, result) }

  Expr getName() { configuration_definition(this, _, _, result) }

  ScriptBlockExpr getBody() { configuration_definition(this, result, _, _) }

  final override Ast getChild(ChildIndex i) {
    i = ConfigurationName() and
    result = this.getName()
    or
    i = ConfigurationBody() and
    result = this.getBody()
  }

  predicate isMeta() { configuration_definition(this, _, 1, _) }

  predicate isResource() { configuration_definition(this, _, 0, _) }
}
