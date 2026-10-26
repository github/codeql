import javascript

query predicate test_ChildIndex(AstNode node, string res) {
  exists(AstNode child1, AstNode child2, int index |
    node.getChild(index) = child1 and node.getChild(index) = child2 and child1 != child2
  |
    res = "There are two different children at index " + index.toString()
  )
}
