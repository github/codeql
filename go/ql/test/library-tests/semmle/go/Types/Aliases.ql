import go

string getQualifiedNameIfExists(Type t) {
  if exists(t.getQualifiedName()) then result = t.getQualifiedName() else result = t.pp()
}

from AliasType at, string filepath
where at.hasLocationInfo(filepath, _, _, _, _) and filepath != ""
select getQualifiedNameIfExists(at), getQualifiedNameIfExists(at.getRhs()),
  getQualifiedNameIfExists(at.getUnderlyingType())
