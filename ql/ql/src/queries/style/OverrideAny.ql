/**
 * @name Override with unmentioned parameter
 * @description A predicate that overrides the default behavior but doesn't mention a parameter is suspicious.
 * @kind problem
 * @problem.severity warning
 * @id ql/override-any
 * @precision high
 */

import ql
import codeql_ql.performance.VarUnusedInDisjunctQuery

AstNode param(Predicate pred, string name, Type t) {
  result = pred.getParameter(_) and
  result.(VarDecl).getName() = name and
  result.(VarDecl).getType() = t
  or
  result = pred.getReturnTypeExpr() and
  name = "result" and
  t = pred.getReturnType()
}

predicate hasAccess(Predicate pred, string name) {
  exists(param(pred, name, _).(VarDecl).getAnAccess())
  or
  name = "result" and
  exists(param(pred, name, _)) and
  exists(ResultAccess res | res.getEnclosingPredicate() = pred)
}

from Predicate pred, AstNode param, string name, Type paramType
where
  pred.hasAnnotation("override") and
  param = param(pred, name, paramType) and
  not hasAccess(pred, name) and
  not pred.getBody() instanceof NoneCall and
  exists(pred.getBody()) and
  not isSmallType(pred.getParent().(Class).getType()) and
  not isSmallType(paramType)
select pred, "Override predicate doesn't mention $@. Maybe mention it in a 'exists(" + name + ")'?",
  param, name
