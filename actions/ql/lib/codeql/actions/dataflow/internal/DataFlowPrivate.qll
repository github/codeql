private import codeql.util.Unit
private import codeql.dataflow.DataFlow
private import codeql.actions.Ast
private import codeql.actions.Cfg as Cfg
private import codeql.Locations
private import codeql.actions.controlflow.BasicBlocks
private import DataFlowPublic
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.dataflow.FlowSteps
private import codeql.actions.dataflow.FlowSources

class DataFlowSecondLevelScope = Unit;

cached
newtype TNode = TExprNode(DataFlowExpr e)

class OutNode extends ExprNode {
  private DataFlowCall call;

  OutNode() { call = this.getCfgNode() }

  DataFlowCall getCall(ReturnKind kind) {
    result = call and
    kind instanceof NormalReturn
  }
}

/**
 * Not implemented
 */
class CastNode extends Node {
  CastNode() { none() }
}

/**
 * Not implemented
 */
class PostUpdateNode extends Node {
  PostUpdateNode() { none() }

  Node getPreUpdateNode() { none() }
}

predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.isParameterOf(c, pos)
}

predicate isArgumentNode(ArgumentNode arg, DataFlowCall call, ArgumentPosition pos) {
  arg.argumentOf(call, pos)
}

DataFlowCallable nodeGetEnclosingCallable(Node node) {
  node = TExprNode(any(DataFlowExpr e | result = e.getScope()))
}

DataFlowType getNodeType(Node node) { any() }

predicate nodeIsHidden(Node node) { none() }

class DataFlowExpr extends Cfg::Node {
  DataFlowExpr() {
    this.getAstNode() instanceof Job or
    this.getAstNode() instanceof Expression or
    this.getAstNode() instanceof Uses or
    this.getAstNode() instanceof Run or
    this.getAstNode() instanceof Outputs or
    this.getAstNode() instanceof Input or
    this.getAstNode() instanceof ScalarValue
  }
}

/**
 * A call corresponds to a Uses steps where a composite action or a reusable workflow get called
 */
class DataFlowCall instanceof Cfg::Node {
  DataFlowCall() { super.getAstNode() instanceof Uses }

  /** Gets a textual representation of this element. */
  string toString() { result = super.toString() }

  string getName() { result = super.getAstNode().(Uses).getCallee() }

  DataFlowCallable getEnclosingCallable() { result = super.getScope() }

  /** Gets a best-effort total ordering. */
  int totalorder() { none() }

  /** Gets the location of this call. */
  Location getLocation() { result = this.(Cfg::Node).getLocation() }
}

/**
 * A Cfg scope that can be called
 */
class DataFlowCallable instanceof Cfg::CfgScope {
  string toString() { result = super.toString() }

  string getName() {
    result = this.(ReusableWorkflowImpl).getResolvedPath() or
    result = this.(CompositeActionImpl).getResolvedPath()
  }

  /** Gets a best-effort total ordering. */
  int totalorder() { none() }

  /** Gets the location of this callable. */
  Location getLocation() { result = this.(Cfg::CfgScope).getLocation() }
}

newtype TReturnKind = TNormalReturn()

abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this element. */
  abstract string toString();
}

class NormalReturn extends ReturnKind, TNormalReturn {
  override string toString() { result = "return" }
}

/** Gets a viable implementation of the target of the given `Call`. */
DataFlowCallable viableCallable(DataFlowCall c) { c.getName() = result.getName() }

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

private newtype TDataFlowType = TUnknownDataFlowType()

/**
 * A type for a data flow node.
 *
 * This may or may not coincide with any type system existing for the source
 * language, but should minimally include unique types for individual closure
 * expressions (typically lambdas).
 */
class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

string ppReprType(DataFlowType t) { none() }

predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

newtype TContent =
  TFieldContent(string name) {
    // We only use field flow for env, steps and jobs outputs
    // not for accessing other context fields such as matrix or inputs
    name = any(StepsExpression a).getFieldName() or
    name = any(NeedsExpression a).getFieldName() or
    name = any(JobsExpression a).getFieldName() or
    name = any(EnvExpression a).getFieldName()
  }

predicate forceHighPrecision(Content c) { c instanceof FieldContent }

class NodeRegion instanceof Unit {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { none() }

