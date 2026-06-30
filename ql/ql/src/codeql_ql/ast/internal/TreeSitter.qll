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
  /** The base class for all AST nodes */
  private class AstNodeImpl extends @ql_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { ql_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { ql_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { ql_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  final class AstNode = AstNodeImpl;

  /** A token. */
  private class TokenImpl extends @ql_token, AstNodeImpl {
    /** Gets the value of this token. */
    final string getValue() { ql_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  final class Token = TokenImpl;

  /** A reserved word. */
  final class ReservedWord extends @ql_reserved_word, TokenImpl {
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
  final class AddExpr extends @ql_add_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AddExpr" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_add_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_add_expr_def(this, _, result, _) }

    /** Gets the child of this node. */
    final Addop getChild() { ql_add_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_add_expr_def(this, result, _, _) or
      ql_add_expr_def(this, _, result, _) or
      ql_add_expr_def(this, _, _, result)
    }
  }

  /** A class representing `addop` tokens. */
  final class Addop extends @ql_token_addop, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Addop" }
  }

  /** A class representing `aggId` tokens. */
  final class AggId extends @ql_token_agg_id, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AggId" }
  }

  /** A class representing `aggregate` nodes. */
  final class Aggregate extends @ql_aggregate, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Aggregate" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_aggregate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_aggregate_child(this, _, result) }
  }

  /** A class representing `annotArg` nodes. */
  final class AnnotArg extends @ql_annot_arg, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotArg" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_annot_arg_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_annot_arg_def(this, result) }
  }

  /** A class representing `annotName` tokens. */
  final class AnnotName extends @ql_token_annot_name, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  final class Annotation extends @ql_annotation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Annotation" }

    /** Gets the node corresponding to the field `args`. */
    final AstNode getArgs(int i) { ql_annotation_args(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final AnnotName getName() { ql_annotation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_annotation_args(this, _, result) or ql_annotation_def(this, result)
    }
  }

  /** A class representing `aritylessPredicateExpr` nodes. */
  final class AritylessPredicateExpr extends @ql_arityless_predicate_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AritylessPredicateExpr" }

    /** Gets the node corresponding to the field `name`. */
    final LiteralId getName() { ql_arityless_predicate_expr_def(this, result) }

    /** Gets the node corresponding to the field `qualifier`. */
    final ModuleExpr getQualifier() { ql_arityless_predicate_expr_qualifier(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_arityless_predicate_expr_def(this, result) or
      ql_arityless_predicate_expr_qualifier(this, result)
    }
  }

  /** A class representing `asExpr` nodes. */
  final class AsExpr extends @ql_as_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_as_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_as_expr_child(this, _, result) }
  }

  /** A class representing `asExprs` nodes. */
  final class AsExprs extends @ql_as_exprs, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExprs" }

    /** Gets the `i`th child of this node. */
    final AsExpr getChild(int i) { ql_as_exprs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_as_exprs_child(this, _, result) }
  }

  /** A class representing `block_comment` tokens. */
  final class BlockComment extends @ql_token_block_comment, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `body` nodes. */
  final class Body extends @ql_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Body" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_body_def(this, result) }
  }

  /** A class representing `bool` nodes. */
  final class Bool extends @ql_bool, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Bool" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_bool_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_bool_def(this, result) }
  }

  /** A class representing `call_body` nodes. */
  final class CallBody extends @ql_call_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallBody" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_call_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_call_body_child(this, _, result) }
  }

  /** A class representing `call_or_unqual_agg_expr` nodes. */
  final class CallOrUnqualAggExpr extends @ql_call_or_unqual_agg_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallOrUnqualAggExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_call_or_unqual_agg_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_call_or_unqual_agg_expr_child(this, _, result) }
  }

  /** A class representing `charpred` nodes. */
  final class Charpred extends @ql_charpred, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Charpred" }

    /** Gets the node corresponding to the field `body`. */
    final AstNode getBody() { ql_charpred_def(this, result, _) }

    /** Gets the child of this node. */
    final ClassName getChild() { ql_charpred_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_charpred_def(this, result, _) or ql_charpred_def(this, _, result)
    }
  }

  /** A class representing `classMember` nodes. */
  final class ClassMember extends @ql_class_member, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassMember" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_class_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_class_member_child(this, _, result) }
  }

  /** A class representing `className` tokens. */
  final class ClassName extends @ql_token_class_name, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassName" }
  }

  /** A class representing `classlessPredicate` nodes. */
  final class ClasslessPredicate extends @ql_classless_predicate, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

    /** Gets the node corresponding to the field `name`. */
    final PredicateName getName() { ql_classless_predicate_def(this, result, _) }

    /** Gets the node corresponding to the field `returnType`. */
    final AstNode getReturnType() { ql_classless_predicate_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_classless_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_classless_predicate_def(this, result, _) or
      ql_classless_predicate_def(this, _, result) or
      ql_classless_predicate_child(this, _, result)
    }
  }

  /** A class representing `closure` tokens. */
  final class Closure extends @ql_token_closure, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Closure" }
  }

  /** A class representing `comp_term` nodes. */
  final class CompTerm extends @ql_comp_term, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CompTerm" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_comp_term_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_comp_term_def(this, _, result, _) }

    /** Gets the child of this node. */
    final Compop getChild() { ql_comp_term_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_comp_term_def(this, result, _, _) or
      ql_comp_term_def(this, _, result, _) or
      ql_comp_term_def(this, _, _, result)
    }
  }

  /** A class representing `compop` tokens. */
  final class Compop extends @ql_token_compop, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Compop" }
  }

  /** A class representing `conjunction` nodes. */
  final class Conjunction extends @ql_conjunction, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Conjunction" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_conjunction_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_conjunction_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_conjunction_def(this, result, _) or ql_conjunction_def(this, _, result)
    }
  }

  /** A class representing `dataclass` nodes. */
  final class Dataclass extends @ql_dataclass, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dataclass" }

    /** Gets the node corresponding to the field `extends`. */
    final AstNode getExtends(int i) { ql_dataclass_extends(this, i, result) }

    /** Gets the node corresponding to the field `instanceof`. */
    final AstNode getInstanceof(int i) { ql_dataclass_instanceof(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final ClassName getName() { ql_dataclass_def(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_dataclass_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_dataclass_extends(this, _, result) or
      ql_dataclass_instanceof(this, _, result) or
      ql_dataclass_def(this, result) or
      ql_dataclass_child(this, _, result)
    }
  }

  /** A class representing `datatype` nodes. */
  final class Datatype extends @ql_datatype, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Datatype" }

    /** Gets the node corresponding to the field `name`. */
    final ClassName getName() { ql_datatype_def(this, result, _) }

    /** Gets the child of this node. */
    final DatatypeBranches getChild() { ql_datatype_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_datatype_def(this, result, _) or ql_datatype_def(this, _, result)
    }
  }

  /** A class representing `datatypeBranch` nodes. */
  final class DatatypeBranch extends @ql_datatype_branch, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DatatypeBranch" }

    /** Gets the node corresponding to the field `name`. */
    final ClassName getName() { ql_datatype_branch_def(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_datatype_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_datatype_branch_def(this, result) or ql_datatype_branch_child(this, _, result)
    }
  }

  /** A class representing `datatypeBranches` nodes. */
  final class DatatypeBranches extends @ql_datatype_branches, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DatatypeBranches" }

    /** Gets the `i`th child of this node. */
    final DatatypeBranch getChild(int i) { ql_datatype_branches_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_datatype_branches_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  final class Dbtype extends @ql_token_dbtype, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `direction` tokens. */
  final class Direction extends @ql_token_direction, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Direction" }
  }

  /** A class representing `disjunction` nodes. */
  final class Disjunction extends @ql_disjunction, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Disjunction" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_disjunction_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_disjunction_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_disjunction_def(this, result, _) or ql_disjunction_def(this, _, result)
    }
  }

  /** A class representing `empty` tokens. */
  final class Empty extends @ql_token_empty, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Empty" }
  }

  /** A class representing `expr_aggregate_body` nodes. */
  final class ExprAggregateBody extends @ql_expr_aggregate_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprAggregateBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final AsExprs getAsExprs() { ql_expr_aggregate_body_def(this, result) }

    /** Gets the node corresponding to the field `orderBys`. */
    final OrderBys getOrderBys() { ql_expr_aggregate_body_order_bys(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_expr_aggregate_body_def(this, result) or ql_expr_aggregate_body_order_bys(this, result)
    }
  }

  /** A class representing `expr_annotation` nodes. */
  final class ExprAnnotation extends @ql_expr_annotation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ExprAnnotation" }

    /** Gets the node corresponding to the field `annot_arg`. */
    final AnnotName getAnnotArg() { ql_expr_annotation_def(this, result, _, _) }

    /** Gets the node corresponding to the field `name`. */
    final AnnotName getName() { ql_expr_annotation_def(this, _, result, _) }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_expr_annotation_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_expr_annotation_def(this, result, _, _) or
      ql_expr_annotation_def(this, _, result, _) or
      ql_expr_annotation_def(this, _, _, result)
    }
  }

  /** A class representing `false` tokens. */
  final class False extends @ql_token_false, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `field` nodes. */
  final class Field extends @ql_field, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Field" }

    /** Gets the child of this node. */
    final VarDecl getChild() { ql_field_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_field_def(this, result) }
  }

  /** A class representing `float` tokens. */
  final class Float extends @ql_token_float, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `full_aggregate_body` nodes. */
  final class FullAggregateBody extends @ql_full_aggregate_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FullAggregateBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final AsExprs getAsExprs() { ql_full_aggregate_body_as_exprs(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    final AstNode getGuard() { ql_full_aggregate_body_guard(this, result) }

    /** Gets the node corresponding to the field `orderBys`. */
    final OrderBys getOrderBys() { ql_full_aggregate_body_order_bys(this, result) }

    /** Gets the `i`th child of this node. */
    final VarDecl getChild(int i) { ql_full_aggregate_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_full_aggregate_body_as_exprs(this, result) or
      ql_full_aggregate_body_guard(this, result) or
      ql_full_aggregate_body_order_bys(this, result) or
      ql_full_aggregate_body_child(this, _, result)
    }
  }

  /** A class representing `higherOrderTerm` nodes. */
  final class HigherOrderTerm extends @ql_higher_order_term, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "HigherOrderTerm" }

    /** Gets the node corresponding to the field `name`. */
    final LiteralId getName() { ql_higher_order_term_def(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_higher_order_term_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_higher_order_term_def(this, result) or ql_higher_order_term_child(this, _, result)
    }
  }

  /** A class representing `if_term` nodes. */
  final class IfTerm extends @ql_if_term, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "IfTerm" }

    /** Gets the node corresponding to the field `cond`. */
    final AstNode getCond() { ql_if_term_def(this, result, _, _) }

    /** Gets the node corresponding to the field `first`. */
    final AstNode getFirst() { ql_if_term_def(this, _, result, _) }

    /** Gets the node corresponding to the field `second`. */
    final AstNode getSecond() { ql_if_term_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_if_term_def(this, result, _, _) or
      ql_if_term_def(this, _, result, _) or
      ql_if_term_def(this, _, _, result)
    }
  }

  /** A class representing `implication` nodes. */
  final class Implication extends @ql_implication, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Implication" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_implication_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_implication_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_implication_def(this, result, _) or ql_implication_def(this, _, result)
    }
  }

  /** A class representing `importDirective` nodes. */
  final class ImportDirective extends @ql_import_directive, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDirective" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_import_directive_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_import_directive_child(this, _, result) }
  }

  /** A class representing `importModuleExpr` nodes. */
  final class ImportModuleExpr extends @ql_import_module_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportModuleExpr" }

    /** Gets the node corresponding to the field `qualName`. */
    final SimpleId getQualName(int i) { ql_import_module_expr_qual_name(this, i, result) }

    /** Gets the child of this node. */
    final ModuleExpr getChild() { ql_import_module_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_import_module_expr_qual_name(this, _, result) or ql_import_module_expr_def(this, result)
    }
  }

  /** A class representing `in_expr` nodes. */
  final class InExpr extends @ql_in_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InExpr" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_in_expr_def(this, result, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_in_expr_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_in_expr_def(this, result, _) or ql_in_expr_def(this, _, result)
    }
  }

  /** A class representing `instance_of` nodes. */
  final class InstanceOf extends @ql_instance_of, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InstanceOf" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_instance_of_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_instance_of_child(this, _, result) }
  }

  /** A class representing `integer` tokens. */
  final class Integer extends @ql_token_integer, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  final class LineComment extends @ql_token_line_comment, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `literal` nodes. */
  final class Literal extends @ql_literal, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Literal" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_literal_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_literal_def(this, result) }
  }

  /** A class representing `literalId` tokens. */
  final class LiteralId extends @ql_token_literal_id, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LiteralId" }
  }

  /** A class representing `memberPredicate` nodes. */
  final class MemberPredicate extends @ql_member_predicate, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MemberPredicate" }

    /** Gets the node corresponding to the field `name`. */
    final PredicateName getName() { ql_member_predicate_def(this, result, _) }

    /** Gets the node corresponding to the field `returnType`. */
    final AstNode getReturnType() { ql_member_predicate_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_member_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_member_predicate_def(this, result, _) or
      ql_member_predicate_def(this, _, result) or
      ql_member_predicate_child(this, _, result)
    }
  }

  /** A class representing `module` nodes. */
  final class Module extends @ql_module, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Module" }

    /** Gets the node corresponding to the field `implements`. */
    final SignatureExpr getImplements(int i) { ql_module_implements(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    final ModuleName getName() { ql_module_def(this, result) }

    /** Gets the node corresponding to the field `parameter`. */
    final ModuleParam getParameter(int i) { ql_module_parameter(this, i, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_module_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_module_implements(this, _, result) or
      ql_module_def(this, result) or
      ql_module_parameter(this, _, result) or
      ql_module_child(this, _, result)
    }
  }

  /** A class representing `moduleAliasBody` nodes. */
  final class ModuleAliasBody extends @ql_module_alias_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleAliasBody" }

    /** Gets the child of this node. */
    final ModuleExpr getChild() { ql_module_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_alias_body_def(this, result) }
  }

  /** A class representing `moduleExpr` nodes. */
  final class ModuleExpr extends @ql_module_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleExpr" }

    /** Gets the node corresponding to the field `name`. */
    final AstNode getName() { ql_module_expr_name(this, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_module_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_module_expr_name(this, result) or ql_module_expr_def(this, result)
    }
  }

  /** A class representing `moduleInstantiation` nodes. */
  final class ModuleInstantiation extends @ql_module_instantiation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleInstantiation" }

    /** Gets the node corresponding to the field `name`. */
    final ModuleName getName() { ql_module_instantiation_def(this, result) }

    /** Gets the `i`th child of this node. */
    final SignatureExpr getChild(int i) { ql_module_instantiation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_module_instantiation_def(this, result) or ql_module_instantiation_child(this, _, result)
    }
  }

  /** A class representing `moduleMember` nodes. */
  final class ModuleMember extends @ql_module_member, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleMember" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_module_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_member_child(this, _, result) }
  }

  /** A class representing `moduleName` nodes. */
  final class ModuleName extends @ql_module_name, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { ql_module_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_name_def(this, result) }
  }

  /** A class representing `moduleParam` nodes. */
  final class ModuleParam extends @ql_module_param, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleParam" }

    /** Gets the node corresponding to the field `parameter`. */
    final SimpleId getParameter() { ql_module_param_def(this, result, _) }

    /** Gets the node corresponding to the field `signature`. */
    final SignatureExpr getSignature() { ql_module_param_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_module_param_def(this, result, _) or ql_module_param_def(this, _, result)
    }
  }

  /** A class representing `mul_expr` nodes. */
  final class MulExpr extends @ql_mul_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "MulExpr" }

    /** Gets the node corresponding to the field `left`. */
    final AstNode getLeft() { ql_mul_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    final AstNode getRight() { ql_mul_expr_def(this, _, result, _) }

    /** Gets the child of this node. */
    final Mulop getChild() { ql_mul_expr_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_mul_expr_def(this, result, _, _) or
      ql_mul_expr_def(this, _, result, _) or
      ql_mul_expr_def(this, _, _, result)
    }
  }

  /** A class representing `mulop` tokens. */
  final class Mulop extends @ql_token_mulop, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Mulop" }
  }

  /** A class representing `negation` nodes. */
  final class Negation extends @ql_negation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Negation" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_negation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_negation_def(this, result) }
  }

  /** A class representing `orderBy` nodes. */
  final class OrderBy extends @ql_order_by, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBy" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_order_by_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_order_by_child(this, _, result) }
  }

  /** A class representing `orderBys` nodes. */
  final class OrderBys extends @ql_order_bys, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBys" }

    /** Gets the `i`th child of this node. */
    final OrderBy getChild(int i) { ql_order_bys_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_order_bys_child(this, _, result) }
  }

  /** A class representing `par_expr` nodes. */
  final class ParExpr extends @ql_par_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParExpr" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_par_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_par_expr_def(this, result) }
  }

  /** A class representing `predicate` tokens. */
  final class Predicate extends @ql_token_predicate, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Predicate" }
  }

  /** A class representing `predicateAliasBody` nodes. */
  final class PredicateAliasBody extends @ql_predicate_alias_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateAliasBody" }

    /** Gets the child of this node. */
    final PredicateExpr getChild() { ql_predicate_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_predicate_alias_body_def(this, result) }
  }

  /** A class representing `predicateExpr` nodes. */
  final class PredicateExpr extends @ql_predicate_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_predicate_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_predicate_expr_child(this, _, result) }
  }

  /** A class representing `predicateName` tokens. */
  final class PredicateName extends @ql_token_predicate_name, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateName" }
  }

  /** A class representing `prefix_cast` nodes. */
  final class PrefixCast extends @ql_prefix_cast, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixCast" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_prefix_cast_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_prefix_cast_child(this, _, result) }
  }

  /** A class representing `primitiveType` tokens. */
  final class PrimitiveType extends @ql_token_primitive_type, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrimitiveType" }
  }

  /** A class representing `ql` nodes. */
  final class Ql extends @ql_ql, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ql" }

    /** Gets the `i`th child of this node. */
    final ModuleMember getChild(int i) { ql_ql_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_ql_child(this, _, result) }
  }

  /** A class representing `qldoc` tokens. */
  final class Qldoc extends @ql_token_qldoc, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `qualifiedRhs` nodes. */
  final class QualifiedRhs extends @ql_qualified_rhs, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "QualifiedRhs" }

    /** Gets the node corresponding to the field `name`. */
    final PredicateName getName() { ql_qualified_rhs_name(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_qualified_rhs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_qualified_rhs_name(this, result) or ql_qualified_rhs_child(this, _, result)
    }
  }

  /** A class representing `qualified_expr` nodes. */
  final class QualifiedExpr extends @ql_qualified_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "QualifiedExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_qualified_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_qualified_expr_child(this, _, result) }
  }

  /** A class representing `quantified` nodes. */
  final class Quantified extends @ql_quantified, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Quantified" }

    /** Gets the node corresponding to the field `expr`. */
    final AstNode getExpr() { ql_quantified_expr(this, result) }

    /** Gets the node corresponding to the field `formula`. */
    final AstNode getFormula() { ql_quantified_formula(this, result) }

    /** Gets the node corresponding to the field `range`. */
    final AstNode getRange() { ql_quantified_range(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_quantified_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_quantified_expr(this, result) or
      ql_quantified_formula(this, result) or
      ql_quantified_range(this, result) or
      ql_quantified_child(this, _, result)
    }
  }

  /** A class representing `quantifier` tokens. */
  final class Quantifier extends @ql_token_quantifier, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Quantifier" }
  }

  /** A class representing `range` nodes. */
  final class Range extends @ql_range, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Range" }

    /** Gets the node corresponding to the field `lower`. */
    final AstNode getLower() { ql_range_def(this, result, _) }

    /** Gets the node corresponding to the field `upper`. */
    final AstNode getUpper() { ql_range_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_range_def(this, result, _) or ql_range_def(this, _, result)
    }
  }

  /** A class representing `result` tokens. */
  final class Result extends @ql_token_result, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Result" }
  }

  /** A class representing `select` nodes. */
  final class Select extends @ql_select, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Select" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_select_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_select_child(this, _, result) }
  }

  /** A class representing `set_literal` nodes. */
  final class SetLiteral extends @ql_set_literal, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SetLiteral" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_set_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_set_literal_child(this, _, result) }
  }

  /** A class representing `signatureExpr` nodes. */
  final class SignatureExpr extends @ql_signature_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SignatureExpr" }

    /** Gets the node corresponding to the field `mod_expr`. */
    final ModuleExpr getModExpr() { ql_signature_expr_mod_expr(this, result) }

    /** Gets the node corresponding to the field `predicate`. */
    final PredicateExpr getPredicate() { ql_signature_expr_predicate(this, result) }

    /** Gets the node corresponding to the field `type_expr`. */
    final TypeExpr getTypeExpr() { ql_signature_expr_type_expr(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_signature_expr_mod_expr(this, result) or
      ql_signature_expr_predicate(this, result) or
      ql_signature_expr_type_expr(this, result)
    }
  }

  /** A class representing `simpleId` tokens. */
  final class SimpleId extends @ql_token_simple_id, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `specialId` tokens. */
  final class SpecialId extends @ql_token_special_id, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialId" }
  }

  /** A class representing `special_call` nodes. */
  final class SpecialCall extends @ql_special_call, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialCall" }

    /** Gets the child of this node. */
    final SpecialId getChild() { ql_special_call_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_special_call_def(this, result) }
  }

  /** A class representing `string` tokens. */
  final class String extends @ql_token_string, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `super` tokens. */
  final class Super extends @ql_token_super, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `super_ref` nodes. */
  final class SuperRef extends @ql_super_ref, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuperRef" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_super_ref_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_super_ref_child(this, _, result) }
  }

  /** A class representing `this` tokens. */
  final class This extends @ql_token_this, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "This" }
  }

  /** A class representing `true` tokens. */
  final class True extends @ql_token_true, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `typeAliasBody` nodes. */
  final class TypeAliasBody extends @ql_type_alias_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAliasBody" }

    /** Gets the child of this node. */
    final TypeExpr getChild() { ql_type_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_type_alias_body_def(this, result) }
  }

  /** A class representing `typeExpr` nodes. */
  final class TypeExpr extends @ql_type_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeExpr" }

    /** Gets the node corresponding to the field `name`. */
    final ClassName getName() { ql_type_expr_name(this, result) }

    /** Gets the node corresponding to the field `qualifier`. */
    final ModuleExpr getQualifier() { ql_type_expr_qualifier(this, result) }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_type_expr_child(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_type_expr_name(this, result) or
      ql_type_expr_qualifier(this, result) or
      ql_type_expr_child(this, result)
    }
  }

  /** A class representing `typeUnionBody` nodes. */
  final class TypeUnionBody extends @ql_type_union_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeUnionBody" }

    /** Gets the `i`th child of this node. */
    final TypeExpr getChild(int i) { ql_type_union_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_type_union_body_child(this, _, result) }
  }

  /** A class representing `unary_expr` nodes. */
  final class UnaryExpr extends @ql_unary_expr, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnaryExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_unary_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_unary_expr_child(this, _, result) }
  }

  /** A class representing `underscore` tokens. */
  final class Underscore extends @ql_token_underscore, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Underscore" }
  }

  /** A class representing `unop` tokens. */
  final class Unop extends @ql_token_unop, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unop" }
  }

  /** A class representing `unqual_agg_body` nodes. */
  final class UnqualAggBody extends @ql_unqual_agg_body, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnqualAggBody" }

    /** Gets the node corresponding to the field `asExprs`. */
    final AstNode getAsExprs(int i) { ql_unqual_agg_body_as_exprs(this, i, result) }

    /** Gets the node corresponding to the field `guard`. */
    final AstNode getGuard() { ql_unqual_agg_body_guard(this, result) }

    /** Gets the `i`th child of this node. */
    final VarDecl getChild(int i) { ql_unqual_agg_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      ql_unqual_agg_body_as_exprs(this, _, result) or
      ql_unqual_agg_body_guard(this, result) or
      ql_unqual_agg_body_child(this, _, result)
    }
  }

  /** A class representing `varDecl` nodes. */
  final class VarDecl extends @ql_var_decl, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarDecl" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_var_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_var_decl_child(this, _, result) }
  }

  /** A class representing `varName` nodes. */
  final class VarName extends @ql_var_name, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { ql_var_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_var_name_def(this, result) }
  }

  /** A class representing `variable` nodes. */
  final class Variable extends @ql_variable, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Variable" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_variable_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_variable_def(this, result) }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    AstNode getChild(AstNode node, string name, int i) {
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

