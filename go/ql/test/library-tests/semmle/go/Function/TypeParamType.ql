import go

from TypeParamType tpt
select tpt.getParamName(), tpt.getConstraint().pp()
