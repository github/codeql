/**
 * CodeQL library for QL
 * Automatically generated from the tree-sitter grammar; do not edit
 */

import codeql.Locations as L

module QL {
  /** The base class for all AST nodes */
  class AstNode extends @ql_ast_node {
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

  /** A token. */
  class Token extends @ql_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { ql_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @ql_reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** A class representing `add_expr` nodes. */
  class AddExpr extends @ql_add_expr, AstNode {
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
  class Addop extends @ql_token_addop, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Addop" }
  }

  /** A class representing `aggId` tokens. */
  class AggId extends @ql_token_agg_id, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AggId" }
  }

  /** A class representing `aggregate` nodes. */
  class Aggregate extends @ql_aggregate, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Aggregate" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_aggregate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_aggregate_child(this, _, result) }
  }

  /** A class representing `annotArg` nodes. */
  class AnnotArg extends @ql_annot_arg, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotArg" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_annot_arg_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_annot_arg_def(this, result) }
  }

  /** A class representing `annotName` tokens. */
  class AnnotName extends @ql_token_annot_name, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  class Annotation extends @ql_annotation, AstNode {
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
  class AritylessPredicateExpr extends @ql_arityless_predicate_expr, AstNode {
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
  class AsExpr extends @ql_as_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_as_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_as_expr_child(this, _, result) }
  }

  /** A class representing `asExprs` nodes. */
  class AsExprs extends @ql_as_exprs, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AsExprs" }

    /** Gets the `i`th child of this node. */
    final AsExpr getChild(int i) { ql_as_exprs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_as_exprs_child(this, _, result) }
  }

  /** A class representing `block_comment` tokens. */
  class BlockComment extends @ql_token_block_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `body` nodes. */
  class Body extends @ql_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Body" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_body_def(this, result) }
  }

  /** A class representing `bool` nodes. */
  class Bool extends @ql_bool, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Bool" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_bool_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_bool_def(this, result) }
  }

  /** A class representing `call_body` nodes. */
  class CallBody extends @ql_call_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallBody" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_call_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_call_body_child(this, _, result) }
  }

  /** A class representing `call_or_unqual_agg_expr` nodes. */
  class CallOrUnqualAggExpr extends @ql_call_or_unqual_agg_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "CallOrUnqualAggExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_call_or_unqual_agg_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_call_or_unqual_agg_expr_child(this, _, result) }
  }

  /** A class representing `charpred` nodes. */
  class Charpred extends @ql_charpred, AstNode {
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
  class ClassMember extends @ql_class_member, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassMember" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_class_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_class_member_child(this, _, result) }
  }

  /** A class representing `className` tokens. */
  class ClassName extends @ql_token_class_name, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ClassName" }
  }

  /** A class representing `classlessPredicate` nodes. */
  class ClasslessPredicate extends @ql_classless_predicate, AstNode {
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
  class Closure extends @ql_token_closure, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Closure" }
  }

  /** A class representing `comp_term` nodes. */
  class CompTerm extends @ql_comp_term, AstNode {
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
  class Compop extends @ql_token_compop, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Compop" }
  }

  /** A class representing `conjunction` nodes. */
  class Conjunction extends @ql_conjunction, AstNode {
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
  class Dataclass extends @ql_dataclass, AstNode {
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
  class Datatype extends @ql_datatype, AstNode {
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
  class DatatypeBranch extends @ql_datatype_branch, AstNode {
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
  class DatatypeBranches extends @ql_datatype_branches, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "DatatypeBranches" }

    /** Gets the `i`th child of this node. */
    final DatatypeBranch getChild(int i) { ql_datatype_branches_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_datatype_branches_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  class Dbtype extends @ql_token_dbtype, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `direction` tokens. */
  class Direction extends @ql_token_direction, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Direction" }
  }

  /** A class representing `disjunction` nodes. */
  class Disjunction extends @ql_disjunction, AstNode {
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
  class Empty extends @ql_token_empty, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Empty" }
  }

  /** A class representing `expr_aggregate_body` nodes. */
  class ExprAggregateBody extends @ql_expr_aggregate_body, AstNode {
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
  class ExprAnnotation extends @ql_expr_annotation, AstNode {
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
  class False extends @ql_token_false, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `field` nodes. */
  class Field extends @ql_field, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Field" }

    /** Gets the child of this node. */
    final VarDecl getChild() { ql_field_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_field_def(this, result) }
  }

  /** A class representing `float` tokens. */
  class Float extends @ql_token_float, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `full_aggregate_body` nodes. */
  class FullAggregateBody extends @ql_full_aggregate_body, AstNode {
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
  class HigherOrderTerm extends @ql_higher_order_term, AstNode {
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
  class IfTerm extends @ql_if_term, AstNode {
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
  class Implication extends @ql_implication, AstNode {
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
  class ImportDirective extends @ql_import_directive, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ImportDirective" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_import_directive_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_import_directive_child(this, _, result) }
  }

  /** A class representing `importModuleExpr` nodes. */
  class ImportModuleExpr extends @ql_import_module_expr, AstNode {
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
  class InExpr extends @ql_in_expr, AstNode {
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
  class InstanceOf extends @ql_instance_of, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "InstanceOf" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_instance_of_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_instance_of_child(this, _, result) }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @ql_token_integer, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  class LineComment extends @ql_token_line_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `literal` nodes. */
  class Literal extends @ql_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Literal" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_literal_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_literal_def(this, result) }
  }

  /** A class representing `literalId` tokens. */
  class LiteralId extends @ql_token_literal_id, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LiteralId" }
  }

  /** A class representing `memberPredicate` nodes. */
  class MemberPredicate extends @ql_member_predicate, AstNode {
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
  class Module extends @ql_module, AstNode {
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
  class ModuleAliasBody extends @ql_module_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleAliasBody" }

    /** Gets the child of this node. */
    final ModuleExpr getChild() { ql_module_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_alias_body_def(this, result) }
  }

  /** A class representing `moduleExpr` nodes. */
  class ModuleExpr extends @ql_module_expr, AstNode {
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
  class ModuleInstantiation extends @ql_module_instantiation, AstNode {
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
  class ModuleMember extends @ql_module_member, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleMember" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_module_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_member_child(this, _, result) }
  }

  /** A class representing `moduleName` nodes. */
  class ModuleName extends @ql_module_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ModuleName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { ql_module_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_module_name_def(this, result) }
  }

  /** A class representing `moduleParam` nodes. */
  class ModuleParam extends @ql_module_param, AstNode {
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
  class MulExpr extends @ql_mul_expr, AstNode {
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
  class Mulop extends @ql_token_mulop, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Mulop" }
  }

  /** A class representing `negation` nodes. */
  class Negation extends @ql_negation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Negation" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_negation_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_negation_def(this, result) }
  }

  /** A class representing `orderBy` nodes. */
  class OrderBy extends @ql_order_by, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBy" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_order_by_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_order_by_child(this, _, result) }
  }

  /** A class representing `orderBys` nodes. */
  class OrderBys extends @ql_order_bys, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "OrderBys" }

    /** Gets the `i`th child of this node. */
    final OrderBy getChild(int i) { ql_order_bys_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_order_bys_child(this, _, result) }
  }

  /** A class representing `par_expr` nodes. */
  class ParExpr extends @ql_par_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ParExpr" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_par_expr_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_par_expr_def(this, result) }
  }

  /** A class representing `predicate` tokens. */
  class Predicate extends @ql_token_predicate, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Predicate" }
  }

  /** A class representing `predicateAliasBody` nodes. */
  class PredicateAliasBody extends @ql_predicate_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateAliasBody" }

    /** Gets the child of this node. */
    final PredicateExpr getChild() { ql_predicate_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_predicate_alias_body_def(this, result) }
  }

  /** A class representing `predicateExpr` nodes. */
  class PredicateExpr extends @ql_predicate_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_predicate_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_predicate_expr_child(this, _, result) }
  }

  /** A class representing `predicateName` tokens. */
  class PredicateName extends @ql_token_predicate_name, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PredicateName" }
  }

  /** A class representing `prefix_cast` nodes. */
  class PrefixCast extends @ql_prefix_cast, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrefixCast" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_prefix_cast_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_prefix_cast_child(this, _, result) }
  }

  /** A class representing `primitiveType` tokens. */
  class PrimitiveType extends @ql_token_primitive_type, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "PrimitiveType" }
  }

  /** A class representing `ql` nodes. */
  class Ql extends @ql_ql, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ql" }

    /** Gets the `i`th child of this node. */
    final ModuleMember getChild(int i) { ql_ql_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_ql_child(this, _, result) }
  }

  /** A class representing `qldoc` tokens. */
  class Qldoc extends @ql_token_qldoc, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `qualifiedRhs` nodes. */
  class QualifiedRhs extends @ql_qualified_rhs, AstNode {
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
  class QualifiedExpr extends @ql_qualified_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "QualifiedExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_qualified_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_qualified_expr_child(this, _, result) }
  }

  /** A class representing `quantified` nodes. */
  class Quantified extends @ql_quantified, AstNode {
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
  class Quantifier extends @ql_token_quantifier, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Quantifier" }
  }

  /** A class representing `range` nodes. */
  class Range extends @ql_range, AstNode {
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
  class Result extends @ql_token_result, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Result" }
  }

  /** A class representing `select` nodes. */
  class Select extends @ql_select, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Select" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_select_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_select_child(this, _, result) }
  }

  /** A class representing `set_literal` nodes. */
  class SetLiteral extends @ql_set_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SetLiteral" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_set_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_set_literal_child(this, _, result) }
  }

  /** A class representing `signatureExpr` nodes. */
  class SignatureExpr extends @ql_signature_expr, AstNode {
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
  class SimpleId extends @ql_token_simple_id, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `specialId` tokens. */
  class SpecialId extends @ql_token_special_id, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialId" }
  }

  /** A class representing `special_call` nodes. */
  class SpecialCall extends @ql_special_call, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SpecialCall" }

    /** Gets the child of this node. */
    final SpecialId getChild() { ql_special_call_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_special_call_def(this, result) }
  }

  /** A class representing `string` tokens. */
  class String extends @ql_token_string, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `super` tokens. */
  class Super extends @ql_token_super, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `super_ref` nodes. */
  class SuperRef extends @ql_super_ref, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SuperRef" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_super_ref_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_super_ref_child(this, _, result) }
  }

  /** A class representing `this` tokens. */
  class This extends @ql_token_this, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "This" }
  }

  /** A class representing `true` tokens. */
  class True extends @ql_token_true, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `typeAliasBody` nodes. */
  class TypeAliasBody extends @ql_type_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeAliasBody" }

    /** Gets the child of this node. */
    final TypeExpr getChild() { ql_type_alias_body_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_type_alias_body_def(this, result) }
  }

  /** A class representing `typeExpr` nodes. */
  class TypeExpr extends @ql_type_expr, AstNode {
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
  class TypeUnionBody extends @ql_type_union_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TypeUnionBody" }

    /** Gets the `i`th child of this node. */
    final TypeExpr getChild(int i) { ql_type_union_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_type_union_body_child(this, _, result) }
  }

  /** A class representing `unary_expr` nodes. */
  class UnaryExpr extends @ql_unary_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "UnaryExpr" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_unary_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_unary_expr_child(this, _, result) }
  }

  /** A class representing `underscore` tokens. */
  class Underscore extends @ql_token_underscore, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Underscore" }
  }

  /** A class representing `unop` tokens. */
  class Unop extends @ql_token_unop, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unop" }
  }

  /** A class representing `unqual_agg_body` nodes. */
  class UnqualAggBody extends @ql_unqual_agg_body, AstNode {
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
  class VarDecl extends @ql_var_decl, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarDecl" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { ql_var_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_var_decl_child(this, _, result) }
  }

  /** A class representing `varName` nodes. */
  class VarName extends @ql_var_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "VarName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { ql_var_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_var_name_def(this, result) }
  }

  /** A class representing `variable` nodes. */
  class Variable extends @ql_variable, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Variable" }

    /** Gets the child of this node. */
    final AstNode getChild() { ql_variable_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { ql_variable_def(this, result) }
  }
}

