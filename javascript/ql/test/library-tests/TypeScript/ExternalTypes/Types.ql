import javascript

string getDefinition(TypeReference ref) {
  if exists(ref.getADefinition())
  then result = "defined in " + ref.getADefinition().getFile().getBaseName()
  else result = "has no definition"
}

from TypeReference type
where not type.hasTypeArguments()
select type, getDefinition(type)