  int totalOrder() { result = 1 }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

class ContentApprox = ContentSet;

ContentApprox getContentApprox(Content c) { result = c }

/**
 * Made a string to match the ArgumentPosition type.
 */
class ParameterPosition extends string {
  ParameterPosition() {
    exists(any(ReusableWorkflow w).getInput(this)) or
    exists(any(CompositeAction a).getInput(this))
  }
}

/**
 * Made a string to match `With:` keys in the AST
 */
class ArgumentPosition extends string {
  ArgumentPosition() { exists(any(Uses e).getArgumentExpr(this)) }
}

/**
 */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

/**
 * Holds if there is a local flow step between a ${{ steps.xxx.outputs.yyy }} expression accesing a step output field
 * and the step output itself. But only for those cases where the step output is defined externally in a MaD Source
 * specification. The reason for this is that we don't currently have a way to specify that a source starts with a
 * non-empty access path so we cannot write a Source that stores the taint in a Content, we can only do that for steps
 * (storeStep). The easiest thing is to add this local flow step that simulates a read step from the source node for a specific
 * field name.
 */
predicate stepsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(Uses astFrom, StepsExpression astTo |
    madSource(nodeFrom, _, "output." + ["*", astTo.getFieldName()]) and
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getTarget() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{ needs.xxx.outputs.yyy }} expression accesing a job output field
 * and the step output itself. But only for those cases where the job (needs) output is defined externally in a MaD Source
 * specification. The reason for this is that we don't currently have a way to specify that a source starts with a
 * non-empty access path so we cannot write a Source that stores the taint in a Content, we can only do that for steps
 * (storeStep). The easiest thing is to add this local flow step that simulates a read step from the source node for a specific
 * field name.
 */
predicate needsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(Uses astFrom, NeedsExpression astTo |
    madSource(nodeFrom, _, "output." + astTo.getFieldName()) and
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getTarget() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing an input variable and the input itself
 * e.g. ${{ inputs.foo }}
 */
predicate inputsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(AstNode astFrom, InputsExpression astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getTarget() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing a matrix variable and the matrix itself
 * e.g. ${{ matrix.foo }}
 */
predicate matrixCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(AstNode astFrom, MatrixExpression astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getTarget() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing an env var and the var definition itself
 * e.g. ${{ env.foo }}
 */
predicate envCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(AstNode astFrom, EnvExpression astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    (
      madSource(nodeFrom, _, "env." + astTo.getFieldName())
      or
      astTo.getTarget() = astFrom
    )
  )
}

/**
 * Holds if there is a local flow step from `nodeFrom` to `nodeTo`.
 * For Actions, we dont need SSA nodes since it should be already in SSA form
 * Local flow steps are always between two nodes in the same Cfg scope.
 */
pragma[nomagic]
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  stepsCtxLocalStep(nodeFrom, nodeTo) or
  needsCtxLocalStep(nodeFrom, nodeTo) or
  inputsCtxLocalStep(nodeFrom, nodeTo) or
  matrixCtxLocalStep(nodeFrom, nodeTo) or
  envCtxLocalStep(nodeFrom, nodeTo)
}

/**
 * This is the local flow predicate that is used as a building block in global
 * data flow.
 */
cached
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
  localFlowStep(nodeFrom, nodeTo) and model = ""
}

/**
 * Holds if data can flow from `node1` to `node2` through a non-local step
 * that does not follow a call edge. For example, a step through a global
 * variable.
 * We throw away the call context and let us jump to any location
 * AKA teleport steps
 * local steps are preferible since they are more predictable and easier to control
 */
predicate jumpStep(Node nodeFrom, Node nodeTo) { none() }

/**
 * Holds if a Expression reads a field from a job (needs/jobs), step (steps) output via a read of `c` (fieldname)
 */
predicate ctxFieldReadStep(Node node1, Node node2, ContentSet c) {
  exists(SimpleReferenceExpression access |
    (
      access instanceof NeedsExpression or
      access instanceof StepsExpression or
      access instanceof JobsExpression or
      access instanceof EnvExpression
    ) and
    c = any(FieldContent ct | ct.getName() = access.getFieldName()) and
    node1.asExpr() = access.getTarget() and
    node2.asExpr() = access
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
 * `node1` references an object with a content `c.getAReadContent()` whose
 * value ends up in `node2`.
 * Store steps without corresponding reads are pruned aggressively very early, since they can never contribute to a complete path.
 */
predicate readStep(Node node1, ContentSet c, Node node2) { ctxFieldReadStep(node1, node2, c) }

/**
 * Stores an output expression (node1) into its OutputsStm node (node2)
 * using the output variable name as the access path
 */
predicate fieldStoreStep(Node node1, Node node2, ContentSet c) {
  exists(Outputs out, string fieldName |
    node1.asExpr() = out.getOutputExpr(fieldName) and
    node2.asExpr() = out and
    c = any(FieldContent ct | ct.getName() = fieldName)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
 * `node2` references an object with a content `c.getAStoreContent()` that
 * contains the value of `node1`.
 * Store steps without corresponding reads are pruned aggressively very early, since they can never contribute to a complete path.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  fieldStoreStep(node1, node2, c) or
  madStoreStep(node1, node2, c) or
  envToOutputStoreStep(node1, node2, c) or
  envToEnvStoreStep(node1, node2, c) or
  commandToOutputStoreStep(node1, node2, c) or
  commandToEnvStoreStep(node1, node2, c)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) { none() }

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) { none() }

predicate localMustFlowStep(Node nodeFrom, Node nodeTo) { localFlowStep(nodeFrom, nodeTo) }

private newtype TLambdaCallKind = TNone()

class LambdaCallKind = TLambdaCallKind;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Since our model is so simple, we dont want to compress the local flow steps.
 * This compression is normally done to not show SSA steps, casts, etc.
 */
predicate neverSkipInPathGraph(Node node) { any() }

predicate knownSourceModel(Node source, string model) { none() }

predicate knownSinkModel(Node sink, string model) { none() }
