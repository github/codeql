class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode ruby_pair, AstNode key, AstNode value, Location location
where
  ruby_pair_def(ruby_pair, key, location) and
  ruby_pair_value(ruby_pair, value)
select ruby_pair, key, value, location
