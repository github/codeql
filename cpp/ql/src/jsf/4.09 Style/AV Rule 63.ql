/**
 * @name AV Rule 63
 * @description Spaces will not be used around '.' or '->', nor between unary operators and operands.
 * @kind problem
 * @id cpp/jsf/av-rule-63
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate hasLocation(Expr e) { e.getLocation().getStartLine() != 0 }

predicate outermostConvWithLocation(Expr e, Expr res) {
  if exists(Expr p | e.getConversion+() = p and hasLocation(p))
  then outermostConvWithLocation(e.getConversion(), res)
  else res = e
}

predicate diffEndBegin(Expr lhs, Expr rhs, int length) {
  exists(Location l, Location r |
    l = lhs.getLocation() and
    r = rhs.getLocation() and
    length = r.getStartColumn() - l.getEndColumn() and
    l.getEndLine() = r.getStartLine()
  )
}

predicate diffEndEnd(Expr lhs, Expr rhs, int length) {
  exists(Location l, Location r |
    l = lhs.getLocation() and
    r = rhs.getLocation() and
    length = r.getEndColumn() - l.getEndColumn() and
    l.getEndLine() = r.getEndLine()
  )
}

predicate diffBeginBegin(Expr lhs, Expr rhs, int length) {
  exists(Location l, Location r |
    l = lhs.getLocation() and
    r = rhs.getLocation() and
    length = r.getStartColumn() - l.getStartColumn() and
    l.getStartLine() = r.getStartLine()
  )
}

/*
 * Unary postfix operations: PostfixDecrExpr, PostfixIncrExpr
 * Unary prefix operations: PrefixIncrExpr, PrefixDecrExpr, ComplementExpr, NotExpr,
 *        UnaryMinusExpr, UnaryPlusExpr, AddressOfExpr, PointerDereferenceExpr
 */

from Expr err
where
  not err.isInMacroExpansion() and
  hasLocation(err) and
  (
    exists(Call c, Expr e |
      c = err and
      outermostConvWithLocation(c.getQualifier(), e) and
      e.getType() instanceof PointerType and
      not diffEndBegin(e, c, 3)
    )
    or
    exists(Call c, Expr e |
      c = err and
      outermostConvWithLocation(c.getQualifier(), e) and
      not e.getType() instanceof PointerType and
      not diffEndBegin(e, c, 2)
    )
    or
    exists(VariableAccess c, Expr e |
      c = err and
      outermostConvWithLocation(c.getQualifier(), e) and
      e.getType() instanceof PointerType and
      not diffEndBegin(e, c, 3)
    )
    or
    exists(VariableAccess c, Expr e |
      c = err and
      outermostConvWithLocation(c.getQualifier(), e) and
      not e.getType() instanceof PointerType and
      not diffEndBegin(e, c, 2)
    )
    or
    exists(UnaryOperation c, Expr e |
      c = err and
      outermostConvWithLocation(c.getOperand(), e) and
      (
        c instanceof ComplementExpr or
        c instanceof NotExpr or
        c instanceof UnaryMinusExpr or
        c instanceof UnaryPlusExpr or
        c instanceof AddressOfExpr
      ) and
      not diffBeginBegin(c, e, 1)
    )
    or
    exists(PrefixIncrExpr c, Expr e |
      c = err and
      outermostConvWithLocation(c.getOperand(), e) and
      not diffBeginBegin(c, e, 2)
    )
    or
    exists(PrefixDecrExpr c, Expr e |
      c = err and
      outermostConvWithLocation(c.getOperand(), e) and
      not diffBeginBegin(c, e, 2)
    )
    or
    exists(PointerDereferenceExpr c, Expr e |
      c = err and
      outermostConvWithLocation(c.getChild(0), e) and
      not diffBeginBegin(c, e, 1)
    )
    or
    exists(PostfixIncrExpr c, Expr e |
      c = err and
      outermostConvWithLocation(c.getOperand(), e) and
      not diffEndEnd(e, c, 2)
    )
    or
    exists(PostfixDecrExpr c, Expr e |
      c = err and
      outermostConvWithLocation(c.getOperand(), e) and
      not diffEndEnd(e, c, 2)
    )
  )
select err,
  "AV Rule 63: Spaces will not be used around '.' or '->', nor between unary operators and operands."
