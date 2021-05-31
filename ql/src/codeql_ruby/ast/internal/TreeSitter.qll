/*
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

module Generated {
  private import codeql.files.FileSystem
  private import codeql.Locations

  /** The base class for all AST nodes */
  class AstNode extends @ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    Location getLocation() { none() }

    /** Gets the parent of this element. */
    AstNode getParent() { ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    int getParentIndex() { ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }
  }

  /** A token. */
  class Token extends @token, AstNode {
    /** Gets the value of this token. */
    string getValue() { tokeninfo(this, _, _, _, result, _) }

    /** Gets the location of this token. */
    override Location getLocation() { tokeninfo(this, _, _, _, _, result) }

    /** Gets a string representation of this element. */
    override string toString() { result = getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  class UnderscoreArg extends @underscore_arg, AstNode { }

  class UnderscoreLhs extends @underscore_lhs, AstNode { }

  class UnderscoreMethodName extends @underscore_method_name, AstNode { }

  class UnderscorePrimary extends @underscore_primary, AstNode { }

  class UnderscoreStatement extends @underscore_statement, AstNode { }

  class UnderscoreVariable extends @underscore_variable, AstNode { }

  /** A class representing `alias` nodes. */
  class Alias extends @alias, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Alias" }

    /** Gets the location of this element. */
    override Location getLocation() { alias_def(this, _, _, result) }

    /** Gets the node corresponding to the field `alias`. */
    UnderscoreMethodName getAlias() { alias_def(this, result, _, _) }

    /** Gets the node corresponding to the field `name`. */
    UnderscoreMethodName getName() { alias_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      alias_def(this, result, _, _) or alias_def(this, _, result, _)
    }
  }

  /** A class representing `argument_list` nodes. */
  class ArgumentList extends @argument_list, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ArgumentList" }

    /** Gets the location of this element. */
    override Location getLocation() { argument_list_def(this, result) }

    AstNode getChild(int i) { argument_list_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { argument_list_child(this, _, result) }
  }

  /** A class representing `array` nodes. */
  class Array extends @array, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Array" }

    /** Gets the location of this element. */
    override Location getLocation() { array_def(this, result) }

    AstNode getChild(int i) { array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { array_child(this, _, result) }
  }

  /** A class representing `assignment` nodes. */
  class Assignment extends @assignment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Assignment" }

    /** Gets the location of this element. */
    override Location getLocation() { assignment_def(this, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { assignment_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { assignment_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      assignment_def(this, result, _, _) or assignment_def(this, _, result, _)
    }
  }

  /** A class representing `bare_string` nodes. */
  class BareString extends @bare_string, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BareString" }

    /** Gets the location of this element. */
    override Location getLocation() { bare_string_def(this, result) }

    AstNode getChild(int i) { bare_string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { bare_string_child(this, _, result) }
  }

  /** A class representing `bare_symbol` nodes. */
  class BareSymbol extends @bare_symbol, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BareSymbol" }

    /** Gets the location of this element. */
    override Location getLocation() { bare_symbol_def(this, result) }

    AstNode getChild(int i) { bare_symbol_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { bare_symbol_child(this, _, result) }
  }

  /** A class representing `begin` nodes. */
  class Begin extends @begin, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Begin" }

    /** Gets the location of this element. */
    override Location getLocation() { begin_def(this, result) }

    AstNode getChild(int i) { begin_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { begin_child(this, _, result) }
  }

  /** A class representing `begin_block` nodes. */
  class BeginBlock extends @begin_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BeginBlock" }

    /** Gets the location of this element. */
    override Location getLocation() { begin_block_def(this, result) }

    AstNode getChild(int i) { begin_block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { begin_block_child(this, _, result) }
  }

  /** A class representing `binary` nodes. */
  class Binary extends @binary, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Binary" }

    /** Gets the location of this element. */
    override Location getLocation() { binary_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { binary_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `operator`. */
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

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { binary_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      binary_def(this, result, _, _, _) or binary_def(this, _, _, result, _)
    }
  }

  /** A class representing `block` nodes. */
  class Block extends @block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Block" }

    /** Gets the location of this element. */
    override Location getLocation() { block_def(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    BlockParameters getParameters() { block_parameters(this, result) }

    AstNode getChild(int i) { block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      block_parameters(this, result) or block_child(this, _, result)
    }
  }

  /** A class representing `block_argument` nodes. */
  class BlockArgument extends @block_argument, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BlockArgument" }

    /** Gets the location of this element. */
    override Location getLocation() { block_argument_def(this, _, result) }

    UnderscoreArg getChild() { block_argument_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { block_argument_def(this, result, _) }
  }

  /** A class representing `block_parameter` nodes. */
  class BlockParameter extends @block_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BlockParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { block_parameter_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { block_parameter_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { block_parameter_def(this, result, _) }
  }

  /** A class representing `block_parameters` nodes. */
  class BlockParameters extends @block_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BlockParameters" }

    /** Gets the location of this element. */
    override Location getLocation() { block_parameters_def(this, result) }

    AstNode getChild(int i) { block_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { block_parameters_child(this, _, result) }
  }

  /** A class representing `break` nodes. */
  class Break extends @break, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Break" }

    /** Gets the location of this element. */
    override Location getLocation() { break_def(this, result) }

    ArgumentList getChild() { break_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { break_child(this, result) }
  }

  /** A class representing `call` nodes. */
  class Call extends @call, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Call" }

    /** Gets the location of this element. */
    override Location getLocation() { call_def(this, _, result) }

    /** Gets the node corresponding to the field `arguments`. */
    ArgumentList getArguments() { call_arguments(this, result) }

    /** Gets the node corresponding to the field `block`. */
    AstNode getBlock() { call_block(this, result) }

    /** Gets the node corresponding to the field `method`. */
    AstNode getMethod() { call_def(this, result, _) }

    /** Gets the node corresponding to the field `receiver`. */
    AstNode getReceiver() { call_receiver(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      call_arguments(this, result) or
      call_block(this, result) or
      call_def(this, result, _) or
      call_receiver(this, result)
    }
  }

  /** A class representing `case` nodes. */
  class Case extends @case__, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Case" }

    /** Gets the location of this element. */
    override Location getLocation() { case_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    UnderscoreStatement getValue() { case_value(this, result) }

    AstNode getChild(int i) { case_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { case_value(this, result) or case_child(this, _, result) }
  }

  /** A class representing `chained_string` nodes. */
  class ChainedString extends @chained_string, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ChainedString" }

    /** Gets the location of this element. */
    override Location getLocation() { chained_string_def(this, result) }

    String getChild(int i) { chained_string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { chained_string_child(this, _, result) }
  }

  /** A class representing `character` tokens. */
  class Character extends @token_character, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Character" }
  }

  /** A class representing `class` nodes. */
  class Class extends @class, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Class" }

    /** Gets the location of this element. */
    override Location getLocation() { class_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    AstNode getName() { class_def(this, result, _) }

    /** Gets the node corresponding to the field `superclass`. */
    Superclass getSuperclass() { class_superclass(this, result) }

    AstNode getChild(int i) { class_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      class_def(this, result, _) or class_superclass(this, result) or class_child(this, _, result)
    }
  }

  /** A class representing `class_variable` tokens. */
  class ClassVariable extends @token_class_variable, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ClassVariable" }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @token_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `complex` tokens. */
  class Complex extends @token_complex, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Complex" }
  }

  /** A class representing `conditional` nodes. */
  class Conditional extends @conditional, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Conditional" }

    /** Gets the location of this element. */
    override Location getLocation() { conditional_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `alternative`. */
    UnderscoreArg getAlternative() { conditional_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreArg getCondition() { conditional_def(this, _, result, _, _) }

    /** Gets the node corresponding to the field `consequence`. */
    UnderscoreArg getConsequence() { conditional_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      conditional_def(this, result, _, _, _) or
      conditional_def(this, _, result, _, _) or
      conditional_def(this, _, _, result, _)
    }
  }

  /** A class representing `constant` tokens. */
  class Constant extends @token_constant, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Constant" }
  }

  /** A class representing `delimited_symbol` nodes. */
  class DelimitedSymbol extends @delimited_symbol, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DelimitedSymbol" }

    /** Gets the location of this element. */
    override Location getLocation() { delimited_symbol_def(this, result) }

    AstNode getChild(int i) { delimited_symbol_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { delimited_symbol_child(this, _, result) }
  }

  /** A class representing `destructured_left_assignment` nodes. */
  class DestructuredLeftAssignment extends @destructured_left_assignment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DestructuredLeftAssignment" }

    /** Gets the location of this element. */
    override Location getLocation() { destructured_left_assignment_def(this, result) }

    AstNode getChild(int i) { destructured_left_assignment_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { destructured_left_assignment_child(this, _, result) }
  }

  /** A class representing `destructured_parameter` nodes. */
  class DestructuredParameter extends @destructured_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DestructuredParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { destructured_parameter_def(this, result) }

    AstNode getChild(int i) { destructured_parameter_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { destructured_parameter_child(this, _, result) }
  }

  /** A class representing `do` nodes. */
  class Do extends @do, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Do" }

    /** Gets the location of this element. */
    override Location getLocation() { do_def(this, result) }

    AstNode getChild(int i) { do_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { do_child(this, _, result) }
  }

  /** A class representing `do_block` nodes. */
  class DoBlock extends @do_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DoBlock" }

    /** Gets the location of this element. */
    override Location getLocation() { do_block_def(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    BlockParameters getParameters() { do_block_parameters(this, result) }

    AstNode getChild(int i) { do_block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      do_block_parameters(this, result) or do_block_child(this, _, result)
    }
  }

  /** A class representing `element_reference` nodes. */
  class ElementReference extends @element_reference, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ElementReference" }

    /** Gets the location of this element. */
    override Location getLocation() { element_reference_def(this, _, result) }

    /** Gets the node corresponding to the field `object`. */
    UnderscorePrimary getObject() { element_reference_def(this, result, _) }

    AstNode getChild(int i) { element_reference_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      element_reference_def(this, result, _) or element_reference_child(this, _, result)
    }
  }

  /** A class representing `else` nodes. */
  class Else extends @else, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Else" }

    /** Gets the location of this element. */
    override Location getLocation() { else_def(this, result) }

    AstNode getChild(int i) { else_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { else_child(this, _, result) }
  }

  /** A class representing `elsif` nodes. */
  class Elsif extends @elsif, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Elsif" }

    /** Gets the location of this element. */
    override Location getLocation() { elsif_def(this, _, result) }

    /** Gets the node corresponding to the field `alternative`. */
    AstNode getAlternative() { elsif_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreStatement getCondition() { elsif_def(this, result, _) }

    /** Gets the node corresponding to the field `consequence`. */
    Then getConsequence() { elsif_consequence(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      elsif_alternative(this, result) or
      elsif_def(this, result, _) or
      elsif_consequence(this, result)
    }
  }

  /** A class representing `empty_statement` tokens. */
  class EmptyStatement extends @token_empty_statement, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "EmptyStatement" }
  }

  /** A class representing `end_block` nodes. */
  class EndBlock extends @end_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "EndBlock" }

    /** Gets the location of this element. */
    override Location getLocation() { end_block_def(this, result) }

    AstNode getChild(int i) { end_block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { end_block_child(this, _, result) }
  }

  /** A class representing `ensure` nodes. */
  class Ensure extends @ensure, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Ensure" }

    /** Gets the location of this element. */
    override Location getLocation() { ensure_def(this, result) }

    AstNode getChild(int i) { ensure_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { ensure_child(this, _, result) }
  }

  /** A class representing `escape_sequence` tokens. */
  class EscapeSequence extends @token_escape_sequence, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  /** A class representing `exception_variable` nodes. */
  class ExceptionVariable extends @exception_variable, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ExceptionVariable" }

    /** Gets the location of this element. */
    override Location getLocation() { exception_variable_def(this, _, result) }

    UnderscoreLhs getChild() { exception_variable_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { exception_variable_def(this, result, _) }
  }

  /** A class representing `exceptions` nodes. */
  class Exceptions extends @exceptions, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Exceptions" }

    /** Gets the location of this element. */
    override Location getLocation() { exceptions_def(this, result) }

    AstNode getChild(int i) { exceptions_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { exceptions_child(this, _, result) }
  }

  /** A class representing `false` tokens. */
  class False extends @token_false, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `float` tokens. */
  class Float extends @token_float, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `for` nodes. */
  class For extends @for, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "For" }

    /** Gets the location of this element. */
    override Location getLocation() { for_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    Do getBody() { for_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `pattern`. */
    AstNode getPattern() { for_def(this, _, result, _, _) }

    /** Gets the node corresponding to the field `value`. */
    In getValue() { for_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      for_def(this, result, _, _, _) or
      for_def(this, _, result, _, _) or
      for_def(this, _, _, result, _)
    }
  }

  /** A class representing `global_variable` tokens. */
  class GlobalVariable extends @token_global_variable, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "GlobalVariable" }
  }

  /** A class representing `hash` nodes. */
  class Hash extends @hash, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Hash" }

    /** Gets the location of this element. */
    override Location getLocation() { hash_def(this, result) }

    AstNode getChild(int i) { hash_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { hash_child(this, _, result) }
  }

  /** A class representing `hash_key_symbol` tokens. */
  class HashKeySymbol extends @token_hash_key_symbol, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HashKeySymbol" }
  }

  /** A class representing `hash_splat_argument` nodes. */
  class HashSplatArgument extends @hash_splat_argument, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HashSplatArgument" }

    /** Gets the location of this element. */
    override Location getLocation() { hash_splat_argument_def(this, _, result) }

    UnderscoreArg getChild() { hash_splat_argument_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { hash_splat_argument_def(this, result, _) }
  }

  /** A class representing `hash_splat_parameter` nodes. */
  class HashSplatParameter extends @hash_splat_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HashSplatParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { hash_splat_parameter_def(this, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { hash_splat_parameter_name(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { hash_splat_parameter_name(this, result) }
  }

  /** A class representing `heredoc_beginning` tokens. */
  class HeredocBeginning extends @token_heredoc_beginning, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HeredocBeginning" }
  }

  /** A class representing `heredoc_body` nodes. */
  class HeredocBody extends @heredoc_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HeredocBody" }

    /** Gets the location of this element. */
    override Location getLocation() { heredoc_body_def(this, result) }

    AstNode getChild(int i) { heredoc_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { heredoc_body_child(this, _, result) }
  }

  /** A class representing `heredoc_content` tokens. */
  class HeredocContent extends @token_heredoc_content, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HeredocContent" }
  }

  /** A class representing `heredoc_end` tokens. */
  class HeredocEnd extends @token_heredoc_end, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HeredocEnd" }
  }

  /** A class representing `identifier` tokens. */
  class Identifier extends @token_identifier, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Identifier" }
  }

  /** A class representing `if` nodes. */
  class If extends @if, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "If" }

    /** Gets the location of this element. */
    override Location getLocation() { if_def(this, _, result) }

    /** Gets the node corresponding to the field `alternative`. */
    AstNode getAlternative() { if_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreStatement getCondition() { if_def(this, result, _) }

    /** Gets the node corresponding to the field `consequence`. */
    Then getConsequence() { if_consequence(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      if_alternative(this, result) or if_def(this, result, _) or if_consequence(this, result)
    }
  }

  /** A class representing `if_modifier` nodes. */
  class IfModifier extends @if_modifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "IfModifier" }

    /** Gets the location of this element. */
    override Location getLocation() { if_modifier_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    UnderscoreStatement getBody() { if_modifier_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    AstNode getCondition() { if_modifier_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      if_modifier_def(this, result, _, _) or if_modifier_def(this, _, result, _)
    }
  }

  /** A class representing `in` nodes. */
  class In extends @in, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "In" }

    /** Gets the location of this element. */
    override Location getLocation() { in_def(this, _, result) }

    UnderscoreArg getChild() { in_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { in_def(this, result, _) }
  }

  /** A class representing `instance_variable` tokens. */
  class InstanceVariable extends @token_instance_variable, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "InstanceVariable" }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @token_integer, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `interpolation` nodes. */
  class Interpolation extends @interpolation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Interpolation" }

    /** Gets the location of this element. */
    override Location getLocation() { interpolation_def(this, result) }

    AstNode getChild(int i) { interpolation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { interpolation_child(this, _, result) }
  }

  /** A class representing `keyword_parameter` nodes. */
  class KeywordParameter extends @keyword_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "KeywordParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { keyword_parameter_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { keyword_parameter_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    UnderscoreArg getValue() { keyword_parameter_value(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      keyword_parameter_def(this, result, _) or keyword_parameter_value(this, result)
    }
  }

  /** A class representing `lambda` nodes. */
  class Lambda extends @lambda, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Lambda" }

    /** Gets the location of this element. */
    override Location getLocation() { lambda_def(this, _, result) }

    /** Gets the node corresponding to the field `body`. */
    AstNode getBody() { lambda_def(this, result, _) }

    /** Gets the node corresponding to the field `parameters`. */
    LambdaParameters getParameters() { lambda_parameters(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      lambda_def(this, result, _) or lambda_parameters(this, result)
    }
  }

  /** A class representing `lambda_parameters` nodes. */
  class LambdaParameters extends @lambda_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "LambdaParameters" }

    /** Gets the location of this element. */
    override Location getLocation() { lambda_parameters_def(this, result) }

    AstNode getChild(int i) { lambda_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { lambda_parameters_child(this, _, result) }
  }

  /** A class representing `left_assignment_list` nodes. */
  class LeftAssignmentList extends @left_assignment_list, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "LeftAssignmentList" }

    /** Gets the location of this element. */
    override Location getLocation() { left_assignment_list_def(this, result) }

    AstNode getChild(int i) { left_assignment_list_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { left_assignment_list_child(this, _, result) }
  }

  /** A class representing `method` nodes. */
  class Method extends @method, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Method" }

    /** Gets the location of this element. */
    override Location getLocation() { method_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    UnderscoreMethodName getName() { method_def(this, result, _) }

    /** Gets the node corresponding to the field `parameters`. */
    MethodParameters getParameters() { method_parameters(this, result) }

    AstNode getChild(int i) { method_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      method_def(this, result, _) or
      method_parameters(this, result) or
      method_child(this, _, result)
    }
  }

  /** A class representing `method_parameters` nodes. */
  class MethodParameters extends @method_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "MethodParameters" }

    /** Gets the location of this element. */
    override Location getLocation() { method_parameters_def(this, result) }

    AstNode getChild(int i) { method_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { method_parameters_child(this, _, result) }
  }

  /** A class representing `module` nodes. */
  class Module extends @module, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Module" }

    /** Gets the location of this element. */
    override Location getLocation() { module_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    AstNode getName() { module_def(this, result, _) }

    AstNode getChild(int i) { module_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      module_def(this, result, _) or module_child(this, _, result)
    }
  }

  /** A class representing `next` nodes. */
  class Next extends @next, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Next" }

    /** Gets the location of this element. */
    override Location getLocation() { next_def(this, result) }

    ArgumentList getChild() { next_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { next_child(this, result) }
  }

  /** A class representing `nil` tokens. */
  class Nil extends @token_nil, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Nil" }
  }

  /** A class representing `operator` tokens. */
  class Operator extends @token_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Operator" }
  }

  /** A class representing `operator_assignment` nodes. */
  class OperatorAssignment extends @operator_assignment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "OperatorAssignment" }

    /** Gets the location of this element. */
    override Location getLocation() { operator_assignment_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    UnderscoreLhs getLeft() { operator_assignment_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `operator`. */
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

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { operator_assignment_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      operator_assignment_def(this, result, _, _, _) or
      operator_assignment_def(this, _, _, result, _)
    }
  }

  /** A class representing `optional_parameter` nodes. */
  class OptionalParameter extends @optional_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "OptionalParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { optional_parameter_def(this, _, _, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { optional_parameter_def(this, result, _, _) }

    /** Gets the node corresponding to the field `value`. */
    UnderscoreArg getValue() { optional_parameter_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      optional_parameter_def(this, result, _, _) or optional_parameter_def(this, _, result, _)
    }
  }

  /** A class representing `pair` nodes. */
  class Pair extends @pair, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Pair" }

    /** Gets the location of this element. */
    override Location getLocation() { pair_def(this, _, _, result) }

    /** Gets the node corresponding to the field `key__`. */
    AstNode getKey() { pair_def(this, result, _, _) }

    /** Gets the node corresponding to the field `value`. */
    UnderscoreArg getValue() { pair_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      pair_def(this, result, _, _) or pair_def(this, _, result, _)
    }
  }

  /** A class representing `parenthesized_statements` nodes. */
  class ParenthesizedStatements extends @parenthesized_statements, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ParenthesizedStatements" }

    /** Gets the location of this element. */
    override Location getLocation() { parenthesized_statements_def(this, result) }

    AstNode getChild(int i) { parenthesized_statements_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
  }

  /** A class representing `pattern` nodes. */
  class Pattern extends @pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Pattern" }

    /** Gets the location of this element. */
    override Location getLocation() { pattern_def(this, _, result) }

    AstNode getChild() { pattern_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { pattern_def(this, result, _) }
  }

  /** A class representing `program` nodes. */
  class Program extends @program, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Program" }

    /** Gets the location of this element. */
    override Location getLocation() { program_def(this, result) }

    AstNode getChild(int i) { program_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { program_child(this, _, result) }
  }

  /** A class representing `range` nodes. */
  class Range extends @range, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Range" }

    /** Gets the location of this element. */
    override Location getLocation() { range_def(this, _, result) }

    /** Gets the node corresponding to the field `begin`. */
    UnderscoreArg getBegin() { range_begin(this, result) }

    /** Gets the node corresponding to the field `end`. */
    UnderscoreArg getEnd() { range_end(this, result) }

    /** Gets the node corresponding to the field `operator`. */
    string getOperator() {
      exists(int value | range_def(this, value, _) |
        result = ".." and value = 0
        or
        result = "..." and value = 1
      )
    }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { range_begin(this, result) or range_end(this, result) }
  }

  /** A class representing `rational` nodes. */
  class Rational extends @rational, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Rational" }

    /** Gets the location of this element. */
    override Location getLocation() { rational_def(this, _, result) }

    AstNode getChild() { rational_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { rational_def(this, result, _) }
  }

  /** A class representing `redo` nodes. */
  class Redo extends @redo, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Redo" }

    /** Gets the location of this element. */
    override Location getLocation() { redo_def(this, result) }

    ArgumentList getChild() { redo_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { redo_child(this, result) }
  }

  /** A class representing `regex` nodes. */
  class Regex extends @regex, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Regex" }

    /** Gets the location of this element. */
    override Location getLocation() { regex_def(this, result) }

    AstNode getChild(int i) { regex_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { regex_child(this, _, result) }
  }

  /** A class representing `rescue` nodes. */
  class Rescue extends @rescue, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Rescue" }

    /** Gets the location of this element. */
    override Location getLocation() { rescue_def(this, result) }

    /** Gets the node corresponding to the field `body`. */
    Then getBody() { rescue_body(this, result) }

    /** Gets the node corresponding to the field `exceptions`. */
    Exceptions getExceptions() { rescue_exceptions(this, result) }

    /** Gets the node corresponding to the field `variable`. */
    ExceptionVariable getVariable() { rescue_variable(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      rescue_body(this, result) or rescue_exceptions(this, result) or rescue_variable(this, result)
    }
  }

  /** A class representing `rescue_modifier` nodes. */
  class RescueModifier extends @rescue_modifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "RescueModifier" }

    /** Gets the location of this element. */
    override Location getLocation() { rescue_modifier_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    UnderscoreStatement getBody() { rescue_modifier_def(this, result, _, _) }

    /** Gets the node corresponding to the field `handler`. */
    AstNode getHandler() { rescue_modifier_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      rescue_modifier_def(this, result, _, _) or rescue_modifier_def(this, _, result, _)
    }
  }

  /** A class representing `rest_assignment` nodes. */
  class RestAssignment extends @rest_assignment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "RestAssignment" }

    /** Gets the location of this element. */
    override Location getLocation() { rest_assignment_def(this, result) }

    UnderscoreLhs getChild() { rest_assignment_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { rest_assignment_child(this, result) }
  }

  /** A class representing `retry` nodes. */
  class Retry extends @retry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Retry" }

    /** Gets the location of this element. */
    override Location getLocation() { retry_def(this, result) }

    ArgumentList getChild() { retry_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { retry_child(this, result) }
  }

  /** A class representing `return` nodes. */
  class Return extends @return, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Return" }

    /** Gets the location of this element. */
    override Location getLocation() { return_def(this, result) }

    ArgumentList getChild() { return_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { return_child(this, result) }
  }

  /** A class representing `right_assignment_list` nodes. */
  class RightAssignmentList extends @right_assignment_list, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "RightAssignmentList" }

    /** Gets the location of this element. */
    override Location getLocation() { right_assignment_list_def(this, result) }

    AstNode getChild(int i) { right_assignment_list_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { right_assignment_list_child(this, _, result) }
  }

  /** A class representing `scope_resolution` nodes. */
  class ScopeResolution extends @scope_resolution, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ScopeResolution" }

    /** Gets the location of this element. */
    override Location getLocation() { scope_resolution_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    AstNode getName() { scope_resolution_def(this, result, _) }

    /** Gets the node corresponding to the field `scope`. */
    UnderscorePrimary getScope() { scope_resolution_scope(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      scope_resolution_def(this, result, _) or scope_resolution_scope(this, result)
    }
  }

  /** A class representing `self` tokens. */
  class Self extends @token_self, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Self" }
  }

  /** A class representing `setter` nodes. */
  class Setter extends @setter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Setter" }

    /** Gets the location of this element. */
    override Location getLocation() { setter_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { setter_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { setter_def(this, result, _) }
  }

  /** A class representing `simple_symbol` tokens. */
  class SimpleSymbol extends @token_simple_symbol, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SimpleSymbol" }
  }

  /** A class representing `singleton_class` nodes. */
  class SingletonClass extends @singleton_class, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SingletonClass" }

    /** Gets the location of this element. */
    override Location getLocation() { singleton_class_def(this, _, result) }

    /** Gets the node corresponding to the field `value`. */
    UnderscoreArg getValue() { singleton_class_def(this, result, _) }

    AstNode getChild(int i) { singleton_class_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      singleton_class_def(this, result, _) or singleton_class_child(this, _, result)
    }
  }

  /** A class representing `singleton_method` nodes. */
  class SingletonMethod extends @singleton_method, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SingletonMethod" }

    /** Gets the location of this element. */
    override Location getLocation() { singleton_method_def(this, _, _, result) }

    /** Gets the node corresponding to the field `name`. */
    UnderscoreMethodName getName() { singleton_method_def(this, result, _, _) }

    /** Gets the node corresponding to the field `object`. */
    AstNode getObject() { singleton_method_def(this, _, result, _) }

    /** Gets the node corresponding to the field `parameters`. */
    MethodParameters getParameters() { singleton_method_parameters(this, result) }

    AstNode getChild(int i) { singleton_method_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      singleton_method_def(this, result, _, _) or
      singleton_method_def(this, _, result, _) or
      singleton_method_parameters(this, result) or
      singleton_method_child(this, _, result)
    }
  }

  /** A class representing `splat_argument` nodes. */
  class SplatArgument extends @splat_argument, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SplatArgument" }

    /** Gets the location of this element. */
    override Location getLocation() { splat_argument_def(this, _, result) }

    UnderscoreArg getChild() { splat_argument_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { splat_argument_def(this, result, _) }
  }

  /** A class representing `splat_parameter` nodes. */
  class SplatParameter extends @splat_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SplatParameter" }

    /** Gets the location of this element. */
    override Location getLocation() { splat_parameter_def(this, result) }

    /** Gets the node corresponding to the field `name`. */
    Identifier getName() { splat_parameter_name(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { splat_parameter_name(this, result) }
  }

  /** A class representing `string` nodes. */
  class String extends @string__, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "String" }

    /** Gets the location of this element. */
    override Location getLocation() { string_def(this, result) }

    AstNode getChild(int i) { string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { string_child(this, _, result) }
  }

  /** A class representing `string_array` nodes. */
  class StringArray extends @string_array, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "StringArray" }

    /** Gets the location of this element. */
    override Location getLocation() { string_array_def(this, result) }

    BareString getChild(int i) { string_array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { string_array_child(this, _, result) }
  }

  /** A class representing `string_content` tokens. */
  class StringContent extends @token_string_content, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "StringContent" }
  }

  /** A class representing `subshell` nodes. */
  class Subshell extends @subshell, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Subshell" }

    /** Gets the location of this element. */
    override Location getLocation() { subshell_def(this, result) }

    AstNode getChild(int i) { subshell_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { subshell_child(this, _, result) }
  }

  /** A class representing `super` tokens. */
  class Super extends @token_super, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `superclass` nodes. */
  class Superclass extends @superclass, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Superclass" }

    /** Gets the location of this element. */
    override Location getLocation() { superclass_def(this, _, result) }

    AstNode getChild() { superclass_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { superclass_def(this, result, _) }
  }

  /** A class representing `symbol_array` nodes. */
  class SymbolArray extends @symbol_array, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SymbolArray" }

    /** Gets the location of this element. */
    override Location getLocation() { symbol_array_def(this, result) }

    BareSymbol getChild(int i) { symbol_array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { symbol_array_child(this, _, result) }
  }

  /** A class representing `then` nodes. */
  class Then extends @then, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Then" }

    /** Gets the location of this element. */
    override Location getLocation() { then_def(this, result) }

    AstNode getChild(int i) { then_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { then_child(this, _, result) }
  }

  /** A class representing `true` tokens. */
  class True extends @token_true, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `unary` nodes. */
  class Unary extends @unary, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Unary" }

    /** Gets the location of this element. */
    override Location getLocation() { unary_def(this, _, _, result) }

    /** Gets the node corresponding to the field `operand`. */
    AstNode getOperand() { unary_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
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

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { unary_def(this, result, _, _) }
  }

  /** A class representing `undef` nodes. */
  class Undef extends @undef, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Undef" }

    /** Gets the location of this element. */
    override Location getLocation() { undef_def(this, result) }

    UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { undef_child(this, _, result) }
  }

  /** A class representing `uninterpreted` tokens. */
  class Uninterpreted extends @token_uninterpreted, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Uninterpreted" }
  }

  /** A class representing `unless` nodes. */
  class Unless extends @unless, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Unless" }

    /** Gets the location of this element. */
    override Location getLocation() { unless_def(this, _, result) }

    /** Gets the node corresponding to the field `alternative`. */
    AstNode getAlternative() { unless_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreStatement getCondition() { unless_def(this, result, _) }

    /** Gets the node corresponding to the field `consequence`. */
    Then getConsequence() { unless_consequence(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      unless_alternative(this, result) or
      unless_def(this, result, _) or
      unless_consequence(this, result)
    }
  }

  /** A class representing `unless_modifier` nodes. */
  class UnlessModifier extends @unless_modifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "UnlessModifier" }

    /** Gets the location of this element. */
    override Location getLocation() { unless_modifier_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    UnderscoreStatement getBody() { unless_modifier_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    AstNode getCondition() { unless_modifier_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      unless_modifier_def(this, result, _, _) or unless_modifier_def(this, _, result, _)
    }
  }

  /** A class representing `until` nodes. */
  class Until extends @until, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Until" }

    /** Gets the location of this element. */
    override Location getLocation() { until_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    Do getBody() { until_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreStatement getCondition() { until_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      until_def(this, result, _, _) or until_def(this, _, result, _)
    }
  }

  /** A class representing `until_modifier` nodes. */
  class UntilModifier extends @until_modifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "UntilModifier" }

    /** Gets the location of this element. */
    override Location getLocation() { until_modifier_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    UnderscoreStatement getBody() { until_modifier_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    AstNode getCondition() { until_modifier_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      until_modifier_def(this, result, _, _) or until_modifier_def(this, _, result, _)
    }
  }

  /** A class representing `when` nodes. */
  class When extends @when, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "When" }

    /** Gets the location of this element. */
    override Location getLocation() { when_def(this, result) }

    /** Gets the node corresponding to the field `body`. */
    Then getBody() { when_body(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    Pattern getPattern(int i) { when_pattern(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { when_body(this, result) or when_pattern(this, _, result) }
  }

  /** A class representing `while` nodes. */
  class While extends @while, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "While" }

    /** Gets the location of this element. */
    override Location getLocation() { while_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    Do getBody() { while_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    UnderscoreStatement getCondition() { while_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      while_def(this, result, _, _) or while_def(this, _, result, _)
    }
  }

  /** A class representing `while_modifier` nodes. */
  class WhileModifier extends @while_modifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "WhileModifier" }

    /** Gets the location of this element. */
    override Location getLocation() { while_modifier_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    UnderscoreStatement getBody() { while_modifier_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    AstNode getCondition() { while_modifier_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      while_modifier_def(this, result, _, _) or while_modifier_def(this, _, result, _)
    }
  }

  /** A class representing `yield` nodes. */
  class Yield extends @yield, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Yield" }

    /** Gets the location of this element. */
    override Location getLocation() { yield_def(this, result) }

    ArgumentList getChild() { yield_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { yield_child(this, result) }
  }
}
