import powershell

class Attribute extends @attribute, AttributeBase {
  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { attribute_location(this, result) }

  string getName() { attribute(this, result, _, _) }

  int getNumNamedArguments() { attribute(this, _, result, _) }

  int getNumPositionalArguments() { attribute(this, _, _, result) }

  NamedAttributeArgument getNamedArgument(int i) { attribute_named_argument(this, i, result) }

  NamedAttributeArgument getANamedArgument() { result = this.getNamedArgument(_) }

  int getNumberOfArguments() { result = count(this.getAPositionalArgument()) }

  Expr getPositionalArgument(int i) { attribute_positional_argument(this, i, result) }

  Expr getAPositionalArgument() { result = this.getPositionalArgument(_) }

  int getNumberOfPositionalArguments() { result = count(this.getAPositionalArgument()) }
}