overlay[local]
module Dbscheme {
  /** The base class for all AST nodes */
  private class AstNodeImpl extends @dbscheme_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { dbscheme_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { dbscheme_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { dbscheme_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  final class AstNode = AstNodeImpl;

  /** A token. */
  private class TokenImpl extends @dbscheme_token, AstNodeImpl {
    /** Gets the value of this token. */
    final string getValue() { dbscheme_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  final class Token = TokenImpl;

  /** A reserved word. */
  final class ReservedWord extends @dbscheme_reserved_word, TokenImpl {
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
  final class AnnotName extends @dbscheme_token_annot_name, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  final class Annotation extends @dbscheme_annotation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Annotation" }

    /** Gets the node corresponding to the field `argsAnnotation`. */
    final ArgsAnnotation getArgsAnnotation() { dbscheme_annotation_args_annotation(this, result) }

    /** Gets the node corresponding to the field `simpleAnnotation`. */
    final AnnotName getSimpleAnnotation() { dbscheme_annotation_simple_annotation(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_annotation_args_annotation(this, result) or
      dbscheme_annotation_simple_annotation(this, result)
    }
  }

  /** A class representing `argsAnnotation` nodes. */
  final class ArgsAnnotation extends @dbscheme_args_annotation, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ArgsAnnotation" }

    /** Gets the node corresponding to the field `name`. */
    final AnnotName getName() { dbscheme_args_annotation_def(this, result) }

    /** Gets the `i`th child of this node. */
    final SimpleId getChild(int i) { dbscheme_args_annotation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_args_annotation_def(this, result) or dbscheme_args_annotation_child(this, _, result)
    }
  }

  /** A class representing `block_comment` tokens. */
  final class BlockComment extends @dbscheme_token_block_comment, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `boolean` tokens. */
  final class Boolean extends @dbscheme_token_boolean, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Boolean" }
  }

