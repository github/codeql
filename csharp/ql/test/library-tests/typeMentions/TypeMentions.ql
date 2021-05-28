import csharp

private predicate matchingLineLoc(TypeMention tm0, TypeMention tm1) {
  tm0.getLocation().getStartLine() = tm1.getLocation().getStartLine() and
  tm0.getLocation().getEndLine() = tm1.getLocation().getEndLine() and
  tm0.getLocation().getStartColumn() = tm1.getLocation().getStartColumn() and
  tm0.getLocation().getEndColumn() = tm1.getLocation().getEndColumn()
}

private predicate matchingFile(TypeMention tm0, TypeMention tm1) {
  tm0.getLocation().getFile().getStem() = tm1.getLocation().getFile().getStem()
}

query predicate typeMentions(TypeMention tm) { any() }

query predicate duplicates(TypeMention tm) {
  exists(TypeMention other |
    matchingLineLoc(other, tm) and
    matchingFile(other, tm) and
    other != tm
  )
}

query predicate diff(TypeMention tm) {
  not exists(TypeMention other |
    matchingLineLoc(other, tm) and
    not matchingFile(other, tm)
  )
}
