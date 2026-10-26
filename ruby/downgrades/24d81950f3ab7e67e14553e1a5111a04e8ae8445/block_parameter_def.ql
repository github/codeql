class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode ruby_block_parameter, AstNode name, Location location
where
  ruby_block_parameter_def(ruby_block_parameter, location) and
  ruby_block_parameter_name(ruby_block_parameter, name)
select ruby_block_parameter, name, location