  /** A class representing `branch` nodes. */
  final class Branch extends @dbscheme_branch, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Branch" }

    /** Gets the node corresponding to the field `qldoc`. */
    final Qldoc getQldoc() { dbscheme_branch_qldoc(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { dbscheme_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_branch_qldoc(this, result) or dbscheme_branch_child(this, _, result)
    }
  }

  /** A class representing `caseDecl` nodes. */
  final class CaseDecl extends @dbscheme_case_decl, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CaseDecl" }

    /** Gets the node corresponding to the field `base`. */
    final Dbtype getBase() { dbscheme_case_decl_def(this, result, _) }

    /** Gets the node corresponding to the field `discriminator`. */
    final SimpleId getDiscriminator() { dbscheme_case_decl_def(this, _, result) }

    /** Gets the `i`th child of this node. */
    final Branch getChild(int i) { dbscheme_case_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_case_decl_def(this, result, _) or
      dbscheme_case_decl_def(this, _, result) or
      dbscheme_case_decl_child(this, _, result)
    }
  }

  /** A class representing `colType` nodes. */
  final class ColType extends @dbscheme_col_type, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ColType" }

    /** Gets the child of this node. */
    final AstNode getChild() { dbscheme_col_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_col_type_def(this, result) }
  }

  /** A class representing `column` nodes. */
  final class Column extends @dbscheme_column, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Column" }

