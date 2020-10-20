import csharp

query predicate countSplits(ControlFlowElement cfe, int i) {
  i = strictcount(ControlFlow::Nodes::ElementNode n | n.getElement() = cfe and cfe.fromSource())
}

query predicate ssaDef(Ssa::Definition def) { def.getLocation().getFile().fromSource() }
