private import Raw

class TypeStmt extends @type_definition, Stmt {
  override SourceLocation getLocation() { type_definition_location(this, result) }

  string getName() { type_definition(this, result, _, _, _, _) }

  Member getMember(int i) { type_definition_members(this, i, result) }

  Member getAMember() { result = this.getMember(_) }

  Method getMethod(string name) {
    result = this.getAMember() and
    result.getName() = name
  }

  TypeConstraint getBaseType(int i) { type_definition_base_type(this, i, result) }

  TypeConstraint getABaseType() { result = this.getBaseType(_) }

  TypeStmt getASubtype() { result.getABaseType().getName() = this.getName() }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = TypeStmtMember(index) and
      result = this.getMember(index)
      or
      i = TypeStmtBaseType(index) and
      result = this.getBaseType(index)
    )
  }
}
