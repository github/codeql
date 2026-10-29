private class RubyToken extends @ruby_token {
  string toString() { none() }
}

bindingset[old]
private int newKind(int old) {
  // @ruby_token_complex was removed, for lack of a better solution
  // it gets translated to @ruby_token_float
  // 4 = @ruby_token_complex
  // 10 = @ruby_token_float
  old = 4 and result = 10
  or
  old <= 3 and result = old
  or
  old >= 5 and result = old - 1
}

from RubyToken id, int kind, string value
where ruby_tokeninfo(id, kind, value)
select id, newKind(kind), value
