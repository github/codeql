import java

query predicate genericType(GenericType t, TypeVariable tv, int i) {
  t.getTypeParameter(i) = tv and t.getFile().getExtension() = "kt"
}

query predicate parameterizedType(ParameterizedType t, GenericType gt, int i, RefType ta) {
  t.getGenericType() = gt and
  t.getTypeArgument(i) = ta and
  t.getFile().getExtension() = "kt"
}

query predicate genericFunction(GenericCallable c, TypeVariable tv, int i) {
  c.getTypeParameter(i) = tv and
  c.getFile().getExtension() = "kt"
}

query predicate genericCall(GenericCall c, TypeVariable tv, Type t) { c.getATypeArgument(tv) = t }

query predicate genericCtor(ClassInstanceExpr c, int i, Type ta) {
  c.getTypeArgument(i).getType() = ta
}