    /** Gets the node corresponding to the field `colName`. */
    final SimpleId getColName() { dbscheme_column_def(this, result, _, _) }

    /** Gets the node corresponding to the field `colType`. */
    final ColType getColType() { dbscheme_column_def(this, _, result, _) }

    /** Gets the node corresponding to the field `isRef`. */
    final Ref getIsRef() { dbscheme_column_is_ref(this, result) }

    /** Gets the node corresponding to the field `isUnique`. */
    final Unique getIsUnique() { dbscheme_column_is_unique(this, result) }

    /** Gets the node corresponding to the field `qldoc`. */
    final Qldoc getQldoc() { dbscheme_column_qldoc(this, result) }

    /** Gets the node corresponding to the field `reprType`. */
    final ReprType getReprType() { dbscheme_column_def(this, _, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_column_def(this, result, _, _) or
      dbscheme_column_def(this, _, result, _) or
      dbscheme_column_is_ref(this, result) or
      dbscheme_column_is_unique(this, result) or
      dbscheme_column_qldoc(this, result) or
      dbscheme_column_def(this, _, _, result)
    }
  }

  /** A class representing `date` tokens. */
  final class Date extends @dbscheme_token_date, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `dbscheme` nodes. */
  final class Dbscheme extends @dbscheme_dbscheme, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbscheme" }

