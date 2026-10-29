class TypeParamType extends @typeparamtype {
  string toString() { none() }
}

class CompositeType extends @compositetype {
  string toString() { none() }
}

class TypeParamParentObject extends @typeparamparentobject {
  string toString() { none() }
}

// In Go 1.26 and below, a type parameter is from a receiver exactly when its
// parent is a method.
boolean isFromReceiver(TypeParamParentObject parent) {
  if methodreceivers(parent, _) then result = true else result = false
}

from TypeParamType tp, string name, CompositeType bound, TypeParamParentObject parent, int idx
where typeparam(tp, name, bound, parent, idx)
select tp, name, bound, parent, idx, isFromReceiver(parent)
