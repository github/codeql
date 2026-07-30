/**
 * CodeQL library for QL
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
module QL {
  private import QL as F

  /** The base class for all AST nodes */
  class AstNode extends @ql_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { ql_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { ql_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { ql_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @ql_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { ql_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @ql_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@ql_ast_node node) {
    exists(@location_default loc | ql_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @ql_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@ql_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `add_expr` nodes. */
  class AddExpr extends @ql_add_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AddExpr" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_add_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_add_expr_def(this, _, result, _) }

    /** Gets the child of this node. */
    final F::Addop getChild() { ql_add_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_add_expr_def(this, result, _, _) or
      ql_add_expr_def(this, _, result, _) or
      ql_add_expr_def(this, _, _, result)
    }
  }

  /** A class representing `addop` tokens. */
  class Addop extends @ql_token_addop, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Addop" }
  }

  /** A class representing `aggId` tokens. */
  class AggId extends @ql_token_agg_id, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AggId" }
  }

  /** A class representing `aggregate` nodes. */
  class Aggregate extends @ql_aggregate, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Aggregate" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_aggregate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_aggregate_child(this, _, result) }
  }

  /** A class representing `annotArg` nodes. */
  class AnnotArg extends @ql_annot_arg, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotArg" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_annot_arg_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_annot_arg_def(this, result) }
  }

  /** A class representing `annotName` tokens. */
  class AnnotName extends @ql_token_annot_name, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  class Annotation extends @ql_annotation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Annotation" }

    /** Gets the node corresponding to the field `args`. */
    final F::AstNode getArgs(int i) { ql_annotation_args(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::AnnotName getName() { ql_annotation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_annotation_args(this, _, result) or ql_annotation_def(this, result)
    }
  }

  /** A class representing `aritylessPredicateExpr` nodes. */
  class AritylessPredicateExpr extends @ql_arityless_predicate_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AritylessPredicateExpr" }

    /** Gets the node corresponding to the field `name`. */
    final F::LiteralId getName() { ql_arityless_predicate_expr_def(this, result) }

    /** Gets the node corresponding to the field `qualifier`. */
    final F::ModuleExpr getQualifier() { ql_arityless_predicate_expr_qualifier(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_arityless_predicate_expr_def(this, result) or
      ql_arityless_predicate_expr_qualifier(this, result)
    }
  }

  /** A class representing `asExpr` nodes. */
  class AsExpr extends @ql_as_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExpr" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_as_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_as_expr_child(this, _, result) }
  }

  /** A class representing `asExprs` nodes. */
  class AsExprs extends @ql_as_exprs, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExprs" }

    /** Gets the `i`th child of this node. */
    final F::AsExpr getChild(int i) { ql_as_exprs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_as_exprs_child(this, _, result) }
  }

  /** A class representing `block_comment` tokens. */
  class BlockComment extends @ql_token_block_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `body` nodes. */
  class Body extends @ql_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Body" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_body_def(this, result) }
  }

  /** A class representing `bool` nodes. */
  class Bool extends @ql_bool, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Bool" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_bool_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_bool_def(this, result) }
  }

  /** A class representing `call_body` nodes. */
  class CallBody extends @ql_call_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallBody" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_call_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_call_body_child(this, _, result) }
  }

  /** A class representing `call_or_unqual_agg_expr` nodes. */
  class CallOrUnqualAggExpr extends @ql_call_or_unqual_agg_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallOrUnqualAggExpr" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_call_or_unqual_agg_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_call_or_unqual_agg_expr_child(this, _, result)
    }
  }

  /** A class representing `charpred` nodes. */
  class Charpred extends @ql_charpred, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Charpred" }

    /** Gets the node corresponding to the field `body`. */
    final F::AstNode getBody() { ql_charpred_def(this, result, _) }

    /** Gets the child of this node. */
    final F::ClassName getChild() { ql_charpred_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_charpred_def(this, result, _) or ql_charpred_def(this, _, result)
    }
  }

  /** A class representing `classMember` nodes. */
  class ClassMember extends @ql_class_member, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassMember" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_class_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_class_member_child(this, _, result) }
  }

  /** A class representing `className` tokens. */
  class ClassName extends @ql_token_class_name, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassName" }
  }

  /** A class representing `classlessPredicate` nodes. */
  class ClasslessPredicate extends @ql_classless_predicate, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

    /** Gets the node corresponding to the field `name`. */
    final F::PredicateName getName() { ql_classless_predicate_def(this, result, _) }

    /** Gets the node corresponding to the field `returnType`. */
    final F::AstNode getReturnType() { ql_classless_predicate_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_classless_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_classless_predicate_def(this, result, _) or
      ql_classless_predicate_def(this, _, result) or
      ql_classless_predicate_child(this, _, result)
    }
  }

  /** A class representing `closure` tokens. */
  class Closure extends @ql_token_closure, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Closure" }
  }

  /** A class representing `comp_term` nodes. */
  class CompTerm extends @ql_comp_term, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CompTerm" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_comp_term_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_comp_term_def(this, _, result, _) }

    /** Gets the child of this node. */
    final F::Compop getChild() { ql_comp_term_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_comp_term_def(this, result, _, _) or
      ql_comp_term_def(this, _, result, _) or
      ql_comp_term_def(this, _, _, result)
    }
  }

  /** A class representing `compop` tokens. */
  class Compop extends @ql_token_compop, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Compop" }
  }

  /** A class representing `conjunction` nodes. */
  class Conjunction extends @ql_conjunction, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Conjunction" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_conjunction_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_conjunction_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_conjunction_def(this, result, _) or ql_conjunction_def(this, _, result)
    }
  }

  /** A class representing `dataclass` nodes. */
  class Dataclass extends @ql_dataclass, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dataclass" }

    /** Gets the node corresponding to the field `extends`. */
    final F::AstNode getExtends(int i) { ql_dataclass_extends(this, i, result) }

    /** Gets the node corresponding to the field `instanceof`. */
    final F::AstNode getInstanceof(int i) { ql_dataclass_instanceof(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::ClassName getName() { ql_dataclass_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_dataclass_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_dataclass_extends(this, _, result) or
      ql_dataclass_instanceof(this, _, result) or
      ql_dataclass_def(this, result) or
      ql_dataclass_child(this, _, result)
    }
  }

  /** A class representing `datatype` nodes. */
  class Datatype extends @ql_datatype, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Datatype" }

    /** Gets the node corresponding to the field `name`. */
    final F::ClassName getName() { ql_datatype_def(this, result, _) }

    /** Gets the child of this node. */
    final F::DatatypeBranches getChild() { ql_datatype_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_datatype_def(this, result, _) or ql_datatype_def(this, _, result)
    }
  }

  /** A class representing `datatypeBranch` nodes. */
  class DatatypeBranch extends @ql_datatype_branch, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DatatypeBranch" }

    /** Gets the node corresponding to the field `name`. */
    final F::ClassName getName() { ql_datatype_branch_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_datatype_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_datatype_branch_def(this, result) or ql_datatype_branch_child(this, _, result)
    }
  }

  /** A class representing `datatypeBranches` nodes. */
  class DatatypeBranches extends @ql_datatype_branches, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DatatypeBranches" }

    /** Gets the `i`th child of this node. */
    final F::DatatypeBranch getChild(int i) { ql_datatype_branches_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_datatype_branches_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  class Dbtype extends @ql_token_dbtype, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `direction` tokens. */
  class Direction extends @ql_token_direction, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Direction" }
  }

  /** A class representing `disjunction` nodes. */
  class Disjunction extends @ql_disjunction, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Disjunction" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_disjunction_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_disjunction_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_disjunction_def(this, result, _) or ql_disjunction_def(this, _, result)
    }
  }

  /** A class representing `empty` tokens. */
  class Empty extends @ql_token_empty, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Empty" }
  }

  /** A class representing `expr_aggregate_body` nodes. */
  class ExprAggregateBody extends @ql_expr_aggregate_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprAggregateBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final F::AsExprs getAsExprs() { ql_expr_aggregate_body_def(this, result) }

    /** Gets the node corresponding to the field `orderBys`. */
    final F::OrderBys getOrderBys() { ql_expr_aggregate_body_order_bys(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_expr_aggregate_body_def(this, result) or ql_expr_aggregate_body_order_bys(this, result)
    }
  }

  /** A class representing `expr_annotation` nodes. */
  class ExprAnnotation extends @ql_expr_annotation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprAnnotation" }

    /** Gets the node corresponding to the field `annot_arg`. */
    final F::AnnotName getAnnotArg() { ql_expr_annotation_def(this, result, _, _) }

    /** Gets the node corresponding to the field `name`. */
    final F::AnnotName getName() { ql_expr_annotation_def(this, _, result, _) }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_expr_annotation_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_expr_annotation_def(this, result, _, _) or
      ql_expr_annotation_def(this, _, result, _) or
      ql_expr_annotation_def(this, _, _, result)
    }
  }

  /** A class representing `false` tokens. */
  class False extends @ql_token_false, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `field` nodes. */
  class Field extends @ql_field, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Field" }

    /** Gets the child of this node. */
    final F::VarDecl getChild() { ql_field_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_field_def(this, result) }
  }

  /** A class representing `float` tokens. */
  class Float extends @ql_token_float, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `full_aggregate_body` nodes. */
  class FullAggregateBody extends @ql_full_aggregate_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FullAggregateBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final F::AsExprs getAsExprs() { ql_full_aggregate_body_as_exprs(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final F::AstNode getGuard() { ql_full_aggregate_body_guard(this, result) }

    /** Gets the node corresponding to the field `orderBys`. */
    final F::OrderBys getOrderBys() { ql_full_aggregate_body_order_bys(this, result) }

    /** Gets the `i`th child of this node. */
    final F::VarDecl getChild(int i) { ql_full_aggregate_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_full_aggregate_body_as_exprs(this, result) or
      ql_full_aggregate_body_guard(this, result) or
      ql_full_aggregate_body_order_bys(this, result) or
      ql_full_aggregate_body_child(this, _, result)
    }
  }

  /** A class representing `higherOrderTerm` nodes. */
  class HigherOrderTerm extends @ql_higher_order_term, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HigherOrderTerm" }

    /** Gets the node corresponding to the field `name`. */
    final F::LiteralId getName() { ql_higher_order_term_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_higher_order_term_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_higher_order_term_def(this, result) or ql_higher_order_term_child(this, _, result)
    }
  }

  /** A class representing `if_term` nodes. */
  class IfTerm extends @ql_if_term, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfTerm" }

    /** Gets the node corresponding to the field `cond`. */
    final F::AstNode getCond() { ql_if_term_def(this, result, _, _) }

    /** Gets the node corresponding to the field `first`. */
    final F::AstNode getFirst() { ql_if_term_def(this, _, result, _) }

    /** Gets the node corresponding to the field `second`. */
    final F::AstNode getSecond() { ql_if_term_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_if_term_def(this, result, _, _) or
      ql_if_term_def(this, _, result, _) or
      ql_if_term_def(this, _, _, result)
    }
  }

  /** A class representing `implication` nodes. */
  class Implication extends @ql_implication, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Implication" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_implication_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_implication_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_implication_def(this, result, _) or ql_implication_def(this, _, result)
    }
  }

  /** A class representing `importDirective` nodes. */
  class ImportDirective extends @ql_import_directive, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDirective" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_import_directive_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_import_directive_child(this, _, result) }
  }

  /** A class representing `importModuleExpr` nodes. */
  class ImportModuleExpr extends @ql_import_module_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportModuleExpr" }

    /** Gets the node corresponding to the field `qualName`. */
    final F::SimpleId getQualName(int i) { ql_import_module_expr_qual_name(this, i, result) }

    /** Gets the child of this node. */
    final F::ModuleExpr getChild() { ql_import_module_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_import_module_expr_qual_name(this, _, result) or ql_import_module_expr_def(this, result)
    }
  }

  /** A class representing `in_expr` nodes. */
  class InExpr extends @ql_in_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InExpr" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_in_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_in_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_in_expr_def(this, result, _) or ql_in_expr_def(this, _, result)
    }
  }

  /** A class representing `instance_of` nodes. */
  class InstanceOf extends @ql_instance_of, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InstanceOf" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_instance_of_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_instance_of_child(this, _, result) }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @ql_token_integer, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  class LineComment extends @ql_token_line_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `literal` nodes. */
  class Literal extends @ql_literal, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Literal" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_literal_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_literal_def(this, result) }
  }

  /** A class representing `literalId` tokens. */
  class LiteralId extends @ql_token_literal_id, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LiteralId" }
  }

  /** A class representing `memberPredicate` nodes. */
  class MemberPredicate extends @ql_member_predicate, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MemberPredicate" }

    /** Gets the node corresponding to the field `name`. */
    final F::PredicateName getName() { ql_member_predicate_def(this, result, _) }

    /** Gets the node corresponding to the field `returnType`. */
    final F::AstNode getReturnType() { ql_member_predicate_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_member_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_member_predicate_def(this, result, _) or
      ql_member_predicate_def(this, _, result) or
      ql_member_predicate_child(this, _, result)
    }
  }

  /** A class representing `module` nodes. */
  class Module extends @ql_module, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Module" }

    /** Gets the node corresponding to the field `implements`. */
    final F::SignatureExpr getImplements(int i) { ql_module_implements(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final F::ModuleName getName() { ql_module_def(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final F::ModuleParam getParameter(int i) { ql_module_parameter(this, i, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_module_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_module_implements(this, _, result) or
      ql_module_def(this, result) or
      ql_module_parameter(this, _, result) or
      ql_module_child(this, _, result)
    }
  }

  /** A class representing `moduleAliasBody` nodes. */
  class ModuleAliasBody extends @ql_module_alias_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleAliasBody" }

    /** Gets the child of this node. */
    final F::ModuleExpr getChild() { ql_module_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_module_alias_body_def(this, result) }
  }

  /** A class representing `moduleExpr` nodes. */
  class ModuleExpr extends @ql_module_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleExpr" }

    /** Gets the node corresponding to the field `name`. */
    final F::AstNode getName() { ql_module_expr_name(this, result) }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_module_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_module_expr_name(this, result) or ql_module_expr_def(this, result)
    }
  }

  /** A class representing `moduleInstantiation` nodes. */
  class ModuleInstantiation extends @ql_module_instantiation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleInstantiation" }

    /** Gets the node corresponding to the field `name`. */
    final F::ModuleName getName() { ql_module_instantiation_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::SignatureExpr getChild(int i) { ql_module_instantiation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_module_instantiation_def(this, result) or ql_module_instantiation_child(this, _, result)
    }
  }

  /** A class representing `moduleMember` nodes. */
  class ModuleMember extends @ql_module_member, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleMember" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_module_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_module_member_child(this, _, result) }
  }

  /** A class representing `moduleName` nodes. */
  class ModuleName extends @ql_module_name, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleName" }

    /** Gets the child of this node. */
    final F::SimpleId getChild() { ql_module_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_module_name_def(this, result) }
  }

  /** A class representing `moduleParam` nodes. */
  class ModuleParam extends @ql_module_param, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleParam" }

    /** Gets the node corresponding to the field `parameter`. */
    final F::SimpleId getParameter() { ql_module_param_def(this, result, _) }

    /** Gets the node corresponding to the field `signature`. */
    final F::SignatureExpr getSignature() { ql_module_param_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_module_param_def(this, result, _) or ql_module_param_def(this, _, result)
    }
  }

  /** A class representing `mul_expr` nodes. */
  class MulExpr extends @ql_mul_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MulExpr" }

    /** Gets the node corresponding to the field `left`. */
    final F::AstNode getLeft() { ql_mul_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final F::AstNode getRight() { ql_mul_expr_def(this, _, result, _) }

    /** Gets the child of this node. */
    final F::Mulop getChild() { ql_mul_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_mul_expr_def(this, result, _, _) or
      ql_mul_expr_def(this, _, result, _) or
      ql_mul_expr_def(this, _, _, result)
    }
  }

  /** A class representing `mulop` tokens. */
  class Mulop extends @ql_token_mulop, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Mulop" }
  }

  /** A class representing `negation` nodes. */
  class Negation extends @ql_negation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Negation" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_negation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_negation_def(this, result) }
  }

  /** A class representing `orderBy` nodes. */
  class OrderBy extends @ql_order_by, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBy" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_order_by_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_order_by_child(this, _, result) }
  }

  /** A class representing `orderBys` nodes. */
  class OrderBys extends @ql_order_bys, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBys" }

    /** Gets the `i`th child of this node. */
    final F::OrderBy getChild(int i) { ql_order_bys_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_order_bys_child(this, _, result) }
  }

  /** A class representing `par_expr` nodes. */
  class ParExpr extends @ql_par_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParExpr" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_par_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_par_expr_def(this, result) }
  }

  /** A class representing `predicate` tokens. */
  class Predicate extends @ql_token_predicate, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Predicate" }
  }

  /** A class representing `predicateAliasBody` nodes. */
  class PredicateAliasBody extends @ql_predicate_alias_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateAliasBody" }

    /** Gets the child of this node. */
    final F::PredicateExpr getChild() { ql_predicate_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_predicate_alias_body_def(this, result) }
  }

  /** A class representing `predicateExpr` nodes. */
  class PredicateExpr extends @ql_predicate_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateExpr" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_predicate_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_predicate_expr_child(this, _, result) }
  }

  /** A class representing `predicateName` tokens. */
  class PredicateName extends @ql_token_predicate_name, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateName" }
  }

  /** A class representing `prefix_cast` nodes. */
  class PrefixCast extends @ql_prefix_cast, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixCast" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_prefix_cast_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_prefix_cast_child(this, _, result) }
  }

  /** A class representing `primitiveType` tokens. */
  class PrimitiveType extends @ql_token_primitive_type, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrimitiveType" }
  }

  /** A class representing `ql` nodes. */
  class Ql extends @ql_ql, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ql" }

    /** Gets the `i`th child of this node. */
    final F::ModuleMember getChild(int i) { ql_ql_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_ql_child(this, _, result) }
  }

  /** A class representing `qldoc` tokens. */
  class Qldoc extends @ql_token_qldoc, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `qualifiedRhs` nodes. */
  class QualifiedRhs extends @ql_qualified_rhs, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "QualifiedRhs" }

    /** Gets the node corresponding to the field `name`. */
    final F::PredicateName getName() { ql_qualified_rhs_name(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_qualified_rhs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_qualified_rhs_name(this, result) or ql_qualified_rhs_child(this, _, result)
    }
  }

  /** A class representing `qualified_expr` nodes. */
  class QualifiedExpr extends @ql_qualified_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "QualifiedExpr" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_qualified_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_qualified_expr_child(this, _, result) }
  }

  /** A class representing `quantified` nodes. */
  class Quantified extends @ql_quantified, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Quantified" }

    /** Gets the node corresponding to the field `expr`. */
    final F::AstNode getExpr() { ql_quantified_expr(this, result) }

    /** Gets the node corresponding to the field `formula`. */
    final F::AstNode getFormula() { ql_quantified_formula(this, result) }

    /** Gets the node corresponding to the field `range`. */
    final F::AstNode getRange() { ql_quantified_range(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_quantified_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_quantified_expr(this, result) or
      ql_quantified_formula(this, result) or
      ql_quantified_range(this, result) or
      ql_quantified_child(this, _, result)
    }
  }

  /** A class representing `quantifier` tokens. */
  class Quantifier extends @ql_token_quantifier, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Quantifier" }
  }

  /** A class representing `range` nodes. */
  class Range extends @ql_range, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Range" }

    /** Gets the node corresponding to the field `lower`. */
    final F::AstNode getLower() { ql_range_def(this, result, _) }

    /** Gets the node corresponding to the field `upper`. */
    final F::AstNode getUpper() { ql_range_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_range_def(this, result, _) or ql_range_def(this, _, result)
    }
  }

  /** A class representing `result` tokens. */
  class Result extends @ql_token_result, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Result" }
  }

  /** A class representing `select` nodes. */
  class Select extends @ql_select, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Select" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_select_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_select_child(this, _, result) }
  }

  /** A class representing `set_literal` nodes. */
  class SetLiteral extends @ql_set_literal, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SetLiteral" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_set_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_set_literal_child(this, _, result) }
  }

  /** A class representing `signatureExpr` nodes. */
  class SignatureExpr extends @ql_signature_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SignatureExpr" }

    /** Gets the node corresponding to the field `mod_expr`. */
    final F::ModuleExpr getModExpr() { ql_signature_expr_mod_expr(this, result) }

    /** Gets the node corresponding to the field `predicate`. */
    final F::PredicateExpr getPredicate() { ql_signature_expr_predicate(this, result) }

    /** Gets the node corresponding to the field `type_expr`. */
    final F::TypeExpr getTypeExpr() { ql_signature_expr_type_expr(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_signature_expr_mod_expr(this, result) or
      ql_signature_expr_predicate(this, result) or
      ql_signature_expr_type_expr(this, result)
    }
  }

  /** A class representing `simpleId` tokens. */
  class SimpleId extends @ql_token_simple_id, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `specialId` tokens. */
  class SpecialId extends @ql_token_special_id, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialId" }
  }

  /** A class representing `special_call` nodes. */
  class SpecialCall extends @ql_special_call, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialCall" }

    /** Gets the child of this node. */
    final F::SpecialId getChild() { ql_special_call_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_special_call_def(this, result) }
  }

  /** A class representing `string` tokens. */
  class String extends @ql_token_string, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `super` tokens. */
  class Super extends @ql_token_super, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `super_ref` nodes. */
  class SuperRef extends @ql_super_ref, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuperRef" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_super_ref_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_super_ref_child(this, _, result) }
  }

  /** A class representing `this` tokens. */
  class This extends @ql_token_this, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "This" }
  }

  /** A class representing `true` tokens. */
  class True extends @ql_token_true, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `typeAliasBody` nodes. */
  class TypeAliasBody extends @ql_type_alias_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAliasBody" }

    /** Gets the child of this node. */
    final F::TypeExpr getChild() { ql_type_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_type_alias_body_def(this, result) }
  }

  /** A class representing `typeExpr` nodes. */
  class TypeExpr extends @ql_type_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeExpr" }

    /** Gets the node corresponding to the field `name`. */
    final F::ClassName getName() { ql_type_expr_name(this, result) }

    /** Gets the node corresponding to the field `qualifier`. */
    final F::ModuleExpr getQualifier() { ql_type_expr_qualifier(this, result) }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_type_expr_child(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_type_expr_name(this, result) or
      ql_type_expr_qualifier(this, result) or
      ql_type_expr_child(this, result)
    }
  }

  /** A class representing `typeUnionBody` nodes. */
  class TypeUnionBody extends @ql_type_union_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeUnionBody" }

    /** Gets the `i`th child of this node. */
    final F::TypeExpr getChild(int i) { ql_type_union_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_type_union_body_child(this, _, result) }
  }

  /** A class representing `unary_expr` nodes. */
  class UnaryExpr extends @ql_unary_expr, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnaryExpr" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_unary_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_unary_expr_child(this, _, result) }
  }

  /** A class representing `underscore` tokens. */
  class Underscore extends @ql_token_underscore, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Underscore" }
  }

  /** A class representing `unop` tokens. */
  class Unop extends @ql_token_unop, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unop" }
  }

  /** A class representing `unqual_agg_body` nodes. */
  class UnqualAggBody extends @ql_unqual_agg_body, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnqualAggBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final F::AstNode getAsExprs(int i) { ql_unqual_agg_body_as_exprs(this, i, result) }

    /** Gets the node corresponding to the field `guard`. */
    final F::AstNode getGuard() { ql_unqual_agg_body_guard(this, result) }

    /** Gets the `i`th child of this node. */
    final F::VarDecl getChild(int i) { ql_unqual_agg_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      ql_unqual_agg_body_as_exprs(this, _, result) or
      ql_unqual_agg_body_guard(this, result) or
      ql_unqual_agg_body_child(this, _, result)
    }
  }

  /** A class representing `varDecl` nodes. */
  class VarDecl extends @ql_var_decl, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarDecl" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { ql_var_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_var_decl_child(this, _, result) }
  }

  /** A class representing `varName` nodes. */
  class VarName extends @ql_var_name, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarName" }

    /** Gets the child of this node. */
    final F::SimpleId getChild() { ql_var_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_var_name_def(this, result) }
  }

  /** A class representing `variable` nodes. */
  class Variable extends @ql_variable, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Variable" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { ql_variable_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { ql_variable_def(this, result) }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(AddExpr).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(AddExpr).getRight() and i = -1 and name = "getRight"
      or
      result = node.(AddExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Aggregate).getChild(i) and name = "getChild"
      or
      result = node.(AnnotArg).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Annotation).getArgs(i) and name = "getArgs"
      or
      result = node.(Annotation).getName() and i = -1 and name = "getName"
      or
      result = node.(AritylessPredicateExpr).getName() and i = -1 and name = "getName"
      or
      result = node.(AritylessPredicateExpr).getQualifier() and i = -1 and name = "getQualifier"
      or
      result = node.(AsExpr).getChild(i) and name = "getChild"
      or
      result = node.(AsExprs).getChild(i) and name = "getChild"
      or
      result = node.(Body).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Bool).getChild() and i = -1 and name = "getChild"
      or
      result = node.(CallBody).getChild(i) and name = "getChild"
      or
      result = node.(CallOrUnqualAggExpr).getChild(i) and name = "getChild"
      or
      result = node.(Charpred).getBody() and i = -1 and name = "getBody"
      or
      result = node.(Charpred).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ClassMember).getChild(i) and name = "getChild"
      or
      result = node.(ClasslessPredicate).getName() and i = -1 and name = "getName"
      or
      result = node.(ClasslessPredicate).getReturnType() and i = -1 and name = "getReturnType"
      or
      result = node.(ClasslessPredicate).getChild(i) and name = "getChild"
      or
      result = node.(CompTerm).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(CompTerm).getRight() and i = -1 and name = "getRight"
      or
      result = node.(CompTerm).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Conjunction).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(Conjunction).getRight() and i = -1 and name = "getRight"
      or
      result = node.(Dataclass).getExtends(i) and name = "getExtends"
      or
      result = node.(Dataclass).getInstanceof(i) and name = "getInstanceof"
      or
      result = node.(Dataclass).getName() and i = -1 and name = "getName"
      or
      result = node.(Dataclass).getChild(i) and name = "getChild"
      or
      result = node.(Datatype).getName() and i = -1 and name = "getName"
      or
      result = node.(Datatype).getChild() and i = -1 and name = "getChild"
      or
      result = node.(DatatypeBranch).getName() and i = -1 and name = "getName"
      or
      result = node.(DatatypeBranch).getChild(i) and name = "getChild"
      or
      result = node.(DatatypeBranches).getChild(i) and name = "getChild"
      or
      result = node.(Disjunction).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(Disjunction).getRight() and i = -1 and name = "getRight"
      or
      result = node.(ExprAggregateBody).getAsExprs() and i = -1 and name = "getAsExprs"
      or
      result = node.(ExprAggregateBody).getOrderBys() and i = -1 and name = "getOrderBys"
      or
      result = node.(ExprAnnotation).getAnnotArg() and i = -1 and name = "getAnnotArg"
      or
      result = node.(ExprAnnotation).getName() and i = -1 and name = "getName"
      or
      result = node.(ExprAnnotation).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Field).getChild() and i = -1 and name = "getChild"
      or
      result = node.(FullAggregateBody).getAsExprs() and i = -1 and name = "getAsExprs"
      or
      result = node.(FullAggregateBody).getGuard() and i = -1 and name = "getGuard"
      or
      result = node.(FullAggregateBody).getOrderBys() and i = -1 and name = "getOrderBys"
      or
      result = node.(FullAggregateBody).getChild(i) and name = "getChild"
      or
      result = node.(HigherOrderTerm).getName() and i = -1 and name = "getName"
      or
      result = node.(HigherOrderTerm).getChild(i) and name = "getChild"
      or
      result = node.(IfTerm).getCond() and i = -1 and name = "getCond"
      or
      result = node.(IfTerm).getFirst() and i = -1 and name = "getFirst"
      or
      result = node.(IfTerm).getSecond() and i = -1 and name = "getSecond"
      or
      result = node.(Implication).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(Implication).getRight() and i = -1 and name = "getRight"
      or
      result = node.(ImportDirective).getChild(i) and name = "getChild"
      or
      result = node.(ImportModuleExpr).getQualName(i) and name = "getQualName"
      or
      result = node.(ImportModuleExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(InExpr).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(InExpr).getRight() and i = -1 and name = "getRight"
      or
      result = node.(InstanceOf).getChild(i) and name = "getChild"
      or
      result = node.(Literal).getChild() and i = -1 and name = "getChild"
      or
      result = node.(MemberPredicate).getName() and i = -1 and name = "getName"
      or
      result = node.(MemberPredicate).getReturnType() and i = -1 and name = "getReturnType"
      or
      result = node.(MemberPredicate).getChild(i) and name = "getChild"
      or
      result = node.(Module).getImplements(i) and name = "getImplements"
      or
      result = node.(Module).getName() and i = -1 and name = "getName"
      or
      result = node.(Module).getParameter(i) and name = "getParameter"
      or
      result = node.(Module).getChild(i) and name = "getChild"
      or
      result = node.(ModuleAliasBody).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ModuleExpr).getName() and i = -1 and name = "getName"
      or
      result = node.(ModuleExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ModuleInstantiation).getName() and i = -1 and name = "getName"
      or
      result = node.(ModuleInstantiation).getChild(i) and name = "getChild"
      or
      result = node.(ModuleMember).getChild(i) and name = "getChild"
      or
      result = node.(ModuleName).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ModuleParam).getParameter() and i = -1 and name = "getParameter"
      or
      result = node.(ModuleParam).getSignature() and i = -1 and name = "getSignature"
      or
      result = node.(MulExpr).getLeft() and i = -1 and name = "getLeft"
      or
      result = node.(MulExpr).getRight() and i = -1 and name = "getRight"
      or
      result = node.(MulExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Negation).getChild() and i = -1 and name = "getChild"
      or
      result = node.(OrderBy).getChild(i) and name = "getChild"
      or
      result = node.(OrderBys).getChild(i) and name = "getChild"
      or
      result = node.(ParExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(PredicateAliasBody).getChild() and i = -1 and name = "getChild"
      or
      result = node.(PredicateExpr).getChild(i) and name = "getChild"
      or
      result = node.(PrefixCast).getChild(i) and name = "getChild"
      or
      result = node.(Ql).getChild(i) and name = "getChild"
      or
      result = node.(QualifiedRhs).getName() and i = -1 and name = "getName"
      or
      result = node.(QualifiedRhs).getChild(i) and name = "getChild"
      or
      result = node.(QualifiedExpr).getChild(i) and name = "getChild"
      or
      result = node.(Quantified).getExpr() and i = -1 and name = "getExpr"
      or
      result = node.(Quantified).getFormula() and i = -1 and name = "getFormula"
      or
      result = node.(Quantified).getRange() and i = -1 and name = "getRange"
      or
      result = node.(Quantified).getChild(i) and name = "getChild"
      or
      result = node.(Range).getLower() and i = -1 and name = "getLower"
      or
      result = node.(Range).getUpper() and i = -1 and name = "getUpper"
      or
      result = node.(Select).getChild(i) and name = "getChild"
      or
      result = node.(SetLiteral).getChild(i) and name = "getChild"
      or
      result = node.(SignatureExpr).getModExpr() and i = -1 and name = "getModExpr"
      or
      result = node.(SignatureExpr).getPredicate() and i = -1 and name = "getPredicate"
      or
      result = node.(SignatureExpr).getTypeExpr() and i = -1 and name = "getTypeExpr"
      or
      result = node.(SpecialCall).getChild() and i = -1 and name = "getChild"
      or
      result = node.(SuperRef).getChild(i) and name = "getChild"
      or
      result = node.(TypeAliasBody).getChild() and i = -1 and name = "getChild"
      or
      result = node.(TypeExpr).getName() and i = -1 and name = "getName"
      or
      result = node.(TypeExpr).getQualifier() and i = -1 and name = "getQualifier"
      or
      result = node.(TypeExpr).getChild() and i = -1 and name = "getChild"
      or
      result = node.(TypeUnionBody).getChild(i) and name = "getChild"
      or
      result = node.(UnaryExpr).getChild(i) and name = "getChild"
      or
      result = node.(UnqualAggBody).getAsExprs(i) and name = "getAsExprs"
      or
      result = node.(UnqualAggBody).getGuard() and i = -1 and name = "getGuard"
      or
      result = node.(UnqualAggBody).getChild(i) and name = "getChild"
      or
      result = node.(VarDecl).getChild(i) and name = "getChild"
      or
      result = node.(VarName).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Variable).getChild() and i = -1 and name = "getChild"
    }
  }
}

