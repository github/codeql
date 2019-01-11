import javascript

from TypeReference type, string globalName
where
  type.hasQualifiedName(globalName) and
  not type.hasTypeArguments()
select globalName, type
