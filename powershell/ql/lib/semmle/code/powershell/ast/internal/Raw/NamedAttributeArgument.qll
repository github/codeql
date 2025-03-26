private import Raw

class NamedAttributeArgument extends @named_attribute_argument, Ast {
  final override SourceLocation getLocation() { named_attribute_argument_location(this, result) }

  string getName() { named_attribute_argument(this, result, _) }

  predicate hasName(string s) { this.getName() = s }

  Expr getValue() { named_attribute_argument(this, _, result) }

  final override Ast getChild(ChildIndex i) {
    i = NamedAttributeArgVal() and result = this.getValue()
  }
}

class ValueFromPipelineAttribute extends NamedAttributeArgument {
  ValueFromPipelineAttribute() { this.getName() = "ValueFromPipeline" }
}

class ValueFromPipelineByPropertyName extends NamedAttributeArgument {
  ValueFromPipelineByPropertyName() { this.getName() = "ValueFromPipelineByPropertyName" }
}
