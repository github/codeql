/**
 * @name Missing error check
 * @description When a function returns a pointer alongside an error value, one should normally
 *              assume that the pointer may be nil until either the pointer or error has been checked.
 * @kind problem
 * @problem.severity warning
 * @id go/missing-error-check
 * @tags reliability
 *       correctness
 *       logic
 * @precision high
 */

import go

/**
 * Holds if `node` is a reference to the `nil` builtin constant.
 */
predicate isNil(DataFlow::Node node) { node = Builtin::nil().getARead() }

/**
 * Matches if `call` may return a nil pointer alongside an error value.
 *
 * This is both an over- and under-estimate: over in that we assume opaque functions may use this
 * convention, and under in that functions with bodies are only recognized if they use a literal
 * `nil` for the pointer return value at some return site.
 */
predicate calleeMayReturnNilWithError(DataFlow::CallNode call) {
  not exists(call.getACallee())
  or
  exists(FuncDef callee | callee = call.getACallee() |
    not exists(callee.getBody())
    or
    exists(IR::ReturnInstruction ret, DataFlow::Node ptrReturn, DataFlow::Node errReturn |
      callee = ret.getRoot() and
      ptrReturn = DataFlow::instructionNode(ret.getResult(0)) and
      errReturn = DataFlow::instructionNode(ret.getResult(1)) and
      isNil(ptrReturn) and
      not isNil(errReturn)
    )
  )
}

/**
 * Matches if `type` is a pointer, slice or interface type, or an alias for such a type.
 */
predicate isDereferenceableType(Type maybePointer) {
  exists(Type t | t = maybePointer.getUnderlyingType() |
    t instanceof PointerType or t instanceof SliceType or t instanceof InterfaceType
  )
}

/**
 * Matches if `instruction` checks `value`.
 *
 * We consider testing value for equality (against anything), passing it as a parameter to
 * a function call, switching on either its value or its type or casting it to constitute a
 * check.
 */
predicate checksValue(IR::Instruction instruction, DataFlow::SsaNode value) {
  exists(DataFlow::InstructionNode instNode | instNode.asInstruction() = instruction |
    instNode.(DataFlow::CallNode).getAnArgument() = value.getAUse() or
    instNode.(DataFlow::EqualityTestNode).getAnOperand() = value.getAUse()
  )
  or
  value.getAUse().asInstruction() = instruction and
  (
    exists(ExpressionSwitchStmt s | instruction.(IR::EvalInstruction).getExpr() = s.getExpr())
    or
    // This case accounts for both a type-switch or cast used to check `value`
    exists(TypeAssertExpr e | instruction.(IR::EvalInstruction).getExpr() = e.getExpr())
  )
}

/**
 * Matches if `call` is a function returning (`ptr`, `err`) where `ptr` may be nil, and neither
 * `ptr` not `err` has been checked for validity as of `node`.
 *
 * This is initially true of any callsite that may call either an opaque function or a user-defined
 * function that may return (nil, error), and is true of any downstream control-flow node where a
 * check has not certainly been made against either `ptr` or `err`.
 */
predicate returnUncheckedAtNode(
  DataFlow::CallNode call, ControlFlow::Node node, DataFlow::SsaNode ptr, DataFlow::SsaNode err
) {
  (
    // Base case: check that `ptr` and `err` have appropriate types, and that the callee may return
    // a nil pointer with an error.
    ptr.getAPredecessor() = call.getResult(0) and
    err.getAPredecessor() = call.getResult(1) and
    call.asInstruction() = node and
    isDereferenceableType(ptr.getType()) and
    err.getType() instanceof ErrorType and
    calleeMayReturnNilWithError(call)
    or
    // Recursive case: check that some predecessor is missing a check, and `node` does not itself
    // check either `ptr` or `err`.
    // localFlow is used to permit checks via either an SSA phi node or ordinary assignment.
    returnUncheckedAtNode(call, node.getAPredecessor(), ptr, err) and
    not exists(DataFlow::SsaNode checked |
      DataFlow::localFlow(ptr, checked) or DataFlow::localFlow(err, checked)
    |
      checksValue(node, checked)
    )
  )
}

from
  DataFlow::CallNode call, DataFlow::SsaNode ptr, DataFlow::SsaNode err,
  DataFlow::PointerDereferenceNode deref, ControlFlow::Node derefNode
where
  // `derefNode` is a control-flow node corresponding to `deref`
  deref.getOperand().asInstruction() = derefNode and
  // neither `ptr` nor `err`, the return values of `call`, have been checked as of `derefNode`
  returnUncheckedAtNode(call, derefNode, ptr, err) and
  // `deref` dereferences `ptr`
  deref.getOperand() = ptr.getAUse()
select deref.getOperand(),
  ptr.getSourceVariable() + " may be nil here, because $@ may not have been checked.", err,
  err.getSourceVariable().toString()
