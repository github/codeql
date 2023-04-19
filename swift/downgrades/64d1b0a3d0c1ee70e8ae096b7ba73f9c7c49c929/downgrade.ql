class Element extends @element {
  string toString() { none() }
}

newtype TAddedUnspecifiedElement =
  TNonClosureExprClosureBody(Element list, Element body) {
    capture_list_exprs(list, body) and not closure_exprs(body)
  }

module Fresh = QlBuiltins::NewEntity<TAddedUnspecifiedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }
}

query predicate new_unspecified_elements(NewElement u, string property, string error) {
  unspecified_elements(u, property, error)
  or
  u = Fresh::map(TNonClosureExprClosureBody(_, _)) and
  property = "closure_body" and
  error = "while downgrading: closure_body not a @closure_expr"
}

query predicate new_unspecified_element_parents(NewElement u, Element parent) {
  unspecified_element_parents(u, parent)
  or
  u = Fresh::map(TNonClosureExprClosureBody(parent, _))
}

query predicate new_capture_list_exprs(Element list, NewElement body) {
  capture_list_exprs(list, body) and closure_exprs(body)
  or
  body = Fresh::map(TNonClosureExprClosureBody(list, _))
}
