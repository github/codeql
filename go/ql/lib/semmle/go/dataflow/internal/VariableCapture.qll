/** Provides flow through variables captured by Go function literals. */
overlay[local?]
module;

private import go
private import semmle.go.controlflow.ControlFlowGraphImpl
private import codeql.dataflow.VariableCapture as Shared
private import DataFlowPrivate
private import DataFlowUtil

private module CaptureInput implements Shared::InputSig<Location, BasicBlock> {
  private import go as G

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
    exists(SsaDefinition def, SsaExplicitWrite write |
      write = def.getAnUltimateDefinition() and
      nodeFrom = write.getDefinition().getRhs() and
      nodeTo = IR::evalExprInstruction(def.getARead())
    )
    or
    exists(G::Expr e |
      nodeTo = IR::evalExprInstruction(e) and
      nodeFrom = IR::evalExprInstruction(e.(ConversionExpr).getOperand())
    )
  }

  class ClosureExpr extends Expr {
    ClosureExpr() { this.(IR::EvalInstruction).getExpr() instanceof FuncLit }

    predicate hasBody(Callable body) { body = this.(IR::EvalInstruction).getExpr() }

    predicate hasAliasedAccess(Expr e) {
      closureFlowStep*(this, e) and
      not closureFlowStep(e, _)
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
  result.(Flow::VariableWriteSourceNode).getVariableWrite().getRhs() = n.asInstruction()
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
