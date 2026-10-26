/**
 * @name ExprsCast2
 * @kind table
 */

import cpp

string exprString(Expr e) {
  if e instanceof ArrayToPointerConversion
  then result = e.(ArrayToPointerConversion).getExpr().(Literal).getValue()
  else result = e.toString()
}

from Cast c, Type cType, string cTypeName, string toStruct
where
  cType = c.getType() and
  cType.hasName(cTypeName) and
  if cType instanceof Struct then toStruct = "struct" else toStruct = ""
select c, exprString(c.getExpr()), c.getExpr().getType().toString(), cTypeName, toStruct
