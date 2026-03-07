import go

// This is a consistency check that the overlay mechanism for cleaning up locations
// works correctly.
query predicate elementsWithMultipleLocations(AstNode an, Location loc) {
  strictcount(Location l0 | l0 = an.getLocation()) > 1 and
  loc = an.getLocation()
}

query predicate commentLinesWithMultipleLocations(Comment cl, Location loc) {
  strictcount(Location l0 | l0 = cl.getLocation()) > 1 and
  loc = cl.getLocation()
}

query predicate commentBlocksWithMultipleLocations(CommentGroup cb, Location loc) {
  strictcount(Location l0 | l0 = cb.getLocation()) > 1 and
  loc = cb.getLocation()
}

// This is a consistency check that the entities that are removed as a part of
// the changes in the overlay are indeed removed from the database.
query predicate removedEntities(Function f) { f.getName() = ["FuncA", "GetNameLength"] }
