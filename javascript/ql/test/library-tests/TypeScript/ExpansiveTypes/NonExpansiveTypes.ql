import javascript

from TypeReference type
where exists(type.getProperty(_))
select type.getTypeName(), "has properties"
