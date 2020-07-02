import javascript

query StringOps::Concatenation concatenation() { any() }

query StringOps::ConcatenationOperand concatenationOperand() { any() }

query StringOps::ConcatenationLeaf concatenationLeaf() { any() }

query StringOps::ConcatenationNode concatenationNode() { any() }

query predicate operand(StringOps::ConcatenationNode node, int i, DataFlow::Node child) {
  child = node.getOperand(i)
}

query predicate nextLeaf(StringOps::ConcatenationNode node, DataFlow::Node next) {
  next = node.getNextLeaf()
}

query StringOps::HtmlConcatenationRoot htmlRoot() { any() }

query StringOps::HtmlConcatenationLeaf htmlLeaf() { any() }

query string getStringValue(Expr e) {
  result = e.getStringValue() and
  e.getEnclosingFunction().getName() = "stringValue"
}
