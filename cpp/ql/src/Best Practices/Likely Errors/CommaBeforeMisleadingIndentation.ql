/**
 * @name Comma before misleading indentation
 * @description If expressions before and after a comma operator use different indentation, it is easy to misread the purpose of the code.
 * @kind problem
 * @id cpp/comma-before-misleading-indentation
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @tags maintainability
 *       readability
 *       security
 *       external/cwe/cwe-1078
 *       external/cwe/cwe-670
 */

import cpp
import semmle.code.cpp.commons.Exclusions

/**
 * Gets a child of `e`, including conversions but excluding call arguments.
 */
pragma[inline]
Expr getAChildWithConversions(Expr e) {
  result.getParentWithConversions() = e and
  not result = any(Call c).getAnArgument()
}

/**
 * Gets the left-most column position of any transitive child of `e` (including
 * conversions but excluding call arguments).
 */
int getCandidateColumn(Expr e) {
  result = e.getLocation().getStartColumn() or
  result = getCandidateColumn(getAChildWithConversions(e))
}

/**
 * Gets the transitive child of `e` (including conversions but excluding call
 * arguments) at the left-most column position, preferring less deeply nested
 * expressions if there is a choice.
 */
Expr normalizeExpr(Expr e) {
  e.getLocation().getStartColumn() = min(getCandidateColumn(e)) and
  result = e
  or
  not e.getLocation().getStartColumn() = min(getCandidateColumn(e)) and
  result = normalizeExpr(getAChildWithConversions(e)) and
  result.getLocation().getStartColumn() = min(getCandidateColumn(e))
}

predicate isParenthesized(CommaExpr ce) {
  ce.getParent*().(Expr).isParenthesised()
  or
  ce.isUnevaluated() // sizeof(), decltype(), alignof(), noexcept(), typeid()
  or
  ce.getParent*() = [any(IfStmt i).getCondition(), any(SwitchStmt s).getExpr()]
  or
  ce.getParent*() = [any(Loop l).getCondition(), any(ForStmt f).getUpdate()]
  or
  ce.getEnclosingStmt() = any(ForStmt f).getInitialization()
}

from CommaExpr ce, Expr left, Expr right, Location leftLoc, Location rightLoc
where
  ce.fromSource() and
  not isFromMacroDefinition(ce) and
  left = normalizeExpr(ce.getLeftOperand().getFullyConverted()) and
  right = normalizeExpr(ce.getRightOperand().getFullyConverted()) and
  leftLoc = left.getLocation() and
  rightLoc = right.getLocation() and
  not isParenthesized(ce) and
  leftLoc.getEndLine() < rightLoc.getStartLine() and
  leftLoc.getStartColumn() > rightLoc.getStartColumn()
select right, "The indentation level may be misleading for some tab sizes."
