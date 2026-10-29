class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

newtype TAddedElement =
  TAssignment(CompoundAssignmentExpr e) or
  TLhs(CompoundAssignmentExpr e) or
  TRhs(CompoundAssignmentExpr e)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewExpr = @expr or Fresh::EntityId;

class NewExpr extends TNewExpr {
  string toString() { none() }
}

class TNewControlFlowElement = @control_flow_element or Fresh::EntityId;

class NewControlFlowElement extends TNewControlFlowElement {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

class Callable extends @callable {
  string toString() { none() }
}

class Accessible extends @accessible {
  string toString() { none() }
}

predicate assignmentKind(int kind) {
  // | 63 = @simple_assign_expr
  // | 80 = @add_event_expr
  // | 81 = @remove_event_expr
  // | 83 = @local_var_decl_expr
  kind = [63, 80, 81, 83]
}

predicate compoundAssignmentKind(int kind) {
  // | 64 = @assign_add_expr
  // | 65 = @assign_sub_expr
  // | 66 = @assign_mul_expr
  // | 67 = @assign_div_expr
  // | 68 = @assign_rem_expr
  // | 69 = @assign_and_expr
  // | 70 = @assign_xor_expr
  // | 71 = @assign_or_expr
  // | 72 = @assign_lshift_expr
  // | 73 = @assign_rshift_expr
  // | 119 = @assign_coalesce_expr
  // | 134 = @assign_urshift_expr
  kind = [64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 119, 134]
}

int getOperatorKindFromAssignmentKind(int kind) {
  kind = 64 and result = 44 // @assign_add_expr -> @add_expr
  or
  kind = 65 and result = 45 // @assign_sub_expr -> @sub_expr
  or
  kind = 66 and result = 41 // @assign_mul_expr -> @mul_expr
  or
  kind = 67 and result = 42 // @assign_div_expr -> @div_expr
  or
  kind = 68 and result = 43 // @assign_rem_expr -> @rem_expr
  or
  kind = 69 and result = 54 // @assign_and_expr -> @bit_and_expr
  or
  kind = 70 and result = 55 // @assign_xor_expr -> @bit_xor_expr
  or
  kind = 71 and result = 56 // @assign_or_expr -> @bit_or_expr
  or
  kind = 72 and result = 46 // @assign_lshift_expr -> @lshift_expr
  or
  kind = 73 and result = 47 // @assign_rshift_expr -> @rshift_expr
  or
  kind = 119 and result = 61 // @assign_coalesce_expr -> @coalesce_expr
  or
  kind = 134 and result = 133 // @assign_urshift_expr -> @urshift_expr
}

predicate isAssignment(Expr ass) {
  exists(int kind | assignmentKind(kind) | expressions(ass, kind, _))
}

class CompoundAssignmentExpr extends Expr {
  CompoundAssignmentExpr() {
    exists(int kind | compoundAssignmentKind(kind) | expressions(this, kind, _))
  }
}

query predicate new_expressions(NewExpr e, int kind, TypeOrRef t) {
  expressions(e, kind, t)
  or
  // Introduce expanded expression nodes.
  exists(CompoundAssignmentExpr compound, int kind0, Expr e1, int kind1 |
    expressions(compound, kind0, t) and
    expressions(e1, kind1, _) and
    expr_parent(e1, 0, compound)
  |
    Fresh::map(TAssignment(compound)) = e and kind = 63
    or
    Fresh::map(TLhs(compound)) = e and kind = kind1
    or
    Fresh::map(TRhs(compound)) = e and kind = getOperatorKindFromAssignmentKind(kind0)
  )
}

query predicate new_expr_parent(NewExpr e, int child, NewControlFlowElement parent) {
  if isAssignment(parent)
  then
    // Swap children for assignments, local variable declarations and add/remove event.
    child = 0 and expr_parent(e, 1, parent)
    or
    child = 1 and expr_parent(e, 0, parent)
  else (
    exists(CompoundAssignmentExpr compound |
      Fresh::map(TAssignment(compound)) = e and child = 2 and parent = compound
      or
      Fresh::map(TLhs(compound)) = e and child = 1 and parent = Fresh::map(TAssignment(compound))
      or
      Fresh::map(TRhs(compound)) = e and child = 0 and parent = Fresh::map(TAssignment(compound))
      or
      expr_parent(e, child, compound) and parent = Fresh::map(TRhs(compound))
    )
    or
    // Copy the expr_parent relation except for compound assignment edges.
    expr_parent(e, child, parent) and not parent instanceof CompoundAssignmentExpr
  )
}

query predicate new_expr_location(NewExpr e, Location loc) {
  expr_location(e, loc)
  or
  exists(CompoundAssignmentExpr compound |
    Fresh::map(TAssignment(compound)) = e and expr_location(compound, loc)
    or
    Fresh::map(TLhs(compound)) = e and
    exists(Expr child | expr_location(child, loc) and expr_parent(child, 0, compound))
    or
    Fresh::map(TRhs(compound)) = e and expr_location(compound, loc)
  )
}

query predicate new_expr_call(NewExpr e, Callable c) {
  expr_call(e, c) and not e instanceof CompoundAssignmentExpr
  or
  exists(CompoundAssignmentExpr compound |
    Fresh::map(TRhs(compound)) = e and expr_call(compound, c)
  )
}

query predicate new_dynamic_member_name(NewExpr e, string name) {
  dynamic_member_name(e, name) and not e instanceof CompoundAssignmentExpr
  or
  exists(CompoundAssignmentExpr compound |
    Fresh::map(TRhs(compound)) = e and dynamic_member_name(compound, name)
  )
}

query predicate new_expr_access(NewExpr e, Accessible a) {
  expr_access(e, a)
  or
  exists(CompoundAssignmentExpr compound, Expr access |
    expr_parent(access, 0, compound) and
    expr_access(access, a) and
    Fresh::map(TLhs(compound)) = e
  )
}
