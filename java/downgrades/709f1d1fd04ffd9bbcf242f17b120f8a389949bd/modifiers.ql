class Modifier extends @modifier {
  string toString() { none() }

  string getName() { modifiers(this, result) }
}

from Modifier m, string s
where
  s = m.getName() and
  not s in ["in", "out", "reified"]
select m, m.getName()
