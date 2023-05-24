private import codeql.swift.printast.PrintAstNode

query predicate doubleChildren(
  PrintAstNode parent, int index, string label1, PrintAstNode child1, string label2,
  PrintAstNode child2
) {
  child1 != child2 and
  parent.hasChild(child1, index, label1) and
  parent.hasChild(child2, index, label2)
}

query predicate doubleIndexes(
  PrintAstNode parent, int index1, string label1, int index2, string label2, PrintAstNode child
) {
  index1 != index2 and
  parent.hasChild(child, index1, label1) and
  parent.hasChild(child, index2, label2)
}

query predicate doubleParents(
  PrintAstNode parent1, string label1, PrintAstNode parent2, string label2, PrintAstNode child
) {
  parent1 != parent2 and
  parent1.hasChild(child, _, label1) and
  parent2.hasChild(child, _, label2)
}

private predicate isChildOf(PrintAstNode parent, PrintAstNode child) {
  parent.hasChild(child, _, _)
}

query predicate parentChildLoops(PrintAstNode parent, PrintAstNode child) {
  isChildOf(parent, child) and isChildOf*(child, parent)
}
