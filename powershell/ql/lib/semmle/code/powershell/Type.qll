import powershell

class Type extends @type_definition, Stmt {
  override SourceLocation getLocation() { type_definition_location(this, result) }

  override string toString() { result = this.getName() }

  string getName() { type_definition(this, result, _, _, _, _) }

  Member getMember(int i) { type_definition_members(this, i, result) }

  Member getAMember() { result = this.getMember(_) }

  MemberFunction getMemberFunction(string name) {
    result = this.getAMember() and
    result.hasName(name)
  }

  MemberFunction getAMemberFunction() { result = this.getMemberFunction(_) }
}
