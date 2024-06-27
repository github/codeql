import java

query predicate classTVs(TypeVariable tv, GenericType declType, string bound) {
  tv.getGenericType() = declType and
  tv.getUpperBoundType().toString() = bound and
  declType.fromSource()
}

query predicate functionTVs(TypeVariable tv, GenericCallable callable, string bound) {
  tv.getGenericCallable() = callable and
  tv.getUpperBoundType().toString() = bound and
  callable.fromSource()
}
