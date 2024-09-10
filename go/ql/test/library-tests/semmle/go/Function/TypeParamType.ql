import go

from TypeParamType tpt, TypeParamParentEntity ty
where ty = tpt.getParent()
select ty.getQualifiedName(), tpt.getIndex(), tpt.getParamName(), tpt.getConstraint().pp()
