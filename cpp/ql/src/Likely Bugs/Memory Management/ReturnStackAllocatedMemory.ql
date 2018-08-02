/**
 * @name Returning stack-allocated memory
 * @description A function returns a pointer to a stack-allocated region of
 *              memory. This memory is deallocated at the end of the function,
 *              which may lead the caller to dereference a dangling pointer.
 * @kind problem
 * @id cpp/return-stack-allocated-memory
 * @problem.severity warning
 * @tags reliability
 */
import cpp

// an expression is possibly stack allocated if it is an aggregate literal
// or a reference to a possibly stack allocated local variables
predicate exprMaybeStackAllocated(Expr e) {
     e instanceof AggregateLiteral
  or varMaybeStackAllocated(e.(VariableAccess).getTarget())
}

// a local variable is possibly stack allocated if it is not static and
// is initialized to/assigned a possibly stack allocated expression
predicate varMaybeStackAllocated(LocalVariable lv) {
  not lv.isStatic() and
  (   lv.getType().getUnderlyingType() instanceof ArrayType
   or exprMaybeStackAllocated(lv.getInitializer().getExpr())
   or exists(AssignExpr a | a.getLValue().(VariableAccess).getTarget() = lv and
                            exprMaybeStackAllocated(a.getRValue())))
}

// an expression possibly points to the stack if it takes the address of
// a possibly stack allocated expression, if it is a reference to a local variable
// that possibly points to the stack, or if it is a possibly stack allocated array
// that is converted (implicitly or explicitly) to a pointer
predicate exprMayPointToStack(Expr e) {
     e instanceof AddressOfExpr and exprMaybeStackAllocated(e.(AddressOfExpr).getAnOperand())
  or varMayPointToStack(e.(VariableAccess).getTarget())
  or exprMaybeStackAllocated(e) and e.getType() instanceof ArrayType and e.getFullyConverted().getType() instanceof PointerType
}

// a local variable possibly points to the stack if it is initialized to/assigned to
// an expression that possibly points to the stack
predicate varMayPointToStack(LocalVariable lv) {
     exprMayPointToStack(lv.getInitializer().getExpr())
  or exists(AssignExpr a | a.getLValue().(VariableAccess).getTarget() = lv and
                           exprMayPointToStack(a.getRValue()))
}

from ReturnStmt r
where exprMayPointToStack(r.getExpr())
select r, "May return stack-allocated memory."
