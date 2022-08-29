class RubyBlockParameters extends @ruby_block_parameters {
  string toString() { none() }
}

class RubyIdentifier extends @ruby_token_identifier {
  string toString() { none() }
}

predicate blockParametersLocals(RubyBlockParameters params, int index, RubyIdentifier local) {
  local =
    rank[index + 1](@ruby_token semi, int semiIndex, RubyIdentifier id, int idIndex |
      ruby_tokeninfo(semi, _, ";") and
      ruby_ast_node_info(semi, params, semiIndex, _) and
      ruby_ast_node_info(id, params, idIndex, _) and
      idIndex > semiIndex
    |
      id order by idIndex
    )
}

from RubyBlockParameters ruby_block_parameters, int index, RubyIdentifier local
where blockParametersLocals(ruby_block_parameters, index, local)
select ruby_block_parameters, index, local
