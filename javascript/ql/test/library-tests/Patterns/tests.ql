import javascript

query predicate arrayPattern_getElement(ArrayPattern ap, int i, BindingPattern elt) {
  elt = ap.getElement(i)
}

query predicate arrayPattern_getSizeE(ArrayPattern ap, int size) { size = ap.getSize() }

query predicate arrayPattern_omittedElements(ArrayPattern ap, int i) { ap.elementIsOmitted(i) }

query predicate objectPattern_getPropertyPattern(ObjectPattern op, int i, PropertyPattern pp) {
  pp = op.getPropertyPattern(i)
}

query predicate propertyPattern_getName(PropertyPattern pp, string name) {
  if exists(pp.getName()) then name = pp.getName() else name = "<unknown>"
}

query predicate propertyPattern_isComputed(PropertyPattern pp) { pp.isComputed() }

query predicate propertyPattern_isShortHand(PropertyPattern pp) { pp.isShorthand() }
