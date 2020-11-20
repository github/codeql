import csharp

query predicate refType(TypeParameter tp) {
  tp.fromSource() and
  tp.isRefType()
}

query predicate valueType(TypeParameter tp) {
  tp.fromSource() and
  tp.isValueType()
}

query predicate valueOrRefType(TypeParameter tp) {
  tp.fromSource() and
  not tp.isRefType() and
  not tp.isValueType()
}
