private class RubyToken extends @ruby_token {
  string toString() { none() }
}

private class Location extends @location {
  string toString() { none() }
}

bindingset[kind]
private int newKind(int kind) { if kind >= 10 then result = kind + 2 else result = kind }

from RubyToken id, int kind, string value, Location loc
where ruby_tokeninfo(id, kind, value, loc)
select id, newKind(kind), value, loc
