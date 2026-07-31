import unified

query predicate nameExpr(NameExpr node, string value) { value = node.getIdentifier().getValue() }

query predicate unsupported(UnsupportedNode node, string value) { value = node.getValue() }
