/**
 * @name Comma before misleading indentation
 * @description The expressions before and after the comma operator can be misread because of an unusual difference in start columns.
 * @kind problem
 * @id cpp/comma-before-misleading-indentation
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 */

import cpp
import semmle.code.cpp.commons.Exclusions

/** Gets the sub-expression of 'e' with the earliest-starting Location */
Expr normalizeExpr(Expr e) {
  if exists(e.(Call).getQualifier())
  then result = normalizeExpr(e.(Call).getQualifier())
  else
    if exists(e.(FieldAccess).getQualifier())
    then result = normalizeExpr(e.(FieldAccess).getQualifier())
    else
      if e.hasExplicitConversion()
      then result = normalizeExpr(e.getFullyConverted())
      else result = e
}

predicate isInLoopHead(CommaExpr ce) {
  ce.getParent*() = [any(Loop l).getCondition(), any(ForStmt f).getUpdate()]
  or
  ce.getEnclosingStmt() = any(ForStmt f).getInitialization()
}

predicate isInDecltypeOrSizeof(CommaExpr ce) {
  ce.getParent*() instanceof SizeofExprOperator
  or
  ce.getParent*() = any(Decltype d).getExpr()
}

from CommaExpr ce, Expr left, Expr right, Location leftLoc, Location rightLoc
where
  ce.fromSource() and
  not isFromMacroDefinition(ce) and
  left = normalizeExpr(ce.getLeftOperand()) and
  right = normalizeExpr(ce.getRightOperand()) and
  leftLoc = left.getLocation() and
  rightLoc = right.getLocation() and
  not isInLoopHead(ce) and // <- HACK to reduce FPs in loop heads; assumption: unlikely to be misread due to '(', ')' delimiters
  not isInDecltypeOrSizeof(ce) and // <- Removes arguable FPs since, like function calls (and loop heads), these Exprs have clear delimiters.
  leftLoc.getEndLine() < rightLoc.getStartLine() and
  leftLoc.getStartColumn() > rightLoc.getStartColumn()
select right, "The indentation level may be misleading (for some tab sizes)."