    /** Gets the `i`th child of this node. */
    final Entry getChild(int i) { dbscheme_dbscheme_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_dbscheme_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  final class Dbtype extends @dbscheme_token_dbtype, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `entry` nodes. */
  final class Entry extends @dbscheme_entry, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Entry" }

    /** Gets the child of this node. */
    final AstNode getChild() { dbscheme_entry_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_entry_def(this, result) }
  }

  /** A class representing `float` tokens. */
  final class Float extends @dbscheme_token_float, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `int` tokens. */
  final class Int extends @dbscheme_token_int, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Int" }
  }

  /** A class representing `integer` tokens. */
  final class Integer extends @dbscheme_token_integer, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  final class LineComment extends @dbscheme_token_line_comment, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `qldoc` tokens. */
  final class Qldoc extends @dbscheme_token_qldoc, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `ref` tokens. */
  final class Ref extends @dbscheme_token_ref, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ref" }
  }

  /** A class representing `reprType` nodes. */
  final class ReprType extends @dbscheme_repr_type, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReprType" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { dbscheme_repr_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_repr_type_child(this, _, result) }
  }

  /** A class representing `simpleId` tokens. */
  final class SimpleId extends @dbscheme_token_simple_id, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `string` tokens. */
  final class String extends @dbscheme_token_string, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `table` nodes. */
  final class Table extends @dbscheme_table, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Table" }

