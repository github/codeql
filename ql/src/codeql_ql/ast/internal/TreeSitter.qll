/*
 * CodeQL library for QL
 * Automatically generated from the tree-sitter grammar; do not edit
 */

module Generated {
  private import codeql.files.FileSystem
  private import codeql.Locations

  class AstNode extends @ast_node {
    string toString() { result = this.getAPrimaryQlClass() }

    Location getLocation() { none() }

    AstNode getParent() { ast_node_parent(this, result, _) }

    int getParentIndex() { ast_node_parent(this, _, result) }

    AstNode getAFieldOrChild() { none() }

    string getAPrimaryQlClass() { result = "???" }
  }

  class Token extends @token, AstNode {
    string getValue() { tokeninfo(this, _, _, _, result, _) }

    override Location getLocation() { tokeninfo(this, _, _, _, _, result) }

    override string toString() { result = getValue() }

    override string getAPrimaryQlClass() { result = "Token" }
  }

  class ReservedWord extends @reserved_word, Token {
    override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  class AddExpr extends @add_expr, AstNode {
    override string getAPrimaryQlClass() { result = "AddExpr" }

    override Location getLocation() { add_expr_def(this, _, _, _, result) }

    AstNode getLeft() { add_expr_def(this, result, _, _, _) }

    AstNode getRight() { add_expr_def(this, _, result, _, _) }

    Addop getChild() { add_expr_def(this, _, _, result, _) }

    override AstNode getAFieldOrChild() {
      add_expr_def(this, result, _, _, _) or
      add_expr_def(this, _, result, _, _) or
      add_expr_def(this, _, _, result, _)
    }
  }

  class Addop extends @token_addop, Token {
    override string getAPrimaryQlClass() { result = "Addop" }
  }

  class AggId extends @token_agg_id, Token {
    override string getAPrimaryQlClass() { result = "AggId" }
  }

  class Aggregate extends @aggregate, AstNode {
    override string getAPrimaryQlClass() { result = "Aggregate" }

    override Location getLocation() { aggregate_def(this, result) }

    AstNode getChild(int i) { aggregate_child(this, i, result) }

    override AstNode getAFieldOrChild() { aggregate_child(this, _, result) }
  }

  class AnnotArg extends @annot_arg, AstNode {
    override string getAPrimaryQlClass() { result = "AnnotArg" }

    override Location getLocation() { annot_arg_def(this, _, result) }

    AstNode getChild() { annot_arg_def(this, result, _) }

    override AstNode getAFieldOrChild() { annot_arg_def(this, result, _) }
  }

  class AnnotName extends @token_annot_name, Token {
    override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  class Annotation extends @annotation, AstNode {
    override string getAPrimaryQlClass() { result = "Annotation" }

    override Location getLocation() { annotation_def(this, _, result) }

    AstNode getArgs(int i) { annotation_args(this, i, result) }

    AnnotName getName() { annotation_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      annotation_args(this, _, result) or annotation_def(this, result, _)
    }
  }

  class AritylessPredicateExpr extends @arityless_predicate_expr, AstNode {
    override string getAPrimaryQlClass() { result = "AritylessPredicateExpr" }

    override Location getLocation() { arityless_predicate_expr_def(this, _, result) }

    LiteralId getName() { arityless_predicate_expr_def(this, result, _) }

    ModuleExpr getChild() { arityless_predicate_expr_child(this, result) }

    override AstNode getAFieldOrChild() {
      arityless_predicate_expr_def(this, result, _) or arityless_predicate_expr_child(this, result)
    }
  }

  class AsExpr extends @as_expr, AstNode {
    override string getAPrimaryQlClass() { result = "AsExpr" }

    override Location getLocation() { as_expr_def(this, result) }

    AstNode getChild(int i) { as_expr_child(this, i, result) }

    override AstNode getAFieldOrChild() { as_expr_child(this, _, result) }
  }

  class AsExprs extends @as_exprs, AstNode {
    override string getAPrimaryQlClass() { result = "AsExprs" }

    override Location getLocation() { as_exprs_def(this, result) }

