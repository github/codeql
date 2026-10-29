class Element extends @element {
  string toString() { none() }
}

class Trap extends @trap {
  string toString() { none() }
}

from Element e, Trap trap
where in_trap(e, trap)
select e, trap
