import powershell

class Parameter extends @parameter, Ast {
  override string toString() { result = this.getName().toString() }

  string getName() {
    exists(@variable_expression ve |
      parameter(this, ve, _, _) and
      variable_expression(ve, result, _, _, _, _, _, _, _, _, _, _)
    )
  }

  string getStaticType() { parameter(this, _, result, _) }

  int getNumAttributes() { parameter(this, _, _, result) }

  AttributeBase getAttribute(int i) { parameter_attribute(this, i, result) }

  AttributeBase getAnAttribute() { result = this.getAttribute(_) }

  Expr getDefaultValue() { parameter_default_value(this, result) }

  override SourceLocation getLocation() { parameter_location(this, result) }
}
