import csharp

query predicate countSplits(ControlFlowElement cfe, int i) {
  i = strictcount(ControlFlow::Nodes::ElementNode n | n.getElement() = cfe)
}

query predicate ssaDef(Ssa::Definition def) { any() }
