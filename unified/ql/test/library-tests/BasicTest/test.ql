import codeql.unified.Ast::Unified

query predicate nameExpr(NameExpr node, string value) { value = node.getValue() }

query predicate unsupported(UnsupportedNode node, string value) { value = node.getValue() }
