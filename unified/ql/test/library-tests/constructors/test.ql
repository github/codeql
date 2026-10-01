import unified
import codeql.unified.internal.CallableEx

query predicate callableExDefaultConstructor(CallableEx c) {
  c.isDefaultConstructor(any(ClassLikeDeclaration cls | cls.fromSource()))
}

query predicate callableExDefaultConstructorParameter(CallableEx c, int i, ParameterEx p) {
  callableExDefaultConstructor(c) and
  p = c.getParameter(i)
}
