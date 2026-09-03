import unified

query predicate identifier(Identifier node, string value) { value = node.getValue() }

query predicate namedPattern(NamedPattern node, string value) {
  value = node.getNameNode().getValue()
}

query predicate unsupported(UnsupportedNode node, string value) { value = node.getValue() }

query predicate stringValue(StringLiteral e, string value) { value = e.getValue() }
