private import AstImport

class Type extends Ast, TTypeSynth {
  override string toString() { result = this.getLowerCaseName() }

  Member getMember(int i) { any(Synthesis s).typeMember(this, i, result) }

  string getLowerCaseName() { any(Synthesis s).typeName(this, result) }

  Member getAMember() { result = this.getMember(_) }

  Method getMethod(string name) { result = this.getAMember() and result.getLowerCaseName() = name }

  Method getAMethod() { result = this.getMethod(_) }

  Constructor getAConstructor() {
    result = this.getAMethod() and
    result.getLowerCaseName() = this.getLowerCaseName()
  }

  TypeConstraint getBaseType(int i) { none() }

  TypeConstraint getABaseType() { result = this.getBaseType(_) }

  Type getASubtype() { none() }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = typeMember(index) and
      result = this.getMember(index)
      or
      i = typeStmtBaseType(index) and
      result = this.getBaseType(index)
    )
  }
}