module Dbscheme {
  /** The base class for all AST nodes */
  class AstNode extends @dbscheme_ast_node {
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

  /** A token. */
  class Token extends @dbscheme_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { dbscheme_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @dbscheme_reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** A class representing `annotName` tokens. */
  class AnnotName extends @dbscheme_token_annot_name, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  class Annotation extends @dbscheme_annotation, AstNode {
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
  class ArgsAnnotation extends @dbscheme_args_annotation, AstNode {
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
  class BlockComment extends @dbscheme_token_block_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `boolean` tokens. */
  class Boolean extends @dbscheme_token_boolean, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Boolean" }
  }

  /** A class representing `branch` nodes. */
  class Branch extends @dbscheme_branch, AstNode {
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
  class CaseDecl extends @dbscheme_case_decl, AstNode {
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
  class ColType extends @dbscheme_col_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ColType" }

    /** Gets the child of this node. */
    final AstNode getChild() { dbscheme_col_type_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_col_type_def(this, result) }
  }

  /** A class representing `column` nodes. */
  class Column extends @dbscheme_column, AstNode {
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
  class Date extends @dbscheme_token_date, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `dbscheme` nodes. */
  class Dbscheme extends @dbscheme_dbscheme, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbscheme" }

    /** Gets the `i`th child of this node. */
    final Entry getChild(int i) { dbscheme_dbscheme_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_dbscheme_child(this, _, result) }
  }

