/**
 * Provides a predicate for non-contextual virtual dispatch and function
 * pointer resolution.
 */

import cpp
private import semmle.code.cpp.ir.ValueNumbering
private import internal.DataFlowDispatch
private import semmle.code.cpp.ir.IR

/**
 * Resolve potential target function(s) for `call`.
 *
 * If `call` is a call through a function pointer (`ExprCall`) or its target is
 * a virtual member function, simple data flow analysis is performed in order
 * to identify the possible target(s).
 */
Function resolveCall(Call call) {
  exists(CallInstruction callInstruction |
    callInstruction.getAst() = call and
    result = viableCallable(callInstruction)
  )
}
