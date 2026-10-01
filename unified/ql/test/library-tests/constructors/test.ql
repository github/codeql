import unified

query predicate generatedConstructor(ConstructorDeclaration c) {
  c = any(ClassLikeDeclaration cls | cls.fromSource()).getAMember() and
  c.hasModifier("generated")
}