    /** Gets the node corresponding to the field `tableName`. */
    final TableName getTableName() { dbscheme_table_def(this, result) }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { dbscheme_table_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_table_def(this, result) or dbscheme_table_child(this, _, result)
    }
  }

  /** A class representing `tableName` nodes. */
  final class TableName extends @dbscheme_table_name, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TableName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { dbscheme_table_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_table_name_def(this, result) }
  }

  /** A class representing `unionDecl` nodes. */
  final class UnionDecl extends @dbscheme_union_decl, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnionDecl" }

    /** Gets the node corresponding to the field `base`. */
    final Dbtype getBase() { dbscheme_union_decl_def(this, result) }

    /** Gets the `i`th child of this node. */
    final Dbtype getChild(int i) { dbscheme_union_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      dbscheme_union_decl_def(this, result) or dbscheme_union_decl_child(this, _, result)
    }
  }

  /** A class representing `unique` tokens. */
  final class Unique extends @dbscheme_token_unique, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unique" }
  }

  /** A class representing `varchar` tokens. */
  final class Varchar extends @dbscheme_token_varchar, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Varchar" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    AstNode getChild(AstNode node, string name, int i) {
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

overlay[local]
module Blame {
  /** The base class for all AST nodes */
  private class AstNodeImpl extends @blame_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { blame_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { blame_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { blame_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  final class AstNode = AstNodeImpl;

