import javascript

from TypeReference type, string moduleName, string exportedName
where
  type.hasQualifiedName(moduleName, exportedName) and
  not type.hasTypeArguments()
select moduleName, exportedName, type
