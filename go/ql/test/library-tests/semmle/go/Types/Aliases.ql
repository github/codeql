import go

string getQualifiedNameIfExists(Type t) {
  if exists(t.getQualifiedName()) then result = t.getQualifiedName() else result = t.getName()
}

from AliasType at
where at.hasLocationInfo(_, _, _, _, _)
select getQualifiedNameIfExists(at), getQualifiedNameIfExists(at.getRhs()),
  getQualifiedNameIfExists(at.getUnderlyingType())
