import csharp

query predicate typeParameterContraints(TypeParameter tp, TypeParameterConstraints tpc) {
  tp.fromSource() and tp.getConstraints() = tpc
}

query predicate specificParameterConstraints(TypeParameter tp, string type) {
  exists(TypeParameterConstraints tpc |
    typeParameterContraints(tp, tpc) and type = tpc.getATypeConstraint().toStringWithTypes()
  )
}

query predicate hasConstructorConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasConstructorConstraint()
}

query predicate hasRefTypeConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasRefTypeConstraint()
}

query predicate hasValueTypeConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasValueTypeConstraint()
}

query predicate hasUnmanagedTypeConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasUnmanagedTypeConstraint()
}

query predicate hasNullableRefTypeConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasNullableRefTypeConstraint()
}

query predicate hasNotNullConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasNotNullTypeConstraint()
}

query predicate hasAllowRefLikeTypeConstraint(TypeParameter tp, TypeParameterConstraints tpc) {
  typeParameterContraints(tp, tpc) and tpc.hasAllowRefLikeTypeConstraint()
}
