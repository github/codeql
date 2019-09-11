/**
 * Provides a predicate for identifying unused index variables in loops.
 */

import javascript

/**
 * Holds if `arr` is of the form `base[idx]` and is nested inside loop `fs`.
 */
private predicate arrayIndexInLoop(IndexExpr arr, Variable base, Expr idx, ForStmt fs) {
  arr.getEnclosingStmt().getParentStmt*() = fs.getBody() and
  arr.getBase() = base.getAnAccess() and
  arr.getIndex() = idx
}

/**
 * Gets `e` or a sub-expression `s` resulting from `e` by peeling off unary and binary
 * operators, increments, decrements, type assertions, parentheses, sequence expressions,
 * and assignments.
 */
private Expr unwrap(Expr e) {
  result = e or
  result = unwrap(e.(UpdateExpr).getOperand()) or
  result = unwrap(e.(UnaryExpr).getOperand()) or
  result = unwrap(e.(BinaryExpr).getAnOperand()) or
  result = unwrap(e.getUnderlyingValue())
}

/**
 * Holds if `rel` is a for-loop condition of the form `idx <= v.length`, but all array
 * indices `v[c]` inside the loop body (of which there must be at least one) use a constant
 * index `c` instead of an index based on `idx`.
 */
predicate unusedIndexVariable(RelationalComparison rel, Variable idx, Variable v) {
  exists(ForStmt fs | fs.getTest() = rel |
    unwrap(rel.getLesserOperand()) = idx.getAnAccess() and
    rel.getGreaterOperand().(PropAccess).accesses(v.getAnAccess(), "length") and
    forex(IndexExpr arr, Expr e | arrayIndexInLoop(arr, v, e, fs) | exists(e.getIntValue()))
  )
}
