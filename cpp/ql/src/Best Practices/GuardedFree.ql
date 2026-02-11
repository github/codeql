/**
 * @name Guarded Free
 * @description NULL-condition guards before function calls to the memory-deallocation
 *              function free(3) are unnecessary, because passing NULL to free(3) is a no-op.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/guarded-free
 * @tags maintainability
 *       readability
 */

import cpp
import semmle.code.cpp.controlflow.Guards

class FreeCall extends FunctionCall {
  FreeCall() { this.getTarget().hasGlobalName("free") }
}

predicate blockContainsPreprocessorBranches(BasicBlock bb) {
  exists(PreprocessorBranch ppb, Location bbLoc, Location ppbLoc |
    bbLoc = bb.(Stmt).getLocation() and ppbLoc = ppb.getLocation()
  |
    bbLoc.getFile() = ppb.getFile() and
    bbLoc.getStartLine() < ppbLoc.getStartLine() and
    ppbLoc.getEndLine() < bbLoc.getEndLine()
  )
}

/**
 * Holds if `gc` ensures that `v` is non-zero when reaching `bb`, and `bb`
 * contains a single statement which is `fc`.
 */
pragma[nomagic]
private predicate interesting(GuardCondition gc, FreeCall fc, Variable v, BasicBlock bb) {
  gc.ensuresEq(v.getAnAccess(), 0, bb, false) and
  fc.getArgument(0) = v.getAnAccess() and
  bb = fc.getBasicBlock() and
  (
    // No block statement: if (x) free(x);
    bb = fc.getEnclosingStmt()
    or
    // Block statement with a single nested statement: if (x) { free(x); }
    strictcount(bb.(BlockStmt).getAStmt()) = 1
  ) and
  not fc.isInMacroExpansion() and
  not blockContainsPreprocessorBranches(bb) and
  not (gc instanceof BinaryOperation and not gc instanceof ComparisonOperation) and
  not exists(CommaExpr c | c.getAChild*() = fc)
}

/** Holds if `gc` only guards a single block. */
bindingset[gc]
pragma[inline_late]
private predicate guardConditionGuardsUniqueBlock(GuardCondition gc) {
  strictcount(BasicBlock bb | gc.ensuresEq(_, 0, bb, _)) = 1
}

from GuardCondition gc, FreeCall fc, Variable v, BasicBlock bb
where
  interesting(gc, fc, v, bb) and
  guardConditionGuardsUniqueBlock(gc)
select gc, "unnecessary NULL check before call to $@", fc, "free"
