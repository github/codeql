/** Provides flow through variables captured by Go function literals. */
overlay[local?]
module;

private import go
private import semmle.go.controlflow.ControlFlowGraphImpl
private import semmle.go.dataflow.SsaImpl as SsaImpl
private import codeql.dataflow.VariableCapture as Shared
private import DataFlowPrivate
private import DataFlowUtil

private predicate flowInsensitiveInstructionStep(IR::Instruction nodeFrom, IR::Instruction nodeTo) {
  exists(SsaSourceVariable v, IR::WriteInstruction write |
    v.isCaptured() and
    write.writes(v, nodeFrom) and
    nodeTo.reads(v)
  )
}

/**
 * Holds if a captured variable may carry a function value from `nodeFrom` to `nodeTo`.
 * Only used for discovering call targets, not ordinary value flow.
 */
predicate flowInsensitiveStep(Node nodeFrom, Node nodeTo) {
  flowInsensitiveInstructionStep(nodeFrom.asInstruction(), nodeTo.asInstruction())
  or
  flowInsensitiveInstructionStep(IR::initParamInstruction(nodeFrom.asParameter()),
    nodeTo.asInstruction())
}

/** A deferred call at its invocation point, as the enclosing function exits. */
class DeferredCall extends IR::EvalInstruction {
  DeferredCall() { this.isAdditional(_, "defer-invoke") }
}

bindingset[a, b]
pragma[inline_late]
private predicate differentRoot(IR::Instruction a, IR::Instruction b) { a.getRoot() != b.getRoot() }

bindingset[outer, inner]
pragma[inline_late]
private predicate strictlyEnclosesFunction(ControlFlow::Root outer, ControlFlow::Root inner) {
  outer = inner.getEnclosingFunction+()
}

private predicate closureSsaDef(SsaExplicitWrite write, SsaDefinition def) {
  reachesDeferredClosureInstruction(write.getDefinition().getRhs()) and
  def = write
  or
  exists(SsaDefinition prev | closureSsaDef(write, prev) |
    prev = def.(SsaPhiDefinition).getAnInput() or
    prev = def.(SsaUncertainWrite).getPriorDefinition()
  )
}

bindingset[def]
pragma[inline_late]
private predicate ssaDefReachesReadNode(SsaDefinition def, IR::Instruction read) {
  exists(SsaSourceVariable v, BasicBlock bb, int i |
    v = def.getSourceVariable() and
    SsaImpl::ssaDefReachesRead(v, def, bb, i) and
    SsaImpl::useAt(bb, i, v) and
    read = bb.getNode(i)
  )
}

private predicate closureDirectInstructionStep(IR::Instruction nodeFrom, IR::Instruction nodeTo) {
  exists(SsaDefinition def, SsaExplicitWrite write |
    closureSsaDef(write, def) and
    nodeFrom = write.getDefinition().getRhs() and
    ssaDefReachesReadNode(def, nodeTo)
  )
  or
  reachesDeferredClosureInstruction(nodeFrom) and
  (
    typeAssertionFlowStep(nodeFrom, nodeTo)
    or
    exists(ConversionExpr conv |
      nodeFrom = IR::evalExprInstruction(conv.getOperand().stripParens()) and
      nodeTo = IR::evalExprInstruction(conv)
    )
  )
}

private predicate closureCapturedInstructionStep(IR::Instruction nodeFrom, IR::Instruction nodeTo) {
  reachesDeferredClosureInstruction(nodeFrom) and
  flowInsensitiveInstructionStep(nodeFrom, nodeTo) and
  differentRoot(nodeFrom, nodeTo)
}

private predicate reachesDeferredClosureInstruction(IR::Instruction insn) {
  insn.(IR::EvalInstruction).getExpr() instanceof FuncLit
  or
  closureDirectInstructionStep(_, insn)
  or
  closureCapturedInstructionStep(_, insn)
}

private newtype TCaptureExpr =
  MkInstructionExpr(IR::Instruction insn) {
    exists(SsaSourceVariable v | v.isCaptured() and insn.reads(v))
    or
    reachesDeferredClosureInstruction(insn)
  } or
  MkDeferredArgument(DeferredCall call, IR::Instruction argument) {
    reachesDeferredClosureInstruction(argument) and
    exists(CallExpr ce | ce = call.getExpr() |
      isLambdaCall(ce) and
      argument = IR::evalExprInstruction(ce.getCalleeExpr().stripParens())
      or
      (
        ce.getArgument(0).stripParens().getType() instanceof TupleType and
        argument =
          IR::extractTupleElement(IR::evalExprInstruction(ce.getArgument(0).stripParens()), _)
        or
        not ce.getArgument(0).stripParens().getType() instanceof TupleType and
        argument = IR::evalExprInstruction(ce.getAnArgument().stripParens())
        or
        exists(Method m |
          m = ce.getTarget() and
          not m.getReceiverBaseType().getUnderlyingType() instanceof InterfaceType and
          argument =
            IR::evalExprInstruction(ce.getCalleeExpr().stripParens())
                .(IR::MethodReadInstruction)
                .getReceiver()
        )
      ) and
      (
        argument.getResultType().getUnderlyingType() instanceof SignatureType or
        argument.getResultType().getUnderlyingType() instanceof InterfaceType
      )
    )
  }

private module CaptureInput implements Shared::InputSig<Location, BasicBlock> {
  class Callable extends ControlFlow::Root {
    predicate isConstructor() { none() }
  }

