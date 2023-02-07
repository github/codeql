class IterableDeclContext extends @decl {
  IterableDeclContext() {
    this instanceof @extension_decl
    or
    this instanceof @nominal_type_decl
  }

  string toString() { none() }
}

class DeclOrNone extends @decl_or_none {
  string toString() { none() }
}

query predicate iterable_decl_context_members(IterableDeclContext id, int index, DeclOrNone member) {
  decl_members(id, index, member)
}
