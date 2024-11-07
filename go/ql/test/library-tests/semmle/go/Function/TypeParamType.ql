import go

query predicate numberOfTypeParameters(TypeParamParentEntity parent, int n) {
  exists(string file | file != "" | parent.hasLocationInfo(file, _, _, _, _)) and
  n = strictcount(TypeParamType tpt | tpt.getParent() = parent)
}

from TypeParamType tpt, TypeParamParentEntity ty
where ty = tpt.getParent()
select ty.getQualifiedName(), tpt.getIndex(), tpt.getParamName(), tpt.getConstraint().pp()
