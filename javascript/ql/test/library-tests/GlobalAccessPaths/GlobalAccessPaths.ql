import javascript

query string test_fromReference(DataFlow::Node node) {
  result = GlobalAccessPath::fromReference(node)
}

query string test_fromRhs(DataFlow::Node node) { result = GlobalAccessPath::fromRhs(node) }

query string test_assignedUnique() { GlobalAccessPath::isAssignedInUniqueFile(result) }
