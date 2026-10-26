class RegexLiteralExpr extends @regex_literal_expr {
  string toString() { none() }
}

from RegexLiteralExpr e
select e, "", 0