module QLFinal {
  private import QL as F
  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class AddExpr = F::AddExpr;

  final class Addop = F::Addop;

  final class AggId = F::AggId;

  final class Aggregate = F::Aggregate;

  final class AnnotArg = F::AnnotArg;

  final class AnnotName = F::AnnotName;

  final class Annotation = F::Annotation;

  final class AritylessPredicateExpr = F::AritylessPredicateExpr;

  final class AsExpr = F::AsExpr;

  final class AsExprs = F::AsExprs;

  final class BlockComment = F::BlockComment;

  final class Body = F::Body;

  final class Bool = F::Bool;

  final class CallBody = F::CallBody;

  final class CallOrUnqualAggExpr = F::CallOrUnqualAggExpr;

  final class Charpred = F::Charpred;

  final class ClassMember = F::ClassMember;

  final class ClassName = F::ClassName;

  final class ClasslessPredicate = F::ClasslessPredicate;

  final class Closure = F::Closure;

  final class CompTerm = F::CompTerm;

  final class Compop = F::Compop;

  final class Conjunction = F::Conjunction;

  final class Dataclass = F::Dataclass;

  final class Datatype = F::Datatype;

  final class DatatypeBranch = F::DatatypeBranch;

  final class DatatypeBranches = F::DatatypeBranches;

