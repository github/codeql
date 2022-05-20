import csharp

query predicate assignedMembers(AssignableMember member, Expr value) {
  member.fromSource() and
  value = member.getAnAssignedValue()
}

query predicate indexerCalls(IndexerCall indexer, int arg, Expr value) {
  value = indexer.getArgument(arg)
}

query predicate elementAssignments(
  ElementWrite write, Assignment assignment, int index, Expr indexer
) {
  write = assignment.getLValue() and indexer = write.getIndex(index)
}

query predicate arrayQualifiers(ElementAccess access, Expr qualifier) {
  qualifier = access.getQualifier()
}

query predicate initializers(ObjectInitializer init, int item, Expr expr) {
  expr = init.getMemberInitializer(item)
}

query predicate initializerType(ObjectInitializer init, string type) {
  type = init.getType().toStringWithTypes()
}