    AsExpr getChild(int i) { as_exprs_child(this, i, result) }

    override AstNode getAFieldOrChild() { as_exprs_child(this, _, result) }
  }

  class BlockComment extends @token_block_comment, Token {
    override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  class Body extends @body, AstNode {
    override string getAPrimaryQlClass() { result = "Body" }

    override Location getLocation() { body_def(this, _, result) }

    AstNode getChild() { body_def(this, result, _) }

    override AstNode getAFieldOrChild() { body_def(this, result, _) }
  }

  class Bool extends @bool, AstNode {
    override string getAPrimaryQlClass() { result = "Bool" }

    override Location getLocation() { bool_def(this, _, result) }

    AstNode getChild() { bool_def(this, result, _) }

    override AstNode getAFieldOrChild() { bool_def(this, result, _) }
  }

  class CallBody extends @call_body, AstNode {
    override string getAPrimaryQlClass() { result = "CallBody" }

    override Location getLocation() { call_body_def(this, result) }

    AstNode getChild(int i) { call_body_child(this, i, result) }

    override AstNode getAFieldOrChild() { call_body_child(this, _, result) }
  }

  class CallOrUnqualAggExpr extends @call_or_unqual_agg_expr, AstNode {
    override string getAPrimaryQlClass() { result = "CallOrUnqualAggExpr" }

    override Location getLocation() { call_or_unqual_agg_expr_def(this, result) }

    AstNode getChild(int i) { call_or_unqual_agg_expr_child(this, i, result) }

    override AstNode getAFieldOrChild() { call_or_unqual_agg_expr_child(this, _, result) }
  }

  class Charpred extends @charpred, AstNode {
    override string getAPrimaryQlClass() { result = "Charpred" }

    override Location getLocation() { charpred_def(this, result) }

    AstNode getChild(int i) { charpred_child(this, i, result) }

    override AstNode getAFieldOrChild() { charpred_child(this, _, result) }
  }

  class ClassMember extends @class_member, AstNode {
    override string getAPrimaryQlClass() { result = "ClassMember" }

    override Location getLocation() { class_member_def(this, result) }

    AstNode getChild(int i) { class_member_child(this, i, result) }

    override AstNode getAFieldOrChild() { class_member_child(this, _, result) }
  }

  class ClassName extends @token_class_name, Token {
    override string getAPrimaryQlClass() { result = "ClassName" }
  }

  class ClasslessPredicate extends @classless_predicate, AstNode {
    override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

    override Location getLocation() { classless_predicate_def(this, _, _, result) }

    PredicateName getName() { classless_predicate_def(this, result, _, _) }

    AstNode getReturnType() { classless_predicate_def(this, _, result, _) }

    AstNode getChild(int i) { classless_predicate_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      classless_predicate_def(this, result, _, _) or
      classless_predicate_def(this, _, result, _) or
      classless_predicate_child(this, _, result)
    }
  }

  class Closure extends @token_closure, Token {
    override string getAPrimaryQlClass() { result = "Closure" }
  }

  class CompTerm extends @comp_term, AstNode {
    override string getAPrimaryQlClass() { result = "CompTerm" }

    override Location getLocation() { comp_term_def(this, _, _, _, result) }

    AstNode getLeft() { comp_term_def(this, result, _, _, _) }

    AstNode getRight() { comp_term_def(this, _, result, _, _) }

    Compop getChild() { comp_term_def(this, _, _, result, _) }

    override AstNode getAFieldOrChild() {
      comp_term_def(this, result, _, _, _) or
      comp_term_def(this, _, result, _, _) or
      comp_term_def(this, _, _, result, _)
    }
  }

  class Compop extends @token_compop, Token {
    override string getAPrimaryQlClass() { result = "Compop" }
  }

  class Conjunction extends @conjunction, AstNode {
    override string getAPrimaryQlClass() { result = "Conjunction" }

    override Location getLocation() { conjunction_def(this, _, _, result) }

    AstNode getLeft() { conjunction_def(this, result, _, _) }