  final class Dbtype = F::Dbtype;

  final class Direction = F::Direction;

  final class Disjunction = F::Disjunction;

  final class Empty = F::Empty;

  final class ExprAggregateBody = F::ExprAggregateBody;

  final class ExprAnnotation = F::ExprAnnotation;

  final class False = F::False;

  final class Field = F::Field;

  final class Float = F::Float;

  final class FullAggregateBody = F::FullAggregateBody;

  final class HigherOrderTerm = F::HigherOrderTerm;

  final class IfTerm = F::IfTerm;

  final class Implication = F::Implication;

  final class ImportDirective = F::ImportDirective;

  final class ImportModuleExpr = F::ImportModuleExpr;

  final class InExpr = F::InExpr;

  final class InstanceOf = F::InstanceOf;

  final class Integer = F::Integer;

  final class LineComment = F::LineComment;

  final class Literal = F::Literal;

  final class LiteralId = F::LiteralId;

  final class MemberPredicate = F::MemberPredicate;

  final class Module = F::Module;

  final class ModuleAliasBody = F::ModuleAliasBody;

  final class ModuleExpr = F::ModuleExpr;

  final class ModuleInstantiation = F::ModuleInstantiation;

  final class ModuleMember = F::ModuleMember;

  final class ModuleName = F::ModuleName;

