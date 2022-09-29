/**
 * @name Comma before misleading indentation
 * @description The expressions before and after the comma operator can be misread because of an unusual difference in start columns.
 * @kind problem
 * @id cpp/comma-before-misleading-indentation
 * @problem.severity warning
 * @precision medium
 * @tags maintainability
 *       readability
 */

import cpp
import semmle.code.cpp.commons.Exclusions

/**
 * Holds if this is an implicit `this`.
 *
 * ThisExpr.isCompilerGenerated() is currently not being extracted, so use a heuristic.
 */
predicate isCompilerGenerated(ThisExpr te) {
  exists(int line, int colStart, int colEnd |
    te.getLocation().hasLocationInfo(_, line, colStart, line, colEnd)
  |
    colStart = colEnd
    or
    exists(Call c | c.getQualifier() = te | c.getLocation() = te.getLocation())
  )
}

/** Gets the sub-expression of 'e' with the earliest-starting Location */
Expr normalizeExpr(Expr e) {
  if forex(Expr q | q = e.(Call).getQualifier() | not isCompilerGenerated(q))
  then result = normalizeExpr(e.(Call).getQualifier())
  else
    if forex(Expr q | q = e.(FieldAccess).getQualifier() | not isCompilerGenerated(q))
    then result = normalizeExpr(e.(FieldAccess).getQualifier())
    else
      if e.hasExplicitConversion()
      then result = normalizeExpr(e.getFullyConverted())
      else result = e
}

predicate isParenthesized(CommaExpr ce) {
  ce.getParent*().(Expr).isParenthesised()
  or
  ce.isUnevaluated() // sizeof(), decltype(), alignof(), noexcept(), typeid()
  or
  ce.getParent*() = any(IfStmt i).getCondition()
  or
  ce.getParent*() = [any(Loop l).getCondition(), any(ForStmt f).getUpdate()]
  or
  ce.getEnclosingStmt() = any(ForStmt f).getInitialization()
}

from CommaExpr ce, Expr left, Expr right, Location leftLoc, Location rightLoc
where
  ce.fromSource() and
  not isFromMacroDefinition(ce) and
  left = normalizeExpr(ce.getLeftOperand()) and
  right = normalizeExpr(ce.getRightOperand()) and
  leftLoc = left.getLocation() and
  rightLoc = right.getLocation() and
  not isParenthesized(ce) and
  leftLoc.getEndLine() < rightLoc.getStartLine() and
  leftLoc.getStartColumn() > rightLoc.getStartColumn()
select right, "The indentation level may be misleading (for some tab sizes)."
