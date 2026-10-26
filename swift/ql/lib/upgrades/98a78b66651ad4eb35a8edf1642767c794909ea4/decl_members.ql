class Decl extends @decl {
  string toString() { none() }
}

class DeclOrNone extends @decl_or_none {
  string toString() { none() }
}

query predicate decl_members(Decl id, int index, DeclOrNone member) {
  iterable_decl_context_members(id, index, member)
}