  final class ModuleParam = F::ModuleParam;

  final class MulExpr = F::MulExpr;

  final class Mulop = F::Mulop;

  final class Negation = F::Negation;

  final class OrderBy = F::OrderBy;

  final class OrderBys = F::OrderBys;

  final class ParExpr = F::ParExpr;

  final class Predicate = F::Predicate;

  final class PredicateAliasBody = F::PredicateAliasBody;

  final class PredicateExpr = F::PredicateExpr;

  final class PredicateName = F::PredicateName;

  final class PrefixCast = F::PrefixCast;

  final class PrimitiveType = F::PrimitiveType;

  final class Ql = F::Ql;

  final class Qldoc = F::Qldoc;

  final class QualifiedRhs = F::QualifiedRhs;

  final class QualifiedExpr = F::QualifiedExpr;

  final class Quantified = F::Quantified;

  final class Quantifier = F::Quantifier;

  final class Range = F::Range;

  final class Result = F::Result;

  final class Select = F::Select;

  final class SetLiteral = F::SetLiteral;

  final class SignatureExpr = F::SignatureExpr;

  final class SimpleId = F::SimpleId;

  final class SpecialId = F::SpecialId;

  final class SpecialCall = F::SpecialCall;

  final class String = F::String;

  final class Super = F::Super;

