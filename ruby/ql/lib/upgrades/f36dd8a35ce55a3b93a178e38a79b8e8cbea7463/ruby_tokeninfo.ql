private class RubyToken extends @ruby_token {
  string toString() { none() }
}

private class Location extends @location {
  string toString() { none() }
}

bindingset[old]
private int newKind(int old) {
  old in [0 .. 6] and result = old
  or
  // @ruby_token_escape_sequence
  old = 7 and result = 8
  or
  // @ruby_token_false
  old = 8 and result = 9
  or
  // @ruby_token_float
  old = 9 and result = 11
  or
  // @ruby_token_forward_argument
  old = 10 and result = 12
  or
  // @ruby_token_forward_parameter
  old = 11 and result = 13
  or
  // @ruby_token_global_variable
  old = 12 and result = 14
  or
  // @ruby_token_hash_key_symbol
  old = 13 and result = 15
  or
  // @ruby_token_heredoc_beginning
  old = 14 and result = 17
  or
  // @ruby_token_heredoc_content
  old = 15 and result = 18
  or
  // @ruby_token_heredoc_end
  old = 16 and result = 19
  or
  // @ruby_token_identifier
  old = 17 and result = 20
  or
  // @ruby_token_instance_variable
  old = 18 and result = 21
  or
  // @ruby_token_integer
  old = 19 and result = 22
  or
  // @ruby_token_nil
  old = 20 and result = 24
  or
  // @ruby_token_operator
  old = 21 and result = 25
  or
  // @ruby_token_self
  old = 22 and result = 26
  or
  // @ruby_token_simple_symbol
  old = 23 and result = 27
  or
  // @ruby_token_string_content
  old = 24 and result = 28
  or
  // @ruby_token_super
  old = 25 and result = 29
  or
  // @ruby_token_true
  old = 26 and result = 30
  or
  // @ruby_token_uninterpreted
  old = 27 and result = 31
}

from RubyToken id, int kind, string value, Location loc
where ruby_tokeninfo(id, kind, value, loc)
select id, newKind(kind), value, loc
