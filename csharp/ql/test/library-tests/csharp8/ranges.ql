import csharp

predicate getConversion(Expr expr, Expr unconvertedExpr) {
  unconvertedExpr = expr.(Cast).getExpr()
  or
  unconvertedExpr = expr.(OperatorCall).getArgument(0) and
  expr.(OperatorCall).getTarget() instanceof ConversionOperator
}

Expr stripConversions(Expr expr) {
  if getConversion(expr, _) then getConversion(expr, result) else result = expr
}

query predicate indexes(IndexExpr e, Expr c) { c = e.getExpr() }

query predicate ranges(RangeExpr e) { any() }

query predicate rangeStart(RangeExpr e, Expr start) { start = stripConversions(e.getStart()) }

query predicate rangeEnd(RangeExpr e, Expr end) { end = stripConversions(e.getEnd()) }
