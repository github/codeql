import java

query predicate genericType(GenericType t, TypeVariable tv, int i) {
  t.getTypeParameter(i) = tv and t.getFile().isKotlinSourceFile()
}

query predicate parameterizedType(ParameterizedType t, GenericType gt, int i, string ta) {
  t.getGenericType() = gt and
  t.getTypeArgument(i).toString() = ta and
  t.getFile().isKotlinSourceFile()
}

query predicate function(Callable c, string signature) {
  signature = c.getSignature() and
  c.getFile().isKotlinSourceFile()
}

query predicate genericFunction(GenericCallable c, RefType declType, TypeVariable tv, int i) {
  c.getTypeParameter(i) = tv and
  c.getFile().isKotlinSourceFile() and
  c.getDeclaringType() = declType
}

query predicate genericCall(GenericCall c, TypeVariable tv, string t) {
  c.getATypeArgument(tv).toString() = t
}

query predicate genericCtor(ClassInstanceExpr c, int i, string ta) {
  c.getTypeArgument(i).getType().toString() = ta
}
