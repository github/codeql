private import AstImport

class Member extends Ast, TMember {
  string getName() {
    result = getRawAst(this).(Raw::Member).getName()
    or
    any(Synthesis s).memberName(this, result)
  }

  Type getDeclaringType() { result.getAMember() = this }

  final Attribute getAttribute(int i) {
    exists(ChildIndex index, Raw::Ast r | index = memberAttr(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::Member).getAttribute(i))
    )
  }

  final TypeConstraint getTypeConstraint() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, memberTypeConstraint(), result)
      or
      not synthChild(r, memberTypeConstraint(), _) and
      result = getResultAst(r.(Raw::Member).getTypeConstraint())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = memberAttr(index) and
      result = this.getAttribute(index)
    )
    or
    i = memberTypeConstraint() and
    result = this.getTypeConstraint()
  }
}
