private import AstImport

class NamedAttributeArgument extends Ast, TNamedAttributeArgument {
  final override string toString() { result = this.getName() }

  string getName() { result = getRawAst(this).(Raw::NamedAttributeArgument).getName() }

  predicate hasName(string s) { this.getName() = s }

  Expr getValue() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, namedAttributeArgVal(), result)
      or
      not synthChild(r, namedAttributeArgVal(), _) and
      result = getResultAst(r.(Raw::NamedAttributeArgument).getValue())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = namedAttributeArgVal() and result = this.getValue()
  }
}
