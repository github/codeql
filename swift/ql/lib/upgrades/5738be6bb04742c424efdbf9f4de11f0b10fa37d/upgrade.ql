class TypeDecl extends @type_decl {
  string toString() { none() }
}

newtype TAddedElement = TType(TypeDecl t)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_type_decls(TypeDecl typeDecl, string name, NewElement elementType) {
  type_decls(typeDecl, name) and
  Fresh::map(TType(typeDecl)) = elementType
}

query predicate new_unspecified_elements(NewElement id, string property, string error) {
  unspecified_elements(id, property, error)
  or
  exists(TypeDecl typeDecl | type_decls(typeDecl, _) |
    id = Fresh::map(TType(typeDecl)) and
    error =
      "TypeDecl declared interface type missing after upgrade. Please update your CodeQL code." and
    property = ""
  )
}
