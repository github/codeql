private import AstImport

class Parameter extends Variable instanceof ParameterImpl {
  string getName() { result = super.getNameImpl() }

  final predicate hasName(string name) { name = this.getName() }

  override Ast getChild(ChildIndex childIndex) {
    result = Variable.super.getChild(childIndex)
    or
    childIndex = paramDefaultVal() and result = this.getDefaultValue()
    or
    exists(int index |
      childIndex = paramAttr(index) and
      result = this.getAttribute(index)
    )
  }

  Expr getDefaultValue() { synthChild(getRawAst(this), paramDefaultVal(), result) }

  AttributeBase getAttribute(int index) { synthChild(getRawAst(this), paramAttr(index), result) }

  AttributeBase getAnAttribute() { result = this.getAttribute(_) }

  predicate hasDefaultValue() { exists(this.getDefaultValue()) }

  FunctionBase getFunction() { result.getAParameter() = this }

  int getIndex() { this.getFunction().getParameter(result) = this }

  /** ..., if any. */
  string getStaticType() { any(Synthesis s).parameterStaticType(this, result) }
}

class ThisParameter extends Parameter instanceof ThisParameterImpl { }

class PipelineParameter extends Parameter {
  PipelineParameter() { any(Synthesis s).isPipelineParameter(this) }
}

class PipelineByPropertyNameParameter extends Parameter {
  PipelineByPropertyNameParameter() {
    exists(NamedAttributeArgument namedAttribute |
      this.getAnAttribute().(Attribute).getANamedArgument() = namedAttribute and
      namedAttribute.getName().toLowerCase() = "valuefrompipelinebypropertyname"
    |
      namedAttribute.getValue().getValue().asBoolean() = true
      or
      not exists(namedAttribute.getValue().getValue().asBoolean())
    )
  }

  string getPropertyName() { result = this.getName() }

  PipelineByPropertyNameIteratorVariable getIteratorVariable() { result.getParameter() = this }
}