  final class SuperRef = F::SuperRef;

  final class This = F::This;

  final class True = F::True;

  final class TypeAliasBody = F::TypeAliasBody;

  final class TypeExpr = F::TypeExpr;

  final class TypeUnionBody = F::TypeUnionBody;

  final class UnaryExpr = F::UnaryExpr;

  final class Underscore = F::Underscore;

  final class Unop = F::Unop;

  final class UnqualAggBody = F::UnqualAggBody;

  final class VarDecl = F::VarDecl;

  final class VarName = F::VarName;

  final class Variable = F::Variable;
}

overlay[local]
module Dbscheme {
  private import Dbscheme as F

  /** The base class for all AST nodes */
  class AstNode extends @dbscheme_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { dbscheme_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { dbscheme_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { dbscheme_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @dbscheme_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { dbscheme_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @dbscheme_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@dbscheme_ast_node node) {
    exists(@location_default loc | dbscheme_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @dbscheme_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@dbscheme_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `annotName` tokens. */
  class AnnotName extends @dbscheme_token_annot_name, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  class Annotation extends @dbscheme_annotation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Annotation" }

    /** Gets the node corresponding to the field `argsAnnotation`. */
    final F::ArgsAnnotation getArgsAnnotation() {
      dbscheme_annotation_args_annotation(this, result)
    }

    /** Gets the node corresponding to the field `simpleAnnotation`. */
    final F::AnnotName getSimpleAnnotation() { dbscheme_annotation_simple_annotation(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_annotation_args_annotation(this, result) or
      dbscheme_annotation_simple_annotation(this, result)
    }
  }

  /** A class representing `argsAnnotation` nodes. */
  class ArgsAnnotation extends @dbscheme_args_annotation, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArgsAnnotation" }

    /** Gets the node corresponding to the field `name`. */
    final F::AnnotName getName() { dbscheme_args_annotation_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::SimpleId getChild(int i) { dbscheme_args_annotation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_args_annotation_def(this, result) or dbscheme_args_annotation_child(this, _, result)
    }
  }

  /** A class representing `block_comment` tokens. */
  class BlockComment extends @dbscheme_token_block_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `boolean` tokens. */
  class Boolean extends @dbscheme_token_boolean, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Boolean" }
  }

