import go

from TypeParamType tpt, TypeEntity te, string filepath
where
  te = tpt.getEntity() and
  te.hasLocationInfo(filepath, _, _, _, _) and
  filepath != ""
select tpt.getParamName(), tpt.getConstraint().pp()
