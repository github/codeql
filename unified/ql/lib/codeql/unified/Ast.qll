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

  /** A class representing `accessor_declaration` nodes. */
  class AccessorDeclaration extends @unified_accessor_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AccessorDeclaration" }

    /** Gets the node corresponding to the field `accessor_kind`. */
    final AccessorKind getAccessorKind() { unified_accessor_declaration_def(this, result, _) }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_accessor_declaration_body(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_accessor_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_accessor_declaration_def(this, _, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { unified_accessor_declaration_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final TypeExpr getReturnType() { unified_accessor_declaration_return_type(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_accessor_declaration_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_accessor_declaration_def(this, result, _) or
      unified_accessor_declaration_body(this, result) or
      unified_accessor_declaration_modifier(this, _, result) or
      unified_accessor_declaration_def(this, _, result) or
      unified_accessor_declaration_parameter(this, _, result) or
      unified_accessor_declaration_return_type(this, result) or
      unified_accessor_declaration_type(this, result)
    }
  }

  /** A class representing `accessor_kind` tokens. */
  class AccessorKind extends @unified_token_accessor_kind, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AccessorKind" }
  }

  /** A class representing `argument` nodes. */
  class Argument extends @unified_argument, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Argument" }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_argument_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_argument_name(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_argument_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_argument_modifier(this, _, result) or
      unified_argument_name(this, result) or
      unified_argument_value(this, result)
    }
  }

  /** A class representing `array_literal` nodes. */
  class ArrayLiteral extends @unified_array_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArrayLiteral" }

    /** Gets the node corresponding to the field `element`. */
    final Expr getElement(int i) { unified_array_literal_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_array_literal_element(this, _, result) }
  }

  /** A class representing `assign_expr` nodes. */
  class AssignExpr extends @unified_assign_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AssignExpr" }

    /** Gets the node corresponding to the field `target`. */
    final ExprOrPattern getTarget() { unified_assign_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_assign_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_assign_expr_def(this, result, _) or unified_assign_expr_def(this, _, result)
    }
  }

  /** A class representing `associated_type_declaration` nodes. */
  class AssociatedTypeDeclaration extends @unified_associated_type_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AssociatedTypeDeclaration" }

    /** Gets the node corresponding to the field `bound`. */
    final TypeExpr getBound() { unified_associated_type_declaration_bound(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) {
      unified_associated_type_declaration_modifier(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_associated_type_declaration_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_associated_type_declaration_bound(this, result) or
      unified_associated_type_declaration_modifier(this, _, result) or
      unified_associated_type_declaration_def(this, result)
    }
  }

  /** A class representing `base_type` nodes. */
  class BaseType extends @unified_base_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BaseType" }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_base_type_modifier(this, i, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_base_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_base_type_modifier(this, _, result) or unified_base_type_def(this, result)
    }
  }

  /** A class representing `binary_expr` nodes. */
  class BinaryExpr extends @unified_binary_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BinaryExpr" }

    /** Gets the node corresponding to the field `left`. */
    final Expr getLeft() { unified_binary_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final InfixOperator getOperator() { unified_binary_expr_def(this, _, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final Expr getRight() { unified_binary_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_binary_expr_def(this, result, _, _) or
      unified_binary_expr_def(this, _, result, _) or
      unified_binary_expr_def(this, _, _, result)
    }
  }

  /** A class representing `block` nodes. */
  class Block extends @unified_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Block" }

    /** Gets the node corresponding to the field `stmt`. */
    final Stmt getStmt(int i) { unified_block_stmt(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_block_stmt(this, _, result) }
  }

  /** A class representing `boolean_literal` tokens. */
  class BooleanLiteral extends @unified_token_boolean_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BooleanLiteral" }
  }

  /** A class representing `bound_type_constraint` nodes. */
  class BoundTypeConstraint extends @unified_bound_type_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BoundTypeConstraint" }

    /** Gets the node corresponding to the field `bound`. */
    final TypeExpr getBound() { unified_bound_type_constraint_def(this, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_bound_type_constraint_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_bound_type_constraint_def(this, result, _) or
      unified_bound_type_constraint_def(this, _, result)
    }
  }

  /** A class representing `break_expr` nodes. */
  class BreakExpr extends @unified_break_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BreakExpr" }

    /** Gets the node corresponding to the field `label`. */
    final Identifier getLabel() { unified_break_expr_label(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_break_expr_label(this, result) }
  }

  /** A class representing `call_expr` nodes. */
  class CallExpr extends @unified_call_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallExpr" }

    /** Gets the node corresponding to the field `argument`. */
    final Argument getArgument(int i) { unified_call_expr_argument(this, i, result) }

    /** Gets the node corresponding to the field `function`. */
    final ExprOrType getFunction() { unified_call_expr_def(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_call_expr_modifier(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_call_expr_argument(this, _, result) or
      unified_call_expr_def(this, result) or
      unified_call_expr_modifier(this, _, result)
    }
  }

  /** A class representing `catch_clause` nodes. */
  class CatchClause extends @unified_catch_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CatchClause" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_catch_clause_def(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final Expr getGuard() { unified_catch_clause_guard(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_catch_clause_pattern(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_catch_clause_def(this, result) or
      unified_catch_clause_guard(this, result) or
      unified_catch_clause_pattern(this, result)
    }
  }

  /** A class representing `class_like_declaration` nodes. */
  class ClassLikeDeclaration extends @unified_class_like_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassLikeDeclaration" }

    /** Gets the node corresponding to the field `base_type`. */
    final BaseType getBaseType(int i) { unified_class_like_declaration_base_type(this, i, result) }

    /** Gets the node corresponding to the field `member`. */
    final Member getMember(int i) { unified_class_like_declaration_member(this, i, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_class_like_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_class_like_declaration_name(this, result) }

    /** Gets the node corresponding to the field `type_constraint`. */
    final TypeConstraint getTypeConstraint(int i) {
      unified_class_like_declaration_type_constraint(this, i, result)
    }

    /** Gets the node corresponding to the field `type_parameter`. */
    final TypeParameter getTypeParameter(int i) {
      unified_class_like_declaration_type_parameter(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_class_like_declaration_base_type(this, _, result) or
      unified_class_like_declaration_member(this, _, result) or
      unified_class_like_declaration_modifier(this, _, result) or
      unified_class_like_declaration_name(this, result) or
      unified_class_like_declaration_type_constraint(this, _, result) or
      unified_class_like_declaration_type_parameter(this, _, result)
    }
  }

  /** A class representing `compound_assign_expr` nodes. */
  class CompoundAssignExpr extends @unified_compound_assign_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CompoundAssignExpr" }

    /** Gets the node corresponding to the field `operator`. */
    final InfixOperator getOperator() { unified_compound_assign_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `target`. */
    final Expr getTarget() { unified_compound_assign_expr_def(this, _, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_compound_assign_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_compound_assign_expr_def(this, result, _, _) or
      unified_compound_assign_expr_def(this, _, result, _) or
      unified_compound_assign_expr_def(this, _, _, result)
    }
  }

  /** A class representing `constructor_declaration` nodes. */
  class ConstructorDeclaration extends @unified_constructor_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConstructorDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_constructor_declaration_def(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_constructor_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_constructor_declaration_name(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) {
      unified_constructor_declaration_parameter(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_constructor_declaration_def(this, result) or
      unified_constructor_declaration_modifier(this, _, result) or
      unified_constructor_declaration_name(this, result) or
      unified_constructor_declaration_parameter(this, _, result)
    }
  }

  /** A class representing `constructor_pattern` nodes. */
  class ConstructorPattern extends @unified_constructor_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConstructorPattern" }

    /** Gets the node corresponding to the field `argument`. */
    final Pattern getArgument(int i) { unified_constructor_pattern_argument(this, i, result) }

    /** Gets the node corresponding to the field `constructor`. */
    final Expr getConstructor() { unified_constructor_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_constructor_pattern_argument(this, _, result) or
      unified_constructor_pattern_def(this, result)
    }
  }

  /** A class representing `continue_expr` nodes. */
  class ContinueExpr extends @unified_continue_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ContinueExpr" }

    /** Gets the node corresponding to the field `label`. */
    final Identifier getLabel() { unified_continue_expr_label(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_continue_expr_label(this, result) }
  }

  /** A class representing `destructor_declaration` nodes. */
  class DestructorDeclaration extends @unified_destructor_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DestructorDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_destructor_declaration_def(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_destructor_declaration_modifier(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_destructor_declaration_def(this, result) or
      unified_destructor_declaration_modifier(this, _, result)
    }
  }

  /** A class representing `do_while_stmt` nodes. */
  class DoWhileStmt extends @unified_do_while_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DoWhileStmt" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_do_while_stmt_body(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final Expr getCondition() { unified_do_while_stmt_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_do_while_stmt_body(this, result) or unified_do_while_stmt_def(this, result)
    }
  }

  /** A class representing `empty_expr` tokens. */
  class EmptyExpr extends @unified_token_empty_expr, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EmptyExpr" }
  }

  /** A class representing `equality_type_constraint` nodes. */
  class EqualityTypeConstraint extends @unified_equality_type_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EqualityTypeConstraint" }

    /** Gets the node corresponding to the field `left`. */
    final TypeExpr getLeft() { unified_equality_type_constraint_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final TypeExpr getRight() { unified_equality_type_constraint_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_equality_type_constraint_def(this, result, _) or
      unified_equality_type_constraint_def(this, _, result)
    }
  }

  class Expr extends @unified_expr, AstNode { }

  /** A class representing `expr_equality_pattern` nodes. */
  class ExprEqualityPattern extends @unified_expr_equality_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprEqualityPattern" }

    /** Gets the node corresponding to the field `expr`. */
    final Expr getExpr() { unified_expr_equality_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_expr_equality_pattern_def(this, result) }
  }

  class ExprOrPattern extends @unified_expr_or_pattern, AstNode { }

  class ExprOrType extends @unified_expr_or_type, AstNode { }

  /** A class representing `fixity` tokens. */
  class Fixity extends @unified_token_fixity, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Fixity" }
  }

  /** A class representing `float_literal` tokens. */
  class FloatLiteral extends @unified_token_float_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FloatLiteral" }
  }

  /** A class representing `for_each_stmt` nodes. */
  class ForEachStmt extends @unified_for_each_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ForEachStmt" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_for_each_stmt_body(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final Expr getGuard() { unified_for_each_stmt_guard(this, result) }

    /** Gets the node corresponding to the field `iterable`. */
    final Expr getIterable() { unified_for_each_stmt_def(this, result, _) }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_for_each_stmt_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_for_each_stmt_body(this, result) or
      unified_for_each_stmt_guard(this, result) or
      unified_for_each_stmt_def(this, result, _) or
      unified_for_each_stmt_def(this, _, result)
    }
  }

  /** A class representing `function_declaration` nodes. */
  class FunctionDeclaration extends @unified_function_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_function_declaration_body(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_function_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_function_declaration_def(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { unified_function_declaration_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final TypeExpr getReturnType() { unified_function_declaration_return_type(this, result) }

    /** Gets the node corresponding to the field `type_constraint`. */
    final TypeConstraint getTypeConstraint(int i) {
      unified_function_declaration_type_constraint(this, i, result)
    }

    /** Gets the node corresponding to the field `type_parameter`. */
    final TypeParameter getTypeParameter(int i) {
      unified_function_declaration_type_parameter(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_function_declaration_body(this, result) or
      unified_function_declaration_modifier(this, _, result) or
      unified_function_declaration_def(this, result) or
      unified_function_declaration_parameter(this, _, result) or
      unified_function_declaration_return_type(this, result) or
      unified_function_declaration_type_constraint(this, _, result) or
      unified_function_declaration_type_parameter(this, _, result)
    }
  }

  /** A class representing `function_expr` nodes. */
  class FunctionExpr extends @unified_function_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionExpr" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_function_expr_def(this, result) }

    /** Gets the node corresponding to the field `capture_declaration`. */
    final VariableDeclaration getCaptureDeclaration(int i) {
      unified_function_expr_capture_declaration(this, i, result)
    }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_function_expr_modifier(this, i, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { unified_function_expr_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final TypeExpr getReturnType() { unified_function_expr_return_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_function_expr_def(this, result) or
      unified_function_expr_capture_declaration(this, _, result) or
      unified_function_expr_modifier(this, _, result) or
      unified_function_expr_parameter(this, _, result) or
      unified_function_expr_return_type(this, result)
    }
  }

  /** A class representing `function_type_expr` nodes. */
  class FunctionTypeExpr extends @unified_function_type_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionTypeExpr" }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { unified_function_type_expr_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final TypeExpr getReturnType() { unified_function_type_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_function_type_expr_parameter(this, _, result) or
      unified_function_type_expr_def(this, result)
    }
  }

  /** A class representing `generic_type_expr` nodes. */
  class GenericTypeExpr extends @unified_generic_type_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GenericTypeExpr" }

    /** Gets the node corresponding to the field `base`. */
    final TypeExpr getBase() { unified_generic_type_expr_def(this, result) }

    /** Gets the node corresponding to the field `type_argument`. */
    final TypeExpr getTypeArgument(int i) {
      unified_generic_type_expr_type_argument(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_generic_type_expr_def(this, result) or
      unified_generic_type_expr_type_argument(this, _, result)
    }
  }

  /** A class representing `guard_if_stmt` nodes. */
  class GuardIfStmt extends @unified_guard_if_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GuardIfStmt" }

    /** Gets the node corresponding to the field `condition`. */
    final Expr getCondition() { unified_guard_if_stmt_def(this, result, _) }

    /** Gets the node corresponding to the field `else`. */
    final Block getElse() { unified_guard_if_stmt_def(this, _, result) }

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

  /** A class representing `if_expr` nodes. */
  class IfExpr extends @unified_if_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfExpr" }

    /** Gets the node corresponding to the field `condition`. */
    final Expr getCondition() { unified_if_expr_def(this, result) }

    /** Gets the node corresponding to the field `else`. */
    final Expr getElse() { unified_if_expr_else(this, result) }

    /** Gets the node corresponding to the field `then`. */
    final Expr getThen() { unified_if_expr_then(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_if_expr_def(this, result) or
      unified_if_expr_else(this, result) or
      unified_if_expr_then(this, result)
    }
  }

  /** A class representing `ignore_pattern` tokens. */
  class IgnorePattern extends @unified_token_ignore_pattern, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IgnorePattern" }
  }

  /** A class representing `import_declaration` nodes. */
  class ImportDeclaration extends @unified_import_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDeclaration" }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_import_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `path`. */
    final Identifier getPath(int i) { unified_import_declaration_path(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_import_declaration_modifier(this, _, result) or
      unified_import_declaration_path(this, _, result)
    }
  }

  /** A class representing `infix_operator` tokens. */
  class InfixOperator extends @unified_token_infix_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InfixOperator" }
  }

  /** A class representing `initializer_declaration` nodes. */
  class InitializerDeclaration extends @unified_initializer_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InitializerDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_initializer_declaration_def(this, result) }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_initializer_declaration_modifier(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_initializer_declaration_def(this, result) or
      unified_initializer_declaration_modifier(this, _, result)
    }
  }

  /** A class representing `int_literal` tokens. */
  class IntLiteral extends @unified_token_int_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IntLiteral" }
  }

  /** A class representing `key_value_pair` nodes. */
  class KeyValuePair extends @unified_key_value_pair, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeyValuePair" }

    /** Gets the node corresponding to the field `key`. */
    final Expr getKey() { unified_key_value_pair_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_key_value_pair_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_key_value_pair_def(this, result, _) or unified_key_value_pair_def(this, _, result)
    }
  }

  /** A class representing `keyword_literal` tokens. */
  class KeywordLiteral extends @unified_token_keyword_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeywordLiteral" }
  }

  /** A class representing `labeled_stmt` nodes. */
  class LabeledStmt extends @unified_labeled_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LabeledStmt" }

    /** Gets the node corresponding to the field `label`. */
    final Identifier getLabel() { unified_labeled_stmt_def(this, result, _) }

    /** Gets the node corresponding to the field `stmt`. */
    final Stmt getStmt() { unified_labeled_stmt_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_labeled_stmt_def(this, result, _) or unified_labeled_stmt_def(this, _, result)
    }
  }

  /** A class representing `map_literal` nodes. */
  class MapLiteral extends @unified_map_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MapLiteral" }

    /** Gets the node corresponding to the field `element`. */
    final Expr getElement(int i) { unified_map_literal_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_map_literal_element(this, _, result) }
  }

  class Member extends @unified_member, AstNode { }

  /** A class representing `member_access_expr` nodes. */
  class MemberAccessExpr extends @unified_member_access_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MemberAccessExpr" }

    /** Gets the node corresponding to the field `member`. */
    final Identifier getMember() { unified_member_access_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final ExprOrType getTarget() { unified_member_access_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_member_access_expr_def(this, result, _) or
      unified_member_access_expr_def(this, _, result)
    }
  }

  /** A class representing `modifier` tokens. */
  class Modifier extends @unified_token_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Modifier" }
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

  /** A class representing `name_pattern` nodes. */
  class NamePattern extends @unified_name_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NamePattern" }

    /** Gets the node corresponding to the field `identifier`. */
    final Identifier getIdentifier() { unified_name_pattern_def(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_name_pattern_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_name_pattern_def(this, result) or unified_name_pattern_type(this, result)
    }
  }

  /** A class representing `named_type_expr` nodes. */
  class NamedTypeExpr extends @unified_named_type_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NamedTypeExpr" }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_named_type_expr_def(this, result) }

    /** Gets the node corresponding to the field `qualifier`. */
    final TypeExpr getQualifier() { unified_named_type_expr_qualifier(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_named_type_expr_def(this, result) or unified_named_type_expr_qualifier(this, result)
    }
  }

  class Operator extends @unified_operator, AstNode { }

  /** A class representing `operator_syntax_declaration` nodes. */
  class OperatorSyntaxDeclaration extends @unified_operator_syntax_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OperatorSyntaxDeclaration" }

    /** Gets the node corresponding to the field `fixity`. */
    final Fixity getFixity() { unified_operator_syntax_declaration_fixity(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_operator_syntax_declaration_def(this, result) }

    /** Gets the node corresponding to the field `precedence`. */
    final Expr getPrecedence() { unified_operator_syntax_declaration_precedence(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_operator_syntax_declaration_fixity(this, result) or
      unified_operator_syntax_declaration_def(this, result) or
      unified_operator_syntax_declaration_precedence(this, result)
    }
  }

  /** A class representing `parameter` nodes. */
  class Parameter extends @unified_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Parameter" }

    /** Gets the node corresponding to the field `external_name`. */
    final Identifier getExternalName() { unified_parameter_external_name(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_parameter_pattern(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_parameter_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_parameter_external_name(this, result) or
      unified_parameter_pattern(this, result) or
      unified_parameter_type(this, result)
    }
  }

  class Pattern extends @unified_pattern, AstNode { }

  /** A class representing `pattern_guard_expr` nodes. */
  class PatternGuardExpr extends @unified_pattern_guard_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PatternGuardExpr" }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_pattern_guard_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_pattern_guard_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_pattern_guard_expr_def(this, result, _) or
      unified_pattern_guard_expr_def(this, _, result)
    }
  }

  /** A class representing `postfix_operator` tokens. */
  class PostfixOperator extends @unified_token_postfix_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PostfixOperator" }
  }

  /** A class representing `prefix_operator` tokens. */
  class PrefixOperator extends @unified_token_prefix_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixOperator" }
  }

  /** A class representing `regex_literal` tokens. */
  class RegexLiteral extends @unified_token_regex_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RegexLiteral" }
  }

  /** A class representing `return_expr` nodes. */
  class ReturnExpr extends @unified_return_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReturnExpr" }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_return_expr_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_return_expr_value(this, result) }
  }

  /** A class representing `shorthand_member_access_expr` nodes. */
  class ShorthandMemberAccessExpr extends @unified_shorthand_member_access_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ShorthandMemberAccessExpr" }

    /** Gets the node corresponding to the field `member`. */
    final Identifier getMember() { unified_shorthand_member_access_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_shorthand_member_access_expr_def(this, result)
    }
  }

  class Stmt extends @unified_stmt, AstNode { }

  /** A class representing `string_literal` tokens. */
  class StringLiteral extends @unified_token_string_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringLiteral" }
  }

  /** A class representing `super_expr` tokens. */
  class SuperExpr extends @unified_token_super_expr, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuperExpr" }
  }

  /** A class representing `switch_case` nodes. */
  class SwitchCase extends @unified_switch_case, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SwitchCase" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_switch_case_def(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final Expr getGuard() { unified_switch_case_guard(this, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern(int i) { unified_switch_case_pattern(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_switch_case_def(this, result) or
      unified_switch_case_guard(this, result) or
      unified_switch_case_pattern(this, _, result)
    }
  }

  /** A class representing `switch_expr` nodes. */
  class SwitchExpr extends @unified_switch_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SwitchExpr" }

    /** Gets the node corresponding to the field `case`. */
    final SwitchCase getCase(int i) { unified_switch_expr_case(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_switch_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_switch_expr_case(this, _, result) or unified_switch_expr_def(this, result)
    }
  }

  /** A class representing `throw_expr` nodes. */
  class ThrowExpr extends @unified_throw_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ThrowExpr" }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_throw_expr_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_throw_expr_value(this, result) }
  }

  /** A class representing `top_level` nodes. */
  class TopLevel extends @unified_top_level, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TopLevel" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_top_level_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_top_level_def(this, result) }
  }

  /** A class representing `try_expr` nodes. */
  class TryExpr extends @unified_try_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TryExpr" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_try_expr_def(this, result) }

    /** Gets the node corresponding to the field `catch_clause`. */
    final CatchClause getCatchClause(int i) { unified_try_expr_catch_clause(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_try_expr_def(this, result) or unified_try_expr_catch_clause(this, _, result)
    }
  }

  /** A class representing `tuple_expr` nodes. */
  class TupleExpr extends @unified_tuple_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleExpr" }

    /** Gets the node corresponding to the field `element`. */
    final Expr getElement(int i) { unified_tuple_expr_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_tuple_expr_element(this, _, result) }
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

  /** A class representing `tuple_type_element` nodes. */
  class TupleTypeElement extends @unified_tuple_type_element, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleTypeElement" }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_tuple_type_element_name(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_tuple_type_element_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_tuple_type_element_name(this, result) or unified_tuple_type_element_def(this, result)
    }
  }

  /** A class representing `tuple_type_expr` nodes. */
  class TupleTypeExpr extends @unified_tuple_type_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleTypeExpr" }

    /** Gets the node corresponding to the field `element`. */
    final TupleTypeElement getElement(int i) { unified_tuple_type_expr_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { unified_tuple_type_expr_element(this, _, result) }
  }

  /** A class representing `type_alias_declaration` nodes. */
  class TypeAliasDeclaration extends @unified_type_alias_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAliasDeclaration" }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_type_alias_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_type_alias_declaration_def(this, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_type_alias_declaration_def(this, _, result) }

    /** Gets the node corresponding to the field `type_constraint`. */
    final TypeConstraint getTypeConstraint(int i) {
      unified_type_alias_declaration_type_constraint(this, i, result)
    }

    /** Gets the node corresponding to the field `type_parameter`. */
    final TypeParameter getTypeParameter(int i) {
      unified_type_alias_declaration_type_parameter(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_type_alias_declaration_modifier(this, _, result) or
      unified_type_alias_declaration_def(this, result, _) or
      unified_type_alias_declaration_def(this, _, result) or
      unified_type_alias_declaration_type_constraint(this, _, result) or
      unified_type_alias_declaration_type_parameter(this, _, result)
    }
  }

  /** A class representing `type_cast_expr` nodes. */
  class TypeCastExpr extends @unified_type_cast_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeCastExpr" }

    /** Gets the node corresponding to the field `expr`. */
    final Expr getExpr() { unified_type_cast_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final InfixOperator getOperator() { unified_type_cast_expr_def(this, _, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_type_cast_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_type_cast_expr_def(this, result, _, _) or
      unified_type_cast_expr_def(this, _, result, _) or
      unified_type_cast_expr_def(this, _, _, result)
    }
  }

  class TypeConstraint extends @unified_type_constraint, AstNode { }

  class TypeExpr extends @unified_type_expr, AstNode { }

  /** A class representing `type_parameter` nodes. */
  class TypeParameter extends @unified_type_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameter" }

    /** Gets the node corresponding to the field `bound`. */
    final TypeExpr getBound() { unified_type_parameter_bound(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { unified_type_parameter_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_type_parameter_bound(this, result) or unified_type_parameter_def(this, result)
    }
  }

  /** A class representing `type_test_expr` nodes. */
  class TypeTestExpr extends @unified_type_test_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeTestExpr" }

    /** Gets the node corresponding to the field `expr`. */
    final Expr getExpr() { unified_type_test_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final InfixOperator getOperator() { unified_type_test_expr_def(this, _, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_type_test_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_type_test_expr_def(this, result, _, _) or
      unified_type_test_expr_def(this, _, result, _) or
      unified_type_test_expr_def(this, _, _, result)
    }
  }

  /** A class representing `type_test_pattern` nodes. */
  class TypeTestPattern extends @unified_type_test_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeTestPattern" }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_type_test_pattern_def(this, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_type_test_pattern_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_type_test_pattern_def(this, result, _) or
      unified_type_test_pattern_def(this, _, result)
    }
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

  /** A class representing `variable_declaration` nodes. */
  class VariableDeclaration extends @unified_variable_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VariableDeclaration" }

    /** Gets the node corresponding to the field `modifier`. */
    final Modifier getModifier(int i) { unified_variable_declaration_modifier(this, i, result) }

    /** Gets the node corresponding to the field `pattern`. */
    final Pattern getPattern() { unified_variable_declaration_def(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeExpr getType() { unified_variable_declaration_type(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expr getValue() { unified_variable_declaration_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_variable_declaration_modifier(this, _, result) or
      unified_variable_declaration_def(this, result) or
      unified_variable_declaration_type(this, result) or
      unified_variable_declaration_value(this, result)
    }
  }

  /** A class representing `while_stmt` nodes. */
  class WhileStmt extends @unified_while_stmt, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WhileStmt" }

    /** Gets the node corresponding to the field `body`. */
    final Block getBody() { unified_while_stmt_body(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final Expr getCondition() { unified_while_stmt_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      unified_while_stmt_body(this, result) or unified_while_stmt_def(this, result)
    }
  }
}