  /** A class representing `dbtype` tokens. */
  class Dbtype extends @dbscheme_token_dbtype, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `entry` nodes. */
  class Entry extends @dbscheme_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Entry" }

    /** Gets the child of this node. */
    final AstNode getChild() { dbscheme_entry_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_entry_def(this, result) }
  }

  /** A class representing `float` tokens. */
  class Float extends @dbscheme_token_float, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `int` tokens. */
  class Int extends @dbscheme_token_int, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Int" }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @dbscheme_token_integer, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  class LineComment extends @dbscheme_token_line_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `qldoc` tokens. */
  class Qldoc extends @dbscheme_token_qldoc, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `ref` tokens. */
  class Ref extends @dbscheme_token_ref, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Ref" }
  }

  /** A class representing `reprType` nodes. */
  class ReprType extends @dbscheme_repr_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReprType" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { dbscheme_repr_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_repr_type_child(this, _, result) }
  }

  /** A class representing `simpleId` tokens. */
  class SimpleId extends @dbscheme_token_simple_id, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `string` tokens. */
  class String extends @dbscheme_token_string, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `table` nodes. */
  class Table extends @dbscheme_table, AstNode {
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
  class TableName extends @dbscheme_table_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "TableName" }

    /** Gets the child of this node. */
    final SimpleId getChild() { dbscheme_table_name_def(this, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { dbscheme_table_name_def(this, result) }
  }

  /** A class representing `unionDecl` nodes. */
  class UnionDecl extends @dbscheme_union_decl, AstNode {
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
  class Unique extends @dbscheme_token_unique, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Unique" }
  }

  /** A class representing `varchar` tokens. */
  class Varchar extends @dbscheme_token_varchar, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Varchar" }
  }
}

module Blame {
  /** The base class for all AST nodes */
  class AstNode extends @blame_ast_node {
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

