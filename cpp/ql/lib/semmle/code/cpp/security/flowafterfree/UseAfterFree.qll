/**
 * General library for tracing Use After Free vulnerabilities.
 */

import cpp
private import semmle.code.cpp.security.flowafterfree.FlowAfterFree
private import semmle.code.cpp.ir.IR

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

/**
 * Holds if `e` is a use. A use is a pointer dereference or a
 * parameter to a call with no function definition.
 * Uses in deallocation expressions (e.g., free) are excluded.
 * Default isUse definition for an expression.
 */
predicate isUse0(Expr e) {
  not isFree(_, _, e, _) and
  (
    // TODO: use DirectDefereferencedByOperation in Dereferenced.qll
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
      e = call.getArgument(i) and
      f = call.getTarget() and
      not f.hasEntryPoint() and
      // Exclude known functions we know won't dereference the pointer.
      // For example, a call such as `printf("%p", myPointer)`.
      not externalCallNeverDereferences(call, i)
    )
  )
}

private module ParameterSinks {
  import semmle.code.cpp.ir.ValueNumbering

  private predicate flowsToUse(DataFlow::Node n) {
    isUse0(n.asExpr())
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
    isUse0(sink.asExpr())
  }

  private InitializeParameterInstruction getAnAlwaysDereferencedParameter0() {
    exists(DataFlow::Node source, DataFlow::Node sink, IRBlock b1, int i1, IRBlock b2, int i2 |
      hasFlow(pragma[only_bind_into](source), result, pragma[only_bind_into](sink)) and
      source.hasIndexInBlock(b1, pragma[only_bind_into](i1)) and
      sink.hasIndexInBlock(b2, pragma[only_bind_into](i2)) and
      strictlyPostDominates(b2, i2, b1, i1)
    )
  }

  private CallInstruction getAnAlwaysReachedCallInstruction() {
    exists(IRFunction f | result.getBlock().postDominates(f.getEntryBlock()))
  }

  pragma[nomagic]
  private predicate callHasTargetAndArgument(Function f, int i, Instruction argument) {
    exists(CallInstruction call |
      call.getStaticCallTarget() = f and
      call.getArgument(i) = argument and
      call = getAnAlwaysReachedCallInstruction()
    )
  }

  pragma[nomagic]
  private predicate initializeParameterInFunction(Function f, int i) {
    exists(InitializeParameterInstruction init |
      pragma[only_bind_out](init.getEnclosingFunction()) = f and
      init.hasIndex(i) and
      init = getAnAlwaysDereferencedParameter()
    )
  }

  pragma[nomagic]
  private predicate alwaysDereferencedArgumentHasValueNumber(ValueNumber vn) {
    exists(int i, Function f, Instruction argument |
      callHasTargetAndArgument(f, i, argument) and
      initializeParameterInFunction(pragma[only_bind_into](f), pragma[only_bind_into](i)) and
      vn.getAnInstruction() = argument
    )
  }

  InitializeParameterInstruction getAnAlwaysDereferencedParameter() {
    result = getAnAlwaysDereferencedParameter0()
    or
    exists(ValueNumber vn |
      alwaysDereferencedArgumentHasValueNumber(vn) and
      vn.getAnInstruction() = result
    )
  }
}

private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

/**
 * Holds if `n` represents the expression `e`, and `e` is a pointer that is
 * guaranteed to be dereferenced (either because it's an operand of a
 * dereference operation, or because it's an argument to a function that
 * always dereferences the parameter).
 */
predicate isUse(DataFlow::Node n, Expr e) {
  isUse0(e) and n.asExpr() = e
  or
  exists(DataFlowCall call, InitializeParameterInstruction init |
    n.asOperand().getDef().getUnconvertedResultExpression() = e and
    pragma[only_bind_into](init) = ParameterSinks::getAnAlwaysDereferencedParameter() and
    viableParamArg(call, DataFlow::instructionNode(init), n) and
    pragma[only_bind_out](init.getEnclosingFunction()) =
      pragma[only_bind_out](call.asCallInstruction().getStaticCallTarget())
  )
}
