class TypeAliasDecl extends @type_alias_decl {
  string toString() { result = "TypeAliasDecl" }
}

class Type extends @type_or_none {
  string toString() { result = "Type" }
}

// use the canonical type as an approximation of the aliased type
from TypeAliasDecl td, Type t, Type canonical
where
  type_alias_types(t, td) and // td is the declaration of t
  types(t, _, canonical) // canonical is the canonical type of t
select td, canonical
