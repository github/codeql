class UsingEntry extends @using {
  string toString() { none() }
}

class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from UsingEntry u, Element target, Location loc, int kind
where
  usings(u, target, loc) and
  if target instanceof @namespace then kind = 2 else kind = 1
select u, target, loc, kind
