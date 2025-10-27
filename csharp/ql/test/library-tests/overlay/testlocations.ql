import csharp

// This is a consistency check that the overlay mechanism for cleaning up locations
// works correctly.
query predicate elementsWithMultipleSourceLocations(Element e, SourceLocation loc) {
  e.fromSource() and
  not e instanceof Namespace and
  count(SourceLocation l0 | l0 = e.getALocation()) > 1 and
  loc = e.getALocation()
}

query predicate typeMentionsWithMultipleSourceLocations(TypeMention tm, SourceLocation loc) {
  tm.getLocation().getFile().fromSource() and
  count(SourceLocation l0 | l0 = tm.getLocation()) > 1 and
  loc = tm.getLocation()
}

query predicate commentLinesWithMultipleSourceLocations(CommentLine cl, SourceLocation loc) {
  cl.getLocation().getFile().fromSource() and
  count(SourceLocation l0 | l0 = cl.getLocation()) > 1 and
  loc = cl.getLocation()
}

query predicate commentBlocksWithMultipleSourceLocations(CommentBlock cb, SourceLocation loc) {
  cb.getLocation().getFile().fromSource() and
  count(SourceLocation l0 | l0 = cb.getLocation()) > 1 and
  loc = cb.getLocation()
}

// This is a consistency check that the entities that are removed as a part of
// the changes in the overlay are indeed removed from the database.
query predicate removedEntities(Element e) { e.(Method).getName() = "OldMethod" }
