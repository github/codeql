/**
 * @name Missing return statement
 * @description All functions that are not void should return a value on every exit path.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/missing-return
 * @tags reliability
 *       readability
 *       language-features
 *       external/jsf
 */

import cpp

/*
 * This is slightly subtle: The extractor adds a dummy 'return;' statement for control paths
 * that fall off the end of a function. So we can simply look for non-void functions containing
 * a non-value carrying return. If the predecessor is a return statement it means that
 * the return did not return a value. (If that return was not added by the extractor but by the
 * programmer, we can flag it anyway, since this is arguably a bug.)
 */

predicate functionsMissingReturnStmt(Function f, ControlFlowNode blame) {
  f.fromSource() and
  exists(Type returnType |
    returnType = f.getUnspecifiedType() and
    not returnType instanceof VoidType and
    not returnType instanceof TemplateParameter
  ) and
  exists(ReturnStmt s |
    f.getAPredecessor() = s and
    (
      blame = s.getAPredecessor() and
      count(blame.getASuccessor()) = 1
      or
      blame = s and
      exists(ControlFlowNode pred | pred = s.getAPredecessor() | count(pred.getASuccessor()) != 1)
    )
  )
}

/**
 * If a function has a value-carrying return statement, but the extractor hit a snag
 * whilst parsing the value, then the control flow graph will not include the value.
 * As such, to avoid embarrassing false positives, we exclude any function which
 * wasn't perfectly extracted.
 */
predicate functionImperfectlyExtracted(Function f) {
  exists(CompilerError e | f.getBlock().getLocation().subsumes(e.getLocation()))
  or
  exists(ErrorExpr ee | ee.getEnclosingFunction() = f)
  or
  count(f.getType()) > 1
  or
  // an `AsmStmt` isn't strictly 'imperfectly extracted', but it's beyond the scope
  // of this analysis.
  exists(AsmStmt asm | asm.getEnclosingFunction() = f)
}

from Stmt stmt, string msg, Function f, ControlFlowNode blame
where
  functionsMissingReturnStmt(f, blame) and
  reachable(blame) and
  not functionImperfectlyExtracted(f) and
  not f.isFromUninstantiatedTemplate(_) and
  (blame = stmt or blame.(Expr).getEnclosingStmt() = stmt) and
  msg =
    "Function " + f.getName() + " should return a value of type " + f.getType().getName() +
      " but does not return a value here"
select stmt, msg
