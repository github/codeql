class Value extends @value {
  string toString() { none() }
}

from Value v, string s
where values(v, s, _)
select v, s
