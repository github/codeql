/**
 * Provides a predicate for non-contextual virtual dispatch and function
 * pointer resolution.
 */

import cpp
private import semmle.code.cpp.ir.ValueNumbering
private import internal.DataFlowDispatch
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

/**
 * Resolve potential target function(s) for `call`.
 *
 * If `call` is a call through a function pointer (`ExprCall`) or its target is
 * a virtual member function, simple data flow analysis is performed in order
 * to identify the possible target(s).
 */
Function resolveCall(Call call) {
  exists(DataFlowCall dataFlowCall, CallInstruction callInstruction |
    callInstruction.getAst() = call and
    callInstruction = dataFlowCall.asCallInstruction() and
    result = viableCallable(dataFlowCall).getUnderlyingCallable()
  )
}
