/**
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

import codeql.Locations as L

/** Holds if the database is an overlay. */
overlay[local]
private predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/** Holds if `loc` is in the `file` and is part of the overlay base database. */
overlay[local]
private predicate discardableLocation(@file file, @location_default loc) {
  not isOverlay() and locations_default(loc, file, _, _, _, _)
}

/** Holds if `loc` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
overlay[discard_entity]
private predicate discardLocation(@location_default loc) {
  exists(@file file, string path | files(file, path) |
    discardableLocation(file, loc) and overlayChangedFiles(path)
  )
}

overlay[local]
module Ruby {
  private module F = Ruby;

  /** The base class for all AST nodes */
  class AstNode extends @ruby_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { ruby_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { ruby_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { ruby_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @ruby_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { ruby_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @ruby_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@ruby_ast_node node) {
    exists(@location_default loc | ruby_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @ruby_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@ruby_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  class UnderscoreArg extends @ruby_underscore_arg, F::UnderscoreExpression { }

  class UnderscoreCallOperator extends @ruby_underscore_call_operator, F::AstNode { }

  class UnderscoreExpression extends @ruby_underscore_expression, F::UnderscoreStatement { }

  class UnderscoreLhs extends @ruby_underscore_lhs, F::UnderscorePrimary { }

  class UnderscoreMethodName extends @ruby_underscore_method_name, F::AstNode { }

  class UnderscoreNonlocalVariable extends @ruby_underscore_nonlocal_variable,
    F::UnderscoreMethodName, F::UnderscoreVariable
  { }

  class UnderscorePatternConstant extends @ruby_underscore_pattern_constant,
    F::UnderscorePatternExprBasic
  { }

  class UnderscorePatternExpr extends @ruby_underscore_pattern_expr, F::UnderscorePatternTopExprBody
  { }

  class UnderscorePatternExprBasic extends @ruby_underscore_pattern_expr_basic,
    F::UnderscorePatternExpr
  { }

  class UnderscorePatternPrimitive extends @ruby_underscore_pattern_primitive,
    F::UnderscorePatternExprBasic
  { }

  class UnderscorePatternTopExprBody extends @ruby_underscore_pattern_top_expr_body, F::AstNode { }

  class UnderscorePrimary extends @ruby_underscore_primary, F::UnderscoreArg { }

  class UnderscoreSimpleNumeric extends @ruby_underscore_simple_numeric,
    F::UnderscorePatternPrimitive, F::UnderscorePrimary
  { }

  class UnderscoreStatement extends @ruby_underscore_statement, F::AstNode { }

  class UnderscoreVariable extends @ruby_underscore_variable, F::UnderscoreLhs { }

  /** A class representing `alias` nodes. */
  class Alias extends @ruby_alias, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Alias" }

    /** Gets the node corresponding to the field `alias`. */
    final F::UnderscoreMethodName getAlias() { ruby_alias_def(this, result, _) }

    /** Gets the node corresponding to the field `name`. */
    final F::UnderscoreMethodName getName() { ruby_alias_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_alias_def(this, result, _) or ruby_alias_def(this, _, result)
    }
  }

  /** A class representing `alternative_pattern` nodes. */
  class AlternativePattern extends @ruby_alternative_pattern, F::UnderscorePatternExpr {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AlternativePattern" }

    /** Gets the node corresponding to the field `alternatives`. */
    final F::UnderscorePatternExprBasic getAlternatives(int i) {
      ruby_alternative_pattern_alternatives(this, i, result)
    }

    /** Gets the node corresponding to the field `alternatives`. */
    final F::UnderscorePatternExprBasic getAnAlternatives() { result = this.getAlternatives(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_alternative_pattern_alternatives(this, _, result)
    }
  }

  /** A class representing `argument_list` nodes. */
  class ArgumentList extends @ruby_argument_list, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArgumentList" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_argument_list_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_argument_list_child(this, _, result) }
  }

  /** A class representing `array` nodes. */
  class Array extends @ruby_array, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Array" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_array_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_array_child(this, _, result) }
  }

  /** A class representing `array_pattern` nodes. */
  class ArrayPattern extends @ruby_array_pattern, F::UnderscorePatternExprBasic,
    F::UnderscorePatternTopExprBody
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArrayPattern" }

    /** Gets the node corresponding to the field `class`. */
    final F::UnderscorePatternConstant getClass() { ruby_array_pattern_class(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_array_pattern_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_array_pattern_class(this, result) or ruby_array_pattern_child(this, _, result)
    }
  }

  /** A class representing `as_pattern` nodes. */
  class AsPattern extends @ruby_as_pattern, F::UnderscorePatternExpr {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsPattern" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_as_pattern_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscorePatternExpr getValue() { ruby_as_pattern_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_as_pattern_def(this, result, _) or ruby_as_pattern_def(this, _, result)
    }
  }

  /** A class representing `assignment` nodes. */
  class Assignment extends @ruby_assignment, F::UnderscoreArg, F::UnderscoreExpression {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Assignment" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ruby_assignment_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ruby_assignment_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_assignment_def(this, result, _) or ruby_assignment_def(this, _, result)
    }
  }

  /** A class representing `bare_string` nodes. */
  class BareString extends @ruby_bare_string, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BareString" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_bare_string_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_bare_string_child(this, _, result) }
  }

  /** A class representing `bare_symbol` nodes. */
  class BareSymbol extends @ruby_bare_symbol, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BareSymbol" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_bare_symbol_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_bare_symbol_child(this, _, result) }
  }

  /** A class representing `begin` nodes. */
  class Begin extends @ruby_begin, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Begin" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_begin_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_begin_child(this, _, result) }
  }

  /** A class representing `begin_block` nodes. */
  class BeginBlock extends @ruby_begin_block, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BeginBlock" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_begin_block_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_begin_block_child(this, _, result) }
  }

  /** A class representing `binary` nodes. */
  class Binary extends @ruby_binary, F::UnderscoreArg, F::UnderscoreExpression {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Binary" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ruby_binary_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final string getOperator() {
      exists(int value | ruby_binary_def(this, _, value, _) |
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
    final F::UnderscoreExpression getRight() { ruby_binary_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_binary_def(this, result, _, _) or ruby_binary_def(this, _, _, result)
    }
  }

  /** A class representing `block` nodes. */
  class Block extends @ruby_block, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Block" }

    /** Gets the node corresponding to the field `body`. */
    final F::BlockBody getBody() { ruby_block_body(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    final F::BlockParameters getParameters() { ruby_block_parameters(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_block_body(this, result) or ruby_block_parameters(this, result)
    }
  }

  /** A class representing `block_argument` nodes. */
  class BlockArgument extends @ruby_block_argument, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockArgument" }

    /** Gets the child of this node. */
    final F::UnderscoreArg getChild() { ruby_block_argument_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_block_argument_child(this, result) }
  }

  /** A class representing `block_body` nodes. */
  class BlockBody extends @ruby_block_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockBody" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_block_body_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_block_body_child(this, _, result) }
  }

  /** A class representing `block_parameter` nodes. */
  class BlockParameter extends @ruby_block_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockParameter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_block_parameter_name(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_block_parameter_name(this, result) }
  }

  /** A class representing `block_parameters` nodes. */
  class BlockParameters extends @ruby_block_parameters, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockParameters" }

    /** Gets the node corresponding to the field `locals`. */
    final F::Identifier getLocals(int i) { ruby_block_parameters_locals(this, i, result) }

    /** Gets the node corresponding to the field `locals`. */
    final F::Identifier getALocals() { result = this.getLocals(_) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_block_parameters_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_block_parameters_locals(this, _, result) or ruby_block_parameters_child(this, _, result)
    }
  }

  /** A class representing `body_statement` nodes. */
  class BodyStatement extends @ruby_body_statement, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BodyStatement" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_body_statement_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_body_statement_child(this, _, result) }
  }

  /** A class representing `break` nodes. */
  class Break extends @ruby_break, F::UnderscoreExpression, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Break" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_break_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_break_child(this, result) }
  }

  /** A class representing `call` nodes. */
  class Call extends @ruby_call, F::UnderscoreExpression, F::UnderscoreLhs, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Call" }

    /** Gets the node corresponding to the field `arguments`. */
    final F::ArgumentList getArguments() { ruby_call_arguments(this, result) }

    /** Gets the node corresponding to the field `block`. */
    final F::AstNode getBlock() { ruby_call_block(this, result) }

    /** Gets the node corresponding to the field `method`. */
    final F::AstNode getMethod() { ruby_call_method(this, result) }

    /** Gets the node corresponding to the field `operator`. */
    final F::UnderscoreCallOperator getOperator() { ruby_call_operator(this, result) }

    /** Gets the node corresponding to the field `receiver`. */
    final F::UnderscorePrimary getReceiver() { ruby_call_receiver(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_call_arguments(this, result) or
      ruby_call_block(this, result) or
      ruby_call_method(this, result) or
      ruby_call_operator(this, result) or
      ruby_call_receiver(this, result)
    }
  }

  /** A class representing `case` nodes. */
  class Case extends @ruby_case__, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Case" }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreStatement getValue() { ruby_case_value(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_case_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_case_value(this, result) or ruby_case_child(this, _, result)
    }
  }

  /** A class representing `case_match` nodes. */
  class CaseMatch extends @ruby_case_match, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaseMatch" }

    /** Gets the node corresponding to the field `clauses`. */
    final F::InClause getClauses(int i) { ruby_case_match_clauses(this, i, result) }

    /** Gets the node corresponding to the field `clauses`. */
    final F::InClause getAClauses() { result = this.getClauses(_) }

    /** Gets the node corresponding to the field `else`. */
    final F::Else getElse() { ruby_case_match_else(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreStatement getValue() { ruby_case_match_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_case_match_clauses(this, _, result) or
      ruby_case_match_else(this, result) or
      ruby_case_match_def(this, result)
    }
  }

  /** A class representing `chained_string` nodes. */
  class ChainedString extends @ruby_chained_string, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ChainedString" }

    /** Gets the `i`th child of this node. */
    final F::String getChild(int i) { ruby_chained_string_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::String getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_chained_string_child(this, _, result) }
  }

  /** A class representing `character` tokens. */
  class Character extends @ruby_token_character, F::Token, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Character" }
  }

  /** A class representing `class` nodes. */
  class Class extends @ruby_class, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Class" }

    /** Gets the node corresponding to the field `body`. */
    final F::BodyStatement getBody() { ruby_class_body(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::AstNode getName() { ruby_class_def(this, result) }

    /** Gets the node corresponding to the field `superclass`. */
    final F::Superclass getSuperclass() { ruby_class_superclass(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_class_body(this, result) or
      ruby_class_def(this, result) or
      ruby_class_superclass(this, result)
    }
  }

  /** A class representing `class_variable` tokens. */
  class ClassVariable extends @ruby_token_class_variable, F::Token, F::UnderscoreNonlocalVariable {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassVariable" }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @ruby_token_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `complex` nodes. */
  class Complex extends @ruby_complex, F::UnderscoreSimpleNumeric {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Complex" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ruby_complex_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_complex_def(this, result) }
  }

  /** A class representing `conditional` nodes. */
  class Conditional extends @ruby_conditional, F::UnderscoreArg {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Conditional" }

    /** Gets the node corresponding to the field `alternative`. */
    final F::UnderscoreArg getAlternative() { ruby_conditional_def(this, result, _, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreArg getCondition() { ruby_conditional_def(this, _, result, _) }

    /** Gets the node corresponding to the field `consequence`. */
    final F::UnderscoreArg getConsequence() { ruby_conditional_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_conditional_def(this, result, _, _) or
      ruby_conditional_def(this, _, result, _) or
      ruby_conditional_def(this, _, _, result)
    }
  }

  /** A class representing `constant` tokens. */
  class Constant extends @ruby_token_constant, F::Token, F::UnderscoreMethodName,
    F::UnderscorePatternConstant, F::UnderscoreVariable
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Constant" }
  }

  /** A class representing `delimited_symbol` nodes. */
  class DelimitedSymbol extends @ruby_delimited_symbol, F::UnderscoreMethodName,
    F::UnderscorePatternPrimitive, F::UnderscorePrimary
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DelimitedSymbol" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_delimited_symbol_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_delimited_symbol_child(this, _, result) }
  }

  /** A class representing `destructured_left_assignment` nodes. */
  class DestructuredLeftAssignment extends @ruby_destructured_left_assignment, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DestructuredLeftAssignment" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_destructured_left_assignment_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_destructured_left_assignment_child(this, _, result)
    }
  }

  /** A class representing `destructured_parameter` nodes. */
  class DestructuredParameter extends @ruby_destructured_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DestructuredParameter" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_destructured_parameter_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_destructured_parameter_child(this, _, result)
    }
  }

  /** A class representing `do` nodes. */
  class Do extends @ruby_do, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Do" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_do_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_do_child(this, _, result) }
  }

  /** A class representing `do_block` nodes. */
  class DoBlock extends @ruby_do_block, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DoBlock" }

    /** Gets the node corresponding to the field `body`. */
    final F::BodyStatement getBody() { ruby_do_block_body(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    final F::BlockParameters getParameters() { ruby_do_block_parameters(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_do_block_body(this, result) or ruby_do_block_parameters(this, result)
    }
  }

  /** A class representing `element_reference` nodes. */
  class ElementReference extends @ruby_element_reference, F::UnderscoreLhs {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ElementReference" }

    /** Gets the node corresponding to the field `block`. */
    final F::AstNode getBlock() { ruby_element_reference_block(this, result) }

    /** Gets the node corresponding to the field `object`. */
    final F::UnderscorePrimary getObject() { ruby_element_reference_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_element_reference_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_element_reference_block(this, result) or
      ruby_element_reference_def(this, result) or
      ruby_element_reference_child(this, _, result)
    }
  }

  /** A class representing `else` nodes. */
  class Else extends @ruby_else, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Else" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_else_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_else_child(this, _, result) }
  }

  /** A class representing `elsif` nodes. */
  class Elsif extends @ruby_elsif, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Elsif" }

    /** Gets the node corresponding to the field `alternative`. */
    final F::AstNode getAlternative() { ruby_elsif_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreStatement getCondition() { ruby_elsif_def(this, result) }

    /** Gets the node corresponding to the field `consequence`. */
    final F::Then getConsequence() { ruby_elsif_consequence(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_elsif_alternative(this, result) or
      ruby_elsif_def(this, result) or
      ruby_elsif_consequence(this, result)
    }
  }

  /** A class representing `empty_statement` tokens. */
  class EmptyStatement extends @ruby_token_empty_statement, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EmptyStatement" }
  }

  /** A class representing `encoding` tokens. */
  class Encoding extends @ruby_token_encoding, F::Token, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Encoding" }
  }

  /** A class representing `end_block` nodes. */
  class EndBlock extends @ruby_end_block, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EndBlock" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_end_block_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_end_block_child(this, _, result) }
  }

  /** A class representing `ensure` nodes. */
  class Ensure extends @ruby_ensure, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ensure" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_ensure_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_ensure_child(this, _, result) }
  }

  /** A class representing `escape_sequence` tokens. */
  class EscapeSequence extends @ruby_token_escape_sequence, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  /** A class representing `exception_variable` nodes. */
  class ExceptionVariable extends @ruby_exception_variable, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExceptionVariable" }

    /** Gets the child of this node. */
    final F::UnderscoreLhs getChild() { ruby_exception_variable_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_exception_variable_def(this, result) }
  }

  /** A class representing `exceptions` nodes. */
  class Exceptions extends @ruby_exceptions, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Exceptions" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_exceptions_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_exceptions_child(this, _, result) }
  }

  /** A class representing `expression_reference_pattern` nodes. */
  class ExpressionReferencePattern extends @ruby_expression_reference_pattern,
    F::UnderscorePatternExprBasic
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExpressionReferencePattern" }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreExpression getValue() { ruby_expression_reference_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_expression_reference_pattern_def(this, result)
    }
  }

  /** A class representing `false` tokens. */
  class False extends @ruby_token_false, F::Token, F::UnderscoreLhs, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `file` tokens. */
  class File extends @ruby_token_file, F::Token, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "File" }
  }

  /** A class representing `find_pattern` nodes. */
  class FindPattern extends @ruby_find_pattern, F::UnderscorePatternExprBasic,
    F::UnderscorePatternTopExprBody
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FindPattern" }

    /** Gets the node corresponding to the field `class`. */
    final F::UnderscorePatternConstant getClass() { ruby_find_pattern_class(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_find_pattern_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_find_pattern_class(this, result) or ruby_find_pattern_child(this, _, result)
    }
  }

  /** A class representing `float` tokens. */
  class Float extends @ruby_token_float, F::Token, F::UnderscoreSimpleNumeric {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `for` nodes. */
  class For extends @ruby_for, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "For" }

    /** Gets the node corresponding to the field `body`. */
    final F::Do getBody() { ruby_for_def(this, result, _, _) }

    /** Gets the node corresponding to the field `pattern`. */
    final F::AstNode getPattern() { ruby_for_def(this, _, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::In getValue() { ruby_for_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_for_def(this, result, _, _) or
      ruby_for_def(this, _, result, _) or
      ruby_for_def(this, _, _, result)
    }
  }

  /** A class representing `forward_argument` tokens. */
  class ForwardArgument extends @ruby_token_forward_argument, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ForwardArgument" }
  }

  /** A class representing `forward_parameter` tokens. */
  class ForwardParameter extends @ruby_token_forward_parameter, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ForwardParameter" }
  }

  /** A class representing `global_variable` tokens. */
  class GlobalVariable extends @ruby_token_global_variable, F::Token, F::UnderscoreNonlocalVariable {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GlobalVariable" }
  }

  /** A class representing `hash` nodes. */
  class Hash extends @ruby_hash, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Hash" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_hash_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_hash_child(this, _, result) }
  }

  /** A class representing `hash_key_symbol` tokens. */
  class HashKeySymbol extends @ruby_token_hash_key_symbol, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HashKeySymbol" }
  }

  /** A class representing `hash_pattern` nodes. */
  class HashPattern extends @ruby_hash_pattern, F::UnderscorePatternExprBasic,
    F::UnderscorePatternTopExprBody
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HashPattern" }

    /** Gets the node corresponding to the field `class`. */
    final F::UnderscorePatternConstant getClass() { ruby_hash_pattern_class(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_hash_pattern_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_hash_pattern_class(this, result) or ruby_hash_pattern_child(this, _, result)
    }
  }

  /** A class representing `hash_splat_argument` nodes. */
  class HashSplatArgument extends @ruby_hash_splat_argument, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HashSplatArgument" }

    /** Gets the child of this node. */
    final F::UnderscoreArg getChild() { ruby_hash_splat_argument_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_hash_splat_argument_child(this, result) }
  }

  /** A class representing `hash_splat_nil` tokens. */
  class HashSplatNil extends @ruby_token_hash_splat_nil, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HashSplatNil" }
  }

  /** A class representing `hash_splat_parameter` nodes. */
  class HashSplatParameter extends @ruby_hash_splat_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HashSplatParameter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_hash_splat_parameter_name(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_hash_splat_parameter_name(this, result) }
  }

  /** A class representing `heredoc_beginning` tokens. */
  class HeredocBeginning extends @ruby_token_heredoc_beginning, F::Token,
    F::UnderscorePatternPrimitive, F::UnderscorePrimary
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HeredocBeginning" }
  }

  /** A class representing `heredoc_body` nodes. */
  class HeredocBody extends @ruby_heredoc_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HeredocBody" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_heredoc_body_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_heredoc_body_child(this, _, result) }
  }

  /** A class representing `heredoc_content` tokens. */
  class HeredocContent extends @ruby_token_heredoc_content, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HeredocContent" }
  }

  /** A class representing `heredoc_end` tokens. */
  class HeredocEnd extends @ruby_token_heredoc_end, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HeredocEnd" }
  }

  /** A class representing `identifier` tokens. */
  class Identifier extends @ruby_token_identifier, F::Token, F::UnderscoreMethodName,
    F::UnderscorePatternExprBasic, F::UnderscoreVariable
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Identifier" }
  }

  /** A class representing `if` nodes. */
  class If extends @ruby_if, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "If" }

    /** Gets the node corresponding to the field `alternative`. */
    final F::AstNode getAlternative() { ruby_if_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreStatement getCondition() { ruby_if_def(this, result) }

    /** Gets the node corresponding to the field `consequence`. */
    final F::Then getConsequence() { ruby_if_consequence(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_if_alternative(this, result) or
      ruby_if_def(this, result) or
      ruby_if_consequence(this, result)
    }
  }

  /** A class representing `if_guard` nodes. */
  class IfGuard extends @ruby_if_guard, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfGuard" }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_if_guard_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_if_guard_def(this, result) }
  }

  /** A class representing `if_modifier` nodes. */
  class IfModifier extends @ruby_if_modifier, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfModifier" }

    /** Gets the node corresponding to the field `body`. */
    final F::UnderscoreStatement getBody() { ruby_if_modifier_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_if_modifier_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_if_modifier_def(this, result, _) or ruby_if_modifier_def(this, _, result)
    }
  }

  /** A class representing `in` nodes. */
  class In extends @ruby_in, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "In" }

    /** Gets the child of this node. */
    final F::UnderscoreArg getChild() { ruby_in_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_in_def(this, result) }
  }

  /** A class representing `in_clause` nodes. */
  class InClause extends @ruby_in_clause, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InClause" }

    /** Gets the node corresponding to the field `body`. */
    final F::Then getBody() { ruby_in_clause_body(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final F::AstNode getGuard() { ruby_in_clause_guard(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final F::UnderscorePatternTopExprBody getPattern() { ruby_in_clause_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_in_clause_body(this, result) or
      ruby_in_clause_guard(this, result) or
      ruby_in_clause_def(this, result)
    }
  }

  /** A class representing `instance_variable` tokens. */
  class InstanceVariable extends @ruby_token_instance_variable, F::Token,
    F::UnderscoreNonlocalVariable
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InstanceVariable" }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @ruby_token_integer, F::Token, F::UnderscoreSimpleNumeric {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `interpolation` nodes. */
  class Interpolation extends @ruby_interpolation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Interpolation" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_interpolation_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_interpolation_child(this, _, result) }
  }

  /** A class representing `keyword_parameter` nodes. */
  class KeywordParameter extends @ruby_keyword_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeywordParameter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_keyword_parameter_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_keyword_parameter_value(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_keyword_parameter_def(this, result) or ruby_keyword_parameter_value(this, result)
    }
  }

  /** A class representing `keyword_pattern` nodes. */
  class KeywordPattern extends @ruby_keyword_pattern, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeywordPattern" }

    /** Gets the node corresponding to the field `key`. */
    final F::AstNode getKey() { ruby_keyword_pattern_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscorePatternExpr getValue() { ruby_keyword_pattern_value(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_keyword_pattern_def(this, result) or ruby_keyword_pattern_value(this, result)
    }
  }

  /** A class representing `lambda` nodes. */
  class Lambda extends @ruby_lambda, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Lambda" }

    /** Gets the node corresponding to the field `body`. */
    final F::AstNode getBody() { ruby_lambda_def(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    final F::LambdaParameters getParameters() { ruby_lambda_parameters(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_lambda_def(this, result) or ruby_lambda_parameters(this, result)
    }
  }

  /** A class representing `lambda_parameters` nodes. */
  class LambdaParameters extends @ruby_lambda_parameters, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaParameters" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_lambda_parameters_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_lambda_parameters_child(this, _, result) }
  }

  /** A class representing `left_assignment_list` nodes. */
  class LeftAssignmentList extends @ruby_left_assignment_list, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LeftAssignmentList" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_left_assignment_list_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_left_assignment_list_child(this, _, result)
    }
  }

  /** A class representing `line` tokens. */
  class Line extends @ruby_token_line, F::Token, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Line" }
  }

  /** A class representing `match_pattern` nodes. */
  class MatchPattern extends @ruby_match_pattern, F::UnderscoreExpression {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MatchPattern" }

    /** Gets the node corresponding to the field `pattern`. */
    final F::UnderscorePatternTopExprBody getPattern() { ruby_match_pattern_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_match_pattern_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_match_pattern_def(this, result, _) or ruby_match_pattern_def(this, _, result)
    }
  }

  /** A class representing `method` nodes. */
  class Method extends @ruby_method, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Method" }

    /** Gets the node corresponding to the field `body`. */
    final F::AstNode getBody() { ruby_method_body(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::UnderscoreMethodName getName() { ruby_method_def(this, result) }

    /** Gets the node corresponding to the field `parameters`. */
    final F::MethodParameters getParameters() { ruby_method_parameters(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_method_body(this, result) or
      ruby_method_def(this, result) or
      ruby_method_parameters(this, result)
    }
  }

  /** A class representing `method_parameters` nodes. */
  class MethodParameters extends @ruby_method_parameters, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MethodParameters" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_method_parameters_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_method_parameters_child(this, _, result) }
  }

  /** A class representing `module` nodes. */
  class Module extends @ruby_module, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Module" }

    /** Gets the node corresponding to the field `body`. */
    final F::BodyStatement getBody() { ruby_module_body(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::AstNode getName() { ruby_module_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_module_body(this, result) or ruby_module_def(this, result)
    }
  }

  /** A class representing `next` nodes. */
  class Next extends @ruby_next, F::UnderscoreExpression, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Next" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_next_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_next_child(this, result) }
  }

  /** A class representing `nil` tokens. */
  class Nil extends @ruby_token_nil, F::Token, F::UnderscoreLhs, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Nil" }
  }

  /** A class representing `operator` tokens. */
  class Operator extends @ruby_token_operator, F::Token, F::UnderscoreMethodName {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Operator" }
  }

  /** A class representing `operator_assignment` nodes. */
  class OperatorAssignment extends @ruby_operator_assignment, F::UnderscoreArg,
    F::UnderscoreExpression
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OperatorAssignment" }

    /** Gets the node corresponding to the field `left`. */
    final F::UnderscoreLhs getLeft() { ruby_operator_assignment_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final string getOperator() {
      exists(int value | ruby_operator_assignment_def(this, _, value, _) |
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
    final F::AstNode getRight() { ruby_operator_assignment_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_operator_assignment_def(this, result, _, _) or
      ruby_operator_assignment_def(this, _, _, result)
    }
  }

  /** A class representing `optional_parameter` nodes. */
  class OptionalParameter extends @ruby_optional_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OptionalParameter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_optional_parameter_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_optional_parameter_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_optional_parameter_def(this, result, _) or ruby_optional_parameter_def(this, _, result)
    }
  }

  /** A class representing `pair` nodes. */
  class Pair extends @ruby_pair, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pair" }

    /** Gets the node corresponding to the field `key`. */
    final F::AstNode getKey() { ruby_pair_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_pair_value(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_pair_def(this, result) or ruby_pair_value(this, result)
    }
  }

  /** A class representing `parenthesized_pattern` nodes. */
  class ParenthesizedPattern extends @ruby_parenthesized_pattern, F::UnderscorePatternExprBasic {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParenthesizedPattern" }

    /** Gets the child of this node. */
    final F::UnderscorePatternExpr getChild() { ruby_parenthesized_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_parenthesized_pattern_def(this, result) }
  }

  /** A class representing `parenthesized_statements` nodes. */
  class ParenthesizedStatements extends @ruby_parenthesized_statements, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParenthesizedStatements" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_parenthesized_statements_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_parenthesized_statements_child(this, _, result)
    }
  }

  /** A class representing `pattern` nodes. */
  class Pattern extends @ruby_pattern, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pattern" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ruby_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_pattern_def(this, result) }
  }

  /** A class representing `program` nodes. */
  class Program extends @ruby_program, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Program" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_program_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_program_child(this, _, result) }
  }

  /** A class representing `range` nodes. */
  class Range extends @ruby_range, F::UnderscoreArg, F::UnderscorePatternExprBasic {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Range" }

    /** Gets the node corresponding to the field `begin`. */
    final F::AstNode getBegin() { ruby_range_begin(this, result) }

    /** Gets the node corresponding to the field `end`. */
    final F::AstNode getEnd() { ruby_range_end(this, result) }

    /** Gets the node corresponding to the field `operator`. */
    final string getOperator() {
      exists(int value | ruby_range_def(this, value) |
        result = ".." and value = 0
        or
        result = "..." and value = 1
      )
    }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_range_begin(this, result) or ruby_range_end(this, result)
    }
  }

  /** A class representing `rational` nodes. */
  class Rational extends @ruby_rational, F::UnderscoreSimpleNumeric {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Rational" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ruby_rational_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_rational_def(this, result) }
  }

  /** A class representing `redo` nodes. */
  class Redo extends @ruby_redo, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Redo" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_redo_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_redo_child(this, result) }
  }

  /** A class representing `regex` nodes. */
  class Regex extends @ruby_regex, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Regex" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_regex_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_regex_child(this, _, result) }
  }

  /** A class representing `rescue` nodes. */
  class Rescue extends @ruby_rescue, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Rescue" }

    /** Gets the node corresponding to the field `body`. */
    final F::Then getBody() { ruby_rescue_body(this, result) }

    /** Gets the node corresponding to the field `exceptions`. */
    final F::Exceptions getExceptions() { ruby_rescue_exceptions(this, result) }

    /** Gets the node corresponding to the field `variable`. */
    final F::ExceptionVariable getVariable() { ruby_rescue_variable(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_rescue_body(this, result) or
      ruby_rescue_exceptions(this, result) or
      ruby_rescue_variable(this, result)
    }
  }

  /** A class representing `rescue_modifier` nodes. */
  class RescueModifier extends @ruby_rescue_modifier, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RescueModifier" }

    /** Gets the node corresponding to the field `body`. */
    final F::AstNode getBody() { ruby_rescue_modifier_def(this, result, _) }

    /** Gets the node corresponding to the field `handler`. */
    final F::UnderscoreExpression getHandler() { ruby_rescue_modifier_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_rescue_modifier_def(this, result, _) or ruby_rescue_modifier_def(this, _, result)
    }
  }

  /** A class representing `rest_assignment` nodes. */
  class RestAssignment extends @ruby_rest_assignment, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RestAssignment" }

    /** Gets the child of this node. */
    final F::UnderscoreLhs getChild() { ruby_rest_assignment_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_rest_assignment_child(this, result) }
  }

  /** A class representing `retry` nodes. */
  class Retry extends @ruby_retry, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Retry" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_retry_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_retry_child(this, result) }
  }

  /** A class representing `return` nodes. */
  class Return extends @ruby_return, F::UnderscoreExpression, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Return" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_return_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_return_child(this, result) }
  }

  /** A class representing `right_assignment_list` nodes. */
  class RightAssignmentList extends @ruby_right_assignment_list, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RightAssignmentList" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_right_assignment_list_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_right_assignment_list_child(this, _, result)
    }
  }

  /** A class representing `scope_resolution` nodes. */
  class ScopeResolution extends @ruby_scope_resolution, F::UnderscoreLhs,
    F::UnderscorePatternConstant
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ScopeResolution" }

    /** Gets the node corresponding to the field `name`. */
    final F::Constant getName() { ruby_scope_resolution_def(this, result) }

    /** Gets the node corresponding to the field `scope`. */
    final F::AstNode getScope() { ruby_scope_resolution_scope(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_scope_resolution_def(this, result) or ruby_scope_resolution_scope(this, result)
    }
  }

  /** A class representing `self` tokens. */
  class Self extends @ruby_token_self, F::Token, F::UnderscorePatternPrimitive,
    F::UnderscoreVariable
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Self" }
  }

  /** A class representing `setter` nodes. */
  class Setter extends @ruby_setter, F::UnderscoreMethodName {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Setter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_setter_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_setter_def(this, result) }
  }

  /** A class representing `simple_symbol` tokens. */
  class SimpleSymbol extends @ruby_token_simple_symbol, F::Token, F::UnderscoreMethodName,
    F::UnderscorePatternPrimitive, F::UnderscorePrimary
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleSymbol" }
  }

  /** A class representing `singleton_class` nodes. */
  class SingletonClass extends @ruby_singleton_class, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SingletonClass" }

    /** Gets the node corresponding to the field `body`. */
    final F::BodyStatement getBody() { ruby_singleton_class_body(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_singleton_class_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_singleton_class_body(this, result) or ruby_singleton_class_def(this, result)
    }
  }

  /** A class representing `singleton_method` nodes. */
  class SingletonMethod extends @ruby_singleton_method, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SingletonMethod" }

    /** Gets the node corresponding to the field `body`. */
    final F::AstNode getBody() { ruby_singleton_method_body(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::UnderscoreMethodName getName() { ruby_singleton_method_def(this, result, _) }

    /** Gets the node corresponding to the field `object`. */
    final F::AstNode getObject() { ruby_singleton_method_def(this, _, result) }

    /** Gets the node corresponding to the field `parameters`. */
    final F::MethodParameters getParameters() { ruby_singleton_method_parameters(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_singleton_method_body(this, result) or
      ruby_singleton_method_def(this, result, _) or
      ruby_singleton_method_def(this, _, result) or
      ruby_singleton_method_parameters(this, result)
    }
  }

  /** A class representing `splat_argument` nodes. */
  class SplatArgument extends @ruby_splat_argument, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SplatArgument" }

    /** Gets the child of this node. */
    final F::UnderscoreArg getChild() { ruby_splat_argument_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_splat_argument_child(this, result) }
  }

  /** A class representing `splat_parameter` nodes. */
  class SplatParameter extends @ruby_splat_parameter, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SplatParameter" }

    /** Gets the node corresponding to the field `name`. */
    final F::Identifier getName() { ruby_splat_parameter_name(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_splat_parameter_name(this, result) }
  }

  /** A class representing `string` nodes. */
  class String extends @ruby_string__, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_string_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_string_child(this, _, result) }
  }

  /** A class representing `string_array` nodes. */
  class StringArray extends @ruby_string_array, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringArray" }

    /** Gets the `i`th child of this node. */
    final F::BareString getChild(int i) { ruby_string_array_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::BareString getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_string_array_child(this, _, result) }
  }

  /** A class representing `string_content` tokens. */
  class StringContent extends @ruby_token_string_content, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringContent" }
  }

  /** A class representing `subshell` nodes. */
  class Subshell extends @ruby_subshell, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Subshell" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_subshell_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_subshell_child(this, _, result) }
  }

  /** A class representing `super` tokens. */
  class Super extends @ruby_token_super, F::Token, F::UnderscoreVariable {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `superclass` nodes. */
  class Superclass extends @ruby_superclass, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Superclass" }

    /** Gets the child of this node. */
    final F::UnderscoreExpression getChild() { ruby_superclass_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_superclass_def(this, result) }
  }

  /** A class representing `symbol_array` nodes. */
  class SymbolArray extends @ruby_symbol_array, F::UnderscorePatternPrimitive, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SymbolArray" }

    /** Gets the `i`th child of this node. */
    final F::BareSymbol getChild(int i) { ruby_symbol_array_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::BareSymbol getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_symbol_array_child(this, _, result) }
  }

  /** A class representing `test_pattern` nodes. */
  class TestPattern extends @ruby_test_pattern, F::UnderscoreExpression {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TestPattern" }

    /** Gets the node corresponding to the field `pattern`. */
    final F::UnderscorePatternTopExprBody getPattern() { ruby_test_pattern_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreArg getValue() { ruby_test_pattern_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_test_pattern_def(this, result, _) or ruby_test_pattern_def(this, _, result)
    }
  }

  /** A class representing `then` nodes. */
  class Then extends @ruby_then, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Then" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ruby_then_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_then_child(this, _, result) }
  }

  /** A class representing `true` tokens. */
  class True extends @ruby_token_true, F::Token, F::UnderscoreLhs, F::UnderscorePatternPrimitive {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `unary` nodes. */
  class Unary extends @ruby_unary, F::UnderscoreArg, F::UnderscoreExpression,
    F::UnderscorePatternPrimitive, F::UnderscorePrimary
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unary" }

    /** Gets the node corresponding to the field `operand`. */
    final F::AstNode getOperand() { ruby_unary_def(this, result, _) }

    /** Gets the node corresponding to the field `operator`. */
    final string getOperator() {
      exists(int value | ruby_unary_def(this, _, value) |
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
    final override F::AstNode getAFieldOrChild() { ruby_unary_def(this, result, _) }
  }

  /** A class representing `undef` nodes. */
  class Undef extends @ruby_undef, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Undef" }

    /** Gets the `i`th child of this node. */
    final F::UnderscoreMethodName getChild(int i) { ruby_undef_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::UnderscoreMethodName getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_undef_child(this, _, result) }
  }

  /** A class representing `uninterpreted` tokens. */
  class Uninterpreted extends @ruby_token_uninterpreted, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Uninterpreted" }
  }

  /** A class representing `unless` nodes. */
  class Unless extends @ruby_unless, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unless" }

    /** Gets the node corresponding to the field `alternative`. */
    final F::AstNode getAlternative() { ruby_unless_alternative(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreStatement getCondition() { ruby_unless_def(this, result) }

    /** Gets the node corresponding to the field `consequence`. */
    final F::Then getConsequence() { ruby_unless_consequence(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_unless_alternative(this, result) or
      ruby_unless_def(this, result) or
      ruby_unless_consequence(this, result)
    }
  }

  /** A class representing `unless_guard` nodes. */
  class UnlessGuard extends @ruby_unless_guard, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnlessGuard" }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_unless_guard_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_unless_guard_def(this, result) }
  }

  /** A class representing `unless_modifier` nodes. */
  class UnlessModifier extends @ruby_unless_modifier, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnlessModifier" }

    /** Gets the node corresponding to the field `body`. */
    final F::UnderscoreStatement getBody() { ruby_unless_modifier_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_unless_modifier_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_unless_modifier_def(this, result, _) or ruby_unless_modifier_def(this, _, result)
    }
  }

  /** A class representing `until` nodes. */
  class Until extends @ruby_until, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Until" }

    /** Gets the node corresponding to the field `body`. */
    final F::Do getBody() { ruby_until_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreStatement getCondition() { ruby_until_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_until_def(this, result, _) or ruby_until_def(this, _, result)
    }
  }

  /** A class representing `until_modifier` nodes. */
  class UntilModifier extends @ruby_until_modifier, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UntilModifier" }

    /** Gets the node corresponding to the field `body`. */
    final F::UnderscoreStatement getBody() { ruby_until_modifier_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_until_modifier_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_until_modifier_def(this, result, _) or ruby_until_modifier_def(this, _, result)
    }
  }

  /** A class representing `variable_reference_pattern` nodes. */
  class VariableReferencePattern extends @ruby_variable_reference_pattern,
    F::UnderscorePatternExprBasic
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VariableReferencePattern" }

    /** Gets the node corresponding to the field `name`. */
    final F::AstNode getName() { ruby_variable_reference_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_variable_reference_pattern_def(this, result)
    }
  }

  /** A class representing `when` nodes. */
  class When extends @ruby_when, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "When" }

    /** Gets the node corresponding to the field `body`. */
    final F::Then getBody() { ruby_when_body(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final F::Pattern getPattern(int i) { ruby_when_pattern(this, i, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final F::Pattern getAPattern() { result = this.getPattern(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_when_body(this, result) or ruby_when_pattern(this, _, result)
    }
  }

  /** A class representing `while` nodes. */
  class While extends @ruby_while, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "While" }

    /** Gets the node corresponding to the field `body`. */
    final F::Do getBody() { ruby_while_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreStatement getCondition() { ruby_while_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_while_def(this, result, _) or ruby_while_def(this, _, result)
    }
  }

  /** A class representing `while_modifier` nodes. */
  class WhileModifier extends @ruby_while_modifier, F::UnderscoreStatement {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WhileModifier" }

    /** Gets the node corresponding to the field `body`. */
    final F::UnderscoreStatement getBody() { ruby_while_modifier_def(this, result, _) }

    /** Gets the node corresponding to the field `condition`. */
    final F::UnderscoreExpression getCondition() { ruby_while_modifier_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ruby_while_modifier_def(this, result, _) or ruby_while_modifier_def(this, _, result)
    }
  }

  /** A class representing `yield` nodes. */
  class Yield extends @ruby_yield, F::UnderscoreExpression, F::UnderscorePrimary {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Yield" }

    /** Gets the child of this node. */
    final F::ArgumentList getChild() { ruby_yield_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ruby_yield_child(this, result) }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(Alias).getAlias() and i = -1 and name = "getAlias"
      or
      result = node.(Alias).getName() and i = -1 and name = "getName"
      or
      result = node.(AlternativePattern).getAlternatives(i) and name = "getAlternatives"
      or
      result = node.(ArgumentList).getChild(i) and name = "getChild"
      or
      result = node.(Array).getChild(i) and name = "getChild"
      or
      result = node.(ArrayPattern).getClass() and i = -1 and name = "getClass"
      or
      result = node.(ArrayPattern).getChild(i) and name = "getChild"
      or
      result = node.(AsPattern).getName() and i = -1 and name = "getName"
      or
      result = node.(AsPattern).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Assignment).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(Assignment).getRight() and i = -1 and name = "getRight"
      or
      result = node.(BareString).getChild(i) and name = "getChild"
      or
      result = node.(BareSymbol).getChild(i) and name = "getChild"
      or
      result = node.(Begin).getChild(i) and name = "getChild"
      or
      result = node.(BeginBlock).getChild(i) and name = "getChild"
      or
      result = node.(Binary).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(Binary).getRight() and i = -1 and name = "getRight"
      or
      result = node.(Block).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Block).getParameters() and i = -1 and name = "getParameters"
      or
      result = node.(BlockArgument).getChild() and i = -1 and name = "getChild"
      or
      result = node.(BlockBody).getChild(i) and name = "getChild"
      or
      result = node.(BlockParameter).getName() and i = -1 and name = "getName"
      or
      result = node.(BlockParameters).getLocals(i) and name = "getLocals"
      or
      result = node.(BlockParameters).getChild(i) and name = "getChild"
      or
      result = node.(BodyStatement).getChild(i) and name = "getChild"
      or
      result = node.(Break).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Call).getArguments() and i = -1 and name = "getArguments"
      or
      result = node.(Call).getBlock() and i = -1 and name = "getBlock"
      or
      result = node.(Call).getMethod() and i = -1 and name = "getMethod"
      or
      result = node.(Call).getOperator() and i = -1 and name = "getOperator"
      or
      result = node.(Call).getReceiver() and i = -1 and name = "getReceiver"
      or
      result = node.(Case).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Case).getChild(i) and name = "getChild"
      or
      result = node.(CaseMatch).getClauses(i) and name = "getClauses"
      or
      result = node.(CaseMatch).getElse() and i = -1 and name = "getElse"
      or
      result = node.(CaseMatch).getValue() and i = -1 and name = "getValue"
      or
      result = node.(ChainedString).getChild(i) and name = "getChild"
      or
      result = node.(Class).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Class).getName() and i = -1 and name = "getName"
      or
      result = node.(Class).getSuperclass() and i = -1 and name = "getSuperclass"
      or
      result = node.(Complex).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Conditional).getAlternative() and i = -1 and name = "getAlternative"
      or
      result = node.(Conditional).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(Conditional).getConsequence() and i = -1 and name = "getConsequence"
      or
      result = node.(DelimitedSymbol).getChild(i) and name = "getChild"
      or
      result = node.(DestructuredLeftAssignment).getChild(i) and name = "getChild"
      or
      result = node.(DestructuredParameter).getChild(i) and name = "getChild"
      or
      result = node.(Do).getChild(i) and name = "getChild"
      or
      result = node.(DoBlock).getBody() and i = -1 and name = "getBody"
      or
      result = node.(DoBlock).getParameters() and i = -1 and name = "getParameters"
      or
      result = node.(ElementReference).getBlock() and i = -1 and name = "getBlock"
      or
      result = node.(ElementReference).getObject() and i = -1 and name = "getObject"
      or
      result = node.(ElementReference).getChild(i) and name = "getChild"
      or
      result = node.(Else).getChild(i) and name = "getChild"
      or
      result = node.(Elsif).getAlternative() and i = -1 and name = "getAlternative"
      or
      result = node.(Elsif).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(Elsif).getConsequence() and i = -1 and name = "getConsequence"
      or
      result = node.(EndBlock).getChild(i) and name = "getChild"
      or
      result = node.(Ensure).getChild(i) and name = "getChild"
      or
      result = node.(ExceptionVariable).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Exceptions).getChild(i) and name = "getChild"
      or
      result = node.(ExpressionReferencePattern).getValue() and i = -1 and name = "getValue"
      or
      result = node.(FindPattern).getClass() and i = -1 and name = "getClass"
      or
      result = node.(FindPattern).getChild(i) and name = "getChild"
      or
      result = node.(For).getBody() and i = -1 and name = "getBody"
      or
      result = node.(For).getPattern() and i = -1 and name = "getPattern"
      or
      result = node.(For).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Hash).getChild(i) and name = "getChild"
      or
      result = node.(HashPattern).getClass() and i = -1 and name = "getClass"
      or
      result = node.(HashPattern).getChild(i) and name = "getChild"
      or
      result = node.(HashSplatArgument).getChild() and i = -1 and name = "getChild"
      or
      result = node.(HashSplatParameter).getName() and i = -1 and name = "getName"
      or
      result = node.(HeredocBody).getChild(i) and name = "getChild"
      or
      result = node.(If).getAlternative() and i = -1 and name = "getAlternative"
      or
      result = node.(If).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(If).getConsequence() and i = -1 and name = "getConsequence"
      or
      result = node.(IfGuard).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(IfModifier).getBody() and i = -1 and name = "getBody"
      or
      result = node.(IfModifier).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(In).getChild() and i = -1 and name = "getChild"
      or
      result = node.(InClause).getBody() and i = -1 and name = "getBody"
      or
      result = node.(InClause).getGuard() and i = -1 and name = "getGuard"
      or
      result = node.(InClause).getPattern() and i = -1 and name = "getPattern"
      or
      result = node.(Interpolation).getChild(i) and name = "getChild"
      or
      result = node.(KeywordParameter).getName() and i = -1 and name = "getName"
      or
      result = node.(KeywordParameter).getValue() and i = -1 and name = "getValue"
      or
      result = node.(KeywordPattern).getKey() and i = -1 and name = "getKey"
      or
      result = node.(KeywordPattern).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Lambda).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Lambda).getParameters() and i = -1 and name = "getParameters"
      or
      result = node.(LambdaParameters).getChild(i) and name = "getChild"
      or
      result = node.(LeftAssignmentList).getChild(i) and name = "getChild"
      or
      result = node.(MatchPattern).getPattern() and i = -1 and name = "getPattern"
      or
      result = node.(MatchPattern).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Method).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Method).getName() and i = -1 and name = "getName"
      or
      result = node.(Method).getParameters() and i = -1 and name = "getParameters"
      or
      result = node.(MethodParameters).getChild(i) and name = "getChild"
      or
      result = node.(Module).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Module).getName() and i = -1 and name = "getName"
      or
      result = node.(Next).getChild() and i = -1 and name = "getChild"
      or
      result = node.(OperatorAssignment).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(OperatorAssignment).getRight() and i = -1 and name = "getRight"
      or
      result = node.(OptionalParameter).getName() and i = -1 and name = "getName"
      or
      result = node.(OptionalParameter).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Pair).getKey() and i = -1 and name = "getKey"
      or
      result = node.(Pair).getValue() and i = -1 and name = "getValue"
      or
      result = node.(ParenthesizedPattern).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ParenthesizedStatements).getChild(i) and name = "getChild"
      or
      result = node.(Pattern).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Program).getChild(i) and name = "getChild"
      or
      result = node.(Range).getBegin() and i = -1 and name = "getBegin"
      or
      result = node.(Range).getEnd() and i = -1 and name = "getEnd"
      or
      result = node.(Rational).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Redo).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Regex).getChild(i) and name = "getChild"
      or
      result = node.(Rescue).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Rescue).getExceptions() and i = -1 and name = "getExceptions"
      or
      result = node.(Rescue).getVariable() and i = -1 and name = "getVariable"
      or
      result = node.(RescueModifier).getBody() and i = -1 and name = "getBody"
      or
      result = node.(RescueModifier).getHandler() and i = -1 and name = "getHandler"
      or
      result = node.(RestAssignment).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Retry).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Return).getChild() and i = -1 and name = "getChild"
      or
      result = node.(RightAssignmentList).getChild(i) and name = "getChild"
      or
      result = node.(ScopeResolution).getName() and i = -1 and name = "getName"
      or
      result = node.(ScopeResolution).getScope() and i = -1 and name = "getScope"
      or
      result = node.(Setter).getName() and i = -1 and name = "getName"
      or
      result = node.(SingletonClass).getBody() and i = -1 and name = "getBody"
      or
      result = node.(SingletonClass).getValue() and i = -1 and name = "getValue"
      or
      result = node.(SingletonMethod).getBody() and i = -1 and name = "getBody"
      or
      result = node.(SingletonMethod).getName() and i = -1 and name = "getName"
      or
      result = node.(SingletonMethod).getObject() and i = -1 and name = "getObject"
      or
      result = node.(SingletonMethod).getParameters() and i = -1 and name = "getParameters"
      or
      result = node.(SplatArgument).getChild() and i = -1 and name = "getChild"
      or
      result = node.(SplatParameter).getName() and i = -1 and name = "getName"
      or
      result = node.(String).getChild(i) and name = "getChild"
      or
      result = node.(StringArray).getChild(i) and name = "getChild"
      or
      result = node.(Subshell).getChild(i) and name = "getChild"
      or
      result = node.(Superclass).getChild() and i = -1 and name = "getChild"
      or
      result = node.(SymbolArray).getChild(i) and name = "getChild"
      or
      result = node.(TestPattern).getPattern() and i = -1 and name = "getPattern"
      or
      result = node.(TestPattern).getValue() and i = -1 and name = "getValue"
      or
      result = node.(Then).getChild(i) and name = "getChild"
      or
      result = node.(Unary).getOperand() and i = -1 and name = "getOperand"
      or
      result = node.(Undef).getChild(i) and name = "getChild"
      or
      result = node.(Unless).getAlternative() and i = -1 and name = "getAlternative"
      or
      result = node.(Unless).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(Unless).getConsequence() and i = -1 and name = "getConsequence"
      or
      result = node.(UnlessGuard).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(UnlessModifier).getBody() and i = -1 and name = "getBody"
      or
      result = node.(UnlessModifier).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(Until).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Until).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(UntilModifier).getBody() and i = -1 and name = "getBody"
      or
      result = node.(UntilModifier).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(VariableReferencePattern).getName() and i = -1 and name = "getName"
      or
      result = node.(When).getBody() and i = -1 and name = "getBody"
      or
      result = node.(When).getPattern(i) and name = "getPattern"
      or
      result = node.(While).getBody() and i = -1 and name = "getBody"
      or
      result = node.(While).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(WhileModifier).getBody() and i = -1 and name = "getBody"
      or
      result = node.(WhileModifier).getCondition() and i = -1 and name = "getCondition"
      or
      result = node.(Yield).getChild() and i = -1 and name = "getChild"
    }
  }
}

