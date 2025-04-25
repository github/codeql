class MacroRole extends @macro_role {
  string toString() { none() }
}

class ExprOrNone extends @expr_or_none {
  string toString() { none() }
}

class TypeExpr extends @type_expr {
  string toString() { none() }
}

class UnspecifiedElement extends @unspecified_element {
  string toString() { none() }
}

from MacroRole role, int index, ExprOrNone conformance
where
  macro_role_conformances(role, index, conformance) and
  (conformance instanceof TypeExpr or conformance instanceof UnspecifiedElement)
select role, index, conformance
