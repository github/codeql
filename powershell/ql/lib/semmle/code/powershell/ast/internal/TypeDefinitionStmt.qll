private import AstImport

class TypeDefinitionStmt extends Stmt, TTypeDefinitionStmt {
  string getName() { result = getRawAst(this).(Raw::TypeStmt).getName() }

  override string toString() { result = this.getName() }

  Member getMember(int i) {
    exists(ChildIndex index, Raw::Ast r | index = typeStmtMember(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::TypeStmt).getMember(i))
    )
  }

  Member getAMember() { result = this.getMember(_) }

  Method getMethod(string name) {
    result = getResultAst(getRawAst(this).(Raw::TypeStmt).getMethod(name))
  }

  Method getAMethod() { result = this.getMethod(_) }

  Constructor getAConstructor() {
    result = this.getAMethod() and
    result.getName() = this.getName()
  }

  TypeConstraint getBaseType(int i) {
    exists(ChildIndex index, Raw::Ast r | index = typeStmtBaseType(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::TypeStmt).getBaseType(i))
    )
  }

  TypeConstraint getABaseType() { result = this.getBaseType(_) }

  TypeDefinitionStmt getASubtype() { result.getABaseType().getName() = this.getName() }

  Type getType() { synthChild(getRawAst(this), typeDefType(), result) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = typeDefType() and result = this.getType()
  }
}
