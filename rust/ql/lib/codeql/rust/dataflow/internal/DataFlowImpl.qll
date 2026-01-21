/**
 * Provides Rust-specific definitions for use in the data flow library.
 */

private import codeql.util.Void
private import codeql.util.Unit
private import codeql.util.Boolean
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import rust
private import SsaImpl as SsaImpl
private import codeql.rust.controlflow.internal.Scope as Scope
private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl
private import codeql.rust.internal.PathResolution
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.dataflow.Ssa
private import codeql.rust.dataflow.FlowSummary
private import codeql.rust.internal.typeinference.TypeInference as TypeInference
private import codeql.rust.internal.typeinference.DerefChain
private import Node
private import Content
private import FlowSummaryImpl as FlowSummaryImpl

/**
 * A return kind. A return kind describes how a value can be returned from a
 * callable.
 *
 * The only return kind is a "normal" return from a `return` statement or an
 * expression body.
 */
final class ReturnKind extends TNormalReturnKind {
  string toString() { result = "return" }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
final class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   */
  CfgScope asCfgScope() { this = TCfgScope(result) }

  /**
   * Gets the underlying library callable, if any.
   */
  SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Gets a textual representation of this callable. */
  string toString() {
    result = [this.asCfgScope().toString(), "[summarized] " + this.asSummarizedCallable()]
  }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = [this.asCfgScope().getLocation(), this.asSummarizedCallable().getLocation()]
  }
}

final class DataFlowCall extends TDataFlowCall {
  /** Gets the underlying call, if any. */
  Call asCall() { this = TCall(result) }

  predicate isImplicitDerefCall(Expr e, DerefChain derefChain, int i, Function target) {
    this = TImplicitDerefCall(e, derefChain, i, target)
  }

  predicate isSummaryCall(
    FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
  ) {
    this = TSummaryCall(c, receiver)
  }

  DataFlowCallable getEnclosingCallable() {
    result.asCfgScope() = this.asCall().getEnclosingCfgScope()
    or
    result.asCfgScope() = any(Expr e | this.isImplicitDerefCall(e, _, _, _)).getEnclosingCfgScope()
    or
    this.isSummaryCall(result.asSummarizedCallable(), _)
  }

  string toString() {
    result = this.asCall().toString()
    or
    exists(Expr e, DerefChain derefChain, int i |
      this.isImplicitDerefCall(e, derefChain, i, _) and
      result = "[implicit deref call " + i + " in " + derefChain.toString() + "] " + e
    )
    or
    exists(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    |
      this.isSummaryCall(c, receiver) and
      result = "[summary] call to " + receiver + " in " + c
    )
  }

  Location getLocation() {
    result = this.asCall().getLocation()
    or
    result = any(Expr e | this.isImplicitDerefCall(e, _, _, _)).getLocation()
  }
}

/**
 * Holds if `arg` is an argument of `call` at the position `pos`.
 */
predicate isArgumentForCall(Expr arg, Call call, RustDataFlow::ArgumentPosition pos) {
  arg = pos.getArgument(call)
}

/** Provides logic related to SSA. */
module SsaFlow {
  private module SsaFlow = SsaImpl::DataFlowIntegration;