  /** A class representing `branch` nodes. */
  class Branch extends @dbscheme_branch, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Branch" }

    /** Gets the node corresponding to the field `qldoc`. */
    final F::Qldoc getQldoc() { dbscheme_branch_qldoc(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { dbscheme_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_branch_qldoc(this, result) or dbscheme_branch_child(this, _, result)
    }
  }

  /** A class representing `caseDecl` nodes. */
  class CaseDecl extends @dbscheme_case_decl, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaseDecl" }

    /** Gets the node corresponding to the field `base`. */
    final F::Dbtype getBase() { dbscheme_case_decl_def(this, result, _) }

    /** Gets the node corresponding to the field `discriminator`. */
    final F::SimpleId getDiscriminator() { dbscheme_case_decl_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final F::Branch getChild(int i) { dbscheme_case_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_case_decl_def(this, result, _) or
      dbscheme_case_decl_def(this, _, result) or
      dbscheme_case_decl_child(this, _, result)
    }
  }

  /** A class representing `colType` nodes. */
  class ColType extends @dbscheme_col_type, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ColType" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { dbscheme_col_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { dbscheme_col_type_def(this, result) }
  }

  /** A class representing `column` nodes. */
  class Column extends @dbscheme_column, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Column" }

    /** Gets the node corresponding to the field `colName`. */
    final F::SimpleId getColName() { dbscheme_column_def(this, result, _, _) }

    /** Gets the node corresponding to the field `colType`. */
    final F::ColType getColType() { dbscheme_column_def(this, _, result, _) }

