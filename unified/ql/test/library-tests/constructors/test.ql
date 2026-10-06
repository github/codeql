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

query predicate callableExDefaultConstructorParameter(
  ConstructorDeclaration cd, int i, ParameterEx p, string name
) {
  p.isDefaultConstructorParameter(cd, i, name) and
  cd.getFile().fromSource()
}
