import go

query predicate fieldDeclWithNamedFields(FieldDecl fd, int i, Field f) { fd.getField(i) = f }

query predicate fieldDeclWithEmbeddedField(FieldDecl fd, string tp) {
  fd.isEmbedded() and tp = fd.getType().pp()
}
