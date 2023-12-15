/** Provides logic related to captured variables. */

private import python
private import DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate
private import codeql.dataflow.VariableCapture as Shared

private module CaptureInput implements Shared::InputSig<Location> {
  private import python as PY

  additional class ExprCfgNode extends ControlFlowNode {
    ExprCfgNode() { isExpressionNode(this) }
  }

  private predicate closureFlowStep(ExprCfgNode nodeFrom, ExprCfgNode nodeTo) {
    // TODO: Other languages have an extra case here looking like
    //   simpleAstFlowStep(nodeFrom, nodeTo)
    // we should investigate the potential benefit of adding that.
    exists(SsaVariable def |
      def.getAUse() = nodeTo and
      def.getAnUltimateDefinition().getDefinition().(DefinitionNode).getValue() = nodeFrom
    )
  }

  class Callable extends Scope {
    predicate isConstructor() { none() }
  }

  class BasicBlock extends PY::BasicBlock {
    Callable getEnclosingCallable() { result = this.getScope() }

    // TODO: check that this gives useful results
    Location getLocation() { result = super.getNode(0).getLocation() }
  }

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class CapturedVariable extends LocalVariable {
    Function f;

    CapturedVariable() {
      // note: captured variables originating on module scope is currently
      // covered by global variable handling.
      this.getScope() = f and
      this.getAnAccess().getScope() != f
    }

    Callable getCallable() { result = f }

    Location getLocation() { result = f.getLocation() }

    /** Gets a scope that captures this variable. */
    Scope getACapturingScope() {
      result = this.getAnAccess().getScope().getScope*() and
      result.getScope+() = f
    }
  }

  class CapturedParameter extends CapturedVariable {
    CapturedParameter() { this.isParameter() }

    ControlFlowNode getCfgNode() { result.getNode().(Parameter) = this.getAnAccess() }
  }

  class Expr extends ExprCfgNode {
    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  class VariableWrite extends ControlFlowNode {
    CapturedVariable v;

    VariableWrite() { this = v.getAStore().getAFlowNode() }

    CapturedVariable getVariable() { result = v }

    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  class VariableRead extends Expr {
    CapturedVariable v;

    VariableRead() { this = v.getALoad().getAFlowNode() }

    CapturedVariable getVariable() { result = v }
  }

  class ClosureExpr extends Expr {
    ClosureExpr() {
      this.getNode() instanceof CallableExpr
      or
      this.getNode() instanceof Comp
    }

    predicate hasBody(Callable body) {
      body = this.getNode().(CallableExpr).getInnerScope()
      or
      body = this.getNode().(Comp).getFunction()
    }

    predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
  }
}

class CapturedVariable = CaptureInput::CapturedVariable;

class ClosureExpr = CaptureInput::ClosureExpr;

module Flow = Shared::Flow<Location, CaptureInput>;

private Flow::ClosureNode asClosureNode(Node n) {
  result = n.(SynthCaptureNode).getSynthesizedCaptureNode()
  or
  result.(Flow::ExprNode).getExpr() = n.(CfgNode).getNode()
  or
  result.(Flow::VariableWriteSourceNode).getVariableWrite() = n.(CfgNode).getNode()
  or
  result.(Flow::ExprPostUpdateNode).getExpr() =
    n.(PostUpdateNode).getPreUpdateNode().(CfgNode).getNode()
  or
  result.(Flow::ParameterNode).getParameter().getCfgNode() = n.(CfgNode).getNode()
  or
  result.(Flow::ThisParameterNode).getCallable() =
    n.(SynthCapturingClosureParameterNode).getCallable()
}

predicate storeStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::storeStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate readStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::readStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate valueStep(Node nodeFrom, Node nodeTo) {
  Flow::localFlowStep(asClosureNode(nodeFrom), asClosureNode(nodeTo))
}

/**
 * Provides predicates to understand the behaviour of the variable capture
 * library instantiation on Python code bases.
 */
private module Debug {
  predicate flowStoreStep(
    Node nodeFrom, Flow::ClosureNode closureNodeFrom, CapturedVariable v,
    Flow::ClosureNode closureNodeTo, Node nodeTo
  ) {
    closureNodeFrom = asClosureNode(nodeFrom) and
    closureNodeTo = asClosureNode(nodeTo) and
    Flow::storeStep(closureNodeFrom, v, closureNodeTo)
  }

  predicate unmappedFlowStoreStep(
    Flow::ClosureNode closureNodeFrom, CapturedVariable v, Flow::ClosureNode closureNodeTo
  ) {
    Flow::storeStep(closureNodeFrom, v, closureNodeTo) and
    not flowStoreStep(_, closureNodeFrom, v, closureNodeTo, _)
  }

  predicate flowReadStep(
    Node nodeFrom, Flow::ClosureNode closureNodeFrom, CapturedVariable v,
    Flow::ClosureNode closureNodeTo, Node nodeTo
  ) {
    closureNodeFrom = asClosureNode(nodeFrom) and
    closureNodeTo = asClosureNode(nodeTo) and
    Flow::readStep(closureNodeFrom, v, closureNodeTo)
  }

  predicate unmappedFlowReadStep(
    Flow::ClosureNode closureNodeFrom, CapturedVariable v, Flow::ClosureNode closureNodeTo
  ) {
    Flow::readStep(closureNodeFrom, v, closureNodeTo) and
    not flowReadStep(_, closureNodeFrom, v, closureNodeTo, _)
  }

  predicate flowValueStep(
    Node nodeFrom, Flow::ClosureNode closureNodeFrom, Flow::ClosureNode closureNodeTo, Node nodeTo
  ) {
    closureNodeFrom = asClosureNode(nodeFrom) and
    closureNodeTo = asClosureNode(nodeTo) and
    Flow::localFlowStep(closureNodeFrom, closureNodeTo)
  }

  predicate unmappedFlowValueStep(Flow::ClosureNode closureNodeFrom, Flow::ClosureNode closureNodeTo) {
    Flow::localFlowStep(closureNodeFrom, closureNodeTo) and
    not flowValueStep(_, closureNodeFrom, closureNodeTo, _)
  }
}
