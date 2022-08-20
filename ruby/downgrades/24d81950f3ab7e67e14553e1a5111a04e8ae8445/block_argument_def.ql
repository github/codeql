class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode ruby_block_argument, AstNode child, Location location
where
  ruby_block_argument_def(ruby_block_argument, location) and
  ruby_block_argument_child(ruby_block_argument, child)
select ruby_block_argument, child, location
