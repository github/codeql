class Modifier extends @modifier {
  string toString() { none() }
}

class TypeVariable extends @typevariable {
  string toString() { none() }
}

class Modified extends @modifiable {
  Modified() { hasModifier(this, _) }

  string toString() { none() }
}

from Modified m1, Modifier m2
where
  hasModifier(m1, m2) and
  not m1 instanceof TypeVariable
select m1, m2