    AstNode getRight() { conjunction_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      conjunction_def(this, result, _, _) or conjunction_def(this, _, result, _)
    }
  }

  class Dataclass extends @dataclass, AstNode {
    override string getAPrimaryQlClass() { result = "Dataclass" }

    override Location getLocation() { dataclass_def(this, _, result) }

    ClassName getName() { dataclass_def(this, result, _) }

    AstNode getChild(int i) { dataclass_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      dataclass_def(this, result, _) or dataclass_child(this, _, result)
    }
  }

  class Datatype extends @datatype, AstNode {
    override string getAPrimaryQlClass() { result = "Datatype" }

    override Location getLocation() { datatype_def(this, _, _, result) }

    ClassName getName() { datatype_def(this, result, _, _) }

    DatatypeBranches getChild() { datatype_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      datatype_def(this, result, _, _) or datatype_def(this, _, result, _)
    }
  }

  class DatatypeBranch extends @datatype_branch, AstNode {
    override string getAPrimaryQlClass() { result = "DatatypeBranch" }

    override Location getLocation() { datatype_branch_def(this, _, result) }

    ClassName getName() { datatype_branch_def(this, result, _) }

    AstNode getChild(int i) { datatype_branch_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      datatype_branch_def(this, result, _) or datatype_branch_child(this, _, result)
    }
  }

  class DatatypeBranches extends @datatype_branches, AstNode {
    override string getAPrimaryQlClass() { result = "DatatypeBranches" }

    override Location getLocation() { datatype_branches_def(this, result) }

    DatatypeBranch getChild(int i) { datatype_branches_child(this, i, result) }

    override AstNode getAFieldOrChild() { datatype_branches_child(this, _, result) }
  }

  class Dbtype extends @token_dbtype, Token {
    override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  class Direction extends @token_direction, Token {
    override string getAPrimaryQlClass() { result = "Direction" }
  }

  class Disjunction extends @disjunction, AstNode {
    override string getAPrimaryQlClass() { result = "Disjunction" }

    override Location getLocation() { disjunction_def(this, _, _, result) }

    AstNode getLeft() { disjunction_def(this, result, _, _) }

    AstNode getRight() { disjunction_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      disjunction_def(this, result, _, _) or disjunction_def(this, _, result, _)
    }
  }

  class Empty extends @token_empty, Token {
    override string getAPrimaryQlClass() { result = "Empty" }
  }

  class ExprAggregateBody extends @expr_aggregate_body, AstNode {
    override string getAPrimaryQlClass() { result = "ExprAggregateBody" }

    override Location getLocation() { expr_aggregate_body_def(this, result) }

    AstNode getChild(int i) { expr_aggregate_body_child(this, i, result) }

    override AstNode getAFieldOrChild() { expr_aggregate_body_child(this, _, result) }
  }

  class False extends @token_false, Token {
    override string getAPrimaryQlClass() { result = "False" }
  }

  class Field extends @field, AstNode {
    override string getAPrimaryQlClass() { result = "Field" }

    override Location getLocation() { field_def(this, _, result) }

    VarDecl getChild() { field_def(this, result, _) }

    override AstNode getAFieldOrChild() { field_def(this, result, _) }
  }

  class Float extends @token_float, Token {
    override string getAPrimaryQlClass() { result = "Float" }
  }

  class FullAggregateBody extends @full_aggregate_body, AstNode {
    override string getAPrimaryQlClass() { result = "FullAggregateBody" }

    override Location getLocation() { full_aggregate_body_def(this, result) }

    AstNode getChild(int i) { full_aggregate_body_child(this, i, result) }

    override AstNode getAFieldOrChild() { full_aggregate_body_child(this, _, result) }
  }

  class HigherOrderTerm extends @higher_order_term, AstNode {
    override string getAPrimaryQlClass() { result = "HigherOrderTerm" }

    override Location getLocation() { higher_order_term_def(this, _, result) }

    LiteralId getName() { higher_order_term_def(this, result, _) }

    AstNode getChild(int i) { higher_order_term_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      higher_order_term_def(this, result, _) or higher_order_term_child(this, _, result)
    }
  }

