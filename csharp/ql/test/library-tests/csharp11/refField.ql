import csharp

query predicate reffields(Field f) {
  f.getFile().getStem() = "Struct" and
  f.isRef()
}

query predicate readonlyreffields(Field f) {
  f.getFile().getStem() = "Struct" and
  f.isReadonlyRef()
}

query predicate readonlyfield(Field f) {
  f.getFile().getStem() = "Struct" and
  f.isReadOnly()
}
