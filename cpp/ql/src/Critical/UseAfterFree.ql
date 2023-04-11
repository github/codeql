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
      source.hasIndexInBlock(b1, i1) and
      sink.hasIndexInBlock(b2, i2) and
      strictlyPostDominates(b2, i2, b1, i1)
    )
  }

  private CallInstruction getAnAlwaysReachedCallInstruction(IRFunction f) {
    result.getBlock().postDominates(f.getEntryBlock())
  }

  InitializeParameterInstruction getAnAlwaysDereferencedParameter() {
    result = getAnAlwaysDereferencedParameter0()
    or
    exists(CallInstruction call, int i, InitializeParameterInstruction p |
      pragma[only_bind_out](call.getStaticCallTarget()) =
        pragma[only_bind_out](p.getEnclosingFunction()) and
      p.hasIndex(i) and
      p = getAnAlwaysDereferencedParameter() and
      result = valueNumber(call.getArgument(i)).getAnInstruction() and
      call = getAnAlwaysReachedCallInstruction(_)
    )
  }
}

predicate isUse(DataFlow::Node n, Expr e) {
  isUse0(n, e)
  or
  exists(CallInstruction call, int i, InitializeParameterInstruction init |
    n.asOperand().getDef().getUnconvertedResultExpression() = e and
    init = ParameterSinks::getAnAlwaysDereferencedParameter() and
    call.getArgumentOperand(i) = n.asOperand() and
    init.hasIndex(i) and
    init.getEnclosingFunction() = call.getStaticCallTarget()
  )
}

predicate excludeNothing(DeallocationExpr dealloc, Expr e) { none() }

module UseAfterFree = FlowFromFree<isUse/2, excludeNothing/2>;

from UseAfterFree::PathNode source, UseAfterFree::PathNode sink, DeallocationExpr dealloc
where
  UseAfterFree::flowPath(source, sink) and
  isFree(source.getNode(), _, dealloc)
select sink.getNode(), source, sink, "Memory may have been previously freed by $@.", dealloc,
  dealloc.toString()
