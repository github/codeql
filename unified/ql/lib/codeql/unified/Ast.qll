/**
 * CodeQL library for Unified
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
module Unified {
  /** The base class for all AST nodes */
  class AstNode extends @unified_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { unified_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { unified_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { unified_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @unified_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { unified_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A trivia token, such as a comment, preserved from the original parse tree. */
  class TriviaToken extends @unified_trivia_token, AstNode {
    /** Gets the source text of this trivia token. */
    final string getValue() { unified_trivia_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "TriviaToken" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@unified_ast_node node) {
    exists(@location_default loc | unified_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @unified_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@unified_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `apply_pattern` nodes. */
  class ApplyPattern extends @unified_apply_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ApplyPattern" }

    /** Gets the node corresponding to the field `argument`. */
    final Pattern getArgument(int i) { unified_apply_pattern_argument(this, i, result) }

    /** Gets the node corresponding to the field `constructor`. */
    final Expr getConstructor() { unified_apply_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_apply_pattern_argument(this, _, result) or unified_apply_pattern_def(this, result)
    }
  }

  /** A class representing `binary_expr` nodes. */
  class BinaryExpr extends @unified_binary_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BinaryExpr" }

    /** Gets the node corresponding to the field `left`. */
    final Expr getLeft() { unified_binary_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final Operator getOperator() { unified_binary_expr_def(this, _, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final Expr getRight() { unified_binary_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_binary_expr_def(this, result, _, _) or
      unified_binary_expr_def(this, _, result, _) or
      unified_binary_expr_def(this, _, _, result)
    }
  }

  /** A class representing `block_stmt` nodes. */
  class BlockStmt extends @unified_block_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockStmt" }

    /** Gets the node corresponding to the field `body`. */
    final Stmt getBody(int i) { unified_block_stmt_body(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_block_stmt_body(this, _, result) }
  }

  /** A class representing `call_expr` nodes. */
  class CallExpr extends @unified_call_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallExpr" }

    /** Gets the node corresponding to the field `argument`. */
    final Expr getArgument(int i) { unified_call_expr_argument(this, i, result) }

    /** Gets the node corresponding to the field `function`. */
    final Expr getFunction() { unified_call_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_call_expr_argument(this, _, result) or unified_call_expr_def(this, result)
    }
  }

  class Condition extends @unified_condition, AstNode { }

  /** A class representing `empty_stmt` tokens. */
  class EmptyStmt extends @unified_token_empty_stmt, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EmptyStmt" }
  }

  class Expr extends @unified_expr, AstNode { }

  /** A class representing `expr_condition` nodes. */
  class ExprCondition extends @unified_expr_condition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprCondition" }

    /** Gets the node corresponding to the field `expr`. */
    final Expr getExpr() { unified_expr_condition_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_expr_condition_def(this, result) }
  }

  /** A class representing `expr_stmt` nodes. */
  class ExprStmt extends @unified_expr_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprStmt" }

    /** Gets the node corresponding to the field `expr`. */
    final Expr getExpr() { unified_expr_stmt_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_expr_stmt_def(this, result) }
  }

  /** A class representing `guard_if_stmt` nodes. */
  class GuardIfStmt extends @unified_guard_if_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GuardIfStmt" }

    /** Gets the node corresponding to the field `condition`. */
    final Condition getCondition() { unified_guard_if_stmt_def(this, result, _) }

    /** Gets the node corresponding to the field `else`. */
    final Stmt getElse() { unified_guard_if_stmt_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_guard_if_stmt_def(this, result, _) or unified_guard_if_stmt_def(this, _, result)
    }
  }

  /** A class representing `identifier` tokens. */
  class Identifier extends @unified_token_identifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Identifier" }
  }

  /** A class representing `if_stmt` nodes. */
  class IfStmt extends @unified_if_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfStmt" }

    /** Gets the node corresponding to the field `condition`. */
    final Condition getCondition() { unified_if_stmt_def(this, result) }

    /** Gets the node corresponding to the field `else`. */
    final Stmt getElse() { unified_if_stmt_else(this, result) }

    /** Gets the node corresponding to the field `then`. */
    final Stmt getThen() { unified_if_stmt_then(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_if_stmt_def(this, result) or
      unified_if_stmt_else(this, result) or
      unified_if_stmt_then(this, result)
    }
  }

  /** A class representing `ignore_pattern` tokens. */
  class IgnorePattern extends @unified_token_ignore_pattern, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IgnorePattern" }
  }

  /** A class representing `int_literal` tokens. */
  class IntLiteral extends @unified_token_int_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IntLiteral" }
  }

  /** A class representing `lambda_expr` nodes. */
  class LambdaExpr extends @unified_lambda_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaExpr" }

    /** Gets the node corresponding to the field `body`. */
    final AstNode getBody() { unified_lambda_expr_def(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { unified_lambda_expr_parameter(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_lambda_expr_def(this, result) or unified_lambda_expr_parameter(this, _, result)
    }
  }

  /** A class representing `let_pattern_condition` nodes. */
  class LetPatternCondition extends @unified_let_pattern_condition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LetPatternCondition" }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_let_pattern_condition_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_let_pattern_condition_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_let_pattern_condition_def(this, result, _) or
      unified_let_pattern_condition_def(this, _, result)
    }
  }

  /** A class representing `member_access_expr` nodes. */
  class MemberAccessExpr extends @unified_member_access_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MemberAccessExpr" }

    /** Gets the node corresponding to the field `member`. */
    final Identifier getMember() { unified_member_access_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final Expr getTarget() { unified_member_access_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_member_access_expr_def(this, result, _) or
      unified_member_access_expr_def(this, _, result)
    }
  }

  /** A class representing `name_expr` nodes. */
  class NameExpr extends @unified_name_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NameExpr" }

    /** Gets the node corresponding to the field `identifier`. */
    final Identifier getIdentifier() { unified_name_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_name_expr_def(this, result) }
  }

  /** A class representing `operator` tokens. */
  class Operator extends @unified_token_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Operator" }
  }

  /** A class representing `parameter` nodes. */
  class Parameter extends @unified_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Parameter" }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_parameter_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_parameter_def(this, result) }
  }

  class Pattern extends @unified_pattern, AstNode { }

  /** A class representing `sequence_condition` nodes. */
  class SequenceCondition extends @unified_sequence_condition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SequenceCondition" }

    /** Gets the node corresponding to the field `condition`. */
    final Condition getCondition() { unified_sequence_condition_def(this, result) }

    /** Gets the node corresponding to the field `stmt`. */
    final Stmt getStmt(int i) { unified_sequence_condition_stmt(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_sequence_condition_def(this, result) or
      unified_sequence_condition_stmt(this, _, result)
    }
  }

  class Stmt extends @unified_stmt, AstNode { }

  /** A class representing `string_literal` tokens. */
  class StringLiteral extends @unified_token_string_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringLiteral" }
  }

  /** A class representing `top_level` nodes. */
  class TopLevel extends @unified_top_level, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TopLevel" }

    /** Gets the node corresponding to the field `body`. */
    final AstNode getBody(int i) { unified_top_level_body(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_top_level_body(this, _, result) }
  }

  /** A class representing `tuple_pattern` nodes. */
  class TuplePattern extends @unified_tuple_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TuplePattern" }

    /** Gets the node corresponding to the field `element`. */
    final Pattern getElement(int i) { unified_tuple_pattern_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_tuple_pattern_element(this, _, result) }
  }

  /** A class representing `unary_expr` nodes. */
  class UnaryExpr extends @unified_unary_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnaryExpr" }

    /** Gets the node corresponding to the field `operand`. */
    final Expr getOperand() { unified_unary_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `operator`. */
    final Operator getOperator() { unified_unary_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_unary_expr_def(this, result, _) or unified_unary_expr_def(this, _, result)
    }
  }

  /** A class representing `unsupported_node` tokens. */
  class UnsupportedNode extends @unified_token_unsupported_node, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnsupportedNode" }
  }

  /** A class representing `var_pattern` nodes. */
  class VarPattern extends @unified_var_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarPattern" }

    /** Gets the node corresponding to the field `identifier`. */
    final Identifier getIdentifier() { unified_var_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_var_pattern_def(this, result) }
  }

  /** A class representing `variable_declaration_stmt` nodes. */
  class VariableDeclarationStmt extends @unified_variable_declaration_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VariableDeclarationStmt" }

    /** Gets the node corresponding to the field `variable_declarator`. */
    final VariableDeclarator getVariableDeclarator(int i) {
      unified_variable_declaration_stmt_variable_declarator(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_variable_declaration_stmt_variable_declarator(this, _, result)
    }
  }

  /** A class representing `variable_declarator` nodes. */
  class VariableDeclarator extends @unified_variable_declarator, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VariableDeclarator" }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_variable_declarator_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_variable_declarator_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_variable_declarator_def(this, result) or
      unified_variable_declarator_value(this, result)
    }
  }
}
