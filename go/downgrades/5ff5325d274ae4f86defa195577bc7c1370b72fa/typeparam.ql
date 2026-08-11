class TypeParamType extends @typeparamtype {
  string toString() { none() }
}

class CompositeType extends @compositetype {
  string toString() { none() }
}

class TypeParamParentObject extends @typeparamparentobject {
  string toString() { none() }
}

from
  TypeParamType tp, string name, CompositeType bound, TypeParamParentObject parent, int idx,
  boolean is_from_recv
where typeparam(tp, name, bound, parent, idx, is_from_recv)
select tp, name, bound, parent, idx
