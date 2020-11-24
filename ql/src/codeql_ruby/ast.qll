/*
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

import codeql.files.FileSystem
import codeql.Locations

class AstNode extends @ast_node {
  string toString() { result = this.describeQlClass() }

  Location getLocation() { none() }

  AstNode getParent() { none() }

  int getParentIndex() { none() }

  AstNode getAFieldOrChild() { none() }

  string describeQlClass() { result = "???" }
}

class Token extends @token, AstNode {
  override AstNode getParent() { tokeninfo(this, result, _, _, _, _, _, _) }

  override int getParentIndex() { tokeninfo(this, _, result, _, _, _, _, _) }

  string getValue() { tokeninfo(this, _, _, _, _, _, result, _) }

  override Location getLocation() { tokeninfo(this, _, _, _, _, _, _, result) }

  override string toString() { result = getValue() }

  override string describeQlClass() { result = "Token" }
}

class ReservedWord extends @reserved_word, Token {
  override string describeQlClass() { result = "ReservedWord" }
}

class UnderscoreArg extends @underscore_arg, AstNode { }

class UnderscoreLhs extends @underscore_lhs, AstNode { }

class UnderscoreMethodName extends @underscore_method_name, AstNode { }

class UnderscorePrimary extends @underscore_primary, AstNode { }

class UnderscoreStatement extends @underscore_statement, AstNode { }

class UnderscoreVariable extends @underscore_variable, AstNode { }

class Alias extends @alias, AstNode {
  override string describeQlClass() { result = "Alias" }

  override Location getLocation() { alias_def(this, _, _, _, _, result) }

  UnderscoreMethodName getAlias() { alias_def(this, _, _, result, _, _) }

  UnderscoreMethodName getName() { alias_def(this, _, _, _, result, _) }

  override AstNode getParent() { alias_def(this, result, _, _, _, _) }

  override int getParentIndex() { alias_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    alias_def(this, _, _, result, _, _) or alias_def(this, _, _, _, result, _)
  }
}

class ArgumentList extends @argument_list, AstNode {
  override string describeQlClass() { result = "ArgumentList" }

  override Location getLocation() { argument_list_def(this, _, _, result) }

  AstNode getChild(int i) { argument_list_child(this, i, result) }

  override AstNode getParent() { argument_list_def(this, result, _, _) }

  override int getParentIndex() { argument_list_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { argument_list_child(this, _, result) }
}

class Array extends @array, AstNode {
  override string describeQlClass() { result = "Array" }

  override Location getLocation() { array_def(this, _, _, result) }

  AstNode getChild(int i) { array_child(this, i, result) }

  override AstNode getParent() { array_def(this, result, _, _) }

  override int getParentIndex() { array_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { array_child(this, _, result) }
}

class Assignment extends @assignment, AstNode {
  override string describeQlClass() { result = "Assignment" }

  override Location getLocation() { assignment_def(this, _, _, _, _, result) }

  AstNode getLeft() { assignment_def(this, _, _, result, _, _) }

  AstNode getRight() { assignment_def(this, _, _, _, result, _) }

  override AstNode getParent() { assignment_def(this, result, _, _, _, _) }

  override int getParentIndex() { assignment_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    assignment_def(this, _, _, result, _, _) or assignment_def(this, _, _, _, result, _)
  }
}

class BareString extends @bare_string, AstNode {
  override string describeQlClass() { result = "BareString" }

  override Location getLocation() { bare_string_def(this, _, _, result) }

  AstNode getChild(int i) { bare_string_child(this, i, result) }

  override AstNode getParent() { bare_string_def(this, result, _, _) }

  override int getParentIndex() { bare_string_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { bare_string_child(this, _, result) }
}

class BareSymbol extends @bare_symbol, AstNode {
  override string describeQlClass() { result = "BareSymbol" }

  override Location getLocation() { bare_symbol_def(this, _, _, result) }

  AstNode getChild(int i) { bare_symbol_child(this, i, result) }

  override AstNode getParent() { bare_symbol_def(this, result, _, _) }

  override int getParentIndex() { bare_symbol_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { bare_symbol_child(this, _, result) }
}

class Begin extends @begin, AstNode {
  override string describeQlClass() { result = "Begin" }

  override Location getLocation() { begin_def(this, _, _, result) }

  AstNode getChild(int i) { begin_child(this, i, result) }

  override AstNode getParent() { begin_def(this, result, _, _) }

  override int getParentIndex() { begin_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { begin_child(this, _, result) }
}

class BeginBlock extends @begin_block, AstNode {
  override string describeQlClass() { result = "BeginBlock" }

  override Location getLocation() { begin_block_def(this, _, _, result) }

  AstNode getChild(int i) { begin_block_child(this, i, result) }

  override AstNode getParent() { begin_block_def(this, result, _, _) }

  override int getParentIndex() { begin_block_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { begin_block_child(this, _, result) }
}

class Binary extends @binary, AstNode {
  override string describeQlClass() { result = "Binary" }

  override Location getLocation() { binary_def(this, _, _, _, _, _, result) }

  AstNode getLeft() { binary_def(this, _, _, result, _, _, _) }

  AstNode getOperator() { binary_def(this, _, _, _, result, _, _) }

  AstNode getRight() { binary_def(this, _, _, _, _, result, _) }

  override AstNode getParent() { binary_def(this, result, _, _, _, _, _) }

  override int getParentIndex() { binary_def(this, _, result, _, _, _, _) }

  override AstNode getAFieldOrChild() {
    binary_def(this, _, _, result, _, _, _) or
    binary_def(this, _, _, _, result, _, _) or
    binary_def(this, _, _, _, _, result, _)
  }
}

class Block extends @block, AstNode {
  override string describeQlClass() { result = "Block" }

  override Location getLocation() { block_def(this, _, _, result) }

  AstNode getChild(int i) { block_child(this, i, result) }

  override AstNode getParent() { block_def(this, result, _, _) }

  override int getParentIndex() { block_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { block_child(this, _, result) }
}

class BlockArgument extends @block_argument, AstNode {
  override string describeQlClass() { result = "BlockArgument" }

  override Location getLocation() { block_argument_def(this, _, _, _, result) }

  UnderscoreArg getChild() { block_argument_def(this, _, _, result, _) }

  override AstNode getParent() { block_argument_def(this, result, _, _, _) }

  override int getParentIndex() { block_argument_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { block_argument_def(this, _, _, result, _) }
}

class BlockParameter extends @block_parameter, AstNode {
  override string describeQlClass() { result = "BlockParameter" }

  override Location getLocation() { block_parameter_def(this, _, _, _, result) }

  Identifier getName() { block_parameter_def(this, _, _, result, _) }

  override AstNode getParent() { block_parameter_def(this, result, _, _, _) }

  override int getParentIndex() { block_parameter_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { block_parameter_def(this, _, _, result, _) }
}

class BlockParameters extends @block_parameters, AstNode {
  override string describeQlClass() { result = "BlockParameters" }

  override Location getLocation() { block_parameters_def(this, _, _, result) }

  AstNode getChild(int i) { block_parameters_child(this, i, result) }

  override AstNode getParent() { block_parameters_def(this, result, _, _) }

  override int getParentIndex() { block_parameters_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { block_parameters_child(this, _, result) }
}

class Break extends @break, AstNode {
  override string describeQlClass() { result = "Break" }

  override Location getLocation() { break_def(this, _, _, result) }

  ArgumentList getChild() { break_child(this, result) }

  override AstNode getParent() { break_def(this, result, _, _) }

  override int getParentIndex() { break_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { break_child(this, result) }
}

class Call extends @call, AstNode {
  override string describeQlClass() { result = "Call" }

  override Location getLocation() { call_def(this, _, _, _, _, result) }

  AstNode getMethod() { call_def(this, _, _, result, _, _) }

  AstNode getReceiver() { call_def(this, _, _, _, result, _) }

  override AstNode getParent() { call_def(this, result, _, _, _, _) }

  override int getParentIndex() { call_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    call_def(this, _, _, result, _, _) or call_def(this, _, _, _, result, _)
  }
}

class Case extends @case__, AstNode {
  override string describeQlClass() { result = "Case" }

  override Location getLocation() { case_def(this, _, _, result) }

  UnderscoreStatement getValue() { case_value(this, result) }

  AstNode getChild(int i) { case_child(this, i, result) }

  override AstNode getParent() { case_def(this, result, _, _) }

  override int getParentIndex() { case_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { case_value(this, result) or case_child(this, _, result) }
}

class ChainedString extends @chained_string, AstNode {
  override string describeQlClass() { result = "ChainedString" }

  override Location getLocation() { chained_string_def(this, _, _, result) }

  String getChild(int i) { chained_string_child(this, i, result) }

  override AstNode getParent() { chained_string_def(this, result, _, _) }

  override int getParentIndex() { chained_string_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { chained_string_child(this, _, result) }
}

class Character extends @token_character, Token {
  override string describeQlClass() { result = "Character" }
}

class Class extends @class, AstNode {
  override string describeQlClass() { result = "Class" }

  override Location getLocation() { class_def(this, _, _, _, result) }

  AstNode getName() { class_def(this, _, _, result, _) }

  AstNode getChild(int i) { class_child(this, i, result) }

  override AstNode getParent() { class_def(this, result, _, _, _) }

  override int getParentIndex() { class_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    class_def(this, _, _, result, _) or class_child(this, _, result)
  }
}

class ClassVariable extends @token_class_variable, Token {
  override string describeQlClass() { result = "ClassVariable" }
}

class Comment extends @token_comment, Token {
  override string describeQlClass() { result = "Comment" }
}

class Complex extends @token_complex, Token {
  override string describeQlClass() { result = "Complex" }
}

class Conditional extends @conditional, AstNode {
  override string describeQlClass() { result = "Conditional" }

  override Location getLocation() { conditional_def(this, _, _, _, _, _, result) }

  UnderscoreArg getAlternative() { conditional_def(this, _, _, result, _, _, _) }

  UnderscoreArg getCondition() { conditional_def(this, _, _, _, result, _, _) }

  UnderscoreArg getConsequence() { conditional_def(this, _, _, _, _, result, _) }

  override AstNode getParent() { conditional_def(this, result, _, _, _, _, _) }

  override int getParentIndex() { conditional_def(this, _, result, _, _, _, _) }

  override AstNode getAFieldOrChild() {
    conditional_def(this, _, _, result, _, _, _) or
    conditional_def(this, _, _, _, result, _, _) or
    conditional_def(this, _, _, _, _, result, _)
  }
}

class Constant extends @token_constant, Token {
  override string describeQlClass() { result = "Constant" }
}

class DestructuredLeftAssignment extends @destructured_left_assignment, AstNode {
  override string describeQlClass() { result = "DestructuredLeftAssignment" }

  override Location getLocation() { destructured_left_assignment_def(this, _, _, result) }

  AstNode getChild(int i) { destructured_left_assignment_child(this, i, result) }

  override AstNode getParent() { destructured_left_assignment_def(this, result, _, _) }

  override int getParentIndex() { destructured_left_assignment_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { destructured_left_assignment_child(this, _, result) }
}

class DestructuredParameter extends @destructured_parameter, AstNode {
  override string describeQlClass() { result = "DestructuredParameter" }

  override Location getLocation() { destructured_parameter_def(this, _, _, result) }

  AstNode getChild(int i) { destructured_parameter_child(this, i, result) }

  override AstNode getParent() { destructured_parameter_def(this, result, _, _) }

  override int getParentIndex() { destructured_parameter_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { destructured_parameter_child(this, _, result) }
}

class Do extends @do, AstNode {
  override string describeQlClass() { result = "Do" }

  override Location getLocation() { do_def(this, _, _, result) }

  AstNode getChild(int i) { do_child(this, i, result) }

  override AstNode getParent() { do_def(this, result, _, _) }

  override int getParentIndex() { do_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { do_child(this, _, result) }
}

class DoBlock extends @do_block, AstNode {
  override string describeQlClass() { result = "DoBlock" }

  override Location getLocation() { do_block_def(this, _, _, result) }

  AstNode getChild(int i) { do_block_child(this, i, result) }

  override AstNode getParent() { do_block_def(this, result, _, _) }

  override int getParentIndex() { do_block_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { do_block_child(this, _, result) }
}

class ElementReference extends @element_reference, AstNode {
  override string describeQlClass() { result = "ElementReference" }

  override Location getLocation() { element_reference_def(this, _, _, _, result) }

  UnderscorePrimary getObject() { element_reference_def(this, _, _, result, _) }

  AstNode getChild(int i) { element_reference_child(this, i, result) }

  override AstNode getParent() { element_reference_def(this, result, _, _, _) }

  override int getParentIndex() { element_reference_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    element_reference_def(this, _, _, result, _) or element_reference_child(this, _, result)
  }
}

class Else extends @else, AstNode {
  override string describeQlClass() { result = "Else" }

  override Location getLocation() { else_def(this, _, _, result) }

  AstNode getChild(int i) { else_child(this, i, result) }

  override AstNode getParent() { else_def(this, result, _, _) }

  override int getParentIndex() { else_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { else_child(this, _, result) }
}

class Elsif extends @elsif, AstNode {
  override string describeQlClass() { result = "Elsif" }

  override Location getLocation() { elsif_def(this, _, _, _, result) }

  AstNode getAlternative() { elsif_alternative(this, result) }

  UnderscoreStatement getCondition() { elsif_def(this, _, _, result, _) }

  Then getConsequence() { elsif_consequence(this, result) }

  override AstNode getParent() { elsif_def(this, result, _, _, _) }

  override int getParentIndex() { elsif_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    elsif_alternative(this, result) or
    elsif_def(this, _, _, result, _) or
    elsif_consequence(this, result)
  }
}

class EmptyStatement extends @token_empty_statement, Token {
  override string describeQlClass() { result = "EmptyStatement" }
}

class EndBlock extends @end_block, AstNode {
  override string describeQlClass() { result = "EndBlock" }

  override Location getLocation() { end_block_def(this, _, _, result) }

  AstNode getChild(int i) { end_block_child(this, i, result) }

  override AstNode getParent() { end_block_def(this, result, _, _) }

  override int getParentIndex() { end_block_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { end_block_child(this, _, result) }
}

class Ensure extends @ensure, AstNode {
  override string describeQlClass() { result = "Ensure" }

  override Location getLocation() { ensure_def(this, _, _, result) }

  AstNode getChild(int i) { ensure_child(this, i, result) }

  override AstNode getParent() { ensure_def(this, result, _, _) }

  override int getParentIndex() { ensure_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { ensure_child(this, _, result) }
}

class EscapeSequence extends @token_escape_sequence, Token {
  override string describeQlClass() { result = "EscapeSequence" }
}

class ExceptionVariable extends @exception_variable, AstNode {
  override string describeQlClass() { result = "ExceptionVariable" }

  override Location getLocation() { exception_variable_def(this, _, _, _, result) }

  UnderscoreLhs getChild() { exception_variable_def(this, _, _, result, _) }

  override AstNode getParent() { exception_variable_def(this, result, _, _, _) }

  override int getParentIndex() { exception_variable_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { exception_variable_def(this, _, _, result, _) }
}

class Exceptions extends @exceptions, AstNode {
  override string describeQlClass() { result = "Exceptions" }

  override Location getLocation() { exceptions_def(this, _, _, result) }

  AstNode getChild(int i) { exceptions_child(this, i, result) }

  override AstNode getParent() { exceptions_def(this, result, _, _) }

  override int getParentIndex() { exceptions_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { exceptions_child(this, _, result) }
}

class False extends @token_false, Token {
  override string describeQlClass() { result = "False" }
}

class Float extends @token_float, Token {
  override string describeQlClass() { result = "Float" }
}

class For extends @for, AstNode {
  override string describeQlClass() { result = "For" }

  override Location getLocation() { for_def(this, _, _, _, _, result) }

  Do getBody() { for_def(this, _, _, result, _, _) }

  AstNode getPattern(int i) { for_pattern(this, i, result) }

  In getValue() { for_def(this, _, _, _, result, _) }

  override AstNode getParent() { for_def(this, result, _, _, _, _) }

  override int getParentIndex() { for_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    for_def(this, _, _, result, _, _) or
    for_pattern(this, _, result) or
    for_def(this, _, _, _, result, _)
  }
}

class GlobalVariable extends @token_global_variable, Token {
  override string describeQlClass() { result = "GlobalVariable" }
}

class Hash extends @hash, AstNode {
  override string describeQlClass() { result = "Hash" }

  override Location getLocation() { hash_def(this, _, _, result) }

  AstNode getChild(int i) { hash_child(this, i, result) }

  override AstNode getParent() { hash_def(this, result, _, _) }

  override int getParentIndex() { hash_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { hash_child(this, _, result) }
}

class HashSplatArgument extends @hash_splat_argument, AstNode {
  override string describeQlClass() { result = "HashSplatArgument" }

  override Location getLocation() { hash_splat_argument_def(this, _, _, _, result) }

  UnderscoreArg getChild() { hash_splat_argument_def(this, _, _, result, _) }

  override AstNode getParent() { hash_splat_argument_def(this, result, _, _, _) }

  override int getParentIndex() { hash_splat_argument_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { hash_splat_argument_def(this, _, _, result, _) }
}

class HashSplatParameter extends @hash_splat_parameter, AstNode {
  override string describeQlClass() { result = "HashSplatParameter" }

  override Location getLocation() { hash_splat_parameter_def(this, _, _, result) }

  Identifier getName() { hash_splat_parameter_name(this, result) }

  override AstNode getParent() { hash_splat_parameter_def(this, result, _, _) }

  override int getParentIndex() { hash_splat_parameter_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { hash_splat_parameter_name(this, result) }
}

class HeredocBeginning extends @token_heredoc_beginning, Token {
  override string describeQlClass() { result = "HeredocBeginning" }
}

class HeredocBody extends @heredoc_body, AstNode {
  override string describeQlClass() { result = "HeredocBody" }

  override Location getLocation() { heredoc_body_def(this, _, _, result) }

  AstNode getChild(int i) { heredoc_body_child(this, i, result) }

  override AstNode getParent() { heredoc_body_def(this, result, _, _) }

  override int getParentIndex() { heredoc_body_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { heredoc_body_child(this, _, result) }
}

class HeredocContent extends @token_heredoc_content, Token {
  override string describeQlClass() { result = "HeredocContent" }
}

class HeredocEnd extends @token_heredoc_end, Token {
  override string describeQlClass() { result = "HeredocEnd" }
}

class Identifier extends @token_identifier, Token {
  override string describeQlClass() { result = "Identifier" }
}

class If extends @if, AstNode {
  override string describeQlClass() { result = "If" }

  override Location getLocation() { if_def(this, _, _, _, result) }

  AstNode getAlternative() { if_alternative(this, result) }

  UnderscoreStatement getCondition() { if_def(this, _, _, result, _) }

  Then getConsequence() { if_consequence(this, result) }

  override AstNode getParent() { if_def(this, result, _, _, _) }

  override int getParentIndex() { if_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    if_alternative(this, result) or if_def(this, _, _, result, _) or if_consequence(this, result)
  }
}

class IfModifier extends @if_modifier, AstNode {
  override string describeQlClass() { result = "IfModifier" }

  override Location getLocation() { if_modifier_def(this, _, _, _, _, result) }

  UnderscoreStatement getBody() { if_modifier_def(this, _, _, result, _, _) }

  AstNode getCondition() { if_modifier_def(this, _, _, _, result, _) }

  override AstNode getParent() { if_modifier_def(this, result, _, _, _, _) }

  override int getParentIndex() { if_modifier_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    if_modifier_def(this, _, _, result, _, _) or if_modifier_def(this, _, _, _, result, _)
  }
}

class In extends @in, AstNode {
  override string describeQlClass() { result = "In" }

  override Location getLocation() { in_def(this, _, _, _, result) }

  UnderscoreArg getChild() { in_def(this, _, _, result, _) }

  override AstNode getParent() { in_def(this, result, _, _, _) }

  override int getParentIndex() { in_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { in_def(this, _, _, result, _) }
}

class InstanceVariable extends @token_instance_variable, Token {
  override string describeQlClass() { result = "InstanceVariable" }
}

class Integer extends @token_integer, Token {
  override string describeQlClass() { result = "Integer" }
}

class Interpolation extends @interpolation, AstNode {
  override string describeQlClass() { result = "Interpolation" }

  override Location getLocation() { interpolation_def(this, _, _, _, result) }

  UnderscoreStatement getChild() { interpolation_def(this, _, _, result, _) }

  override AstNode getParent() { interpolation_def(this, result, _, _, _) }

  override int getParentIndex() { interpolation_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { interpolation_def(this, _, _, result, _) }
}

class KeywordParameter extends @keyword_parameter, AstNode {
  override string describeQlClass() { result = "KeywordParameter" }

  override Location getLocation() { keyword_parameter_def(this, _, _, _, result) }

  Identifier getName() { keyword_parameter_def(this, _, _, result, _) }

  UnderscoreArg getValue() { keyword_parameter_value(this, result) }

  override AstNode getParent() { keyword_parameter_def(this, result, _, _, _) }

  override int getParentIndex() { keyword_parameter_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    keyword_parameter_def(this, _, _, result, _) or keyword_parameter_value(this, result)
  }
}

class Lambda extends @lambda, AstNode {
  override string describeQlClass() { result = "Lambda" }

  override Location getLocation() { lambda_def(this, _, _, _, result) }

  AstNode getBody() { lambda_def(this, _, _, result, _) }

  LambdaParameters getParameters() { lambda_parameters(this, result) }

  override AstNode getParent() { lambda_def(this, result, _, _, _) }

  override int getParentIndex() { lambda_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    lambda_def(this, _, _, result, _) or lambda_parameters(this, result)
  }
}

class LambdaParameters extends @lambda_parameters, AstNode {
  override string describeQlClass() { result = "LambdaParameters" }

  override Location getLocation() { lambda_parameters_def(this, _, _, result) }

  AstNode getChild(int i) { lambda_parameters_child(this, i, result) }

  override AstNode getParent() { lambda_parameters_def(this, result, _, _) }

  override int getParentIndex() { lambda_parameters_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { lambda_parameters_child(this, _, result) }
}

class LeftAssignmentList extends @left_assignment_list, AstNode {
  override string describeQlClass() { result = "LeftAssignmentList" }

  override Location getLocation() { left_assignment_list_def(this, _, _, result) }

  AstNode getChild(int i) { left_assignment_list_child(this, i, result) }

  override AstNode getParent() { left_assignment_list_def(this, result, _, _) }

  override int getParentIndex() { left_assignment_list_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { left_assignment_list_child(this, _, result) }
}

class Method extends @method, AstNode {
  override string describeQlClass() { result = "Method" }

  override Location getLocation() { method_def(this, _, _, _, result) }

  UnderscoreMethodName getName() { method_def(this, _, _, result, _) }

  MethodParameters getParameters() { method_parameters(this, result) }

  AstNode getChild(int i) { method_child(this, i, result) }

  override AstNode getParent() { method_def(this, result, _, _, _) }

  override int getParentIndex() { method_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    method_def(this, _, _, result, _) or
    method_parameters(this, result) or
    method_child(this, _, result)
  }
}

class MethodCall extends @method_call, AstNode {
  override string describeQlClass() { result = "MethodCall" }

  override Location getLocation() { method_call_def(this, _, _, _, result) }

  ArgumentList getArguments() { method_call_arguments(this, result) }

  AstNode getBlock() { method_call_block(this, result) }

  AstNode getMethod() { method_call_def(this, _, _, result, _) }

  override AstNode getParent() { method_call_def(this, result, _, _, _) }

  override int getParentIndex() { method_call_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    method_call_arguments(this, result) or
    method_call_block(this, result) or
    method_call_def(this, _, _, result, _)
  }
}

class MethodParameters extends @method_parameters, AstNode {
  override string describeQlClass() { result = "MethodParameters" }

  override Location getLocation() { method_parameters_def(this, _, _, result) }

  AstNode getChild(int i) { method_parameters_child(this, i, result) }

  override AstNode getParent() { method_parameters_def(this, result, _, _) }

  override int getParentIndex() { method_parameters_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { method_parameters_child(this, _, result) }
}

class Module extends @module, AstNode {
  override string describeQlClass() { result = "Module" }

  override Location getLocation() { module_def(this, _, _, _, result) }

  AstNode getName() { module_def(this, _, _, result, _) }

  AstNode getChild(int i) { module_child(this, i, result) }

  override AstNode getParent() { module_def(this, result, _, _, _) }

  override int getParentIndex() { module_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    module_def(this, _, _, result, _) or module_child(this, _, result)
  }
}

class Next extends @next, AstNode {
  override string describeQlClass() { result = "Next" }

  override Location getLocation() { next_def(this, _, _, result) }

  ArgumentList getChild() { next_child(this, result) }

  override AstNode getParent() { next_def(this, result, _, _) }

  override int getParentIndex() { next_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { next_child(this, result) }
}

class Nil extends @token_nil, Token {
  override string describeQlClass() { result = "Nil" }
}

class Operator extends @token_operator, Token {
  override string describeQlClass() { result = "Operator" }
}

class OperatorAssignment extends @operator_assignment, AstNode {
  override string describeQlClass() { result = "OperatorAssignment" }

  override Location getLocation() { operator_assignment_def(this, _, _, _, _, result) }

  UnderscoreLhs getLeft() { operator_assignment_def(this, _, _, result, _, _) }

  AstNode getRight() { operator_assignment_def(this, _, _, _, result, _) }

  override AstNode getParent() { operator_assignment_def(this, result, _, _, _, _) }

  override int getParentIndex() { operator_assignment_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    operator_assignment_def(this, _, _, result, _, _) or
    operator_assignment_def(this, _, _, _, result, _)
  }
}

class OptionalParameter extends @optional_parameter, AstNode {
  override string describeQlClass() { result = "OptionalParameter" }

  override Location getLocation() { optional_parameter_def(this, _, _, _, _, result) }

  Identifier getName() { optional_parameter_def(this, _, _, result, _, _) }

  UnderscoreArg getValue() { optional_parameter_def(this, _, _, _, result, _) }

  override AstNode getParent() { optional_parameter_def(this, result, _, _, _, _) }

  override int getParentIndex() { optional_parameter_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    optional_parameter_def(this, _, _, result, _, _) or
    optional_parameter_def(this, _, _, _, result, _)
  }
}

class Pair extends @pair, AstNode {
  override string describeQlClass() { result = "Pair" }

  override Location getLocation() { pair_def(this, _, _, _, _, result) }

  AstNode getKey() { pair_def(this, _, _, result, _, _) }

  UnderscoreArg getValue() { pair_def(this, _, _, _, result, _) }

  override AstNode getParent() { pair_def(this, result, _, _, _, _) }

  override int getParentIndex() { pair_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    pair_def(this, _, _, result, _, _) or pair_def(this, _, _, _, result, _)
  }
}

class ParenthesizedStatements extends @parenthesized_statements, AstNode {
  override string describeQlClass() { result = "ParenthesizedStatements" }

  override Location getLocation() { parenthesized_statements_def(this, _, _, result) }

  AstNode getChild(int i) { parenthesized_statements_child(this, i, result) }

  override AstNode getParent() { parenthesized_statements_def(this, result, _, _) }

  override int getParentIndex() { parenthesized_statements_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
}

class Pattern extends @pattern, AstNode {
  override string describeQlClass() { result = "Pattern" }

  override Location getLocation() { pattern_def(this, _, _, _, result) }

  AstNode getChild() { pattern_def(this, _, _, result, _) }

  override AstNode getParent() { pattern_def(this, result, _, _, _) }

  override int getParentIndex() { pattern_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { pattern_def(this, _, _, result, _) }
}

class Program extends @program, AstNode {
  override string describeQlClass() { result = "Program" }

  override Location getLocation() { program_def(this, _, _, result) }

  AstNode getChild(int i) { program_child(this, i, result) }

  override AstNode getParent() { program_def(this, result, _, _) }

  override int getParentIndex() { program_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { program_child(this, _, result) }
}

class Range extends @range, AstNode {
  override string describeQlClass() { result = "Range" }

  override Location getLocation() { range_def(this, _, _, result) }

  UnderscoreArg getChild(int i) { range_child(this, i, result) }

  override AstNode getParent() { range_def(this, result, _, _) }

  override int getParentIndex() { range_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { range_child(this, _, result) }
}

class Rational extends @rational, AstNode {
  override string describeQlClass() { result = "Rational" }

  override Location getLocation() { rational_def(this, _, _, _, result) }

  Integer getChild() { rational_def(this, _, _, result, _) }

  override AstNode getParent() { rational_def(this, result, _, _, _) }

  override int getParentIndex() { rational_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { rational_def(this, _, _, result, _) }
}

class Redo extends @redo, AstNode {
  override string describeQlClass() { result = "Redo" }

  override Location getLocation() { redo_def(this, _, _, result) }

  ArgumentList getChild() { redo_child(this, result) }

  override AstNode getParent() { redo_def(this, result, _, _) }

  override int getParentIndex() { redo_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { redo_child(this, result) }
}

class Regex extends @regex, AstNode {
  override string describeQlClass() { result = "Regex" }

  override Location getLocation() { regex_def(this, _, _, result) }

  AstNode getChild(int i) { regex_child(this, i, result) }

  override AstNode getParent() { regex_def(this, result, _, _) }

  override int getParentIndex() { regex_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { regex_child(this, _, result) }
}

class Rescue extends @rescue, AstNode {
  override string describeQlClass() { result = "Rescue" }

  override Location getLocation() { rescue_def(this, _, _, result) }

  Then getBody() { rescue_body(this, result) }

  Exceptions getExceptions() { rescue_exceptions(this, result) }

  ExceptionVariable getVariable() { rescue_variable(this, result) }

  override AstNode getParent() { rescue_def(this, result, _, _) }

  override int getParentIndex() { rescue_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    rescue_body(this, result) or rescue_exceptions(this, result) or rescue_variable(this, result)
  }
}

class RescueModifier extends @rescue_modifier, AstNode {
  override string describeQlClass() { result = "RescueModifier" }

  override Location getLocation() { rescue_modifier_def(this, _, _, _, _, result) }

  UnderscoreStatement getBody() { rescue_modifier_def(this, _, _, result, _, _) }

  AstNode getHandler() { rescue_modifier_def(this, _, _, _, result, _) }

  override AstNode getParent() { rescue_modifier_def(this, result, _, _, _, _) }

  override int getParentIndex() { rescue_modifier_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    rescue_modifier_def(this, _, _, result, _, _) or rescue_modifier_def(this, _, _, _, result, _)
  }
}

class RestAssignment extends @rest_assignment, AstNode {
  override string describeQlClass() { result = "RestAssignment" }

  override Location getLocation() { rest_assignment_def(this, _, _, result) }

  UnderscoreLhs getChild() { rest_assignment_child(this, result) }

  override AstNode getParent() { rest_assignment_def(this, result, _, _) }

  override int getParentIndex() { rest_assignment_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { rest_assignment_child(this, result) }
}

class Retry extends @retry, AstNode {
  override string describeQlClass() { result = "Retry" }

  override Location getLocation() { retry_def(this, _, _, result) }

  ArgumentList getChild() { retry_child(this, result) }

  override AstNode getParent() { retry_def(this, result, _, _) }

  override int getParentIndex() { retry_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { retry_child(this, result) }
}

class Return extends @return, AstNode {
  override string describeQlClass() { result = "Return" }

  override Location getLocation() { return_def(this, _, _, result) }

  ArgumentList getChild() { return_child(this, result) }

  override AstNode getParent() { return_def(this, result, _, _) }

  override int getParentIndex() { return_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { return_child(this, result) }
}

class RightAssignmentList extends @right_assignment_list, AstNode {
  override string describeQlClass() { result = "RightAssignmentList" }

  override Location getLocation() { right_assignment_list_def(this, _, _, result) }

  AstNode getChild(int i) { right_assignment_list_child(this, i, result) }

  override AstNode getParent() { right_assignment_list_def(this, result, _, _) }

  override int getParentIndex() { right_assignment_list_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { right_assignment_list_child(this, _, result) }
}

class ScopeResolution extends @scope_resolution, AstNode {
  override string describeQlClass() { result = "ScopeResolution" }

  override Location getLocation() { scope_resolution_def(this, _, _, _, result) }

  AstNode getName() { scope_resolution_def(this, _, _, result, _) }

  UnderscorePrimary getScope() { scope_resolution_scope(this, result) }

  override AstNode getParent() { scope_resolution_def(this, result, _, _, _) }

  override int getParentIndex() { scope_resolution_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    scope_resolution_def(this, _, _, result, _) or scope_resolution_scope(this, result)
  }
}

class Self extends @token_self, Token {
  override string describeQlClass() { result = "Self" }
}

class Setter extends @setter, AstNode {
  override string describeQlClass() { result = "Setter" }

  override Location getLocation() { setter_def(this, _, _, _, result) }

  Identifier getChild() { setter_def(this, _, _, result, _) }

  override AstNode getParent() { setter_def(this, result, _, _, _) }

  override int getParentIndex() { setter_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { setter_def(this, _, _, result, _) }
}

class SingletonClass extends @singleton_class, AstNode {
  override string describeQlClass() { result = "SingletonClass" }

  override Location getLocation() { singleton_class_def(this, _, _, _, result) }

  UnderscoreArg getValue() { singleton_class_def(this, _, _, result, _) }

  AstNode getChild(int i) { singleton_class_child(this, i, result) }

  override AstNode getParent() { singleton_class_def(this, result, _, _, _) }

  override int getParentIndex() { singleton_class_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    singleton_class_def(this, _, _, result, _) or singleton_class_child(this, _, result)
  }
}

class SingletonMethod extends @singleton_method, AstNode {
  override string describeQlClass() { result = "SingletonMethod" }

  override Location getLocation() { singleton_method_def(this, _, _, _, _, result) }

  UnderscoreMethodName getName() { singleton_method_def(this, _, _, result, _, _) }

  AstNode getObject() { singleton_method_def(this, _, _, _, result, _) }

  MethodParameters getParameters() { singleton_method_parameters(this, result) }

  AstNode getChild(int i) { singleton_method_child(this, i, result) }

  override AstNode getParent() { singleton_method_def(this, result, _, _, _, _) }

  override int getParentIndex() { singleton_method_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    singleton_method_def(this, _, _, result, _, _) or
    singleton_method_def(this, _, _, _, result, _) or
    singleton_method_parameters(this, result) or
    singleton_method_child(this, _, result)
  }
}

class SplatArgument extends @splat_argument, AstNode {
  override string describeQlClass() { result = "SplatArgument" }

  override Location getLocation() { splat_argument_def(this, _, _, _, result) }

  UnderscoreArg getChild() { splat_argument_def(this, _, _, result, _) }

  override AstNode getParent() { splat_argument_def(this, result, _, _, _) }

  override int getParentIndex() { splat_argument_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { splat_argument_def(this, _, _, result, _) }
}

class SplatParameter extends @splat_parameter, AstNode {
  override string describeQlClass() { result = "SplatParameter" }

  override Location getLocation() { splat_parameter_def(this, _, _, result) }

  Identifier getName() { splat_parameter_name(this, result) }

  override AstNode getParent() { splat_parameter_def(this, result, _, _) }

  override int getParentIndex() { splat_parameter_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { splat_parameter_name(this, result) }
}

class String extends @string__, AstNode {
  override string describeQlClass() { result = "String" }

  override Location getLocation() { string_def(this, _, _, result) }

  AstNode getChild(int i) { string_child(this, i, result) }

  override AstNode getParent() { string_def(this, result, _, _) }

  override int getParentIndex() { string_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { string_child(this, _, result) }
}

class StringArray extends @string_array, AstNode {
  override string describeQlClass() { result = "StringArray" }

  override Location getLocation() { string_array_def(this, _, _, result) }

  BareString getChild(int i) { string_array_child(this, i, result) }

  override AstNode getParent() { string_array_def(this, result, _, _) }

  override int getParentIndex() { string_array_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { string_array_child(this, _, result) }
}

class StringContent extends @token_string_content, Token {
  override string describeQlClass() { result = "StringContent" }
}

class Subshell extends @subshell, AstNode {
  override string describeQlClass() { result = "Subshell" }

  override Location getLocation() { subshell_def(this, _, _, result) }

  AstNode getChild(int i) { subshell_child(this, i, result) }

  override AstNode getParent() { subshell_def(this, result, _, _) }

  override int getParentIndex() { subshell_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { subshell_child(this, _, result) }
}

class Super extends @token_super, Token {
  override string describeQlClass() { result = "Super" }
}

class Superclass extends @superclass, AstNode {
  override string describeQlClass() { result = "Superclass" }

  override Location getLocation() { superclass_def(this, _, _, _, result) }

  AstNode getChild() { superclass_def(this, _, _, result, _) }

  override AstNode getParent() { superclass_def(this, result, _, _, _) }

  override int getParentIndex() { superclass_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() { superclass_def(this, _, _, result, _) }
}

class Symbol extends @symbol, AstNode {
  override string describeQlClass() { result = "Symbol" }

  override Location getLocation() { symbol_def(this, _, _, result) }

  AstNode getChild(int i) { symbol_child(this, i, result) }

  override AstNode getParent() { symbol_def(this, result, _, _) }

  override int getParentIndex() { symbol_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { symbol_child(this, _, result) }
}

class SymbolArray extends @symbol_array, AstNode {
  override string describeQlClass() { result = "SymbolArray" }

  override Location getLocation() { symbol_array_def(this, _, _, result) }

  BareSymbol getChild(int i) { symbol_array_child(this, i, result) }

  override AstNode getParent() { symbol_array_def(this, result, _, _) }

  override int getParentIndex() { symbol_array_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { symbol_array_child(this, _, result) }
}

class Then extends @then, AstNode {
  override string describeQlClass() { result = "Then" }

  override Location getLocation() { then_def(this, _, _, result) }

  AstNode getChild(int i) { then_child(this, i, result) }

  override AstNode getParent() { then_def(this, result, _, _) }

  override int getParentIndex() { then_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { then_child(this, _, result) }
}

class True extends @token_true, Token {
  override string describeQlClass() { result = "True" }
}

class Unary extends @unary, AstNode {
  override string describeQlClass() { result = "Unary" }

  override Location getLocation() { unary_def(this, _, _, _, _, result) }

  AstNode getOperand() { unary_def(this, _, _, result, _, _) }

  AstNode getOperator() { unary_def(this, _, _, _, result, _) }

  override AstNode getParent() { unary_def(this, result, _, _, _, _) }

  override int getParentIndex() { unary_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    unary_def(this, _, _, result, _, _) or unary_def(this, _, _, _, result, _)
  }
}

class Undef extends @undef, AstNode {
  override string describeQlClass() { result = "Undef" }

  override Location getLocation() { undef_def(this, _, _, result) }

  UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

  override AstNode getParent() { undef_def(this, result, _, _) }

  override int getParentIndex() { undef_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { undef_child(this, _, result) }
}

class Uninterpreted extends @token_uninterpreted, Token {
  override string describeQlClass() { result = "Uninterpreted" }
}

class Unless extends @unless, AstNode {
  override string describeQlClass() { result = "Unless" }

  override Location getLocation() { unless_def(this, _, _, _, result) }

  AstNode getAlternative() { unless_alternative(this, result) }

  UnderscoreStatement getCondition() { unless_def(this, _, _, result, _) }

  Then getConsequence() { unless_consequence(this, result) }

  override AstNode getParent() { unless_def(this, result, _, _, _) }

  override int getParentIndex() { unless_def(this, _, result, _, _) }

  override AstNode getAFieldOrChild() {
    unless_alternative(this, result) or
    unless_def(this, _, _, result, _) or
    unless_consequence(this, result)
  }
}

class UnlessModifier extends @unless_modifier, AstNode {
  override string describeQlClass() { result = "UnlessModifier" }

  override Location getLocation() { unless_modifier_def(this, _, _, _, _, result) }

  UnderscoreStatement getBody() { unless_modifier_def(this, _, _, result, _, _) }

  AstNode getCondition() { unless_modifier_def(this, _, _, _, result, _) }

  override AstNode getParent() { unless_modifier_def(this, result, _, _, _, _) }

  override int getParentIndex() { unless_modifier_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    unless_modifier_def(this, _, _, result, _, _) or unless_modifier_def(this, _, _, _, result, _)
  }
}

class Until extends @until, AstNode {
  override string describeQlClass() { result = "Until" }

  override Location getLocation() { until_def(this, _, _, _, _, result) }

  Do getBody() { until_def(this, _, _, result, _, _) }

  UnderscoreStatement getCondition() { until_def(this, _, _, _, result, _) }

  override AstNode getParent() { until_def(this, result, _, _, _, _) }

  override int getParentIndex() { until_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    until_def(this, _, _, result, _, _) or until_def(this, _, _, _, result, _)
  }
}

class UntilModifier extends @until_modifier, AstNode {
  override string describeQlClass() { result = "UntilModifier" }

  override Location getLocation() { until_modifier_def(this, _, _, _, _, result) }

  UnderscoreStatement getBody() { until_modifier_def(this, _, _, result, _, _) }

  AstNode getCondition() { until_modifier_def(this, _, _, _, result, _) }

  override AstNode getParent() { until_modifier_def(this, result, _, _, _, _) }

  override int getParentIndex() { until_modifier_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    until_modifier_def(this, _, _, result, _, _) or until_modifier_def(this, _, _, _, result, _)
  }
}

class When extends @when, AstNode {
  override string describeQlClass() { result = "When" }

  override Location getLocation() { when_def(this, _, _, result) }

  Then getBody() { when_body(this, result) }

  AstNode getPattern(int i) { when_pattern(this, i, result) }

  override AstNode getParent() { when_def(this, result, _, _) }

  override int getParentIndex() { when_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { when_body(this, result) or when_pattern(this, _, result) }
}

class While extends @while, AstNode {
  override string describeQlClass() { result = "While" }

  override Location getLocation() { while_def(this, _, _, _, _, result) }

  Do getBody() { while_def(this, _, _, result, _, _) }

  UnderscoreStatement getCondition() { while_def(this, _, _, _, result, _) }

  override AstNode getParent() { while_def(this, result, _, _, _, _) }

  override int getParentIndex() { while_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    while_def(this, _, _, result, _, _) or while_def(this, _, _, _, result, _)
  }
}

class WhileModifier extends @while_modifier, AstNode {
  override string describeQlClass() { result = "WhileModifier" }

  override Location getLocation() { while_modifier_def(this, _, _, _, _, result) }

  UnderscoreStatement getBody() { while_modifier_def(this, _, _, result, _, _) }

  AstNode getCondition() { while_modifier_def(this, _, _, _, result, _) }

  override AstNode getParent() { while_modifier_def(this, result, _, _, _, _) }

  override int getParentIndex() { while_modifier_def(this, _, result, _, _, _) }

  override AstNode getAFieldOrChild() {
    while_modifier_def(this, _, _, result, _, _) or while_modifier_def(this, _, _, _, result, _)
  }
}

class Yield extends @yield, AstNode {
  override string describeQlClass() { result = "Yield" }

  override Location getLocation() { yield_def(this, _, _, result) }

  ArgumentList getChild() { yield_child(this, result) }

  override AstNode getParent() { yield_def(this, result, _, _) }

  override int getParentIndex() { yield_def(this, _, result, _) }

  override AstNode getAFieldOrChild() { yield_child(this, result) }
}
