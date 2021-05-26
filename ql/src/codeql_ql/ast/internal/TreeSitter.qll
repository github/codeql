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

  class AggiD extends @token_aggi_d, Token {
    override string getAPrimaryQlClass() { result = "AggiD" }
  }

  class Aggregate extends @aggregate, AstNode {
    override string getAPrimaryQlClass() { result = "Aggregate" }

    override Location getLocation() { aggregate_def(this, result) }

    AstNode getChild(int i) { aggregate_child(this, i, result) }

    override AstNode getAFieldOrChild() { aggregate_child(this, _, result) }
  }

  class AnnotaRg extends @annota_rg, AstNode {
    override string getAPrimaryQlClass() { result = "AnnotaRg" }

    override Location getLocation() { annota_rg_def(this, _, result) }

    AstNode getChild() { annota_rg_def(this, result, _) }

    override AstNode getAFieldOrChild() { annota_rg_def(this, result, _) }
  }

  class AnnotnAme extends @token_annotn_ame, Token {
    override string getAPrimaryQlClass() { result = "AnnotnAme" }
  }

  class Annotation extends @annotation, AstNode {
    override string getAPrimaryQlClass() { result = "Annotation" }

    override Location getLocation() { annotation_def(this, _, result) }

    AstNode getArgs(int i) { annotation_args(this, i, result) }

    AnnotnAme getName() { annotation_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      annotation_args(this, _, result) or annotation_def(this, result, _)
    }
  }

  class AritylesspRedicateeXpr extends @aritylessp_redicatee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "AritylesspRedicateeXpr" }

    override Location getLocation() { aritylessp_redicatee_xpr_def(this, _, result) }

    LiteraliD getName() { aritylessp_redicatee_xpr_def(this, result, _) }

    ModuleeXpr getChild() { aritylessp_redicatee_xpr_child(this, result) }

    override AstNode getAFieldOrChild() {
      aritylessp_redicatee_xpr_def(this, result, _) or aritylessp_redicatee_xpr_child(this, result)
    }
  }

  class AseXpr extends @ase_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "AseXpr" }

    override Location getLocation() { ase_xpr_def(this, result) }

    AstNode getChild(int i) { ase_xpr_child(this, i, result) }

    override AstNode getAFieldOrChild() { ase_xpr_child(this, _, result) }
  }

  class AseXprs extends @ase_xprs, AstNode {
    override string getAPrimaryQlClass() { result = "AseXprs" }

    override Location getLocation() { ase_xprs_def(this, result) }

    AseXpr getChild(int i) { ase_xprs_child(this, i, result) }

    override AstNode getAFieldOrChild() { ase_xprs_child(this, _, result) }
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

  class ClassmEmber extends @classm_ember, AstNode {
    override string getAPrimaryQlClass() { result = "ClassmEmber" }

    override Location getLocation() { classm_ember_def(this, result) }

    AstNode getChild(int i) { classm_ember_child(this, i, result) }

    override AstNode getAFieldOrChild() { classm_ember_child(this, _, result) }
  }

  class ClassnAme extends @token_classn_ame, Token {
    override string getAPrimaryQlClass() { result = "ClassnAme" }
  }

  class ClasslesspRedicate extends @classlessp_redicate, AstNode {
    override string getAPrimaryQlClass() { result = "ClasslesspRedicate" }

    override Location getLocation() { classlessp_redicate_def(this, _, _, result) }

    PredicatenAme getName() { classlessp_redicate_def(this, result, _, _) }

    AstNode getReturntYpe() { classlessp_redicate_def(this, _, result, _) }

    AstNode getChild(int i) { classlessp_redicate_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      classlessp_redicate_def(this, result, _, _) or
      classlessp_redicate_def(this, _, result, _) or
      classlessp_redicate_child(this, _, result)
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

    ClassnAme getName() { dataclass_def(this, result, _) }

    AstNode getChild(int i) { dataclass_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      dataclass_def(this, result, _) or dataclass_child(this, _, result)
    }
  }

  class Datatype extends @datatype, AstNode {
    override string getAPrimaryQlClass() { result = "Datatype" }

    override Location getLocation() { datatype_def(this, _, _, result) }

    ClassnAme getName() { datatype_def(this, result, _, _) }

    DatatypebRanches getChild() { datatype_def(this, _, result, _) }

    override AstNode getAFieldOrChild() {
      datatype_def(this, result, _, _) or datatype_def(this, _, result, _)
    }
  }

  class DatatypebRanch extends @datatypeb_ranch, AstNode {
    override string getAPrimaryQlClass() { result = "DatatypebRanch" }

    override Location getLocation() { datatypeb_ranch_def(this, _, result) }

    ClassnAme getName() { datatypeb_ranch_def(this, result, _) }

    AstNode getChild(int i) { datatypeb_ranch_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      datatypeb_ranch_def(this, result, _) or datatypeb_ranch_child(this, _, result)
    }
  }

  class DatatypebRanches extends @datatypeb_ranches, AstNode {
    override string getAPrimaryQlClass() { result = "DatatypebRanches" }

    override Location getLocation() { datatypeb_ranches_def(this, result) }

    DatatypebRanch getChild(int i) { datatypeb_ranches_child(this, i, result) }

    override AstNode getAFieldOrChild() { datatypeb_ranches_child(this, _, result) }
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

    VardEcl getChild() { field_def(this, result, _) }

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

  class HigheroRdertErm extends @highero_rdert_erm, AstNode {
    override string getAPrimaryQlClass() { result = "HigheroRdertErm" }

    override Location getLocation() { highero_rdert_erm_def(this, _, result) }

    LiteraliD getName() { highero_rdert_erm_def(this, result, _) }

    AstNode getChild(int i) { highero_rdert_erm_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      highero_rdert_erm_def(this, result, _) or highero_rdert_erm_child(this, _, result)
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

  class ImportdIrective extends @importd_irective, AstNode {
    override string getAPrimaryQlClass() { result = "ImportdIrective" }

    override Location getLocation() { importd_irective_def(this, result) }

    AstNode getChild(int i) { importd_irective_child(this, i, result) }

    override AstNode getAFieldOrChild() { importd_irective_child(this, _, result) }
  }

  class ImportmOduleeXpr extends @importm_odulee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "ImportmOduleeXpr" }

    override Location getLocation() { importm_odulee_xpr_def(this, _, result) }

    SimpleiD getName(int i) { importm_odulee_xpr_name(this, i, result) }

    QualmOduleeXpr getChild() { importm_odulee_xpr_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      importm_odulee_xpr_name(this, _, result) or importm_odulee_xpr_def(this, result, _)
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

  class LiteraliD extends @token_literali_d, Token {
    override string getAPrimaryQlClass() { result = "LiteraliD" }
  }

  class MemberpRedicate extends @memberp_redicate, AstNode {
    override string getAPrimaryQlClass() { result = "MemberpRedicate" }

    override Location getLocation() { memberp_redicate_def(this, _, _, result) }

    PredicatenAme getName() { memberp_redicate_def(this, result, _, _) }

    AstNode getReturntYpe() { memberp_redicate_def(this, _, result, _) }

    AstNode getChild(int i) { memberp_redicate_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      memberp_redicate_def(this, result, _, _) or
      memberp_redicate_def(this, _, result, _) or
      memberp_redicate_child(this, _, result)
    }
  }

  class Module extends @module, AstNode {
    override string getAPrimaryQlClass() { result = "Module" }

    override Location getLocation() { module_def(this, _, result) }

    ModulenAme getName() { module_def(this, result, _) }

    AstNode getChild(int i) { module_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      module_def(this, result, _) or module_child(this, _, result)
    }
  }

  class ModuleaLiasbOdy extends @modulea_liasb_ody, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleaLiasbOdy" }

    override Location getLocation() { modulea_liasb_ody_def(this, _, result) }

    ModuleeXpr getChild() { modulea_liasb_ody_def(this, result, _) }

    override AstNode getAFieldOrChild() { modulea_liasb_ody_def(this, result, _) }
  }

  class ModuleeXpr extends @modulee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "ModuleeXpr" }

    override Location getLocation() { modulee_xpr_def(this, _, result) }

    SimpleiD getName() { modulee_xpr_name(this, result) }

    AstNode getChild() { modulee_xpr_def(this, result, _) }

    override AstNode getAFieldOrChild() {
      modulee_xpr_name(this, result) or modulee_xpr_def(this, result, _)
    }
  }

  class ModulemEmber extends @modulem_ember, AstNode {
    override string getAPrimaryQlClass() { result = "ModulemEmber" }

    override Location getLocation() { modulem_ember_def(this, result) }

    AstNode getChild(int i) { modulem_ember_child(this, i, result) }

    override AstNode getAFieldOrChild() { modulem_ember_child(this, _, result) }
  }

  class ModulenAme extends @modulen_ame, AstNode {
    override string getAPrimaryQlClass() { result = "ModulenAme" }

    override Location getLocation() { modulen_ame_def(this, _, result) }

    SimpleiD getChild() { modulen_ame_def(this, result, _) }

    override AstNode getAFieldOrChild() { modulen_ame_def(this, result, _) }
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

  class OrderbY extends @orderb_y, AstNode {
    override string getAPrimaryQlClass() { result = "OrderbY" }

    override Location getLocation() { orderb_y_def(this, result) }

    AstNode getChild(int i) { orderb_y_child(this, i, result) }

    override AstNode getAFieldOrChild() { orderb_y_child(this, _, result) }
  }

  class OrderbYs extends @orderb_ys, AstNode {
    override string getAPrimaryQlClass() { result = "OrderbYs" }

    override Location getLocation() { orderb_ys_def(this, result) }

    OrderbY getChild(int i) { orderb_ys_child(this, i, result) }

    override AstNode getAFieldOrChild() { orderb_ys_child(this, _, result) }
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

  class PredicateaLiasbOdy extends @predicatea_liasb_ody, AstNode {
    override string getAPrimaryQlClass() { result = "PredicateaLiasbOdy" }

    override Location getLocation() { predicatea_liasb_ody_def(this, _, result) }

    PredicateeXpr getChild() { predicatea_liasb_ody_def(this, result, _) }

    override AstNode getAFieldOrChild() { predicatea_liasb_ody_def(this, result, _) }
  }

  class PredicateeXpr extends @predicatee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "PredicateeXpr" }

    override Location getLocation() { predicatee_xpr_def(this, result) }

    AstNode getChild(int i) { predicatee_xpr_child(this, i, result) }

    override AstNode getAFieldOrChild() { predicatee_xpr_child(this, _, result) }
  }

  class PredicatenAme extends @token_predicaten_ame, Token {
    override string getAPrimaryQlClass() { result = "PredicatenAme" }
  }

  class PrefixCast extends @prefix_cast, AstNode {
    override string getAPrimaryQlClass() { result = "PrefixCast" }

    override Location getLocation() { prefix_cast_def(this, result) }

    AstNode getChild(int i) { prefix_cast_child(this, i, result) }

    override AstNode getAFieldOrChild() { prefix_cast_child(this, _, result) }
  }

  class PrimitivetYpe extends @token_primitivet_ype, Token {
    override string getAPrimaryQlClass() { result = "PrimitivetYpe" }
  }

  class Ql extends @ql, AstNode {
    override string getAPrimaryQlClass() { result = "Ql" }

    override Location getLocation() { ql_def(this, result) }

    ModulemEmber getChild(int i) { ql_child(this, i, result) }

    override AstNode getAFieldOrChild() { ql_child(this, _, result) }
  }

  class Qldoc extends @token_qldoc, Token {
    override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  class QualmOduleeXpr extends @qualm_odulee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "QualmOduleeXpr" }

    override Location getLocation() { qualm_odulee_xpr_def(this, result) }

    SimpleiD getName(int i) { qualm_odulee_xpr_name(this, i, result) }

    override AstNode getAFieldOrChild() { qualm_odulee_xpr_name(this, _, result) }
  }

  class QualifiedrHs extends @qualifiedr_hs, AstNode {
    override string getAPrimaryQlClass() { result = "QualifiedrHs" }

    override Location getLocation() { qualifiedr_hs_def(this, result) }

    PredicatenAme getName() { qualifiedr_hs_name(this, result) }

    AstNode getChild(int i) { qualifiedr_hs_child(this, i, result) }

    override AstNode getAFieldOrChild() {
      qualifiedr_hs_name(this, result) or qualifiedr_hs_child(this, _, result)
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

  class SimpleiD extends @token_simplei_d, Token {
    override string getAPrimaryQlClass() { result = "SimpleiD" }
  }

  class SpecialiD extends @token_speciali_d, Token {
    override string getAPrimaryQlClass() { result = "SpecialiD" }
  }

  class SpecialCall extends @special_call, AstNode {
    override string getAPrimaryQlClass() { result = "SpecialCall" }

    override Location getLocation() { special_call_def(this, _, result) }

    SpecialiD getChild() { special_call_def(this, result, _) }

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

  class TypeaLiasbOdy extends @typea_liasb_ody, AstNode {
    override string getAPrimaryQlClass() { result = "TypeaLiasbOdy" }

    override Location getLocation() { typea_liasb_ody_def(this, _, result) }

    TypeeXpr getChild() { typea_liasb_ody_def(this, result, _) }

    override AstNode getAFieldOrChild() { typea_liasb_ody_def(this, result, _) }
  }

  class TypeeXpr extends @typee_xpr, AstNode {
    override string getAPrimaryQlClass() { result = "TypeeXpr" }

    override Location getLocation() { typee_xpr_def(this, result) }

    ClassnAme getName() { typee_xpr_name(this, result) }

    AstNode getChild() { typee_xpr_child(this, result) }

    override AstNode getAFieldOrChild() {
      typee_xpr_name(this, result) or typee_xpr_child(this, result)
    }
  }

  class TypeuNionbOdy extends @typeu_nionb_ody, AstNode {
    override string getAPrimaryQlClass() { result = "TypeuNionbOdy" }

    override Location getLocation() { typeu_nionb_ody_def(this, result) }

    TypeeXpr getChild(int i) { typeu_nionb_ody_child(this, i, result) }

    override AstNode getAFieldOrChild() { typeu_nionb_ody_child(this, _, result) }
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

  class VardEcl extends @vard_ecl, AstNode {
    override string getAPrimaryQlClass() { result = "VardEcl" }

    override Location getLocation() { vard_ecl_def(this, result) }

    AstNode getChild(int i) { vard_ecl_child(this, i, result) }

    override AstNode getAFieldOrChild() { vard_ecl_child(this, _, result) }
  }

  class VarnAme extends @varn_ame, AstNode {
    override string getAPrimaryQlClass() { result = "VarnAme" }

    override Location getLocation() { varn_ame_def(this, _, result) }

    SimpleiD getChild() { varn_ame_def(this, result, _) }

    override AstNode getAFieldOrChild() { varn_ame_def(this, result, _) }
  }

  class Variable extends @variable, AstNode {
    override string getAPrimaryQlClass() { result = "Variable" }

    override Location getLocation() { variable_def(this, _, result) }

    AstNode getChild() { variable_def(this, result, _) }

    override AstNode getAFieldOrChild() { variable_def(this, result, _) }
  }
}