module RubyFinal {
  private module F = Ruby;

  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class UnderscoreArg = F::UnderscoreArg;

  final class UnderscoreCallOperator = F::UnderscoreCallOperator;

  final class UnderscoreExpression = F::UnderscoreExpression;

  final class UnderscoreLhs = F::UnderscoreLhs;

  final class UnderscoreMethodName = F::UnderscoreMethodName;

  final class UnderscoreNonlocalVariable = F::UnderscoreNonlocalVariable;

  final class UnderscorePatternConstant = F::UnderscorePatternConstant;

  final class UnderscorePatternExpr = F::UnderscorePatternExpr;

  final class UnderscorePatternExprBasic = F::UnderscorePatternExprBasic;

  final class UnderscorePatternPrimitive = F::UnderscorePatternPrimitive;

  final class UnderscorePatternTopExprBody = F::UnderscorePatternTopExprBody;

  final class UnderscorePrimary = F::UnderscorePrimary;

  final class UnderscoreSimpleNumeric = F::UnderscoreSimpleNumeric;

  final class UnderscoreStatement = F::UnderscoreStatement;

  final class UnderscoreVariable = F::UnderscoreVariable;

  final class Alias = F::Alias;

  final class AlternativePattern = F::AlternativePattern;

  final class ArgumentList = F::ArgumentList;

