// Moves AbiSafeConversionExprs into UnspecifiedElements
class Element extends @element {
  string toString() { none() }
}

from Element e, string property, string error
where
  abi_safe_conversion_exprs(e) and
  property = "" and
  error = "Removed ABISafeConversionExpr during the database downgrade"
  or
  unspecified_elements(e, property, error)
select e, property, error