    /** Gets the node corresponding to the field `isRef`. */
    final F::Ref getIsRef() { dbscheme_column_is_ref(this, result) }

    /** Gets the node corresponding to the field `isUnique`. */
    final F::Unique getIsUnique() { dbscheme_column_is_unique(this, result) }

    /** Gets the node corresponding to the field `qldoc`. */
    final F::Qldoc getQldoc() { dbscheme_column_qldoc(this, result) }

    /** Gets the node corresponding to the field `reprType`. */
    final F::ReprType getReprType() { dbscheme_column_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_column_def(this, result, _, _) or
      dbscheme_column_def(this, _, result, _) or
      dbscheme_column_is_ref(this, result) or
      dbscheme_column_is_unique(this, result) or
      dbscheme_column_qldoc(this, result) or
      dbscheme_column_def(this, _, _, result)
    }
  }

  /** A class representing `date` tokens. */
  class Date extends @dbscheme_token_date, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `dbscheme` nodes. */
  class Dbscheme extends @dbscheme_dbscheme, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbscheme" }

    /** Gets the `i`th child of this node. */
    final F::Entry getChild(int i) { dbscheme_dbscheme_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { dbscheme_dbscheme_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  class Dbtype extends @dbscheme_token_dbtype, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `entry` nodes. */
  class Entry extends @dbscheme_entry, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Entry" }

    /** Gets the child of this node. */
    final F::AstNode getChild() { dbscheme_entry_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { dbscheme_entry_def(this, result) }
  }

  /** A class representing `float` tokens. */
  class Float extends @dbscheme_token_float, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `int` tokens. */
  class Int extends @dbscheme_token_int, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Int" }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @dbscheme_token_integer, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  class LineComment extends @dbscheme_token_line_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `qldoc` tokens. */
  class Qldoc extends @dbscheme_token_qldoc, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `ref` tokens. */
  class Ref extends @dbscheme_token_ref, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ref" }
  }

  /** A class representing `reprType` nodes. */
  class ReprType extends @dbscheme_repr_type, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReprType" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { dbscheme_repr_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { dbscheme_repr_type_child(this, _, result) }
  }

  /** A class representing `simpleId` tokens. */
  class SimpleId extends @dbscheme_token_simple_id, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `string` tokens. */
  class String extends @dbscheme_token_string, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `table` nodes. */
  class Table extends @dbscheme_table, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Table" }

    /** Gets the node corresponding to the field `tableName`. */
    final F::TableName getTableName() { dbscheme_table_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { dbscheme_table_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_table_def(this, result) or dbscheme_table_child(this, _, result)
    }
  }

  /** A class representing `tableName` nodes. */
  class TableName extends @dbscheme_table_name, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TableName" }

    /** Gets the child of this node. */
    final F::SimpleId getChild() { dbscheme_table_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { dbscheme_table_name_def(this, result) }
  }

  /** A class representing `unionDecl` nodes. */
  class UnionDecl extends @dbscheme_union_decl, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnionDecl" }

    /** Gets the node corresponding to the field `base`. */
    final F::Dbtype getBase() { dbscheme_union_decl_def(this, result) }

    /** Gets the `i`th child of this node. */
    final F::Dbtype getChild(int i) { dbscheme_union_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      dbscheme_union_decl_def(this, result) or dbscheme_union_decl_child(this, _, result)
    }
  }

  /** A class representing `unique` tokens. */
  class Unique extends @dbscheme_token_unique, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unique" }
  }

  /** A class representing `varchar` tokens. */
  class Varchar extends @dbscheme_token_varchar, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Varchar" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(Annotation).getArgsAnnotation() and i = -1 and name = "getArgsAnnotation"
      or
      result = node.(Annotation).getSimpleAnnotation() and i = -1 and name = "getSimpleAnnotation"
      or
      result = node.(ArgsAnnotation).getName() and i = -1 and name = "getName"
      or
      result = node.(ArgsAnnotation).getChild(i) and name = "getChild"
      or
      result = node.(Branch).getQldoc() and i = -1 and name = "getQldoc"
      or
      result = node.(Branch).getChild(i) and name = "getChild"
      or
      result = node.(CaseDecl).getBase() and i = -1 and name = "getBase"
      or
      result = node.(CaseDecl).getDiscriminator() and i = -1 and name = "getDiscriminator"
      or
      result = node.(CaseDecl).getChild(i) and name = "getChild"
      or
      result = node.(ColType).getChild() and i = -1 and name = "getChild"
      or
      result = node.(Column).getColName() and i = -1 and name = "getColName"
      or
      result = node.(Column).getColType() and i = -1 and name = "getColType"
      or
      result = node.(Column).getIsRef() and i = -1 and name = "getIsRef"
      or
      result = node.(Column).getIsUnique() and i = -1 and name = "getIsUnique"
      or
      result = node.(Column).getQldoc() and i = -1 and name = "getQldoc"
      or
      result = node.(Column).getReprType() and i = -1 and name = "getReprType"
      or
      result = node.(Dbscheme).getChild(i) and name = "getChild"
      or
      result = node.(Entry).getChild() and i = -1 and name = "getChild"
      or
      result = node.(ReprType).getChild(i) and name = "getChild"
      or
      result = node.(Table).getTableName() and i = -1 and name = "getTableName"
      or
      result = node.(Table).getChild(i) and name = "getChild"
      or
      result = node.(TableName).getChild() and i = -1 and name = "getChild"
      or
      result = node.(UnionDecl).getBase() and i = -1 and name = "getBase"
      or
      result = node.(UnionDecl).getChild(i) and name = "getChild"
    }
  }
}

module DbschemeFinal {
  private import Dbscheme as F
  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class AnnotName = F::AnnotName;

  final class Annotation = F::Annotation;

  final class ArgsAnnotation = F::ArgsAnnotation;

  final class BlockComment = F::BlockComment;

  final class Boolean = F::Boolean;

  final class Branch = F::Branch;

  final class CaseDecl = F::CaseDecl;

  final class ColType = F::ColType;

  final class Column = F::Column;

  final class Date = F::Date;

  final class Dbscheme = F::Dbscheme;

  final class Dbtype = F::Dbtype;

  final class Entry = F::Entry;

  final class Float = F::Float;

  final class Int = F::Int;

  final class Integer = F::Integer;

  final class LineComment = F::LineComment;

  final class Qldoc = F::Qldoc;

  final class Ref = F::Ref;

  final class ReprType = F::ReprType;

  final class SimpleId = F::SimpleId;

  final class String = F::String;

  final class Table = F::Table;

  final class TableName = F::TableName;

  final class UnionDecl = F::UnionDecl;

  final class Unique = F::Unique;

  final class Varchar = F::Varchar;
}

overlay[local]
module Blame {
  private import Blame as F

