import javascript

query predicate optionalFields(FieldDeclaration decl, string text) {
  decl.isOptional() and
  text = decl.getStartLine().getText()
}

string getFieldType(ParameterField field) {
  if exists(field.getTypeAnnotation())
  then result = field.getTypeAnnotation().toString()
  else result = "no type"
}

query predicate parameterFields(ParameterField field, string text, string name, string fieldType) {
  text = field.getStartLine().getText() and
  name = field.getNameExpr().toString() and
  fieldType = getFieldType(field)
}

query predicate privateMembers(MemberDeclaration member, string text) {
  member.isPrivate() and
  text = member.getStartLine().getText()
}

query predicate protectedMembers(MemberDeclaration member, string text) {
  member.isProtected() and
  text = member.getStartLine().getText()
}

query predicate publicKeyword(MemberDeclaration member, string text) {
  member.hasPublicKeyword() and
  text = member.getStartLine().getText()
}

query predicate publicMembers(MemberDeclaration member, string text) {
  member.isPublic() and
  text = member.getStartLine().getText()
}

query predicate readonlyMembers(FieldDeclaration field, string text) {
  field.isReadonly() and
  text = field.getStartLine().getText()
}
