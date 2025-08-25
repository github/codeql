import go

from DefinedType dt, InterfaceType it, Type methodType, string id
where
  dt.getName() = "MixedExportedAndNot" and
  it = dt.getUnderlyingType() and
  (
    it.hasPrivateMethodWithQualifiedName(_, id, methodType)
    or
    it.hasMethod(id, methodType) and not it.hasPrivateMethodWithQualifiedName(id, _, _)
  )
select it.pp(), methodType.pp(), id