  class IfTerm extends @if_term, AstNode {
    override string getAPrimaryQlClass() { result = "IfTerm" }

    override Location getLocation() { if_term_def(this, _, _, _, result) }

    AstNode getCond() { if_term_def(this, result, _, _, _) }

    AstNode getFirst() { if_term_def(this, _, result, _, _) }

    AstNode getSecond() { if_term_def(this, _, _, result, _) }

    override AstNode getAFieldOrChild() {
      if_term_def(this, result, _, _, _) or
      if_term_def(this, _, result, _, _) or
      if_term_def(this, _, _, result, _)
    }
  }

  class Implication extends @implication, AstNode {
    override string getAPrimaryQlClass() { result = "Implication" }

    override Location getLocation() { implication_def(this, _, _, result) }

    AstNode getLeft() { implication_def(this, result, _, _) }

    AstNode getRight() { implication_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      implication_def(this, result, _, _) or implication_def(this, _, result, _)
    }
  }

  class ImportDirective extends @import_directive, AstNode {
    override string getAPrimaryQlClass() { result = "ImportDirective" }

    override Location getLocation() { import_directive_def(this, result) }

    AstNode getChild(int i) { import_directive_child(this, i, result) }

    override AstNode getAFieldOrChild() { import_directive_child(this, _, result) }
  }

  class ImportModuleExpr extends @import_module_expr, AstNode {
    override string getAPrimaryQlClass() { result = "ImportModuleExpr" }

    override Location getLocation() { import_module_expr_def(this, _, result) }

    SimpleId getName(int i) { import_module_expr_name(this, i, result) }

    QualModuleExpr getChild() { import_module_expr_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      import_module_expr_name(this, _, result) or import_module_expr_def(this, result, _)
    }
  }

  class InExpr extends @in_expr, AstNode {
    override string getAPrimaryQlClass() { result = "InExpr" }

    override Location getLocation() { in_expr_def(this, _, _, result) }

    AstNode getLeft() { in_expr_def(this, result, _, _) }

    AstNode getRight() { in_expr_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      in_expr_def(this, result, _, _) or in_expr_def(this, _, result, _)
    }
  }

  class InstanceOf extends @instance_of, AstNode {
    override string getAPrimaryQlClass() { result = "InstanceOf" }

    override Location getLocation() { instance_of_def(this, result) }

    AstNode getChild(int i) { instance_of_child(this, i, result) }

    override AstNode getAFieldOrChild() { instance_of_child(this, _, result) }
  }

  class Integer extends @token_integer, Token {
    override string getAPrimaryQlClass() { result = "Integer" }
  }

  class LineComment extends @token_line_comment, Token {
    override string getAPrimaryQlClass() { result = "LineComment" }
  }

  class Literal extends @literal, AstNode {
    override string getAPrimaryQlClass() { result = "Literal" }

    override Location getLocation() { literal_def(this, _, result) }

    AstNode getChild() { literal_def(this, result, _) }

    override AstNode getAFieldOrChild() { literal_def(this, result, _) }
  }

  class LiteralId extends @token_literal_id, Token {
    override string getAPrimaryQlClass() { result = "LiteralId" }
  }

  class MemberPredicate extends @member_predicate, AstNode {
    override string getAPrimaryQlClass() { result = "MemberPredicate" }

    override Location getLocation() { member_predicate_def(this, _, _, result) }

    PredicateName getName() { member_predicate_def(this, result, _, _) }

    AstNode getReturnType() { member_predicate_def(this, _, result, _) }

    AstNode getChild(int i) { member_predicate_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      member_predicate_def(this, result, _, _) or
      member_predicate_def(this, _, result, _) or
      member_predicate_child(this, _, result)
    }
  }

  class Module extends @module, AstNode {
    override string getAPrimaryQlClass() { result = "Module" }

    override Location getLocation() { module_def(this, _, result) }

    ModuleName getName() { module_def(this, result, _) }

    AstNode getChild(int i) { module_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      module_def(this, result, _) or module_child(this, _, result)
    }
  }

