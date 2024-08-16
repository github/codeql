import powershell

class FunctionMember extends @function_member, Member {
  override string getName() { function_member(this, _, _, _, _, _, _, result, _) }

  override SourceLocation getLocation() { function_member_location(this, result) }

  override string toString() { result = this.getName() }

  ScriptBlock getBody() { function_member(this, result, _, _, _, _, _, _, _) }

  override predicate isHidden() { function_member(this, _, _, true, _, _, _, _, _) }

  override predicate isPrivate() { function_member(this, _, _, _, true, _, _, _, _) }

  override predicate isPublic() { function_member(this, _, _, _, _, true, _, _, _) }

  override predicate isStatic() { function_member(this, _, _, _, _, _, true, _, _) }

  predicate isConstructor() { function_member(this, _, true, _, _, _, _, _, _) }

  Parameter getParameter(int i) { function_member_parameter(this, i, result) }

  Parameter getAParameter() { result = this.getParameter(_) }

  TypeConstraint getTypeConstraint() { function_member_return_type(this, result) }
}

class Constructor extends FunctionMember {
  Constructor() { this.isConstructor() }
}
