import ruby

query predicate blockArguments(BlockArgument a, Expr e) { e = a.getValue() }

query predicate splatExpr(SplatExpr a, Expr e) { e = a.getOperand() }

query predicate hashSplatExpr(HashSplatExpr a, Expr e) { e = a.getOperand() }

query predicate keywordArguments(Pair a, Expr key, Expr value) {
  exists(Call c | c.getAnArgument() = a and key = a.getKey() and value = a.getValue())
}

query predicate keywordArgumentsByKeyword(Call c, string keyword, Expr value) {
  c.getKeywordArgument(keyword) = value
}
