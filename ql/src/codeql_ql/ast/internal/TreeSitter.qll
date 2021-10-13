/*
 * CodeQL library for QL
 * Automatically generated from the tree-sitter grammar; do not edit
 */

module Generated {
  private import codeql.files.FileSystem
  private import codeql.Locations

  /** The base class for all AST nodes */
  class AstNode extends @ast_node {
    /** Gets a string representation of this element. */
    string toString() { result = this.getAPrimaryQlClass() }

    /** Gets the location of this element. */
    Location getLocation() { none() }

    /** Gets the parent of this element. */
    AstNode getParent() { ast_node_parent(this, result, _) }

    /** Gets the index of this node among the children of its parent. */
    int getParentIndex() { ast_node_parent(this, _, result) }

    /** Gets a field or child node of this node. */
    AstNode getAFieldOrChild() { none() }

    /** Gets the name of the primary QL class for this element. */
    string getAPrimaryQlClass() { result = "???" }
  }

  /** A token. */
  class Token extends @token, AstNode {
    /** Gets the value of this token. */
    string getValue() { tokeninfo(this, _, _, _, result, _) }

    /** Gets the location of this token. */
    override Location getLocation() { tokeninfo(this, _, _, _, _, result) }

    /** Gets a string representation of this element. */
    override string toString() { result = getValue() }

    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Token" }
  }

