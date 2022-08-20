class Location extends @location {
  string toString() { none() }
}

class RubyAstNodeParent extends @ruby_ast_node_parent {
  string toString() { none() }
}

class RubyAstNode extends @ruby_ast_node {
  string toString() { none() }

  RubyAstNodeParent getParent(int index) { ruby_ast_node_parent(this, result, index) }

  Location getLocation() {
    ruby_tokeninfo(this, _, _, result) or
    ruby_alias_def(this, _, _, result) or
    ruby_alternative_pattern_def(this, result) or
    ruby_argument_list_def(this, result) or
    ruby_array_def(this, result) or
    ruby_array_pattern_def(this, result) or
    ruby_as_pattern_def(this, _, _, result) or
    ruby_assignment_def(this, _, _, result) or
    ruby_bare_string_def(this, result) or
    ruby_bare_symbol_def(this, result) or
    ruby_begin_def(this, result) or
    ruby_begin_block_def(this, result) or
    ruby_binary_def(this, _, _, _, result) or
    ruby_block_def(this, result) or
    ruby_block_argument_def(this, result) or
    ruby_block_parameter_def(this, result) or
    ruby_block_parameters_def(this, result) or
    ruby_break_def(this, result) or
    ruby_call_def(this, _, result) or
    ruby_case_def(this, result) or
    ruby_case_match_def(this, _, result) or
    ruby_chained_string_def(this, result) or
    ruby_class_def(this, _, result) or
    ruby_conditional_def(this, _, _, _, result) or
    ruby_delimited_symbol_def(this, result) or
    ruby_destructured_left_assignment_def(this, result) or
    ruby_destructured_parameter_def(this, result) or
    ruby_do_def(this, result) or
    ruby_do_block_def(this, result) or
    ruby_element_reference_def(this, _, result) or
    ruby_else_def(this, result) or
    ruby_elsif_def(this, _, result) or
    ruby_end_block_def(this, result) or
    ruby_ensure_def(this, result) or
    ruby_exception_variable_def(this, _, result) or
    ruby_exceptions_def(this, result) or
    ruby_expression_reference_pattern_def(this, _, result) or
    ruby_find_pattern_def(this, result) or
    ruby_for_def(this, _, _, _, result) or
    ruby_hash_def(this, result) or
    ruby_hash_pattern_def(this, result) or
    ruby_hash_splat_argument_def(this, _, result) or
    ruby_hash_splat_parameter_def(this, result) or
    ruby_heredoc_body_def(this, result) or
    ruby_if_def(this, _, result) or
    ruby_if_guard_def(this, _, result) or
    ruby_if_modifier_def(this, _, _, result) or
    ruby_in_def(this, _, result) or
    ruby_in_clause_def(this, _, result) or
    ruby_interpolation_def(this, result) or
    ruby_keyword_parameter_def(this, _, result) or
    ruby_keyword_pattern_def(this, _, result) or
    ruby_lambda_def(this, _, result) or
    ruby_lambda_parameters_def(this, result) or
    ruby_left_assignment_list_def(this, result) or
    ruby_method_def(this, _, result) or
    ruby_method_parameters_def(this, result) or
    ruby_module_def(this, _, result) or
    ruby_next_def(this, result) or
    ruby_operator_assignment_def(this, _, _, _, result) or
    ruby_optional_parameter_def(this, _, _, result) or
    ruby_pair_def(this, _, result) or
    ruby_parenthesized_pattern_def(this, _, result) or
    ruby_parenthesized_statements_def(this, result) or
    ruby_pattern_def(this, _, result) or
    ruby_program_def(this, result) or
    ruby_range_def(this, _, result) or
    ruby_rational_def(this, _, result) or
    ruby_redo_def(this, result) or
    ruby_regex_def(this, result) or
    ruby_rescue_def(this, result) or
    ruby_rescue_modifier_def(this, _, _, result) or
    ruby_rest_assignment_def(this, result) or
    ruby_retry_def(this, result) or
    ruby_return_def(this, result) or
    ruby_right_assignment_list_def(this, result) or
    ruby_scope_resolution_def(this, _, result) or
    ruby_setter_def(this, _, result) or
    ruby_singleton_class_def(this, _, result) or
    ruby_singleton_method_def(this, _, _, result) or
    ruby_splat_argument_def(this, _, result) or
    ruby_splat_parameter_def(this, result) or
    ruby_string_def(this, result) or
    ruby_string_array_def(this, result) or
    ruby_subshell_def(this, result) or
    ruby_superclass_def(this, _, result) or
    ruby_symbol_array_def(this, result) or
    ruby_then_def(this, result) or
    ruby_unary_def(this, _, _, result) or
    ruby_undef_def(this, result) or
    ruby_unless_def(this, _, result) or
    ruby_unless_guard_def(this, _, result) or
    ruby_unless_modifier_def(this, _, _, result) or
    ruby_until_def(this, _, _, result) or
    ruby_until_modifier_def(this, _, _, result) or
    ruby_variable_reference_pattern_def(this, _, result) or
    ruby_when_def(this, result) or
    ruby_while_def(this, _, _, result) or
    ruby_while_modifier_def(this, _, _, result) or
    ruby_yield_def(this, result)
  }
}

from RubyAstNode node, RubyAstNodeParent parent, int index, Location loc
where parent = node.getParent(index) and loc = node.getLocation()
select node, parent, index, loc