  /** The base class for all AST nodes */
  class AstNode extends @blame_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { blame_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { blame_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { blame_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @blame_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { blame_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @blame_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@blame_ast_node node) {
    exists(@location_default loc | blame_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @blame_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@blame_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  /** A class representing `blame_entry` nodes. */
  class BlameEntry extends @blame_blame_entry, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlameEntry" }

    /** Gets the node corresponding to the field `date`. */
    final F::Date getDate() { blame_blame_entry_def(this, result) }

    /** Gets the node corresponding to the field `line`. */
    final F::Number getLine(int i) { blame_blame_entry_line(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      blame_blame_entry_def(this, result) or blame_blame_entry_line(this, _, result)
    }
  }

  /** A class representing `blame_info` nodes. */
  class BlameInfo extends @blame_blame_info, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlameInfo" }

    /** Gets the node corresponding to the field `file_entry`. */
    final F::FileEntry getFileEntry(int i) { blame_blame_info_file_entry(this, i, result) }

    /** Gets the node corresponding to the field `today`. */
    final F::Date getToday() { blame_blame_info_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      blame_blame_info_file_entry(this, _, result) or blame_blame_info_def(this, result)
    }
  }

  /** A class representing `date` tokens. */
  class Date extends @blame_token_date, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `file_entry` nodes. */
  class FileEntry extends @blame_file_entry, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FileEntry" }

    /** Gets the node corresponding to the field `blame_entry`. */
    final F::BlameEntry getBlameEntry(int i) { blame_file_entry_blame_entry(this, i, result) }

    /** Gets the node corresponding to the field `file_name`. */
    final F::Filename getFileName() { blame_file_entry_def(this, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      blame_file_entry_blame_entry(this, _, result) or blame_file_entry_def(this, result)
    }
  }

  /** A class representing `filename` tokens. */
  class Filename extends @blame_token_filename, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Filename" }
  }

  /** A class representing `number` tokens. */
  class Number extends @blame_token_number, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(BlameEntry).getDate() and i = -1 and name = "getDate"
      or
      result = node.(BlameEntry).getLine(i) and name = "getLine"
      or
      result = node.(BlameInfo).getFileEntry(i) and name = "getFileEntry"
      or
      result = node.(BlameInfo).getToday() and i = -1 and name = "getToday"
      or
      result = node.(FileEntry).getBlameEntry(i) and name = "getBlameEntry"
      or
      result = node.(FileEntry).getFileName() and i = -1 and name = "getFileName"
    }
  }
}

module BlameFinal {
  private import Blame as F
  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class BlameEntry = F::BlameEntry;

  final class BlameInfo = F::BlameInfo;

  final class Date = F::Date;

  final class FileEntry = F::FileEntry;

  final class Filename = F::Filename;

  final class Number = F::Number;
}

overlay[local]
module JSON {
  private import JSON as F

  /** The base class for all AST nodes */
  class AstNode extends @json_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { json_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final F::AstNode getParent() { json_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { json_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    F::AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  /** A token. */
  class Token extends @json_token, F::AstNode {
    /** Gets the value of this token. */
    final string getValue() { json_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @json_reserved_word, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** Gets the file containing the given `node`. */
  private @file getNodeFile(@json_ast_node node) {
    exists(@location_default loc | json_ast_node_location(node, loc) |
      locations_default(loc, result, _, _, _, _)
    )
  }

  /** Holds if `node` is in the `file` and is part of the overlay base database. */
  private predicate discardableAstNode(@file file, @json_ast_node node) {
    not isOverlay() and file = getNodeFile(node)
  }

  /** Holds if `node` should be discarded, because it is part of the overlay base and is in a file that was also extracted as part of the overlay database. */
  overlay[discard_entity]
  private predicate discardAstNode(@json_ast_node node) {
    exists(@file file, string path | files(file, path) |
      discardableAstNode(file, node) and overlayChangedFiles(path)
    )
  }

  class UnderscoreValue extends @json_underscore_value, F::AstNode { }

  /** A class representing `array` nodes. */
  class Array extends @json_array, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Array" }

    /** Gets the `i`th child of this node. */
    final F::UnderscoreValue getChild(int i) { json_array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { json_array_child(this, _, result) }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @json_token_comment, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `document` nodes. */
  class Document extends @json_document, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Document" }

    /** Gets the `i`th child of this node. */
    final F::UnderscoreValue getChild(int i) { json_document_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { json_document_child(this, _, result) }
  }

  /** A class representing `escape_sequence` tokens. */
  class EscapeSequence extends @json_token_escape_sequence, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  /** A class representing `false` tokens. */
  class False extends @json_token_false, F::Token, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `null` tokens. */
  class Null extends @json_token_null, F::Token, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Null" }
  }

  /** A class representing `number` tokens. */
  class Number extends @json_token_number, F::Token, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }

  /** A class representing `object` nodes. */
  class Object extends @json_object, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Object" }

    /** Gets the `i`th child of this node. */
    final F::Pair getChild(int i) { json_object_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { json_object_child(this, _, result) }
  }

  /** A class representing `pair` nodes. */
  class Pair extends @json_pair, F::AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pair" }

    /** Gets the node corresponding to the field `key`. */
    final F::String getKey() { json_pair_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final F::UnderscoreValue getValue() { json_pair_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() {
      json_pair_def(this, result, _) or json_pair_def(this, _, result)
    }
  }

  /** A class representing `string` nodes. */
  class String extends @json_string__, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }

    /** Gets the `i`th child of this node. */
    final F::AstNode getChild(int i) { json_string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override F::AstNode getAFieldOrChild() { json_string_child(this, _, result) }
  }

  /** A class representing `string_content` tokens. */
  class StringContent extends @json_token_string_content, F::AstNode, F::Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringContent" }
  }

  /** A class representing `true` tokens. */
  class True extends @json_token_true, F::Token, F::UnderscoreValue {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    F::AstNode getChild(F::AstNode node, string name, int i) {
      result = node.(Array).getChild(i) and name = "getChild"
      or
      result = node.(Document).getChild(i) and name = "getChild"
      or
      result = node.(Object).getChild(i) and name = "getChild"
      or
      result = node.(Pair).getKey() and i = -1 and name = "getKey"
      or
      result = node.(Pair).getValue() and i = -1 and name = "getValue"
      or
      result = node.(String).getChild(i) and name = "getChild"
    }
  }
}

module JSONFinal {
  private import JSON as F
  import F

  final class AstNode = F::AstNode;

  final class Token = F::Token;

  final class ReservedWord = F::ReservedWord;

  final class UnderscoreValue = F::UnderscoreValue;

  final class Array = F::Array;

  final class Comment = F::Comment;

  final class Document = F::Document;

  final class EscapeSequence = F::EscapeSequence;

  final class False = F::False;

  final class Null = F::Null;

  final class Number = F::Number;

  final class Object = F::Object;

  final class Pair = F::Pair;

  final class String = F::String;

  final class StringContent = F::StringContent;

  final class True = F::True;
}
