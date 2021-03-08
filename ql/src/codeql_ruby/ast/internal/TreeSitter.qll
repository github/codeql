/*
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

module Generated {
  private import codeql.files.FileSystem
  private import codeql.Locations

  class AstNode extends @ast_node {
    string toString() { result = this.getAPrimaryQlClass() }

    Location getLocation() { none() }

    AstNode getParent() { none() }

    int getParentIndex() { none() }

    AstNode getAFieldOrChild() { none() }

    string getAPrimaryQlClass() { result = "???" }
  }

  class Token extends @token, AstNode {
    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    string getValue() { tokeninfo(this, _, _, _, result, _) }

    override Location getLocation() { tokeninfo(this, _, _, _, _, result) }

    override string toString() { result = getValue() }

    override string getAPrimaryQlClass() { result = "Token" }
  }

  class ReservedWord extends @reserved_word, Token {
    override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  class UnderscoreArg extends @underscore_arg, AstNode { }

  class UnderscoreLhs extends @underscore_lhs, AstNode { }

  class UnderscoreMethodName extends @underscore_method_name, AstNode { }

  class UnderscorePrimary extends @underscore_primary, AstNode { }

  class UnderscoreStatement extends @underscore_statement, AstNode { }

  class UnderscoreVariable extends @underscore_variable, AstNode { }

  class Alias extends @alias, AstNode {
    override string getAPrimaryQlClass() { result = "Alias" }

    override Location getLocation() { alias_def(this, _, _, result) }

    UnderscoreMethodName getAlias() { alias_def(this, result, _, _) }

    UnderscoreMethodName getName() { alias_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      alias_def(this, result, _, _) or alias_def(this, _, result, _)
    }
  }

  class ArgumentList extends @argument_list, AstNode {
    override string getAPrimaryQlClass() { result = "ArgumentList" }

    override Location getLocation() { argument_list_def(this, result) }

    AstNode getChild(int i) { argument_list_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { argument_list_child(this, _, result) }
  }

  class Array extends @array, AstNode {
    override string getAPrimaryQlClass() { result = "Array" }

    override Location getLocation() { array_def(this, result) }

    AstNode getChild(int i) { array_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { array_child(this, _, result) }
  }

  class Assignment extends @assignment, AstNode {
    override string getAPrimaryQlClass() { result = "Assignment" }

    override Location getLocation() { assignment_def(this, _, _, result) }

    AstNode getLeft() { assignment_def(this, result, _, _) }

    AstNode getRight() { assignment_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      assignment_def(this, result, _, _) or assignment_def(this, _, result, _)
    }
  }

  class BareString extends @bare_string, AstNode {
    override string getAPrimaryQlClass() { result = "BareString" }

    override Location getLocation() { bare_string_def(this, result) }

    AstNode getChild(int i) { bare_string_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { bare_string_child(this, _, result) }
  }

  class BareSymbol extends @bare_symbol, AstNode {
    override string getAPrimaryQlClass() { result = "BareSymbol" }

    override Location getLocation() { bare_symbol_def(this, result) }

    AstNode getChild(int i) { bare_symbol_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { bare_symbol_child(this, _, result) }
  }

  class Begin extends @begin, AstNode {
    override string getAPrimaryQlClass() { result = "Begin" }

    override Location getLocation() { begin_def(this, result) }

    AstNode getChild(int i) { begin_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { begin_child(this, _, result) }
  }

  class BeginBlock extends @begin_block, AstNode {
    override string getAPrimaryQlClass() { result = "BeginBlock" }

    override Location getLocation() { begin_block_def(this, result) }

    AstNode getChild(int i) { begin_block_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { begin_block_child(this, _, result) }
  }

  class Binary extends @binary, AstNode {
    override string getAPrimaryQlClass() { result = "Binary" }

    override Location getLocation() { binary_def(this, _, _, _, result) }

    AstNode getLeft() { binary_def(this, result, _, _, _) }

    string getOperator() {
      exists(int value | binary_def(this, _, value, _, _) |
        result = "!=" and value = 0
        or
        result = "!~" and value = 1
        or
        result = "%" and value = 2
        or
        result = "&" and value = 3
        or
        result = "&&" and value = 4
        or
        result = "*" and value = 5
        or
        result = "**" and value = 6
        or
        result = "+" and value = 7
        or
        result = "-" and value = 8
        or
        result = "/" and value = 9
        or
        result = "<" and value = 10
        or
        result = "<<" and value = 11
        or
        result = "<=" and value = 12
        or
        result = "<=>" and value = 13
        or
        result = "==" and value = 14
        or
        result = "===" and value = 15
        or
        result = "=~" and value = 16
        or
        result = ">" and value = 17
        or
        result = ">=" and value = 18
        or
        result = ">>" and value = 19
        or
        result = "^" and value = 20
        or
        result = "and" and value = 21
        or
        result = "or" and value = 22
        or
        result = "|" and value = 23
        or
        result = "||" and value = 24
      )
    }

    AstNode getRight() { binary_def(this, _, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      binary_def(this, result, _, _, _) or binary_def(this, _, _, result, _)
    }
  }

  class Block extends @block, AstNode {
    override string getAPrimaryQlClass() { result = "Block" }

    override Location getLocation() { block_def(this, result) }

    BlockParameters getParameters() { block_parameters(this, result) }

    AstNode getChild(int i) { block_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      block_parameters(this, result) or block_child(this, _, result)
    }
  }

  class BlockArgument extends @block_argument, AstNode {
    override string getAPrimaryQlClass() { result = "BlockArgument" }

    override Location getLocation() { block_argument_def(this, _, result) }

    UnderscoreArg getChild() { block_argument_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { block_argument_def(this, result, _) }
  }

  class BlockParameter extends @block_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "BlockParameter" }

    override Location getLocation() { block_parameter_def(this, _, result) }

    Identifier getName() { block_parameter_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { block_parameter_def(this, result, _) }
  }

  class BlockParameters extends @block_parameters, AstNode {
    override string getAPrimaryQlClass() { result = "BlockParameters" }

    override Location getLocation() { block_parameters_def(this, result) }

    AstNode getChild(int i) { block_parameters_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { block_parameters_child(this, _, result) }
  }

  class Break extends @break, AstNode {
    override string getAPrimaryQlClass() { result = "Break" }

    override Location getLocation() { break_def(this, result) }

    ArgumentList getChild() { break_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { break_child(this, result) }
  }

  class Call extends @call, AstNode {
    override string getAPrimaryQlClass() { result = "Call" }

    override Location getLocation() { call_def(this, _, result) }

    ArgumentList getArguments() { call_arguments(this, result) }

    AstNode getBlock() { call_block(this, result) }

    AstNode getMethod() { call_def(this, result, _) }

    AstNode getReceiver() { call_receiver(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      call_arguments(this, result) or
      call_block(this, result) or
      call_def(this, result, _) or
      call_receiver(this, result)
    }
  }

  class Case extends @case__, AstNode {
    override string getAPrimaryQlClass() { result = "Case" }

    override Location getLocation() { case_def(this, result) }

    UnderscoreStatement getValue() { case_value(this, result) }

    AstNode getChild(int i) { case_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { case_value(this, result) or case_child(this, _, result) }
  }

  class ChainedString extends @chained_string, AstNode {
    override string getAPrimaryQlClass() { result = "ChainedString" }

    override Location getLocation() { chained_string_def(this, result) }

    String getChild(int i) { chained_string_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { chained_string_child(this, _, result) }
  }

  class Character extends @token_character, Token {
    override string getAPrimaryQlClass() { result = "Character" }
  }

  class Class extends @class, AstNode {
    override string getAPrimaryQlClass() { result = "Class" }

    override Location getLocation() { class_def(this, _, result) }

    AstNode getName() { class_def(this, result, _) }

    Superclass getSuperclass() { class_superclass(this, result) }

    AstNode getChild(int i) { class_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      class_def(this, result, _) or class_superclass(this, result) or class_child(this, _, result)
    }
  }

  class ClassVariable extends @token_class_variable, Token {
    override string getAPrimaryQlClass() { result = "ClassVariable" }
  }

  class Comment extends @token_comment, Token {
    override string getAPrimaryQlClass() { result = "Comment" }
  }

  class Complex extends @token_complex, Token {
    override string getAPrimaryQlClass() { result = "Complex" }
  }

  class Conditional extends @conditional, AstNode {
    override string getAPrimaryQlClass() { result = "Conditional" }

    override Location getLocation() { conditional_def(this, _, _, _, result) }

    UnderscoreArg getAlternative() { conditional_def(this, result, _, _, _) }

    UnderscoreArg getCondition() { conditional_def(this, _, result, _, _) }

    UnderscoreArg getConsequence() { conditional_def(this, _, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      conditional_def(this, result, _, _, _) or
      conditional_def(this, _, result, _, _) or
      conditional_def(this, _, _, result, _)
    }
  }

  class Constant extends @token_constant, Token {
    override string getAPrimaryQlClass() { result = "Constant" }
  }

  class DelimitedSymbol extends @delimited_symbol, AstNode {
    override string getAPrimaryQlClass() { result = "DelimitedSymbol" }

    override Location getLocation() { delimited_symbol_def(this, result) }

    AstNode getChild(int i) { delimited_symbol_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { delimited_symbol_child(this, _, result) }
  }

  class DestructuredLeftAssignment extends @destructured_left_assignment, AstNode {
    override string getAPrimaryQlClass() { result = "DestructuredLeftAssignment" }

    override Location getLocation() { destructured_left_assignment_def(this, result) }

    AstNode getChild(int i) { destructured_left_assignment_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { destructured_left_assignment_child(this, _, result) }
  }

  class DestructuredParameter extends @destructured_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "DestructuredParameter" }

    override Location getLocation() { destructured_parameter_def(this, result) }

    AstNode getChild(int i) { destructured_parameter_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { destructured_parameter_child(this, _, result) }
  }

  class Do extends @do, AstNode {
    override string getAPrimaryQlClass() { result = "Do" }

    override Location getLocation() { do_def(this, result) }

    AstNode getChild(int i) { do_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { do_child(this, _, result) }
  }

  class DoBlock extends @do_block, AstNode {
    override string getAPrimaryQlClass() { result = "DoBlock" }

    override Location getLocation() { do_block_def(this, result) }

    BlockParameters getParameters() { do_block_parameters(this, result) }

    AstNode getChild(int i) { do_block_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      do_block_parameters(this, result) or do_block_child(this, _, result)
    }
  }

  class ElementReference extends @element_reference, AstNode {
    override string getAPrimaryQlClass() { result = "ElementReference" }

    override Location getLocation() { element_reference_def(this, _, result) }

    UnderscorePrimary getObject() { element_reference_def(this, result, _) }

    AstNode getChild(int i) { element_reference_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      element_reference_def(this, result, _) or element_reference_child(this, _, result)
    }
  }

  class Else extends @else, AstNode {
    override string getAPrimaryQlClass() { result = "Else" }

    override Location getLocation() { else_def(this, result) }

    AstNode getChild(int i) { else_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { else_child(this, _, result) }
  }

  class Elsif extends @elsif, AstNode {
    override string getAPrimaryQlClass() { result = "Elsif" }

    override Location getLocation() { elsif_def(this, _, result) }

    AstNode getAlternative() { elsif_alternative(this, result) }

    UnderscoreStatement getCondition() { elsif_def(this, result, _) }

    Then getConsequence() { elsif_consequence(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      elsif_alternative(this, result) or
      elsif_def(this, result, _) or
      elsif_consequence(this, result)
    }
  }

  class EmptyStatement extends @token_empty_statement, Token {
    override string getAPrimaryQlClass() { result = "EmptyStatement" }
  }

  class EndBlock extends @end_block, AstNode {
    override string getAPrimaryQlClass() { result = "EndBlock" }

    override Location getLocation() { end_block_def(this, result) }

    AstNode getChild(int i) { end_block_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { end_block_child(this, _, result) }
  }

  class Ensure extends @ensure, AstNode {
    override string getAPrimaryQlClass() { result = "Ensure" }

    override Location getLocation() { ensure_def(this, result) }

    AstNode getChild(int i) { ensure_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { ensure_child(this, _, result) }
  }

  class EscapeSequence extends @token_escape_sequence, Token {
    override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  class ExceptionVariable extends @exception_variable, AstNode {
    override string getAPrimaryQlClass() { result = "ExceptionVariable" }

    override Location getLocation() { exception_variable_def(this, _, result) }

    UnderscoreLhs getChild() { exception_variable_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { exception_variable_def(this, result, _) }
  }

  class Exceptions extends @exceptions, AstNode {
    override string getAPrimaryQlClass() { result = "Exceptions" }

    override Location getLocation() { exceptions_def(this, result) }

    AstNode getChild(int i) { exceptions_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { exceptions_child(this, _, result) }
  }

  class False extends @token_false, Token {
    override string getAPrimaryQlClass() { result = "False" }
  }

  class Float extends @token_float, Token {
    override string getAPrimaryQlClass() { result = "Float" }
  }

  class For extends @for, AstNode {
    override string getAPrimaryQlClass() { result = "For" }

    override Location getLocation() { for_def(this, _, _, _, result) }

    Do getBody() { for_def(this, result, _, _, _) }

    AstNode getPattern() { for_def(this, _, result, _, _) }

    In getValue() { for_def(this, _, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      for_def(this, result, _, _, _) or
      for_def(this, _, result, _, _) or
      for_def(this, _, _, result, _)
    }
  }

  class GlobalVariable extends @token_global_variable, Token {
    override string getAPrimaryQlClass() { result = "GlobalVariable" }
  }

  class Hash extends @hash, AstNode {
    override string getAPrimaryQlClass() { result = "Hash" }

    override Location getLocation() { hash_def(this, result) }

    AstNode getChild(int i) { hash_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { hash_child(this, _, result) }
  }

  class HashKeySymbol extends @token_hash_key_symbol, Token {
    override string getAPrimaryQlClass() { result = "HashKeySymbol" }
  }

  class HashSplatArgument extends @hash_splat_argument, AstNode {
    override string getAPrimaryQlClass() { result = "HashSplatArgument" }

    override Location getLocation() { hash_splat_argument_def(this, _, result) }

    UnderscoreArg getChild() { hash_splat_argument_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { hash_splat_argument_def(this, result, _) }
  }

  class HashSplatParameter extends @hash_splat_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "HashSplatParameter" }

    override Location getLocation() { hash_splat_parameter_def(this, result) }

    Identifier getName() { hash_splat_parameter_name(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { hash_splat_parameter_name(this, result) }
  }

  class HeredocBeginning extends @token_heredoc_beginning, Token {
    override string getAPrimaryQlClass() { result = "HeredocBeginning" }
  }

  class HeredocBody extends @heredoc_body, AstNode {
    override string getAPrimaryQlClass() { result = "HeredocBody" }

    override Location getLocation() { heredoc_body_def(this, result) }

    AstNode getChild(int i) { heredoc_body_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { heredoc_body_child(this, _, result) }
  }

  class HeredocContent extends @token_heredoc_content, Token {
    override string getAPrimaryQlClass() { result = "HeredocContent" }
  }

  class HeredocEnd extends @token_heredoc_end, Token {
    override string getAPrimaryQlClass() { result = "HeredocEnd" }
  }

  class Identifier extends @token_identifier, Token {
    override string getAPrimaryQlClass() { result = "Identifier" }
  }

  class If extends @if, AstNode {
    override string getAPrimaryQlClass() { result = "If" }

    override Location getLocation() { if_def(this, _, result) }

    AstNode getAlternative() { if_alternative(this, result) }

    UnderscoreStatement getCondition() { if_def(this, result, _) }

    Then getConsequence() { if_consequence(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      if_alternative(this, result) or if_def(this, result, _) or if_consequence(this, result)
    }
  }

  class IfModifier extends @if_modifier, AstNode {
    override string getAPrimaryQlClass() { result = "IfModifier" }

    override Location getLocation() { if_modifier_def(this, _, _, result) }

    UnderscoreStatement getBody() { if_modifier_def(this, result, _, _) }

    AstNode getCondition() { if_modifier_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      if_modifier_def(this, result, _, _) or if_modifier_def(this, _, result, _)
    }
  }

  class In extends @in, AstNode {
    override string getAPrimaryQlClass() { result = "In" }

    override Location getLocation() { in_def(this, _, result) }

    UnderscoreArg getChild() { in_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { in_def(this, result, _) }
  }

  class InstanceVariable extends @token_instance_variable, Token {
    override string getAPrimaryQlClass() { result = "InstanceVariable" }
  }

  class Integer extends @token_integer, Token {
    override string getAPrimaryQlClass() { result = "Integer" }
  }

  class Interpolation extends @interpolation, AstNode {
    override string getAPrimaryQlClass() { result = "Interpolation" }

    override Location getLocation() { interpolation_def(this, result) }

    AstNode getChild(int i) { interpolation_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { interpolation_child(this, _, result) }
  }

  class KeywordParameter extends @keyword_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "KeywordParameter" }

    override Location getLocation() { keyword_parameter_def(this, _, result) }

    Identifier getName() { keyword_parameter_def(this, result, _) }

    UnderscoreArg getValue() { keyword_parameter_value(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      keyword_parameter_def(this, result, _) or keyword_parameter_value(this, result)
    }
  }

  class Lambda extends @lambda, AstNode {
    override string getAPrimaryQlClass() { result = "Lambda" }

    override Location getLocation() { lambda_def(this, _, result) }

    AstNode getBody() { lambda_def(this, result, _) }

    LambdaParameters getParameters() { lambda_parameters(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      lambda_def(this, result, _) or lambda_parameters(this, result)
    }
  }

  class LambdaParameters extends @lambda_parameters, AstNode {
    override string getAPrimaryQlClass() { result = "LambdaParameters" }

    override Location getLocation() { lambda_parameters_def(this, result) }

    AstNode getChild(int i) { lambda_parameters_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { lambda_parameters_child(this, _, result) }
  }

  class LeftAssignmentList extends @left_assignment_list, AstNode {
    override string getAPrimaryQlClass() { result = "LeftAssignmentList" }

    override Location getLocation() { left_assignment_list_def(this, result) }

    AstNode getChild(int i) { left_assignment_list_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { left_assignment_list_child(this, _, result) }
  }

  class Method extends @method, AstNode {
    override string getAPrimaryQlClass() { result = "Method" }

    override Location getLocation() { method_def(this, _, result) }

    UnderscoreMethodName getName() { method_def(this, result, _) }

    MethodParameters getParameters() { method_parameters(this, result) }

    AstNode getChild(int i) { method_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      method_def(this, result, _) or
      method_parameters(this, result) or
      method_child(this, _, result)
    }
  }

  class MethodParameters extends @method_parameters, AstNode {
    override string getAPrimaryQlClass() { result = "MethodParameters" }

    override Location getLocation() { method_parameters_def(this, result) }

    AstNode getChild(int i) { method_parameters_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { method_parameters_child(this, _, result) }
  }

  class Module extends @module, AstNode {
    override string getAPrimaryQlClass() { result = "Module" }

    override Location getLocation() { module_def(this, _, result) }

    AstNode getName() { module_def(this, result, _) }

    AstNode getChild(int i) { module_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      module_def(this, result, _) or module_child(this, _, result)
    }
  }

  class Next extends @next, AstNode {
    override string getAPrimaryQlClass() { result = "Next" }

    override Location getLocation() { next_def(this, result) }

    ArgumentList getChild() { next_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { next_child(this, result) }
  }

  class Nil extends @token_nil, Token {
    override string getAPrimaryQlClass() { result = "Nil" }
  }

  class Operator extends @token_operator, Token {
    override string getAPrimaryQlClass() { result = "Operator" }
  }

  class OperatorAssignment extends @operator_assignment, AstNode {
    override string getAPrimaryQlClass() { result = "OperatorAssignment" }

    override Location getLocation() { operator_assignment_def(this, _, _, _, result) }

    UnderscoreLhs getLeft() { operator_assignment_def(this, result, _, _, _) }

    string getOperator() {
      exists(int value | operator_assignment_def(this, _, value, _, _) |
        result = "%=" and value = 0
        or
        result = "&&=" and value = 1
        or
        result = "&=" and value = 2
        or
        result = "**=" and value = 3
        or
        result = "*=" and value = 4
        or
        result = "+=" and value = 5
        or
        result = "-=" and value = 6
        or
        result = "/=" and value = 7
        or
        result = "<<=" and value = 8
        or
        result = ">>=" and value = 9
        or
        result = "^=" and value = 10
        or
        result = "|=" and value = 11
        or
        result = "||=" and value = 12
      )
    }

    AstNode getRight() { operator_assignment_def(this, _, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      operator_assignment_def(this, result, _, _, _) or
      operator_assignment_def(this, _, _, result, _)
    }
  }

  class OptionalParameter extends @optional_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "OptionalParameter" }

    override Location getLocation() { optional_parameter_def(this, _, _, result) }

    Identifier getName() { optional_parameter_def(this, result, _, _) }

    UnderscoreArg getValue() { optional_parameter_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      optional_parameter_def(this, result, _, _) or optional_parameter_def(this, _, result, _)
    }
  }

  class Pair extends @pair, AstNode {
    override string getAPrimaryQlClass() { result = "Pair" }

    override Location getLocation() { pair_def(this, _, _, result) }

    AstNode getKey() { pair_def(this, result, _, _) }

    UnderscoreArg getValue() { pair_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      pair_def(this, result, _, _) or pair_def(this, _, result, _)
    }
  }

  class ParenthesizedStatements extends @parenthesized_statements, AstNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedStatements" }

    override Location getLocation() { parenthesized_statements_def(this, result) }

    AstNode getChild(int i) { parenthesized_statements_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
  }

  class Pattern extends @pattern, AstNode {
    override string getAPrimaryQlClass() { result = "Pattern" }

    override Location getLocation() { pattern_def(this, _, result) }

    AstNode getChild() { pattern_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { pattern_def(this, result, _) }
  }

  class Program extends @program, AstNode {
    override string getAPrimaryQlClass() { result = "Program" }

    override Location getLocation() { program_def(this, result) }

    AstNode getChild(int i) { program_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { program_child(this, _, result) }
  }

  class Range extends @range, AstNode {
    override string getAPrimaryQlClass() { result = "Range" }

    override Location getLocation() { range_def(this, _, result) }

    UnderscoreArg getBegin() { range_begin(this, result) }

    UnderscoreArg getEnd() { range_end(this, result) }

    string getOperator() {
      exists(int value | range_def(this, value, _) |
        result = ".." and value = 0
        or
        result = "..." and value = 1
      )
    }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { range_begin(this, result) or range_end(this, result) }
  }

  class Rational extends @rational, AstNode {
    override string getAPrimaryQlClass() { result = "Rational" }

    override Location getLocation() { rational_def(this, _, result) }

    AstNode getChild() { rational_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { rational_def(this, result, _) }
  }

  class Redo extends @redo, AstNode {
    override string getAPrimaryQlClass() { result = "Redo" }

    override Location getLocation() { redo_def(this, result) }

    ArgumentList getChild() { redo_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { redo_child(this, result) }
  }

  class Regex extends @regex, AstNode {
    override string getAPrimaryQlClass() { result = "Regex" }

    override Location getLocation() { regex_def(this, result) }

    AstNode getChild(int i) { regex_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { regex_child(this, _, result) }
  }

  class Rescue extends @rescue, AstNode {
    override string getAPrimaryQlClass() { result = "Rescue" }

    override Location getLocation() { rescue_def(this, result) }

    Then getBody() { rescue_body(this, result) }

    Exceptions getExceptions() { rescue_exceptions(this, result) }

    ExceptionVariable getVariable() { rescue_variable(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      rescue_body(this, result) or rescue_exceptions(this, result) or rescue_variable(this, result)
    }
  }

  class RescueModifier extends @rescue_modifier, AstNode {
    override string getAPrimaryQlClass() { result = "RescueModifier" }

    override Location getLocation() { rescue_modifier_def(this, _, _, result) }

    UnderscoreStatement getBody() { rescue_modifier_def(this, result, _, _) }

    AstNode getHandler() { rescue_modifier_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      rescue_modifier_def(this, result, _, _) or rescue_modifier_def(this, _, result, _)
    }
  }

  class RestAssignment extends @rest_assignment, AstNode {
    override string getAPrimaryQlClass() { result = "RestAssignment" }

    override Location getLocation() { rest_assignment_def(this, result) }

    UnderscoreLhs getChild() { rest_assignment_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { rest_assignment_child(this, result) }
  }

  class Retry extends @retry, AstNode {
    override string getAPrimaryQlClass() { result = "Retry" }

    override Location getLocation() { retry_def(this, result) }

    ArgumentList getChild() { retry_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { retry_child(this, result) }
  }

  class Return extends @return, AstNode {
    override string getAPrimaryQlClass() { result = "Return" }

    override Location getLocation() { return_def(this, result) }

    ArgumentList getChild() { return_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { return_child(this, result) }
  }

  class RightAssignmentList extends @right_assignment_list, AstNode {
    override string getAPrimaryQlClass() { result = "RightAssignmentList" }

    override Location getLocation() { right_assignment_list_def(this, result) }

    AstNode getChild(int i) { right_assignment_list_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { right_assignment_list_child(this, _, result) }
  }

  class ScopeResolution extends @scope_resolution, AstNode {
    override string getAPrimaryQlClass() { result = "ScopeResolution" }

    override Location getLocation() { scope_resolution_def(this, _, result) }

    AstNode getName() { scope_resolution_def(this, result, _) }

    UnderscorePrimary getScope() { scope_resolution_scope(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      scope_resolution_def(this, result, _) or scope_resolution_scope(this, result)
    }
  }

  class Self extends @token_self, Token {
    override string getAPrimaryQlClass() { result = "Self" }
  }

  class Setter extends @setter, AstNode {
    override string getAPrimaryQlClass() { result = "Setter" }

    override Location getLocation() { setter_def(this, _, result) }

    Identifier getName() { setter_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { setter_def(this, result, _) }
  }

  class SimpleSymbol extends @token_simple_symbol, Token {
    override string getAPrimaryQlClass() { result = "SimpleSymbol" }
  }

  class SingletonClass extends @singleton_class, AstNode {
    override string getAPrimaryQlClass() { result = "SingletonClass" }

    override Location getLocation() { singleton_class_def(this, _, result) }

    UnderscoreArg getValue() { singleton_class_def(this, result, _) }

    AstNode getChild(int i) { singleton_class_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      singleton_class_def(this, result, _) or singleton_class_child(this, _, result)
    }
  }

  class SingletonMethod extends @singleton_method, AstNode {
    override string getAPrimaryQlClass() { result = "SingletonMethod" }

    override Location getLocation() { singleton_method_def(this, _, _, result) }

    UnderscoreMethodName getName() { singleton_method_def(this, result, _, _) }

    AstNode getObject() { singleton_method_def(this, _, result, _) }

    MethodParameters getParameters() { singleton_method_parameters(this, result) }

    AstNode getChild(int i) { singleton_method_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      singleton_method_def(this, result, _, _) or
      singleton_method_def(this, _, result, _) or
      singleton_method_parameters(this, result) or
      singleton_method_child(this, _, result)
    }
  }

  class SplatArgument extends @splat_argument, AstNode {
    override string getAPrimaryQlClass() { result = "SplatArgument" }

    override Location getLocation() { splat_argument_def(this, _, result) }

    UnderscoreArg getChild() { splat_argument_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { splat_argument_def(this, result, _) }
  }

  class SplatParameter extends @splat_parameter, AstNode {
    override string getAPrimaryQlClass() { result = "SplatParameter" }

    override Location getLocation() { splat_parameter_def(this, result) }

    Identifier getName() { splat_parameter_name(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { splat_parameter_name(this, result) }
  }

  class String extends @string__, AstNode {
    override string getAPrimaryQlClass() { result = "String" }

    override Location getLocation() { string_def(this, result) }

    AstNode getChild(int i) { string_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { string_child(this, _, result) }
  }

  class StringArray extends @string_array, AstNode {
    override string getAPrimaryQlClass() { result = "StringArray" }

    override Location getLocation() { string_array_def(this, result) }

    BareString getChild(int i) { string_array_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { string_array_child(this, _, result) }
  }

  class StringContent extends @token_string_content, Token {
    override string getAPrimaryQlClass() { result = "StringContent" }
  }

  class Subshell extends @subshell, AstNode {
    override string getAPrimaryQlClass() { result = "Subshell" }

    override Location getLocation() { subshell_def(this, result) }

    AstNode getChild(int i) { subshell_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { subshell_child(this, _, result) }
  }

  class Super extends @token_super, Token {
    override string getAPrimaryQlClass() { result = "Super" }
  }

  class Superclass extends @superclass, AstNode {
    override string getAPrimaryQlClass() { result = "Superclass" }

    override Location getLocation() { superclass_def(this, _, result) }

    AstNode getChild() { superclass_def(this, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { superclass_def(this, result, _) }
  }

  class SymbolArray extends @symbol_array, AstNode {
    override string getAPrimaryQlClass() { result = "SymbolArray" }

    override Location getLocation() { symbol_array_def(this, result) }

    BareSymbol getChild(int i) { symbol_array_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { symbol_array_child(this, _, result) }
  }

  class Then extends @then, AstNode {
    override string getAPrimaryQlClass() { result = "Then" }

    override Location getLocation() { then_def(this, result) }

    AstNode getChild(int i) { then_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { then_child(this, _, result) }
  }

  class True extends @token_true, Token {
    override string getAPrimaryQlClass() { result = "True" }
  }

  class Unary extends @unary, AstNode {
    override string getAPrimaryQlClass() { result = "Unary" }

    override Location getLocation() { unary_def(this, _, _, result) }

    AstNode getOperand() { unary_def(this, result, _, _) }

    string getOperator() {
      exists(int value | unary_def(this, _, value, _) |
        result = "!" and value = 0
        or
        result = "+" and value = 1
        or
        result = "-" and value = 2
        or
        result = "defined?" and value = 3
        or
        result = "not" and value = 4
        or
        result = "~" and value = 5
      )
    }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { unary_def(this, result, _, _) }
  }

  class Undef extends @undef, AstNode {
    override string getAPrimaryQlClass() { result = "Undef" }

    override Location getLocation() { undef_def(this, result) }

    UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { undef_child(this, _, result) }
  }

  class Uninterpreted extends @token_uninterpreted, Token {
    override string getAPrimaryQlClass() { result = "Uninterpreted" }
  }

  class Unless extends @unless, AstNode {
    override string getAPrimaryQlClass() { result = "Unless" }

    override Location getLocation() { unless_def(this, _, result) }

    AstNode getAlternative() { unless_alternative(this, result) }

    UnderscoreStatement getCondition() { unless_def(this, result, _) }

    Then getConsequence() { unless_consequence(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      unless_alternative(this, result) or
      unless_def(this, result, _) or
      unless_consequence(this, result)
    }
  }

  class UnlessModifier extends @unless_modifier, AstNode {
    override string getAPrimaryQlClass() { result = "UnlessModifier" }

    override Location getLocation() { unless_modifier_def(this, _, _, result) }

    UnderscoreStatement getBody() { unless_modifier_def(this, result, _, _) }

    AstNode getCondition() { unless_modifier_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      unless_modifier_def(this, result, _, _) or unless_modifier_def(this, _, result, _)
    }
  }

  class Until extends @until, AstNode {
    override string getAPrimaryQlClass() { result = "Until" }

    override Location getLocation() { until_def(this, _, _, result) }

    Do getBody() { until_def(this, result, _, _) }

    UnderscoreStatement getCondition() { until_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      until_def(this, result, _, _) or until_def(this, _, result, _)
    }
  }

  class UntilModifier extends @until_modifier, AstNode {
    override string getAPrimaryQlClass() { result = "UntilModifier" }

    override Location getLocation() { until_modifier_def(this, _, _, result) }

    UnderscoreStatement getBody() { until_modifier_def(this, result, _, _) }

    AstNode getCondition() { until_modifier_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      until_modifier_def(this, result, _, _) or until_modifier_def(this, _, result, _)
    }
  }

  class When extends @when, AstNode {
    override string getAPrimaryQlClass() { result = "When" }

    override Location getLocation() { when_def(this, result) }

    Then getBody() { when_body(this, result) }

    Pattern getPattern(int i) { when_pattern(this, i, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { when_body(this, result) or when_pattern(this, _, result) }
  }

  class While extends @while, AstNode {
    override string getAPrimaryQlClass() { result = "While" }

    override Location getLocation() { while_def(this, _, _, result) }

    Do getBody() { while_def(this, result, _, _) }

    UnderscoreStatement getCondition() { while_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      while_def(this, result, _, _) or while_def(this, _, result, _)
    }
  }

  class WhileModifier extends @while_modifier, AstNode {
    override string getAPrimaryQlClass() { result = "WhileModifier" }

    override Location getLocation() { while_modifier_def(this, _, _, result) }

    UnderscoreStatement getBody() { while_modifier_def(this, result, _, _) }

    AstNode getCondition() { while_modifier_def(this, _, result, _) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() {
      while_modifier_def(this, result, _, _) or while_modifier_def(this, _, result, _)
    }
  }

  class Yield extends @yield, AstNode {
    override string getAPrimaryQlClass() { result = "Yield" }

    override Location getLocation() { yield_def(this, result) }

    ArgumentList getChild() { yield_child(this, result) }

    override AstNode getParent() { ast_node_parent(this, result, _) }

    override int getParentIndex() { ast_node_parent(this, _, result) }

    override AstNode getAFieldOrChild() { yield_child(this, result) }
  }
}
