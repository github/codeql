class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

class ControlFlowElement extends @control_flow_element {
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

class CompoundAssignmentExpr extends Expr {
  CompoundAssignmentExpr() {
    exists(int kind | compoundAssignmentKind(kind) | expressions(this, kind, _))
  }
}

predicate isAssignment(Expr ass) {
  exists(int kind | assignmentKind(kind) |
    expressions(ass, kind, _) and
    // Exclude assignments that are part of a compound assignment. These are handled seperatly.
    not exists(CompoundAssignmentExpr e | expr_parent(ass, 2, e))
  )
}

Expr getOperatorCall(CompoundAssignmentExpr e) {
  exists(Expr assignment |
    expr_parent(assignment, 2, e) and
    expr_parent(result, 0, assignment)
  )
}

query predicate new_expressions(Expr e, int kind, TypeOrRef t) {
  expressions(e, kind, t) and
  // Remove the unused expanded assignment expressions.
  not exists(CompoundAssignmentExpr parent, Expr assignment | expr_parent(assignment, 2, parent) |
    e = assignment or
    expr_parent(e, 0, assignment) or
    expr_parent(e, 1, assignment)
  )
}

query predicate new_expr_parent(Expr e, int child, ControlFlowElement parent) {
  if isAssignment(parent)
  then
    // Swap children for assignments, local variable declarations and add/remove event.
    child = 0 and expr_parent(e, 1, parent)
    or
    child = 1 and expr_parent(e, 0, parent)
  else (
    // Case for compound assignments. The parent child relation is contracted.
    exists(Expr op | op = getOperatorCall(parent) | expr_parent(e, child, op))
    or
    // For other expressions (as long as they are included in the new expressions
    // table), the parent child relation is unchanged.
    expr_parent(e, child, parent) and
    new_expressions(e, _, _) and
    (not parent instanceof Expr or new_expressions(parent, _, _))
  )
}

query predicate new_expr_location(Expr e, Location loc) {
  expr_location(e, loc) and new_expressions(e, _, _)
}

query predicate new_expr_call(Expr e, Callable c) {
  exists(Expr op | op = getOperatorCall(e) | expr_call(op, c))
  or
  expr_call(e, c) and not e = getOperatorCall(_)
}

query predicate new_dynamic_member_name(Expr e, string name) {
  exists(Expr op | op = getOperatorCall(e) | dynamic_member_name(op, name))
  or
  dynamic_member_name(e, name) and not e = getOperatorCall(_)
}

query predicate new_expr_access(Expr e, Accessible a) {
  expr_access(e, a) and new_expressions(e, _, _)
}
