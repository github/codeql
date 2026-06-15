import csharp

private predicate isInteresting(Type t) {
  (
    t instanceof Class or
    t instanceof Interface or
    t instanceof Struct or
    t instanceof Enum or
    t instanceof DelegateType or
    t instanceof RecordType
  ) and
  t.getFile().getStem().matches("FileScoped%")
}

query predicate typemodifiers(Type t, string modifier) {
  isInteresting(t) and
  t.(Modifiable).hasModifier(modifier)
}

query predicate qualifiedtypes(Type t, string qualifiedName) {
  isInteresting(t) and
  qualifiedName = t.getFullyQualifiedNameDebug()
}

query predicate filetypes(Type t) {
  isInteresting(t) and
  t.isFile()
}

query predicate internaltypes(Type t) {
  isInteresting(t) and
  t.isInternal()
}

query predicate publictypes(Type t) {
  isInteresting(t) and
  t.isPublic()
}
