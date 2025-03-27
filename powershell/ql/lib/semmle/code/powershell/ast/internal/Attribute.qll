private import AstImport

class Attribute extends AttributeBase, TAttribute {
  string getName() { result = getRawAst(this).(Raw::Attribute).getName() }

  NamedAttributeArgument getNamedArgument(int i) {
    exists(ChildIndex index, Raw::Ast r | index = attributeNamedArg(i) and r = getRawAst(this) |
      synthChild(r, attributeNamedArg(i), result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::Attribute).getNamedArgument(i))
    )
  }

  NamedAttributeArgument getANamedArgument() { result = this.getNamedArgument(_) }

  int getNumberOfArguments() { result = count(this.getAPositionalArgument()) }

  Expr getPositionalArgument(int i) {
    exists(ChildIndex index, Raw::Ast r | index = attributePosArg(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::Attribute).getPositionalArgument(i))
    )
  }

  Expr getAPositionalArgument() { result = this.getPositionalArgument(_) }

  int getNumberOfPositionalArguments() { result = count(this.getAPositionalArgument()) }

  private string toStringSpecific() {
    not exists(this.getAPositionalArgument()) and
    result = unique( | | this.getANamedArgument()).getName()
    or
    not exists(this.getANamedArgument()) and
    result = unique( | | this.getANamedArgument()).getName()
  }

  override string toString() {
    result = this.toStringSpecific()
    or
    not exists(this.toStringSpecific()) and
    result = this.getName()
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = attributeNamedArg(index) and
      result = this.getNamedArgument(index)
      or
      i = attributePosArg(index) and
      result = this.getPositionalArgument(index)
    )
  }
}