  final class Array = F::Array;

  final class ArrayPattern = F::ArrayPattern;

  final class AsPattern = F::AsPattern;

  final class Assignment = F::Assignment;

  final class BareString = F::BareString;

  final class BareSymbol = F::BareSymbol;

  final class Begin = F::Begin;

  final class BeginBlock = F::BeginBlock;

  final class Binary = F::Binary;

  final class Block = F::Block;

  final class BlockArgument = F::BlockArgument;

  final class BlockBody = F::BlockBody;

  final class BlockParameter = F::BlockParameter;

  final class BlockParameters = F::BlockParameters;

  final class BodyStatement = F::BodyStatement;

  final class Break = F::Break;

  final class Call = F::Call;

  final class Case = F::Case;

  final class CaseMatch = F::CaseMatch;

  final class ChainedString = F::ChainedString;

  final class Character = F::Character;

  final class Class = F::Class;

  final class ClassVariable = F::ClassVariable;

  final class Comment = F::Comment;

  final class Complex = F::Complex;

  final class Conditional = F::Conditional;

  final class Constant = F::Constant;

  final class DelimitedSymbol = F::DelimitedSymbol;

  final class DestructuredLeftAssignment = F::DestructuredLeftAssignment;

  final class DestructuredParameter = F::DestructuredParameter;

