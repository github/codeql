private import codeql.swift.printast.PrintAstNode

query predicate doubleChildren(
  PrintAstNode parent, int index, PrintAstNode child1, PrintAstNode child2
) {
  child1 != child2 and
  parent.hasChild(child1, index, _) and
  parent.hasChild(child2, index, _)
}

query predicate doubleIndexes(PrintAstNode parent, int index1, int index2, PrintAstNode child) {
  index1 != index2 and
  parent.hasChild(child, index1, _) and
  parent.hasChild(child, index2, _)
}

query predicate doubleParents(PrintAstNode parent1, PrintAstNode parent2, PrintAstNode child) {
  parent1 != parent2 and
  parent1.hasChild(child, _, _) and
  parent2.hasChild(child, _, _)
}

private predicate isChildOf(PrintAstNode parent, PrintAstNode child) {
  parent.hasChild(child, _, _)
}

query predicate parentChildLoops(PrintAstNode parent, PrintAstNode child) {
  isChildOf(parent, child) and isChildOf*(child, parent)
}
