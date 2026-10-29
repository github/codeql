import csharp

query predicate nameof(NameOfExpr e, string parent, string v) {
  e.getFile().getStem() = "NameofScope" and
  e.getParent().toString() = parent and
  v = e.getValue()
}
