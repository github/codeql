class Element extends @element {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

class Expr extends Element, @expr { }

class Pat extends Element, @pat { }

class AnyAttr extends Element, @any_attr { }

class ParenExpr extends Element, @paren_expr { }

class ArgList extends Element, @arg_list { }

class ArrayExprInternal extends Element, @array_expr_internal { }

class BlockExpr extends Element, @block_expr { }

class AsmConst extends Element, @asm_const { }

class AsmExpr extends Element, @asm_expr { }

class AsmOperandExpr extends Element, @asm_operand_expr { }

class AwaitExpr extends Element, @await_expr { }

class BecomeExpr extends Element, @become_expr { }

class BinaryExpr extends Element, @binary_expr { }

class BoxPat extends Element, @box_pat { }

class BreakExpr extends Element, @break_expr { }

class CallExpr extends Element, @call_expr { }

class CastExpr extends Element, @cast_expr { }

class ClosureExpr extends Element, @closure_expr { }

class Const extends Element, @const { }

class ConstArg extends Element, @const_arg { }

class ContinueExpr extends Element, @continue_expr { }

class DerefPat extends Element, @deref_pat { }

class ExprStmt extends Element, @expr_stmt { }

class FieldExpr extends Element, @field_expr { }

class ForExpr extends Element, @for_expr { }

class FormatArgsArg extends Element, @format_args_arg { }

class FormatArgsExpr extends Element, @format_args_expr { }

class IdentPat extends Element, @ident_pat { }

class IfExpr extends Element, @if_expr { }

class IndexExpr extends Element, @index_expr { }

class KeyValueMeta extends Element, @key_value_meta { }

class LetExpr extends Element, @let_expr { }

class LetStmt extends Element, @let_stmt { }

class LiteralExpr extends Element, @literal_expr { }

class MatchArm extends Element, @match_arm { }

class MatchExpr extends Element, @match_expr { }

class MatchGuard extends Element, @match_guard { }

class MacroExpr extends Element, @macro_expr { }

class MethodCallExpr extends Element, @method_call_expr { }

class OrPat extends Element, @or_pat { }

class OffsetOfExpr extends Element, @offset_of_expr { }

class Param extends Element, @param { }

class PatternTypeRepr extends Element, @pattern_type_repr { }

class PathExpr extends Element, @path_expr { }

class PrefixExpr extends Element, @prefix_expr { }

class RangeExpr extends Element, @range_expr { }

class RangePat extends Element, @range_pat { }

class RefExpr extends Element, @ref_expr { }

class RefPat extends Element, @ref_pat { }

class ReturnExpr extends Element, @return_expr { }

class SlicePat extends Element, @slice_pat { }

class Static extends Element, @static { }

class StmtList extends Element, @stmt_list { }

class StructExpr extends Element, @struct_expr { }

class StructExprField extends Element, @struct_expr_field { }

class StructExprFieldList extends Element, @struct_expr_field_list { }

class StructPatField extends Element, @struct_pat_field { }

class TryExpr extends Element, @try_expr { }

class TupleExpr extends Element, @tuple_expr { }

class TuplePat extends Element, @tuple_pat { }

class TupleStructPat extends Element, @tuple_struct_pat { }

class LoopExpr extends Element, @loop_expr { }

class UnderscoreExpr extends Element, @underscore_expr { }

class WhileExpr extends Element, @while_expr { }

class YeetExpr extends Element, @yeet_expr { }

class YieldExpr extends Element, @yield_expr { }

private predicate stripExpr(Expr expr, Expr unwrapped) {
  expr = unwrapped and not paren_exprs(expr)
  or
  exists(Expr inner |
    paren_expr_exprs(expr, inner) and
    stripExpr(inner, unwrapped)
  )
}

private predicate stripPat(Pat pat, Pat unwrapped) {
  pat = unwrapped and not paren_pats(pat)
  or
  exists(Pat inner |
    paren_pat_pats(pat, inner) and
    stripPat(inner, unwrapped)
  )
}

private predicate stripAstNode(Element node, Element unwrapped) {
  exists(Expr expr | node = expr and stripExpr(expr, unwrapped))
  or
  exists(Pat pat | node = pat and stripPat(pat, unwrapped))
  or
  node = unwrapped and not paren_exprs(node) and not paren_pats(node)
}

private predicate deletedNode(Element id) { paren_exprs(id) or paren_pats(id) }

private predicate wrapsExpr(Expr outer, Expr inner) {
  paren_expr_exprs(outer, inner)
  or
  exists(Expr child |
    paren_expr_exprs(outer, child) and
    wrapsExpr(child, inner)
  )
}

private int numberOfParenthesizedExprAttrs(Expr expr) {
  result =
    count(ParenExpr wrapper, int index |
      stripExpr(wrapper, expr) and
      paren_expr_attrs(wrapper, index, _)
    )
}

private int numberOfOuterParenthesizedExprAttrs(ParenExpr expr) {
  result =
    count(ParenExpr outer, int index |
      wrapsExpr(outer, expr) and
      outer != expr and
      paren_expr_attrs(outer, index, _)
    )
}

private predicate exprAttrs(Element id, int index, AnyAttr attr) {
  array_expr_internal_attrs(id, index, attr) or
  asm_expr_attrs(id, index, attr) or
  await_expr_attrs(id, index, attr) or
  become_expr_attrs(id, index, attr) or
  binary_expr_attrs(id, index, attr) or
  break_expr_attrs(id, index, attr) or
  call_expr_attrs(id, index, attr) or
  cast_expr_attrs(id, index, attr) or
  block_expr_attrs(id, index, attr) or
  callable_attrs(id, index, attr) or
  continue_expr_attrs(id, index, attr) or
  field_expr_attrs(id, index, attr) or
  format_args_expr_attrs(id, index, attr) or
  for_expr_attrs(id, index, attr) or
  if_expr_attrs(id, index, attr) or
  index_expr_attrs(id, index, attr) or
  let_expr_attrs(id, index, attr) or
  literal_expr_attrs(id, index, attr) or
  loop_expr_attrs(id, index, attr) or
  match_expr_attrs(id, index, attr) or
  method_call_expr_attrs(id, index, attr) or
  offset_of_expr_attrs(id, index, attr) or
  path_expr_attrs(id, index, attr) or
  prefix_expr_attrs(id, index, attr) or
  range_expr_attrs(id, index, attr) or
  ref_expr_attrs(id, index, attr) or
  return_expr_attrs(id, index, attr) or
  try_expr_attrs(id, index, attr) or
  tuple_expr_attrs(id, index, attr) or
  underscore_expr_attrs(id, index, attr) or
  while_expr_attrs(id, index, attr) or
  yeet_expr_attrs(id, index, attr) or
  yield_expr_attrs(id, index, attr)
}

private predicate mergedExprAttrs(Expr expr, int index, AnyAttr attr) {
  exists(int originalIndex |
    exprAttrs(expr, originalIndex, attr) and
    index = originalIndex + numberOfParenthesizedExprAttrs(expr)
  )
  or
  exists(ParenExpr wrapper, int originalIndex |
    paren_expr_attrs(wrapper, originalIndex, attr) and
    stripExpr(wrapper, expr) and
    index = numberOfOuterParenthesizedExprAttrs(wrapper) + originalIndex
  )
}

query predicate new_locatable_locations(Element id, Location location) {
  locatable_locations(id, location) and not deletedNode(id)
}

query predicate new_macro_call_macro_call_expansions(Element macroCall, Element expansion) {
  exists(Element oldExpansion |
    macro_call_macro_call_expansions(macroCall, oldExpansion) and
    stripAstNode(oldExpansion, expansion)
  )
}

query predicate new_comments(Element id, Element parent, string text) {
  exists(Element oldParent |
    comments(id, oldParent, text) and
    stripAstNode(oldParent, parent)
  )
}

query predicate new_arg_list_args(ArgList id, int index, Expr arg) {
  arg =
    rank[index + 1](Expr oldArg, Expr unwrappedArg, int oldIndex |
      arg_list_args(id, oldIndex, oldArg) and stripExpr(oldArg, unwrappedArg)
    |
      unwrappedArg order by oldIndex
    )
}

query predicate new_asm_operand_expr_in_exprs(AsmOperandExpr id, Expr in_expr) {
  exists(Expr oldExpr | asm_operand_expr_in_exprs(id, oldExpr) and stripExpr(oldExpr, in_expr))
}

query predicate new_asm_operand_expr_out_exprs(AsmOperandExpr id, Expr out_expr) {
  exists(Expr oldExpr | asm_operand_expr_out_exprs(id, oldExpr) and stripExpr(oldExpr, out_expr))
}

query predicate new_format_args_arg_exprs(FormatArgsArg id, Expr expr) {
  exists(Expr oldExpr | format_args_arg_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_match_arm_exprs(MatchArm id, Expr expr) {
  exists(Expr oldExpr | match_arm_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_match_arm_pats(MatchArm id, Pat pat) {
  exists(Pat oldPat | match_arm_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_match_guard_conditions(MatchGuard id, Expr condition) {
  exists(Expr oldExpr | match_guard_conditions(id, oldExpr) and stripExpr(oldExpr, condition))
}

query predicate new_stmt_list_tail_exprs(StmtList id, Expr tail_expr) {
  exists(Expr oldExpr | stmt_list_tail_exprs(id, oldExpr) and stripExpr(oldExpr, tail_expr))
}

query predicate new_struct_expr_field_exprs(StructExprField id, Expr expr) {
  exists(Expr oldExpr | struct_expr_field_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_struct_expr_field_list_spreads(StructExprFieldList id, Expr spread) {
  exists(Expr oldExpr | struct_expr_field_list_spreads(id, oldExpr) and stripExpr(oldExpr, spread))
}

query predicate new_struct_pat_field_pats(StructPatField id, Pat pat) {
  exists(Pat oldPat | struct_pat_field_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_array_expr_internal_exprs(ArrayExprInternal id, int index, Expr expr) {
  expr =
    rank[index + 1](Expr oldExpr, Expr unwrappedExpr, int oldIndex |
      array_expr_internal_exprs(id, oldIndex, oldExpr) and stripExpr(oldExpr, unwrappedExpr)
    |
      unwrappedExpr order by oldIndex
    )
}

query predicate new_asm_const_exprs(AsmConst id, Expr expr) {
  exists(Expr oldExpr | asm_const_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_await_expr_exprs(AwaitExpr id, Expr expr) {
  exists(Expr oldExpr | await_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_become_expr_exprs(BecomeExpr id, Expr expr) {
  exists(Expr oldExpr | become_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_binary_expr_lhs(BinaryExpr id, Expr lhs) {
  exists(Expr oldExpr | binary_expr_lhs(id, oldExpr) and stripExpr(oldExpr, lhs))
}

query predicate new_binary_expr_rhs(BinaryExpr id, Expr rhs) {
  exists(Expr oldExpr | binary_expr_rhs(id, oldExpr) and stripExpr(oldExpr, rhs))
}

query predicate new_box_pat_pats(BoxPat id, Pat pat) {
  exists(Pat oldPat | box_pat_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_break_expr_exprs(BreakExpr id, Expr expr) {
  exists(Expr oldExpr | break_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_call_expr_functions(CallExpr id, Expr function) {
  exists(Expr oldExpr | call_expr_functions(id, oldExpr) and stripExpr(oldExpr, function))
}

query predicate new_cast_expr_exprs(CastExpr id, Expr expr) {
  exists(Expr oldExpr | cast_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_closure_expr_closure_bodies(ClosureExpr id, Expr closure_body) {
  exists(Expr oldExpr |
    closure_expr_closure_bodies(id, oldExpr) and stripExpr(oldExpr, closure_body)
  )
}

query predicate new_const_arg_exprs(ConstArg id, Expr expr) {
  exists(Expr oldExpr | const_arg_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_deref_pat_pats(DerefPat id, Pat pat) {
  exists(Pat oldPat | deref_pat_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_expr_stmt_exprs(ExprStmt id, Expr expr) {
  exists(Expr oldExpr | expr_stmt_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_field_expr_containers(FieldExpr id, Expr container) {
  exists(Expr oldExpr | field_expr_containers(id, oldExpr) and stripExpr(oldExpr, container))
}

query predicate new_format_args_expr_templates(FormatArgsExpr id, Expr template) {
  exists(Expr oldExpr | format_args_expr_templates(id, oldExpr) and stripExpr(oldExpr, template))
}

query predicate new_ident_pat_pats(IdentPat id, Pat pat) {
  exists(Pat oldPat | ident_pat_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_if_expr_conditions(IfExpr id, Expr condition) {
  exists(Expr oldExpr | if_expr_conditions(id, oldExpr) and stripExpr(oldExpr, condition))
}

query predicate new_if_expr_elses(IfExpr id, Expr else_) {
  exists(Expr oldExpr | if_expr_elses(id, oldExpr) and stripExpr(oldExpr, else_))
}

query predicate new_index_expr_bases(IndexExpr id, Expr base) {
  exists(Expr oldExpr | index_expr_bases(id, oldExpr) and stripExpr(oldExpr, base))
}

query predicate new_index_expr_indices(IndexExpr id, Expr index) {
  exists(Expr oldExpr | index_expr_indices(id, oldExpr) and stripExpr(oldExpr, index))
}

query predicate new_key_value_meta_exprs(KeyValueMeta id, Expr expr) {
  exists(Expr oldExpr | key_value_meta_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_let_expr_scrutinees(LetExpr id, Expr scrutinee) {
  exists(Expr oldExpr | let_expr_scrutinees(id, oldExpr) and stripExpr(oldExpr, scrutinee))
}

query predicate new_let_expr_pats(LetExpr id, Pat pat) {
  exists(Pat oldPat | let_expr_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_let_stmt_initializers(LetStmt id, Expr initializer) {
  exists(Expr oldExpr | let_stmt_initializers(id, oldExpr) and stripExpr(oldExpr, initializer))
}

query predicate new_let_stmt_pats(LetStmt id, Pat pat) {
  exists(Pat oldPat | let_stmt_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_match_expr_scrutinees(MatchExpr id, Expr scrutinee) {
  exists(Expr oldExpr | match_expr_scrutinees(id, oldExpr) and stripExpr(oldExpr, scrutinee))
}

query predicate new_method_call_expr_receivers(MethodCallExpr id, Expr receiver) {
  exists(Expr oldExpr | method_call_expr_receivers(id, oldExpr) and stripExpr(oldExpr, receiver))
}

query predicate new_or_pat_pats(OrPat id, int index, Pat pat) {
  pat =
    rank[index + 1](Pat oldPat, Pat unwrappedPat, int oldIndex |
      or_pat_pats(id, oldIndex, oldPat) and stripPat(oldPat, unwrappedPat)
    |
      unwrappedPat order by oldIndex
    )
}

query predicate new_param_pats(Param id, Pat pat) {
  exists(Pat oldPat | param_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_pattern_type_repr_pats(PatternTypeRepr id, Pat pat) {
  exists(Pat oldPat | pattern_type_repr_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_prefix_expr_exprs(PrefixExpr id, Expr expr) {
  exists(Expr oldExpr | prefix_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_range_expr_ends(RangeExpr id, Expr end) {
  exists(Expr oldExpr | range_expr_ends(id, oldExpr) and stripExpr(oldExpr, end))
}

query predicate new_range_expr_starts(RangeExpr id, Expr start) {
  exists(Expr oldExpr | range_expr_starts(id, oldExpr) and stripExpr(oldExpr, start))
}

query predicate new_range_pat_ends(RangePat id, Pat end) {
  exists(Pat oldPat | range_pat_ends(id, oldPat) and stripPat(oldPat, end))
}

query predicate new_range_pat_starts(RangePat id, Pat start) {
  exists(Pat oldPat | range_pat_starts(id, oldPat) and stripPat(oldPat, start))
}

query predicate new_ref_expr_exprs(RefExpr id, Expr expr) {
  exists(Expr oldExpr | ref_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_ref_pat_pats(RefPat id, Pat pat) {
  exists(Pat oldPat | ref_pat_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_return_expr_exprs(ReturnExpr id, Expr expr) {
  exists(Expr oldExpr | return_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_slice_pat_pats(SlicePat id, int index, Pat pat) {
  pat =
    rank[index + 1](Pat oldPat, Pat unwrappedPat, int oldIndex |
      slice_pat_pats(id, oldIndex, oldPat) and stripPat(oldPat, unwrappedPat)
    |
      unwrappedPat order by oldIndex
    )
}

query predicate new_try_expr_exprs(TryExpr id, Expr expr) {
  exists(Expr oldExpr | try_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_tuple_expr_fields(TupleExpr id, int index, Expr field) {
  field =
    rank[index + 1](Expr oldExpr, Expr unwrappedExpr, int oldIndex |
      tuple_expr_fields(id, oldIndex, oldExpr) and stripExpr(oldExpr, unwrappedExpr)
    |
      unwrappedExpr order by oldIndex
    )
}

query predicate new_tuple_pat_fields(TuplePat id, int index, Pat field) {
  field =
    rank[index + 1](Pat oldPat, Pat unwrappedPat, int oldIndex |
      tuple_pat_fields(id, oldIndex, oldPat) and stripPat(oldPat, unwrappedPat)
    |
      unwrappedPat order by oldIndex
    )
}

query predicate new_tuple_struct_pat_fields(TupleStructPat id, int index, Pat field) {
  field =
    rank[index + 1](Pat oldPat, Pat unwrappedPat, int oldIndex |
      tuple_struct_pat_fields(id, oldIndex, oldPat) and stripPat(oldPat, unwrappedPat)
    |
      unwrappedPat order by oldIndex
    )
}

query predicate new_yeet_expr_exprs(YeetExpr id, Expr expr) {
  exists(Expr oldExpr | yeet_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_yield_expr_exprs(YieldExpr id, Expr expr) {
  exists(Expr oldExpr | yield_expr_exprs(id, oldExpr) and stripExpr(oldExpr, expr))
}

query predicate new_asm_expr_templates(AsmExpr id, int index, Expr template) {
  template =
    rank[index + 1](Expr oldExpr, Expr unwrappedExpr, int oldIndex |
      asm_expr_templates(id, oldIndex, oldExpr) and stripExpr(oldExpr, unwrappedExpr)
    |
      unwrappedExpr order by oldIndex
    )
}

query predicate new_const_bodies(Const id, Expr body) {
  exists(Expr oldExpr | const_bodies(id, oldExpr) and stripExpr(oldExpr, body))
}

query predicate new_for_expr_iterables(ForExpr id, Expr iterable) {
  exists(Expr oldExpr | for_expr_iterables(id, oldExpr) and stripExpr(oldExpr, iterable))
}

query predicate new_for_expr_pats(ForExpr id, Pat pat) {
  exists(Pat oldPat | for_expr_pats(id, oldPat) and stripPat(oldPat, pat))
}

query predicate new_static_bodies(Static id, Expr body) {
  exists(Expr oldExpr | static_bodies(id, oldExpr) and stripExpr(oldExpr, body))
}

query predicate new_while_expr_conditions(WhileExpr id, Expr condition) {
  exists(Expr oldExpr | while_expr_conditions(id, oldExpr) and stripExpr(oldExpr, condition))
}

query predicate new_array_expr_internal_attrs(ArrayExprInternal id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_block_expr_attrs(BlockExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_callable_attrs(Element id, int index, AnyAttr attr) {
  exists(ClosureExpr expr | id = expr and mergedExprAttrs(expr, index, attr))
  or
  callable_attrs(id, index, attr) and
  not exists(ClosureExpr expr | id = expr)
}

query predicate new_asm_expr_attrs(AsmExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_await_expr_attrs(AwaitExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_become_expr_attrs(BecomeExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_binary_expr_attrs(BinaryExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_break_expr_attrs(BreakExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_call_expr_attrs(CallExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_cast_expr_attrs(CastExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_continue_expr_attrs(ContinueExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_field_expr_attrs(FieldExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_format_args_expr_attrs(FormatArgsExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_for_expr_attrs(ForExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_if_expr_attrs(IfExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_index_expr_attrs(IndexExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_let_expr_attrs(LetExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_literal_expr_attrs(LiteralExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_loop_expr_attrs(LoopExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_macro_expr_attrs(MacroExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_match_expr_attrs(MatchExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_method_call_expr_attrs(MethodCallExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_offset_of_expr_attrs(OffsetOfExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_path_expr_attrs(PathExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_prefix_expr_attrs(PrefixExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_range_expr_attrs(RangeExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_ref_expr_attrs(RefExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_return_expr_attrs(ReturnExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_try_expr_attrs(TryExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_struct_expr_attrs(StructExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_tuple_expr_attrs(TupleExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_underscore_expr_attrs(UnderscoreExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_yeet_expr_attrs(YeetExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_yield_expr_attrs(YieldExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}

query predicate new_while_expr_attrs(WhileExpr id, int index, AnyAttr attr) {
  mergedExprAttrs(id, index, attr)
}
