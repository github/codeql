/**
 * @name Missing return statement
 * @description All functions that are not void should return a value on every exit path.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cpp/missing-return
 * @tags reliability
 *       readability
 *       language-features
 */
import cpp

/* This is slightly subtle: The extractor adds a dummy 'return;' statement for control paths
   that fall off the end of a function. So we can simply look for non-void functions containing
   a non-value carrying return. If the predecessor is a return statement it means that
   the return did not return a value. (If that return was not added by the extractor but by the
   programmer, we can flag it anyway, since this is arguably a bug.) */

predicate functionsMissingReturnStmt(Function f, ControlFlowNode blame) {
                        f.fromSource() and
      not f.getType().getUnderlyingType().getUnspecifiedType() instanceof VoidType and
      exists(ReturnStmt s | f.getAPredecessor() = s | blame = s.getAPredecessor())}

/* If a function has a value-carrying return statement, but the extractor hit a snag
   whilst parsing the value, then the control flow graph will not include the value.
   As such, to avoid embarrassing false positives, we exclude any function which
   wasn't perfectly extracted. */
predicate functionImperfectlyExtracted(Function f) {
  exists(CompilerError e | f.getBlock().getLocation().subsumes(e.getLocation()))
  or
  exists(ErrorExpr ee | ee.getEnclosingFunction() = f)
}

from Stmt stmt, string msg
where
  exists(Function f, ControlFlowNode blame |
    functionsMissingReturnStmt(f, blame) and
    reachable(blame) and
    not functionImperfectlyExtracted(f) and
    (blame = stmt or blame.(Expr).getEnclosingStmt() = stmt) and
    msg = "Function " + f.getName() + " should return a value of type " + f.getType().getName() + " but does not return a value here"
  )
select stmt, msg
