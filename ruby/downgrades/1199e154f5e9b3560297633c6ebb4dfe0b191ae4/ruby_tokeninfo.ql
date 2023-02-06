private class RubyAstNode extends @ruby_ast_node {
  string toString() { none() }
}

bindingset[old]
private int newKind(int old) {
  old <= 3 and result = old
  or
  old >= 4 and result = old + 1
}

private predicate complex_token(RubyAstNode node, string value) {
  exists(RubyAstNode token, string tokenValue | ruby_tokeninfo(token, _, tokenValue) |
    (
      ruby_complex_def(node, token) and value = tokenValue + "i"
      or
      exists(@ruby_rational rational |
        ruby_complex_def(node, rational) and
        ruby_rational_def(rational, token)
      ) and
      value = tokenValue + "ri"
    )
  )
}

private RubyAstNode parent(RubyAstNode node) { ruby_ast_node_info(node, result, _, _) }

from RubyAstNode token, int kind, string value
where
  exists(int oldKind |
    ruby_tokeninfo(token, oldKind, value) and
    not complex_token(parent+(token), _) and
    kind = newKind(oldKind)
  )
  or
  complex_token(token, value) and kind = 4
select token, kind, value
