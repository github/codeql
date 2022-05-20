import csharp

query predicate refType(TypeParameter tp) {
  tp.getFile().getStem() = "TypeParameterNullability" and
  tp.isRefType()
}

query predicate valueType(TypeParameter tp) {
  tp.getFile().getStem() = "TypeParameterNullability" and
  tp.isValueType()
}

query predicate valueOrRefType(TypeParameter tp) {
  tp.getFile().getStem() = "TypeParameterNullability" and
  not tp.isRefType() and
  not tp.isValueType()
}