  /** A token. */
  private class TokenImpl extends @blame_token, AstNodeImpl {
    /** Gets the value of this token. */
    final string getValue() { blame_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  final class Token = TokenImpl;

  /** A reserved word. */
  final class ReservedWord extends @blame_reserved_word, TokenImpl {
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
  final class BlameEntry extends @blame_blame_entry, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlameEntry" }

    /** Gets the node corresponding to the field `date`. */
    final Date getDate() { blame_blame_entry_def(this, result) }

    /** Gets the node corresponding to the field `line`. */
    final Number getLine(int i) { blame_blame_entry_line(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      blame_blame_entry_def(this, result) or blame_blame_entry_line(this, _, result)
    }
  }

  /** A class representing `blame_info` nodes. */
  final class BlameInfo extends @blame_blame_info, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlameInfo" }

    /** Gets the node corresponding to the field `file_entry`. */
    final FileEntry getFileEntry(int i) { blame_blame_info_file_entry(this, i, result) }

    /** Gets the node corresponding to the field `today`. */
    final Date getToday() { blame_blame_info_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      blame_blame_info_file_entry(this, _, result) or blame_blame_info_def(this, result)
    }
  }

  /** A class representing `date` tokens. */
  final class Date extends @blame_token_date, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `file_entry` nodes. */
  final class FileEntry extends @blame_file_entry, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "FileEntry" }

