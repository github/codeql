import csharp

predicate structDefaultConstructors(Struct struct, Constructor c) {
  struct.getAConstructor() = c and
  struct.getFile().getBaseName() = "StructTypes.cs" and
  c.hasNoParameters()
}

query predicate structAllDefaultConstructors(Struct struct, Constructor c) {
  structDefaultConstructors(struct, c)
}

query predicate structFromSourceDefaultConstructors(Struct struct, Constructor c) {
  structDefaultConstructors(struct, c) and c.fromSource()
}
