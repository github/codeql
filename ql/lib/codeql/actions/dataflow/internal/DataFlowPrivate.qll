private import codeql.dataflow.DataFlow
private import codeql.actions.Ast
private import codeql.actions.Cfg as Cfg
private import codeql.Locations
private import codeql.actions.controlflow.BasicBlocks
private import DataFlowPublic

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
  DataFlowExpr() { this.getAstNode() instanceof Expression }
}

/**
 * A call corresponds to a Uses steps where a 3rd party action or a reusable workflow gets called
 */
class DataFlowCall instanceof Cfg::Node {
  DataFlowCall() { super.getAstNode() instanceof UsesExpr }

  /** Gets a textual representation of this element. */
  string toString() { result = super.toString() }

  Location getLocation() { result = super.getLocation() }

  string getName() { result = super.getAstNode().(UsesExpr).getCallee() }

  DataFlowCallable getEnclosingCallable() { result = super.getScope() }
}

/**
 * A Cfg scope that can be called
 */
class DataFlowCallable instanceof Cfg::CfgScope {
  string toString() { result = super.toString() }

  Location getLocation() { result = super.getLocation() }

  string getName() {
    if this instanceof ReusableWorkflowStmt
    then result = this.(ReusableWorkflowStmt).getName()
    else
      if this instanceof CompositeActionStmt
      then result = this.(CompositeActionStmt).getName()
      else none()
  }
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

bindingset[t1, t2]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { t1 = t2 }

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

private newtype TContent = TNoContent() { none() }

class Content extends TContent {
  /** Gets a textual representation of this element. */
  string toString() { none() }
}

predicate forceHighPrecision(Content c) { none() }

newtype TContentSet = TNoContentSet() { none() }

private newtype TContentApprox = TNoContentApprox() { none() }

class ContentApprox extends TContentApprox {
  /** Gets a textual representation of this element. */
  string toString() { none() }
}

ContentApprox getContentApprox(Content c) { none() }

/**
 * Made a string to match the ArgumentPosition type.
 */
class ParameterPosition extends string {
  ParameterPosition() { exists(any(ReusableWorkflowStmt w).getInputsStmt().getInputExpr(this)) }
}

/**
 * Made a string to match `With:` keys in the AST
 */
class ArgumentPosition extends string {
  ArgumentPosition() { exists(any(UsesExpr e).getArgumentExpr(this)) }
}

/**
 */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

/**
 * Holds if there is a local flow step between a ${{}} expression accesing a step output variable and the step output itself
 * e.g. ${{ steps.step1.output.foo }}
 */
predicate stepsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(StepStmt astFrom, StepOutputAccessExpr astTo |
    (astFrom instanceof UsesExpr or astFrom instanceof RunExpr) and
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getRefExpr() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing a job output variable and the job output itself
 * e.g. ${{ needs.job1.output.foo }} or ${{ job.job1.output.foo }}
 */
predicate jobsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(Expression astFrom, JobOutputAccessExpr astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getRefExpr() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing an input variable and the input itself
 * e.g. ${{ inputs.foo }}
 */
predicate inputsCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(Expression astFrom, InputAccessExpr astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getRefExpr() = astFrom
  )
}

/**
 * Holds if there is a local flow step between a ${{}} expression accesing an env var and the var definition itself
 * e.g. ${{ env.foo }}
 */
predicate envCtxLocalStep(Node nodeFrom, Node nodeTo) {
  exists(Expression astFrom, EnvAccessExpr astTo |
    astFrom = nodeFrom.asExpr() and
    astTo = nodeTo.asExpr() and
    astTo.getRefExpr() = astFrom
  )
}

/**
 * Holds if there is a local flow step from `nodeFrom` to `nodeTo`.
 * For Actions, we dont need SSA nodes since it should be already in SSA form
 * Local flow steps are always between two nodes in the same Cfg scope (job definition).
 */
pragma[nomagic]
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  stepsCtxLocalStep(nodeFrom, nodeTo) or
  jobsCtxLocalStep(nodeFrom, nodeTo) or
  inputsCtxLocalStep(nodeFrom, nodeTo) or
  envCtxLocalStep(nodeFrom, nodeTo)
}

/**
 * a simple local flow step that should always preserve the call context (same callable)
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) { localFlowStep(nodeFrom, nodeTo) }

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
 * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
 * `node1` references an object with a content `c.getAReadContent()` whose
 * value ends up in `node2`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) { none() }

/**
 * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
 * `node2` references an object with a content `c.getAStoreContent()` that
 * contains the value of `node1`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) { none() }

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
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }

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
