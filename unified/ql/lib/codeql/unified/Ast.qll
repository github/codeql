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

  /** A class representing `additive_expression` nodes. */
  class AdditiveExpression extends @swift_additive_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AdditiveExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final Expression getLhs() { swift_additive_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_additive_expression_def(this, _, value, _) |
        result = "+" and value = 0
        or
        result = "-" and value = 1
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final Expression getRhs() { swift_additive_expression_def(this, _, _, result) }

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
    final Expression getElement(int i) { swift_array_literal_element(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_array_literal_element(this, _, result) }
  }

  /** A class representing `array_type` nodes. */
  class ArrayType extends @swift_array_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArrayType" }

    /** Gets the node corresponding to the field `element`. */
    final Type getElement() { swift_array_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_array_type_def(this, result) }
  }

  /** A class representing `as_expression` nodes. */
  class AsExpression extends @swift_as_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_as_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `operator`. */
    final AsOperator getOperator() { swift_as_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final Type getType() { swift_as_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_as_expression_def(this, result, _, _) or
      swift_as_expression_def(this, _, result, _) or
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
    final Expression getResult() { swift_assignment_def(this, _, result, _) }

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
    final Type getDefaultValue() { swift_associatedtype_declaration_default_value(this, result) }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_associatedtype_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `must_inherit`. */
    final Type getMustInherit() { swift_associatedtype_declaration_must_inherit(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final TypeIdentifier getName() { swift_associatedtype_declaration_def(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_associatedtype_declaration_type_constraints(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_associatedtype_declaration_default_value(this, result) or
      swift_associatedtype_declaration_modifiers(this, result) or
      swift_associatedtype_declaration_must_inherit(this, result) or
      swift_associatedtype_declaration_def(this, result) or
      swift_associatedtype_declaration_type_constraints(this, result)
    }
  }

  /** A class representing `async_keyword` tokens. */
  class AsyncKeyword extends @swift_token_async_keyword, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsyncKeyword" }
  }

  /** A class representing `attribute` nodes. */
  class Attribute extends @swift_attribute, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Attribute" }

    /** Gets the node corresponding to the field `argument`. */
    final Expression getArgument(int i) { swift_attribute_argument(this, i, result) }

    /** Gets the node corresponding to the field `argument_name`. */
    final SimpleIdentifier getArgumentName(int i) { swift_attribute_argument_name(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final UserType getName() { swift_attribute_def(this, result) }

    /** Gets the node corresponding to the field `param_ref`. */
    final SimpleIdentifier getParamRef(int i) { swift_attribute_param_ref(this, i, result) }

    /** Gets the node corresponding to the field `platform`. */
    final SimpleIdentifier getPlatform(int i) { swift_attribute_platform(this, i, result) }

    /** Gets the node corresponding to the field `version`. */
    final IntegerLiteral getVersion(int i) { swift_attribute_version(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_attribute_argument(this, _, result) or
      swift_attribute_argument_name(this, _, result) or
      swift_attribute_def(this, result) or
      swift_attribute_param_ref(this, _, result) or
      swift_attribute_platform(this, _, result) or
      swift_attribute_version(this, _, result)
    }
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
    final Expression getExpr() { swift_await_expression_expr(this, result) }

    /** Gets the child of this node. */
    final Expression getChild() { swift_await_expression_child(this, result) }

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
    final Expression getLhs() { swift_bitwise_operation_def(this, result, _, _) }

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
    final Expression getRhs() { swift_bitwise_operation_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `function`. */
    final Expression getFunction() { swift_call_expression_function(this, result) }

    /** Gets the node corresponding to the field `suffix`. */
    final CallSuffix getSuffix() { swift_call_expression_suffix(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_call_expression_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_call_expression_function(this, result) or
      swift_call_expression_suffix(this, result) or
      swift_call_expression_child(this, _, result)
    }
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

    /** Gets the node corresponding to the field `item`. */
    final CaptureListItem getItem(int i) { swift_capture_list_item(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_capture_list_item(this, _, result) }
  }

  /** A class representing `capture_list_item` nodes. */
  class CaptureListItem extends @swift_capture_list_item, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaptureListItem" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_capture_list_item_def(this, result) }

    /** Gets the node corresponding to the field `ownership`. */
    final OwnershipModifier getOwnership() { swift_capture_list_item_ownership(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue() { swift_capture_list_item_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_capture_list_item_def(this, result) or
      swift_capture_list_item_ownership(this, result) or
      swift_capture_list_item_value(this, result)
    }
  }

  /** A class representing `catch_block` nodes. */
  class CatchBlock extends @swift_catch_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CatchBlock" }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_catch_block_body(this, result) }

    /** Gets the node corresponding to the field `error`. */
    final Pattern getError() { swift_catch_block_error(this, result) }

    /** Gets the node corresponding to the field `keyword`. */
    final CatchKeyword getKeyword() { swift_catch_block_def(this, result) }

    /** Gets the node corresponding to the field `where`. */
    final WhereClause getWhere() { swift_catch_block_where(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_catch_block_body(this, result) or
      swift_catch_block_error(this, result) or
      swift_catch_block_def(this, result) or
      swift_catch_block_where(this, result)
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

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_check_expression_def(this, value, _, _) |
        (result = "is" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `target`. */
    final Expression getTarget() { swift_check_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final Type getType() { swift_check_expression_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_check_expression_def(this, _, result, _) or
      swift_check_expression_def(this, _, _, result)
    }
  }

  /** A class representing `class_body` nodes. */
  class ClassBody extends @swift_class_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassBody" }

    /** Gets the node corresponding to the field `member`. */
    final TypeLevelDeclaration getMember(int i) { swift_class_body_member(this, i, result) }

    /** Gets the `i`th child of this node. */
    final MultilineComment getChild(int i) { swift_class_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_class_body_member(this, _, result) or swift_class_body_child(this, _, result)
    }
  }

  /** A class representing `class_declaration` nodes. */
  class ClassDeclaration extends @swift_class_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassDeclaration" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_class_declaration_attribute(this, i, result) }

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

    /** Gets the node corresponding to the field `modifiers`. */
    final AstNode getModifiers(int i) { swift_class_declaration_modifiers(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_class_declaration_def(this, _, _, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_class_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_class_declaration_type_parameters(this, result)
    }

    /** Gets the `i`th child of this node. */
    final InheritanceSpecifier getChild(int i) { swift_class_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_class_declaration_attribute(this, _, result) or
      swift_class_declaration_def(this, result, _, _) or
      swift_class_declaration_modifiers(this, _, result) or
      swift_class_declaration_def(this, _, _, result) or
      swift_class_declaration_type_constraints(this, result) or
      swift_class_declaration_type_parameters(this, result) or
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
    final Expression getLhs() { swift_comparison_expression_def(this, result, _, _) }

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
    final Expression getRhs() { swift_comparison_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_computed_getter_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_computed_getter_body(this, result) }

    /** Gets the node corresponding to the field `specifier`. */
    final GetterSpecifier getSpecifier() { swift_computed_getter_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_computed_getter_attribute(this, _, result) or
      swift_computed_getter_body(this, result) or
      swift_computed_getter_def(this, result)
    }
  }

  /** A class representing `computed_modify` nodes. */
  class ComputedModify extends @swift_computed_modify, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedModify" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_computed_modify_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_computed_modify_body(this, result) }

    /** Gets the node corresponding to the field `specifier`. */
    final ModifySpecifier getSpecifier() { swift_computed_modify_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_computed_modify_attribute(this, _, result) or
      swift_computed_modify_body(this, result) or
      swift_computed_modify_def(this, result)
    }
  }

  /** A class representing `computed_property` nodes. */
  class ComputedProperty extends @swift_computed_property, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedProperty" }

    /** Gets the node corresponding to the field `accessor`. */
    final AstNode getAccessor(int i) { swift_computed_property_accessor(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_computed_property_body(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_computed_property_accessor(this, _, result) or
      swift_computed_property_body(this, result)
    }
  }

  /** A class representing `computed_setter` nodes. */
  class ComputedSetter extends @swift_computed_setter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ComputedSetter" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_computed_setter_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_computed_setter_body(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final SimpleIdentifier getParameter() { swift_computed_setter_parameter(this, result) }

    /** Gets the node corresponding to the field `specifier`. */
    final SetterSpecifier getSpecifier() { swift_computed_setter_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_computed_setter_attribute(this, _, result) or
      swift_computed_setter_body(this, result) or
      swift_computed_setter_parameter(this, result) or
      swift_computed_setter_def(this, result)
    }
  }

  /** A class representing `conjunction_expression` nodes. */
  class ConjunctionExpression extends @swift_conjunction_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ConjunctionExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final Expression getLhs() { swift_conjunction_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_conjunction_expression_def(this, _, value, _) |
        (result = "&&" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final Expression getRhs() { swift_conjunction_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `suffix`. */
    final ConstructorSuffix getSuffix() { swift_constructor_expression_def(this, _, result) }

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

    /** Gets the node corresponding to the field `kind`. */
    final AstNode getKind() { swift_control_transfer_statement_kind(this, result) }

    /** Gets the node corresponding to the field `result`. */
    final Expression getResult() { swift_control_transfer_statement_result(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_control_transfer_statement_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_control_transfer_statement_kind(this, result) or
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

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_deinit_declaration_modifiers(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_deinit_declaration_def(this, result) or swift_deinit_declaration_modifiers(this, result)
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
    final Expression getKey(int i) { swift_dictionary_literal_key(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue(int i) { swift_dictionary_literal_value(this, i, result) }

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
    final Type getKey() { swift_dictionary_type_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Type getValue() { swift_dictionary_type_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_dictionary_type_def(this, result, _) or swift_dictionary_type_def(this, _, result)
    }
  }

  /** A class representing `didset_clause` nodes. */
  class DidsetClause extends @swift_didset_clause, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DidsetClause" }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_didset_clause_body(this, result) }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_didset_clause_modifiers(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final SimpleIdentifier getParameter() { swift_didset_clause_parameter(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_didset_clause_body(this, result) or
      swift_didset_clause_modifiers(this, result) or
      swift_didset_clause_parameter(this, result)
    }
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

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_directly_assignable_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_directly_assignable_expression_def(this, result)
    }
  }

  /** A class representing `disjunction_expression` nodes. */
  class DisjunctionExpression extends @swift_disjunction_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DisjunctionExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final Expression getLhs() { swift_disjunction_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_disjunction_expression_def(this, _, value, _) |
        (result = "||" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `rhs`. */
    final Expression getRhs() { swift_disjunction_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_do_statement_body(this, result) }

    /** Gets the node corresponding to the field `catch`. */
    final CatchBlock getCatch(int i) { swift_do_statement_catch(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_do_statement_body(this, result) or swift_do_statement_catch(this, _, result)
    }
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

    /** Gets the node corresponding to the field `member`. */
    final AstNode getMember(int i) { swift_enum_class_body_member(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_enum_class_body_member(this, _, result) }
  }

  /** A class representing `enum_entry` nodes. */
  class EnumEntry extends @swift_enum_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EnumEntry" }

    /** Gets the node corresponding to the field `data_contents`. */
    final EnumTypeParameters getDataContents(int i) {
      swift_enum_entry_data_contents(this, i, result)
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_enum_entry_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_enum_entry_name(this, i, result) }

    /** Gets the node corresponding to the field `raw_value`. */
    final Expression getRawValue(int i) { swift_enum_entry_raw_value(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_enum_entry_data_contents(this, _, result) or
      swift_enum_entry_modifiers(this, result) or
      swift_enum_entry_name(this, _, result) or
      swift_enum_entry_raw_value(this, _, result)
    }
  }

  /** A class representing `enum_type_parameters` nodes. */
  class EnumTypeParameters extends @swift_enum_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EnumTypeParameters" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_enum_type_parameters_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_enum_type_parameters_child(this, _, result) }
  }

  /** A class representing `equality_constraint` nodes. */
  class EqualityConstraint extends @swift_equality_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EqualityConstraint" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_equality_constraint_attribute(this, i, result) }

    /** Gets the node corresponding to the field `constrained_type`. */
    final AstNode getConstrainedType() { swift_equality_constraint_def(this, result, _) }

    /** Gets the node corresponding to the field `must_equal`. */
    final Type getMustEqual() { swift_equality_constraint_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_equality_constraint_attribute(this, _, result) or
      swift_equality_constraint_def(this, result, _) or
      swift_equality_constraint_def(this, _, result)
    }
  }

  /** A class representing `equality_expression` nodes. */
  class EqualityExpression extends @swift_equality_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EqualityExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final Expression getLhs() { swift_equality_expression_def(this, result, _, _) }

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
    final Expression getRhs() { swift_equality_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_existential_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_existential_type_def(this, result) }
  }

  class Expression extends @swift_expression, AstNode { }

  /** A class representing `external_macro_definition` nodes. */
  class ExternalMacroDefinition extends @swift_external_macro_definition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExternalMacroDefinition" }

    /** Gets the node corresponding to the field `arguments`. */
    final ValueArguments getArguments() { swift_external_macro_definition_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_external_macro_definition_def(this, result) }
  }

  /** A class representing `for_statement` nodes. */
  class ForStatement extends @swift_for_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ForStatement" }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_for_statement_body(this, result) }

    /** Gets the node corresponding to the field `collection`. */
    final Expression getCollection() { swift_for_statement_def(this, result, _) }

    /** Gets the node corresponding to the field `item`. */
    final Pattern getItem() { swift_for_statement_def(this, _, result) }

    /** Gets the node corresponding to the field `try`. */
    final TryOperator getTry() { swift_for_statement_try(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final TypeAnnotation getType() { swift_for_statement_type(this, result) }

    /** Gets the node corresponding to the field `where`. */
    final WhereClause getWhere() { swift_for_statement_where(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_for_statement_body(this, result) or
      swift_for_statement_def(this, result, _) or
      swift_for_statement_def(this, _, result) or
      swift_for_statement_try(this, result) or
      swift_for_statement_type(this, result) or
      swift_for_statement_where(this, result)
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

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_function_body_body(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_function_body_body(this, result) }
  }

  /** A class representing `function_declaration` nodes. */
  class FunctionDeclaration extends @swift_function_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FunctionDeclaration" }

    /** Gets the node corresponding to the field `async`. */
    final AsyncKeyword getAsync() { swift_function_declaration_async(this, result) }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_function_declaration_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_function_declaration_def(this, result, _) }

    /** Gets the node corresponding to the field `default_value`. */
    final Expression getDefaultValue(int i) {
      swift_function_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final AstNode getModifiers(int i) { swift_function_declaration_modifiers(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_function_declaration_def(this, _, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { swift_function_declaration_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType() { swift_function_declaration_return_type(this, result) }

    /** Gets the node corresponding to the field `throws`. */
    final AstNode getThrows() { swift_function_declaration_throws(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_function_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_function_declaration_type_parameters(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_function_declaration_async(this, result) or
      swift_function_declaration_attribute(this, _, result) or
      swift_function_declaration_def(this, result, _) or
      swift_function_declaration_default_value(this, _, result) or
      swift_function_declaration_modifiers(this, _, result) or
      swift_function_declaration_def(this, _, result) or
      swift_function_declaration_parameter(this, _, result) or
      swift_function_declaration_return_type(this, result) or
      swift_function_declaration_throws(this, result) or
      swift_function_declaration_type_constraints(this, result) or
      swift_function_declaration_type_parameters(this, result)
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

    /** Gets the node corresponding to the field `async`. */
    final AsyncKeyword getAsync() { swift_function_type_async(this, result) }

    /** Gets the node corresponding to the field `params`. */
    final UnannotatedType getParams() { swift_function_type_def(this, result, _) }

    /** Gets the node corresponding to the field `return_type`. */
    final Type getReturnType() { swift_function_type_def(this, _, result) }

    /** Gets the node corresponding to the field `throws`. */
    final AstNode getThrows() { swift_function_type_throws(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_function_type_async(this, result) or
      swift_function_type_def(this, result, _) or
      swift_function_type_def(this, _, result) or
      swift_function_type_throws(this, result)
    }
  }

  /** A class representing `getter_specifier` nodes. */
  class GetterSpecifier extends @swift_getter_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GetterSpecifier" }

    /** Gets the node corresponding to the field `effect`. */
    final AstNode getEffect(int i) { swift_getter_specifier_effect(this, i, result) }

    /** Gets the node corresponding to the field `mutation`. */
    final MutationModifier getMutation() { swift_getter_specifier_mutation(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_getter_specifier_effect(this, _, result) or
      swift_getter_specifier_mutation(this, result)
    }
  }

  class GlobalDeclaration extends @swift_global_declaration, AstNode { }

  /** A class representing `guard_statement` nodes. */
  class GuardStatement extends @swift_guard_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "GuardStatement" }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_guard_statement_body(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final IfCondition getCondition(int i) { swift_guard_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `else_keyword`. */
    final Else getElseKeyword() { swift_guard_statement_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_guard_statement_body(this, result) or
      swift_guard_statement_condition(this, _, result) or
      swift_guard_statement_def(this, result)
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

    /** Gets the node corresponding to the field `part`. */
    final SimpleIdentifier getPart(int i) { swift_identifier_part(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_identifier_part(this, _, result) }
  }

  /** A class representing `if_condition` nodes. */
  class IfCondition extends @swift_if_condition, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfCondition" }

    /** Gets the node corresponding to the field `kind`. */
    final AstNode getKind() { swift_if_condition_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_if_condition_def(this, result) }
  }

  /** A class representing `if_let_binding` nodes. */
  class IfLetBinding extends @swift_if_let_binding, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfLetBinding" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier() {
      swift_if_let_binding_bound_identifier(this, result)
    }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue() { swift_if_let_binding_value(this, result) }

    /** Gets the node corresponding to the field `where`. */
    final WhereClause getWhere() { swift_if_let_binding_where(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_if_let_binding_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_if_let_binding_bound_identifier(this, result) or
      swift_if_let_binding_value(this, result) or
      swift_if_let_binding_where(this, result) or
      swift_if_let_binding_child(this, _, result)
    }
  }

  /** A class representing `if_statement` nodes. */
  class IfStatement extends @swift_if_statement, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfStatement" }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody(int i) { swift_if_statement_body(this, i, result) }

    /** Gets the node corresponding to the field `condition`. */
    final IfCondition getCondition(int i) { swift_if_statement_condition(this, i, result) }

    /** Gets the node corresponding to the field `else_branch`. */
    final IfStatement getElseBranch() { swift_if_statement_else_branch(this, result) }

    /** Gets the node corresponding to the field `else_keyword`. */
    final Else getElseKeyword() { swift_if_statement_else_keyword(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_if_statement_body(this, _, result) or
      swift_if_statement_condition(this, _, result) or
      swift_if_statement_else_branch(this, result) or
      swift_if_statement_else_keyword(this, result)
    }
  }

  /** A class representing `implicitly_unwrapped_type` nodes. */
  class ImplicitlyUnwrappedType extends @swift_implicitly_unwrapped_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImplicitlyUnwrappedType" }

    /** Gets the node corresponding to the field `name`. */
    final Type getName() { swift_implicitly_unwrapped_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_implicitly_unwrapped_type_def(this, result) }
  }

  /** A class representing `import_declaration` nodes. */
  class ImportDeclaration extends @swift_import_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDeclaration" }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_import_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final Identifier getName() { swift_import_declaration_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_import_declaration_modifiers(this, result) or swift_import_declaration_def(this, result)
    }
  }

  /** A class representing `infix_expression` nodes. */
  class InfixExpression extends @swift_infix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InfixExpression" }

    /** Gets the node corresponding to the field `lhs`. */
    final Expression getLhs() { swift_infix_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final CustomOperator getOp() { swift_infix_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `rhs`. */
    final Expression getRhs() { swift_infix_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_inheritance_constraint_attribute(this, i, result) }

    /** Gets the node corresponding to the field `constrained_type`. */
    final AstNode getConstrainedType() { swift_inheritance_constraint_def(this, result, _) }

    /** Gets the node corresponding to the field `inherits_from`. */
    final AstNode getInheritsFrom() { swift_inheritance_constraint_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_inheritance_constraint_attribute(this, _, result) or
      swift_inheritance_constraint_def(this, result, _) or
      swift_inheritance_constraint_def(this, _, result)
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

    /** Gets the node corresponding to the field `async`. */
    final AsyncKeyword getAsync() { swift_init_declaration_async(this, result) }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_init_declaration_attribute(this, i, result) }

    /** Gets the node corresponding to the field `bang`. */
    final Bang getBang() { swift_init_declaration_bang(this, result) }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_init_declaration_body(this, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final Expression getDefaultValue(int i) {
      swift_init_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_init_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final string getName() {
      exists(int value | swift_init_declaration_def(this, value) | (result = "init" and value = 0))
    }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { swift_init_declaration_parameter(this, i, result) }

    /** Gets the node corresponding to the field `throws`. */
    final AstNode getThrows() { swift_init_declaration_throws(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_init_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_init_declaration_type_parameters(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_init_declaration_async(this, result) or
      swift_init_declaration_attribute(this, _, result) or
      swift_init_declaration_bang(this, result) or
      swift_init_declaration_body(this, result) or
      swift_init_declaration_default_value(this, _, result) or
      swift_init_declaration_modifiers(this, result) or
      swift_init_declaration_parameter(this, _, result) or
      swift_init_declaration_throws(this, result) or
      swift_init_declaration_type_constraints(this, result) or
      swift_init_declaration_type_parameters(this, result)
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

    /** Gets the node corresponding to the field `type_modifiers`. */
    final TypeModifiers getTypeModifiers() {
      swift_interpolated_expression_type_modifiers(this, result)
    }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue() { swift_interpolated_expression_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_interpolated_expression_name(this, result) or
      swift_interpolated_expression_reference_specifier(this, _, result) or
      swift_interpolated_expression_type_modifiers(this, result) or
      swift_interpolated_expression_value(this, result)
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

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_key_path_string_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_key_path_string_expression_def(this, result) }
  }

  /** A class representing `lambda_function_type` nodes. */
  class LambdaFunctionType extends @swift_lambda_function_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaFunctionType" }

    /** Gets the node corresponding to the field `async`. */
    final AsyncKeyword getAsync() { swift_lambda_function_type_async(this, result) }

    /** Gets the node corresponding to the field `params`. */
    final LambdaFunctionTypeParameters getParams() {
      swift_lambda_function_type_params(this, result)
    }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType() { swift_lambda_function_type_return_type(this, result) }

    /** Gets the node corresponding to the field `throws`. */
    final AstNode getThrows() { swift_lambda_function_type_throws(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_function_type_async(this, result) or
      swift_lambda_function_type_params(this, result) or
      swift_lambda_function_type_return_type(this, result) or
      swift_lambda_function_type_throws(this, result)
    }
  }

  /** A class representing `lambda_function_type_parameters` nodes. */
  class LambdaFunctionTypeParameters extends @swift_lambda_function_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaFunctionTypeParameters" }

    /** Gets the node corresponding to the field `parameter`. */
    final LambdaParameter getParameter(int i) {
      swift_lambda_function_type_parameters_parameter(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_function_type_parameters_parameter(this, _, result)
    }
  }

  /** A class representing `lambda_literal` nodes. */
  class LambdaLiteral extends @swift_lambda_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaLiteral" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_lambda_literal_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_lambda_literal_body(this, result) }

    /** Gets the node corresponding to the field `captures`. */
    final CaptureList getCaptures() { swift_lambda_literal_captures(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final LambdaFunctionType getType() { swift_lambda_literal_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_literal_attribute(this, _, result) or
      swift_lambda_literal_body(this, result) or
      swift_lambda_literal_captures(this, result) or
      swift_lambda_literal_type(this, result)
    }
  }

  /** A class representing `lambda_parameter` nodes. */
  class LambdaParameter extends @swift_lambda_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LambdaParameter" }

    /** Gets the node corresponding to the field `external_name`. */
    final SimpleIdentifier getExternalName() { swift_lambda_parameter_external_name(this, result) }

    /** Gets the node corresponding to the field `modifiers`. */
    final ParameterModifiers getModifiers() { swift_lambda_parameter_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_lambda_parameter_def(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType() { swift_lambda_parameter_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_lambda_parameter_external_name(this, result) or
      swift_lambda_parameter_modifiers(this, result) or
      swift_lambda_parameter_def(this, result) or
      swift_lambda_parameter_type(this, result)
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

  class LocalDeclaration extends @swift_local_declaration, AstNode { }

  /** A class representing `macro_declaration` nodes. */
  class MacroDeclaration extends @swift_macro_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MacroDeclaration" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_macro_declaration_attribute(this, i, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final Expression getDefaultValue(int i) {
      swift_macro_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `definition`. */
    final MacroDefinition getDefinition() { swift_macro_declaration_definition(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { swift_macro_declaration_parameter(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_macro_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_macro_declaration_attribute(this, _, result) or
      swift_macro_declaration_default_value(this, _, result) or
      swift_macro_declaration_definition(this, result) or
      swift_macro_declaration_parameter(this, _, result) or
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

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName() { swift_macro_invocation_def(this, result, _) }

    /** Gets the node corresponding to the field `suffix`. */
    final CallSuffix getSuffix() { swift_macro_invocation_def(this, _, result) }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_macro_invocation_type_parameters(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_macro_invocation_def(this, result, _) or
      swift_macro_invocation_def(this, _, result) or
      swift_macro_invocation_type_parameters(this, result)
    }
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

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_metatype_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_metatype_def(this, result) }
  }

  /** A class representing `modifiers` nodes. */
  class Modifiers extends @swift_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Modifiers" }

    /** Gets the node corresponding to the field `modifier`. */
    final AstNode getModifier(int i) { swift_modifiers_modifier(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_modifiers_modifier(this, _, result) }
  }

  /** A class representing `modify_specifier` nodes. */
  class ModifySpecifier extends @swift_modify_specifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModifySpecifier" }

    /** Gets the node corresponding to the field `mutation`. */
    final MutationModifier getMutation() { swift_modify_specifier_mutation(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_modify_specifier_mutation(this, result) }
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
    final Expression getLhs() { swift_multiplicative_expression_def(this, result, _, _) }

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
    final Expression getRhs() { swift_multiplicative_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `suffix`. */
    final NavigationSuffix getSuffix() { swift_navigation_expression_def(this, result) }

    /** Gets the node corresponding to the field `target`. */
    final AstNode getTarget(int i) { swift_navigation_expression_target(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
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

  /** A class representing `nested_type_identifier` nodes. */
  class NestedTypeIdentifier extends @swift_nested_type_identifier, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NestedTypeIdentifier" }

    /** Gets the node corresponding to the field `base`. */
    final UnannotatedType getBase() { swift_nested_type_identifier_def(this, result) }

    /** Gets the node corresponding to the field `member`. */
    final SimpleIdentifier getMember(int i) { swift_nested_type_identifier_member(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_nested_type_identifier_def(this, result) or
      swift_nested_type_identifier_member(this, _, result)
    }
  }

  /** A class representing `nil_coalescing_expression` nodes. */
  class NilCoalescingExpression extends @swift_nil_coalescing_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "NilCoalescingExpression" }

    /** Gets the node corresponding to the field `if_nil`. */
    final Expression getIfNil() { swift_nil_coalescing_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue() { swift_nil_coalescing_expression_def(this, _, result) }

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

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_opaque_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_opaque_type_def(this, result) }
  }

  /** A class representing `open_end_range_expression` nodes. */
  class OpenEndRangeExpression extends @swift_open_end_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OpenEndRangeExpression" }

    /** Gets the node corresponding to the field `start`. */
    final Expression getStart() { swift_open_end_range_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_open_end_range_expression_def(this, result) }
  }

  /** A class representing `open_start_range_expression` nodes. */
  class OpenStartRangeExpression extends @swift_open_start_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OpenStartRangeExpression" }

    /** Gets the node corresponding to the field `end`. */
    final Expression getEnd() { swift_open_start_range_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_open_start_range_expression_def(this, result)
    }
  }

  /** A class representing `operator_declaration` nodes. */
  class OperatorDeclaration extends @swift_operator_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OperatorDeclaration" }

    /** Gets the node corresponding to the field `body`. */
    final DeprecatedOperatorDeclarationBody getBody() {
      swift_operator_declaration_body(this, result)
    }

    /** Gets the node corresponding to the field `kind`. */
    final string getKind() {
      exists(int value | swift_operator_declaration_def(this, value, _) |
        result = "infix" and value = 0
        or
        result = "postfix" and value = 1
        or
        result = "prefix" and value = 2
      )
    }

    /** Gets the node corresponding to the field `name`. */
    final ReferenceableOperator getName() { swift_operator_declaration_def(this, _, result) }

    /** Gets the node corresponding to the field `precedence_group`. */
    final SimpleIdentifier getPrecedenceGroup() {
      swift_operator_declaration_precedence_group(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_operator_declaration_body(this, result) or
      swift_operator_declaration_def(this, _, result) or
      swift_operator_declaration_precedence_group(this, result)
    }
  }

  /** A class representing `optional_chain_marker` nodes. */
  class OptionalChainMarker extends @swift_optional_chain_marker, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OptionalChainMarker" }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_optional_chain_marker_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_optional_chain_marker_def(this, result) }
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

    /** Gets the node corresponding to the field `modifiers`. */
    final ParameterModifiers getModifiers() { swift_parameter_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName() { swift_parameter_def(this, result, _) }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType() { swift_parameter_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_parameter_external_name(this, result) or
      swift_parameter_modifiers(this, result) or
      swift_parameter_def(this, result, _) or
      swift_parameter_def(this, _, result)
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

    /** Gets the node corresponding to the field `modifier`. */
    final ParameterModifier getModifier(int i) {
      swift_parameter_modifiers_modifier(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_parameter_modifiers_modifier(this, _, result)
    }
  }

  /** A class representing `pattern` nodes. */
  class Pattern extends @swift_pattern, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pattern" }

    /** Gets the node corresponding to the field `bound_identifier`. */
    final SimpleIdentifier getBoundIdentifier() { swift_pattern_bound_identifier(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_pattern_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_pattern_bound_identifier(this, result) or swift_pattern_child(this, _, result)
    }
  }

  /** A class representing `playground_literal` nodes. */
  class PlaygroundLiteral extends @swift_playground_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PlaygroundLiteral" }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName(int i) { swift_playground_literal_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue(int i) { swift_playground_literal_value(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_playground_literal_name(this, _, result) or
      swift_playground_literal_value(this, _, result)
    }
  }

  /** A class representing `postfix_expression` nodes. */
  class PostfixExpression extends @swift_postfix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PostfixExpression" }

    /** Gets the node corresponding to the field `operation`. */
    final AstNode getOperation() { swift_postfix_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final Expression getTarget() { swift_postfix_expression_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_postfix_expression_def(this, result, _) or swift_postfix_expression_def(this, _, result)
    }
  }

  /** A class representing `precedence_group_attribute` nodes. */
  class PrecedenceGroupAttribute extends @swift_precedence_group_attribute, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupAttribute" }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName() { swift_precedence_group_attribute_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final AstNode getValue() { swift_precedence_group_attribute_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_attribute_def(this, result, _) or
      swift_precedence_group_attribute_def(this, _, result)
    }
  }

  /** A class representing `precedence_group_attributes` nodes. */
  class PrecedenceGroupAttributes extends @swift_precedence_group_attributes, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupAttributes" }

    /** Gets the node corresponding to the field `attribute`. */
    final PrecedenceGroupAttribute getAttribute(int i) {
      swift_precedence_group_attributes_attribute(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_attributes_attribute(this, _, result)
    }
  }

  /** A class representing `precedence_group_declaration` nodes. */
  class PrecedenceGroupDeclaration extends @swift_precedence_group_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrecedenceGroupDeclaration" }

    /** Gets the node corresponding to the field `attributes`. */
    final PrecedenceGroupAttributes getAttributes() {
      swift_precedence_group_declaration_attributes(this, result)
    }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName() { swift_precedence_group_declaration_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_precedence_group_declaration_attributes(this, result) or
      swift_precedence_group_declaration_def(this, result)
    }
  }

  /** A class representing `prefix_expression` nodes. */
  class PrefixExpression extends @swift_prefix_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixExpression" }

    /** Gets the node corresponding to the field `operation`. */
    final AstNode getOperation() { swift_prefix_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `target`. */
    final Expression getTarget() { swift_prefix_expression_def(this, _, result) }

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

    /** Gets the node corresponding to the field `modifiers`. */
    final AstNode getModifiers(int i) { swift_property_declaration_modifiers(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final Pattern getName(int i) { swift_property_declaration_name(this, i, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue(int i) { swift_property_declaration_value(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { swift_property_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_property_declaration_computed_value(this, _, result) or
      swift_property_declaration_modifiers(this, _, result) or
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

    /** Gets the node corresponding to the field `member`. */
    final ProtocolMemberDeclaration getMember(int i) { swift_protocol_body_member(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_protocol_body_member(this, _, result) }
  }

  /** A class representing `protocol_composition_type` nodes. */
  class ProtocolCompositionType extends @swift_protocol_composition_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolCompositionType" }

    /** Gets the node corresponding to the field `type`. */
    final UnannotatedType getType(int i) { swift_protocol_composition_type_type(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_composition_type_type(this, _, result)
    }
  }

  /** A class representing `protocol_declaration` nodes. */
  class ProtocolDeclaration extends @swift_protocol_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolDeclaration" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_protocol_declaration_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final ProtocolBody getBody() { swift_protocol_declaration_def(this, result, _, _) }

    /** Gets the node corresponding to the field `declaration_kind`. */
    final string getDeclarationKind() {
      exists(int value | swift_protocol_declaration_def(this, _, value, _) |
        (result = "protocol" and value = 0)
      )
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_protocol_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final TypeIdentifier getName() { swift_protocol_declaration_def(this, _, _, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_protocol_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_protocol_declaration_type_parameters(this, result)
    }

    /** Gets the `i`th child of this node. */
    final InheritanceSpecifier getChild(int i) { swift_protocol_declaration_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_declaration_attribute(this, _, result) or
      swift_protocol_declaration_def(this, result, _, _) or
      swift_protocol_declaration_modifiers(this, result) or
      swift_protocol_declaration_def(this, _, _, result) or
      swift_protocol_declaration_type_constraints(this, result) or
      swift_protocol_declaration_type_parameters(this, result) or
      swift_protocol_declaration_child(this, _, result)
    }
  }

  /** A class representing `protocol_function_declaration` nodes. */
  class ProtocolFunctionDeclaration extends @swift_protocol_function_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolFunctionDeclaration" }

    /** Gets the node corresponding to the field `async`. */
    final AsyncKeyword getAsync() { swift_protocol_function_declaration_async(this, result) }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) {
      swift_protocol_function_declaration_attribute(this, i, result)
    }

    /** Gets the node corresponding to the field `body`. */
    final FunctionBody getBody() { swift_protocol_function_declaration_body(this, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final Expression getDefaultValue(int i) {
      swift_protocol_function_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_protocol_function_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_protocol_function_declaration_def(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) {
      swift_protocol_function_declaration_parameter(this, i, result)
    }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType() { swift_protocol_function_declaration_return_type(this, result) }

    /** Gets the node corresponding to the field `throws`. */
    final AstNode getThrows() { swift_protocol_function_declaration_throws(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_protocol_function_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_protocol_function_declaration_type_parameters(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_function_declaration_async(this, result) or
      swift_protocol_function_declaration_attribute(this, _, result) or
      swift_protocol_function_declaration_body(this, result) or
      swift_protocol_function_declaration_default_value(this, _, result) or
      swift_protocol_function_declaration_modifiers(this, result) or
      swift_protocol_function_declaration_def(this, result) or
      swift_protocol_function_declaration_parameter(this, _, result) or
      swift_protocol_function_declaration_return_type(this, result) or
      swift_protocol_function_declaration_throws(this, result) or
      swift_protocol_function_declaration_type_constraints(this, result) or
      swift_protocol_function_declaration_type_parameters(this, result)
    }
  }

  class ProtocolMemberDeclaration extends @swift_protocol_member_declaration, AstNode { }

  /** A class representing `protocol_property_declaration` nodes. */
  class ProtocolPropertyDeclaration extends @swift_protocol_property_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolPropertyDeclaration" }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_protocol_property_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final Pattern getName() { swift_protocol_property_declaration_def(this, result, _) }

    /** Gets the node corresponding to the field `requirements`. */
    final ProtocolPropertyRequirements getRequirements() {
      swift_protocol_property_declaration_def(this, _, result)
    }

    /** Gets the node corresponding to the field `type`. */
    final TypeAnnotation getType() { swift_protocol_property_declaration_type(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_protocol_property_declaration_type_constraints(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_property_declaration_modifiers(this, result) or
      swift_protocol_property_declaration_def(this, result, _) or
      swift_protocol_property_declaration_def(this, _, result) or
      swift_protocol_property_declaration_type(this, result) or
      swift_protocol_property_declaration_type_constraints(this, result)
    }
  }

  /** A class representing `protocol_property_requirements` nodes. */
  class ProtocolPropertyRequirements extends @swift_protocol_property_requirements, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ProtocolPropertyRequirements" }

    /** Gets the node corresponding to the field `accessor`. */
    final AstNode getAccessor(int i) {
      swift_protocol_property_requirements_accessor(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_protocol_property_requirements_accessor(this, _, result)
    }
  }

  /** A class representing `range_expression` nodes. */
  class RangeExpression extends @swift_range_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "RangeExpression" }

    /** Gets the node corresponding to the field `end`. */
    final Expression getEnd() { swift_range_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `op`. */
    final string getOp() {
      exists(int value | swift_range_expression_def(this, _, value, _) |
        result = "..." and value = 0
        or
        result = "..<" and value = 1
      )
    }

    /** Gets the node corresponding to the field `start`. */
    final Expression getStart() { swift_range_expression_def(this, _, _, result) }

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

    /** Gets the node corresponding to the field `start`. */
    final RawStrInterpolationStart getStart() { swift_raw_str_interpolation_def(this, result) }

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

    /** Gets the node corresponding to the field `continuing`. */
    final RawStrContinuingIndicator getContinuing(int i) {
      swift_raw_string_literal_continuing(this, i, result)
    }

    /** Gets the node corresponding to the field `interpolation`. */
    final RawStrInterpolation getInterpolation(int i) {
      swift_raw_string_literal_interpolation(this, i, result)
    }

    /** Gets the node corresponding to the field `text`. */
    final AstNode getText(int i) { swift_raw_string_literal_text(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_raw_string_literal_continuing(this, _, result) or
      swift_raw_string_literal_interpolation(this, _, result) or
      swift_raw_string_literal_text(this, _, result)
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

    /** Gets the node corresponding to the field `operator`. */
    final AstNode getOperator() { swift_referenceable_operator_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_referenceable_operator_def(this, result) }
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

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_repeat_while_statement_body(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final IfCondition getCondition(int i) {
      swift_repeat_while_statement_condition(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_repeat_while_statement_body(this, result) or
      swift_repeat_while_statement_condition(this, _, result)
    }
  }

  /** A class representing `selector_expression` nodes. */
  class SelectorExpression extends @swift_selector_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SelectorExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_selector_expression_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_selector_expression_def(this, result) }
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

    /** Gets the node corresponding to the field `mutation`. */
    final MutationModifier getMutation() { swift_setter_specifier_mutation(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_setter_specifier_mutation(this, result) }
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

    /** Gets the node corresponding to the field `shebang`. */
    final ShebangLine getShebang() { swift_source_file_shebang(this, result) }

    /** Gets the node corresponding to the field `statement`. */
    final AstNode getStatement(int i) { swift_source_file_statement(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_source_file_shebang(this, result) or swift_source_file_statement(this, _, result)
    }
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

    /** Gets the node corresponding to the field `statement`. */
    final AstNode getStatement(int i) { swift_statements_statement(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_statements_statement(this, _, result) }
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

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_subscript_declaration_attribute(this, i, result) }

    /** Gets the node corresponding to the field `body`. */
    final ComputedProperty getBody() { swift_subscript_declaration_def(this, result) }

    /** Gets the node corresponding to the field `default_value`. */
    final Expression getDefaultValue(int i) {
      swift_subscript_declaration_default_value(this, i, result)
    }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_subscript_declaration_modifiers(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final Parameter getParameter(int i) { swift_subscript_declaration_parameter(this, i, result) }

    /** Gets the node corresponding to the field `return_type`. */
    final AstNode getReturnType() { swift_subscript_declaration_return_type(this, result) }

    /** Gets the node corresponding to the field `type_constraints`. */
    final TypeConstraints getTypeConstraints() {
      swift_subscript_declaration_type_constraints(this, result)
    }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_subscript_declaration_type_parameters(this, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_subscript_declaration_attribute(this, _, result) or
      swift_subscript_declaration_def(this, result) or
      swift_subscript_declaration_default_value(this, _, result) or
      swift_subscript_declaration_modifiers(this, result) or
      swift_subscript_declaration_parameter(this, _, result) or
      swift_subscript_declaration_return_type(this, result) or
      swift_subscript_declaration_type_constraints(this, result) or
      swift_subscript_declaration_type_parameters(this, result)
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

    /** Gets the node corresponding to the field `entry`. */
    final SwitchEntry getEntry(int i) { swift_switch_statement_entry(this, i, result) }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_switch_statement_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_switch_statement_entry(this, _, result) or swift_switch_statement_def(this, result)
    }
  }

  /** A class representing `ternary_expression` nodes. */
  class TernaryExpression extends @swift_ternary_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TernaryExpression" }

    /** Gets the node corresponding to the field `condition`. */
    final Expression getCondition() { swift_ternary_expression_def(this, result, _, _) }

    /** Gets the node corresponding to the field `if_false`. */
    final Expression getIfFalse() { swift_ternary_expression_def(this, _, result, _) }

    /** Gets the node corresponding to the field `if_true`. */
    final Expression getIfTrue() { swift_ternary_expression_def(this, _, _, result) }

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
    final UnannotatedType getType() { swift_throws_clause_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_throws_clause_def(this, result) }
  }

  /** A class representing `try_expression` nodes. */
  class TryExpression extends @swift_try_expression, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TryExpression" }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_try_expression_def(this, result, _) }

    /** Gets the node corresponding to the field `operator`. */
    final TryOperator getOperator() { swift_try_expression_def(this, _, result) }

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
    final Expression getValue(int i) { swift_tuple_expression_value(this, i, result) }

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

    /** Gets the node corresponding to the field `modifiers`. */
    final ParameterModifiers getModifiers() { swift_tuple_type_item_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final SimpleIdentifier getName() { swift_tuple_type_item_name(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final Type getType() { swift_tuple_type_item_type(this, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { swift_tuple_type_item_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_tuple_type_item_modifiers(this, result) or
      swift_tuple_type_item_name(this, result) or
      swift_tuple_type_item_type(this, result) or
      swift_tuple_type_item_child(this, result)
    }
  }

  /** A class representing `type` nodes. */
  class Type extends @swift_type__, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Type" }

    /** Gets the node corresponding to the field `modifiers`. */
    final TypeModifiers getModifiers() { swift_type_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_modifiers(this, result) or swift_type_def(this, result)
    }
  }

  /** A class representing `type_annotation` nodes. */
  class TypeAnnotation extends @swift_type_annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAnnotation" }

    /** Gets the node corresponding to the field `type`. */
    final AstNode getType() { swift_type_annotation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_annotation_def(this, result) }
  }

  /** A class representing `type_arguments` nodes. */
  class TypeArguments extends @swift_type_arguments, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeArguments" }

    /** Gets the node corresponding to the field `argument`. */
    final Type getArgument(int i) { swift_type_arguments_argument(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_arguments_argument(this, _, result) }
  }

  /** A class representing `type_constraint` nodes. */
  class TypeConstraint extends @swift_type_constraint, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeConstraint" }

    /** Gets the node corresponding to the field `constraint`. */
    final AstNode getConstraint() { swift_type_constraint_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_constraint_def(this, result) }
  }

  /** A class representing `type_constraints` nodes. */
  class TypeConstraints extends @swift_type_constraints, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeConstraints" }

    /** Gets the node corresponding to the field `constraint`. */
    final TypeConstraint getConstraint(int i) { swift_type_constraints_constraint(this, i, result) }

    /** Gets the node corresponding to the field `keyword`. */
    final WhereKeyword getKeyword() { swift_type_constraints_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_constraints_constraint(this, _, result) or swift_type_constraints_def(this, result)
    }
  }

  /** A class representing `type_identifier` tokens. */
  class TypeIdentifier extends @swift_token_type_identifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeIdentifier" }
  }

  class TypeLevelDeclaration extends @swift_type_level_declaration, AstNode { }

  /** A class representing `type_modifiers` nodes. */
  class TypeModifiers extends @swift_type_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeModifiers" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) { swift_type_modifiers_attribute(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_modifiers_attribute(this, _, result) }
  }

  /** A class representing `type_pack_expansion` nodes. */
  class TypePackExpansion extends @swift_type_pack_expansion, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypePackExpansion" }

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_type_pack_expansion_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_pack_expansion_def(this, result) }
  }

  /** A class representing `type_parameter` nodes. */
  class TypeParameter extends @swift_type_parameter, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameter" }

    /** Gets the node corresponding to the field `modifiers`. */
    final TypeParameterModifiers getModifiers() { swift_type_parameter_modifiers(this, result) }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { swift_type_parameter_def(this, result) }

    /** Gets the node corresponding to the field `type`. */
    final Type getType() { swift_type_parameter_type(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_parameter_modifiers(this, result) or
      swift_type_parameter_def(this, result) or
      swift_type_parameter_type(this, result)
    }
  }

  /** A class representing `type_parameter_modifiers` nodes. */
  class TypeParameterModifiers extends @swift_type_parameter_modifiers, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameterModifiers" }

    /** Gets the node corresponding to the field `attribute`. */
    final Attribute getAttribute(int i) {
      swift_type_parameter_modifiers_attribute(this, i, result)
    }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_parameter_modifiers_attribute(this, _, result)
    }
  }

  /** A class representing `type_parameter_pack` nodes. */
  class TypeParameterPack extends @swift_type_parameter_pack, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameterPack" }

    /** Gets the node corresponding to the field `name`. */
    final UnannotatedType getName() { swift_type_parameter_pack_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_type_parameter_pack_def(this, result) }
  }

  /** A class representing `type_parameters` nodes. */
  class TypeParameters extends @swift_type_parameters, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeParameters" }

    /** Gets the node corresponding to the field `constraints`. */
    final TypeConstraints getConstraints() { swift_type_parameters_constraints(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final TypeParameter getParameter(int i) { swift_type_parameters_parameter(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_type_parameters_constraints(this, result) or
      swift_type_parameters_parameter(this, _, result)
    }
  }

  /** A class representing `typealias_declaration` nodes. */
  class TypealiasDeclaration extends @swift_typealias_declaration, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypealiasDeclaration" }

    /** Gets the node corresponding to the field `modifiers`. */
    final AstNode getModifiers(int i) { swift_typealias_declaration_modifiers(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final TypeIdentifier getName() { swift_typealias_declaration_def(this, result, _) }

    /** Gets the node corresponding to the field `type_parameters`. */
    final TypeParameters getTypeParameters() {
      swift_typealias_declaration_type_parameters(this, result)
    }

    /** Gets the node corresponding to the field `value`. */
    final Type getValue() { swift_typealias_declaration_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_typealias_declaration_modifiers(this, _, result) or
      swift_typealias_declaration_def(this, result, _) or
      swift_typealias_declaration_type_parameters(this, result) or
      swift_typealias_declaration_def(this, _, result)
    }
  }

  class UnannotatedType extends @swift_unannotated_type, AstNode { }

  /** A class representing `user_type` nodes. */
  class UserType extends @swift_user_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UserType" }

    /** Gets the node corresponding to the field `part`. */
    final AstNode getPart(int i) { swift_user_type_part(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_user_type_part(this, _, result) }
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

    /** Gets the node corresponding to the field `type_modifiers`. */
    final TypeModifiers getTypeModifiers() { swift_value_argument_type_modifiers(this, result) }

    /** Gets the node corresponding to the field `value`. */
    final Expression getValue() { swift_value_argument_value(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_value_argument_name(this, result) or
      swift_value_argument_reference_specifier(this, _, result) or
      swift_value_argument_type_modifiers(this, result) or
      swift_value_argument_value(this, result)
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

    /** Gets the node corresponding to the field `argument`. */
    final ValueArgument getArgument(int i) { swift_value_arguments_argument(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_arguments_argument(this, _, result) }
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

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_value_pack_expansion_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_pack_expansion_def(this, result) }
  }

  /** A class representing `value_parameter_pack` nodes. */
  class ValueParameterPack extends @swift_value_parameter_pack, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ValueParameterPack" }

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_value_parameter_pack_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { swift_value_parameter_pack_def(this, result) }
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

    /** Gets the node corresponding to the field `expr`. */
    final Expression getExpr() { swift_where_clause_def(this, result, _) }

    /** Gets the node corresponding to the field `keyword`. */
    final WhereKeyword getKeyword() { swift_where_clause_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_where_clause_def(this, result, _) or swift_where_clause_def(this, _, result)
    }
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

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_while_statement_body(this, result) }

    /** Gets the node corresponding to the field `condition`. */
    final IfCondition getCondition(int i) { swift_while_statement_condition(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_while_statement_body(this, result) or swift_while_statement_condition(this, _, result)
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

    /** Gets the node corresponding to the field `body`. */
    final Statements getBody() { swift_willset_clause_body(this, result) }

    /** Gets the node corresponding to the field `modifiers`. */
    final Modifiers getModifiers() { swift_willset_clause_modifiers(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final SimpleIdentifier getParameter() { swift_willset_clause_parameter(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_willset_clause_body(this, result) or
      swift_willset_clause_modifiers(this, result) or
      swift_willset_clause_parameter(this, result)
    }
  }

  /** A class representing `willset_didset_block` nodes. */
  class WillsetDidsetBlock extends @swift_willset_didset_block, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "WillsetDidsetBlock" }

    /** Gets the node corresponding to the field `didset`. */
    final DidsetClause getDidset() { swift_willset_didset_block_didset(this, result) }

    /** Gets the node corresponding to the field `willset`. */
    final WillsetClause getWillset() { swift_willset_didset_block_willset(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      swift_willset_didset_block_didset(this, result) or
      swift_willset_didset_block_willset(this, result)
    }
  }
}
