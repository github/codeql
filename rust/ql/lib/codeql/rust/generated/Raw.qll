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
  class File extends @file, Element {
    /**
     * Gets the name of this file.
     */
    string getName() { files(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Locatable extends @locatable, Element {
    /**
     * Gets the location of this locatable, if it exists.
     */
    Location getLocation() { locatable_locations(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Location extends @location, Element {
    /**
     * Gets the file of this location.
     */
    File getFile() { locations(this, result, _, _, _, _) }

    /**
     * Gets the start line of this location.
     */
    int getStartLine() { locations(this, _, result, _, _, _) }

    /**
     * Gets the start column of this location.
     */
    int getStartColumn() { locations(this, _, _, result, _, _) }

    /**
     * Gets the end line of this location.
     */
    int getEndLine() { locations(this, _, _, _, result, _) }

    /**
     * Gets the end column of this location.
     */
    int getEndColumn() { locations(this, _, _, _, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AstNode extends @ast_node, Locatable { }

  /**
   * INTERNAL: Do not use.
   */
  class DbFile extends @db_file, File {
    override string toString() { result = "DbFile" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DbLocation extends @db_location, Location {
    override string toString() { result = "DbLocation" }
  }

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
  class Stmt extends @stmt, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class TypeRef extends @type_ref, AstNode {
    override string toString() { result = "TypeRef" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Array extends @array, Expr {
    override string toString() { result = "Array" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Await extends @await, Expr {
    override string toString() { result = "Await" }

    /**
     * Gets the expression of this await.
     */
    Expr getExpr() { awaits(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Become extends @become, Expr {
    override string toString() { result = "Become" }

    /**
     * Gets the expression of this become.
     */
    Expr getExpr() { becomes(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BinaryOp extends @binary_op, Expr {
    override string toString() { result = "BinaryOp" }

    /**
     * Gets the lhs of this binary op.
     */
    Expr getLhs() { binary_ops(this, result, _) }

    /**
     * Gets the rhs of this binary op.
     */
    Expr getRhs() { binary_ops(this, _, result) }

    /**
     * Gets the op of this binary op, if it exists.
     */
    string getOp() { binary_op_ops(this, result) }
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
  class BlockBase extends @block_base, Expr {
    /**
     * Gets the `index`th statement of this block base (0-based).
     */
    Stmt getStatement(int index) { block_base_statements(this, index, result) }

    /**
     * Gets the tail of this block base, if it exists.
     */
    Expr getTail() { block_base_tails(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Box extends @box, Expr {
    override string toString() { result = "Box" }

    /**
     * Gets the expression of this box.
     */
    Expr getExpr() { boxes(this, result) }
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
  class Break extends @break, Expr {
    override string toString() { result = "Break" }

    /**
     * Gets the expression of this break, if it exists.
     */
    Expr getExpr() { break_exprs(this, result) }

    /**
     * Gets the label of this break, if it exists.
     */
    Label getLabel() { break_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Call extends @call, Expr {
    override string toString() { result = "Call" }

    /**
     * Gets the callee of this call.
     */
    Expr getCallee() { calls(this, result) }

    /**
     * Gets the `index`th argument of this call (0-based).
     */
    Expr getArg(int index) { call_args(this, index, result) }

    /**
     * Holds if this call is assignee expression.
     */
    predicate isAssigneeExpr() { call_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Cast extends @cast, Expr {
    override string toString() { result = "Cast" }

    /**
     * Gets the expression of this cast.
     */
    Expr getExpr() { casts(this, result, _) }

    /**
     * Gets the type reference of this cast.
     */
    TypeRef getTypeRef() { casts(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Closure extends @closure, Expr {
    override string toString() { result = "Closure" }

    /**
     * Gets the `index`th argument of this closure (0-based).
     */
    Pat getArg(int index) { closure_args(this, index, result) }

    /**
     * Gets the `index`th argument type of this closure (0-based), if it exists.
     */
    TypeRef getArgType(int index) { closure_arg_types(this, index, result) }

    /**
     * Gets the ret type of this closure, if it exists.
     */
    TypeRef getRetType() { closure_ret_types(this, result) }

    /**
     * Gets the body of this closure.
     */
    Expr getBody() { closures(this, result) }

    /**
     * Holds if this closure is move.
     */
    predicate isMove() { closure_is_move(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Const extends @const, Expr {
    override string toString() { result = "Const" }
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
  class Continue extends @continue, Expr {
    override string toString() { result = "Continue" }

    /**
     * Gets the label of this continue, if it exists.
     */
    Label getLabel() { continue_labels(this, result) }
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
     * Holds if this expression statement has semi.
     */
    predicate hasSemi() { expr_stmt_has_semi(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Field extends @field, Expr {
    override string toString() { result = "Field" }

    /**
     * Gets the expression of this field.
     */
    Expr getExpr() { fields(this, result, _) }

    /**
     * Gets the name of this field.
     */
    string getName() { fields(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
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
  class If extends @if, Expr {
    override string toString() { result = "If" }

    /**
     * Gets the condition of this if.
     */
    Expr getCondition() { ifs(this, result, _) }

    /**
     * Gets the then of this if.
     */
    Expr getThen() { ifs(this, _, result) }

    /**
     * Gets the else of this if, if it exists.
     */
    Expr getElse() { if_elses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IfLet extends @if_let, Stmt {
    override string toString() { result = "IfLet" }

    /**
     * Gets the pat of this if let.
     */
    Pat getPat() { if_lets(this, result) }

    /**
     * Gets the type reference of this if let, if it exists.
     */
    TypeRef getTypeRef() { if_let_type_refs(this, result) }

    /**
     * Gets the initializer of this if let, if it exists.
     */
    Expr getInitializer() { if_let_initializers(this, result) }

    /**
     * Gets the else branch of this if let, if it exists.
     */
    Expr getElseBranch() { if_let_else_branches(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Index extends @index, Expr {
    override string toString() { result = "Index" }

    /**
     * Gets the base of this index.
     */
    Expr getBase() { indices(this, result, _) }

    /**
     * Gets the index of this index.
     */
    Expr getIndex() { indices(this, _, result) }

    /**
     * Holds if this index is assignee expression.
     */
    predicate isAssigneeExpr() { index_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InlineAsm extends @inline_asm, Expr {
    override string toString() { result = "InlineAsm" }
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
  class Let extends @let, Expr {
    override string toString() { result = "Let" }

    /**
     * Gets the pat of this let.
     */
    Pat getPat() { lets(this, result, _) }

    /**
     * Gets the expression of this let.
     */
    Expr getExpr() { lets(this, _, result) }
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
  class Literal extends @literal, Expr {
    override string toString() { result = "Literal" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Loop extends @loop, Expr {
    override string toString() { result = "Loop" }

    /**
     * Gets the body of this loop.
     */
    Expr getBody() { loops(this, result) }

    /**
     * Gets the label of this loop, if it exists.
     */
    Label getLabel() { loop_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Match extends @match, Expr {
    override string toString() { result = "Match" }

    /**
     * Gets the expression of this match.
     */
    Expr getExpr() { matches(this, result) }

    /**
     * Gets the `index`th branch of this match (0-based).
     */
    MatchArm getBranch(int index) { match_branches(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MethodCall extends @method_call, Expr {
    override string toString() { result = "MethodCall" }

    /**
     * Gets the receiver of this method call.
     */
    Expr getReceiver() { method_calls(this, result, _) }

    /**
     * Gets the method name of this method call.
     */
    string getMethodName() { method_calls(this, _, result) }

    /**
     * Gets the `index`th argument of this method call (0-based).
     */
    Expr getArg(int index) { method_call_args(this, index, result) }
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
  class OffsetOf extends @offset_of, Expr {
    override string toString() { result = "OffsetOf" }
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
  class Path extends @path, Expr {
    override string toString() { result = "Path" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PathPat extends @path_pat, Pat {
    override string toString() { result = "PathPat" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Range extends @range, Expr {
    override string toString() { result = "Range" }

    /**
     * Gets the lhs of this range, if it exists.
     */
    Expr getLhs() { range_lhs(this, result) }

    /**
     * Gets the rhs of this range, if it exists.
     */
    Expr getRhs() { range_rhs(this, result) }

    /**
     * Holds if this range is inclusive.
     */
    predicate isInclusive() { range_is_inclusive(this) }
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
  class RecordLit extends @record_lit, Expr {
    override string toString() { result = "RecordLit" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class RecordPat extends @record_pat, Pat {
    override string toString() { result = "RecordPat" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Ref extends @ref, Expr {
    override string toString() { result = "Ref" }

    /**
     * Gets the expression of this reference.
     */
    Expr getExpr() { refs(this, result) }

    /**
     * Holds if this reference is raw.
     */
    predicate isRaw() { ref_is_raw(this) }

    /**
     * Holds if this reference is mut.
     */
    predicate isMut() { ref_is_mut(this) }
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
  class Return extends @return, Expr {
    override string toString() { result = "Return" }

    /**
     * Gets the expression of this return, if it exists.
     */
    Expr getExpr() { return_exprs(this, result) }
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
  }

  /**
   * INTERNAL: Do not use.
   */
  class Tuple extends @tuple, Expr {
    override string toString() { result = "Tuple" }

    /**
     * Gets the `index`th expression of this tuple (0-based).
     */
    Expr getExpr(int index) { tuple_exprs(this, index, result) }

    /**
     * Holds if this tuple is assignee expression.
     */
    predicate isAssigneeExpr() { tuple_is_assignee_expr(this) }
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
     * Gets the ellipsis of this tuple pat, if it exists.
     */
    int getEllipsis() { tuple_pat_ellipses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TupleStructPat extends @tuple_struct_pat, Pat {
    override string toString() { result = "TupleStructPat" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnaryOp extends @unary_op, Expr {
    override string toString() { result = "UnaryOp" }

    /**
     * Gets the expression of this unary op.
     */
    Expr getExpr() { unary_ops(this, result, _) }

    /**
     * Gets the op of this unary op.
     */
    string getOp() { unary_ops(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Underscore extends @underscore, Expr {
    override string toString() { result = "Underscore" }
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
  class Yeet extends @yeet, Expr {
    override string toString() { result = "Yeet" }

    /**
     * Gets the expression of this yeet, if it exists.
     */
    Expr getExpr() { yeet_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Yield extends @yield, Expr {
    override string toString() { result = "Yield" }

    /**
     * Gets the expression of this yield, if it exists.
     */
    Expr getExpr() { yield_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsyncBlock extends @async_block, BlockBase {
    override string toString() { result = "AsyncBlock" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Block extends @block, BlockBase {
    override string toString() { result = "Block" }

    /**
     * Gets the label of this block, if it exists.
     */
    Label getLabel() { block_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnsafeBlock extends @unsafe_block, BlockBase {
    override string toString() { result = "UnsafeBlock" }
  }
}
