/**
 * INTERNAL: Do not use.
 * This module holds thin fully generated class definitions around DB entities.
 */
module Raw {
  /**
   * INTERNAL: Do not use.
   */
  class Element extends @element {
    string toString() { none() }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Locatable extends @locatable, Element { }

  /**
   * INTERNAL: Do not use.
   */
  class AstNode extends @ast_node, Locatable { }

  /**
   * INTERNAL: Do not use.
   */
  class Declaration extends @declaration, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class Expr extends @expr, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class Label extends @label, AstNode {
    override string toString() { result = "Label" }

    /**
     * Gets the name of this label.
     */
    string getName() { labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MatchArm extends @match_arm, AstNode {
    override string toString() { result = "MatchArm" }

    /**
     * Gets the pat of this match arm.
     */
    Pat getPat() { match_arms(this, result, _) }

    /**
     * Gets the guard of this match arm, if it exists.
     */
    Expr getGuard() { match_arm_guards(this, result) }

    /**
     * Gets the expression of this match arm.
     */
    Expr getExpr() { match_arms(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Pat extends @pat, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class RecordFieldPat extends @record_field_pat, AstNode {
    override string toString() { result = "RecordFieldPat" }

    /**
     * Gets the name of this record field pat.
     */
    string getName() { record_field_pats(this, result, _) }

    /**
     * Gets the pat of this record field pat.
     */
    Pat getPat() { record_field_pats(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RecordLitField extends @record_lit_field, AstNode {
    override string toString() { result = "RecordLitField" }

    /**
     * Gets the name of this record lit field.
     */
    string getName() { record_lit_fields(this, result, _) }

    /**
     * Gets the expression of this record lit field.
     */
    Expr getExpr() { record_lit_fields(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Stmt extends @stmt, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class TypeRef extends @type_ref, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class ArrayExpr extends @array_expr, Expr { }

  /**
   * INTERNAL: Do not use.
   */
  class AwaitExpr extends @await_expr, Expr {
    override string toString() { result = "AwaitExpr" }

    /**
     * Gets the expression of this await expression.
     */
    Expr getExpr() { await_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BecomeExpr extends @become_expr, Expr {
    override string toString() { result = "BecomeExpr" }

    /**
     * Gets the expression of this become expression.
     */
    Expr getExpr() { become_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BinaryOpExpr extends @binary_op_expr, Expr {
    override string toString() { result = "BinaryOpExpr" }

    /**
     * Gets the lhs of this binary op expression.
     */
    Expr getLhs() { binary_op_exprs(this, result, _) }

    /**
     * Gets the rhs of this binary op expression.
     */
    Expr getRhs() { binary_op_exprs(this, _, result) }

    /**
     * Gets the op of this binary op expression, if it exists.
     */
    string getOp() { binary_op_expr_ops(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BindPat extends @bind_pat, Pat {
    override string toString() { result = "BindPat" }

    /**
     * Gets the binding of this bind pat.
     */
    string getBindingId() { bind_pats(this, result) }

    /**
     * Gets the subpat of this bind pat, if it exists.
     */
    Pat getSubpat() { bind_pat_subpats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BlockExprBase extends @block_expr_base, Expr {
    /**
     * Gets the `index`th statement of this block expression base (0-based).
     */
    Stmt getStatement(int index) { block_expr_base_statements(this, index, result) }

    /**
     * Gets the tail of this block expression base, if it exists.
     */
    Expr getTail() { block_expr_base_tails(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoxExpr extends @box_expr, Expr {
    override string toString() { result = "BoxExpr" }

    /**
     * Gets the expression of this box expression.
     */
    Expr getExpr() { box_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoxPat extends @box_pat, Pat {
    override string toString() { result = "BoxPat" }

    /**
     * Gets the inner of this box pat.
     */
    Pat getInner() { box_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BreakExpr extends @break_expr, Expr {
    override string toString() { result = "BreakExpr" }

    /**
     * Gets the expression of this break expression, if it exists.
     */
    Expr getExpr() { break_expr_exprs(this, result) }

    /**
     * Gets the label of this break expression, if it exists.
     */
    Label getLabel() { break_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CallExpr extends @call_expr, Expr {
    override string toString() { result = "CallExpr" }

    /**
     * Gets the callee of this call expression.
     */
    Expr getCallee() { call_exprs(this, result) }

    /**
     * Gets the `index`th argument of this call expression (0-based).
     */
    Expr getArg(int index) { call_expr_args(this, index, result) }

    /**
     * Holds if this call expression is assignee expression.
     */
    predicate isAssigneeExpr() { call_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CastExpr extends @cast_expr, Expr {
    override string toString() { result = "CastExpr" }

    /**
     * Gets the expression of this cast expression.
     */
    Expr getExpr() { cast_exprs(this, result, _) }

    /**
     * Gets the type reference of this cast expression.
     */
    TypeRef getTypeRef() { cast_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ClosureExpr extends @closure_expr, Expr {
    override string toString() { result = "ClosureExpr" }

    /**
     * Gets the `index`th argument of this closure expression (0-based).
     */
    Pat getArg(int index) { closure_expr_args(this, index, result) }

    /**
     * Gets the `index`th argument type of this closure expression (0-based), if it exists.
     */
    TypeRef getArgType(int index) { closure_expr_arg_types(this, index, result) }

    /**
     * Gets the ret type of this closure expression, if it exists.
     */
    TypeRef getRetType() { closure_expr_ret_types(this, result) }

    /**
     * Gets the body of this closure expression.
     */
    Expr getBody() { closure_exprs(this, result, _) }

    /**
     * Gets the closure kind of this closure expression.
     */
    string getClosureKind() { closure_exprs(this, _, result) }

    /**
     * Holds if this closure expression is move.
     */
    predicate isMove() { closure_expr_is_move(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConstBlockPat extends @const_block_pat, Pat {
    override string toString() { result = "ConstBlockPat" }

    /**
     * Gets the expression of this const block pat.
     */
    Expr getExpr() { const_block_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConstExpr extends @const_expr, Expr {
    override string toString() { result = "ConstExpr" }

    /**
     * Gets the expression of this const expression.
     */
    Expr getExpr() { const_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ContinueExpr extends @continue_expr, Expr {
    override string toString() { result = "ContinueExpr" }

    /**
     * Gets the label of this continue expression, if it exists.
     */
    Label getLabel() { continue_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExprStmt extends @expr_stmt, Stmt {
    override string toString() { result = "ExprStmt" }

    /**
     * Gets the expression of this expression statement.
     */
    Expr getExpr() { expr_stmts(this, result) }

    /**
     * Holds if this expression statement has semicolon.
     */
    predicate hasSemicolon() { expr_stmt_has_semicolon(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class FieldExpr extends @field_expr, Expr {
    override string toString() { result = "FieldExpr" }

    /**
     * Gets the expression of this field expression.
     */
    Expr getExpr() { field_exprs(this, result, _) }

    /**
     * Gets the name of this field expression.
     */
    string getName() { field_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A function declaration. For example
   * ```
   * fn foo(x: u32) -> u64 { (x + 1).into() }
   * ```
   * A function declaration within a trait might not have a body:
   * ```
   * trait Trait {
   *     fn bar();
   * }
   * ```
   */
  class Function extends @function, Declaration {
    override string toString() { result = "Function" }

    /**
     * Gets the name of this function.
     */
    string getName() { functions(this, result, _) }

    /**
     * Gets the body of this function.
     */
    Expr getBody() { functions(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IfExpr extends @if_expr, Expr {
    override string toString() { result = "IfExpr" }

    /**
     * Gets the condition of this if expression.
     */
    Expr getCondition() { if_exprs(this, result, _) }

    /**
     * Gets the then of this if expression.
     */
    Expr getThen() { if_exprs(this, _, result) }

    /**
     * Gets the else of this if expression, if it exists.
     */
    Expr getElse() { if_expr_elses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IndexExpr extends @index_expr, Expr {
    override string toString() { result = "IndexExpr" }

    /**
     * Gets the base of this index expression.
     */
    Expr getBase() { index_exprs(this, result, _) }

    /**
     * Gets the index of this index expression.
     */
    Expr getIndex() { index_exprs(this, _, result) }

    /**
     * Holds if this index expression is assignee expression.
     */
    predicate isAssigneeExpr() { index_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InlineAsmExpr extends @inline_asm_expr, Expr {
    override string toString() { result = "InlineAsmExpr" }

    /**
     * Gets the expression of this inline asm expression.
     */
    Expr getExpr() { inline_asm_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ItemStmt extends @item_stmt, Stmt {
    override string toString() { result = "ItemStmt" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LetExpr extends @let_expr, Expr {
    override string toString() { result = "LetExpr" }

    /**
     * Gets the pat of this let expression.
     */
    Pat getPat() { let_exprs(this, result, _) }

    /**
     * Gets the expression of this let expression.
     */
    Expr getExpr() { let_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LetStmt extends @let_stmt, Stmt {
    override string toString() { result = "LetStmt" }

    /**
     * Gets the pat of this let statement.
     */
    Pat getPat() { let_stmts(this, result) }

    /**
     * Gets the type reference of this let statement, if it exists.
     */
    TypeRef getTypeRef() { let_stmt_type_refs(this, result) }

    /**
     * Gets the initializer of this let statement, if it exists.
     */
    Expr getInitializer() { let_stmt_initializers(this, result) }

    /**
     * Gets the else of this let statement, if it exists.
     */
    Expr getElse() { let_stmt_elses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LitPat extends @lit_pat, Pat {
    override string toString() { result = "LitPat" }

    /**
     * Gets the expression of this lit pat.
     */
    Expr getExpr() { lit_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LiteralExpr extends @literal_expr, Expr {
    override string toString() { result = "LiteralExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LoopExpr extends @loop_expr, Expr {
    override string toString() { result = "LoopExpr" }

    /**
     * Gets the body of this loop expression.
     */
    Expr getBody() { loop_exprs(this, result) }

    /**
     * Gets the label of this loop expression, if it exists.
     */
    Label getLabel() { loop_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MatchExpr extends @match_expr, Expr {
    override string toString() { result = "MatchExpr" }

    /**
     * Gets the expression of this match expression.
     */
    Expr getExpr() { match_exprs(this, result) }

    /**
     * Gets the `index`th branch of this match expression (0-based).
     */
    MatchArm getBranch(int index) { match_expr_branches(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MethodCallExpr extends @method_call_expr, Expr {
    override string toString() { result = "MethodCallExpr" }

    /**
     * Gets the receiver of this method call expression.
     */
    Expr getReceiver() { method_call_exprs(this, result, _) }

    /**
     * Gets the method name of this method call expression.
     */
    string getMethodName() { method_call_exprs(this, _, result) }

    /**
     * Gets the `index`th argument of this method call expression (0-based).
     */
    Expr getArg(int index) { method_call_expr_args(this, index, result) }

    /**
     * Gets the generic arguments of this method call expression, if it exists.
     */
    Unimplemented getGenericArgs() { method_call_expr_generic_args(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MissingExpr extends @missing_expr, Expr {
    override string toString() { result = "MissingExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MissingPat extends @missing_pat, Pat {
    override string toString() { result = "MissingPat" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Module extends @module, Declaration {
    override string toString() { result = "Module" }

    /**
     * Gets the `index`th declaration of this module (0-based).
     */
    Declaration getDeclaration(int index) { module_declarations(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OffsetOfExpr extends @offset_of_expr, Expr {
    override string toString() { result = "OffsetOfExpr" }

    /**
     * Gets the container of this offset of expression.
     */
    TypeRef getContainer() { offset_of_exprs(this, result) }

    /**
     * Gets the `index`th field of this offset of expression (0-based).
     */
    string getField(int index) { offset_of_expr_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OrPat extends @or_pat, Pat {
    override string toString() { result = "OrPat" }

    /**
     * Gets the `index`th argument of this or pat (0-based).
     */
    Pat getArg(int index) { or_pat_args(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PathExpr extends @path_expr, Expr {
    override string toString() { result = "PathExpr" }

    /**
     * Gets the path of this path expression.
     */
    Unimplemented getPath() { path_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PathPat extends @path_pat, Pat {
    override string toString() { result = "PathPat" }

    /**
     * Gets the path of this path pat.
     */
    Unimplemented getPath() { path_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RangeExpr extends @range_expr, Expr {
    override string toString() { result = "RangeExpr" }

    /**
     * Gets the lhs of this range expression, if it exists.
     */
    Expr getLhs() { range_expr_lhs(this, result) }

    /**
     * Gets the rhs of this range expression, if it exists.
     */
    Expr getRhs() { range_expr_rhs(this, result) }

    /**
     * Holds if this range expression is inclusive.
     */
    predicate isInclusive() { range_expr_is_inclusive(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RangePat extends @range_pat, Pat {
    override string toString() { result = "RangePat" }

    /**
     * Gets the start of this range pat, if it exists.
     */
    Pat getStart() { range_pat_starts(this, result) }

    /**
     * Gets the end of this range pat, if it exists.
     */
    Pat getEnd() { range_pat_ends(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RecordLitExpr extends @record_lit_expr, Expr {
    override string toString() { result = "RecordLitExpr" }

    /**
     * Gets the path of this record lit expression, if it exists.
     */
    Unimplemented getPath() { record_lit_expr_paths(this, result) }

    /**
     * Gets the `index`th field of this record lit expression (0-based).
     */
    RecordLitField getField(int index) { record_lit_expr_fields(this, index, result) }

    /**
     * Gets the spread of this record lit expression, if it exists.
     */
    Expr getSpread() { record_lit_expr_spreads(this, result) }

    /**
     * Holds if this record lit expression has ellipsis.
     */
    predicate hasEllipsis() { record_lit_expr_has_ellipsis(this) }

    /**
     * Holds if this record lit expression is assignee expression.
     */
    predicate isAssigneeExpr() { record_lit_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RecordPat extends @record_pat, Pat {
    override string toString() { result = "RecordPat" }

    /**
     * Gets the path of this record pat, if it exists.
     */
    Unimplemented getPath() { record_pat_paths(this, result) }

    /**
     * Gets the `index`th argument of this record pat (0-based).
     */
    RecordFieldPat getArg(int index) { record_pat_args(this, index, result) }

    /**
     * Holds if this record pat has ellipsis.
     */
    predicate hasEllipsis() { record_pat_has_ellipsis(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RefExpr extends @ref_expr, Expr {
    override string toString() { result = "RefExpr" }

    /**
     * Gets the expression of this reference expression.
     */
    Expr getExpr() { ref_exprs(this, result) }

    /**
     * Holds if this reference expression is raw.
     */
    predicate isRaw() { ref_expr_is_raw(this) }

    /**
     * Holds if this reference expression is mut.
     */
    predicate isMut() { ref_expr_is_mut(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RefPat extends @ref_pat, Pat {
    override string toString() { result = "RefPat" }

    /**
     * Gets the pat of this reference pat.
     */
    Pat getPat() { ref_pats(this, result) }

    /**
     * Holds if this reference pat is mut.
     */
    predicate isMut() { ref_pat_is_mut(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ReturnExpr extends @return_expr, Expr {
    override string toString() { result = "ReturnExpr" }

    /**
     * Gets the expression of this return expression, if it exists.
     */
    Expr getExpr() { return_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class SlicePat extends @slice_pat, Pat {
    override string toString() { result = "SlicePat" }

    /**
     * Gets the `index`th prefix of this slice pat (0-based).
     */
    Pat getPrefix(int index) { slice_pat_prefixes(this, index, result) }

    /**
     * Gets the slice of this slice pat, if it exists.
     */
    Pat getSlice() { slice_pat_slice(this, result) }

    /**
     * Gets the `index`th suffix of this slice pat (0-based).
     */
    Pat getSuffix(int index) { slice_pat_suffixes(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TupleExpr extends @tuple_expr, Expr {
    override string toString() { result = "TupleExpr" }

    /**
     * Gets the `index`th expression of this tuple expression (0-based).
     */
    Expr getExpr(int index) { tuple_expr_exprs(this, index, result) }

    /**
     * Holds if this tuple expression is assignee expression.
     */
    predicate isAssigneeExpr() { tuple_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TuplePat extends @tuple_pat, Pat {
    override string toString() { result = "TuplePat" }

    /**
     * Gets the `index`th argument of this tuple pat (0-based).
     */
    Pat getArg(int index) { tuple_pat_args(this, index, result) }

    /**
     * Gets the ellipsis index of this tuple pat, if it exists.
     */
    int getEllipsisIndex() { tuple_pat_ellipsis_indices(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TupleStructPat extends @tuple_struct_pat, Pat {
    override string toString() { result = "TupleStructPat" }

    /**
     * Gets the path of this tuple struct pat, if it exists.
     */
    Unimplemented getPath() { tuple_struct_pat_paths(this, result) }

    /**
     * Gets the `index`th argument of this tuple struct pat (0-based).
     */
    Pat getArg(int index) { tuple_struct_pat_args(this, index, result) }

    /**
     * Gets the ellipsis index of this tuple struct pat, if it exists.
     */
    int getEllipsisIndex() { tuple_struct_pat_ellipsis_indices(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnaryOpExpr extends @unary_op_expr, Expr {
    override string toString() { result = "UnaryOpExpr" }

    /**
     * Gets the expression of this unary op expression.
     */
    Expr getExpr() { unary_op_exprs(this, result, _) }

    /**
     * Gets the op of this unary op expression.
     */
    string getOp() { unary_op_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnderscoreExpr extends @underscore_expr, Expr {
    override string toString() { result = "UnderscoreExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Unimplemented extends @unimplemented, Declaration, TypeRef {
    override string toString() { result = "Unimplemented" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class WildPat extends @wild_pat, Pat {
    override string toString() { result = "WildPat" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class YeetExpr extends @yeet_expr, Expr {
    override string toString() { result = "YeetExpr" }

    /**
     * Gets the expression of this yeet expression, if it exists.
     */
    Expr getExpr() { yeet_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class YieldExpr extends @yield_expr, Expr {
    override string toString() { result = "YieldExpr" }

    /**
     * Gets the expression of this yield expression, if it exists.
     */
    Expr getExpr() { yield_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsyncBlockExpr extends @async_block_expr, BlockExprBase {
    override string toString() { result = "AsyncBlockExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BlockExpr extends @block_expr, BlockExprBase {
    override string toString() { result = "BlockExpr" }

    /**
     * Gets the label of this block expression, if it exists.
     */
    Label getLabel() { block_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ElementListExpr extends @element_list_expr, ArrayExpr {
    override string toString() { result = "ElementListExpr" }

    /**
     * Gets the `index`th element of this element list expression (0-based).
     */
    Expr getElement(int index) { element_list_expr_elements(this, index, result) }

    /**
     * Holds if this element list expression is assignee expression.
     */
    predicate isAssigneeExpr() { element_list_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RepeatExpr extends @repeat_expr, ArrayExpr {
    override string toString() { result = "RepeatExpr" }

    /**
     * Gets the initializer of this repeat expression.
     */
    Expr getInitializer() { repeat_exprs(this, result, _) }

    /**
     * Gets the repeat of this repeat expression.
     */
    Expr getRepeat() { repeat_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnsafeBlockExpr extends @unsafe_block_expr, BlockExprBase {
    override string toString() { result = "UnsafeBlockExpr" }
  }
}
