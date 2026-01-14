class Element extends @element {
  string toString() { none() }
}

newtype TAddedElement =
  TMacroBlockExpr(Element block) {
    block_exprs(block) and macro_call_macro_call_expansions(_, block)
  }

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_macro_block_exprs(NewElement id) { id = Fresh::map(TMacroBlockExpr(_)) }

query predicate new_macro_block_expr_statements(NewElement id, int index, Element stmt) {
  exists(Element block, Element list |
    id = Fresh::map(TMacroBlockExpr(block)) and
    block_expr_stmt_lists(block, list) and
    stmt_list_statements(list, index, stmt)
  )
}

query predicate new_macro_block_expr_tail_exprs(NewElement id, Element expr) {
  exists(Element block, Element list |
    id = Fresh::map(TMacroBlockExpr(block)) and
    block_expr_stmt_lists(block, list) and
    stmt_list_tail_exprs(list, expr)
  )
}

query predicate new_block_exprs(Element id) {
  block_exprs(id) and
  not macro_call_macro_call_expansions(_, id)
}

query predicate new_stmt_lists(Element id) {
  stmt_lists(id) and
  not exists(Element block |
    macro_call_macro_call_expansions(_, block) and
    block_expr_stmt_lists(block, id)
  )
}

query predicate new_block_expr_stmt_lists(Element id, Element list) {
  block_expr_stmt_lists(id, list) and
  not macro_call_macro_call_expansions(_, id)
}

query predicate new_stmt_list_statements(Element id, int index, Element stmt) {
  stmt_list_statements(id, index, stmt) and
  not exists(Element block |
    macro_call_macro_call_expansions(_, block) and
    block_expr_stmt_lists(block, id)
  )
}

query predicate new_stmt_list_tail_exprs(Element id, Element expr) {
  stmt_list_tail_exprs(id, expr) and
  not exists(Element block |
    macro_call_macro_call_expansions(_, block) and
    block_expr_stmt_lists(block, id)
  )
}

query predicate new_macro_call_macro_call_expansions(NewElement id, NewElement expansion) {
  macro_call_macro_call_expansions(id, expansion) and
  not block_exprs(expansion)
  or
  exists(Element block |
    expansion = Fresh::map(TMacroBlockExpr(block)) and
    macro_call_macro_call_expansions(id, block)
  )
}
