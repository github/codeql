import javascript

query predicate test_FieldTypes(FieldDeclaration field, TypeExpr res) {
  res = field.getTypeAnnotation()
}
