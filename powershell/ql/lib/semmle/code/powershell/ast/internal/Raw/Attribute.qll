private import Raw

class Attribute extends @attribute, AttributeBase {
  override SourceLocation getLocation() { attribute_location(this, result) }

  string getName() { attribute(this, result, _, _) }

  int getNumNamedArguments() { attribute(this, _, result, _) }

  int getNumPositionalArguments() { attribute(this, _, _, result) }

  NamedAttributeArgument getNamedArgument(int i) { attribute_named_argument(this, i, result) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = AttributeNamedArg(index) and
      result = this.getNamedArgument(index)
      or
      i = AttributePosArg(index) and
      result = this.getPositionalArgument(index)
    )
  }

  NamedAttributeArgument getANamedArgument() { result = this.getNamedArgument(_) }

  int getNumberOfArguments() { result = count(this.getAPositionalArgument()) }

  Expr getPositionalArgument(int i) { attribute_positional_argument(this, i, result) }

  Expr getAPositionalArgument() { result = this.getPositionalArgument(_) }

  int getNumberOfPositionalArguments() { result = count(this.getAPositionalArgument()) }
}
