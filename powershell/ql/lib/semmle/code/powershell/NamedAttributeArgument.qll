import powershell

class NamedAttributeArgument extends @named_attribute_argument, Ast {
  final override string toString() { result = this.getName() }

  final override SourceLocation getLocation() { named_attribute_argument_location(this, result) }

  string getName() { named_attribute_argument(this, result, _) }

  Expr getValue() { named_attribute_argument(this, _, result) }
}

class ValueFromPipelineAttribute extends NamedAttributeArgument {
  ValueFromPipelineAttribute() { this.getName() = "ValueFromPipeline" }
}

class ValueFromPipelineByPropertyName extends NamedAttributeArgument {
  ValueFromPipelineByPropertyName() { this.getName() = "ValueFromPipelineByPropertyName" }
}
