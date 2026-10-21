/**
 * @name Unreachable code
 * @description Code that cannot be reached should be deleted.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id rust/dead-code
 * @tags maintainability
 *       quality
 */

import rust
import codeql.rust.controlflow.ControlFlowGraph

/**
 * Gets the AST node represented by `n`, ignoring transparent parentheses.
 */
private AstNode desugar(AstNode n) {
  result = desugar(n.(ParenExpr).getExpr())
  or
  result = desugar(n.(ParenPat).getPat())
  or
  not n instanceof ParenExpr and
  not n instanceof ParenPat and
  result = n
}

/**
 * Holds if `n` has a node in the reachable control-flow graph.
 *
 * The shared control-flow library only creates nodes for reachable code.
 */
private predicate reachable(AstNode n) {
  any(CfgNode cfg).getAstNode() = desugar(n)
}

/** Holds if normal execution of `n` reaches its after-node. */
private predicate reachesAfter(AstNode n) {
  any(CfgNode cfg).isAfter(desugar(n))
}

/** Holds if `n` is a direct element of a statement list. */
private predicate statementListElement(AstNode n) {
  n = any(StmtList list).getStmtOrExpr(_)
}

/** Holds if `n` is a statement-list element that executes at runtime. */
private predicate runtimeStatementListElement(AstNode n) {
  statementListElement(n) and
  not n instanceof Const and
  not n instanceof Static
}

/** Gets the runtime statement-list element immediately preceding `n`, if any. */
private AstNode getPreviousRuntimeStatementListElement(AstNode n) {
  exists(StmtList list, int i |
    n = list.getStmtOrExpr(i) and
    (
      result = list.getStmtOrExpr(i - 1) and runtimeStatementListElement(result)
      or
      not runtimeStatementListElement(list.getStmtOrExpr(i - 1)) and
      result = getPreviousRuntimeStatementListElement(list.getStmtOrExpr(i - 1))
    )
  )
}

/**
 * Holds if `n` is an `if` expression, possibly wrapped in an expression
 * statement, with an unreachable branch.
 */
private predicate hasUnreachableIfBranch(AstNode n) {
  exists(IfExpr ifExpr, AstNode child |
    (
      ifExpr = n
      or
      ifExpr = n.(ExprStmt).getExpr()
    ) and
    statementListElement(child) and
    child.getParentNode+() = ifExpr and
    not reachable(child)
  )
}

/**
 * Holds if `n` is the first unreachable element in a run of unreachable
 * statement-list elements.
 */
private predicate firstUnreachableStatementListElement(AstNode n) {
  runtimeStatementListElement(n) and
  not reachable(n) and
  (
    not exists(getPreviousRuntimeStatementListElement(n))
    or
    reachesAfter(getPreviousRuntimeStatementListElement(n))
    or
    reachable(getPreviousRuntimeStatementListElement(n)) and
    not hasUnreachableIfBranch(getPreviousRuntimeStatementListElement(n))
  )
}

/**
 * Holds if `macro` is an unreachable macro expression inside a reachable
 * statement-list element. This captures unreachable right-hand sides of
 * short-circuiting expressions without reporting every unreachable subexpression.
 */
private predicate unreachableNestedMacro(MacroExpr macro) {
  not statementListElement(macro) and
  not reachable(macro) and
  exists(AstNode enclosing |
    statementListElement(enclosing) and
    macro.getParentNode*() = enclosing and
    reachable(enclosing)
  ) and
  not exists(AstNode enclosing |
    statementListElement(enclosing) and
    macro.getParentNode*() = enclosing and
    not reachable(enclosing)
  )
}

/** Holds if `n` is the first useful AST node to report as unreachable. */
private predicate firstUnreachable(AstNode n) {
  firstUnreachableStatementListElement(n)
  or
  n instanceof MacroExpr and unreachableNestedMacro(n)
}

from AstNode n
where
  firstUnreachable(n) and
  not n.isFromMacroExpansion() and
  exists(n.getFile().getRelativePath()) // in source
select n, "This code is never reached."
