// Removes AbiSafeConversionExprs from ImplicitConversionExprs
class Element extends @element {
  string toString() { none() }
}

from Element e, Element child
where implicit_conversion_exprs(e, child) and not abi_safe_conversion_exprs(e)
select e, child
