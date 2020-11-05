import csharp

private predicate isRealRefTypeConstraint(Type t) {
  t instanceof RefType and
  not t instanceof Interface
}

query predicate refType(TypeParameter tp) {
  tp.fromSource() and
  (
    not exists(tp.getConstraints())
    or
    tp.getConstraints().hasRefTypeConstraint()
    or
    tp.getConstraints().hasNullableRefTypeConstraint()
    or
    isRealRefTypeConstraint(tp.getConstraints().getATypeConstraint())
  )
}

query predicate valueType(TypeParameter tp) {
  tp.fromSource() and
  (
    not exists(tp.getConstraints()) or
    tp.getConstraints().hasValueTypeConstraint() or
    tp.getConstraints().getATypeConstraint() instanceof ValueType
  )
}

query predicate valueOrRefType(TypeParameter tp) {
  tp.fromSource() and
  (
    not exists(tp.getConstraints())
    or
    not tp.getConstraints().hasValueTypeConstraint() and
    not tp.getConstraints().hasRefTypeConstraint() and
    not isRealRefTypeConstraint(tp.getConstraints().getATypeConstraint())
  )
}