  /** A token. */
  class Token extends @blame_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { blame_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @blame_reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** A class representing `blame_entry` nodes. */
  class BlameEntry extends @blame_blame_entry, AstNode {
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
  class BlameInfo extends @blame_blame_info, AstNode {
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
  class Date extends @blame_token_date, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Date" }
  }

  /** A class representing `file_entry` nodes. */
  class FileEntry extends @blame_file_entry, AstNode {
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
  class Filename extends @blame_token_filename, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Filename" }
  }

  /** A class representing `number` tokens. */
  class Number extends @blame_token_number, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }
}

module JSON {
  /** The base class for all AST nodes */
  class AstNode extends @json_ast_node {
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

  /** A token. */
  class Token extends @json_token, AstNode {
    /** Gets the value of this token. */
    final string getValue() { json_tokeninfo(this, _, result) }

    /** Gets a string representation of this element. */
    final override string toString() { result = this.getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @json_reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  class UnderscoreValue extends @json_underscore_value, AstNode { }

  /** A class representing `array` nodes. */
  class Array extends @json_array, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Array" }

    /** Gets the `i`th child of this node. */
    final UnderscoreValue getChild(int i) { json_array_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_array_child(this, _, result) }
  }

  /** A class representing `comment` tokens. */
  class Comment extends @json_token_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Comment" }
  }

  /** A class representing `document` nodes. */
  class Document extends @json_document, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Document" }

    /** Gets the `i`th child of this node. */
    final UnderscoreValue getChild(int i) { json_document_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_document_child(this, _, result) }
  }

  /** A class representing `escape_sequence` tokens. */
  class EscapeSequence extends @json_token_escape_sequence, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "EscapeSequence" }
  }

  /** A class representing `false` tokens. */
  class False extends @json_token_false, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `null` tokens. */
  class Null extends @json_token_null, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Null" }
  }

  /** A class representing `number` tokens. */
  class Number extends @json_token_number, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Number" }
  }

  /** A class representing `object` nodes. */
  class Object extends @json_object, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "Object" }

    /** Gets the `i`th child of this node. */
    final Pair getChild(int i) { json_object_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_object_child(this, _, result) }
  }

  /** A class representing `pair` nodes. */
  class Pair extends @json_pair, AstNode {
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
  class String extends @json_string__, AstNode {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "String" }

    /** Gets the `i`th child of this node. */
    final AstNode getChild(int i) { json_string_child(this, i, result) }

    /** Gets a field or child node of this node. */
    final override AstNode getAFieldOrChild() { json_string_child(this, _, result) }
  }

  /** A class representing `string_content` tokens. */
  class StringContent extends @json_token_string_content, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "StringContent" }
  }

  /** A class representing `true` tokens. */
  class True extends @json_token_true, Token {
    /** Gets the name of the primary QL class for this element. */
    final override string getAPrimaryQlClass() { result = "True" }
  }
}
