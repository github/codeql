class Attribute extends @attribute {
  string toString() { none() }
}

class Attributable extends @attributable {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

from Attribute id, TypeOrRef type_id, Attributable target
where attributes(id, type_id, target)
select id, 0, type_id, target