  final class Do = F::Do;

  final class DoBlock = F::DoBlock;

  final class ElementReference = F::ElementReference;

  final class Else = F::Else;

  final class Elsif = F::Elsif;

  final class EmptyStatement = F::EmptyStatement;

  final class Encoding = F::Encoding;

  final class EndBlock = F::EndBlock;

  final class Ensure = F::Ensure;

  final class EscapeSequence = F::EscapeSequence;

  final class ExceptionVariable = F::ExceptionVariable;

  final class Exceptions = F::Exceptions;

  final class ExpressionReferencePattern = F::ExpressionReferencePattern;

  final class False = F::False;

  final class File = F::File;

  final class FindPattern = F::FindPattern;

  final class Float = F::Float;

  final class For = F::For;

  final class ForwardArgument = F::ForwardArgument;

  final class ForwardParameter = F::ForwardParameter;

  final class GlobalVariable = F::GlobalVariable;

  final class Hash = F::Hash;

  final class HashKeySymbol = F::HashKeySymbol;

  final class HashPattern = F::HashPattern;

  final class HashSplatArgument = F::HashSplatArgument;

  final class HashSplatNil = F::HashSplatNil;

  final class HashSplatParameter = F::HashSplatParameter;

  final class HeredocBeginning = F::HeredocBeginning;

