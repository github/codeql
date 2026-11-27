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

bindingset[outer, inner]
pragma[inline_late]
private predicate strictlyEnclosesFunction(ControlFlow::Root outer, ControlFlow::Root inner) {
  outer = inner.getEnclosingFunction+()
}

private predicate closureSsaDef(SsaExplicitWrite write, SsaDefinition def) {
  reachesClosureInstruction(write.getDefinition().getRhs()) and
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
  reachesClosureInstruction(nodeFrom) and
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
  reachesClosureInstruction(nodeFrom) and
  flowInsensitiveInstructionStep(nodeFrom, nodeTo) and
  strictlyEnclosesFunction(nodeFrom.getRoot(), nodeTo.getRoot())
}

private predicate reachesClosureInstruction(IR::Instruction insn) {
  insn.(IR::EvalInstruction).getExpr() instanceof FuncLit
  or
  closureDirectInstructionStep(_, insn)
  or
  closureCapturedInstructionStep(_, insn)
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

  class Expr extends IR::Instruction {
    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
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

    VariableRead() { this.reads(v) }

    CapturedVariable getVariable() { result = v }
  }

  private predicate closureFlowStep(IR::Instruction nodeFrom, IR::Instruction nodeTo) {
    closureDirectInstructionStep(nodeFrom, nodeTo)
    or
    closureCapturedInstructionStep(nodeFrom, nodeTo)
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
    reachesClosureInstruction(insn) and
    exists(CapturedVariable v, IR::WriteInstruction write |
      write.writes(v, insn) and
      v.getDeclaringFunction() != insn.getRoot()
    )
  }

  class ClosureExpr extends Expr {
    ClosureExpr() { this.(IR::EvalInstruction).getExpr() instanceof FuncLit }

    predicate hasBody(Callable body) { body = this.(IR::EvalInstruction).getExpr() }

    predicate hasAliasedAccess(Expr e) {
      closureFlowReaches(this, e) and
      (
        not closureFlowStep(e, _)
        or
        escapesCurrentCallable(e)
      )
    }
  }
}

class CapturedVariable = CaptureInput::CapturedVariable;

module Flow = Shared::Flow<Location, CfgImpl::Cfg, CaptureInput>;

private Flow::ClosureNode asClosureNode(Node n) {
  result = n.(CaptureNode).getSynthesizedCaptureNode()
  or
  result.(Flow::ExprNode).getExpr() = n.asInstruction()
  or
  result.(Flow::ExprPostUpdateNode).getExpr() =
    n.(PostUpdateNode).getPreUpdateNode().asInstruction()
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
}
