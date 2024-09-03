import go

from NamedType nt, InterfaceType it, Type methodType, string id
where
  nt.getName() = "MixedExportedAndNot" and
  it = nt.getUnderlyingType() and
  methodType = it.getMethodTypeById(id)
select it.pp(), methodType.pp(), id
