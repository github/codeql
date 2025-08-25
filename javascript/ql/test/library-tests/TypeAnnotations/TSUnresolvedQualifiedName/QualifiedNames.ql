import javascript

from TypeAnnotation type, string mod, string name
where type.hasUnderlyingType(mod, name)
select type, mod, name