  class ModuleAliasBody extends @module_alias_body, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleAliasBody" }

    override Location getLocation() { module_alias_body_def(this, _, result) }

    ModuleExpr getChild() { module_alias_body_def(this, result, _) }

    override AstNode getAFieldOrChild() { module_alias_body_def(this, result, _) }
  }

  class ModuleExpr extends @module_expr, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleExpr" }

    override Location getLocation() { module_expr_def(this, _, result) }

    SimpleId getName() { module_expr_name(this, result) }

    AstNode getChild() { module_expr_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      module_expr_name(this, result) or module_expr_def(this, result, _)
    }
  }

  class ModuleMember extends @module_member, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleMember" }

    override Location getLocation() { module_member_def(this, result) }

    AstNode getChild(int i) { module_member_child(this, i, result) }

    override AstNode getAFieldOrChild() { module_member_child(this, _, result) }
  }

  class ModuleName extends @module_name, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleName" }

    override Location getLocation() { module_name_def(this, _, result) }

    SimpleId getChild() { module_name_def(this, result, _) }

    override AstNode getAFieldOrChild() { module_name_def(this, result, _) }
  }

  class MulExpr extends @mul_expr, AstNode {
    override string getAPrimaryQlClass() { result = "MulExpr" }

    override Location getLocation() { mul_expr_def(this, _, _, _, result) }

    AstNode getLeft() { mul_expr_def(this, result, _, _, _) }

    AstNode getRight() { mul_expr_def(this, _, result, _, _) }

    Mulop getChild() { mul_expr_def(this, _, _, result, _) }

    override AstNode getAFieldOrChild() {
      mul_expr_def(this, result, _, _, _) or
      mul_expr_def(this, _, result, _, _) or
      mul_expr_def(this, _, _, result, _)
    }
  }

  class Mulop extends @token_mulop, Token {
    override string getAPrimaryQlClass() { result = "Mulop" }
  }

  class Negation extends @negation, AstNode {
    override string getAPrimaryQlClass() { result = "Negation" }

    override Location getLocation() { negation_def(this, _, result) }

    AstNode getChild() { negation_def(this, result, _) }

    override AstNode getAFieldOrChild() { negation_def(this, result, _) }
  }

  class OrderBy extends @order_by, AstNode {
    override string getAPrimaryQlClass() { result = "OrderBy" }

    override Location getLocation() { order_by_def(this, result) }

    AstNode getChild(int i) { order_by_child(this, i, result) }

    override AstNode getAFieldOrChild() { order_by_child(this, _, result) }
  }

  class OrderBys extends @order_bys, AstNode {
    override string getAPrimaryQlClass() { result = "OrderBys" }

    override Location getLocation() { order_bys_def(this, result) }

    OrderBy getChild(int i) { order_bys_child(this, i, result) }

    override AstNode getAFieldOrChild() { order_bys_child(this, _, result) }
  }

  class ParExpr extends @par_expr, AstNode {
    override string getAPrimaryQlClass() { result = "ParExpr" }

    override Location getLocation() { par_expr_def(this, _, result) }

    AstNode getChild() { par_expr_def(this, result, _) }

    override AstNode getAFieldOrChild() { par_expr_def(this, result, _) }
  }

  class Predicate extends @token_predicate, Token {
    override string getAPrimaryQlClass() { result = "Predicate" }
  }

  class PredicateAliasBody extends @predicate_alias_body, AstNode {
    override string getAPrimaryQlClass() { result = "PredicateAliasBody" }

    override Location getLocation() { predicate_alias_body_def(this, _, result) }

    PredicateExpr getChild() { predicate_alias_body_def(this, result, _) }

    override AstNode getAFieldOrChild() { predicate_alias_body_def(this, result, _) }
  }

  class PredicateExpr extends @predicate_expr, AstNode {
    override string getAPrimaryQlClass() { result = "PredicateExpr" }

    override Location getLocation() { predicate_expr_def(this, result) }

    AstNode getChild(int i) { predicate_expr_child(this, i, result) }

    override AstNode getAFieldOrChild() { predicate_expr_child(this, _, result) }
  }

