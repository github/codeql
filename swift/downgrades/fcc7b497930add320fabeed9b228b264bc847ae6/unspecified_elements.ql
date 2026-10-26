// Converts SingleValueStmtExprs into UnspecifiedElements
class Element extends @element {
  string toString() { none() }
}

from Element e, string property, string error
where
  single_value_stmt_exprs(e, _) and
  property = "" and
  error = "Removed SingleValueStmtExpr during the database downgrade"
  or
  unspecified_elements(e, property, error)
select e, property, error
