class Element extends @element {
  string toString() { none() }
}

class ForTypeInTypeBound extends Element, @for_type_repr {
  Element bound;

  ForTypeInTypeBound() { type_bound_type_reprs(bound, this) }

  Element getBound() { result = bound }

  Element getGenericParamList() { for_type_repr_generic_param_lists(this, result) }
}

class Location extends @location_default {
  string toString() { none() }
}

// we must create new `ForBinder` elements to wrap `genericParamList`s of
// `WherePred` and `ForType` elements
//
// previously, T: for<'a> X was TypeBound(type_repr=ForType(generic_param_list='a, type_repr=X))
// but now it is TypeBound(for_binder=ForBinder(<generic_param_list='a), type_repr=X>)
// so in that case we don't create new ForBinders, but rather we repurpose ForType ids as
// the new ForBinders ones
newtype TAddedElement =
  TWherePredForBinder(Element wherePred, Element genericParamList) {
    where_pred_generic_param_lists(wherePred, genericParamList)
  } or
  TForTypeForBinder(Element forType, Element genericParamList) {
    for_type_repr_generic_param_lists(forType, genericParamList) and
    not forType instanceof ForTypeInTypeBound
  }

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewElement = @element or Fresh::EntityId;

class NewElement extends TNewElement {
  string toString() { none() }

  Element newGenericParamList() {
    this = Fresh::map(TWherePredForBinder(_, result)) or
    this = Fresh::map(TForTypeForBinder(_, result))
  }
}

query predicate new_for_binders(NewElement id) {
  closure_binders(id) or
  id = Fresh::map(_) or
  id instanceof ForTypeInTypeBound
}

query predicate new_for_binder_generic_param_lists(NewElement id, Element list) {
  closure_binder_generic_param_lists(id, list) or
  id.newGenericParamList() = list or
  id.(ForTypeInTypeBound).getGenericParamList() = list
}

query predicate new_where_pred_for_binders(Element id, NewElement binder) {
  binder = Fresh::map(TWherePredForBinder(id, _))
}

// we need to add a ForBinder to ForType if it's not in a TypeBound
query predicate new_for_type_repr_for_binders(Element id, NewElement binder) {
  binder = Fresh::map(TForTypeForBinder(id, _))
}

query predicate new_for_type_repr_type_reprs(Element id, Element type) {
  for_type_repr_type_reprs(id, type) and not id instanceof ForTypeInTypeBound
}

// we attach a ForTypeInTypeBound id as a ForBinder one to its TypeBound
query predicate new_type_bound_for_binders(Element id, NewElement binder) {
  id = binder.(ForTypeInTypeBound).getBound()
}

// we restrict ForTypes to just the ones that are not in a TypeBound
query predicate new_for_type_reprs(Element id) {
  for_type_reprs(id) and not id instanceof ForTypeInTypeBound
}

// for a TypeBound around a ForType, we need to move type_repr from one directly to the other
query predicate new_type_bound_type_reprs(Element bound, Element type) {
  exists(Element originalType |
    type_bound_type_reprs(bound, originalType) and
    if for_type_reprs(originalType)
    then for_type_repr_type_reprs(originalType, type)
    else type = originalType
  )
}

// for newly addded ForBinders, use same location as their generic param list
query predicate new_locatable_locations(NewElement id, Location location) {
  locatable_locations(id, location)
  or
  locatable_locations(id.newGenericParamList(), location)
}
