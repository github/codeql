import javascript

from TypeReference type
where
  not exists(type.getProperty(_)) and
  (
    exists(type.getADefinition().(ClassOrInterface).getAField())
    or
    exists(type.getADefinition().(ClassOrInterface).getAMethod())
  )
select type.getTypeName(), "has no properties"
