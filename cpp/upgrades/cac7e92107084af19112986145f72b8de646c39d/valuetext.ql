class Value extends @value {
  string toString() { none() }
}

from Value v, string s
where values(v, _, s)
select v, s
