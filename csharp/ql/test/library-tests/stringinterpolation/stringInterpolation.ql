import csharp

query predicate inserts(InterpolatedStringExpr expr, Expr e) {
  expr.getAnInsert() = e // and inSpecificSource(expr)
}

query predicate texts(InterpolatedStringExpr expr, StringLiteral literal) {
  expr.getAText() = literal // and inSpecificSource(expr)
}

query predicate interpolationInsertsWithAlign(InterpolatedStringExpr expr, Expr insert, Expr align) {
  exists(InterpolatedStringInsertExpr e | expr.getInterpolatedInsert(_) = e |
    insert = e.getInsert() and
    align = e.getAlignment()
  )
}

query predicate interpolationInsertsWithFormat(
  InterpolatedStringExpr expr, Expr insert, StringLiteral format
) {
  exists(InterpolatedStringInsertExpr e | expr.getInterpolatedInsert(_) = e |
    insert = e.getInsert() and
    format = e.getFormat()
  )
}
