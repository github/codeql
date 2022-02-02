class Attribute extends @attribute {
  string toString() { none() }
}

class Attributable extends @attributable {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

query predicate add_default_kind(Attribute id, int kind, TypeOrRef type_id, Attributable target) {
  kind = 0 and
  attributes(id, type_id, target)
}