    /** Gets the node corresponding to the field `blame_entry`. */
    final BlameEntry getBlameEntry(int i) { blame_file_entry_blame_entry(this, i, result) }

    /** Gets the node corresponding to the field `file_name`. */
    final Filename getFileName() { blame_file_entry_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      blame_file_entry_blame_entry(this, _, result) or blame_file_entry_def(this, result)
    }
  }

  /** A class representing `filename` tokens. */
  final class Filename extends @blame_token_filename, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Filename" }
  }

  /** A class representing `number` tokens. */
  final class Number extends @blame_token_number, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    AstNode getChild(AstNode node, string name, int i) {
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

overlay[local]
module JSON {
  /** The base class for all AST nodes */
  private class AstNodeImpl extends @json_ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    final L::Location getLocation() { json_ast_node_location(this, result) }

    /** Gets the parent of this element. */
    final AstNode getParent() { json_ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    final int getParentIndex() { json_ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }

    /** Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs. */
    string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  final class AstNode = AstNodeImpl;

  /** A token. */
  private class TokenImpl extends @json_token, AstNodeImpl {
    /** Gets the value of this token. */
    final string getValue() { json_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  final class Token = TokenImpl;

  /** A reserved word. */
  final class ReservedWord extends @json_reserved_word, TokenImpl {
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

  final class UnderscoreValue extends @json_underscore_value, AstNodeImpl { }

  /** A class representing `array` nodes. */
  final class Array extends @json_array, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Array" }

    /** Gets the `i`th child of this node. */
    final UnderscoreValue getChild(int i) { json_array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_array_child(this, _, result) }
  }

  /** A class representing `comment` tokens. */
  final class Comment extends @json_token_comment, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `document` nodes. */
  final class Document extends @json_document, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Document" }

    /** Gets the `i`th child of this node. */
    final UnderscoreValue getChild(int i) { json_document_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_document_child(this, _, result) }
  }

  /** A class representing `escape_sequence` tokens. */
  final class EscapeSequence extends @json_token_escape_sequence, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  /** A class representing `false` tokens. */
  final class False extends @json_token_false, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `null` tokens. */
  final class Null extends @json_token_null, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Null" }
  }

  /** A class representing `number` tokens. */
  final class Number extends @json_token_number, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }

  /** A class representing `object` nodes. */
  final class Object extends @json_object, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Object" }

    /** Gets the `i`th child of this node. */
    final Pair getChild(int i) { json_object_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_object_child(this, _, result) }
  }

  /** A class representing `pair` nodes. */
  final class Pair extends @json_pair, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Pair" }

    /** Gets the node corresponding to the field `key`. */
    final String getKey() { json_pair_def(this, result, _) }

    /** Gets the node corresponding to the field `value`. */
    final UnderscoreValue getValue() { json_pair_def(this, _, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() {
      json_pair_def(this, result, _) or json_pair_def(this, _, result)
    }
  }

  /** A class representing `string` nodes. */
  final class String extends @json_string__, AstNodeImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { json_string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_string_child(this, _, result) }
  }

  /** A class representing `string_content` tokens. */
  final class StringContent extends @json_token_string_content, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringContent" }
  }

  /** A class representing `true` tokens. */
  final class True extends @json_token_true, TokenImpl {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** Provides predicates for mapping AST nodes to their named children. */
  module PrintAst {
    /** Gets a child of `node` returned by the member predicate with the given `name`. If the predicate takes an index argument, `i` is bound to that index, otherwise `i` is `-1` (which is never a valid index). */
    AstNode getChild(AstNode node, string name, int i) {
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
