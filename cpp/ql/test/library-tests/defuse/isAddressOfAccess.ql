import cpp

from VariableAccess va, string description
where
  if va.isAddressOfAccessNonConst()
  then description = "non-const address"
  else
    if va.isAddressOfAccess()
    then description = "const address"
    else description = ""
select va, description