  class PredicateName extends @token_predicate_name, Token {
    override string getAPrimaryQlClass() { result = "PredicateName" }
  }

  class PrefixCast extends @prefix_cast, AstNode {
    override string getAPrimaryQlClass() { result = "PrefixCast" }

    override Location getLocation() { prefix_cast_def(this, result) }

    AstNode getChild(int i) { prefix_cast_child(this, i, result) }

    override AstNode getAFieldOrChild() { prefix_cast_child(this, _, result) }
  }

  class PrimitiveType extends @token_primitive_type, Token {
    override string getAPrimaryQlClass() { result = "PrimitiveType" }
  }

  class Ql extends @ql, AstNode {
    override string getAPrimaryQlClass() { result = "Ql" }

    override Location getLocation() { ql_def(this, result) }

    ModuleMember getChild(int i) { ql_child(this, i, result) }

    override AstNode getAFieldOrChild() { ql_child(this, _, result) }
  }

  class Qldoc extends @token_qldoc, Token {
    override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  class QualModuleExpr extends @qual_module_expr, AstNode {
    override string getAPrimaryQlClass() { result = "QualModuleExpr" }

    override Location getLocation() { qual_module_expr_def(this, result) }

    SimpleId getName(int i) { qual_module_expr_name(this, i, result) }

    override AstNode getAFieldOrChild() { qual_module_expr_name(this, _, result) }
  }

  class QualifiedRhs extends @qualified_rhs, AstNode {
    override string getAPrimaryQlClass() { result = "QualifiedRhs" }

    override Location getLocation() { qualified_rhs_def(this, result) }

    PredicateName getName() { qualified_rhs_name(this, result) }

    AstNode getChild(int i) { qualified_rhs_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      qualified_rhs_name(this, result) or qualified_rhs_child(this, _, result)
    }
  }

  class QualifiedExpr extends @qualified_expr, AstNode {
    override string getAPrimaryQlClass() { result = "QualifiedExpr" }

    override Location getLocation() { qualified_expr_def(this, result) }

    AstNode getChild(int i) { qualified_expr_child(this, i, result) }

    override AstNode getAFieldOrChild() { qualified_expr_child(this, _, result) }
  }

  class Quantified extends @quantified, AstNode {
    override string getAPrimaryQlClass() { result = "Quantified" }

    override Location getLocation() { quantified_def(this, result) }

    AstNode getChild(int i) { quantified_child(this, i, result) }

    override AstNode getAFieldOrChild() { quantified_child(this, _, result) }
  }

  class Quantifier extends @token_quantifier, Token {
    override string getAPrimaryQlClass() { result = "Quantifier" }
  }

  class Range extends @range, AstNode {
    override string getAPrimaryQlClass() { result = "Range" }

    override Location getLocation() { range_def(this, _, _, result) }

    AstNode getLower() { range_def(this, result, _, _) }

    AstNode getUpper() { range_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      range_def(this, result, _, _) or range_def(this, _, result, _)
    }
  }

  class Result extends @token_result, Token {
    override string getAPrimaryQlClass() { result = "Result" }
  }

  class Select extends @select, AstNode {
    override string getAPrimaryQlClass() { result = "Select" }

    override Location getLocation() { select_def(this, result) }

    AstNode getChild(int i) { select_child(this, i, result) }

    override AstNode getAFieldOrChild() { select_child(this, _, result) }
  }

  class SetLiteral extends @set_literal, AstNode {
    override string getAPrimaryQlClass() { result = "SetLiteral" }

    override Location getLocation() { set_literal_def(this, result) }

    AstNode getChild(int i) { set_literal_child(this, i, result) }

    override AstNode getAFieldOrChild() { set_literal_child(this, _, result) }
  }

  class SimpleId extends @token_simple_id, Token {
    override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  class SpecialId extends @token_special_id, Token {
    override string getAPrimaryQlClass() { result = "SpecialId" }
  }

  class SpecialCall extends @special_call, AstNode {
    override string getAPrimaryQlClass() { result = "SpecialCall" }

