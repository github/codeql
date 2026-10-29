class Element extends @element {
  string toString() { none() }
}

newtype TAddedElement =
  TBlockExpr(Element macroBlock) { macro_block_exprs(macroBlock) } or
  TStmtList(Element macroBlock) { macro_block_exprs(macroBlock) }

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_block_exprs(NewElement id) {
  block_exprs(id) or
  id = Fresh::map(TBlockExpr(_))
}

query predicate new_stmt_lists(NewElement id) {
  stmt_lists(id) or
  id = Fresh::map(TStmtList(_))
}

query predicate new_block_expr_stmt_lists(NewElement id, NewElement list) {
  block_expr_stmt_lists(id, list)
  or
  exists(Element macroBlock |
    id = Fresh::map(TBlockExpr(macroBlock)) and
    list = Fresh::map(TStmtList(macroBlock))
  )
}

query predicate new_stmt_list_statements(NewElement id, int index, Element stmt) {
  stmt_list_statements(id, index, stmt)
  or
  exists(Element macroBlock |
    id = Fresh::map(TStmtList(macroBlock)) and
    macro_block_expr_statements(macroBlock, index, stmt)
  )
}

query predicate new_stmt_list_tail_exprs(NewElement id, Element expr) {
  stmt_list_tail_exprs(id, expr)
  or
  exists(Element macroBlock |
    id = Fresh::map(TStmtList(macroBlock)) and
    macro_block_expr_tail_exprs(macroBlock, expr)
  )
}

query predicate new_macro_call_macro_call_expansions(NewElement id, NewElement expansion) {
  macro_call_macro_call_expansions(id, expansion) and
  not macro_block_exprs(expansion)
  or
  exists(Element macroBlock |
    expansion = Fresh::map(TBlockExpr(macroBlock)) and
    macro_call_macro_call_expansions(id, macroBlock)
  )
}
