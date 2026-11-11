import unified
import codeql.unified.internal.ParameterEx

query predicate generatedConstructor(ConstructorDeclaration c) {
  c = any(ClassLikeDeclaration cls | cls.fromSource()).getAMember() and
  c.hasModifier("generated")
}

query predicate implicitReceiverParameter(ParameterEx p, Callable c) {
  p.isImplicitReceiverParameter(c) and
  c.getFile().fromSource()
}

query predicate defaultConstructorParameter(
  ConstructorDeclaration cd, int i, ParameterEx p, string name, boolean hasDefault
) {
  p.isDefaultConstructorParameter(cd, i, name) and
  cd.getFile().fromSource() and
  if p.hasDefault() then hasDefault = true else hasDefault = false
}

query predicate defaultConstructorParameterType(
  ConstructorDeclaration cd, int i, ParameterEx p, string name, AstNode type
) {
  defaultConstructorParameter(cd, i, p, name, _) and
  type = p.getType()
}
