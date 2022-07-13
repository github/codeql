class RubyBlockParameters extends @ruby_block_parameters {
  string toString() { none() }
}

class RubyBlockParameter extends @ruby_block_parameters_child_type {
  string toString() { none() }
}

from RubyBlockParameters ruby_block_parameters, int index, RubyBlockParameter param
where
  ruby_block_parameters_child(ruby_block_parameters, index, param) or
  ruby_block_parameters_locals(ruby_block_parameters,
    index - 1 - max(int i | ruby_block_parameters_child(ruby_block_parameters, i, _)), param)
select ruby_block_parameters, index, param
