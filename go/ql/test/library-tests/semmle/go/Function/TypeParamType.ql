import go

query predicate numberOfTypeParameters(TypeParamParentEntity parent, int n) {
  exists(parent.getLocation().getFile()) and
  n = strictcount(TypeParamType tpt | tpt.getParent() = parent)
}

from TypeParamType tpt, TypeParamParentEntity ty
where ty = tpt.getParent()
select ty.getQualifiedName(), tpt.getIndex(), tpt.getParamName(), tpt.getConstraint().pp()
