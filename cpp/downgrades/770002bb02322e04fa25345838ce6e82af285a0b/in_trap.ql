class Element extends @element {
  string toString() { none() }
}

class Trap extends @trap {
  string toString() { none() }
}

class Tag extends @tag {
  string toString() { none() }
}

from Element e, Trap trap
where
  in_trap_or_tag(e, trap)
  or
  exists(Tag tag |
    in_trap_or_tag(e, tag) and
    trap_uses_tag(trap, tag)
  )
select e, trap