  /** A reserved word. */
  class ReservedWord extends @reserved_word, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ReservedWord" }
  }

  /** A class representing `add_expr` nodes. */
  class AddExpr extends @add_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AddExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { add_expr_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { add_expr_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { add_expr_def(this, _, result, _, _) }

    /** Gets the child of this node. */
    Addop getChild() { add_expr_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      add_expr_def(this, result, _, _, _) or
      add_expr_def(this, _, result, _, _) or
      add_expr_def(this, _, _, result, _)
    }
  }

  /** A class representing `addop` tokens. */
  class Addop extends @token_addop, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Addop" }
  }

  /** A class representing `aggId` tokens. */
  class AggId extends @token_agg_id, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AggId" }
  }

  /** A class representing `aggregate` nodes. */
  class Aggregate extends @aggregate, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Aggregate" }

    /** Gets the location of this element. */
    override Location getLocation() { aggregate_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { aggregate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { aggregate_child(this, _, result) }
  }

  /** A class representing `annotArg` nodes. */
  class AnnotArg extends @annot_arg, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AnnotArg" }

    /** Gets the location of this element. */
    override Location getLocation() { annot_arg_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { annot_arg_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { annot_arg_def(this, result, _) }
  }

  /** A class representing `annotName` tokens. */
  class AnnotName extends @token_annot_name, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AnnotName" }
  }

  /** A class representing `annotation` nodes. */
  class Annotation extends @annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Annotation" }

    /** Gets the location of this element. */
    override Location getLocation() { annotation_def(this, _, result) }

    /** Gets the node corresponding to the field `args`. */
    AstNode getArgs(int i) { annotation_args(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    AnnotName getName() { annotation_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      annotation_args(this, _, result) or annotation_def(this, result, _)
    }
  }

  /** A class representing `aritylessPredicateExpr` nodes. */
  class AritylessPredicateExpr extends @arityless_predicate_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AritylessPredicateExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { arityless_predicate_expr_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    LiteralId getName() { arityless_predicate_expr_def(this, result, _) }

    /** Gets the child of this node. */
    ModuleExpr getChild() { arityless_predicate_expr_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      arityless_predicate_expr_def(this, result, _) or arityless_predicate_expr_child(this, result)
    }
  }

  /** A class representing `asExpr` nodes. */
  class AsExpr extends @as_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AsExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { as_expr_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { as_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { as_expr_child(this, _, result) }
  }

  /** A class representing `asExprs` nodes. */
  class AsExprs extends @as_exprs, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "AsExprs" }

    /** Gets the location of this element. */
    override Location getLocation() { as_exprs_def(this, result) }

    /** Gets the `i`th child of this node. */
    AsExpr getChild(int i) { as_exprs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { as_exprs_child(this, _, result) }
  }

  /** A class representing `block_comment` tokens. */
  class BlockComment extends @token_block_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "BlockComment" }
  }

  /** A class representing `body` nodes. */
  class Body extends @body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Body" }

    /** Gets the location of this element. */
    override Location getLocation() { body_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { body_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { body_def(this, result, _) }
  }

  /** A class representing `bool` nodes. */
  class Bool extends @bool, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Bool" }

    /** Gets the location of this element. */
    override Location getLocation() { bool_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { bool_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { bool_def(this, result, _) }
  }

  /** A class representing `call_body` nodes. */
  class CallBody extends @call_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "CallBody" }

    /** Gets the location of this element. */
    override Location getLocation() { call_body_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { call_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { call_body_child(this, _, result) }
  }

  /** A class representing `call_or_unqual_agg_expr` nodes. */
  class CallOrUnqualAggExpr extends @call_or_unqual_agg_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "CallOrUnqualAggExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { call_or_unqual_agg_expr_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { call_or_unqual_agg_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { call_or_unqual_agg_expr_child(this, _, result) }
  }

  /** A class representing `charpred` nodes. */
  class Charpred extends @charpred, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Charpred" }

    /** Gets the location of this element. */
    override Location getLocation() { charpred_def(this, _, _, result) }

    /** Gets the node corresponding to the field `body`. */
    AstNode getBody() { charpred_def(this, result, _, _) }

    /** Gets the child of this node. */
    ClassName getChild() { charpred_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      charpred_def(this, result, _, _) or charpred_def(this, _, result, _)
    }
  }

  /** A class representing `classMember` nodes. */
  class ClassMember extends @class_member, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ClassMember" }

    /** Gets the location of this element. */
    override Location getLocation() { class_member_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { class_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { class_member_child(this, _, result) }
  }

  /** A class representing `className` tokens. */
  class ClassName extends @token_class_name, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ClassName" }
  }

  /** A class representing `classlessPredicate` nodes. */
  class ClasslessPredicate extends @classless_predicate, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

    /** Gets the location of this element. */
    override Location getLocation() { classless_predicate_def(this, _, _, result) }

    /** Gets the node corresponding to the field `name`. */
    PredicateName getName() { classless_predicate_def(this, result, _, _) }

    /** Gets the node corresponding to the field `returnType`. */
    AstNode getReturnType() { classless_predicate_def(this, _, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { classless_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      classless_predicate_def(this, result, _, _) or
      classless_predicate_def(this, _, result, _) or
      classless_predicate_child(this, _, result)
    }
  }

  /** A class representing `closure` tokens. */
  class Closure extends @token_closure, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Closure" }
  }

  /** A class representing `comp_term` nodes. */
  class CompTerm extends @comp_term, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "CompTerm" }

    /** Gets the location of this element. */
    override Location getLocation() { comp_term_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { comp_term_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { comp_term_def(this, _, result, _, _) }

    /** Gets the child of this node. */
    Compop getChild() { comp_term_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      comp_term_def(this, result, _, _, _) or
      comp_term_def(this, _, result, _, _) or
      comp_term_def(this, _, _, result, _)
    }
  }

  /** A class representing `compop` tokens. */
  class Compop extends @token_compop, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Compop" }
  }

  /** A class representing `conjunction` nodes. */
  class Conjunction extends @conjunction, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Conjunction" }

    /** Gets the location of this element. */
    override Location getLocation() { conjunction_def(this, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { conjunction_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { conjunction_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      conjunction_def(this, result, _, _) or conjunction_def(this, _, result, _)
    }
  }

  /** A class representing `dataclass` nodes. */
  class Dataclass extends @dataclass, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Dataclass" }

    /** Gets the location of this element. */
    override Location getLocation() { dataclass_def(this, _, result) }

    /** Gets the node corresponding to the field `extends`. */
    AstNode getExtends(int i) { dataclass_extends(this, i, result) }

    /** Gets the node corresponding to the field `instanceof`. */
    AstNode getInstanceof(int i) { dataclass_instanceof(this, i, result) }

    /** Gets the node corresponding to the field `name`. */
    ClassName getName() { dataclass_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { dataclass_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      dataclass_extends(this, _, result) or
      dataclass_instanceof(this, _, result) or
      dataclass_def(this, result, _) or
      dataclass_child(this, _, result)
    }
  }

  /** A class representing `datatype` nodes. */
  class Datatype extends @datatype, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Datatype" }

    /** Gets the location of this element. */
    override Location getLocation() { datatype_def(this, _, _, result) }

    /** Gets the node corresponding to the field `name`. */
    ClassName getName() { datatype_def(this, result, _, _) }

    /** Gets the child of this node. */
    DatatypeBranches getChild() { datatype_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      datatype_def(this, result, _, _) or datatype_def(this, _, result, _)
    }
  }

  /** A class representing `datatypeBranch` nodes. */
  class DatatypeBranch extends @datatype_branch, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DatatypeBranch" }

    /** Gets the location of this element. */
    override Location getLocation() { datatype_branch_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    ClassName getName() { datatype_branch_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { datatype_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      datatype_branch_def(this, result, _) or datatype_branch_child(this, _, result)
    }
  }

  /** A class representing `datatypeBranches` nodes. */
  class DatatypeBranches extends @datatype_branches, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DatatypeBranches" }

    /** Gets the location of this element. */
    override Location getLocation() { datatype_branches_def(this, result) }

    /** Gets the `i`th child of this node. */
    DatatypeBranch getChild(int i) { datatype_branches_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { datatype_branches_child(this, _, result) }
  }

  /** A class representing `db_annotation` nodes. */
  class DbAnnotation extends @db_annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbAnnotation" }

    /** Gets the location of this element. */
    override Location getLocation() { db_annotation_def(this, result) }

    /** Gets the node corresponding to the field `argsAnnotation`. */
    DbArgsAnnotation getArgsAnnotation() { db_annotation_args_annotation(this, result) }

    /** Gets the node corresponding to the field `simpleAnnotation`. */
    AnnotName getSimpleAnnotation() { db_annotation_simple_annotation(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_annotation_args_annotation(this, result) or db_annotation_simple_annotation(this, result)
    }
  }

  /** A class representing `db_argsAnnotation` nodes. */
  class DbArgsAnnotation extends @db_args_annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbArgsAnnotation" }

    /** Gets the location of this element. */
    override Location getLocation() { db_args_annotation_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    AnnotName getName() { db_args_annotation_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    SimpleId getChild(int i) { db_args_annotation_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_args_annotation_def(this, result, _) or db_args_annotation_child(this, _, result)
    }
  }

  /** A class representing `db_boolean` tokens. */
  class DbBoolean extends @token_db_boolean, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbBoolean" }
  }

  /** A class representing `db_branch` nodes. */
  class DbBranch extends @db_branch, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbBranch" }

    /** Gets the location of this element. */
    override Location getLocation() { db_branch_def(this, result) }

    /** Gets the node corresponding to the field `qldoc`. */
    Qldoc getQldoc() { db_branch_qldoc(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { db_branch_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_branch_qldoc(this, result) or db_branch_child(this, _, result)
    }
  }

  /** A class representing `db_case` tokens. */
  class DbCase extends @token_db_case, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbCase" }
  }

  /** A class representing `db_caseDecl` nodes. */
  class DbCaseDecl extends @db_case_decl, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbCaseDecl" }

    /** Gets the location of this element. */
    override Location getLocation() { db_case_decl_def(this, _, _, result) }

    /** Gets the node corresponding to the field `base`. */
    Dbtype getBase() { db_case_decl_def(this, result, _, _) }

    /** Gets the node corresponding to the field `discriminator`. */
    SimpleId getDiscriminator() { db_case_decl_def(this, _, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { db_case_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_case_decl_def(this, result, _, _) or
      db_case_decl_def(this, _, result, _) or
      db_case_decl_child(this, _, result)
    }
  }

  /** A class representing `db_colType` nodes. */
  class DbColType extends @db_col_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbColType" }

    /** Gets the location of this element. */
    override Location getLocation() { db_col_type_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { db_col_type_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { db_col_type_def(this, result, _) }
  }

  /** A class representing `db_column` nodes. */
  class DbColumn extends @db_column, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbColumn" }

    /** Gets the location of this element. */
    override Location getLocation() { db_column_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `colName`. */
    SimpleId getColName() { db_column_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `colType`. */
    DbColType getColType() { db_column_def(this, _, result, _, _) }

    /** Gets the node corresponding to the field `isRef`. */
    DbRef getIsRef() { db_column_is_ref(this, result) }

    /** Gets the node corresponding to the field `isUnique`. */
    DbUnique getIsUnique() { db_column_is_unique(this, result) }

    /** Gets the node corresponding to the field `qldoc`. */
    Qldoc getQldoc() { db_column_qldoc(this, result) }

    /** Gets the node corresponding to the field `reprType`. */
    DbReprType getReprType() { db_column_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_column_def(this, result, _, _, _) or
      db_column_def(this, _, result, _, _) or
      db_column_is_ref(this, result) or
      db_column_is_unique(this, result) or
      db_column_qldoc(this, result) or
      db_column_def(this, _, _, result, _)
    }
  }

  /** A class representing `db_date` tokens. */
  class DbDate extends @token_db_date, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbDate" }
  }

  /** A class representing `db_entry` nodes. */
  class DbEntry extends @db_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbEntry" }

    /** Gets the location of this element. */
    override Location getLocation() { db_entry_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { db_entry_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { db_entry_def(this, result, _) }
  }

  /** A class representing `db_float` tokens. */
  class DbFloat extends @token_db_float, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbFloat" }
  }

  /** A class representing `db_int` tokens. */
  class DbInt extends @token_db_int, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbInt" }
  }

  /** A class representing `db_ref` tokens. */
  class DbRef extends @token_db_ref, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbRef" }
  }

  /** A class representing `db_reprType` nodes. */
  class DbReprType extends @db_repr_type, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbReprType" }

    /** Gets the location of this element. */
    override Location getLocation() { db_repr_type_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { db_repr_type_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { db_repr_type_child(this, _, result) }
  }

  /** A class representing `db_string` tokens. */
  class DbString extends @token_db_string, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbString" }
  }

  /** A class representing `db_table` nodes. */
  class DbTable extends @db_table, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbTable" }

    /** Gets the location of this element. */
    override Location getLocation() { db_table_def(this, _, result) }

    /** Gets the node corresponding to the field `tableName`. */
    DbTableName getTableName() { db_table_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { db_table_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_table_def(this, result, _) or db_table_child(this, _, result)
    }
  }

  /** A class representing `db_tableName` nodes. */
  class DbTableName extends @db_table_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbTableName" }

    /** Gets the location of this element. */
    override Location getLocation() { db_table_name_def(this, _, result) }

    /** Gets the child of this node. */
    SimpleId getChild() { db_table_name_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { db_table_name_def(this, result, _) }
  }

  /** A class representing `db_unionDecl` nodes. */
  class DbUnionDecl extends @db_union_decl, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbUnionDecl" }

    /** Gets the location of this element. */
    override Location getLocation() { db_union_decl_def(this, _, result) }

    /** Gets the node corresponding to the field `base`. */
    Dbtype getBase() { db_union_decl_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    Dbtype getChild(int i) { db_union_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      db_union_decl_def(this, result, _) or db_union_decl_child(this, _, result)
    }
  }

  /** A class representing `db_unique` tokens. */
  class DbUnique extends @token_db_unique, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbUnique" }
  }

  /** A class representing `db_varchar` tokens. */
  class DbVarchar extends @token_db_varchar, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "DbVarchar" }
  }

  /** A class representing `dbtype` tokens. */
  class Dbtype extends @token_dbtype, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Dbtype" }
  }

  /** A class representing `direction` tokens. */
  class Direction extends @token_direction, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Direction" }
  }

  /** A class representing `disjunction` nodes. */
  class Disjunction extends @disjunction, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Disjunction" }

    /** Gets the location of this element. */
    override Location getLocation() { disjunction_def(this, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { disjunction_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { disjunction_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      disjunction_def(this, result, _, _) or disjunction_def(this, _, result, _)
    }
  }

  /** A class representing `empty` tokens. */
  class Empty extends @token_empty, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Empty" }
  }

  /** A class representing `expr_aggregate_body` nodes. */
  class ExprAggregateBody extends @expr_aggregate_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ExprAggregateBody" }

    /** Gets the location of this element. */
    override Location getLocation() { expr_aggregate_body_def(this, _, result) }

    /** Gets the node corresponding to the field `asExprs`. */
    AsExprs getAsExprs() { expr_aggregate_body_def(this, result, _) }

    /** Gets the node corresponding to the field `orderBys`. */
    OrderBys getOrderBys() { expr_aggregate_body_order_bys(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      expr_aggregate_body_def(this, result, _) or expr_aggregate_body_order_bys(this, result)
    }
  }

  /** A class representing `expr_annotation` nodes. */
  class ExprAnnotation extends @expr_annotation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ExprAnnotation" }

    /** Gets the location of this element. */
    override Location getLocation() { expr_annotation_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `annot_arg`. */
    AnnotName getAnnotArg() { expr_annotation_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `name`. */
    AnnotName getName() { expr_annotation_def(this, _, result, _, _) }

    /** Gets the child of this node. */
    AstNode getChild() { expr_annotation_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      expr_annotation_def(this, result, _, _, _) or
      expr_annotation_def(this, _, result, _, _) or
      expr_annotation_def(this, _, _, result, _)
    }
  }

  /** A class representing `false` tokens. */
  class False extends @token_false, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "False" }
  }

  /** A class representing `field` nodes. */
  class Field extends @field, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Field" }

    /** Gets the location of this element. */
    override Location getLocation() { field_def(this, _, result) }

    /** Gets the child of this node. */
    VarDecl getChild() { field_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { field_def(this, result, _) }
  }

  /** A class representing `float` tokens. */
  class Float extends @token_float, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Float" }
  }

  /** A class representing `full_aggregate_body` nodes. */
  class FullAggregateBody extends @full_aggregate_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "FullAggregateBody" }

    /** Gets the location of this element. */
    override Location getLocation() { full_aggregate_body_def(this, result) }

    /** Gets the node corresponding to the field `asExprs`. */
    AsExprs getAsExprs() { full_aggregate_body_as_exprs(this, result) }

    /** Gets the node corresponding to the field `guard`. */
    AstNode getGuard() { full_aggregate_body_guard(this, result) }

    /** Gets the node corresponding to the field `orderBys`. */
    OrderBys getOrderBys() { full_aggregate_body_order_bys(this, result) }

    /** Gets the `i`th child of this node. */
    VarDecl getChild(int i) { full_aggregate_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      full_aggregate_body_as_exprs(this, result) or
      full_aggregate_body_guard(this, result) or
      full_aggregate_body_order_bys(this, result) or
      full_aggregate_body_child(this, _, result)
    }
  }

  /** A class representing `higherOrderTerm` nodes. */
  class HigherOrderTerm extends @higher_order_term, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "HigherOrderTerm" }

    /** Gets the location of this element. */
    override Location getLocation() { higher_order_term_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    LiteralId getName() { higher_order_term_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { higher_order_term_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      higher_order_term_def(this, result, _) or higher_order_term_child(this, _, result)
    }
  }

  /** A class representing `if_term` nodes. */
  class IfTerm extends @if_term, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "IfTerm" }

    /** Gets the location of this element. */
    override Location getLocation() { if_term_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `cond`. */
    AstNode getCond() { if_term_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `first`. */
    AstNode getFirst() { if_term_def(this, _, result, _, _) }

    /** Gets the node corresponding to the field `second`. */
    AstNode getSecond() { if_term_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      if_term_def(this, result, _, _, _) or
      if_term_def(this, _, result, _, _) or
      if_term_def(this, _, _, result, _)
    }
  }

  /** A class representing `implication` nodes. */
  class Implication extends @implication, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Implication" }

    /** Gets the location of this element. */
    override Location getLocation() { implication_def(this, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { implication_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { implication_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      implication_def(this, result, _, _) or implication_def(this, _, result, _)
    }
  }

  /** A class representing `importDirective` nodes. */
  class ImportDirective extends @import_directive, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ImportDirective" }

    /** Gets the location of this element. */
    override Location getLocation() { import_directive_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { import_directive_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { import_directive_child(this, _, result) }
  }

  /** A class representing `importModuleExpr` nodes. */
  class ImportModuleExpr extends @import_module_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ImportModuleExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { import_module_expr_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    SimpleId getName(int i) { import_module_expr_name(this, i, result) }

    /** Gets the child of this node. */
    QualModuleExpr getChild() { import_module_expr_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      import_module_expr_name(this, _, result) or import_module_expr_def(this, result, _)
    }
  }

  /** A class representing `in_expr` nodes. */
  class InExpr extends @in_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "InExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { in_expr_def(this, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { in_expr_def(this, result, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { in_expr_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      in_expr_def(this, result, _, _) or in_expr_def(this, _, result, _)
    }
  }

  /** A class representing `instance_of` nodes. */
  class InstanceOf extends @instance_of, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "InstanceOf" }

    /** Gets the location of this element. */
    override Location getLocation() { instance_of_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { instance_of_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { instance_of_child(this, _, result) }
  }

  /** A class representing `integer` tokens. */
  class Integer extends @token_integer, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Integer" }
  }

  /** A class representing `line_comment` tokens. */
  class LineComment extends @token_line_comment, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "LineComment" }
  }

  /** A class representing `literal` nodes. */
  class Literal extends @literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Literal" }

    /** Gets the location of this element. */
    override Location getLocation() { literal_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { literal_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { literal_def(this, result, _) }
  }

  /** A class representing `literalId` tokens. */
  class LiteralId extends @token_literal_id, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "LiteralId" }
  }

  /** A class representing `memberPredicate` nodes. */
  class MemberPredicate extends @member_predicate, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "MemberPredicate" }

    /** Gets the location of this element. */
    override Location getLocation() { member_predicate_def(this, _, _, result) }

    /** Gets the node corresponding to the field `name`. */
    PredicateName getName() { member_predicate_def(this, result, _, _) }

    /** Gets the node corresponding to the field `returnType`. */
    AstNode getReturnType() { member_predicate_def(this, _, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { member_predicate_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      member_predicate_def(this, result, _, _) or
      member_predicate_def(this, _, result, _) or
      member_predicate_child(this, _, result)
    }
  }

  /** A class representing `module` nodes. */
  class Module extends @module, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Module" }

    /** Gets the location of this element. */
    override Location getLocation() { module_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    ModuleName getName() { module_def(this, result, _) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { module_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      module_def(this, result, _) or module_child(this, _, result)
    }
  }

  /** A class representing `moduleAliasBody` nodes. */
  class ModuleAliasBody extends @module_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ModuleAliasBody" }

    /** Gets the location of this element. */
    override Location getLocation() { module_alias_body_def(this, _, result) }

    /** Gets the child of this node. */
    ModuleExpr getChild() { module_alias_body_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { module_alias_body_def(this, result, _) }
  }

  /** A class representing `moduleExpr` nodes. */
  class ModuleExpr extends @module_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ModuleExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { module_expr_def(this, _, result) }

    /** Gets the node corresponding to the field `name`. */
    SimpleId getName() { module_expr_name(this, result) }

    /** Gets the child of this node. */
    AstNode getChild() { module_expr_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      module_expr_name(this, result) or module_expr_def(this, result, _)
    }
  }

  /** A class representing `moduleMember` nodes. */
  class ModuleMember extends @module_member, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ModuleMember" }

    /** Gets the location of this element. */
    override Location getLocation() { module_member_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { module_member_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { module_member_child(this, _, result) }
  }

  /** A class representing `moduleName` nodes. */
  class ModuleName extends @module_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ModuleName" }

    /** Gets the location of this element. */
    override Location getLocation() { module_name_def(this, _, result) }

    /** Gets the child of this node. */
    SimpleId getChild() { module_name_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { module_name_def(this, result, _) }
  }

  /** A class representing `mul_expr` nodes. */
  class MulExpr extends @mul_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "MulExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { mul_expr_def(this, _, _, _, result) }

    /** Gets the node corresponding to the field `left`. */
    AstNode getLeft() { mul_expr_def(this, result, _, _, _) }

    /** Gets the node corresponding to the field `right`. */
    AstNode getRight() { mul_expr_def(this, _, result, _, _) }

    /** Gets the child of this node. */
    Mulop getChild() { mul_expr_def(this, _, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      mul_expr_def(this, result, _, _, _) or
      mul_expr_def(this, _, result, _, _) or
      mul_expr_def(this, _, _, result, _)
    }
  }

  /** A class representing `mulop` tokens. */
  class Mulop extends @token_mulop, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Mulop" }
  }

  /** A class representing `negation` nodes. */
  class Negation extends @negation, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Negation" }

    /** Gets the location of this element. */
    override Location getLocation() { negation_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { negation_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { negation_def(this, result, _) }
  }

  /** A class representing `orderBy` nodes. */
  class OrderBy extends @order_by, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "OrderBy" }

    /** Gets the location of this element. */
    override Location getLocation() { order_by_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { order_by_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { order_by_child(this, _, result) }
  }

  /** A class representing `orderBys` nodes. */
  class OrderBys extends @order_bys, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "OrderBys" }

    /** Gets the location of this element. */
    override Location getLocation() { order_bys_def(this, result) }

    /** Gets the `i`th child of this node. */
    OrderBy getChild(int i) { order_bys_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { order_bys_child(this, _, result) }
  }

  /** A class representing `par_expr` nodes. */
  class ParExpr extends @par_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "ParExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { par_expr_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { par_expr_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { par_expr_def(this, result, _) }
  }

  /** A class representing `predicate` tokens. */
  class Predicate extends @token_predicate, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Predicate" }
  }

  /** A class representing `predicateAliasBody` nodes. */
  class PredicateAliasBody extends @predicate_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "PredicateAliasBody" }

    /** Gets the location of this element. */
    override Location getLocation() { predicate_alias_body_def(this, _, result) }

    /** Gets the child of this node. */
    PredicateExpr getChild() { predicate_alias_body_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { predicate_alias_body_def(this, result, _) }
  }

  /** A class representing `predicateExpr` nodes. */
  class PredicateExpr extends @predicate_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "PredicateExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { predicate_expr_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { predicate_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { predicate_expr_child(this, _, result) }
  }

  /** A class representing `predicateName` tokens. */
  class PredicateName extends @token_predicate_name, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "PredicateName" }
  }

  /** A class representing `prefix_cast` nodes. */
  class PrefixCast extends @prefix_cast, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "PrefixCast" }

    /** Gets the location of this element. */
    override Location getLocation() { prefix_cast_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { prefix_cast_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { prefix_cast_child(this, _, result) }
  }

  /** A class representing `primitiveType` tokens. */
  class PrimitiveType extends @token_primitive_type, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "PrimitiveType" }
  }

  /** A class representing `ql` nodes. */
  class Ql extends @ql, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Ql" }

    /** Gets the location of this element. */
    override Location getLocation() { ql_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { ql_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { ql_child(this, _, result) }
  }

  /** A class representing `qldoc` tokens. */
  class Qldoc extends @token_qldoc, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Qldoc" }
  }

  /** A class representing `qualModuleExpr` nodes. */
  class QualModuleExpr extends @qual_module_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "QualModuleExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { qual_module_expr_def(this, result) }

    /** Gets the node corresponding to the field `name`. */
    SimpleId getName(int i) { qual_module_expr_name(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { qual_module_expr_name(this, _, result) }
  }

  /** A class representing `qualifiedRhs` nodes. */
  class QualifiedRhs extends @qualified_rhs, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "QualifiedRhs" }

    /** Gets the location of this element. */
    override Location getLocation() { qualified_rhs_def(this, result) }

    /** Gets the node corresponding to the field `name`. */
    PredicateName getName() { qualified_rhs_name(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { qualified_rhs_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      qualified_rhs_name(this, result) or qualified_rhs_child(this, _, result)
    }
  }

  /** A class representing `qualified_expr` nodes. */
  class QualifiedExpr extends @qualified_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "QualifiedExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { qualified_expr_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { qualified_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { qualified_expr_child(this, _, result) }
  }

  /** A class representing `quantified` nodes. */
  class Quantified extends @quantified, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Quantified" }

    /** Gets the location of this element. */
    override Location getLocation() { quantified_def(this, result) }

    /** Gets the node corresponding to the field `expr`. */
    AstNode getExpr() { quantified_expr(this, result) }

    /** Gets the node corresponding to the field `formula`. */
    AstNode getFormula() { quantified_formula(this, result) }

    /** Gets the node corresponding to the field `range`. */
    AstNode getRange() { quantified_range(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { quantified_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      quantified_expr(this, result) or
      quantified_formula(this, result) or
      quantified_range(this, result) or
      quantified_child(this, _, result)
    }
  }

  /** A class representing `quantifier` tokens. */
  class Quantifier extends @token_quantifier, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Quantifier" }
  }

  /** A class representing `range` nodes. */
  class Range extends @range, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Range" }

    /** Gets the location of this element. */
    override Location getLocation() { range_def(this, _, _, result) }

    /** Gets the node corresponding to the field `lower`. */
    AstNode getLower() { range_def(this, result, _, _) }

    /** Gets the node corresponding to the field `upper`. */
    AstNode getUpper() { range_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      range_def(this, result, _, _) or range_def(this, _, result, _)
    }
  }

  /** A class representing `result` tokens. */
  class Result extends @token_result, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Result" }
  }

  /** A class representing `select` nodes. */
  class Select extends @select, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Select" }

    /** Gets the location of this element. */
    override Location getLocation() { select_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { select_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { select_child(this, _, result) }
  }

  /** A class representing `set_literal` nodes. */
  class SetLiteral extends @set_literal, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SetLiteral" }

    /** Gets the location of this element. */
    override Location getLocation() { set_literal_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { set_literal_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { set_literal_child(this, _, result) }
  }

  /** A class representing `simpleId` tokens. */
  class SimpleId extends @token_simple_id, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SimpleId" }
  }

  /** A class representing `specialId` tokens. */
  class SpecialId extends @token_special_id, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SpecialId" }
  }

  /** A class representing `special_call` nodes. */
  class SpecialCall extends @special_call, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SpecialCall" }

    /** Gets the location of this element. */
    override Location getLocation() { special_call_def(this, _, result) }

    /** Gets the child of this node. */
    SpecialId getChild() { special_call_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { special_call_def(this, result, _) }
  }

  /** A class representing `string` tokens. */
  class String extends @token_string, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "String" }
  }

  /** A class representing `super` tokens. */
  class Super extends @token_super, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Super" }
  }

  /** A class representing `super_ref` nodes. */
  class SuperRef extends @super_ref, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "SuperRef" }

    /** Gets the location of this element. */
    override Location getLocation() { super_ref_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { super_ref_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { super_ref_child(this, _, result) }
  }

  /** A class representing `this` tokens. */
  class This extends @token_this, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "This" }
  }

  /** A class representing `true` tokens. */
  class True extends @token_true, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "True" }
  }

  /** A class representing `typeAliasBody` nodes. */
  class TypeAliasBody extends @type_alias_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "TypeAliasBody" }

    /** Gets the location of this element. */
    override Location getLocation() { type_alias_body_def(this, _, result) }

    /** Gets the child of this node. */
    TypeExpr getChild() { type_alias_body_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { type_alias_body_def(this, result, _) }
  }

  /** A class representing `typeExpr` nodes. */
  class TypeExpr extends @type_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "TypeExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { type_expr_def(this, result) }

    /** Gets the node corresponding to the field `name`. */
    ClassName getName() { type_expr_name(this, result) }

    /** Gets the child of this node. */
    AstNode getChild() { type_expr_child(this, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      type_expr_name(this, result) or type_expr_child(this, result)
    }
  }

  /** A class representing `typeUnionBody` nodes. */
  class TypeUnionBody extends @type_union_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "TypeUnionBody" }

    /** Gets the location of this element. */
    override Location getLocation() { type_union_body_def(this, result) }

    /** Gets the `i`th child of this node. */
    TypeExpr getChild(int i) { type_union_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { type_union_body_child(this, _, result) }
  }

  /** A class representing `unary_expr` nodes. */
  class UnaryExpr extends @unary_expr, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "UnaryExpr" }

    /** Gets the location of this element. */
    override Location getLocation() { unary_expr_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { unary_expr_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { unary_expr_child(this, _, result) }
  }

  /** A class representing `underscore` tokens. */
  class Underscore extends @token_underscore, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Underscore" }
  }

  /** A class representing `unop` tokens. */
  class Unop extends @token_unop, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Unop" }
  }

  /** A class representing `unqual_agg_body` nodes. */
  class UnqualAggBody extends @unqual_agg_body, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "UnqualAggBody" }

    /** Gets the location of this element. */
    override Location getLocation() { unqual_agg_body_def(this, result) }

    /** Gets the node corresponding to the field `asExprs`. */
    AstNode getAsExprs(int i) { unqual_agg_body_as_exprs(this, i, result) }

    /** Gets the node corresponding to the field `guard`. */
    AstNode getGuard() { unqual_agg_body_guard(this, result) }

    /** Gets the `i`th child of this node. */
    VarDecl getChild(int i) { unqual_agg_body_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      unqual_agg_body_as_exprs(this, _, result) or
      unqual_agg_body_guard(this, result) or
      unqual_agg_body_child(this, _, result)
    }
  }

  /** A class representing `varDecl` nodes. */
  class VarDecl extends @var_decl, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "VarDecl" }

    /** Gets the location of this element. */
    override Location getLocation() { var_decl_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { var_decl_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { var_decl_child(this, _, result) }
  }

  /** A class representing `varName` nodes. */
  class VarName extends @var_name, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "VarName" }

    /** Gets the location of this element. */
    override Location getLocation() { var_name_def(this, _, result) }

    /** Gets the child of this node. */
    SimpleId getChild() { var_name_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { var_name_def(this, result, _) }
  }

  /** A class representing `variable` nodes. */
  class Variable extends @variable, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "Variable" }

    /** Gets the location of this element. */
    override Location getLocation() { variable_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { variable_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { variable_def(this, result, _) }
  }

  /** A class representing `yaml_comment` nodes. */
  class YamlComment extends @yaml_comment, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlComment" }

    /** Gets the location of this element. */
    override Location getLocation() { yaml_comment_def(this, _, result) }

    /** Gets the child of this node. */
    YamlValue getChild() { yaml_comment_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { yaml_comment_def(this, result, _) }
  }

  /** A class representing `yaml_entry` nodes. */
  class YamlEntry extends @yaml_entry, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlEntry" }

    /** Gets the location of this element. */
    override Location getLocation() { yaml_entry_def(this, _, result) }

    /** Gets the child of this node. */
    AstNode getChild() { yaml_entry_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { yaml_entry_def(this, result, _) }
  }

  /** A class representing `yaml_key` nodes. */
  class YamlKey extends @yaml_key, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlKey" }

    /** Gets the location of this element. */
    override Location getLocation() { yaml_key_def(this, result) }

    /** Gets the `i`th child of this node. */
    AstNode getChild(int i) { yaml_key_child(this, i, result) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { yaml_key_child(this, _, result) }
  }

  /** A class representing `yaml_keyvaluepair` nodes. */
  class YamlKeyvaluepair extends @yaml_keyvaluepair, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlKeyvaluepair" }

    /** Gets the location of this element. */
    override Location getLocation() { yaml_keyvaluepair_def(this, _, _, result) }

    /** Gets the node corresponding to the field `key`. */
    YamlKey getKey() { yaml_keyvaluepair_def(this, result, _, _) }

    /** Gets the node corresponding to the field `value`. */
    YamlValue getValue() { yaml_keyvaluepair_def(this, _, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() {
      yaml_keyvaluepair_def(this, result, _, _) or yaml_keyvaluepair_def(this, _, result, _)
    }
  }

  /** A class representing `yaml_listitem` nodes. */
  class YamlListitem extends @yaml_listitem, AstNode {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlListitem" }

    /** Gets the location of this element. */
    override Location getLocation() { yaml_listitem_def(this, _, result) }

    /** Gets the child of this node. */
    YamlValue getChild() { yaml_listitem_def(this, result, _) }

    /** Gets a field or child node of this node. */
    override AstNode getAFieldOrChild() { yaml_listitem_def(this, result, _) }
  }

  /** A class representing `yaml_value` tokens. */
  class YamlValue extends @token_yaml_value, Token {
    /** Gets the name of the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "YamlValue" }
  }
}
