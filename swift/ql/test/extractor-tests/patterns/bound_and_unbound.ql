import swift

query predicate bound(NamedPattern p) {
  p.getFile().getBaseName() = "patterns.swift" and
  p.hasVarDecl()
}

query predicate unbound(NamedPattern p) {
  p.getFile().getBaseName() = "patterns.swift" and
  not p.hasVarDecl()
}
