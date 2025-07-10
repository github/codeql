import javascript

from TypeAnnotation type, string mod, string name
where type.hasQualifiedName(mod, name)
select type, mod, name
