import go

from NamedType nt, InterfaceType it, Type methodType, string id
where
  nt.getName() = "MixedExportedAndNot" and
  it = nt.getUnderlyingType() and
  (
    it.hasPrivateMethodWithQualifiedName(_, id, methodType)
    or
    it.hasMethod(id, methodType) and not it.hasPrivateMethodWithQualifiedName(id, _, _)
  )
select it.pp(), methodType.pp(), id