  Callable basicBlockGetEnclosingCallable(BasicBlock bb) { result = bb.getScope() }

  class CapturedVariable extends SsaSourceVariable {
    CapturedVariable() { this.isCaptured() }

    Callable getCallable() { result = this.getDeclaringFunction() }
  }

  class CapturedParameter extends CapturedVariable instanceof Parameter { }

  class Expr extends TCaptureExpr {
    IR::Instruction getInstruction() { this = MkInstructionExpr(result) }

    predicate hasCfgNode(BasicBlock bb, int i) {
      this.getInstruction() = bb.getNode(i)
      or
      this.(DeferredArgument).getCallInstruction() = bb.getNode(i)
    }

    string toString() {
      result = this.getInstruction().toString()
      or
      result = "deferred " + this.(DeferredArgument).getArgumentInstruction().toString()
    }

    Location getLocation() {
      result = this.getInstruction().getLocation()
      or
      result = this.(DeferredArgument).getCallInstruction().getLocation()
    }
  }

  class VariableWrite extends IR::WriteInstruction {
    CapturedVariable v;

    VariableWrite() {
      this.writes(v, _) and
      not this instanceof IR::InitParameterInstruction
    }

    CapturedVariable getVariable() { result = v }

    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  class VariableRead extends Expr {
    CapturedVariable v;

    VariableRead() { this.getInstruction().reads(v) }

    CapturedVariable getVariable() { result = v }
  }

  private predicate closureInstructionStep(IR::Instruction nodeFrom, IR::Instruction nodeTo) {
    closureDirectInstructionStep(nodeFrom, nodeTo)
    or
    closureCapturedInstructionStep(nodeFrom, nodeTo) and
    strictlyEnclosesFunction(nodeFrom.getRoot(), nodeTo.getRoot())
  }

  private predicate closureFlowStep(Expr nodeFrom, Expr nodeTo) {
    closureInstructionStep(nodeFrom.getInstruction(), nodeTo.getInstruction())
    or
    nodeTo.(DeferredArgument).getArgumentInstruction() = nodeFrom.getInstruction()
  }

  private predicate closureFlowReaches(ClosureExpr ce, Expr e) {
    closureFlowStep(ce, e)
    or
    exists(Expr mid |
      closureFlowReaches(ce, mid) and
      closureFlowStep(mid, e)
    )
  }

  private predicate escapesCurrentCallable(IR::Instruction insn) {
    reachesDeferredClosureInstruction(insn) and
    exists(CapturedVariable v, IR::WriteInstruction write |
      write.writes(v, insn) and
      v.getDeclaringFunction() != insn.getRoot()
    )
  }

  class ClosureExpr extends Expr {
    ClosureExpr() { this.getInstruction().(IR::EvalInstruction).getExpr() instanceof FuncLit }

    predicate hasBody(Callable body) {
      body = this.getInstruction().(IR::EvalInstruction).getExpr()
    }

    predicate hasAliasedAccess(Expr e) {
      closureFlowReaches(this, e) and
      (
        not closureFlowStep(e, _)
        or
        escapesCurrentCallable(e.getInstruction())
      )
    }
  }
}

/** A saved closure callee, argument, or receiver accessed when a deferred call runs. */
class DeferredArgument extends CaptureInput::Expr, MkDeferredArgument {
  /** Gets the deferred invocation. */
  DeferredCall getCallInstruction() { this = MkDeferredArgument(result, _) }

  /** Gets the instruction evaluating the saved value at registration. */
  IR::Instruction getArgumentInstruction() { this = MkDeferredArgument(_, result) }
}

/** Gets the invocation-time access of `argument` in `call`, if needed for capture flow. */
DeferredArgument getDeferredArgument(DeferredCall call, IR::Instruction argument) {
  result = MkDeferredArgument(call, argument)
}

class CapturedVariable = CaptureInput::CapturedVariable;

module Flow = Shared::Flow<Location, CfgImpl::Cfg, CaptureInput>;

pragma[inline]
private CaptureInput::Expr asCaptureExpr(Node n) {
  result.getInstruction() = n.asInstruction()
  or
  result = n.(DeferredArgumentNode).getDeferredArgument() and
  not n instanceof PostUpdateNode
}

private Flow::ClosureNode asClosureNode(Node n) {
  result = n.(CaptureNode).getSynthesizedCaptureNode()
  or
  result.(Flow::ExprNode).getExpr() = asCaptureExpr(n)
  or
  result.(Flow::ExprPostUpdateNode).getExpr() = asCaptureExpr(n.(PostUpdateNode).getPreUpdateNode())
  or
  result.(Flow::ParameterNode).getParameter() = n.asParameter()
  or
  result.(Flow::ThisParameterNode).getCallable() = n.(CapturedVariablesParameterNode).getFunction()
  or
  exists(IR::WriteInstruction vw |
    vw = pragma[only_bind_out](result.(Flow::VariableWriteSourceNode).getVariableWrite()) and
    vw.getRhs() = n.asInstruction()
  )
}

predicate storeStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::storeStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate readStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::readStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate clearsContent(Node n, CapturedVariableContent c) {
  Flow::clearsContent(asClosureNode(n), c.getVariable())
}

predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  Flow::localFlowStep(asClosureNode(nodeFrom), asClosureNode(nodeTo))
  or
  exists(DeferredArgument argument |
    nodeFrom.asInstruction() = argument.getArgumentInstruction() and
    nodeTo = getDeferredArgumentNode(argument)
  )
}
