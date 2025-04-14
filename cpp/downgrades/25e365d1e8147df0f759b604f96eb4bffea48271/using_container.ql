class UsingEntry extends @using {
  string toString() { none() }
}

class Element extends @element {
  string toString() { none() }
}

from UsingEntry u, Element parent, int kind
where
  usings(u, _, _, kind) and
  using_container(parent, u) and
  kind != 3
select parent, u