  final class HeredocBody = F::HeredocBody;

  final class HeredocContent = F::HeredocContent;

  final class HeredocEnd = F::HeredocEnd;

  final class Identifier = F::Identifier;

  final class If = F::If;

  final class IfGuard = F::IfGuard;

  final class IfModifier = F::IfModifier;

  final class In = F::In;

  final class InClause = F::InClause;

  final class InstanceVariable = F::InstanceVariable;

  final class Integer = F::Integer;

  final class Interpolation = F::Interpolation;

  final class KeywordParameter = F::KeywordParameter;

  final class KeywordPattern = F::KeywordPattern;

  final class Lambda = F::Lambda;

  final class LambdaParameters = F::LambdaParameters;

  final class LeftAssignmentList = F::LeftAssignmentList;

  final class Line = F::Line;

  final class MatchPattern = F::MatchPattern;

  final class Method = F::Method;

  final class MethodParameters = F::MethodParameters;

  final class Module = F::Module;

  final class Next = F::Next;

  final class Nil = F::Nil;

  final class Operator = F::Operator;

  final class OperatorAssignment = F::OperatorAssignment;

  final class OptionalParameter = F::OptionalParameter;

  final class Pair = F::Pair;

  final class ParenthesizedPattern = F::ParenthesizedPattern;

