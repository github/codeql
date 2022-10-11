class AstNodeWithSymbol extends @ast_node_with_symbol {
  string toString() { none() }
}

class Symbol extends @symbol {
  string toString() { none() }
}

from AstNodeWithSymbol node, Symbol symbol
where ast_node_symbol(node, symbol) and not node instanceof @external_module_declaration
select node, symbol
