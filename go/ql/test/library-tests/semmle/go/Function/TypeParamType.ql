import go

query predicate numberOfTypeParameters(TypeParamParentEntity parent, int n) {
  exists(parent.getLocation().getFile()) and
  n = strictcount(TypeParamType tpt | tpt.getParent() = parent)
}

from TypeParamType tpt, TypeParamParentEntity ty, string fr
where
  ty = tpt.getParent() and
  // Note that we cannot use the location of `tpt` itself as we currently fail
  // to extract an object for type parameters for methods on generic structs.
  exists(ty.getLocation()) and
  if tpt.isFromReceiver() then fr = "from receiver" else fr = ""
select ty.getQualifiedName(), tpt.getIndex(), fr, tpt.getParamName(), tpt.getConstraint().pp()