  final class ParenthesizedStatements = F::ParenthesizedStatements;

  final class Pattern = F::Pattern;

  final class Program = F::Program;

  final class Range = F::Range;

  final class Rational = F::Rational;

  final class Redo = F::Redo;

  final class Regex = F::Regex;

  final class Rescue = F::Rescue;

  final class RescueModifier = F::RescueModifier;

  final class RestAssignment = F::RestAssignment;

  final class Retry = F::Retry;

  final class Return = F::Return;

  final class RightAssignmentList = F::RightAssignmentList;

  final class ScopeResolution = F::ScopeResolution;

  final class Self = F::Self;

  final class Setter = F::Setter;

  final class SimpleSymbol = F::SimpleSymbol;

  final class SingletonClass = F::SingletonClass;

  final class SingletonMethod = F::SingletonMethod;

  final class SplatArgument = F::SplatArgument;

  final class SplatParameter = F::SplatParameter;

  final class String = F::String;

  final class StringArray = F::StringArray;

  final class StringContent = F::StringContent;

  final class Subshell = F::Subshell;

  final class Super = F::Super;

  final class Superclass = F::Superclass;

  final class SymbolArray = F::SymbolArray;

  final class TestPattern = F::TestPattern;

  final class Then = F::Then;

  final class True = F::True;

