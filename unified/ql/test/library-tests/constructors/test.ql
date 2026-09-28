import unified
import codeql.unified.internal.CallableEx

query predicate callableExDefaultConstructor(CallableEx c) {
  c.isDefaultConstructor(any(ClassLikeDeclaration cls | cls.fromSource()))
}

query predicate callableExDefaultConstructorParameter(CallableEx c, int i, ParameterEx p) {
  callableExDefaultConstructor(c) and
  p = c.getParameter(i)
}

query predicate callableExInheritedConstructor(CallableEx c, CallableEx base) {
  c.isInheritedConstructor(any(ClassLikeDeclaration cls | cls.fromSource()), base)
}

query predicate callableExInheritedConstructorParameter(
  CallableEx c, int i, ParameterEx p, ParameterEx rootParam
) {
  exists(CallableEx base |
    callableExInheritedConstructor(c, base) and
    p = c.getParameter(i)
  |
    rootParam = base.getParameter(i) and
    not rootParam.isInheritedConstructorParameter(_, _, _)
    or
    callableExInheritedConstructorParameter(base, i, _, rootParam)
  )
}
