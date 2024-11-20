/** Provides logic related to captured variables. */

private import python
private import DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate
private import codeql.dataflow.VariableCapture as Shared

// Note: The Javascript implementation (on the branch https://github.com/github/codeql/pull/14412)
// had some tweaks related to performance. See these two commits:
// - JS: Capture flow: https://github.com/github/codeql/pull/14412/commits/7bcf8b858babfea0a3e36ce61145954c249e13ac
// - JS: Disallow consecutive captured contents: https://github.com/github/codeql/pull/14412/commits/46e4cdc6232604ea7f58138a336d5a222fad8567
// The first is the main implementation, the second is a performance motivated restriction.
// The restriction is to clear any `CapturedVariableContent` before writing a new one
// to avoid long access paths (see the link for a nice explanation).
private module CaptureInput implements Shared::InputSig<Location> {
  private import python as PY

  additional class ExprCfgNode extends ControlFlowNode {
    ExprCfgNode() { isExpressionNode(this) }
  }

  class Callable extends Scope {
    predicate isConstructor() { none() }
  }

  class BasicBlock extends PY::BasicBlock {
    int length() { result = count(int i | exists(this.getNode(i))) }

    Callable getEnclosingCallable() { result = this.getScope() }

    // Note `PY:BasicBlock` does not have a `getLocation`.
    // (Instead it has a complicated location info logic.)
    // Using the location of the first node is simple
    // and we just need a way to identify the basic block
    // during debugging, so this will be serviceable.
    Location getLocation() { result = super.getNode(0).getLocation() }
  }

  class ControlFlowNode = PY::ControlFlowNode;

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

    VariableWrite() { this = v.getAStore().getAFlowNode().(DefinitionNode).getValue() }

    CapturedVariable getVariable() { result = v }

    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  class VariableRead extends Expr {
    CapturedVariable v;

    VariableRead() { this = v.getALoad().getAFlowNode() }

    CapturedVariable getVariable() { result = v }
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
  exists(Comp comp | n = TSynthCompCapturedVariablesArgumentNode(comp) |
    result.(Flow::ExprNode).getExpr().getNode() = comp
  )
  or
  // TODO: Should the `Comp`s above be excluded here?
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
    n.(SynthCapturedVariablesParameterNode).getCallable()
}

predicate storeStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::storeStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate readStep(Node nodeFrom, CapturedVariableContent c, Node nodeTo) {
  Flow::readStep(asClosureNode(nodeFrom), c.getVariable(), asClosureNode(nodeTo))
}

predicate clearsContent(Node node, CapturedVariableContent c) {
  Flow::clearsContent(asClosureNode(node), c.getVariable())
}

predicate valueStep(Node nodeFrom, Node nodeTo) {
  Flow::localFlowStep(asClosureNode(nodeFrom), asClosureNode(nodeTo))
}

/**
 * Provides predicates to understand the behavior of the variable capture
 * library instantiation on Python code bases.
 *
 * The predicates in here are meant to be run by quick-eval on databases of
 * interest. The `unmapped*`-predicates should ideally be empty.
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

  predicate unmappedFlowClosureNode(Flow::ClosureNode closureNode) {
    not closureNode = asClosureNode(_)
  }
}