  final class Unary = F::Unary;

  final class Undef = F::Undef;

  final class Uninterpreted = F::Uninterpreted;

  final class Unless = F::Unless;

  final class UnlessGuard = F::UnlessGuard;

  final class UnlessModifier = F::UnlessModifier;

  final class Until = F::Until;

  final class UntilModifier = F::UntilModifier;

  final class VariableReferencePattern = F::VariableReferencePattern;

  final class When = F::When;

  final class While = F::While;

  final class WhileModifier = F::WhileModifier;

  final class Yield = F::Yield;
}

overlay[local]
module Erb {
  private module F = Erb;

  /** The base class for all AST nodes */
  class AstNode extends @erb_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { erb_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { erb_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { erb_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @erb_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { erb_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @erb_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@erb_ast_node node) {
    exists(@location_default loc | erb_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @erb_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@erb_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `code` tokens. */
  class Code extends @erb_token_code, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Code" }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @erb_token_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `comment_directive` nodes. */
  class CommentDirective extends @erb_comment_directive, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CommentDirective" }

    /** Gets the child of this node. */
    final F::Comment getChild() { erb_comment_directive_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { erb_comment_directive_child(this, result) }
  }

  /** A class representing `content` tokens. */
  class Content extends @erb_token_content, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Content" }
  }

