import java

query predicate classLocations(string name, Location location) {
  exists(Class type |
    type.getQualifiedName() = name and
    type.getSourceDeclaration().getName() in ["A", "B"] and
    hasLocation(type, location)
  )
}

query predicate callableLocations(string name, Location location) {
  exists(Callable callable |
    callable.getQualifiedName() = name and
    callable.getName() = "fn" and
    hasLocation(callable, location)
  )
}
