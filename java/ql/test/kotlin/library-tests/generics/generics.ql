import java

query predicate genericType(GenericType t, TypeVariable tv, int i) { t.getTypeParameter(i) = tv }

query predicate parameterizedType(ParameterizedType t, GenericType gt, int i, RefType ta) {
  t.getGenericType() = gt and
  t.getTypeArgument(i) = ta
}

query predicate genericFunction(GenericCallable c, TypeVariable tv, int i) {
  c.getTypeParameter(i) = tv
}

query predicate genericCall(GenericCall c, TypeVariable tv, Type t) { c.getATypeArgument(tv) = t }

query predicate genericCtor(ClassInstanceExpr c, int i, Type ta) {
  c.getTypeArgument(i).getType() = ta
}