  /** A class representing `directive` nodes. */
  class Directive extends @erb_directive, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Directive" }

    /** Gets the child of this node. */
    final F::Code getChild() { erb_directive_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { erb_directive_child(this, result) }
  }

  /** A class representing `graphql_directive` nodes. */
  class GraphqlDirective extends @erb_graphql_directive, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GraphqlDirective" }

    /** Gets the child of this node. */
    final F::Code getChild() { erb_graphql_directive_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { erb_graphql_directive_child(this, result) }
  }

  /** A class representing `output_directive` nodes. */
  class OutputDirective extends @erb_output_directive, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OutputDirective" }

    /** Gets the child of this node. */
    final F::Code getChild() { erb_output_directive_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { erb_output_directive_child(this, result) }
  }

  /** A class representing `template` nodes. */
  class Template extends @erb_template, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Template" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { erb_template_child(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getAChild() { result = this.getChild(_) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { erb_template_child(this, _, result) }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(CommentDirective).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Directive).getChild() and i = -1 and name = "getChild"
      or
      result = node.(GraphqlDirective).getChild() and i = -1 and name = "getChild"
      or
      result = node.(OutputDirective).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Template).getChild(i) and name = "getChild"
    }
  }
}

module ErbFinal {
  private module F = Erb;

  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class Code = F::Code;

  final class Comment = F::Comment;

  final class CommentDirective = F::CommentDirective;

  final class Content = F::Content;

  final class Directive = F::Directive;

  final class GraphqlDirective = F::GraphqlDirective;

  final class OutputDirective = F::OutputDirective;

  final class Template = F::Template;
}
