/**
 * CodeQL library for Swift
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
module Swift {
  /** The base class for all AST nodes */
  class AstNode extends @swift_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { swift_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { swift_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { swift_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @swift_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { swift_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @swift_reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@swift_ast_node node) {
    exists(@location_default loc | swift_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @swift_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@swift_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `_expression` tokens. */
  class UnderscoreExpression extends @swift_token__expression, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnderscoreExpression" }
  }

  /** A class representing `additive_expression` nodes. */
  class AdditiveExpression extends @swift_additive_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AdditiveExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_additive_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_additive_expression_def(this, _, value, _) |
        result = "+" and value = 0
        or
        result = "-" and value = 1
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_additive_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_additive_expression_def(this, result, _, _) or
      swift_additive_expression_def(this, _, _, result)
    }
  }

  /** A class representing `array_literal` nodes. */
  class ArrayLiteral extends @swift_array_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArrayLiteral" }

    /** Gets the node corresponding to the field `element`. */
    final AstNode getElement(int i) { swift_array_literal_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_array_literal_element(this, _, result) }
  }

  /** A class representing `array_type` nodes. */
  class ArrayType extends @swift_array_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArrayType" }

    /** Gets the node corresponding to the field `element`. */
    final AstNode getElement(int i) { swift_array_type_element(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_array_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_array_type_element(this, _, result) or swift_array_type_def(this, result)
    }
  }

  /** A class representing `as_expression` nodes. */
  class AsExpression extends @swift_as_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final AstNode getExpr() { swift_as_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_as_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_as_expression_type(this, i, result) }

    /** Gets the child of this node. */
    final AsOperator getChild() { swift_as_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_as_expression_def(this, result, _, _) or
      swift_as_expression_def(this, _, result, _) or
      swift_as_expression_type(this, _, result) or
      swift_as_expression_def(this, _, _, result)
    }
  }

  /** A class representing `as_operator` tokens. */
  class AsOperator extends @swift_token_as_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsOperator" }
  }

  /** A class representing `assignment` nodes. */
  class Assignment extends @swift_assignment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Assignment" }

    /** Gets the node corresponding to the field `operator`. */
    final string getOperator() {
      exists(int value | swift_assignment_def(this, value, _, _) |
        result = "%=" and value = 0
        or
        result = "*=" and value = 1
        or
        result = "+=" and value = 2
        or
        result = "-=" and value = 3
        or
        result = "/=" and value = 4
        or
        result = "=" and value = 5
      )
    }

    /** Gets the node corresponding to the field `result`. */
    final AstNode getResult() { swift_assignment_def(this, _, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final DirectlyAssignableExpression getTarget() { swift_assignment_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_assignment_def(this, _, result, _) or swift_assignment_def(this, _, _, result)
    }
  }

  /** A class representing `associatedtype_declaration` nodes. */
  class AssociatedtypeDeclaration extends @swift_associatedtype_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AssociatedtypeDeclaration" }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) {
      swift_associatedtype_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `must_inherit`. */
    final AstNode getMustInherit(int i) {
      swift_associatedtype_declaration_must_inherit(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_associatedtype_declaration_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_associatedtype_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_associatedtype_declaration_default_value(this, _, result) or
      swift_associatedtype_declaration_must_inherit(this, _, result) or
      swift_associatedtype_declaration_name(this, _, result) or
      swift_associatedtype_declaration_child(this, _, result)
    }
  }

  /** A class representing `attribute` nodes. */
  class Attribute extends @swift_attribute, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Attribute" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_attribute_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_attribute_child(this, _, result) }
  }

  /** A class representing `availability_condition` nodes. */
  class AvailabilityCondition extends @swift_availability_condition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AvailabilityCondition" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_availability_condition_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_availability_condition_child(this, _, result)
    }
  }

  /** A class representing `await_expression` nodes. */
  class AwaitExpression extends @swift_await_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AwaitExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final AstNode getExpr() { swift_await_expression_expr(this, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_await_expression_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_await_expression_expr(this, result) or swift_await_expression_child(this, result)
    }
  }

  /** A class representing `bang` tokens. */
  class Bang extends @swift_token_bang, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Bang" }
  }

  /** A class representing `bin_literal` tokens. */
  class BinLiteral extends @swift_token_bin_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BinLiteral" }
  }

  /** A class representing `bitwise_operation` nodes. */
  class BitwiseOperation extends @swift_bitwise_operation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BitwiseOperation" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_bitwise_operation_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_bitwise_operation_def(this, _, value, _) |
        result = "&" and value = 0
        or
        result = "<<" and value = 1
        or
        result = ">>" and value = 2
        or
        result = "^" and value = 3
        or
        result = "|" and value = 4
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_bitwise_operation_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_bitwise_operation_def(this, result, _, _) or
      swift_bitwise_operation_def(this, _, _, result)
    }
  }

  /** A class representing `boolean_literal` tokens. */
  class BooleanLiteral extends @swift_token_boolean_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BooleanLiteral" }
  }

  /** A class representing `call_expression` nodes. */
  class CallExpression extends @swift_call_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallExpression" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_call_expression_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_call_expression_child(this, _, result) }
  }

  /** A class representing `call_suffix` nodes. */
  class CallSuffix extends @swift_call_suffix, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallSuffix" }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_call_suffix_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_call_suffix_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_call_suffix_name(this, _, result) or swift_call_suffix_child(this, _, result)
    }
  }

  /** A class representing `capture_list` nodes. */
  class CaptureList extends @swift_capture_list, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaptureList" }

    /** Gets the `i`th child of this node. */
    final CaptureListItem getChild(int i) { swift_capture_list_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_capture_list_child(this, _, result) }
  }

  /** A class representing `capture_list_item` nodes. */
  class CaptureListItem extends @swift_capture_list_item, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaptureListItem" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_capture_list_item_def(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue() { swift_capture_list_item_value(this, result) }

    /** Gets the child of this node. */
    final OwnershipModifier getChild() { swift_capture_list_item_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_capture_list_item_def(this, result) or
      swift_capture_list_item_value(this, result) or
      swift_capture_list_item_child(this, result)
    }
  }

  /** A class representing `catch_block` nodes. */
  class CatchBlock extends @swift_catch_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CatchBlock" }

    /** Gets the node corresponding to the field `error`. */
    final Pattern getError() { swift_catch_block_error(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_catch_block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_catch_block_error(this, result) or swift_catch_block_child(this, _, result)
    }
  }

  /** A class representing `catch_keyword` tokens. */
  class CatchKeyword extends @swift_token_catch_keyword, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CatchKeyword" }
  }

  /** A class representing `check_expression` nodes. */
  class CheckExpression extends @swift_check_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CheckExpression" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_check_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_check_expression_def(this, _, value, _) |
        (result = "is" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `target`. */
    final AstNode getTarget() { swift_check_expression_def(this, _, _, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_check_expression_type(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_check_expression_def(this, result, _, _) or
      swift_check_expression_def(this, _, _, result) or
      swift_check_expression_type(this, _, result)
    }
  }

  /** A class representing `class_body` nodes. */
  class ClassBody extends @swift_class_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassBody" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_class_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_class_body_child(this, _, result) }
  }

  /** A class representing `class_declaration` nodes. */
  class ClassDeclaration extends @swift_class_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final AstNode getBody() { swift_class_declaration_def(this, result, _, _) }

    /** Gets the node corresponding to the field `declaration_kind`. */
    final string getDeclarationKind() {
      exists(int value | swift_class_declaration_def(this, _, value, _) |
        result = "actor" and value = 0
        or
        result = "class" and value = 1
        or
        result = "enum" and value = 2
        or
        result = "extension" and value = 3
        or
        result = "struct" and value = 4
      )
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_class_declaration_def(this, _, _, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_class_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_class_declaration_def(this, result, _, _) or
      swift_class_declaration_def(this, _, _, result) or
      swift_class_declaration_child(this, _, result)
    }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @swift_token_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `comparison_expression` nodes. */
  class ComparisonExpression extends @swift_comparison_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComparisonExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_comparison_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_comparison_expression_def(this, _, value, _) |
        result = "<" and value = 0
        or
        result = "<=" and value = 1
        or
        result = ">" and value = 2
        or
        result = ">=" and value = 3
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_comparison_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_comparison_expression_def(this, result, _, _) or
      swift_comparison_expression_def(this, _, _, result)
    }
  }

  /** A class representing `computed_getter` nodes. */
  class ComputedGetter extends @swift_computed_getter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedGetter" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_computed_getter_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_computed_getter_child(this, _, result) }
  }

  /** A class representing `computed_modify` nodes. */
  class ComputedModify extends @swift_computed_modify, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedModify" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_computed_modify_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_computed_modify_child(this, _, result) }
  }

  /** A class representing `computed_property` nodes. */
  class ComputedProperty extends @swift_computed_property, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedProperty" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_computed_property_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_computed_property_child(this, _, result) }
  }

  /** A class representing `computed_setter` nodes. */
  class ComputedSetter extends @swift_computed_setter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedSetter" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_computed_setter_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_computed_setter_child(this, _, result) }
  }

  /** A class representing `conjunction_expression` nodes. */
  class ConjunctionExpression extends @swift_conjunction_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConjunctionExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_conjunction_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_conjunction_expression_def(this, _, value, _) |
        (result = "&&" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_conjunction_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_conjunction_expression_def(this, result, _, _) or
      swift_conjunction_expression_def(this, _, _, result)
    }
  }

  /** A class representing `constructor_expression` nodes. */
  class ConstructorExpression extends @swift_constructor_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConstructorExpression" }

    /** Gets the node corresponding to the field `constructed_type`. */
    final AstNode getConstructedType() { swift_constructor_expression_def(this, result, _) }

    /** Gets the child of this node. */
    final ConstructorSuffix getChild() { swift_constructor_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_constructor_expression_def(this, result, _) or
      swift_constructor_expression_def(this, _, result)
    }
  }

  /** A class representing `constructor_suffix` nodes. */
  class ConstructorSuffix extends @swift_constructor_suffix, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConstructorSuffix" }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_constructor_suffix_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_constructor_suffix_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_constructor_suffix_name(this, _, result) or
      swift_constructor_suffix_child(this, _, result)
    }
  }

  /** A class representing `control_transfer_statement` nodes. */
  class ControlTransferStatement extends @swift_control_transfer_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ControlTransferStatement" }

    /** Gets the node corresponding to the field `result`. */
    final AstNode getResult() { swift_control_transfer_statement_result(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_control_transfer_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_control_transfer_statement_result(this, result) or
      swift_control_transfer_statement_child(this, _, result)
    }
  }

  /** A class representing `custom_operator` tokens. */
  class CustomOperator extends @swift_token_custom_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CustomOperator" }
  }

  /** A class representing `default_keyword` tokens. */
  class DefaultKeyword extends @swift_token_default_keyword, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DefaultKeyword" }
  }

  /** A class representing `deinit_declaration` nodes. */
  class DeinitDeclaration extends @swift_deinit_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DeinitDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_deinit_declaration_def(this, result) }

    /** Gets the child of this node. */
    final Modifiers getChild() { swift_deinit_declaration_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_deinit_declaration_def(this, result) or swift_deinit_declaration_child(this, result)
    }
  }

  /** A class representing `deprecated_operator_declaration_body` nodes. */
  class DeprecatedOperatorDeclarationBody extends @swift_deprecated_operator_declaration_body,
    AstNode
  {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DeprecatedOperatorDeclarationBody" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) {
      swift_deprecated_operator_declaration_body_child(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_deprecated_operator_declaration_body_child(this, _, result)
    }
  }

  /** A class representing `diagnostic` tokens. */
  class Diagnostic extends @swift_token_diagnostic, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Diagnostic" }
  }

  /** A class representing `dictionary_literal` nodes. */
  class DictionaryLiteral extends @swift_dictionary_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DictionaryLiteral" }

    /** Gets the node corresponding to the field `key`. */
    final AstNode getKey(int i) { swift_dictionary_literal_key(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue(int i) { swift_dictionary_literal_value(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_dictionary_literal_key(this, _, result) or
      swift_dictionary_literal_value(this, _, result)
    }
  }

  /** A class representing `dictionary_type` nodes. */
  class DictionaryType extends @swift_dictionary_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DictionaryType" }

    /** Gets the node corresponding to the field `key`. */
    final AstNode getKey(int i) { swift_dictionary_type_key(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_dictionary_type_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue(int i) { swift_dictionary_type_value(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_dictionary_type_key(this, _, result) or
      swift_dictionary_type_name(this, _, result) or
      swift_dictionary_type_value(this, _, result)
    }
  }

  /** A class representing `didset_clause` nodes. */
  class DidsetClause extends @swift_didset_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DidsetClause" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_didset_clause_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_didset_clause_child(this, _, result) }
  }

  /** A class representing `directive` nodes. */
  class Directive extends @swift_directive, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Directive" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_directive_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_directive_child(this, _, result) }
  }

  /** A class representing `directly_assignable_expression` nodes. */
  class DirectlyAssignableExpression extends @swift_directly_assignable_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DirectlyAssignableExpression" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_directly_assignable_expression_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_directly_assignable_expression_child(this, result)
    }
  }

  /** A class representing `disjunction_expression` nodes. */
  class DisjunctionExpression extends @swift_disjunction_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DisjunctionExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_disjunction_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_disjunction_expression_def(this, _, value, _) |
        (result = "||" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_disjunction_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_disjunction_expression_def(this, result, _, _) or
      swift_disjunction_expression_def(this, _, _, result)
    }
  }

  /** A class representing `do_statement` nodes. */
  class DoStatement extends @swift_do_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DoStatement" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_do_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_do_statement_child(this, _, result) }
  }

  /** A class representing `else` tokens. */
  class Else extends @swift_token_else, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Else" }
  }

  /** A class representing `enum_class_body` nodes. */
  class EnumClassBody extends @swift_enum_class_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EnumClassBody" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_enum_class_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_enum_class_body_child(this, _, result) }
  }

  /** A class representing `enum_entry` nodes. */
  class EnumEntry extends @swift_enum_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EnumEntry" }

    /** Gets the node corresponding to the field `data_contents`. */
    final EnumTypeParameters getDataContents(int i) {
      swift_enum_entry_data_contents(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_enum_entry_name(this, i, result) }

    /** Gets the node corresponding to the field `raw_value`. */
    final AstNode getRawValue(int i) { swift_enum_entry_raw_value(this, i, result) }

    /** Gets the child of this node. */
    final Modifiers getChild() { swift_enum_entry_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_enum_entry_data_contents(this, _, result) or
      swift_enum_entry_name(this, _, result) or
      swift_enum_entry_raw_value(this, _, result) or
      swift_enum_entry_child(this, result)
    }
  }

  /** A class representing `enum_type_parameters` nodes. */
  class EnumTypeParameters extends @swift_enum_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EnumTypeParameters" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_enum_type_parameters_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_enum_type_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_enum_type_parameters_name(this, _, result) or
      swift_enum_type_parameters_child(this, _, result)
    }
  }

  /** A class representing `equality_constraint` nodes. */
  class EqualityConstraint extends @swift_equality_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EqualityConstraint" }

    /** Gets the node corresponding to the field `constrained_type`. */
    final AstNode getConstrainedType(int i) {
      swift_equality_constraint_constrained_type(this, i, result)
    }

    /** Gets the node corresponding to the field `must_equal`. */
    final AstNode getMustEqual(int i) { swift_equality_constraint_must_equal(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_equality_constraint_def(this, result) }

    /** Gets the `i`th child of this node. */
    final Attribute getChild(int i) { swift_equality_constraint_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_equality_constraint_constrained_type(this, _, result) or
      swift_equality_constraint_must_equal(this, _, result) or
      swift_equality_constraint_def(this, result) or
      swift_equality_constraint_child(this, _, result)
    }
  }

  /** A class representing `equality_expression` nodes. */
  class EqualityExpression extends @swift_equality_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EqualityExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_equality_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_equality_expression_def(this, _, value, _) |
        result = "!=" and value = 0
        or
        result = "!==" and value = 1
        or
        result = "==" and value = 2
        or
        result = "===" and value = 3
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_equality_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_equality_expression_def(this, result, _, _) or
      swift_equality_expression_def(this, _, _, result)
    }
  }

  /** A class representing `existential_type` nodes. */
  class ExistentialType extends @swift_existential_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExistentialType" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_existential_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_existential_type_def(this, result) }
  }

  /** A class representing `external_macro_definition` nodes. */
  class ExternalMacroDefinition extends @swift_external_macro_definition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExternalMacroDefinition" }

    /** Gets the child of this node. */
    final ValueArguments getChild() { swift_external_macro_definition_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_external_macro_definition_def(this, result) }
  }

  /** A class representing `for_statement` nodes. */
  class ForStatement extends @swift_for_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ForStatement" }

    /** Gets the node corresponding to the field `collection`. */
    final AstNode getCollection() { swift_for_statement_def(this, result, _) }

    /** Gets the node corresponding to the field `item`. */
    final Pattern getItem() { swift_for_statement_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_for_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_for_statement_def(this, result, _) or
      swift_for_statement_def(this, _, result) or
      swift_for_statement_child(this, _, result)
    }
  }

  /** A class representing `fully_open_range` tokens. */
  class FullyOpenRange extends @swift_token_fully_open_range, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FullyOpenRange" }
  }

  /** A class representing `function_body` nodes. */
  class FunctionBody extends @swift_function_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionBody" }

    /** Gets the child of this node. */
    final Statements getChild() { swift_function_body_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_function_body_child(this, result) }
  }

  /** A class representing `function_declaration` nodes. */
  class FunctionDeclaration extends @swift_function_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_function_declaration_def(this, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) {
      swift_function_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_function_declaration_name(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType(int i) { swift_function_declaration_return_type(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_function_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_function_declaration_def(this, result) or
      swift_function_declaration_default_value(this, _, result) or
      swift_function_declaration_name(this, _, result) or
      swift_function_declaration_return_type(this, _, result) or
      swift_function_declaration_child(this, _, result)
    }
  }

  /** A class representing `function_modifier` tokens. */
  class FunctionModifier extends @swift_token_function_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionModifier" }
  }

  /** A class representing `function_type` nodes. */
  class FunctionType extends @swift_function_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionType" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_function_type_def(this, result, _) }

    /** Gets the node corresponding to the field `params`. */
    final AstNode getParams() { swift_function_type_def(this, _, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType(int i) { swift_function_type_return_type(this, i, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_function_type_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_function_type_def(this, result, _) or
      swift_function_type_def(this, _, result) or
      swift_function_type_return_type(this, _, result) or
      swift_function_type_child(this, result)
    }
  }

  /** A class representing `getter_specifier` nodes. */
  class GetterSpecifier extends @swift_getter_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GetterSpecifier" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_getter_specifier_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_getter_specifier_child(this, _, result) }
  }

  /** A class representing `guard_statement` nodes. */
  class GuardStatement extends @swift_guard_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GuardStatement" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier(int i) {
      swift_guard_statement_bound_identifier(this, i, result)
    }

    /** Gets the node corresponding to the field `condition`. */
    final AstNode getCondition(int i) { swift_guard_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_guard_statement_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_guard_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_guard_statement_bound_identifier(this, _, result) or
      swift_guard_statement_condition(this, _, result) or
      swift_guard_statement_name(this, _, result) or
      swift_guard_statement_child(this, _, result)
    }
  }

  /** A class representing `hex_literal` tokens. */
  class HexLiteral extends @swift_token_hex_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HexLiteral" }
  }

  /** A class representing `identifier` nodes. */
  class Identifier extends @swift_identifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Identifier" }

    /** Gets the `i`th child of this node. */
    final SimpleIdentifier getChild(int i) { swift_identifier_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_identifier_child(this, _, result) }
  }

  /** A class representing `if_statement` nodes. */
  class IfStatement extends @swift_if_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfStatement" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier(int i) {
      swift_if_statement_bound_identifier(this, i, result)
    }

    /** Gets the node corresponding to the field `condition`. */
    final AstNode getCondition(int i) { swift_if_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_if_statement_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_if_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_if_statement_bound_identifier(this, _, result) or
      swift_if_statement_condition(this, _, result) or
      swift_if_statement_name(this, _, result) or
      swift_if_statement_child(this, _, result)
    }
  }

  /** A class representing `import_declaration` nodes. */
  class ImportDeclaration extends @swift_import_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDeclaration" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_import_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_import_declaration_child(this, _, result) }
  }

  /** A class representing `infix_expression` nodes. */
  class InfixExpression extends @swift_infix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InfixExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_infix_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final CustomOperator getOp() { swift_infix_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_infix_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_infix_expression_def(this, result, _, _) or
      swift_infix_expression_def(this, _, result, _) or
      swift_infix_expression_def(this, _, _, result)
    }
  }

  /** A class representing `inheritance_constraint` nodes. */
  class InheritanceConstraint extends @swift_inheritance_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InheritanceConstraint" }

    /** Gets the node corresponding to the field `constrained_type`. */
    final AstNode getConstrainedType(int i) {
      swift_inheritance_constraint_constrained_type(this, i, result)
    }

    /** Gets the node corresponding to the field `inherits_from`. */
    final AstNode getInheritsFrom(int i) {
      swift_inheritance_constraint_inherits_from(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_inheritance_constraint_def(this, result) }

    /** Gets the `i`th child of this node. */
    final Attribute getChild(int i) { swift_inheritance_constraint_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_inheritance_constraint_constrained_type(this, _, result) or
      swift_inheritance_constraint_inherits_from(this, _, result) or
      swift_inheritance_constraint_def(this, result) or
      swift_inheritance_constraint_child(this, _, result)
    }
  }

  /** A class representing `inheritance_modifier` tokens. */
  class InheritanceModifier extends @swift_token_inheritance_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InheritanceModifier" }
  }

  /** A class representing `inheritance_specifier` nodes. */
  class InheritanceSpecifier extends @swift_inheritance_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InheritanceSpecifier" }

    /** Gets the node corresponding to the field `inherits_from`. */
    final AstNode getInheritsFrom() { swift_inheritance_specifier_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_inheritance_specifier_def(this, result) }
  }

  /** A class representing `init_declaration` nodes. */
  class InitDeclaration extends @swift_init_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InitDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_init_declaration_body(this, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) { swift_init_declaration_default_value(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final string getName() {
      exists(int value | swift_init_declaration_def(this, value) | (result = "init" and value = 0))
    }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_init_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_init_declaration_body(this, result) or
      swift_init_declaration_default_value(this, _, result) or
      swift_init_declaration_child(this, _, result)
    }
  }

  /** A class representing `integer_literal` tokens. */
  class IntegerLiteral extends @swift_token_integer_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IntegerLiteral" }
  }

  /** A class representing `interpolated_expression` nodes. */
  class InterpolatedExpression extends @swift_interpolated_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InterpolatedExpression" }

    /** Gets the node corresponding to the field `name`. */
    final ValueArgumentLabel getName() { swift_interpolated_expression_name(this, result) }

    /** Gets the node corresponding to the field `reference_specifier`. */
    final ValueArgumentLabel getReferenceSpecifier(int i) {
      swift_interpolated_expression_reference_specifier(this, i, result)
    }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue() { swift_interpolated_expression_value(this, result) }

    /** Gets the child of this node. */
    final TypeModifiers getChild() { swift_interpolated_expression_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_interpolated_expression_name(this, result) or
      swift_interpolated_expression_reference_specifier(this, _, result) or
      swift_interpolated_expression_value(this, result) or
      swift_interpolated_expression_child(this, result)
    }
  }

  /** A class representing `key_path_expression` nodes. */
  class KeyPathExpression extends @swift_key_path_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeyPathExpression" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_key_path_expression_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_key_path_expression_child(this, _, result) }
  }

  /** A class representing `key_path_string_expression` nodes. */
  class KeyPathStringExpression extends @swift_key_path_string_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "KeyPathStringExpression" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_key_path_string_expression_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_key_path_string_expression_child(this, result)
    }
  }

  /** A class representing `lambda_function_type` nodes. */
  class LambdaFunctionType extends @swift_lambda_function_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaFunctionType" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_lambda_function_type_name(this, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType(int i) { swift_lambda_function_type_return_type(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_lambda_function_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_function_type_name(this, result) or
      swift_lambda_function_type_return_type(this, _, result) or
      swift_lambda_function_type_child(this, _, result)
    }
  }

  /** A class representing `lambda_function_type_parameters` nodes. */
  class LambdaFunctionTypeParameters extends @swift_lambda_function_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaFunctionTypeParameters" }

    /** Gets the `i`th child of this node. */
    final LambdaParameter getChild(int i) {
      swift_lambda_function_type_parameters_child(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_function_type_parameters_child(this, _, result)
    }
  }

  /** A class representing `lambda_literal` nodes. */
  class LambdaLiteral extends @swift_lambda_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaLiteral" }

    /** Gets the node corresponding to the field `captures`. */
    final CaptureList getCaptures() { swift_lambda_literal_captures(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final LambdaFunctionType getType() { swift_lambda_literal_type(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_lambda_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_literal_captures(this, result) or
      swift_lambda_literal_type(this, result) or
      swift_lambda_literal_child(this, _, result)
    }
  }

  /** A class representing `lambda_parameter` nodes. */
  class LambdaParameter extends @swift_lambda_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaParameter" }

    /** Gets the node corresponding to the field `external_name`. */
    final SimpleIdentifier getExternalName() { swift_lambda_parameter_external_name(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_lambda_parameter_name(this, i, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_lambda_parameter_type(this, i, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_lambda_parameter_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_parameter_external_name(this, result) or
      swift_lambda_parameter_name(this, _, result) or
      swift_lambda_parameter_type(this, _, result) or
      swift_lambda_parameter_child(this, result)
    }
  }

  /** A class representing `line_str_text` tokens. */
  class LineStrText extends @swift_token_line_str_text, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineStrText" }
  }

  /** A class representing `line_string_literal` nodes. */
  class LineStringLiteral extends @swift_line_string_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineStringLiteral" }

    /** Gets the node corresponding to the field `interpolation`. */
    final InterpolatedExpression getInterpolation(int i) {
      swift_line_string_literal_interpolation(this, i, result)
    }

    /** Gets the node corresponding to the field `text`. */
    final AstNode getText(int i) { swift_line_string_literal_text(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_line_string_literal_interpolation(this, _, result) or
      swift_line_string_literal_text(this, _, result)
    }
  }

  /** A class representing `macro_declaration` nodes. */
  class MacroDeclaration extends @swift_macro_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MacroDeclaration" }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) { swift_macro_declaration_default_value(this, i, result) }

    /** Gets the node corresponding to the field `definition`. */
    final MacroDefinition getDefinition() { swift_macro_declaration_definition(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_macro_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_macro_declaration_default_value(this, _, result) or
      swift_macro_declaration_definition(this, result) or
      swift_macro_declaration_child(this, _, result)
    }
  }

  /** A class representing `macro_definition` nodes. */
  class MacroDefinition extends @swift_macro_definition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MacroDefinition" }

    /** Gets the node corresponding to the field `body`. */
    final AstNode getBody() { swift_macro_definition_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_macro_definition_def(this, result) }
  }

  /** A class representing `macro_invocation` nodes. */
  class MacroInvocation extends @swift_macro_invocation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MacroInvocation" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_macro_invocation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_macro_invocation_child(this, _, result) }
  }

  /** A class representing `member_modifier` tokens. */
  class MemberModifier extends @swift_token_member_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MemberModifier" }
  }

  /** A class representing `metatype` nodes. */
  class Metatype extends @swift_metatype, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Metatype" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_metatype_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_metatype_def(this, result) }
  }

  /** A class representing `modifiers` nodes. */
  class Modifiers extends @swift_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Modifiers" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_modifiers_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_modifiers_child(this, _, result) }
  }

  /** A class representing `modify_specifier` nodes. */
  class ModifySpecifier extends @swift_modify_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModifySpecifier" }

    /** Gets the child of this node. */
    final MutationModifier getChild() { swift_modify_specifier_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_modify_specifier_child(this, result) }
  }

  /** A class representing `multi_line_str_text` tokens. */
  class MultiLineStrText extends @swift_token_multi_line_str_text, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MultiLineStrText" }
  }

  /** A class representing `multi_line_string_literal` nodes. */
  class MultiLineStringLiteral extends @swift_multi_line_string_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MultiLineStringLiteral" }

    /** Gets the node corresponding to the field `interpolation`. */
    final InterpolatedExpression getInterpolation(int i) {
      swift_multi_line_string_literal_interpolation(this, i, result)
    }

    /** Gets the node corresponding to the field `text`. */
    final AstNode getText(int i) { swift_multi_line_string_literal_text(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_multi_line_string_literal_interpolation(this, _, result) or
      swift_multi_line_string_literal_text(this, _, result)
    }
  }

  /** A class representing `multiline_comment` tokens. */
  class MultilineComment extends @swift_token_multiline_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MultilineComment" }
  }

  /** A class representing `multiplicative_expression` nodes. */
  class MultiplicativeExpression extends @swift_multiplicative_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MultiplicativeExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final AstNode getLhs() { swift_multiplicative_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_multiplicative_expression_def(this, _, value, _) |
        result = "%" and value = 0
        or
        result = "*" and value = 1
        or
        result = "/" and value = 2
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final AstNode getRhs() { swift_multiplicative_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_multiplicative_expression_def(this, result, _, _) or
      swift_multiplicative_expression_def(this, _, _, result)
    }
  }

  /** A class representing `mutation_modifier` tokens. */
  class MutationModifier extends @swift_token_mutation_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MutationModifier" }
  }

  /** A class representing `navigation_expression` nodes. */
  class NavigationExpression extends @swift_navigation_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NavigationExpression" }

    /** Gets the node corresponding to the field `element`. */
    final AstNode getElement() { swift_navigation_expression_element(this, result) }

    /** Gets the node corresponding to the field `suffix`. */
    final NavigationSuffix getSuffix() { swift_navigation_expression_def(this, result) }

    /** Gets the node corresponding to the field `target`. */
    final AstNode getTarget(int i) { swift_navigation_expression_target(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_navigation_expression_element(this, result) or
      swift_navigation_expression_def(this, result) or
      swift_navigation_expression_target(this, _, result)
    }
  }

  /** A class representing `navigation_suffix` nodes. */
  class NavigationSuffix extends @swift_navigation_suffix, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NavigationSuffix" }

    /** Gets the node corresponding to the field `suffix`. */
    final AstNode getSuffix() { swift_navigation_suffix_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_navigation_suffix_def(this, result) }
  }

  /** A class representing `nil_coalescing_expression` nodes. */
  class NilCoalescingExpression extends @swift_nil_coalescing_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NilCoalescingExpression" }

    /** Gets the node corresponding to the field `if_nil`. */
    final AstNode getIfNil() { swift_nil_coalescing_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue() { swift_nil_coalescing_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_nil_coalescing_expression_def(this, result, _) or
      swift_nil_coalescing_expression_def(this, _, result)
    }
  }

  /** A class representing `oct_literal` tokens. */
  class OctLiteral extends @swift_token_oct_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OctLiteral" }
  }

  /** A class representing `opaque_type` nodes. */
  class OpaqueType extends @swift_opaque_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OpaqueType" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_opaque_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_opaque_type_def(this, result) }
  }

  /** A class representing `open_end_range_expression` nodes. */
  class OpenEndRangeExpression extends @swift_open_end_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OpenEndRangeExpression" }

    /** Gets the node corresponding to the field `start`. */
    final AstNode getStart() { swift_open_end_range_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_open_end_range_expression_def(this, result) }
  }

  /** A class representing `open_start_range_expression` nodes. */
  class OpenStartRangeExpression extends @swift_open_start_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OpenStartRangeExpression" }

    /** Gets the node corresponding to the field `end`. */
    final AstNode getEnd() { swift_open_start_range_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_open_start_range_expression_def(this, result)
    }
  }

  /** A class representing `operator_declaration` nodes. */
  class OperatorDeclaration extends @swift_operator_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OperatorDeclaration" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_operator_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_operator_declaration_child(this, _, result) }
  }

  /** A class representing `optional_chain_marker` nodes. */
  class OptionalChainMarker extends @swift_optional_chain_marker, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OptionalChainMarker" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_optional_chain_marker_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_optional_chain_marker_child(this, result) }
  }

  /** A class representing `optional_type` nodes. */
  class OptionalType extends @swift_optional_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OptionalType" }

    /** Gets the node corresponding to the field `wrapped`. */
    final AstNode getWrapped() { swift_optional_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_optional_type_def(this, result) }
  }

  /** A class representing `ownership_modifier` tokens. */
  class OwnershipModifier extends @swift_token_ownership_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OwnershipModifier" }
  }

  /** A class representing `parameter` nodes. */
  class Parameter extends @swift_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Parameter" }

    /** Gets the node corresponding to the field `external_name`. */
    final SimpleIdentifier getExternalName() { swift_parameter_external_name(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_parameter_name(this, i, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_parameter_type(this, i, result) }

    /** Gets the child of this node. */
    final ParameterModifiers getChild() { swift_parameter_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_parameter_external_name(this, result) or
      swift_parameter_name(this, _, result) or
      swift_parameter_type(this, _, result) or
      swift_parameter_child(this, result)
    }
  }

  /** A class representing `parameter_modifier` tokens. */
  class ParameterModifier extends @swift_token_parameter_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParameterModifier" }
  }

  /** A class representing `parameter_modifiers` nodes. */
  class ParameterModifiers extends @swift_parameter_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParameterModifiers" }

    /** Gets the `i`th child of this node. */
    final ParameterModifier getChild(int i) { swift_parameter_modifiers_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_parameter_modifiers_child(this, _, result) }
  }

  /** A class representing `pattern` nodes. */
  class Pattern extends @swift_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pattern" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier() { swift_pattern_bound_identifier(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_pattern_name(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_pattern_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_pattern_bound_identifier(this, result) or
      swift_pattern_name(this, result) or
      swift_pattern_child(this, _, result)
    }
  }

  /** A class representing `playground_literal` nodes. */
  class PlaygroundLiteral extends @swift_playground_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PlaygroundLiteral" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_playground_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_playground_literal_child(this, _, result) }
  }

  /** A class representing `postfix_expression` nodes. */
  class PostfixExpression extends @swift_postfix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PostfixExpression" }

    /** Gets the node corresponding to the field `operation`. */
    final AstNode getOperation() { swift_postfix_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final AstNode getTarget() { swift_postfix_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_postfix_expression_def(this, result, _) or swift_postfix_expression_def(this, _, result)
    }
  }

  /** A class representing `precedence_group_attribute` nodes. */
  class PrecedenceGroupAttribute extends @swift_precedence_group_attribute, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupAttribute" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_precedence_group_attribute_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_attribute_child(this, _, result)
    }
  }

  /** A class representing `precedence_group_attributes` nodes. */
  class PrecedenceGroupAttributes extends @swift_precedence_group_attributes, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupAttributes" }

    /** Gets the `i`th child of this node. */
    final PrecedenceGroupAttribute getChild(int i) {
      swift_precedence_group_attributes_child(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_attributes_child(this, _, result)
    }
  }

  /** A class representing `precedence_group_declaration` nodes. */
  class PrecedenceGroupDeclaration extends @swift_precedence_group_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupDeclaration" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_precedence_group_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_declaration_child(this, _, result)
    }
  }

  /** A class representing `prefix_expression` nodes. */
  class PrefixExpression extends @swift_prefix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixExpression" }

    /** Gets the node corresponding to the field `operation`. */
    final AstNode getOperation() { swift_prefix_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final AstNode getTarget() { swift_prefix_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_prefix_expression_def(this, result, _) or swift_prefix_expression_def(this, _, result)
    }
  }

  /** A class representing `property_behavior_modifier` tokens. */
  class PropertyBehaviorModifier extends @swift_token_property_behavior_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PropertyBehaviorModifier" }
  }

  /** A class representing `property_declaration` nodes. */
  class PropertyDeclaration extends @swift_property_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PropertyDeclaration" }

    /** Gets the node corresponding to the field `computed_value`. */
    final ComputedProperty getComputedValue(int i) {
      swift_property_declaration_computed_value(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final Pattern getName(int i) { swift_property_declaration_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue(int i) { swift_property_declaration_value(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_property_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_property_declaration_computed_value(this, _, result) or
      swift_property_declaration_name(this, _, result) or
      swift_property_declaration_value(this, _, result) or
      swift_property_declaration_child(this, _, result)
    }
  }

  /** A class representing `property_modifier` tokens. */
  class PropertyModifier extends @swift_token_property_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PropertyModifier" }
  }

  /** A class representing `protocol_body` nodes. */
  class ProtocolBody extends @swift_protocol_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolBody" }

    /** Gets the node corresponding to the field `body`. */
    final ProtocolFunctionDeclaration getBody(int i) { swift_protocol_body_body(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_body_body(this, _, result) or swift_protocol_body_child(this, _, result)
    }
  }

  /** A class representing `protocol_composition_type` nodes. */
  class ProtocolCompositionType extends @swift_protocol_composition_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolCompositionType" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_composition_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_composition_type_child(this, _, result)
    }
  }

  /** A class representing `protocol_declaration` nodes. */
  class ProtocolDeclaration extends @swift_protocol_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final ProtocolBody getBody() { swift_protocol_declaration_def(this, result, _, _) }

    /** Gets the node corresponding to the field `declaration_kind`. */
    final string getDeclarationKind() {
      exists(int value | swift_protocol_declaration_def(this, _, value, _) |
        (result = "protocol" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `name`. */
    final TypeIdentifier getName() { swift_protocol_declaration_def(this, _, _, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_declaration_def(this, result, _, _) or
      swift_protocol_declaration_def(this, _, _, result) or
      swift_protocol_declaration_child(this, _, result)
    }
  }

  /** A class representing `protocol_function_declaration` nodes. */
  class ProtocolFunctionDeclaration extends @swift_protocol_function_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolFunctionDeclaration" }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) {
      swift_protocol_function_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_protocol_function_declaration_name(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType(int i) {
      swift_protocol_function_declaration_return_type(this, i, result)
    }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_function_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_function_declaration_default_value(this, _, result) or
      swift_protocol_function_declaration_name(this, _, result) or
      swift_protocol_function_declaration_return_type(this, _, result) or
      swift_protocol_function_declaration_child(this, _, result)
    }
  }

  /** A class representing `protocol_property_declaration` nodes. */
  class ProtocolPropertyDeclaration extends @swift_protocol_property_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolPropertyDeclaration" }

    /** Gets the node corresponding to the field `name`. */
    final Pattern getName() { swift_protocol_property_declaration_def(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_property_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_property_declaration_def(this, result) or
      swift_protocol_property_declaration_child(this, _, result)
    }
  }

  /** A class representing `protocol_property_requirements` nodes. */
  class ProtocolPropertyRequirements extends @swift_protocol_property_requirements, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolPropertyRequirements" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_protocol_property_requirements_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_property_requirements_child(this, _, result)
    }
  }

  /** A class representing `range_expression` nodes. */
  class RangeExpression extends @swift_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RangeExpression" }

    /** Gets the node corresponding to the field `end`. */
    final AstNode getEnd() { swift_range_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_range_expression_def(this, _, value, _) |
        result = "..." and value = 0
        or
        result = "..<" and value = 1
      )
    }

    /** Gets the node corresponding to the field `start`. */
    final AstNode getStart() { swift_range_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_range_expression_def(this, result, _, _) or
      swift_range_expression_def(this, _, _, result)
    }
  }

  /** A class representing `raw_str_continuing_indicator` tokens. */
  class RawStrContinuingIndicator extends @swift_token_raw_str_continuing_indicator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStrContinuingIndicator" }
  }

  /** A class representing `raw_str_end_part` tokens. */
  class RawStrEndPart extends @swift_token_raw_str_end_part, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStrEndPart" }
  }

  /** A class representing `raw_str_interpolation` nodes. */
  class RawStrInterpolation extends @swift_raw_str_interpolation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStrInterpolation" }

    /** Gets the node corresponding to the field `interpolation`. */
    final InterpolatedExpression getInterpolation(int i) {
      swift_raw_str_interpolation_interpolation(this, i, result)
    }

    /** Gets the child of this node. */
    final RawStrInterpolationStart getChild() { swift_raw_str_interpolation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_raw_str_interpolation_interpolation(this, _, result) or
      swift_raw_str_interpolation_def(this, result)
    }
  }

  /** A class representing `raw_str_interpolation_start` tokens. */
  class RawStrInterpolationStart extends @swift_token_raw_str_interpolation_start, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStrInterpolationStart" }
  }

  /** A class representing `raw_str_part` tokens. */
  class RawStrPart extends @swift_token_raw_str_part, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStrPart" }
  }

  /** A class representing `raw_string_literal` nodes. */
  class RawStringLiteral extends @swift_raw_string_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RawStringLiteral" }

    /** Gets the node corresponding to the field `interpolation`. */
    final RawStrInterpolation getInterpolation(int i) {
      swift_raw_string_literal_interpolation(this, i, result)
    }

    /** Gets the node corresponding to the field `text`. */
    final AstNode getText(int i) { swift_raw_string_literal_text(this, i, result) }

    /** Gets the `i`th child of this node. */
    final RawStrContinuingIndicator getChild(int i) {
      swift_raw_string_literal_child(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_raw_string_literal_interpolation(this, _, result) or
      swift_raw_string_literal_text(this, _, result) or
      swift_raw_string_literal_child(this, _, result)
    }
  }

  /** A class representing `real_literal` tokens. */
  class RealLiteral extends @swift_token_real_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RealLiteral" }
  }

  /** A class representing `referenceable_operator` nodes. */
  class ReferenceableOperator extends @swift_referenceable_operator, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReferenceableOperator" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_referenceable_operator_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_referenceable_operator_child(this, result) }
  }

  /** A class representing `regex_literal` tokens. */
  class RegexLiteral extends @swift_token_regex_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RegexLiteral" }
  }

  /** A class representing `repeat_while_statement` nodes. */
  class RepeatWhileStatement extends @swift_repeat_while_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RepeatWhileStatement" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier(int i) {
      swift_repeat_while_statement_bound_identifier(this, i, result)
    }

    /** Gets the node corresponding to the field `condition`. */
    final AstNode getCondition(int i) { swift_repeat_while_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_repeat_while_statement_name(this, i, result) }

    /** Gets the child of this node. */
    final Statements getChild() { swift_repeat_while_statement_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_repeat_while_statement_bound_identifier(this, _, result) or
      swift_repeat_while_statement_condition(this, _, result) or
      swift_repeat_while_statement_name(this, _, result) or
      swift_repeat_while_statement_child(this, result)
    }
  }

  /** A class representing `selector_expression` nodes. */
  class SelectorExpression extends @swift_selector_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SelectorExpression" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_selector_expression_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_selector_expression_child(this, result) }
  }

  /** A class representing `self_expression` tokens. */
  class SelfExpression extends @swift_token_self_expression, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SelfExpression" }
  }

  /** A class representing `setter_specifier` nodes. */
  class SetterSpecifier extends @swift_setter_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SetterSpecifier" }

    /** Gets the child of this node. */
    final MutationModifier getChild() { swift_setter_specifier_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_setter_specifier_child(this, result) }
  }

  /** A class representing `shebang_line` tokens. */
  class ShebangLine extends @swift_token_shebang_line, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ShebangLine" }
  }

  /** A class representing `simple_identifier` tokens. */
  class SimpleIdentifier extends @swift_token_simple_identifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleIdentifier" }
  }

  /** A class representing `source_file` nodes. */
  class SourceFile extends @swift_source_file, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SourceFile" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_source_file_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_source_file_child(this, _, result) }
  }

  /** A class representing `special_literal` tokens. */
  class SpecialLiteral extends @swift_token_special_literal, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialLiteral" }
  }

  /** A class representing `statement_label` tokens. */
  class StatementLabel extends @swift_token_statement_label, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StatementLabel" }
  }

  /** A class representing `statements` nodes. */
  class Statements extends @swift_statements, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Statements" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_statements_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_statements_child(this, _, result) }
  }

  /** A class representing `str_escaped_char` tokens. */
  class StrEscapedChar extends @swift_token_str_escaped_char, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StrEscapedChar" }
  }

  /** A class representing `subscript_declaration` nodes. */
  class SubscriptDeclaration extends @swift_subscript_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SubscriptDeclaration" }

    /** Gets the node corresponding to the field `default_value`. */
    final AstNode getDefaultValue(int i) {
      swift_subscript_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_subscript_declaration_name(this, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType(int i) { swift_subscript_declaration_return_type(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_subscript_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_subscript_declaration_default_value(this, _, result) or
      swift_subscript_declaration_name(this, result) or
      swift_subscript_declaration_return_type(this, _, result) or
      swift_subscript_declaration_child(this, _, result)
    }
  }

  /** A class representing `super_expression` tokens. */
  class SuperExpression extends @swift_token_super_expression, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuperExpression" }
  }

  /** A class representing `suppressed_constraint` nodes. */
  class SuppressedConstraint extends @swift_suppressed_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuppressedConstraint" }

    /** Gets the node corresponding to the field `suppressed`. */
    final TypeIdentifier getSuppressed() { swift_suppressed_constraint_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_suppressed_constraint_def(this, result) }
  }

  /** A class representing `switch_entry` nodes. */
  class SwitchEntry extends @swift_switch_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SwitchEntry" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_switch_entry_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_switch_entry_child(this, _, result) }
  }

  /** A class representing `switch_pattern` nodes. */
  class SwitchPattern extends @swift_switch_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SwitchPattern" }

    /** Gets the child of this node. */
    final Pattern getChild() { swift_switch_pattern_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_switch_pattern_def(this, result) }
  }

  /** A class representing `switch_statement` nodes. */
  class SwitchStatement extends @swift_switch_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SwitchStatement" }

    /** Gets the node corresponding to the field `expr`. */
    final AstNode getExpr() { swift_switch_statement_def(this, result) }

    /** Gets the `i`th child of this node. */
    final SwitchEntry getChild(int i) { swift_switch_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_switch_statement_def(this, result) or swift_switch_statement_child(this, _, result)
    }
  }

  /** A class representing `ternary_expression` nodes. */
  class TernaryExpression extends @swift_ternary_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TernaryExpression" }

    /** Gets the node corresponding to the field `condition`. */
    final AstNode getCondition() { swift_ternary_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `if_false`. */
    final AstNode getIfFalse() { swift_ternary_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `if_true`. */
    final AstNode getIfTrue() { swift_ternary_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_ternary_expression_def(this, result, _, _) or
      swift_ternary_expression_def(this, _, result, _) or
      swift_ternary_expression_def(this, _, _, result)
    }
  }

  /** A class representing `throw_keyword` tokens. */
  class ThrowKeyword extends @swift_token_throw_keyword, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ThrowKeyword" }
  }

  /** A class representing `throws` tokens. */
  class Throws extends @swift_token_throws, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Throws" }
  }

  /** A class representing `throws_clause` nodes. */
  class ThrowsClause extends @swift_throws_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ThrowsClause" }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType() { swift_throws_clause_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_throws_clause_def(this, result) }
  }

  /** A class representing `try_expression` nodes. */
  class TryExpression extends @swift_try_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TryExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final AstNode getExpr() { swift_try_expression_def(this, result, _) }

    /** Gets the child of this node. */
    final TryOperator getChild() { swift_try_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_try_expression_def(this, result, _) or swift_try_expression_def(this, _, result)
    }
  }

  /** A class representing `try_operator` tokens. */
  class TryOperator extends @swift_token_try_operator, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TryOperator" }
  }

  /** A class representing `tuple_expression` nodes. */
  class TupleExpression extends @swift_tuple_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleExpression" }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_tuple_expression_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue(int i) { swift_tuple_expression_value(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_tuple_expression_name(this, _, result) or swift_tuple_expression_value(this, _, result)
    }
  }

  /** A class representing `tuple_type` nodes. */
  class TupleType extends @swift_tuple_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleType" }

    /** Gets the node corresponding to the field `element`. */
    final TupleTypeItem getElement(int i) { swift_tuple_type_element(this, i, result) }

    /** Gets the child of this node. */
    final TupleTypeItem getChild() { swift_tuple_type_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_tuple_type_element(this, _, result) or swift_tuple_type_child(this, result)
    }
  }

  /** A class representing `tuple_type_item` nodes. */
  class TupleTypeItem extends @swift_tuple_type_item, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TupleTypeItem" }

    /** Gets the node corresponding to the field `element`. */
    final AstNode getElement() { swift_tuple_type_item_element(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_tuple_type_item_name(this, i, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_tuple_type_item_type(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_tuple_type_item_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_tuple_type_item_element(this, result) or
      swift_tuple_type_item_name(this, _, result) or
      swift_tuple_type_item_type(this, _, result) or
      swift_tuple_type_item_child(this, _, result)
    }
  }

  /** A class representing `type_annotation` nodes. */
  class TypeAnnotation extends @swift_type_annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAnnotation" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_type_annotation_def(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType(int i) { swift_type_annotation_type(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_annotation_def(this, result) or swift_type_annotation_type(this, _, result)
    }
  }

  /** A class representing `type_arguments` nodes. */
  class TypeArguments extends @swift_type_arguments, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeArguments" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_type_arguments_name(this, i, result) }

    /** Gets the `i`th child of this node. */
    final TypeModifiers getChild(int i) { swift_type_arguments_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_arguments_name(this, _, result) or swift_type_arguments_child(this, _, result)
    }
  }

  /** A class representing `type_constraint` nodes. */
  class TypeConstraint extends @swift_type_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeConstraint" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_type_constraint_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_constraint_def(this, result) }
  }

  /** A class representing `type_constraints` nodes. */
  class TypeConstraints extends @swift_type_constraints, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeConstraints" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_type_constraints_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_constraints_child(this, _, result) }
  }

  /** A class representing `type_identifier` tokens. */
  class TypeIdentifier extends @swift_token_type_identifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeIdentifier" }
  }

  /** A class representing `type_modifiers` nodes. */
  class TypeModifiers extends @swift_type_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeModifiers" }

    /** Gets the `i`th child of this node. */
    final Attribute getChild(int i) { swift_type_modifiers_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_modifiers_child(this, _, result) }
  }

  /** A class representing `type_pack_expansion` nodes. */
  class TypePackExpansion extends @swift_type_pack_expansion, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypePackExpansion" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_type_pack_expansion_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_pack_expansion_def(this, result) }
  }

  /** A class representing `type_parameter` nodes. */
  class TypeParameter extends @swift_type_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameter" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_type_parameter_name(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_type_parameter_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_parameter_name(this, result) or swift_type_parameter_child(this, _, result)
    }
  }

  /** A class representing `type_parameter_modifiers` nodes. */
  class TypeParameterModifiers extends @swift_type_parameter_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameterModifiers" }

    /** Gets the `i`th child of this node. */
    final Attribute getChild(int i) { swift_type_parameter_modifiers_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_parameter_modifiers_child(this, _, result)
    }
  }

  /** A class representing `type_parameter_pack` nodes. */
  class TypeParameterPack extends @swift_type_parameter_pack, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameterPack" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_type_parameter_pack_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_parameter_pack_def(this, result) }
  }

  /** A class representing `type_parameters` nodes. */
  class TypeParameters extends @swift_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameters" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_type_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_parameters_child(this, _, result) }
  }

  /** A class representing `typealias_declaration` nodes. */
  class TypealiasDeclaration extends @swift_typealias_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypealiasDeclaration" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_typealias_declaration_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue(int i) { swift_typealias_declaration_value(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_typealias_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_typealias_declaration_name(this, _, result) or
      swift_typealias_declaration_value(this, _, result) or
      swift_typealias_declaration_child(this, _, result)
    }
  }

  /** A class representing `user_type` nodes. */
  class UserType extends @swift_user_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UserType" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_user_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_user_type_child(this, _, result) }
  }

  /** A class representing `value_argument` nodes. */
  class ValueArgument extends @swift_value_argument, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueArgument" }

    /** Gets the node corresponding to the field `name`. */
    final ValueArgumentLabel getName() { swift_value_argument_name(this, result) }

    /** Gets the node corresponding to the field `reference_specifier`. */
    final ValueArgumentLabel getReferenceSpecifier(int i) {
      swift_value_argument_reference_specifier(this, i, result)
    }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue() { swift_value_argument_value(this, result) }

    /** Gets the child of this node. */
    final TypeModifiers getChild() { swift_value_argument_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_value_argument_name(this, result) or
      swift_value_argument_reference_specifier(this, _, result) or
      swift_value_argument_value(this, result) or
      swift_value_argument_child(this, result)
    }
  }

  /** A class representing `value_argument_label` nodes. */
  class ValueArgumentLabel extends @swift_value_argument_label, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueArgumentLabel" }

    /** Gets the child of this node. */
    final SimpleIdentifier getChild() { swift_value_argument_label_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_argument_label_def(this, result) }
  }

  /** A class representing `value_arguments` nodes. */
  class ValueArguments extends @swift_value_arguments, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueArguments" }

    /** Gets the `i`th child of this node. */
    final ValueArgument getChild(int i) { swift_value_arguments_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_arguments_child(this, _, result) }
  }

  /** A class representing `value_binding_pattern` nodes. */
  class ValueBindingPattern extends @swift_value_binding_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueBindingPattern" }

    /** Gets the node corresponding to the field `mutability`. */
    final string getMutability() {
      exists(int value | swift_value_binding_pattern_def(this, value) |
        result = "let" and value = 0
        or
        result = "var" and value = 1
      )
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { none() }
  }

  /** A class representing `value_pack_expansion` nodes. */
  class ValuePackExpansion extends @swift_value_pack_expansion, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValuePackExpansion" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_value_pack_expansion_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_pack_expansion_child(this, result) }
  }

  /** A class representing `value_parameter_pack` nodes. */
  class ValueParameterPack extends @swift_value_parameter_pack, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueParameterPack" }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_value_parameter_pack_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_parameter_pack_child(this, result) }
  }

  /** A class representing `visibility_modifier` tokens. */
  class VisibilityModifier extends @swift_token_visibility_modifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VisibilityModifier" }
  }

  /** A class representing `where_clause` nodes. */
  class WhereClause extends @swift_where_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WhereClause" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_where_clause_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_where_clause_child(this, _, result) }
  }

  /** A class representing `where_keyword` tokens. */
  class WhereKeyword extends @swift_token_where_keyword, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WhereKeyword" }
  }

  /** A class representing `while_statement` nodes. */
  class WhileStatement extends @swift_while_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WhileStatement" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier(int i) {
      swift_while_statement_bound_identifier(this, i, result)
    }

    /** Gets the node corresponding to the field `condition`. */
    final AstNode getCondition(int i) { swift_while_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName(int i) { swift_while_statement_name(this, i, result) }

    /** Gets the child of this node. */
    final Statements getChild() { swift_while_statement_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_while_statement_bound_identifier(this, _, result) or
      swift_while_statement_condition(this, _, result) or
      swift_while_statement_name(this, _, result) or
      swift_while_statement_child(this, result)
    }
  }

  /** A class representing `wildcard_pattern` tokens. */
  class WildcardPattern extends @swift_token_wildcard_pattern, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WildcardPattern" }
  }

  /** A class representing `willset_clause` nodes. */
  class WillsetClause extends @swift_willset_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WillsetClause" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_willset_clause_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_willset_clause_child(this, _, result) }
  }

  /** A class representing `willset_didset_block` nodes. */
  class WillsetDidsetBlock extends @swift_willset_didset_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WillsetDidsetBlock" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_willset_didset_block_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_willset_didset_block_child(this, _, result) }
  }
}
