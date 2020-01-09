/**
 * @name Bad redirect check
 * @description A redirect check that checks for a leading slash but not two
 *              leading slashes or a leading slash then backslash is
 *              incomplete.
 * @kind problem
 * @problem.severity warning
 * @id go/bad-redirect-check
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import go

predicate checksForLeadingSlash(Expr e, ValueEntity v) {
  exists(LogicalExpr le | le = e | checksForLeadingSlash(le.getAnOperand(), v))
  or
  exists(StringOps::HasPrefix hp |
    hp.getBaseString().(Read).reads(v) and
    // ASCII value for '/'
    (hp.getSubstring().getStringValue() = "/" or hp.getSubstring().getIntValue() = 47)
  )
}

predicate checksForSecondSlash(Expr e, ValueEntity v) {
  exists(LogicalExpr le | le = e | checksForSecondSlash(le.getAnOperand(), v))
  or
  exists(StringOps::HasPrefix hp |
    hp.getBaseString().(Read).reads(v) and
    hp.getSubstring().getStringValue() = "//"
  )
  or
  exists(EqualityTestExpr eq, Expr slash, IndexExpr ie | e = eq |
    slash.getIntValue() = 47 and // ASCII value for '/'
    ie.getBase() = v.getAUse() and
    ie.getIndex().getIntValue() = 1 and
    eq.hasOperands(ie, slash)
  )
}

predicate checksForSecondBackslash(Expr e, ValueEntity v) {
  exists(LogicalExpr le | le = e | checksForSecondBackslash(le.getAnOperand(), v))
  or
  exists(StringOps::HasPrefix hp |
    hp.getBaseString().(Read).reads(v) and
    hp.getSubstring().getStringValue() = "/\\"
  )
  or
  exists(EqualityTestExpr eq, Expr slash, IndexExpr ie | e = eq |
    slash.getIntValue() = 92 and // ASCII value for '\'
    ie.getBase() = v.getAUse() and
    ie.getIndex().getIntValue() = 1 and
    eq.hasOperands(ie, slash)
  )
}

predicate isBadRedirectCheck(Expr e, ValueEntity v) {
  checksForLeadingSlash(e, v) and
  not (checksForSecondSlash(e, v) and checksForSecondBackslash(e, v))
}

predicate isCond(Expr e) {
  e = any(ForStmt fs).getCond()
  or
  e = any(IfStmt is).getCond()
  or
  e = any(ExpressionSwitchStmt ess | not exists(ess.getExpr())).getACase().getAnExpr()
}

from Expr e, ValueEntity v
where
  isBadRedirectCheck(e, v) and
  (
    // this expression is a condition
    isCond(e)
    or
    // or is returned from a function
    DataFlow::exprNode(e).getASuccessor*() instanceof DataFlow::ResultNode
  ) and
  v.getName().regexpMatch("(?i).*url.*|.*redir.*")
select e,
  "This condition checks '$@' for a leading slash but not for both a '/' and '\\' in the second position.",
  v, v.getName()
