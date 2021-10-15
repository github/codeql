import javascript

query string test_getAReferenceTo(DataFlow::Node node) {
  node = AccessPath::getAReferenceTo(result)
}

query string test_getAnAssignmentTo(DataFlow::Node node) {
  node = AccessPath::getAnAssignmentTo(result)
}

query string test_assignedUnique() { AccessPath::isAssignedInUniqueFile(result) }

query DataFlow::PropRead hasDominatingWrite() {
  AccessPath::DominatingPaths::hasDominatingWrite(result)
}