    override Location getLocation() { special_call_def(this, _, result) }

    SpecialId getChild() { special_call_def(this, result, _) }

    override AstNode getAFieldOrChild() { special_call_def(this, result, _) }
  }

  class String extends @token_string, Token {
    override string getAPrimaryQlClass() { result = "String" }
  }

  class Super extends @token_super, Token {
    override string getAPrimaryQlClass() { result = "Super" }
  }

  class SuperRef extends @super_ref, AstNode {
    override string getAPrimaryQlClass() { result = "SuperRef" }

    override Location getLocation() { super_ref_def(this, result) }

    AstNode getChild(int i) { super_ref_child(this, i, result) }

    override AstNode getAFieldOrChild() { super_ref_child(this, _, result) }
  }

  class This extends @token_this, Token {
    override string getAPrimaryQlClass() { result = "This" }
  }

  class True extends @token_true, Token {
    override string getAPrimaryQlClass() { result = "True" }
  }

  class TypeAliasBody extends @type_alias_body, AstNode {
    override string getAPrimaryQlClass() { result = "TypeAliasBody" }

    override Location getLocation() { type_alias_body_def(this, _, result) }

    TypeExpr getChild() { type_alias_body_def(this, result, _) }

    override AstNode getAFieldOrChild() { type_alias_body_def(this, result, _) }
  }

  class TypeExpr extends @type_expr, AstNode {
    override string getAPrimaryQlClass() { result = "TypeExpr" }

    override Location getLocation() { type_expr_def(this, result) }

    ClassName getName() { type_expr_name(this, result) }

    AstNode getChild() { type_expr_child(this, result) }

    override AstNode getAFieldOrChild() {
      type_expr_name(this, result) or type_expr_child(this, result)
    }
  }

  class TypeUnionBody extends @type_union_body, AstNode {
    override string getAPrimaryQlClass() { result = "TypeUnionBody" }

    override Location getLocation() { type_union_body_def(this, result) }

    TypeExpr getChild(int i) { type_union_body_child(this, i, result) }

    override AstNode getAFieldOrChild() { type_union_body_child(this, _, result) }
  }

  class UnaryExpr extends @unary_expr, AstNode {
    override string getAPrimaryQlClass() { result = "UnaryExpr" }

    override Location getLocation() { unary_expr_def(this, result) }

    AstNode getChild(int i) { unary_expr_child(this, i, result) }

    override AstNode getAFieldOrChild() { unary_expr_child(this, _, result) }
  }

  class Underscore extends @token_underscore, Token {
    override string getAPrimaryQlClass() { result = "Underscore" }
  }

  class Unop extends @token_unop, Token {
    override string getAPrimaryQlClass() { result = "Unop" }
  }

  class UnqualAggBody extends @unqual_agg_body, AstNode {
    override string getAPrimaryQlClass() { result = "UnqualAggBody" }

    override Location getLocation() { unqual_agg_body_def(this, result) }

    AstNode getChild(int i) { unqual_agg_body_child(this, i, result) }

    override AstNode getAFieldOrChild() { unqual_agg_body_child(this, _, result) }
  }

  class VarDecl extends @var_decl, AstNode {
    override string getAPrimaryQlClass() { result = "VarDecl" }

    override Location getLocation() { var_decl_def(this, result) }

    AstNode getChild(int i) { var_decl_child(this, i, result) }

    override AstNode getAFieldOrChild() { var_decl_child(this, _, result) }
  }

  class VarName extends @var_name, AstNode {
    override string getAPrimaryQlClass() { result = "VarName" }

    override Location getLocation() { var_name_def(this, _, result) }

    SimpleId getChild() { var_name_def(this, result, _) }

    override AstNode getAFieldOrChild() { var_name_def(this, result, _) }
  }

  class Variable extends @variable, AstNode {
    override string getAPrimaryQlClass() { result = "Variable" }

    override Location getLocation() { variable_def(this, _, result) }

    AstNode getChild() { variable_def(this, result, _) }

    override AstNode getAFieldOrChild() { variable_def(this, result, _) }
  }
}
