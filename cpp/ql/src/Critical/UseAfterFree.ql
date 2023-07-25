/**
 * @name Potential use after free
 * @description An allocated memory block is used after it has been freed. Behavior in such cases is undefined and can cause memory corruption.
 * @kind path-problem
 * @precision medium
 * @id cpp/use-after-free
 * @problem.severity warning
 * @security-severity 9.3
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import FlowAfterFree
import UseAfterFree::PathGraph

/**
 * Holds if `call` is a call to a function that obviously
 * doesn't dereference its `i`'th argument.
 */
private predicate externalCallNeverDereferences(FormattingFunctionCall call, int arg) {
  exists(int formatArg |
    pragma[only_bind_out](call.getFormatArgument(formatArg)) =
      pragma[only_bind_out](call.getArgument(arg)) and
    call.getFormat().(FormatLiteral).getConvSpec(formatArg) != "%s"
  )
}

predicate isUse0(DataFlow::Node n, Expr e) {
  e = n.asExpr() and
  not isFree(_, e, _) and
  (
    e = any(PointerDereferenceExpr pde).getOperand()
    or
    e = any(PointerFieldAccess pfa).getQualifier()
    or
    e = any(ArrayExpr ae).getArrayBase()
    or
    e = any(Call call).getQualifier()
    or
    // Assume any function without a body will dereference the pointer
    exists(int i, Call call, Function f |
      n.asExpr() = call.getArgument(i) and
      f = call.getTarget() and
      not f.hasEntryPoint() and
      // Exclude known functions we know won't dereference the pointer.
      // For example, a call such as `printf("%p", myPointer)`.
      not externalCallNeverDereferences(call, i)
    )
  )
}

module ParameterSinks {
  import semmle.code.cpp.ir.ValueNumbering

  predicate flowsToUse(DataFlow::Node n) {
    isUse0(n, _)
    or
    exists(DataFlow::Node succ |
      flowsToUse(succ) and
      DataFlow::localFlowStep(n, succ)
    )
  }

  private predicate flowsFromParam(DataFlow::Node n) {
    flowsToUse(n) and
    (
      n.asParameter().getUnspecifiedType() instanceof PointerType
      or
      exists(DataFlow::Node prev |
        flowsFromParam(prev) and
        DataFlow::localFlowStep(prev, n)
      )
    )
  }

  private predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    flowsFromParam(n1) and
    flowsFromParam(n2) and
    DataFlow::localFlowStep(n1, n2)
  }

  private predicate paramToUse(DataFlow::Node n1, DataFlow::Node n2) = fastTC(step/2)(n1, n2)

  private predicate hasFlow(
    DataFlow::Node source, InitializeParameterInstruction init, DataFlow::Node sink
  ) {
    pragma[only_bind_out](source.asParameter()) = pragma[only_bind_out](init.getParameter()) and
    paramToUse(source, sink) and
    isUse0(sink, _)
  }

  private InitializeParameterInstruction getAnAlwaysDereferencedParameter0() {
    exists(DataFlow::Node source, DataFlow::Node sink, IRBlock b1, int i1, IRBlock b2, int i2 |
      hasFlow(pragma[only_bind_into](source), result, pragma[only_bind_into](sink)) and
      source.hasIndexInBlock(b1, pragma[only_bind_into](i1)) and
      sink.hasIndexInBlock(b2, pragma[only_bind_into](i2)) and
      strictlyPostDominates(b2, i2, b1, i1)
    )
  }

  private CallInstruction getAnAlwaysReachedCallInstruction(IRFunction f) {
    result.getBlock().postDominates(f.getEntryBlock())
  }

  pragma[nomagic]
  predicate callHasTargetAndArgument(Function f, int i, CallInstruction call, Instruction argument) {
    call.getStaticCallTarget() = f and
    call.getArgument(i) = argument
  }

  pragma[nomagic]
  predicate initializeParameterInFunction(Function f, int i, InitializeParameterInstruction init) {
    pragma[only_bind_out](init.getEnclosingFunction()) = f and
    init.hasIndex(i)
  }

  InitializeParameterInstruction getAnAlwaysDereferencedParameter() {
    result = getAnAlwaysDereferencedParameter0()
    or
    exists(
      CallInstruction call, int i, InitializeParameterInstruction p, Instruction argument,
      Function f
    |
      callHasTargetAndArgument(f, i, call, argument) and
      initializeParameterInFunction(f, i, p) and
      p = getAnAlwaysDereferencedParameter() and
      result =
        pragma[only_bind_out](pragma[only_bind_into](valueNumber(argument)).getAnInstruction()) and
      call = getAnAlwaysReachedCallInstruction(_)
    )
  }
}

module IsUse {
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon

  predicate isUse(DataFlow::Node n, Expr e) {
    isUse0(n, e)
    or
    exists(CallInstruction call, InitializeParameterInstruction init |
      n.asOperand().getDef().getUnconvertedResultExpression() = e and
      pragma[only_bind_into](init) = ParameterSinks::getAnAlwaysDereferencedParameter() and
      viableParamArg(call, DataFlow::instructionNode(init), n) and
      pragma[only_bind_out](init.getEnclosingFunction()) =
        pragma[only_bind_out](call.getStaticCallTarget())
    )
  }
}

import IsUse

/**
 * `dealloc1` is a deallocation expression, `e` is an expression that dereferences a
 * pointer, and the `(dealloc1, e)` pair should be excluded by the `FlowFromFree` library.
 */
bindingset[dealloc1, e]
predicate isExcludeFreeUsePair(DeallocationExpr dealloc1, Expr e) {
  // From https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/nf-wdm-mmfreepagesfrommdl:
  // "After calling MmFreePagesFromMdl, the caller must also call ExFreePool
  // to release the memory that was allocated for the MDL structure."
  dealloc1.(FunctionCall).getTarget().hasGlobalName("MmFreePagesFromMdl") and
  isExFreePoolCall(_, e)
}

module UseAfterFree = FlowFromFree<isUse/2, isExcludeFreeUsePair/2>;

from UseAfterFree::PathNode source, UseAfterFree::PathNode sink, DeallocationExpr dealloc
where
  UseAfterFree::flowPath(source, sink) and
  isFree(source.getNode(), _, dealloc)
select sink.getNode(), source, sink, "Memory may have been previously freed by $@.", dealloc,
  dealloc.toString()