  /** Converts a control flow node into an SSA control flow node. */
  SsaFlow::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(SsaFlow::ExprNode).getExpr() = n.asExpr()
    or
    result.(SsaFlow::ExprPostUpdateNode).getExpr() = n.(PostUpdateNode).getPreUpdateNode().asExpr()
  }

  predicate localFlowStep(
    SsaImpl::SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
  ) {
    SsaFlow::localFlowStep(v, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(Node nodeFrom, Node nodeTo) {
    SsaFlow::localMustFlowStep(_, asNode(nodeFrom), asNode(nodeTo))
  }
}

/**
 * Gets a node that may execute last in `e`, and which, when it executes last,
 * will be the value of `e`.
 */
private Expr getALastEvalNode(Expr e) {
  e = any(IfExpr n | result = [n.getThen(), n.getElse()]) or
  result = e.(LoopExpr).getLoopBody() or
  result = e.(ReturnExpr).getExpr() or
  result = e.(BreakExpr).getExpr() or
  e =
    any(BlockExpr be |
      not be.isAsync() and
      result = be.getTailExpr()
    ) or
  result = e.(MatchExpr).getAnArm().getExpr() or
  result = e.(MacroExpr).getMacroCall().getMacroCallExpansion() or
  result.(BreakExpr).getTarget() = e or
  result = e.(ParenExpr).getExpr()
}

/**
 * Holds if a reverse local flow step should be added from the post-update node
 * for `e` to the post-update node for the result. `preservesValue` is true
 * if the step is value preserving.
 *
 * This is needed to allow for side-effects on compound expressions to propagate
 * to sub components. For example, in
 *
 * ```rust
 * ({ foo(); &mut a}).set_data(taint);
 * ```
 *
 * we add a reverse flow step from `[post] { foo(); &mut a}` to `[post] &mut a`,
 * in order for the side-effect of `set_data` to reach `&mut a`.
 */
Expr getPostUpdateReverseStep(Expr e, boolean preservesValue) {
  result = getALastEvalNode(e) and
  preservesValue = true
  or
  result = e.(CastExpr).getExpr() and
  preservesValue = false
}

module LocalFlow {
  predicate flowSummaryLocalStep(Node nodeFrom, Node nodeTo, string model) {
    exists(FlowSummaryImpl::Public::SummarizedCallable c |
      FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
        nodeTo.(FlowSummaryNode).getSummaryNode(), true, model) and
      c = nodeFrom.(FlowSummaryNode).getSummarizedCallable()
    )
    or
    FlowSummaryImpl::Private::Steps::sourceLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo, model)
    or
    FlowSummaryImpl::Private::Steps::sinkLocalStep(nodeFrom,
      nodeTo.(FlowSummaryNode).getSummaryNode(), model)
  }

  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.asExpr() = getALastEvalNode(nodeTo.asExpr())
    or
    // An edge from the right-hand side of a let statement to the left-hand side.
    exists(LetStmt s |
      nodeFrom.asExpr() = s.getInitializer() and
      nodeTo.asPat() = s.getPat()
    )
    or
    // An edge from the right-hand side of a let expression to the left-hand side.
    exists(LetExpr e |
      nodeFrom.asExpr() = e.getScrutinee() and
      nodeTo.asPat() = e.getPat()
    )
    or
    exists(IdentPat p |
      not p.isRef() and
      nodeFrom.asPat() = p and
      nodeTo.(NameNode).getName() = p.getName()
    )
    or
    exists(SelfParam self |
      nodeFrom.asParameter() = self and
      nodeTo.(NameNode).getName() = self.getName()
    )
    or
    // An edge from a pattern/expression to its corresponding SSA definition.
    exists(AstNode n |
      n = nodeTo.(SsaNode).asDefinition().(Ssa::WriteDefinition).getWriteAccess() and
      n = nodeFrom.(AstNodeNode).getAstNode() and
      not n = any(CompoundAssignmentExpr cae).getLhs()
    )
    or
    nodeFrom.(SourceParameterNode).getParameter().(Param).getPat() = nodeTo.asPat()
    or
    exists(AssignmentExpr a |
      a.getRhs() = nodeFrom.asExpr() and
      a.getLhs() = nodeTo.asExpr()
    )
    or
    exists(MatchExpr match |
      nodeFrom.asExpr() = match.getScrutinee() and
      nodeTo.asPat() = match.getAnArm().getPat()
    )
    or
    nodeFrom.asPat().(OrPat).getAPat() = nodeTo.asPat()
    or
    nodeTo.(PostUpdateNode).getPreUpdateNode().asExpr() =
      getPostUpdateReverseStep(nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr(), true)
  }
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind`. */
predicate lambdaCreationExpr(Expr creation) {
  creation instanceof ClosureExpr
  or
  creation instanceof Scope::AsyncBlockScope
}

/**
 * Holds if `call` is a lambda call of kind `kind` where `receiver` is the
 * invoked expression.
 */
predicate lambdaCallExpr(CallExprImpl::DynamicCallExpr call, LambdaCallKind kind, Expr receiver) {
  receiver = call.getFunction() and
  exists(kind)
}

// Defines a set of aliases needed for the `RustDataFlow` module
private module Aliases {
  class DataFlowCallableAlias = DataFlowCallable;

  class ReturnKindAlias = ReturnKind;

  class DataFlowCallAlias = DataFlowCall;

  class ContentAlias = Content;

  class ContentApproxAlias = ContentApprox;

  class ContentSetAlias = ContentSet;

  class LambdaCallKindAlias = LambdaCallKind;
}

/**
 * Index assignments like `a[i] = rhs` are treated as `*a.index_mut(i) = rhs`,
 * so they should in principle be handled by `referenceAssignment`.
 *
 * However, this would require support for [generalized reverse flow][1], which
 * is not yet implemented, so instead we simulate reverse flow where it would
 * have applied via the model for `<_ as core::ops::index::IndexMut>::index_mut`.
 *
 * The same is the case for compound assignments like `a[i] += rhs`, which are
 * treated as `(*a.index_mut(i)).add_assign(rhs)`.
 *
 * [1]: https://github.com/github/codeql/pull/18109
 */
predicate indexAssignment(
  AssignmentOperation assignment, IndexExpr index, Node rhs, PostUpdateNode base, Content c
) {
  assignment.getLhs() = index and
  rhs.asExpr() = assignment.getRhs() and
  base.getPreUpdateNode().asExpr() = index.getBase() and
  c instanceof ElementContent and
  // simulate that the flow summary applies
  not index.getResolvedTarget().fromSource()
}

signature module RustDataFlowInputSig {
  predicate includeDynamicTargets();
}

module RustDataFlowGen<RustDataFlowInputSig Input> implements InputSig<Location> {
  private import Aliases
  private import codeql.rust.dataflow.DataFlow
  private import Node as Node
  private import codeql.rust.frameworks.stdlib.Stdlib

  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  class Node = DataFlow::Node;

  final class ParameterNode = Node::ParameterNode;

  final class ArgumentNode = Node::ArgumentNode;

  final class ReturnNode = Node::ReturnNode;

  final class OutNode = Node::OutNode;

  class PostUpdateNode = DataFlow::PostUpdateNode;

  final class CastNode = Node::CastNode;

  /**
   * The position of a parameter in a function.
   *
   * In Rust there is a 1-to-1 correspondence between parameter positions and
   * arguments positions, so we use the same underlying type for both.
   */
  final class ParameterPosition extends TParameterPosition {
    /** Gets the underlying integer position, if any. */
    int getPosition() { this = TPositionalParameterPosition(result) }

    predicate hasPosition() { exists(this.getPosition()) }

    /** Holds if this position represents the `self` position. */
    predicate isSelf() { this = TSelfParameterPosition() }

    /**
     * Holds if this position represents a reference to a closure itself. Only
     * used for tracking flow through captured variables.
     */
    predicate isClosureSelf() { this = TClosureSelfParameterPosition() }

    /** Gets a textual representation of this position. */
    string toString() {
      result = this.getPosition().toString()
      or
      result = "self" and this.isSelf()
      or
      result = "closure self" and this.isClosureSelf()
    }

    ParamBase getParameterIn(ParamList ps) {
      result = ps.getParam(this.getPosition())
      or
      result = ps.getSelfParam() and this.isSelf()
    }
  }

  /**
   * The position of an argument in a call.
   *
   * In Rust there is a 1-to-1 correspondence between parameter positions and
   * arguments positions, so we use the same underlying type for both.
   */
  final class ArgumentPosition extends ParameterPosition {
    /** Gets the argument of `call` at this position, if any. */
    Expr getArgument(Call call) {
      result = call.getPositionalArgument(this.getPosition())
      or
      result = call.(MethodCall).getReceiver() and this.isSelf()
    }
  }

  /** Holds if `p` is a parameter of `c` at the position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.isParameterOf(c, pos)
  }

  /** Holds if `n` is an argument of `c` at the position `pos`. */
  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    n.isArgumentOf(call, pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) {
    result = node.(Node::Node).getEnclosingCallable()
  }

  DataFlowType getNodeType(Node node) { any() }

  predicate nodeIsHidden(Node node) {
    node instanceof SsaNode or
    node.(FlowSummaryNode).getSummaryNode().isHidden() or
    node instanceof CaptureNode or
    node instanceof ClosureParameterNode or
    node instanceof ImplicitDerefNode or
    node instanceof ImplicitBorrowNode or
    node instanceof DerefOutNode or
    node instanceof IndexOutNode or
    node.asExpr() instanceof ParenExpr or
    nodeIsHidden(node.(PostUpdateNode).getPreUpdateNode())
  }

  private Expr stripParens(Expr e) {
    not e instanceof ParenExpr and
    result = e
    or
    result = stripParens(e.(ParenExpr).getExpr())
  }

  predicate neverSkipInPathGraph(Node node) {
    node.(Node::Node).asPat() = any(LetStmt s).getPat()
    or
    node.(Node::Node).asPat() = any(LetExpr e).getPat()
    or
    node.(Node::Node).asExpr() = stripParens(any(AssignmentExpr a).getLhs())
    or
    exists(MatchExpr match |
      node.asExpr() = stripParens(match.getScrutinee()) or
      node.asPat() = match.getAnArm().getPat()
    )
    or
    FlowSummaryImpl::Private::Steps::sourceLocalStep(_, node, _)
    or
    FlowSummaryImpl::Private::Steps::sinkLocalStep(node, _, _)
  }

  class DataFlowExpr = Expr;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.asExpr() = e }

  final class DataFlowCall = DataFlowCallAlias;

  final class DataFlowCallable = DataFlowCallableAlias;

  final class ReturnKind = ReturnKindAlias;

  private Function getStaticTargetExt(Call c) {
    result = c.getStaticTarget()
    or
    // If the static target of an overloaded operation cannot be resolved, we fall
    // back to the trait method as the target. This ensures that the flow models
    // still apply.
    not exists(c.getStaticTarget()) and
    exists(TraitItemNode t, string methodName |
      c.(Operation).isOverloaded(t, methodName, _) and
      result = t.getAssocItem(methodName)
    )
  }

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall call) {
    exists(Call c | c = call.asCall() |
      (
        if Input::includeDynamicTargets()
        then result.asCfgScope() = c.getARuntimeTarget()
        else result.asCfgScope() = c.getStaticTarget()
      )
      or
      result.asSummarizedCallable() = getStaticTargetExt(c)
    )
    or
    exists(Function f | call = TImplicitDerefCall(_, _, _, f) |
      result.asCfgScope() = f
      or
      result.asSummarizedCallable() = f
    )
  }

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

  // NOTE: For now we use the type `Unit` and do not benefit from type
  // information in the data flow analysis.
  final class DataFlowType extends Unit {
    string toString() { result = "" }
  }

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

  class Content = ContentAlias;

  class ContentSet = ContentSetAlias;

  class LambdaCallKind = LambdaCallKindAlias;

  predicate forceHighPrecision(Content c) { none() }

  class ContentApprox = ContentApproxAlias;

  ContentApprox getContentApprox(Content c) {
    result = TTupleFieldContentApprox(tupleFieldApprox(c.(TupleFieldContent).getField()))
    or
    result = TStructFieldContentApprox(structFieldApprox(c.(StructFieldContent).getField()))
    or
    result = TElementContentApprox() and c instanceof ElementContent
    or
    result = TFutureContentApprox() and c instanceof FutureContent
    or
    result = TTuplePositionContentApprox() and c instanceof TuplePositionContent
    or
    result = TFunctionCallArgumentContentApprox() and c instanceof FunctionCallArgumentContent
    or
    result = TFunctionCallReturnContentApprox() and c instanceof FunctionCallReturnContent
    or
    result = TCapturedVariableContentApprox() and c instanceof CapturedVariableContent
    or
    result = TReferenceContentApprox() and c instanceof ReferenceContent
  }

  /**
   * Holds if the parameter position `ppos` matches the argument position
   * `apos`.
   */
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  /**
   * Holds if there is a simple local flow step from `node1` to `node2`. These
   * are the value-preserving intra-callable flow steps.
   */
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    (
      LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
      or
      exists(SsaImpl::SsaInput::SourceVariable v, boolean isUseStep |
        SsaFlow::localFlowStep(v, nodeFrom, nodeTo, isUseStep) and
        not v instanceof VariableCapture::CapturedVariable
      |
        isUseStep = false
        or
        isUseStep = true and
        not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
      )
      or
      nodeFrom = nodeTo.(ImplicitDerefNode).getLocalInputNode()
      or
      VariableCapture::localFlowStep(nodeFrom, nodeTo)
    ) and
    model = ""
    or
    LocalFlow::flowSummaryLocalStep(nodeFrom, nodeTo, model)
    or
    // Add flow through optional barriers. This step is then blocked by the barrier for queries that choose to use the barrier.
    FlowSummaryImpl::Private::Steps::summaryReadStep(nodeFrom
          .(Node::FlowSummaryNode)
          .getSummaryNode(), TOptionalBarrier(_), nodeTo.(Node::FlowSummaryNode).getSummaryNode()) and
    model = ""
  }

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2) {
    FlowSummaryImpl::Private::Steps::summaryJumpStep(node1.(FlowSummaryNode).getSummaryNode(),
      node2.(FlowSummaryNode).getSummaryNode()) or
    FlowSummaryImpl::Private::Steps::sourceJumpStep(node1.(FlowSummaryNode).getSummaryNode(), node2)
  }

  pragma[nomagic]
  private predicate implicitDeref(ImplicitDerefNode node1, Node node2, ReferenceContent c) {
    node2 = node1.getDerefOutputNode() and
    exists(c)
  }

  pragma[nomagic]
  private predicate implicitBorrow(Node node1, ImplicitDerefBorrowNode node2, ReferenceContent c) {
    node1 = node2.getBorrowInputNode() and
    exists(c)
  }

  pragma[nomagic]
  private predicate referenceExprToExpr(Node node1, Node node2, ReferenceContent c) {
    node1.asExpr() = node2.asExpr().(RefExpr).getExpr() and
    exists(c)
  }

  private Node getFieldExprContainerNode(FieldExpr fe) {
    exists(Expr container | container = fe.getContainer() |
      not TypeInference::implicitDerefChainBorrow(container, _, _) and
      result.asExpr() = container
      or
      result.(ImplicitDerefNode).isLast(container)
    )
  }

  pragma[nomagic]
  additional predicate readContentStep(Node node1, Content c, Node node2) {
    exists(TupleStructPat pat, int pos |
      pat = node1.asPat() and
      node2.asPat() = pat.getField(pos) and
      c = TTupleFieldContent(pat.getTupleField(pos))
    )
    or
    exists(TuplePat pat, int pos |
      pos = c.(TuplePositionContent).getPosition() and
      node1.asPat() = pat and
      node2.asPat() = pat.getField(pos)
    )
    or
    exists(StructPat pat, string field |
      pat = node1.asPat() and
      c = TStructFieldContent(pat.getStructField(field)) and
      node2.asPat() = pat.getPatField(field).getPat()
    )
    or
    c instanceof ReferenceContent and
    node1.asPat().(RefPat).getPat() = node2.asPat()
    or
    exists(FieldExpr access |
      node1 = getFieldExprContainerNode(access) and
      node2.asExpr() = access and
      access = c.(FieldContent).getAnAccess()
    )
    or
    exists(ForExpr for |
      c instanceof ElementContent and
      node1.asExpr() = for.getIterable() and
      node2.asPat() = for.getPat()
    )
    or
    exists(SlicePat pat |
      c instanceof ElementContent and
      node1.asPat() = pat and
      node2.asPat() = pat.getAPat()
    )
    or
    exists(TryExpr try |
      node1.asExpr() = try.getExpr() and
      node2.asExpr() = try and
      c.(TupleFieldContent)
          .isVariantField([any(OptionEnum o).getSome(), any(ResultEnum r).getOk()], 0)
    )
    or
    exists(DerefExpr deref |
      c instanceof ReferenceContent and
      node1.(DerefOutNode).getDerefExpr() = deref and
      node2.asExpr() = deref
    )
    or
    exists(IndexExpr index |
      c instanceof ReferenceContent and
      node1.(IndexOutNode).getIndexExpr() = index and
      node2.asExpr() = index
    )
    or
    // Read from function return
    exists(DataFlowCall call |
      lambdaCall(call, _, node1) and
      call = node2.(OutNode).getCall(TNormalReturnKind()) and
      c instanceof FunctionCallReturnContent
    )
    or
    exists(AwaitExpr await |
      c instanceof FutureContent and
      node1.asExpr() = await.getExpr() and
      node2.asExpr() = await
    )
    or
    referenceExprToExpr(node2.(PostUpdateNode).getPreUpdateNode(),
      node1.(PostUpdateNode).getPreUpdateNode(), c)
    or
    implicitDeref(node1, node2, c)
    or
    // A read step dual to the store step for implicit borrows.
    exists(Node n | implicitBorrow(n, node1.(PostUpdateNode).getPreUpdateNode(), c) |
      node2.(PostUpdateNode).getPreUpdateNode() = n
      or
      // For compound assignments into variables like `x += y`, we do not want flow into
      // `[post] x`, as that would create spurious flow when `x` is a parameter. Instead,
      // we add the step directly into the SSA definition for `x` after the update.
      exists(CompoundAssignmentExpr cae, Expr lhs |
        lhs = cae.getLhs() and
        lhs = node2.(SsaNode).asDefinition().(Ssa::WriteDefinition).getWriteAccess() and
        n = TExprNode(lhs)
      )
    )
    or
    VariableCapture::readStep(node1, c, node2)
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet cs, Node node2) {
    exists(Content c |
      c = cs.(SingletonContentSet).getContent() and
      readContentStep(node1, c, node2)
    )
    or
    FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), cs,
      node2.(FlowSummaryNode).getSummaryNode()) and
    not isSpecialContentSet(cs)
  }

  /**
   * Holds if `cs` is used to encode a special operation as a content component, but should not
   * be treated as an ordinary content component.
   */
  private predicate isSpecialContentSet(ContentSet cs) {
    cs instanceof TOptionalStep or
    cs instanceof TOptionalBarrier
  }

  pragma[nomagic]
  private predicate fieldAssignment(Node node1, Node node2, FieldContent c) {
    exists(AssignmentExpr assignment, FieldExpr access |
      assignment.getLhs() = access and
      node1.asExpr() = assignment.getRhs() and
      node2 = getFieldExprContainerNode(access) and
      access = c.getAnAccess()
    )
  }

  pragma[nomagic]
  private predicate referenceAssignment(
    Node node1, Node node2, Expr e, boolean clears, ReferenceContent c
  ) {
    exists(AssignmentExpr assignment, Expr lhs |
      assignment.getLhs() = lhs and
      node1.asExpr() = assignment.getRhs() and
      exists(c)
    |
      lhs =
        any(DerefExpr de |
          de = node2.(DerefOutNode).getDerefExpr() and
          e = de.getExpr()
        ) and
      clears = true
      or
      lhs =
        any(IndexExpr ie |
          ie = node2.(IndexOutNode).getIndexExpr() and
          e = ie.getBase() and
          clears = false
        )
    )
  }

  pragma[nomagic]
  additional predicate storeContentStep(Node node1, Content c, Node node2) {
    exists(CallExpr ce, TupleField tf, int pos |
      node1.asExpr() = ce.getSyntacticPositionalArgument(pos) and
      node2.asExpr() = ce and
      c = TTupleFieldContent(tf)
    |
      tf = ce.(TupleStructExpr).getTupleField(pos)
      or
      tf = ce.(TupleVariantExpr).getTupleField(pos)
    )
    or
    exists(StructExpr re, string field |
      c = TStructFieldContent(re.getStructField(field)) and
      node1.asExpr() = re.getFieldExpr(field).getExpr() and
      node2.asExpr() = re
    )
    or
    exists(TupleExpr tuple |
      node1.asExpr() = tuple.getField(c.(TuplePositionContent).getPosition()) and
      node2.asExpr() = tuple
    )
    or
    c instanceof ElementContent and
    node1.asExpr() =
      [
        node2.asExpr().(ArrayRepeatExpr).getRepeatOperand(),
        node2.asExpr().(ArrayListExpr).getAnExpr()
      ]
    or
    // Store from a `ref` identifier pattern into the contained name.
    exists(IdentPat p |
      c instanceof ReferenceContent and
      p.isRef() and
      node1.asPat() = p and
      node2.(NameNode).getName() = p.getName()
    )
    or
    fieldAssignment(node1, node2.(PostUpdateNode).getPreUpdateNode(), c)
    or
    referenceAssignment(node1, node2.(PostUpdateNode).getPreUpdateNode(), _, _, c)
    or
    indexAssignment(any(AssignmentExpr ae), _, node1, node2, c)
    or
    // Compund assignment like `a[i] += rhs` are modeled as a store step from `rhs`
    // to `[post] a[i]`, followed by a taint step into `[post] a`.
    indexAssignment(any(CompoundAssignmentExpr cae),
      node2.(PostUpdateNode).getPreUpdateNode().asExpr(), node1, _, c)
    or
    referenceExprToExpr(node1, node2, c)
    or
    // Store in function argument
    exists(DataFlowCall call, int i |
      isArgumentNode(node1, call, TPositionalParameterPosition(i)) and
      lambdaCall(call, _, node2.(PostUpdateNode).getPreUpdateNode()) and
      c.(FunctionCallArgumentContent).getPosition() = i
    )
    or
    VariableCapture::storeStep(node1, c, node2)
    or
    implicitBorrow(node1, node2, c)
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet cs, Node node2) {
    storeContentStep(node1, cs.(SingletonContentSet).getContent(), node2)
    or
    FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), cs,
      node2.(FlowSummaryNode).getSummaryNode()) and
    not isSpecialContentSet(cs)
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet cs) {
    fieldAssignment(_, n, cs.(SingletonContentSet).getContent())
    or
    referenceAssignment(_, _, n.asExpr(), true, cs.(SingletonContentSet).getContent())
    or
    FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), cs)
    or
    VariableCapture::clearsContent(n, cs.(SingletonContentSet).getContent())
  }

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet cs) {
    FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), cs)
  }

  class NodeRegion instanceof Void {
    string toString() { result = "NodeRegion" }

    predicate contains(Node n) { none() }
  }

  /**
   * Holds if the nodes in `nr` are unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

  /**
   * Holds if flow is allowed to pass from parameter `p` and back to itself as a
   * side-effect, resulting in a summary from `p` to itself.
   *
   * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
   * by default as a heuristic.
   */
  predicate allowParameterReturnInSelf(ParameterNode p) {
    exists(DataFlowCallable c, ParameterPosition pos |
      p.isParameterOf(c, pos) and
      FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asSummarizedCallable(), pos)
    )
    or
    VariableCapture::Flow::heuristicAllowInstanceParameterReturnInSelf(p.(ClosureParameterNode)
          .getCfgScope())
  }

  /**
   * Holds if the value of `node2` is given by `node1`.
   *
   * This predicate is combined with type information in the following way: If
   * the data flow library is able to compute an improved type for `node1` then
   * it will also conclude that this type applies to `node2`. Vice versa, if
   * `node2` must be visited along a flow path, then any type known for `node2`
   * must also apply to `node1`.
   */
  predicate localMustFlowStep(Node node1, Node node2) {
    SsaFlow::localMustFlowStep(node1, node2)
    or
    FlowSummaryImpl::Private::Steps::summaryLocalMustFlowStep(node1
          .(FlowSummaryNode)
          .getSummaryNode(), node2.(FlowSummaryNode).getSummaryNode())
  }

  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
    exists(kind) and
    exists(Expr e | e = creation.asExpr() |
      lambdaCreationExpr(e) and e = c.asCfgScope()
      or
      // A path expression, that resolves to a function, evaluates to a function
      // pointer. Except if the path occurs directly in a call, then it's just a
      // call to the function and not a function being passed as data.
      resolvePath(e.(PathExpr).getPath()) = c.asCfgScope() and
      not any(CallExpr call).getFunction() = e
    )
  }

  /**
   * Holds if `call` is a lambda call of kind `kind` where `receiver` is the
   * invoked expression.
   */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
    (
      receiver.asExpr() = call.asCall().(CallExprImpl::DynamicCallExpr).getFunction()
      or
      call.isSummaryCall(_, receiver.(FlowSummaryNode).getSummaryNode())
    ) and
    exists(kind)
  }

  /** Extra data flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) {
    source.(FlowSummaryNode).isSource(_, model)
  }

  predicate knownSinkModel(Node sink, string model) { sink.(FlowSummaryNode).isSink(_, model) }

  class DataFlowSecondLevelScope = Void;
}

module RustDataFlowInput implements RustDataFlowInputSig {
  predicate includeDynamicTargets() { any() }
}

module RustDataFlow = RustDataFlowGen<RustDataFlowInput>;

/** Provides logic related to captured variables. */
module VariableCapture {
  private import codeql.rust.internal.CachedStages
  private import codeql.dataflow.VariableCapture as SharedVariableCapture
  private import codeql.rust.controlflow.BasicBlocks as BasicBlocks

  private predicate closureFlowStep(Expr e1, Expr e2) {
    Stages::DataFlowStage::ref() and
    e1 = getALastEvalNode(e2)
    or
    exists(Ssa::Definition def |
      def.getARead() = e2 and
      def.getAnUltimateDefinition().(Ssa::WriteDefinition).assigns(e1)
    )
  }

  private module CaptureInput implements
    SharedVariableCapture::InputSig<Location, BasicBlocks::BasicBlock>
  {
    private import rust as Ast
    private import codeql.rust.elements.Variable as Variable

    Callable basicBlockGetEnclosingCallable(BasicBlocks::BasicBlock bb) { result = bb.getScope() }

    class CapturedVariable extends Variable {
      CapturedVariable() { this.isCaptured() }

      Callable getCallable() { result = this.getEnclosingCfgScope() }
    }

    final class CapturedParameter extends CapturedVariable {
      ParamBase p;

      CapturedParameter() { p = this.getParameter() }

      SourceParameterNode getParameterNode() { result.getParameter() = p }
    }

    class Expr extends AstNode {
      predicate hasCfgNode(BasicBlocks::BasicBlock bb, int i) { this = bb.getNode(i).getAstNode() }
    }

    class VariableWrite extends Expr {
      Expr source;
      CapturedVariable v;

      VariableWrite() {
        exists(AssignmentExpr assign, Variable::VariableWriteAccess write |
          this = assign and
          v = write.getVariable() and
          assign.getLhs() = write and
          assign.getRhs() = source
        )
        or
        this =
          any(LetStmt ls |
            v.getPat() = ls.getPat() and
            ls.getInitializer() = source
          )
        or
        this =
          any(LetExpr le |
            v.getPat() = le.getPat() and
            le.getScrutinee() = source
          )
      }

      CapturedVariable getVariable() { result = v }

      Expr getSource() { result = source }
    }

    class VariableRead extends Expr {
      CapturedVariable v;

      VariableRead() {
        exists(VariableAccess read | this = read and v = read.getVariable() |
          read instanceof VariableReadAccess
          or
          read = any(RefExpr re).getExpr()
        )
      }

      CapturedVariable getVariable() { result = v }
    }

    class ClosureExpr extends Expr {
      ClosureExpr() { lambdaCreationExpr(this) }

      predicate hasBody(Callable body) { body = this }

      predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
    }

    class Callable extends CfgScope {
      predicate isConstructor() { none() }
    }
  }

  class CapturedVariable = CaptureInput::CapturedVariable;

  module Flow = SharedVariableCapture::Flow<Location, BasicBlocks::Cfg, CaptureInput>;

  private Flow::ClosureNode asClosureNode(Node n) {
    result = n.(CaptureNode).getSynthesizedCaptureNode()
    or
    result.(Flow::ExprNode).getExpr() = n.asExpr()
    or
    result.(Flow::VariableWriteSourceNode).getVariableWrite().getSource() = n.asExpr()
    or
    result.(Flow::ExprPostUpdateNode).getExpr() = n.(PostUpdateNode).getPreUpdateNode().asExpr()
    or
    result.(Flow::ParameterNode).getParameter().getParameterNode() = n
    or
    result.(Flow::ThisParameterNode).getCallable() = n.(ClosureParameterNode).getCfgScope()
  }

  predicate storeStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::storeStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate readStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::readStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate localFlowStep(Node node1, Node node2) {
    Flow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
  }

  predicate clearsContent(Node node, CapturedVariableContent c) {
    Flow::clearsContent(asClosureNode(node), c.getVariable())
  }
}

import MakeImpl<Location, RustDataFlow>

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  cached
  newtype TDataFlowCall =
    TCall(Call call) {
      Stages::DataFlowStage::ref() and
      call.hasEnclosingCfgScope()
    } or
    TImplicitDerefCall(Expr e, DerefChain derefChain, int i, Function target) {
      TypeInference::implicitDerefChainBorrow(e, derefChain, _) and
      target = derefChain.getElement(i).getDerefFunction() and
      e.hasEnclosingCfgScope()
    } or
    TSummaryCall(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    ) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  cached
  newtype TDataFlowCallable =
    TCfgScope(CfgScope scope) or
    TSummarizedCallable(SummarizedCallable c)

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  cached
  newtype TParameterPositionImpl =
    TPositionalParameterPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
      or
      FlowSummaryImpl::ParsePositions::isParsedArgumentPosition(_, i)
      or
      FlowSummaryImpl::ParsePositions::isParsedParameterPosition(_, i)
    } or
    TClosureSelfParameterPosition() or
    TSelfParameterPosition()

  final class TParameterPosition = TParameterPositionImpl;

  cached
  newtype TReturnKind = TNormalReturnKind()

  cached
  newtype TContentSet =
    TSingletonContentSet(Content c) or
    TOptionalStep(string name) {
      name = any(FlowSummaryImpl::Private::AccessPathToken tok).getAnArgument("OptionalStep")
    } or
    TOptionalBarrier(string name) {
      name = any(FlowSummaryImpl::Private::AccessPathToken tok).getAnArgument("OptionalBarrier")
    }

  /** Holds if `n` is a flow source of kind `kind`. */
  cached
  predicate sourceNode(Node n, string kind) { n.(FlowSummaryNode).isSource(kind, _) }

  /** Holds if `n` is a flow sink of kind `kind`. */
  cached
  predicate sinkNode(Node n, string kind) { n.(FlowSummaryNode).isSink(kind, _) }

  /**
   * A step in a flow summary defined using `OptionalStep[name]`. An `OptionalStep` is "opt-in", which means
   * that by default the step is not present in the flow summary and needs to be explicitly enabled by defining
   * an additional flow step.
   */
  cached
  predicate optionalStep(Node node1, string name, Node node2) {
    FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(),
      TOptionalStep(name), node2.(FlowSummaryNode).getSummaryNode())
  }

  /**
   * A step in a flow summary defined using `OptionalBarrier[name]`. An `OptionalBarrier` is "opt-out", by default
   * data can flow freely through the step. Flow through the step can be explicity blocked by defining its node as a barrier.
   */
  cached
  predicate optionalBarrier(Node node, string name) {
    FlowSummaryImpl::Private::Steps::summaryReadStep(_, TOptionalBarrier(name),
      node.(FlowSummaryNode).getSummaryNode())
  }
}

import Cached
